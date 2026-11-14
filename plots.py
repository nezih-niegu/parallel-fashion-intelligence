"""Figures from results/summary.json, results/raw/*.csv and results/training_log.json."""
import glob
import json
import os

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402
import numpy as np  # noqa: E402

from common import RESULTS  # noqa: E402

FIG = os.path.join(RESULTS, "figures")
os.makedirs(FIG, exist_ok=True)
S = json.load(open(os.path.join(RESULTS, "summary.json")))
C = ["#2a78d6", "#eb6834", "#1baf7a", "#eda100", "#e87ba4", "#6250d6"]
INK, INK2, GRID = "#0b0b0b", "#52514e", "#e4e3df"
plt.rcParams.update({"font.size": 9, "axes.edgecolor": INK2, "axes.labelcolor": INK, "xtick.color": INK2,
                     "ytick.color": INK2, "axes.spines.top": False, "axes.spines.right": False,
                     "axes.grid": True, "grid.color": GRID, "grid.linewidth": 0.6, "axes.axisbelow": True,
                     "figure.facecolor": "#fcfcfb", "axes.facecolor": "#fcfcfb", "legend.frameon": False})
MAIN = [("flat_torch", "Flat MLP · PyTorch"), ("hier_torch", "Hierarchy · PyTorch"),
        ("flat_custom", "Flat MLP · custom C++"), ("hier_custom", "Hierarchy · custom C++")]


def save(fig, name):
    fig.savefig(os.path.join(FIG, name), dpi=170, bbox_inches="tight")
    plt.close(fig)


# 1. ECDF of batch-1 response time (T=1)
fig, ax = plt.subplots(figsize=(6.4, 3.4))
for i, (k, lab) in enumerate(MAIN):
    runs = [np.genfromtxt(f, delimiter=",", names=True) for f in sorted(glob.glob(os.path.join(RESULTS, "raw", f"{k}_T1_run[0-9].csv")))]
    x = np.sort(np.concatenate([r["latency_ns"][r["batch"] == 1] for r in runs]) / 1e3)
    ax.plot(x, np.arange(1, len(x) + 1) / len(x), color=C[i], lw=2, label=lab)
ax.set_xscale("log")
ax.set_xlabel("End-to-end response time at batch 1 (µs, log scale)")
ax.set_ylabel("Fraction of requests")
ax.set_title("Batch-1 response time distribution, 1 thread (5 runs × 1,000 requests)", loc="left", fontsize=10)
ax.legend(loc="lower right")
save(fig, "fig1_latency_ecdf_b1.png")

# 2. p50 latency vs thread count, small multiples per batch size
fig, axs = plt.subplots(1, 3, figsize=(10, 3.2))
for j, B in enumerate((1, 64, 256)):
    ax = axs[j]
    w = 0.2
    for i, (k, lab) in enumerate(MAIN):
        vals = [S["latency"][f"{k}_T{T}"][str(B)]["p50"] for T in (1, 2, 4)]
        p = np.array([v[0] for v in vals]); lo = p - [v[1] for v in vals]; hi = np.array([v[2] for v in vals]) - p
        ax.bar(np.arange(3) + (i - 1.5) * w, p, w * 0.9, color=C[i], label=lab, yerr=[lo, hi], ecolor=INK2, capsize=1.5)
    ax.set_xticks(range(3)); ax.set_xticklabels(["1 thread", "2 threads", "4 threads\n(oversubscribed)"])
    ax.set_title(f"Batch {B}", loc="left", fontsize=10)
    ax.set_ylabel("Median response time (µs)" if j == 0 else "")
axs[0].legend(loc="upper left", fontsize=7.5)
fig.suptitle("Median end-to-end response time (95% bootstrap CI) on the 2-core host", x=0.01, y=1.06, ha="left", fontsize=10)
save(fig, "fig2_latency_threads.png")

# 3. Dense-kernel ablation
order = ["scalar_1T", "simd_1T", "simd_ilp_1T", "blocked_1T", "simd_omp_2T", "blocked_omp_2T", "blocked_omp_4T",
         "torch_linear_1T", "torch_linear_2T"]
labels = ["Scalar, 1T", "omp simd (1 acc), 1T", "AVX-512, 4 acc (ILP), 1T", "AVX-512 blocked, 1T",
          "omp simd + OpenMP, 2T", "Blocked + OpenMP, 2T", "Blocked + OpenMP, 4T", "PyTorch/MKL linear, 1T", "PyTorch/MKL linear, 2T"]
fig, axs = plt.subplots(1, 3, figsize=(10.5, 3.6), sharey=True)
for j, B in enumerate((1, 64, 256)):
    ax = axs[j]
    v = [S["ablation"][f"{o}|B{B}"]["p50"] for o in order]
    p = np.array([x[0] for x in v])
    cols = [C[0] if "torch" not in o else C[1] for o in order]
    ax.barh(range(len(order)), p, color=cols, xerr=[p - [x[1] for x in v], np.array([x[2] for x in v]) - p], ecolor=INK2)
    for y, val in enumerate(p):
        ax.text(val * 1.08, y, f"{val:.1f}" if val < 100 else f"{val:.0f}", va="center", fontsize=7, color=INK2)
    ax.set_xscale("log")
    ax.set_title(f"Batch {B}", loc="left", fontsize=10)
    ax.set_xlabel("Median time per call (µs, log)")
    ax.set_xlim(right=p.max() * 4)
