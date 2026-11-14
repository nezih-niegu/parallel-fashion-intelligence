"""Shared definitions: dataset I/O, split, hierarchy, and model architectures.

Every script imports from here so that the flat reference, the matched PyTorch
hierarchy, and the custom backends all agree on the same constants.
"""
import gzip
import json
import os

import numpy as np

ROOT = os.path.dirname(os.path.abspath(__file__))
DATA_RAW = os.path.join(ROOT, "data", "raw")
DATA = os.path.join(ROOT, "data")
CKPT = os.path.join(ROOT, "checkpoints")
RESULTS = os.path.join(ROOT, "results")

SPLIT_SEED = 2038          # stratified 50k/10k split of the official training set
TRAIN_SEED = 6             # torch / numpy seed for training
BENCH_SEED = 7             # shared benchmark input sequence

CLASS_NAMES = ["T-shirt/top", "Trouser", "Pullover", "Dress", "Coat",
               "Sandal", "Shirt", "Sneaker", "Bag", "Ankle boot"]

# Disjoint groups covering all ten classes (the partition proposed in the brief).
GROUPS = [
    ("Upper-body", [0, 2, 4, 6]),
    ("Lower/full-body", [1, 3]),
    ("Footwear", [5, 7, 9]),
    ("Accessories", [8]),          # singleton -> no specialist
]
NUM_GROUPS = len(GROUPS)
CLASS_TO_GROUP = np.zeros(10, dtype=np.int64)
CLASS_TO_LOCAL = np.zeros(10, dtype=np.int64)
for g, (_, cls) in enumerate(GROUPS):
    for k, c in enumerate(cls):
        CLASS_TO_GROUP[c] = g
        CLASS_TO_LOCAL[c] = k

# Model architectures (MLP layer widths, input 784). Chosen in train.py on
# validation data from the candidates listed there; these are the frozen picks.
FLAT_DIMS = [784, 256, 128, 10]


def load_idx(path):
    with gzip.open(path, "rb") as f:
        data = f.read()
    magic = int.from_bytes(data[0:4], "big")
    ndim = magic & 0xFF
    dims = [int.from_bytes(data[4 + 4 * i: 8 + 4 * i], "big") for i in range(ndim)]
    return np.frombuffer(data, dtype=np.uint8, offset=4 + 4 * ndim).reshape(dims)


def load_raw():
    tr_x = load_idx(os.path.join(DATA_RAW, "train-images-idx3-ubyte.gz"))
    tr_y = load_idx(os.path.join(DATA_RAW, "train-labels-idx1-ubyte.gz")).astype(np.int64)
    te_x = load_idx(os.path.join(DATA_RAW, "t10k-images-idx3-ubyte.gz"))
    te_y = load_idx(os.path.join(DATA_RAW, "t10k-labels-idx1-ubyte.gz")).astype(np.int64)
    return tr_x, tr_y, te_x, te_y


def load_split():
    """Returns uint8 images (N,28,28), int64 labels, and normalization stats."""
    z = np.load(os.path.join(DATA, "split.npz"))
    tr_x, tr_y, te_x, te_y = load_raw()
    with open(os.path.join(DATA, "preprocess.json")) as f:
        st = json.load(f)
    return dict(
        train_x=tr_x[z["train_idx"]], train_y=tr_y[z["train_idx"]],
        val_x=tr_x[z["val_idx"]], val_y=tr_y[z["val_idx"]],
        test_x=te_x, test_y=te_y, mean=st["mean"], std=st["std"])


def preprocess_np(x_u8, mean, std):
    return ((x_u8.reshape(len(x_u8), 784).astype(np.float32) / 255.0) - mean) / std


def load_manifest():
    with open(os.path.join(CKPT, "manifest.json")) as f:
        return json.load(f)


def bench_sequence(test_x, test_y, n=1000, seed=BENCH_SEED):
    """Shared input sequence: 100 test images per class, shuffled once."""
    rng = np.random.default_rng(seed)
    per = n // 10
    idx = np.concatenate([rng.choice(np.where(test_y == c)[0], per, replace=False)
                          for c in range(10)])
    rng.shuffle(idx)
    return idx
