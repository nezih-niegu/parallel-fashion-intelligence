"""Single-process response-time benchmark (one fresh process per repetition).

python bench.py --system {flat,hier} --backend {torch,custom} --threads T --run R
                [--kernel blocked|simd|simd_ilp|scalar] [--tag NAME]

Timing scope (end to end): from a host-resident uint8 request (numpy array) to labels
readable on the host: includes tensor wrapping, preprocessing, routing, packing,
specialist evaluation, label mapping and order restoration. Model loading and setup are
excluded and reported as cold-start cost. Clock: time.perf_counter_ns (monotonic).
Per batch size: 20 warm-up requests, then 1000 sequential requests at B=1, 100 at B=64
and B=256. A second, instrumented pass of 1000 B=1 requests records the per-stage
breakdown (compute-only vs overhead) without perturbing the main measurement.
"""
import argparse
import json
import os
import resource
import sys
import time

ap = argparse.ArgumentParser()
ap.add_argument("--system", choices=["flat", "hier"], required=True)
ap.add_argument("--backend", choices=["torch", "custom"], required=True)
ap.add_argument("--threads", type=int, default=1)
ap.add_argument("--kernel", default="blocked")
ap.add_argument("--run", type=int, default=0)
ap.add_argument("--tag", default="")
ap.add_argument("--device", default="cpu", help="torch backend only: cpu | cuda")
ap.add_argument("--binding", default="raw", choices=["raw", "ndpointer"])
ap.add_argument("--n1", type=int, default=1000)
ap.add_argument("--nb", type=int, default=100)
args = ap.parse_args()

T = args.threads
# thread counts are fixed before any OpenMP runtime starts (avoid oversubscription)
os.environ["OMP_NUM_THREADS"] = str(T)
os.environ["MKL_NUM_THREADS"] = str(T)
os.environ.setdefault("OMP_PROC_BIND", "close")
os.environ.setdefault("OMP_PLACES", "cores")

import numpy as np  # noqa: E402

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from common import RESULTS, bench_sequence, load_manifest, load_raw  # noqa: E402

rss0 = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
man = load_manifest()
_, _, te_x, te_y = load_raw()
seq = bench_sequence(te_x, te_y)
rng = np.random.default_rng(11)
batches = {B: [te_x[rng.choice(10000, B, replace=False)].copy() for _ in range(args.nb)]
           for B in (64, 256)}
singles = [te_x[i:i + 1].copy() for i in seq]

t_load0 = time.perf_counter_ns()
if args.backend == "torch":
    import torch
    torch.set_num_threads(T)
    from torch_models import TorchFlat, TorchHierarchy
    sysm = TorchFlat(man, args.device) if args.system == "flat" else TorchHierarchy(man, args.device)

    def predict(x, timings=None):
        y, g = sysm.predict(torch.from_numpy(x), timings)
        return y.numpy(), (None if g is None else g.numpy())
else:
    from custom_backend import KERNEL_NAMES, CustomBackend
    kid = {v: k for k, v in KERNEL_NAMES.items()}[args.kernel]
    cb = CustomBackend(man, threads=T, kernel=kid, binding=args.binding)
    predict = cb.flat_predict if args.system == "flat" else cb.hier_predict
cold_ns = time.perf_counter_ns() - t_load0
rss_loaded = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss

# first-request cost (part of cold start, reported separately)
t0 = time.perf_counter_ns(); predict(singles[0]); first_ns = time.perf_counter_ns() - t0
for i in range(20):
    predict(singles[i % len(singles)])

rows = []
clk = time.perf_counter_ns
preds1, groups1 = [], []
for i, x in enumerate(singles[:args.n1]):
    t0 = clk(); y, g = predict(x); t1 = clk()
    rows.append((1, i, t1 - t0))
    preds1.append(int(y[0])); groups1.append(-1 if g is None else int(g[0]))
for B in (64, 256):
    for i in range(5):
        predict(batches[B][i])
    for i, x in enumerate(batches[B]):
        t0 = clk(); predict(x); t1 = clk()
        rows.append((B, i, t1 - t0))
# instrumented pass: per-stage breakdown at B=1
stages = []
for x in singles[:args.n1]:
    tm = []
    t0 = clk(); predict(x, tm); t1 = clk()
    stages.append((t1 - t0,) + tuple(int(v) for v in tm[0]))
rss_end = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss

name = args.tag or f"{args.system}_{args.backend}" + ("_cuda" if args.device == "cuda" else "") + f"_T{T}" + ("" if args.backend == "torch" or args.kernel == "blocked" else f"_{args.kernel}") + ("_ndpointer" if args.binding == "ndpointer" else "")
outdir = os.path.join(RESULTS, "raw")
os.makedirs(outdir, exist_ok=True)
with open(os.path.join(outdir, f"{name}_run{args.run}.csv"), "w") as f:
    f.write("batch,request,latency_ns\n")
    f.writelines(f"{b},{i},{ns}\n" for b, i, ns in rows)
with open(os.path.join(outdir, f"{name}_run{args.run}_stages.csv"), "w") as f:
    f.write("total_ns,preprocess_ns,router_or_forward_ns,specialists_ns,pack_scatter_ns\n")
    f.writelines(",".join(map(str, s)) + "\n" for s in stages)
acc1 = float(np.mean(np.array(preds1) == te_y[seq[:args.n1]]))
meta = {"config": name, "system": args.system, "backend": args.backend, "threads": T,
        "kernel": args.kernel if args.backend == "custom" else "pytorch(MKL/oneDNN)", "binding": args.binding, "run": args.run,
        "cold_start_load_ns": cold_ns, "first_request_ns": first_ns,
        "maxrss_kb_before_load": rss0, "maxrss_kb_after_load": rss_loaded, "maxrss_kb_end": rss_end,
        "bench_seq_accuracy_B1": acc1,
        "route_freq_B1": (np.bincount(np.array(groups1), minlength=4) / len(groups1)).tolist() if args.system == "hier" else None,
        "env": {k: os.environ.get(k) for k in ["OMP_NUM_THREADS", "MKL_NUM_THREADS", "OMP_PROC_BIND", "OMP_PLACES"]},
        "affinity": sorted(os.sched_getaffinity(0)), "python": sys.version.split()[0]}
if args.backend == "torch":
    meta["torch"] = torch.__version__
    meta["torch_threads"] = torch.get_num_threads()
else:
    meta["scratch_bytes"] = int(cb.lib.pfi_scratch_bytes())
with open(os.path.join(outdir, f"{name}_run{args.run}_meta.json"), "w") as f:
    json.dump(meta, f, indent=1)
lat = np.array([r[2] for r in rows if r[0] == 1]) / 1e3
print(f"{name} run{args.run}: B1 median {np.median(lat):.1f}us p99 {np.percentile(lat, 99):.1f}us acc {acc1:.3f}")
