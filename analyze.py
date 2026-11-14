"""Statistics over the raw per-request data -> results/summary.json + results/tables.md

Every percentile and every speedup ratio gets a 95% bootstrap CI: requests are resampled
with replacement *within each of the 5 runs* (stratified by run, each run a fresh
process), the runs are pooled, and the statistic is recomputed (2,000 resamples).
For a ratio A/B, A and B are resampled independently in each iteration. A speedup is
claimed only when its CI excludes 1; otherwise it is reported as "no measurable change".
For MPI throughput (one makespan per run) the 5 makespans themselves are resampled.
"""
import glob
import json
import os
import re

import numpy as np

from common import RESULTS

RAW = os.path.join(RESULTS, "raw")
NB = 2000
rng = np.random.default_rng(2038)
PCTS = (50, 95, 99)


def load_runs(prefix, batch=None, col="latency_ns", pattern=None):
    files = sorted(glob.glob(os.path.join(RAW, f"{prefix}_run[0-9].csv")))
    runs = []
    for f in files:
        a = np.genfromtxt(f, delimiter=",", names=True)
        if batch is not None:
            a = a[a["batch"] == batch]
        runs.append(a[col].astype(np.float64) / 1e3)   # microseconds
    return runs


def boot_pcts(runs, pcts=PCTS):
    """returns {p: (point, lo, hi)} and the bootstrap matrix (NB x len(pcts))."""
    pooled = np.concatenate(runs)
    point = np.percentile(pooled, pcts)
    samples = []
    for r in runs:
        idx = rng.integers(0, len(r), size=(NB, len(r)))
        samples.append(r[idx])
    S = np.concatenate(samples, axis=1)
    B = np.percentile(S, pcts, axis=1).T                # NB x len(pcts)
    out = {p: (float(point[i]), float(np.percentile(B[:, i], 2.5)), float(np.percentile(B[:, i], 97.5)))
           for i, p in enumerate(pcts)}
    return out, B


RUNS = {}   # key -> list of per-run arrays, filled as configs are loaded


def ratio(Ba, Bb, pa, pb, ka=None, kb=None):
    """A/B with CI from independent bootstrap matrices (columns aligned on pcts).
    Claim rule: CI must exclude 1 AND the 5 per-run statistics of A and B must not
    overlap (difference larger than run-to-run variation); otherwise the verdict is
    'no measurable change' (CI includes 1) or 'within run-to-run variation'."""
    R = Ba / Bb
    res = {}
    for i, p in enumerate(PCTS):
        lo, hi = np.percentile(R[:, i], [2.5, 97.5])
        pt = pa[p][0] / pb[p][0]
        sep = None
        if ka in RUNS and kb in RUNS:
            ra = [np.percentile(r, p) for r in RUNS[ka]]
            rb = [np.percentile(r, p) for r in RUNS[kb]]
            sep = bool(min(ra) > max(rb) or max(ra) < min(rb))
        if lo > 1 or hi < 1:
            v = ("faster" if lo > 1 else "slower") if sep in (None, True) else "within run-to-run variation"
        else:
            v = "no measurable change"
        res[p] = {"ratio": float(pt), "lo": float(lo), "hi": float(hi), "runs_separated": sep, "verdict": v}
    return res


def fmt_ci(t, d=1):
    return f"{t[0]:.{d}f} [{t[1]:.{d}f}, {t[2]:.{d}f}]"


def fmt_r(r):
    return f"{r['ratio']:.2f}x [{r['lo']:.2f}, {r['hi']:.2f}]"


summary = {"latency": {}, "speedups": {}, "breakdown": {}, "memory": {}, "cold": {}, "ablation": {},
           "kernel_system": {}, "mpi": {}, "thread_scaling": {}, "run_to_run": {}}
md = []
boot = {}

# ---------------------------------------------------------------- single-node configs
configs = sorted({re.sub(r"_run\d\.csv$", "", os.path.basename(f)) for f in glob.glob(os.path.join(RAW, "*_run[0-9].csv"))
                  if os.path.basename(f).startswith(("flat_", "hier_"))})
