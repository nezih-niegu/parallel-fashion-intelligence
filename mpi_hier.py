"""Distributed hierarchical inference with MPI (mpi4py), identical orchestration for
both backends (torch | custom) so that distributed comparisons are matched.

mpirun -np P python3 mpi_hier.py --backend custom|torch --mode bench|test|throughput --run R

Layout: rank 0 = coordinator (preprocess, router, pack, singleton group, gather/restore).
Specialists are assigned to ranks by a model map broadcast from rank 0:
  P=1: all on rank 0 | P=2: all three on rank 1 | P=3: Upper -> 1, Lower+Footwear -> 2
  P=4: Upper -> 1, Lower -> 2, Footwear -> 3
Protocol (point-to-point, one message per non-empty group each way):
  request  : float32 buffer, first (3+n) words reinterpreted as int32
             [slot, group, n, id_0..id_{n-1}] followed by n*784 preprocessed floats
  reply    : int32 [slot, group, n, ids..., global_labels...]
  shutdown : empty message with TAG_STOP to every worker.
Empty groups are never sent, so empty batches cannot deadlock; afterwards all ranks call
the same collectives (Barrier, gather) in the same order. Timing: each request is timed
on rank 0's clock only (perf_counter_ns), from the host-resident uint8 batch until
labels are restored in input order on rank 0. Timestamps of different ranks are never
subtracted; per-rank comm / exec / idle totals are measured locally and gathered.
"""
import argparse
import json
import os
import sys
import time

ap = argparse.ArgumentParser()
ap.add_argument("--backend", choices=["torch", "custom"], required=True)
ap.add_argument("--mode", choices=["bench", "test", "throughput"], default="bench")
ap.add_argument("--threads", type=int, default=1)
ap.add_argument("--run", type=int, default=0)
ap.add_argument("--window", type=int, default=4)
ap.add_argument("--n1", type=int, default=1000)
ap.add_argument("--nb", type=int, default=100)
args = ap.parse_args()
os.environ["OMP_NUM_THREADS"] = str(args.threads)
os.environ["MKL_NUM_THREADS"] = str(args.threads)

import numpy as np  # noqa: E402
from mpi4py import MPI  # noqa: E402

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from common import GROUPS, RESULTS, bench_sequence, load_manifest, load_raw  # noqa: E402

comm = MPI.COMM_WORLD
rank, P = comm.Get_rank(), comm.Get_size()
TAG_REQ, TAG_REP, TAG_STOP = 1, 2, 3
MAXB = 256
G = len(GROUPS)
SINGLETON = [len(c) == 1 for _, c in GROUPS]

# ---------------- configuration and model map (Bcast from rank 0) ----------------
cfg = None
if rank == 0:
    layouts = {1: {0: 0, 1: 0, 2: 0}, 2: {0: 1, 1: 1, 2: 1}, 3: {0: 1, 1: 2, 2: 2}, 4: {0: 1, 1: 2, 2: 3}}
    gmap = layouts[min(P, 4)]
    cfg = {"backend": args.backend, "threads": args.threads, "group_rank": {g: gmap.get(g, 0) for g in range(G)},
           "manifest": load_manifest()}
    for g in range(G):
        if SINGLETON[g]:
            cfg["group_rank"][g] = 0
cfg = comm.bcast(cfg, root=0)
grank = cfg["group_rank"]
man = cfg["manifest"]
mine = [g for g in range(G) if grank[g] == rank and not SINGLETON[g]]


# ---------------- backend adapter: same interface for both backends ----------------
class TorchAdapter:
    def __init__(self):
        import torch
        torch.set_num_threads(args.threads)
        from torch_models import TorchHierarchy
        self.torch = torch
        self.h = TorchHierarchy(man)          # loads router + all specialists (kept loaded)
        if rank != 0:
            self.h.router = None
            self.h.spec = {g: m for g, m in self.h.spec.items() if g in mine}

    def preprocess(self, x):
        return self.h.preprocess(self.torch.from_numpy(x)).numpy()

    def route(self, X):
        with self.torch.inference_mode():
            return self.h.route(self.torch.from_numpy(X)).numpy().astype(np.int32)

    def spec_predict(self, g, X):
        with self.torch.inference_mode():
            return self.h.run_group(g, self.torch.from_numpy(X)).numpy().astype(np.int32)


