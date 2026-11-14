"""Live demo: classify a few test images with every CPU backend and show route, label, time.

Times here are illustrative only: PyTorch and the custom library share one process (two OpenMP
runtimes); every reported number comes from bench.py, which runs each backend in its own process.

python3 demo.py [n_images]          (MPI demo: mpirun -np 2 python3 mpi_hier.py --backend custom --mode test)
"""
import sys
import time

import numpy as np
import torch

from common import CLASS_NAMES, GROUPS, load_manifest, load_raw
from custom_backend import CustomBackend
from torch_models import TorchFlat, TorchHierarchy

torch.set_num_threads(1)
n = int(sys.argv[1]) if len(sys.argv) > 1 else 8
man = load_manifest()
_, _, te_x, te_y = load_raw()
idx = np.random.default_rng(int(time.time())).choice(10000, n, replace=False)
cb = CustomBackend(man, threads=1)
tf, th = TorchFlat(man), TorchHierarchy(man)
print(f"{'id':>5} {'truth':12s} {'route':16s} {'custom hier':12s} {'us':>6} {'torch hier':12s} {'us':>6} {'torch flat':12s} {'us':>6}")
for i in idx:
    x = te_x[i:i + 1].copy()
    for _ in range(3):                       # warm caches / allocators for every backend
        cb.hier_predict(x); th.predict(torch.from_numpy(x)); tf.predict(torch.from_numpy(x))
    t0 = time.perf_counter_ns(); yc, g = cb.hier_predict(x); t1 = time.perf_counter_ns()
    yt, _ = th.predict(torch.from_numpy(x)); t2 = time.perf_counter_ns()
    yf, _ = tf.predict(torch.from_numpy(x)); t3 = time.perf_counter_ns()
    ok = "ok" if yc[0] == te_y[i] else "WRONG"
    print(f"{i:5d} {CLASS_NAMES[te_y[i]]:12s} {GROUPS[g[0]][0]:16s} {CLASS_NAMES[yc[0]]:12s} {(t1 - t0) / 1e3:6.1f} "
          f"{CLASS_NAMES[int(yt[0])]:12s} {(t2 - t1) / 1e3:6.1f} {CLASS_NAMES[int(yf[0])]:12s} {(t3 - t2) / 1e3:6.1f}  {ok}")