axs[0].set_yticks(range(len(order))); axs[0].set_yticklabels(labels); axs[0].invert_yaxis()
fig.suptitle("Kernel ablation: dense 784→256 + bias + ReLU (custom in blue, library GEMM in orange)", x=0.01, y=1.06, ha="left", fontsize=10)
save(fig, "fig3_kernel_ablation.png")

# 4. Stage breakdown at B=1
cfgs = [("flat_torch_T1", "Flat · PyTorch"), ("hier_torch_T1", "Hierarchy · PyTorch"),
        ("flat_custom_T1_ndpointer", "Flat · custom (ndpointer binding)"), ("flat_custom_T1", "Flat · custom (raw binding)"),
        ("hier_custom_T1_ndpointer", "Hierarchy · custom (ndpointer binding)"), ("hier_custom_T1", "Hierarchy · custom (raw binding)")]
parts = [("preprocess_ns", "Preprocess"), ("router_or_forward_ns", "Router / flat forward"),
         ("specialists_ns", "Specialist"), ("pack_scatter_ns", "Pack + label map + scatter"),
         ("outside_stages_median_us", "Python call / binding / wrap")]
fig, ax = plt.subplots(figsize=(7.5, 3.2))
for y, (c, lab) in enumerate(cfgs):
    b = S["breakdown"][c]
    left = 0
    for i, (k, pl) in enumerate(parts):
        ax.barh(y, b[k], left=left, color=C[i], label=pl if y == 0 else None, edgecolor="#fcfcfb", linewidth=1)
        left += b[k]
    ax.text(left + 1.5, y, f"{left:.0f} µs", va="center", fontsize=8, color=INK2)
ax.set_yticks(range(len(cfgs))); ax.set_yticklabels([l for _, l in cfgs]); ax.invert_yaxis()
ax.set_xlabel("Median time per stage at batch 1, 1 thread (µs)")
ax.legend(ncol=3, loc="upper center", bbox_to_anchor=(0.45, -0.22), fontsize=7.5)
ax.set_title("Where batch-1 response time goes (instrumented pass, medians)", loc="left", fontsize=10)
save(fig, "fig4_stage_breakdown.png")

# 5. MPI latency and throughput vs ranks
fig, axs = plt.subplots(1, 2, figsize=(9, 3.2))
for i, be in enumerate(("torch", "custom")):
    lab = "PyTorch backend" if be == "torch" else "Custom backend"
    P = [1, 2, 3, 4]
    v = [S["mpi"][f"latency|{be}|P{p}|B1"]["p50"] for p in P]
    p = np.array([x[0] for x in v])
    axs[0].errorbar(P, p, yerr=[p - [x[1] for x in v], np.array([x[2] for x in v]) - p], color=C[i], lw=2, marker="o", ms=5, label=lab, capsize=2)
    t = [S["mpi"][f"throughput|{be}|P{p}"]["img_per_s_median"] / 1e3 for p in P]
    axs[1].plot(P, t, color=C[i], lw=2, marker="o", ms=5, label=lab)
for ax in axs:
    ax.set_xticks([1, 2, 3, 4]); ax.set_xticklabels(["1", "2", "3*", "4*"]); ax.set_xlabel("MPI ranks (* = more ranks than cores)")
    ax.axvspan(2.5, 4.5, color=GRID, alpha=0.5, lw=0)
axs[0].set_ylabel("Median response time, batch 1 (µs)"); axs[0].set_ylim(bottom=0)
axs[1].set_ylabel("Throughput (thousand images/s)"); axs[1].set_ylim(bottom=0)
axs[0].set_title("Single-request latency (critical path)", loc="left", fontsize=10)
axs[1].set_title("Pipelined throughput, window 4, batch 64", loc="left", fontsize=10)
axs[0].legend(loc="upper left")
save(fig, "fig5_mpi_scaling.png")

# 6. Training curves (selected models; evidence of proper training only)
log = json.load(open(os.path.join(RESULTS, "training_log.json")))
fig, ax = plt.subplots(figsize=(6.4, 3.2))
names = {"flat": "Flat MLP (10 classes)", "router": "Router (4 groups)", "spec0": "Upper-body specialist",
         "spec1": "Lower/full-body specialist", "spec2": "Footwear specialist"}
for i, (k, lab) in enumerate(names.items()):
    r = next(x for x in log[k] if x["selected"])
    ax.plot([c["epoch"] for c in r["curve"]], [c["val_acc"] for c in r["curve"]], color=C[i], lw=2, label=lab)
    ax.plot(r["best_epoch"], r["best_val_acc"], "o", color=C[i], ms=6, mec="#fcfcfb", mew=2)
ax.set_xlabel("Epoch"); ax.set_ylabel("Validation accuracy")
ax.set_title("Validation accuracy during training (dot = selected checkpoint)", loc="left", fontsize=10)
ax.legend(fontsize=7.5, loc="lower right")
save(fig, "fig6_training_curves.png")
print(sorted(os.listdir(FIG)))
