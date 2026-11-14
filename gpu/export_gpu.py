"""Export frozen weights + test data for the CUDA/cuDNN driver (gpu_bench).

Writes gpu/data/{test_u8.bin,test_labels.i32,ref_hier.i32,seq.i32} and gpu/gpu_config.txt.
Run evaluate.py first (it writes results/test_pred_torch_hier.npy, the reference).
"""
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.dirname(HERE))
from common import CKPT, GROUPS, RESULTS, bench_sequence, load_manifest, load_raw  # noqa: E402

man = load_manifest()
_, _, te_x, te_y = load_raw()
d = os.path.join(HERE, "data")
os.makedirs(d, exist_ok=True)
te_x.astype(np.uint8).tofile(os.path.join(d, "test_u8.bin"))
te_y.astype(np.int32).tofile(os.path.join(d, "test_labels.i32"))
np.load(os.path.join(RESULTS, "test_pred_torch_hier.npy")).astype(np.int32).tofile(os.path.join(d, "ref_hier.i32"))
bench_sequence(te_x, te_y).astype(np.int32).tofile(os.path.join(d, "seq.i32"))
lines = [f"{man['preprocess']['mean']:.9g} {man['preprocess']['std']:.9g}"]
for name, m in man["models"].items():
    lines.append(f"model {name} {os.path.join(CKPT, m['bin'])} {len(m['dims'])} " + " ".join(map(str, m["dims"])))
for g, (_, cls) in enumerate(GROUPS):
    lines.append(f"group {g} {int(len(cls) > 1)} {len(cls)} " + " ".join(map(str, cls)))
lines.append(f"test {os.path.join(d, 'test_u8.bin')} {os.path.join(d, 'test_labels.i32')} {len(te_y)}")
lines.append(f"ref {os.path.join(d, 'ref_hier.i32')}")
lines.append(f"seq {os.path.join(d, 'seq.i32')}")
open(os.path.join(HERE, "gpu_config.txt"), "w").write("\n".join(lines) + "\n")
print("\n".join(lines))
