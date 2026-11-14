"""Visual abstract for the README: both architectures (layer widths drawn to scale) and the
headline results, read from results/accuracy.json and results/summary.json.
Writes results/figures/visual_abstract.png and .svg."""
import json
import os

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402
import numpy as np  # noqa: E402
from matplotlib.patches import FancyBboxPatch, Polygon  # noqa: E402

from common import GROUPS, RESULTS  # noqa: E402

A = json.load(open(os.path.join(RESULTS, "accuracy.json")))
S = json.load(open(os.path.join(RESULTS, "summary.json")))
P = A["parameters"]
T = A["test"]
q = T["hierarchy"]["routing_fraction_q"]
lat = lambda c, B=1: S["latency"][c][str(B)]["p50"][0]

INK, INK2, MUTED, LINE, SURF, PANEL = "#0b0b0b", "#52514e", "#8a8984", "#d6d5cf", "#fcfcfb", "#f3f2ee"
C_FLAT, C_ROUTER = "#2a78d6", "#eb6834"
C_SPEC = ["#1baf7a", "#eda100", "#6250d6"]
C_BAG = "#8a8984"

fig = plt.figure(figsize=(14, 7.7))
fig.patch.set_facecolor(SURF)
ax = fig.add_axes([0, 0, 1, 1])
ax.set_xlim(0, 140); ax.set_ylim(5, 82); ax.axis("off")


def h_of(n):          # bar height scales with sqrt(width): 784 -> 11.2 units, 2 -> ~0.7
    return 0.4 * np.sqrt(n)


def mlp(x0, yc, dims, color, gap=4.2, w=1.6, label_dims=True, first_is_input=True):
    """Draw layers as bars (height ~ sqrt(width)) joined by translucent fans. Returns right x."""
    xs = []
    for i, d in enumerate(dims):
        x = x0 + i * gap
        h = h_of(d)
        inp = i == 0 and first_is_input
        fc = PANEL if inp else color
        ax.add_patch(FancyBboxPatch((x, yc - h / 2), w, h, boxstyle="round,pad=0,rounding_size=0.5",
                                    fc=fc, ec=color if inp else "none", lw=1.2, zorder=3))
        if i > 0:
            hp, xp = h_of(dims[i - 1]), xs[-1]
            ax.add_patch(Polygon([(xp + w, yc - hp / 2), (x, yc - h / 2), (x, yc + h / 2), (xp + w, yc + hp / 2)],
                                 closed=True, fc=color, alpha=0.13, ec="none", zorder=2))
        if label_dims:
            ax.text(x + w / 2, yc - h / 2 - 1.0, str(d), ha="center", va="top", fontsize=7.5, color=INK2)
        xs.append(x)
    return xs[-1] + w


def chip(x, y, txt, color, fs=8):
    ax.text(x, y, txt, fontsize=fs, color="white", weight="bold", va="center", ha="left",
            bbox=dict(boxstyle="round,pad=0.35,rounding_size=0.6", fc=color, ec="none"))


def card(x, y, w, h):
    ax.add_patch(FancyBboxPatch((x, y), w, h, boxstyle="round,pad=0,rounding_size=1.5", fc="white", ec=LINE, lw=1))


# ------------------------------------------------------------------ title
ax.text(2, 79.2, "Hierarchical vs flat inference on Fashion-MNIST", fontsize=17, weight="bold", color=INK, va="center")
ax.text(2, 75.6, "Same frozen FP32 checkpoints in PyTorch and in a custom OpenMP + AVX-512 C++ backend · "
        "2-core Xeon, batch 1, 1 thread, median of 5 × 1,000 requests", fontsize=9.5, color=INK2, va="center")