for c in configs:
    summary["latency"][c] = {}
    for B in (1, 64, 256):
        runs = load_runs(c, B)
        if not runs:
            continue
        pc, Bm = boot_pcts(runs)
        boot[(c, B)] = (pc, Bm)
        RUNS[(c, B)] = runs
        med_runs = [float(np.median(r)) for r in runs]
        summary["latency"][c][B] = {"p50": pc[50], "p95": pc[95], "p99": pc[99], "n_runs": len(runs),
                                    "n_per_run": len(runs[0]), "per_run_median": med_runs,
                                    "throughput_img_s_at_median": B / (pc[50][0] / 1e6)}
    # breakdown (B=1 instrumented pass)
    st = sorted(glob.glob(os.path.join(RAW, f"{c}_run[0-9]_stages.csv")))
    if st:
        a = np.concatenate([np.genfromtxt(f, delimiter=",", names=True) for f in st])
        tot = a["total_ns"] / 1e3
        parts = {k: float(np.median(a[k] / 1e3)) for k in a.dtype.names}
        inlib = (a["preprocess_ns"] + a["router_or_forward_ns"] + a["specialists_ns"] + a["pack_scatter_ns"]) / 1e3
        parts["outside_stages_median_us"] = float(np.median(tot - inlib))
        parts["compute_only_median_us"] = float(np.median((a["router_or_forward_ns"] + a["specialists_ns"]) / 1e3))
        summary["breakdown"][c] = parts
    metas = [json.load(open(f)) for f in sorted(glob.glob(os.path.join(RAW, f"{c}_run[0-9]_meta.json")))]
    if metas:
        summary["memory"][c] = {"rss_load_delta_kb": float(np.median([m["maxrss_kb_after_load"] - m["maxrss_kb_before_load"] for m in metas])),
                                "rss_infer_delta_kb": float(np.median([m["maxrss_kb_end"] - m["maxrss_kb_after_load"] for m in metas])),
                                "maxrss_kb_end": float(np.median([m["maxrss_kb_end"] for m in metas])),
                                "scratch_bytes": metas[0].get("scratch_bytes")}
        summary["cold"][c] = {"load_ms": float(np.median([m["cold_start_load_ns"] for m in metas]) / 1e6),
                              "first_request_us": float(np.median([m["first_request_ns"] for m in metas]) / 1e3),
                              "bench_seq_accuracy_B1": metas[0]["bench_seq_accuracy_B1"],
                              "route_freq_B1": metas[0].get("route_freq_B1"), "env": metas[0]["env"],
                              "affinity": metas[0]["affinity"]}

# matched speedups
for T in (1, 2, 4):
    for B in (1, 64, 256):
        for s in ("flat", "hier"):
            a, b = f"{s}_torch_T{T}", f"{s}_custom_T{T}"
            if (a, B) in boot and (b, B) in boot:
                summary["speedups"][f"S_backend|{s}|T{T}|B{B}"] = ratio(boot[(a, B)][1], boot[(b, B)][1], boot[(a, B)][0], boot[(b, B)][0], (a, B), (b, B))
        for be in ("torch", "custom"):
            a, b = f"flat_{be}_T{T}", f"hier_{be}_T{T}"
            if (a, B) in boot and (b, B) in boot:
                summary["speedups"][f"S_system|{be}|T{T}|B{B}"] = ratio(boot[(a, B)][1], boot[(b, B)][1], boot[(a, B)][0], boot[(b, B)][0], (a, B), (b, B))
# end-to-end custom hierarchy vs flat PyTorch (overall design + implementation)
for T in (1, 2):
    for B in (1, 64, 256):
        a, b = f"flat_torch_T{T}", f"hier_custom_T{T}"
        summary["speedups"][f"S_overall(flat torch / hier custom)|T{T}|B{B}"] = ratio(
            boot[(a, B)][1], boot[(b, B)][1], boot[(a, B)][0], boot[(b, B)][0], (a, B), (b, B))
# thread scaling L(T=1)/L(T)
for s in ("flat", "hier"):
    for be in ("torch", "custom"):
        for T in (2, 4):
            for B in (1, 64, 256):
                a, b = f"{s}_{be}_T1", f"{s}_{be}_T{T}"
                summary["thread_scaling"][f"{s}|{be}|T{T}|B{B}"] = ratio(boot[(a, B)][1], boot[(b, B)][1], boot[(a, B)][0], boot[(b, B)][0], (a, B), (b, B))
