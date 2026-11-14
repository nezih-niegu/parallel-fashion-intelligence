"""PyTorch model definitions and the matched PyTorch hierarchy (inference)."""
import json
import os

import numpy as np
import torch
from torch import nn

from common import CKPT, GROUPS, NUM_GROUPS


class MLP(nn.Module):
    """Linear -> ReLU (-> Dropout during training) ... -> Linear (logits)."""

    def __init__(self, dims, dropout=0.0):
        super().__init__()
        layers = [nn.Flatten()]
        for i in range(len(dims) - 1):
            layers.append(nn.Linear(dims[i], dims[i + 1]))
            if i < len(dims) - 2:
                layers.append(nn.ReLU())
                if dropout > 0:
                    layers.append(nn.Dropout(dropout))
        self.network = nn.Sequential(*layers)
        self.dims = list(dims)

    def forward(self, x):
        return self.network(x)

    def linears(self):
        return [m for m in self.network if isinstance(m, nn.Linear)]


def n_params(dims):
    return sum(dims[i] * dims[i + 1] + dims[i + 1] for i in range(len(dims) - 1))


def load_model(name, manifest):
    m = manifest["models"][name]
    model = MLP(m["dims"])
    sd = torch.load(os.path.join(CKPT, m["pt"]), map_location="cpu", weights_only=True)
    # checkpoints were saved from a dropout model: keep only Linear params, remap index
    lin = model.linears()
    for j, l in enumerate(lin):
        l.weight.data.copy_(sd[f"layer{j}.weight"])
        l.bias.data.copy_(sd[f"layer{j}.bias"])
    model.eval()
    for p in model.parameters():
        p.requires_grad_(False)
    return model


class TorchHierarchy:
    """Matched PyTorch hierarchy: preprocess -> router -> pack -> specialists -> restore.
    device='cuda' runs the same code on the GPU (labels copied back to host at the end)."""

    def __init__(self, manifest, device="cpu"):
        self.device = torch.device(device)
        self.mean = manifest["preprocess"]["mean"]
        self.std = manifest["preprocess"]["std"]
        self.router = load_model("router", manifest).to(self.device)
        self.spec = {}
        self.maps = {}
        for g, (gname, cls) in enumerate(GROUPS):
            self.maps[g] = torch.tensor(cls, dtype=torch.int64, device=self.device)
            if len(cls) > 1:
                self.spec[g] = load_model(f"spec{g}", manifest).to(self.device)

    def preprocess(self, x_u8):
        # x_u8: torch uint8 (B,28,28) host tensor; moved to the model device first
        x_u8 = x_u8.to(self.device, non_blocking=True)
        return (x_u8.reshape(x_u8.shape[0], 784).to(torch.float32) / 255.0 - self.mean) / self.std

    @torch.inference_mode()
    def route(self, x):
        return self.router(x).argmax(dim=1)

    @torch.inference_mode()
    def run_group(self, g, xg):
        if g in self.spec:
            local = self.spec[g](xg).argmax(dim=1)
            return self.maps[g][local]
        return self.maps[g][0].expand(xg.shape[0]).clone()

    @torch.inference_mode()
    def predict(self, x_u8, timings=None):
        import time
        t0 = time.perf_counter_ns()
        x = self.preprocess(x_u8)
        t1 = time.perf_counter_ns()
        g = self.route(x)
        t2 = time.perf_counter_ns()
        out = torch.empty(x.shape[0], dtype=torch.int64, device=self.device)
        tspec = 0
        for gi in range(NUM_GROUPS):
            idx = (g == gi).nonzero(as_tuple=True)[0]
            if idx.numel() == 0:
                continue
            ts = time.perf_counter_ns()
            lab = self.run_group(gi, x.index_select(0, idx))
            tspec += time.perf_counter_ns() - ts
            out[idx] = lab
        t3 = time.perf_counter_ns()
        if self.device.type != "cpu":
            out, g = out.cpu(), g.cpu()          # labels host-readable (synchronizes)
        if timings is not None:
            timings.append((t1 - t0, t2 - t1, tspec, (t3 - t2) - tspec))
        return out, g


class TorchFlat:
    def __init__(self, manifest, device="cpu"):
        self.device = torch.device(device)
        self.mean = manifest["preprocess"]["mean"]
        self.std = manifest["preprocess"]["std"]
        self.model = load_model("flat", manifest).to(self.device)

    def preprocess(self, x_u8):
        x_u8 = x_u8.to(self.device, non_blocking=True)
        return (x_u8.reshape(x_u8.shape[0], 784).to(torch.float32) / 255.0 - self.mean) / self.std

    @torch.inference_mode()
    def predict(self, x_u8, timings=None):
        import time
        t0 = time.perf_counter_ns()
        x = self.preprocess(x_u8)
        t1 = time.perf_counter_ns()
        y = self.model(x).argmax(dim=1)
        if self.device.type != "cpu":
            y = y.cpu()
        t2 = time.perf_counter_ns()
        if timings is not None:
            timings.append((t1 - t0, t2 - t1, 0, 0))
        return y, None