# ------------------------------------------------------------------ input
card(2, 8, 13, 63)
ax.text(8.5, 67.5, "Input", fontsize=10, weight="bold", color=INK, ha="center")
from common import load_raw  # noqa: E402
_, _, te_x, _ = load_raw()
ax.imshow(255 - te_x[0], cmap="gray", extent=(4, 13, 52, 61), zorder=4, interpolation="nearest")
ax.text(8.5, 49.5, "28×28 uint8\n→ (x/255 − μ)/σ\n→ 784 floats", fontsize=8, color=INK2, ha="center", va="top", linespacing=1.4)
ax.text(8.5, 36, "μ, σ fitted on the\n50k training split", fontsize=7.5, color=MUTED, ha="center", va="top", linespacing=1.4)
ax.text(8.5, 25, "Bar height ∝ √width\nof each layer;\nspecialists reuse the\nsame 784 inputs", fontsize=7.5, color=MUTED, ha="center", va="top", linespacing=1.4, style="italic")

# ------------------------------------------------------------------ flat reference
card(17, 48, 76, 23)
ax.text(19, 67.8, "A · Flat reference MLP", fontsize=11, weight="bold", color=C_FLAT)
ax.text(19, 64.6, f"10 classes · {P['flat']:,} params · {P['storage_bytes_fp32']['flat'] / 1e6:.2f} MB FP32",
        fontsize=8.3, color=INK2)
xr = mlp(22, 56.5, P["dims"]["flat"], C_FLAT, gap=7)
ax.annotate("", xy=(xr + 4, 56.5), xytext=(xr + 0.6, 56.5), arrowprops=dict(arrowstyle="-|>", color=INK2))
ax.text(xr + 5, 58.0, "argmax → label", fontsize=8.3, color=INK, va="center")
ax.text(xr + 5, 55.0, "Linear → ReLU → Linear\n→ ReLU → Linear", fontsize=7.3, color=MUTED, va="center", linespacing=1.3)
ax.text(91, 67.8, f"Test acc {T['flat']['accuracy'] * 100:.2f}%", fontsize=9, color=INK, ha="right", weight="bold")

# ------------------------------------------------------------------ hierarchy
card(17, 8, 76, 38)
ax.text(19, 42.8, "B · Hierarchy: router + specialists (hard routing)", fontsize=11, weight="bold", color=C_ROUTER)
ax.text(19, 39.6, f"{P['P_total_hierarchy']:,} params total · E[active] = {P['E_P_active_test_routes']:,.0f} "
        f"({P['E_P_active_test_routes'] / P['flat'] * 100:.0f}% of A) · every specialist smaller than A",
        fontsize=8.3, color=INK2)
ax.text(91, 42.8, f"Test acc {T['hierarchy']['accuracy'] * 100:.2f}%", fontsize=9, color=INK, ha="right", weight="bold")
yR = 23
xr = mlp(20, yR, P["dims"]["router"], C_ROUTER, gap=4.6)
ax.text(20, 35.6, f"Router\n{P['router']:,} params", fontsize=8, color=C_ROUTER, weight="bold", va="top", linespacing=1.3)
ax.text(20, 10.6, f"group acc {T['hierarchy']['router_accuracy'] * 100:.2f}%", fontsize=7.5, color=INK2)
# branches
names = ["Upper-body", "Lower/full-body", "Footwear", "Bag"]
ys = [32.5, 25.5, 18.5, 11.8]
fork_x = xr + 1.0
for g, (gname, cls) in enumerate(GROUPS):
    yb = ys[g]
    ax.plot([fork_x, fork_x + 2.5, fork_x + 2.5, fork_x + 9.5], [yR, yR, yb, yb], color=MUTED, lw=1, zorder=1)
    ax.text(fork_x + 6.0, yb + 0.7, f"{q[g] * 100:.0f}%", fontsize=7, color=MUTED, ha="center", va="bottom")
    if len(cls) > 1:
        col = C_SPEC[g]
        dims = P["dims"][f"spec{g}"]
        x_end = mlp(fork_x + 9.5, yb, dims[1:], col, gap=3.6, w=1.3, label_dims=False, first_is_input=False)
        ax.text(x_end + 1.2, yb + 0.9, f"{names[g]}  {'-'.join(map(str, dims))}", fontsize=8, color=col, weight="bold", va="center")
        ax.text(x_end + 1.2, yb - 1.4, f"{P['specialists'][gname]:,} params · labels {{{','.join(map(str, cls))}}}"
                f" · oracle {T['hierarchy']['oracle_specialist_accuracy'][gname] * 100:.1f}%",
                fontsize=7.2, color=INK2, va="center")
    else:
        ax.add_patch(FancyBboxPatch((fork_x + 9.5, yb - 1.1), 8.6, 2.2, boxstyle="round,pad=0,rounding_size=0.6",
                                    fc=PANEL, ec=C_BAG, lw=1, ls="--"))
        ax.text(fork_x + 13.8, yb, "no model", fontsize=7, color=C_BAG, ha="center", va="center")
        ax.text(fork_x + 19.2, yb, f"Bag (singleton): router decides → label {cls[0]}", fontsize=8, color=INK2, va="center")