# kernel ablation at system level (custom, T=1)
for s in ("flat", "hier"):
    base = f"{s}_custom_T1_scalar"
    for k in ("scalar", "simd", "simd_ilp", ""):
        c = f"{s}_custom_T1" + (f"_{k}" if k else "")
        for B in (1, 64, 256):
            if (c, B) in boot:
                summary["kernel_system"][f"{s}|{k or 'blocked'}|B{B}"] = {
                    "p50": boot[(c, B)][0][50], "vs_scalar": ratio(boot[(base, B)][1], boot[(c, B)][1], boot[(base, B)][0], boot[(c, B)][0], (base, B), (c, B))[50]}

# --------------------------------------------------------------------- dense ablation
FLOP = {B: 2 * B * 784 * 256 for B in (1, 64, 256)}
BYTES_W = 784 * 256 * 4
abl = {}
for f in sorted(glob.glob(os.path.join(RAW, "ablation_*_run[0-9].csv"))):
    a = np.genfromtxt(f, delimiter=",", names=True, dtype=None, encoding=None)
    for v in np.unique(a["variant"]):
        for B in (1, 64, 256):
            m = (a["variant"] == v) & (a["batch"] == B)
            abl.setdefault((str(v), B), []).append(a["ns"][m].astype(np.float64) / 1e3)
ab_boot = {}
for (v, B), runs in abl.items():
    pc, Bm = boot_pcts(runs)
    ab_boot[(v, B)] = (pc, Bm)
    RUNS[("abl", v, B)] = runs
    summary["ablation"][f"{v}|B{B}"] = {"p50": pc[50], "p95": pc[95], "p99": pc[99],
                                       "gflops_at_median": FLOP[B] / (pc[50][0] * 1e3),
                                       "weight_stream_GBs_at_median": BYTES_W / (pc[50][0] * 1e3)}
steps = ["scalar_1T", "simd_1T", "simd_ilp_1T", "blocked_1T", "blocked_omp_2T"]
for B in (1, 64, 256):
    for i in range(1, len(steps)):
        a, b = steps[i - 1], steps[i]
        summary["ablation"][f"step {a}->{b}|B{B}"] = ratio(ab_boot[(a, B)][1], ab_boot[(b, B)][1], ab_boot[(a, B)][0], ab_boot[(b, B)][0], ("abl", a, B), ("abl", b, B))[50]
    for a, b in [("simd_omp_1T", "simd_omp_2T"), ("blocked_omp_1T", "blocked_omp_2T"), ("blocked_omp_2T", "blocked_omp_4T"),
                 ("simd_1T", "simd_omp_1T"), ("blocked_1T", "blocked_omp_1T"),
                 ("torch_linear_1T", "blocked_1T"), ("torch_linear_2T", "blocked_omp_2T"), ("scalar_1T", "blocked_omp_2T")]:
        if (a, B) in ab_boot and (b, B) in ab_boot:
            summary["ablation"][f"cmp {a}->{b}|B{B}"] = ratio(ab_boot[(a, B)][1], ab_boot[(b, B)][1], ab_boot[(a, B)][0], ab_boot[(b, B)][0], ("abl", a, B), ("abl", b, B))[50]

