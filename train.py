"""Train the flat reference, router, and specialists; select on validation; freeze.

Selection rule (applied per role): highest validation accuracy; candidates within
0.15 percentage points of the best are considered tied and the smallest one wins.
Training is preparation only: no timing here is used in the performance analysis.
Outputs: checkpoints/*.pt, checkpoints/*.bin (raw FP32 for the C++/CUDA backends),
checkpoints/manifest.json, results/training_log.json
"""
import hashlib
import json
import os
import time

import numpy as np
import torch
from torch import nn

from common import (CKPT, CLASS_TO_GROUP, CLASS_TO_LOCAL, FLAT_DIMS, GROUPS, RESULTS,
                    TRAIN_SEED, load_split, preprocess_np)
from torch_models import MLP, n_params

torch.set_num_threads(2)
EPOCHS = 30
BATCH = 128
DROPOUT = 0.2

CANDIDATES = {
    "flat": [FLAT_DIMS],
    "router": [[784, 64, 4], [784, 128, 64, 4], [784, 256, 128, 4]],
    "spec0": [[784, 128, 64, 4], [784, 192, 96, 4]],       # Upper-body, 4 classes
    "spec1": [[784, 16, 2], [784, 32, 2]],                 # Lower/full-body, 2 classes
    "spec2": [[784, 32, 3], [784, 64, 32, 3]],             # Footwear, 3 classes
}


def train_one(dims, xtr, ytr, xva, yva, seed):
    torch.manual_seed(seed)
    np.random.seed(seed)
    model = MLP(dims, dropout=DROPOUT)
    opt = torch.optim.Adam(model.parameters(), lr=1e-3)
    steps = EPOCHS * ((len(xtr) + BATCH - 1) // BATCH)
    sched = torch.optim.lr_scheduler.OneCycleLR(opt, max_lr=2e-3, total_steps=steps)
    lossf = nn.CrossEntropyLoss()
    xtr_t, ytr_t = torch.from_numpy(xtr), torch.from_numpy(ytr)
    xva_t, yva_t = torch.from_numpy(xva), torch.from_numpy(yva)
    g = torch.Generator().manual_seed(seed)
    best = (-1.0, None, -1)
    curve = []
    for ep in range(EPOCHS):
        model.train()
        perm = torch.randperm(len(xtr_t), generator=g)
        tot, n = 0.0, 0
        for i in range(0, len(perm), BATCH):
            b = perm[i:i + BATCH]
            opt.zero_grad()
            loss = lossf(model(xtr_t[b]), ytr_t[b])
            loss.backward()
            opt.step()
            sched.step()
            tot += loss.item() * len(b)
            n += len(b)
        model.eval()
        with torch.no_grad():
            lv = model(xva_t)
            vloss = lossf(lv, yva_t).item()
            vacc = (lv.argmax(1) == yva_t).float().mean().item()
        curve.append({"epoch": ep + 1, "train_loss": tot / n, "val_loss": vloss, "val_acc": vacc})
        if vacc > best[0]:
            best = (vacc, {k: v.clone() for k, v in model.state_dict().items()}, ep + 1)
    return best, curve


def export(name, dims, state, manifest):
    # state_dict keys look like network.1.weight; rename to layer{j}
    lin_keys = sorted({k.rsplit(".", 1)[0] for k in state}, key=lambda s: int(s.split(".")[1]))
    sd = {}
    blobs = []
    for j, k in enumerate(lin_keys):
        W = state[k + ".weight"].contiguous()
        b = state[k + ".bias"].contiguous()
        assert W.shape == (dims[j + 1], dims[j])
        sd[f"layer{j}.weight"], sd[f"layer{j}.bias"] = W, b
        blobs += [W.numpy().astype(np.float32).tobytes(), b.numpy().astype(np.float32).tobytes()]
    torch.save(sd, os.path.join(CKPT, f"{name}.pt"))
    raw = b"".join(blobs)
    with open(os.path.join(CKPT, f"{name}.bin"), "wb") as f:
        f.write(raw)
    manifest["models"][name] = {"dims": dims, "pt": f"{name}.pt", "bin": f"{name}.bin",
                                "params": n_params(dims), "bytes_fp32": len(raw),
                                "sha256_bin": hashlib.sha256(raw).hexdigest()}


def main():
    os.makedirs(CKPT, exist_ok=True)
    os.makedirs(RESULTS, exist_ok=True)
    d = load_split()
    xtr = preprocess_np(d["train_x"], d["mean"], d["std"])
    xva = preprocess_np(d["val_x"], d["mean"], d["std"])
    ytr, yva = d["train_y"], d["val_y"]
    roles = {
        "flat": (xtr, ytr, xva, yva),
        "router": (xtr, CLASS_TO_GROUP[ytr], xva, CLASS_TO_GROUP[yva]),
    }
    for g, (_, cls) in enumerate(GROUPS):
        if len(cls) > 1:
            mtr, mva = np.isin(ytr, cls), np.isin(yva, cls)
            roles[f"spec{g}"] = (xtr[mtr], CLASS_TO_LOCAL[ytr[mtr]], xva[mva], CLASS_TO_LOCAL[yva[mva]])
    manifest = {"preprocess": {"mean": d["mean"], "std": d["std"]},
                "groups": [{"name": n, "classes": c} for n, c in GROUPS],
                "train_seed": TRAIN_SEED, "epochs": EPOCHS, "batch": BATCH,
                "dropout": DROPOUT, "optimizer": "Adam + OneCycle(max_lr=2e-3)",
                "selection_rule": "max val acc; within 0.15 pp -> fewest params",
                "models": {}}
    log = {}
    for role, cands in CANDIDATES.items():
        xtr_r, ytr_r, xva_r, yva_r = roles[role]
        res = []
        for dims in cands:
            t0 = time.time()
            (vacc, state, ep), curve = train_one(dims, xtr_r, ytr_r, xva_r, yva_r, TRAIN_SEED)
            res.append({"dims": dims, "params": n_params(dims), "best_val_acc": vacc,
                        "best_epoch": ep, "curve": curve, "state": state})
            print(f"{role:7s} {str(dims):22s} params={n_params(dims):7d} val_acc={vacc:.4f} "
                  f"ep={ep} ({time.time() - t0:.0f}s)", flush=True)
        top = max(r["best_val_acc"] for r in res)
        tied = [r for r in res if r["best_val_acc"] >= top - 0.0015]
        pick = min(tied, key=lambda r: r["params"])
        export(role, pick["dims"], pick["state"], manifest)
        manifest["models"][role]["val_acc"] = pick["best_val_acc"]
        manifest["models"][role]["best_epoch"] = pick["best_epoch"]
        log[role] = [{k: v for k, v in r.items() if k != "state"} | {"selected": r is pick} for r in res]
    flat_p = manifest["models"]["flat"]["params"]
    for k, m in manifest["models"].items():
        if k.startswith("spec"):
            assert m["params"] < flat_p, f"{k} not smaller than flat reference"
    with open(os.path.join(CKPT, "manifest.json"), "w") as f:
        json.dump(manifest, f, indent=2)
    with open(os.path.join(RESULTS, "training_log.json"), "w") as f:
        json.dump(log, f, indent=1)
    print(json.dumps({k: (v["dims"], v["params"], round(v["val_acc"], 4)) for k, v in manifest["models"].items()}, indent=1))


if __name__ == "__main__":
    main()
