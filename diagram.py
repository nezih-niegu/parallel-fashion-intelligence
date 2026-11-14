"""Tagged block diagram of the implemented system -> results/figures/fig0_system_diagram.png"""
import os

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402
from matplotlib.patches import FancyBboxPatch  # noqa: E402

from common import RESULTS  # noqa: E402

TAG = {"SIMD": "#2a78d6", "OpenMP": "#1baf7a", "CUDA": "#eda100", "cuDNN": "#e87ba4", "MPI": "#6250d6",
       "PyTorch": "#eb6834"}
INK, INK2, BOX, LANE = "#0b0b0b", "#52514e", "#ffffff", "#f3f2ee"
fig, ax = plt.subplots(figsize=(13, 7.6))
ax.set_xlim(0, 130); ax.set_ylim(0, 76); ax.axis("off")
fig.patch.set_facecolor("#fcfcfb")


def box(x, y, w, h, title, sub="", tags=(), dashed=False, fc=BOX):
    ax.add_patch(FancyBboxPatch((x, y), w, h, boxstyle="round,pad=0.25,rounding_size=1.2", fc=fc,
                                ec=INK2, lw=1.0, ls="--" if dashed else "-"))
    ax.text(x + 1, y + h - 1.6, title, fontsize=8.6, weight="bold", color=INK, va="top")
    if sub:
        ax.text(x + 1, y + h - 4.4, sub, fontsize=7.2, color=INK2, va="top", linespacing=1.35)
    tx = x + 1
    for t in tags:
        wt = 0.95 * len(t) + 1.6
        ax.add_patch(FancyBboxPatch((tx, y + 0.8), wt, 2.3, boxstyle="round,pad=0.1,rounding_size=0.8",
                                    fc=TAG[t], ec="none"))
        ax.text(tx + wt / 2, y + 1.95, t.upper(), fontsize=5.6, color="white", weight="bold", ha="center", va="center")
        tx += wt + 0.8


def arrow(x0, y0, x1, y1, txt=""):
    ax.annotate("", xy=(x1, y1), xytext=(x0, y0), arrowprops=dict(arrowstyle="-|>", color=INK2, lw=1.1))
    if txt:
        ax.text((x0 + x1) / 2, (y0 + y1) / 2 + 0.8, txt, fontsize=6.8, color=INK2, ha="center")


lanes = [(64, 10, "REQUEST"), (47, 16, "COORDINATOR\nrank 0"), (37, 9.5, "COMMUNI-\nCATION"),
         (19, 18, "SPECIALISTS\nranks 1-3"), (2, 16, "KERNELS")]
for y, h, name in lanes:
    ax.add_patch(FancyBboxPatch((0.5, y), 101, h, boxstyle="round,pad=0,rounding_size=1", fc=LANE, ec="none"))
    ax.text(1.5, y + h / 2, name, fontsize=7.5, weight="bold", color=INK2, va="center")

box(13, 64.6, 20, 9, "1 Request", "id + 28×28 uint8 image\n(host-resident)")
box(78, 64.6, 22, 9, "8 Response", "global labels in input order,\nhost-readable on rank 0")
ax.text(55, 72.5, "response time L_i timed on rank 0's clock only", fontsize=7.5, color=INK2, ha="center", style="italic")
box(13, 48, 15.5, 14, "2 Preprocess", "(x/255 - μ)/σ\nμ, σ from train split", ["OpenMP", "SIMD"])
box(30, 48, 19, 14, "3 Router 784-64-4", "AVX-512 blocked dense\nfused bias+ReLU, argmax\n50,500 params", ["SIMD", "OpenMP"])
box(51, 48, 19, 14, "4 Pack by group", "stable counting sort of ids\nzero-copy if one group\n(always at batch 1)", ["OpenMP"])
box(72, 48, 13, 14, "Bag (singleton)", "no model:\nrouter decides\nlabel 8")
box(87, 48, 13, 14, "7 Restore", "scatter labels\nby sample id\n(order kept)", ["OpenMP"])
box(13, 38, 87, 7.4, "5 MPI point-to-point", "", ["MPI"])
ax.text(36, 43.6, "Bcast config + model map at start · one Isend per NON-EMPTY group: [slot, group, n, ids…] + n×784 floats",
        fontsize=6.8, color=INK2, va="center")
ax.text(36, 40.6, "reply [slot, g, n, ids, labels] · STOP sentinel to every worker · Barrier + gather of per-rank metrics at end",
        fontsize=6.8, color=INK2, va="center")
box(13, 20, 27, 16, "6 Upper-body 784-128-64-4", "rank 1 · 4 classes · 108,996 params\nlocal → global {0,2,4,6}", ["SIMD", "OpenMP"])
box(43, 20, 27, 16, "6 Lower/full 784-32-2", "rank 2 · 2 classes · 25,186 params\nlocal → global {1,3}", ["SIMD", "OpenMP"])
box(73, 20, 27, 16, "6 Footwear 784-64-32-3", "rank 3 · 3 classes · 52,419 params\nlocal → global {5,7,9}", ["SIMD", "OpenMP"])
box(13, 3, 27, 14, "Dense kernel (CPU)", "Wt[I][O], 4 samples × 64 outputs in\n16 zmm accumulators, broadcast x,\nfused bias+ReLU; tiles over threads", ["SIMD", "OpenMP"])
box(43, 3, 27, 14, "One parallel region / request", "layers separated by omp-for barrier\n(the layer dependency); no library\nthreads; 1 thread per MPI rank", ["OpenMP"])
box(73, 3, 27, 14, "GPU path (compiled, not run here)", "cuDNN 1×1-conv dense + fused bias/ReLU,\ncustom preprocess, route_pack,\nbias_argmax_scatter kernels", ["CUDA", "cuDNN"], dashed=True)
for x0, x1 in [(28.3, 29.7), (49.3, 50.7), (70.3, 71.7), (85.3, 86.7)]:
    arrow(x0, 55, x1, 55)
arrow(23, 64.7, 20, 62.4); arrow(93, 62.4, 89, 64.7)
arrow(60, 47.7, 60, 45.7, ""); arrow(26, 37.7, 26, 36.3); arrow(56, 37.7, 56, 36.3); arrow(86, 37.7, 86, 36.3)
arrow(95, 45.7, 95, 47.7)
# right panel: offline / setup / baselines
box(104, 52, 25, 21, "OFFLINE (untimed)", "stratified 50k/10k split, seed 2038\nAdam, 30 epochs, pick on val\nfreeze → .pt + raw FP32 .bin\nsame checkpoints for every\nbackend", ["PyTorch"])
box(104, 29, 25, 20, "SETUP = cold start", "load weights + transposed copy,\nallocate scratch for B ≤ 256,\npin threads (OMP_PROC_BIND)\ncuDNN plans per (layer, N)", ["OpenMP", "cuDNN"])
box(104, 4, 25, 23, "BASELINES (timed)", "flat MLP 784-256-128-10\n(235,146 params) in PyTorch;\nmatched PyTorch hierarchy;\nboth also under the same MPI\norchestration (mpi4py)", ["PyTorch", "MPI"])
ax.text(0.5, 75.5, "Implemented system: hierarchical Fashion-MNIST inference (tags mark where each stack runs)",
        fontsize=11, weight="bold", color=INK)
os.makedirs(os.path.join(RESULTS, "figures"), exist_ok=True)
fig.savefig(os.path.join(RESULTS, "figures", "fig0_system_diagram.png"), dpi=170, bbox_inches="tight")
print("ok")