# ------------------------------------------------------------------ results panel
card(95, 8, 43, 63)
ax.text(97, 67.8, "Batch-1 response time (median, 1 thread)", fontsize=10.5, weight="bold", color=INK)
rows = [("A · PyTorch", lat("flat_torch_T1"), C_FLAT, False), ("B · PyTorch", lat("hier_torch_T1"), C_ROUTER, False),
        ("A · custom C++", lat("flat_custom_T1"), C_FLAT, True), ("B · custom C++", lat("hier_custom_T1"), C_ROUTER, True)]
vmax = max(r[1] for r in rows)
for i, (lab, v, col, solid) in enumerate(rows):
    y = 62 - i * 4.6
    ax.text(97, y, lab, fontsize=8.5, color=INK, va="center")
    wbar = 22 * v / vmax
    ax.add_patch(FancyBboxPatch((109, y - 1.2), wbar, 2.4, boxstyle="round,pad=0,rounding_size=0.5",
                                fc=col if solid else "white", ec=col, lw=1.4, hatch=None if solid else "////"))
    ax.text(109 + wbar + 0.8, y, f"{v:.1f} µs", fontsize=8.5, color=INK, va="center")
sp = S["speedups"]
stats = [
    (f"{sp['S_backend|hier|T1|B1']['50']['ratio']:.1f}×", "custom C++ vs matched PyTorch\nhierarchy, batch 1"),
    (f"{sp['S_system|custom|T1|B256']['50']['ratio']:.2f}×", "B faster than A at batch 256\n(custom C++, 1 thread)"),
    (f"{S['ablation']['cmp scalar_1T->blocked_omp_2T|B256']['ratio']:.0f}×", "scalar → AVX-512 blocked + 2 threads\n(784→256 layer, batch 256)"),
    (f"{S['mpi']['S_throughput|custom|P2']['S']:.2f}×", "MPI throughput at 2 ranks;\nsingle-request latency never improves"),
]
for i, (big, small) in enumerate(stats):
    y = 43 - i * 7.2
    ax.text(97, y, big, fontsize=17, weight="bold", color=INK, va="center")
    ax.text(111, y, small, fontsize=8, color=INK2, va="center", linespacing=1.35)
ax.text(97, 13.6, "Every ratio above clears its 95% bootstrap CI\nand run-to-run variation. "
        "Batch-1 B vs A: no measurable\nchange (runs overlap). GPU (CUDA + cuDNN): compiled,\nnot run (no GPU on this host).",
        fontsize=7.3, color=MUTED, va="center", linespacing=1.45)

os.makedirs(os.path.join(RESULTS, "figures"), exist_ok=True)
for ext in ("png", "svg"):
    fig.savefig(os.path.join(RESULTS, "figures", f"visual_abstract.{ext}"), dpi=170, facecolor=SURF)
print("ok")