class CustomAdapter:
    def __init__(self):
        from custom_backend import CustomBackend
        self.cb = CustomBackend(man, threads=args.threads)

    def preprocess(self, x):
        return self.cb.preprocess(x)

    def route(self, X):
        return self.cb.route(X)

    def spec_predict(self, g, X):
        return self.cb.spec_predict(g, X)


t_load = time.perf_counter_ns()
be = TorchAdapter() if args.backend == "torch" else CustomAdapter()
load_ns = time.perf_counter_ns() - t_load
clk = time.perf_counter_ns
acc = {"comm_ns": 0, "exec_ns": 0, "idle_ns": 0, "msgs_sent": 0, "msgs_recv": 0, "bytes_sent": 0}


# ---------------- worker loop ----------------
def worker():
    buf = np.empty(3 + MAXB + MAXB * 784, dtype=np.float32)
    st = MPI.Status()
    while True:
        t0 = clk()
        comm.Probe(source=0, tag=MPI.ANY_TAG, status=st)       # waiting for work = idle
        t1 = clk()
        acc["idle_ns"] += t1 - t0
        if st.Get_tag() == TAG_STOP:
            comm.Recv([buf, 0, MPI.FLOAT], source=0, tag=TAG_STOP)
            break
        cnt = st.Get_count(MPI.FLOAT)
        comm.Recv([buf, cnt, MPI.FLOAT], source=0, tag=TAG_REQ)
        t2 = clk()
        hdr = buf.view(np.int32)
        slot, g, n = int(hdr[0]), int(hdr[1]), int(hdr[2])
        ids = hdr[3:3 + n].copy()
        X = buf[3 + n: 3 + n + n * 784].reshape(n, 784)
        lab = be.spec_predict(g, X)
        t3 = clk()
        rep = np.concatenate([np.array([slot, g, n], np.int32), ids, lab.astype(np.int32)])
        comm.Send([rep, MPI.INT], dest=0, tag=TAG_REP)
        t4 = clk()
        acc["comm_ns"] += (t2 - t1) + (t4 - t3)
        acc["exec_ns"] += t3 - t2
        acc["msgs_sent"] += 1; acc["msgs_recv"] += 1; acc["bytes_sent"] += rep.nbytes


