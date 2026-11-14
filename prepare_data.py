"""Stratified 50,000 / 10,000 split of the official Fashion-MNIST training set.

Preprocessing statistics (a single mean and std over all pixels after /255)
are fitted on the 50,000 training images only. The test set is not touched.
Outputs: data/split.npz (train_idx, val_idx), data/preprocess.json
"""
import json
import os

import numpy as np

from common import DATA, SPLIT_SEED, load_raw

tr_x, tr_y, te_x, te_y = load_raw()
assert tr_x.shape == (60000, 28, 28) and te_x.shape == (10000, 28, 28)

rng = np.random.default_rng(SPLIT_SEED)
train_idx, val_idx = [], []
for c in range(10):
    idx = np.where(tr_y == c)[0]
    rng.shuffle(idx)
    val_idx.append(idx[:1000])        # 6,000 per class -> 1,000 val, 5,000 train
    train_idx.append(idx[1000:])
train_idx = np.sort(np.concatenate(train_idx))
val_idx = np.sort(np.concatenate(val_idx))
assert len(train_idx) == 50000 and len(val_idx) == 10000
assert len(np.intersect1d(train_idx, val_idx)) == 0

x = tr_x[train_idx].astype(np.float64) / 255.0
stats = {"mean": float(x.mean()), "std": float(x.std()),
         "fitted_on": "training split only (50,000 images)", "split_seed": SPLIT_SEED}
os.makedirs(DATA, exist_ok=True)
np.savez(os.path.join(DATA, "split.npz"), train_idx=train_idx, val_idx=val_idx)
with open(os.path.join(DATA, "preprocess.json"), "w") as f:
    json.dump(stats, f, indent=2)
np.savetxt(os.path.join(DATA, "train_idx.txt"), train_idx, fmt="%d")
np.savetxt(os.path.join(DATA, "val_idx.txt"), val_idx, fmt="%d")
print("train", len(train_idx), "val", len(val_idx), stats)
print("per-class train counts", np.bincount(tr_y[train_idx]))
print("per-class val counts", np.bincount(tr_y[val_idx]))
