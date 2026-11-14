"""Step 1: custom CPU backend vs. PyTorch on identical weights.

Compares preprocessing, every hidden activation, logits, routes and predictions on the
full 10,000-image test set for all four kernels; tests empty / partial / single-group /
singleton-only batches and the label mapping. Writes results/correctness.json.

Tolerance: FP32 dot products of length I summed in a different order differ by at most
gamma_I * sum|x_i w_i| (gamma_I ~ I*u, u = 2^-24). We use the per-layer bound
tol = 2 * I * u * max_n sum_i |x_ni||w_oi| propagated as an absolute tolerance on the
largest layer, plus the observed values. A prediction may differ only if the top-2 logit
gap is below that tolerance (a genuine tie in FP32); otherwise the test fails.
"""
import json
import os

import numpy as np
import torch

from common import CLASS_TO_GROUP, GROUPS, RESULTS, load_manifest, load_split
from custom_backend import KERNEL_NAMES, CustomBackend
from torch_models import TorchFlat, TorchHierarchy

torch.set_num_threads(1)
U = 2.0 ** -24


def layer_bound(model, X):
    """Worst-case forward-error bound for each layer output, computed with |x|,|W|."""
    bounds = []
    h = X.abs()
    hv = X
    for j, lin in enumerate(model.linears()):
        I = lin.in_features
        s = h @ lin.weight.abs().T                    # sum |x||w| per output
        bounds.append(float(2 * I * U * s.max()))
        hv = lin(hv)
        if j < len(model.linears()) - 1:
            hv = torch.relu(hv)
        h = hv.abs()
    return bounds


def main():
    man = load_manifest()
    d = load_split()
    xu8 = np.ascontiguousarray(d["test_x"])
    flat, hier = TorchFlat(man), TorchHierarchy(man)
    cb = CustomBackend(man, threads=2)
    rep = {"preprocess": {}, "models": {}, "system": {}, "edge_cases": {}}

    Xt = flat.preprocess(torch.from_numpy(xu8.copy()))
    Xc = cb.preprocess(xu8)
    e = np.abs(Xc - Xt.numpy())
    rep["preprocess"] = {"max_abs": float(e.max()), "max_rel": float((e / np.maximum(np.abs(Xt.numpy()), 1e-6)).max())}
    X = Xt.numpy()

    tm = {"flat": flat.model, "router": hier.router}
    tm.update({f"spec{g}": m for g, m in hier.spec.items()})
    ok = True
    for name, model in tm.items():
        bounds = layer_bound(model, Xt)
        rep["models"][name] = {"tolerance_per_layer": bounds}
        nl = len(model.linears())
        # torch reference activations
        acts = []
        with torch.inference_mode():
            h = Xt
            for j, lin in enumerate(model.linears()):
                h = lin(h)
                if j < nl - 1:
                    h = torch.relu(h)
                acts.append(h.numpy().copy())
        for k in range(4):
            cb.set_kernel(k)
            r = {}
            for j in range(nl):
                a = cb.logits(name, X, layer_stop=(j + 1) if j < nl - 1 else 0)
                diff = np.abs(a - acts[j])
                r[f"layer{j}"] = {"max_abs": float(diff.max()),
                                  "max_rel": float(diff.max() / max(np.abs(acts[j]).max(), 1e-12)),
                                  "within_tol": bool(diff.max() <= bounds[j])}
                ok &= r[f"layer{j}"]["within_tol"]
            pt = acts[-1].argmax(1)
            pc = a.argmax(1)
            mism = np.where(pt != pc)[0]
            srt = np.sort(acts[-1], axis=1)
            gaps = (srt[:, -1] - srt[:, -2])[mism]
            r["pred_mismatches"] = int(len(mism))
            r["mismatch_top2_gaps"] = gaps.tolist()
            ok &= bool(np.all(gaps <= bounds[-1]))
            rep["models"][name][KERNEL_NAMES[k]] = r
            print(name, KERNEL_NAMES[k], {kk: (round(vv["max_abs"], 8)) for kk, vv in r.items() if kk.startswith("layer")},
                  "mismatch", len(mism))
    cb.set_kernel(3)

    # system-level predictions at several batch sizes (partial final batches included)
    tf, _ = flat.predict(torch.from_numpy(xu8.copy()))
    th, tg = hier.predict(torch.from_numpy(xu8.copy()))
    tf, th, tg = tf.numpy(), th.numpy(), tg.numpy()
    for B in [1, 7, 64, 256]:
        for T in [1, 2]:
            cb.set_threads(T)
            pf = np.concatenate([cb.flat_predict(xu8[i:i + B])[0] for i in range(0, len(xu8), B)])
            outs = [cb.hier_predict(xu8[i:i + B]) for i in range(0, len(xu8), B)]
            ph = np.concatenate([o[0] for o in outs]); pg = np.concatenate([o[1] for o in outs])
            rep["system"][f"B{B}_T{T}"] = {"flat_pred_mismatch": int(np.sum(pf != tf)),
                                           "hier_pred_mismatch": int(np.sum(ph != th)),
                                           "route_mismatch": int(np.sum(pg != tg)),
                                           "last_batch_size": int(len(xu8) - B * ((len(xu8) - 1) // B))}
            print("system", B, T, rep["system"][f"B{B}_T{T}"])
            ok &= rep["system"][f"B{B}_T{T}"]["hier_pred_mismatch"] == 0
    cb.set_threads(2)

    # edge cases
    E = rep["edge_cases"]
    o, g = cb.hier_predict(np.zeros((0, 28, 28), np.uint8)); E["empty_batch"] = {"len_out": int(len(o))}
    ok &= len(o) == 0
    for gi, (gname, cls) in enumerate(GROUPS):
        idx = np.where(tg == gi)[0][:50]        # batch routed entirely to one group
        o, g = cb.hier_predict(xu8[idx])
        E[f"single_group_{gname}"] = {"n": int(len(idx)), "all_routed_here": bool(np.all(g == gi)),
                                     "labels_subset_of_group": bool(np.all(np.isin(o, cls))),
                                     "matches_torch": bool(np.all(o == th[idx]))}
        ok &= E[f"single_group_{gname}"]["matches_torch"] and E[f"single_group_{gname}"]["labels_subset_of_group"]
    # partial batch: some groups empty (only Upper + Bag)
    idx = np.concatenate([np.where(tg == 0)[0][:3], np.where(tg == 3)[0][:2]])
    np.random.default_rng(0).shuffle(idx)
    o, g = cb.hier_predict(xu8[idx])
    E["partial_upper_and_bag_only"] = {"matches_torch": bool(np.all(o == th[idx])), "groups": g.tolist()}
    ok &= E["partial_upper_and_bag_only"]["matches_torch"]
    # label maps: specialist local k -> global
    E["label_maps"] = {gname: {str(k): c for k, c in enumerate(cls)} for gname, cls in GROUPS}
    rep["all_passed"] = bool(ok)
    with open(os.path.join(RESULTS, "correctness.json"), "w") as f:
        json.dump(rep, f, indent=1)
    print("preprocess", rep["preprocess"])
    print("ALL PASSED" if ok else "FAILURES PRESENT")


if __name__ == "__main__":
    main()
