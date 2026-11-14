"""Accuracy evaluation of the frozen models (validation and, once, test).

Reports test accuracy, macro-F1, per-class recall, router accuracy + confusion matrix,
oracle specialist accuracy under true routes, end-to-end accuracy (<= router accuracy
check), parameter / storage / active-parameter accounting. Writes results/accuracy.json.
"""
import json
import os

import numpy as np
import torch

from common import CLASS_NAMES, CLASS_TO_GROUP, CLASS_TO_LOCAL, GROUPS, RESULTS, load_manifest, load_split
from torch_models import TorchFlat, TorchHierarchy

torch.set_num_threads(2)


def macro_f1(y, p, K):
    f = []
    for c in range(K):
        tp = np.sum((p == c) & (y == c)); fp = np.sum((p == c) & (y != c)); fn = np.sum((p != c) & (y == c))
        f.append(0.0 if tp == 0 else 2 * tp / (2 * tp + fp + fn))
    return float(np.mean(f))


def confusion(y, p, K):
    m = np.zeros((K, K), dtype=np.int64)
    np.add.at(m, (y, p), 1)
    return m


def evaluate(split, x_u8, y, flat, hier):
    xt = torch.from_numpy(x_u8)
    pf, _ = flat.predict(xt)
    ph, g = hier.predict(xt)
    pf, ph, g = pf.numpy(), ph.numpy(), g.numpy()
    gt = CLASS_TO_GROUP[y]
    # oracle: each specialist on its true-group images (ground-truth routes)
    X = hier.preprocess(xt)
    oracle = {}
    oracle_correct = 0
    for gi, (gname, cls) in enumerate(GROUPS):
        m = gt == gi
        if len(cls) == 1:
            oracle[gname] = 1.0; oracle_correct += int(m.sum()); continue
        with torch.inference_mode():
            loc = hier.spec[gi](X[torch.from_numpy(m)]).argmax(1).numpy()
        acc = float(np.mean(loc == CLASS_TO_LOCAL[y[m]]))
        oracle[gname] = acc
        oracle_correct += int(np.sum(loc == CLASS_TO_LOCAL[y[m]]))
    r = {
        "n": int(len(y)),
        "flat": {"accuracy": float(np.mean(pf == y)), "macro_f1": macro_f1(y, pf, 10),
                 "per_class_recall": [float(np.mean(pf[y == c] == c)) for c in range(10)],
                 "confusion": confusion(y, pf, 10).tolist()},
        "hierarchy": {"accuracy": float(np.mean(ph == y)), "macro_f1": macro_f1(y, ph, 10),
                      "per_class_recall": [float(np.mean(ph[y == c] == c)) for c in range(10)],
                      "confusion": confusion(y, ph, 10).tolist(),
                      "router_accuracy": float(np.mean(g == gt)),
                      "router_confusion": confusion(gt, g, len(GROUPS)).tolist(),
                      "routing_fraction_q": [float(np.mean(g == k)) for k in range(len(GROUPS))],
                      "oracle_specialist_accuracy": oracle,
                      "oracle_end_to_end_accuracy": oracle_correct / len(y),
                      "end_to_end_le_router": bool(np.mean(ph == y) <= np.mean(g == gt) + 1e-12)},
    }
    print(f"[{split}] flat acc={r['flat']['accuracy']:.4f} F1={r['flat']['macro_f1']:.4f} | hier acc="
          f"{r['hierarchy']['accuracy']:.4f} F1={r['hierarchy']['macro_f1']:.4f} router={r['hierarchy']['router_accuracy']:.4f} "
          f"oracle={r['hierarchy']['oracle_end_to_end_accuracy']:.4f}")
    return r, ph


def main():
    man = load_manifest()
    d = load_split()
    flat, hier = TorchFlat(man), TorchHierarchy(man)
    res = {"validation": evaluate("val", d["val_x"], d["val_y"], flat, hier)[0]}
    rt, ph_test = evaluate("test", d["test_x"], d["test_y"], flat, hier)
    res["test"] = rt
    np.save(os.path.join(RESULTS, "test_pred_torch_hier.npy"), ph_test)
    q = rt["hierarchy"]["routing_fraction_q"]
    models = man["models"]
    PR = models["router"]["params"]
    Pg = [models[f"spec{g}"]["params"] if len(c) > 1 else 0 for g, (_, c) in enumerate(GROUPS)]
    res["parameters"] = {
        "flat": models["flat"]["params"], "router": PR,
        "specialists": {GROUPS[g][0]: Pg[g] for g in range(len(GROUPS))},
        "P_total_hierarchy": PR + sum(Pg),
        "active_per_route": {GROUPS[g][0]: PR + Pg[g] for g in range(len(GROUPS))},
        "E_P_active_test_routes": PR + float(np.dot(q, Pg)),
        "storage_bytes_fp32": {k: v["bytes_fp32"] for k, v in models.items()},
        "storage_bytes_hierarchy": sum(v["bytes_fp32"] for k, v in models.items() if k != "flat"),
        "dims": {k: v["dims"] for k, v in models.items()},
    }
    res["class_names"] = CLASS_NAMES
    with open(os.path.join(RESULTS, "accuracy.json"), "w") as f:
        json.dump(res, f, indent=1)
    print(json.dumps(res["parameters"], indent=1))
    print("test per-class recall flat", np.round(rt["flat"]["per_class_recall"], 3))
    print("test per-class recall hier", np.round(rt["hierarchy"]["per_class_recall"], 3))
    print("router confusion\n", np.array(rt["hierarchy"]["router_confusion"]))
    print("oracle", rt["hierarchy"]["oracle_specialist_accuracy"])


if __name__ == "__main__":
    main()