# ---------------- coordinator ----------------
class Coordinator:
    def __init__(self, window=1):
        self.window = window
        self.sendbufs = [[np.empty(3 + MAXB + MAXB * 784, np.float32) for _ in range(G)] for _ in range(window)]
        self.repbuf = np.empty(3 + 2 * MAXB, np.int32)
        self.pending = {}
        self.stage = None

    def dispatch(self, slot, x):
        """preprocess + route + pack + send; returns state for completion."""
        t0 = clk()
        X = be.preprocess(x)
        t1 = clk()
        g = be.route(X)
        t2 = clk()
        B = len(g)
        out = np.full(B, -1, dtype=np.int32)
        reqs, expect = [], 0
        local = []
        texec = 0
        tcomm = 0
        for gi in range(G):
            ids = np.nonzero(g == gi)[0].astype(np.int32)
            n = len(ids)
            if n == 0:
                continue
            if SINGLETON[gi]:
                out[ids] = GROUPS[gi][1][0]
                continue
            if grank[gi] == 0:
                local.append((gi, ids))
                continue
            sb = self.sendbufs[slot][gi]
            hv = sb.view(np.int32)
            hv[0], hv[1], hv[2] = slot, gi, n
            hv[3:3 + n] = ids
            sb[3 + n: 3 + n + n * 784] = X[ids].reshape(-1)
            ts = clk()
            reqs.append(comm.Isend([sb, 3 + n + n * 784, MPI.FLOAT], dest=grank[gi], tag=TAG_REQ))
            tcomm += clk() - ts
            acc["msgs_sent"] += 1; acc["bytes_sent"] += 4 * (3 + n + n * 784)
            expect += 1
        for gi, ids in local:                              # P=1: specialists on rank 0
            ts = clk()
            out[ids] = be.spec_predict(gi, np.ascontiguousarray(X[ids]))
            texec += clk() - ts
        t3 = clk()
        acc["exec_ns"] += (t2 - t1) + texec
        self.pending[slot] = {"out": out, "expect": expect, "reqs": reqs}
        return {"pre": t1 - t0, "route": t2 - t1, "pack_send": (t3 - t2) - texec, "local_exec": texec}

    def recv_one(self):
        st = MPI.Status()
        t0 = clk()
        comm.Recv([self.repbuf, MPI.INT], source=MPI.ANY_SOURCE, tag=TAG_REP, status=st)
        t1 = clk()
        acc["msgs_recv"] += 1
        slot, gi, n = int(self.repbuf[0]), int(self.repbuf[1]), int(self.repbuf[2])
        p = self.pending[slot]
        p["out"][self.repbuf[3:3 + n]] = self.repbuf[3 + n: 3 + 2 * n]   # restore order by id
        p["expect"] -= 1
        return slot, t1 - t0

    def finish(self, slot):
        p = self.pending[slot]
        wait = 0
        while p["expect"] > 0:
            s, w = self.recv_one()
            wait += w
        MPI.Request.Waitall(p["reqs"])
        del self.pending[slot]
        return p["out"], wait

    def predict(self, x):
        st = self.dispatch(0, x)
        out, wait = self.finish(0)
        acc["comm_ns"] += wait
        st["wait_recv"] = wait
        return out, st


def stop_workers():
    for r in range(1, P):
        comm.Send([np.empty(0, np.float32), 0, MPI.FLOAT], dest=r, tag=TAG_STOP)


def main():
    info = {"rank": rank, "host": MPI.Get_processor_name(), "affinity": sorted(os.sched_getaffinity(0)),
            "threads": args.threads, "models": mine, "load_ns": load_ns}
    result = None
    if rank == 0:
        _, _, te_x, te_y = load_raw()
        co = Coordinator(window=max(1, args.window))
        if args.mode == "test":
            result = run_test(co, te_x)
        elif args.mode == "bench":
            result = run_bench(co, te_x, te_y)
        else:
            result = run_throughput(co, te_x)
        stop_workers()
    else:
        worker()
    comm.Barrier()
    info.update(acc)
    allinfo = comm.gather(info, root=0)
    if rank == 0:
        result["ranks"] = allinfo
        result["P"] = P
        result["backend"] = args.backend
        result["group_rank"] = grank
        os.makedirs(os.path.join(RESULTS, "raw"), exist_ok=True)
        tag = f"mpi_{args.mode}_{args.backend}_P{P}_run{args.run}"
        rows = result.pop("rows", None)
        if rows is not None:
            with open(os.path.join(RESULTS, "raw", tag + ".csv"), "w") as f:
                f.write("batch,request,latency_ns,pre_ns,route_ns,pack_send_ns,local_exec_ns,wait_recv_ns\n")
                f.writelines(",".join(map(str, r)) + "\n" for r in rows)
        with open(os.path.join(RESULTS, "raw", tag + "_meta.json"), "w") as f:
            json.dump(result, f, indent=1)
        print(tag, {k: v for k, v in result.items() if k not in ("ranks",)})


