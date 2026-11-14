"""Kernel ablation on one substantial operation: the flat model's first layer
(784 -> 256, dense + bias + ReLU), the largest layer in the project (200,960 weights).

Variants (custom backend, timed inside C++ with steady_clock around each call):
  scalar_1T     auto-vectorization disabled, no parallel region
  simd_1T       omp simd dot product (teaching-grade kernel), no parallel region
  simd_ilp_1T   AVX-512 dot with 4 accumulators, no parallel region
  blocked_1T    AVX-512 register-blocked on Wt[I][O], no parallel region
  simd_omp_T    teaching-grade kernel + OpenMP collapse(2) with T threads
  blocked_omp_T blocked kernel + OpenMP tiles with T threads
Library GEMM reference: torch.nn.functional.linear + relu_ (MKL/oneDNN) with T threads,
timed with perf_counter_ns around the call (includes the Python dispatch cost).
One fresh process per repetition: python ablation_dense.py --run R --mode custom|torch
"""
import argparse
import os
import sys

ap = argparse.ArgumentParser()
ap.add_argument("--run", type=int, default=0)
ap.add_argument("--mode", choices=["custom", "torch"], required=True)
ap.add_argument("--threads", type=int, default=2)
args = ap.parse_args()
os.environ["OMP_PROC_BIND"] = "close"
os.environ["OMP_PLACES"] = "cores"
if args.mode == "torch":
    os.environ["OMP_NUM_THREADS"] = str(args.threads)
    os.environ["MKL_NUM_THREADS"] = str(args.threads)

import numpy as np  # noqa: E402

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from common import RESULTS, load_manifest, load_raw, preprocess_np  # noqa: E402

man = load_manifest()
_, _, te_x, _ = load_raw()
pp = man["preprocess"]
X_all = preprocess_np(te_x[:256], pp["mean"], pp["std"])
REPS = {1: 2000, 64: 300, 256: 100}
rows = []
out = os.path.join(RESULTS, "raw", f"ablation_{args.mode}" + (f"_T{args.threads}" if args.mode == "torch" else "") + f"_run{args.run}.csv")
os.makedirs(os.path.dirname(out), exist_ok=True)

if args.mode == "custom":
    from custom_backend import CustomBackend
    cb = CustomBackend(man, threads=1)
    variants = [("scalar_1T", 0, 0), ("simd_1T", 1, 0), ("simd_ilp_1T", 2, 0), ("blocked_1T", 3, 0)]
    variants += [(f"simd_omp_{t}T", 1, t) for t in (1, 2, 4)]
    variants += [(f"blocked_omp_{t}T", 3, t) for t in (1, 2, 4)]
    for B in (1, 64, 256):
        X = np.ascontiguousarray(X_all[:B])
        for name, k, t in variants:
            cb.bench_dense(k, t, X, "flat", 0, 50)  # warm-up (caches, thread pool)
            ns, _ = cb.bench_dense(k, t, X, "flat", 0, REPS[B])
            rows += [(name, B, i, int(v)) for i, v in enumerate(ns)]
else:
    import time
    import torch
    torch.set_num_threads(args.threads)
    from torch_models import load_model
    lin = load_model("flat", man).linears()[0]
    W, b = lin.weight, lin.bias
    for B in (1, 64, 256):
        X = torch.from_numpy(np.ascontiguousarray(X_all[:B]))
        with torch.inference_mode():
            for _ in range(50):
                torch.nn.functional.linear(X, W, b).relu_()
            for i in range(REPS[B]):
                t0 = time.perf_counter_ns()
                torch.nn.functional.linear(X, W, b).relu_()
                rows.append((f"torch_linear_{args.threads}T", B, i, time.perf_counter_ns() - t0))
with open(out, "w") as f:
    f.write("variant,batch,rep,ns\n")
    f.writelines(f"{a},{b},{c},{d}\n" for a, b, c, d in rows)
import collections
med = collections.defaultdict(list)
for a, b, c, d in rows:
    med[(a, b)].append(d)
for (a, b), v in sorted(med.items(), key=lambda x: (x[0][1], x[0][0])):
    print(f"{a:18s} B={b:3d} median {np.median(v) / 1e3:9.2f} us")