# ------------------------------------------------------------------------------- MPI
mpi_boot = {}
for be in ("custom", "torch"):
    for P in (1, 2, 3, 4):
        pre = f"mpi_bench_{be}_P{P}"
        for B in (1, 64, 256):
            runs = load_runs(pre, B)
            if not runs:
                continue
            pc, Bm = boot_pcts(runs)
            mpi_boot[(be, P, B)] = (pc, Bm)
            RUNS[("mpi", be, P, B)] = runs
            files = sorted(glob.glob(os.path.join(RAW, f"{pre}_run[0-9].csv")))
            parts = np.concatenate([np.genfromtxt(f, delimiter=",", names=True) for f in files])
            parts = parts[parts["batch"] == B]
            summary["mpi"][f"latency|{be}|P{P}|B{B}"] = {
                "p50": pc[50], "p95": pc[95], "p99": pc[99],
                "rank0_breakdown_median_us": {k: float(np.median(parts[k]) / 1e3) for k in
                                              ("pre_ns", "route_ns", "pack_send_ns", "local_exec_ns", "wait_recv_ns")}}
        metas = [json.load(open(f)) for f in sorted(glob.glob(os.path.join(RAW, f"{pre}_run[0-9]_meta.json")))]
        if metas:
            per_rank = {}
            for r in range(P):
                per_rank[r] = {k: float(np.median([m["ranks"][r][k] for m in metas])) for k in
                               ("comm_ns", "exec_ns", "idle_ns", "msgs_sent", "msgs_recv", "bytes_sent")}
                per_rank[r]["affinity"] = metas[0]["ranks"][r]["affinity"]
                per_rank[r]["models"] = metas[0]["ranks"][r]["models"]
            summary["mpi"][f"ranks|{be}|P{P}"] = per_rank
            summary["mpi"][f"accuracy|{be}|P{P}"] = metas[0]["accuracy_B1"]
        tp = [json.load(open(f)) for f in sorted(glob.glob(os.path.join(RAW, f"mpi_throughput_{be}_P{P}_run[0-9]_meta.json")))]
        if tp:
            mk = np.array([t["makespan_ns"] for t in tp]) / 1e6
            summary["mpi"][f"throughput|{be}|P{P}"] = {
                "makespan_ms_runs": mk.tolist(), "makespan_ms_median": float(np.median(mk)),
                "img_per_s_median": float(np.median([t["throughput_img_per_s"] for t in tp])),
                "service_latency_ms_median": float(np.median([t["latency_ns_median"] for t in tp]) / 1e6),
                "queue_wait_ms_median": float(np.median([t["queue_wait_ns_median"] for t in tp]) / 1e6),
                "window": tp[0]["window"], "batch": tp[0]["batch"], "requests": tp[0]["requests"],
                "arrival": tp[0]["arrival"], "ranks": {r: {k: float(np.median([t["ranks"][r][k] for t in tp])) for k in
                                                           ("comm_ns", "exec_ns", "idle_ns")} for r in range(P)}}
    for P in (2, 3, 4):
        for B in (1, 64, 256):
            if (be, 1, B) in mpi_boot and (be, P, B) in mpi_boot:
                summary["mpi"][f"S_L|{be}|P{P}|B{B}"] = ratio(mpi_boot[(be, 1, B)][1], mpi_boot[(be, P, B)][1],
                                                              mpi_boot[(be, 1, B)][0], mpi_boot[(be, P, B)][0],
                                                              ("mpi", be, 1, B), ("mpi", be, P, B))
        k1, kp = f"throughput|{be}|P1", f"throughput|{be}|P{P}"
        if k1 in summary["mpi"] and kp in summary["mpi"]:
            m1 = np.array(summary["mpi"][k1]["makespan_ms_runs"]); mp = np.array(summary["mpi"][kp]["makespan_ms_runs"])
            b1 = np.median(m1[rng.integers(0, len(m1), (NB, len(m1)))], axis=1)
            bp = np.median(mp[rng.integers(0, len(mp), (NB, len(mp)))], axis=1)
            S = np.median(m1) / np.median(mp)
            lo, hi = np.percentile(b1 / bp, [2.5, 97.5])
            summary["mpi"][f"S_throughput|{be}|P{P}"] = {"S": float(S), "lo": float(lo), "hi": float(hi), "E": float(S / P),
                                                        "verdict": "faster" if lo > 1 else ("slower" if hi < 1 else "no measurable change")}
for P in (1, 2, 3, 4):
    for B in (1, 64, 256):
        if ("torch", P, B) in mpi_boot and ("custom", P, B) in mpi_boot:
            summary["mpi"][f"S_backend|P{P}|B{B}"] = ratio(mpi_boot[("torch", P, B)][1], mpi_boot[("custom", P, B)][1],
                                                           mpi_boot[("torch", P, B)][0], mpi_boot[("custom", P, B)][0],
                                                           ("mpi", "torch", P, B), ("mpi", "custom", P, B))

# convert int keys for json
def clean(o):
    if isinstance(o, dict):
        return {str(k): clean(v) for k, v in o.items()}
    if isinstance(o, (list, tuple)):
        return [clean(v) for v in o]
    return o