def run_bench(co, te_x, te_y):
    seq = bench_sequence(te_x, te_y)
    rng = np.random.default_rng(11)
    batches = {B: [te_x[rng.choice(10000, B, replace=False)].copy() for _ in range(args.nb)] for B in (64, 256)}
    singles = [te_x[i:i + 1].copy() for i in seq[:args.n1]]
    for i in range(20):
        co.predict(singles[i])
    for k in acc:
        acc[k] = 0                               # rank-0 metrics only over timed requests
    rows = []
    preds = []
    for i, x in enumerate(singles):
        t0 = clk(); y, st = co.predict(x); t1 = clk()
        rows.append((1, i, t1 - t0, st["pre"], st["route"], st["pack_send"], st["local_exec"], st["wait_recv"]))
        preds.append(int(y[0]))
    for B in (64, 256):
        for i in range(5):
            co.predict(batches[B][i])
        for i, x in enumerate(batches[B]):
            t0 = clk(); y, st = co.predict(x); t1 = clk()
            rows.append((B, i, t1 - t0, st["pre"], st["route"], st["pack_send"], st["local_exec"], st["wait_recv"]))
    return {"rows": rows, "accuracy_B1": float(np.mean(np.array(preds) == te_y[seq[:args.n1]]))}


def run_throughput(co, te_x):
    """Concurrent requests: closed loop, window W outstanding batches of 64, back-to-back
    arrivals (all requests available at t=0). Reports makespan, throughput, queueing."""
    rng = np.random.default_rng(12)
    B, NREQ, W = 64, args.nb, co.window
    reqs = [te_x[rng.choice(10000, B, replace=False)].copy() for _ in range(NREQ)]
    for i in range(5):
        co.predict(reqs[i])
    for k in acc:
        acc[k] = 0
    t_start = clk()
    issued, done = 0, 0
    slot_of, t_issue, lat, queue = {}, {}, [], []
    free = list(range(W))
    while done < NREQ:
        while issued < NREQ and free:
            s = free.pop()
            t_issue[s] = clk()
            queue.append(t_issue[s] - t_start)       # all requests arrive at t_start
            co.dispatch(s, reqs[issued])
            slot_of[s] = issued
            issued += 1
        # complete any slot with nothing outstanding (all-local or singleton-only batches)
        ready = [s for s, p in co.pending.items() if p["expect"] == 0]
        if not ready:
            s, w = co.recv_one()
            acc["comm_ns"] += w
            if co.pending[s]["expect"] == 0:
                ready = [s]
        for s in ready:
            MPI.Request.Waitall(co.pending[s]["reqs"])
            del co.pending[s]
            lat.append(clk() - t_issue[s])
            done += 1
            free.append(s)
    makespan = clk() - t_start
    return {"batch": B, "requests": NREQ, "window": W, "arrival": "closed-loop, all queued at t=0",
            "makespan_ns": makespan, "throughput_img_per_s": NREQ * B / (makespan / 1e9),
            "latency_ns_median": float(np.median(lat)), "latency_ns_p95": float(np.percentile(lat, 95)),
            "latency_scope": "dispatch start -> labels restored on rank 0 (service time)",
            "queue_wait_ns_median": float(np.median(queue)), "queue_wait_ns_mean": float(np.mean(queue))}


def run_test(co, te_x):
    """Correctness under MPI: random batch sizes incl. 0 and 1; each id exactly once, in order."""
    rng = np.random.default_rng(5)
    sizes = [0, 1, 2, 3, 0, 255, 256, 17, 1, 64, 0, 5]
    while sum(sizes) < 10000:
        sizes.append(int(rng.integers(0, 257)))
    pos, preds, ok_once = 0, [], True
    for s in sizes:
        s = min(s, 10000 - pos)
        x = te_x[pos:pos + s].copy()
        y, _ = co.predict(x)
        ok_once &= bool(len(y) == s and np.all(y >= 0))   # every slot filled exactly once
        preds.append(y)
        pos += s
        if pos >= 10000:
            break
    preds = np.concatenate(preds)
    ref = np.load(os.path.join(RESULTS, "test_pred_torch_hier.npy"))
    return {"n_requests": len(sizes), "batch_sizes_include_0": True, "all_filled_once": ok_once,
            "n_returned": int(len(preds)), "mismatch_vs_torch_hierarchy": int(np.sum(preds != ref)),
            "in_order": bool(len(preds) == 10000 and np.sum(preds != ref) == 0)}


if __name__ == "__main__":
    main()