with open(os.path.join(RESULTS, "summary.json"), "w") as f:
    json.dump(clean(summary), f, indent=1)

# ------------------------------------------------------------------------- markdown
md.append("## End-to-end response time (us), median / p95 / p99 with 95% bootstrap CI\n")
md.append("| config | B | p50 | p95 | p99 | img/s at p50 |\n|---|---|---|---|---|---|")
for c in configs:
    for B, v in summary["latency"][c].items():
        md.append(f"| {c} | {B} | {fmt_ci(v['p50'])} | {fmt_ci(v['p95'])} | {fmt_ci(v['p99'])} | {v['throughput_img_s_at_median']:.0f} |")
md.append("\n## Speedups (ratio of the statistic, 95% CI)\n")
md.append("| comparison | p50 | p95 | p99 |\n|---|---|---|---|")
for k, v in summary["speedups"].items():
    md.append(f"| {k} | {fmt_r(v[50])} {v[50]['verdict']} | {fmt_r(v[95])} | {fmt_r(v[99])} |")
md.append("\n## Thread scaling L(T=1)/L(T)\n")
md.append("| config | p50 | verdict |\n|---|---|---|")
for k, v in summary["thread_scaling"].items():
    md.append(f"| {k} | {fmt_r(v[50])} | {v[50]['verdict']} |")
md.append("\n## Dense-kernel ablation (784->256 + bias + ReLU)\n")
md.append("| variant | B | p50 us [CI] | p99 us | GFLOP/s | weight GB/s |\n|---|---|---|---|---|---|")
for k, v in summary["ablation"].items():
    if "p50" in v:
        md.append(f"| {k.split('|')[0]} | {k.split('|')[1]} | {fmt_ci(v['p50'], 2)} | {v['p99'][0]:.2f} | {v['gflops_at_median']:.1f} | {v['weight_stream_GBs_at_median']:.1f} |")
md.append("\n| step | p50 speedup |\n|---|---|")
for k, v in summary["ablation"].items():
    if "ratio" in v:
        md.append(f"| {k} | {fmt_r(v)} {v['verdict']} |")
md.append("\n## Kernel choice at system level (custom, 1 thread)\n")
for k, v in summary["kernel_system"].items():
    md.append(f"- {k}: p50 {fmt_ci(v['p50'])} us, vs scalar {fmt_r(v['vs_scalar'])}")
md.append("\n## Stage breakdown at B=1 (median us)\n")
for k, v in summary["breakdown"].items():
    md.append(f"- {k}: " + ", ".join(f"{kk}={vv:.1f}" for kk, vv in v.items()))
md.append("\n## MPI\n")
for k, v in summary["mpi"].items():
    if k.startswith("latency"):
        md.append(f"- {k}: p50 {fmt_ci(v['p50'])}, p99 {fmt_ci(v['p99'])}; rank0 " +
                  ", ".join(f"{a}={b:.1f}" for a, b in v["rank0_breakdown_median_us"].items()))
    elif k.startswith(("S_L", "S_backend")):
        md.append(f"- {k}: p50 {fmt_r(v[50])} {v[50]['verdict']}; p99 {fmt_r(v[99])}")
    elif k.startswith("S_throughput"):
        md.append(f"- {k}: S={v['S']:.2f} [{v['lo']:.2f}, {v['hi']:.2f}] E={v['E']:.2f} {v['verdict']}")
    elif k.startswith("throughput"):
        md.append(f"- {k}: makespan {v['makespan_ms_median']:.2f} ms, {v['img_per_s_median']:.0f} img/s, "
                  f"service p50 {v['service_latency_ms_median']:.3f} ms, queue p50 {v['queue_wait_ms_median']:.2f} ms")
    elif k.startswith("ranks"):
        md.append(f"- {k}: " + "; ".join(f"r{r}: comm {d['comm_ns']/1e6:.1f} ms exec {d['exec_ns']/1e6:.1f} ms idle {d['idle_ns']/1e6:.1f} ms msgs {d['msgs_sent']:.0f}"
                                         for r, d in v.items()))
with open(os.path.join(RESULTS, "tables.md"), "w") as f:
    f.write("\n".join(md) + "\n")
print("\n".join(md[:60]))
