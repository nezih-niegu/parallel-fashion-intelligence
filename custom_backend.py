"""ctypes binding to the custom OpenMP+SIMD CPU backend (numpy only, no torch import)."""
import ctypes as C
import os

import numpy as np

from common import CKPT, GROUPS, ROOT

LIB = os.path.join(ROOT, "cpu", "build", "libpfi_cpu.so")
K_SCALAR, K_SIMD, K_SIMD_ILP, K_BLOCKED = 0, 1, 2, 3
KERNEL_NAMES = {0: "scalar", 1: "simd", 2: "simd_ilp", 3: "blocked"}

_p = lambda t: np.ctypeslib.ndpointer(dtype=t, flags="C_CONTIGUOUS")


class CustomBackend:
    def __init__(self, manifest, threads=1, kernel=K_BLOCKED, max_batch=256, binding="raw"):
        """binding='raw': hot calls pass bare pointers (c_void_p) into preallocated
        output buffers; binding='ndpointer': numpy ndpointer argtypes, which validate
        dtype/flags on every call (measured: ~10 us extra per batch-1 request)."""
        lib = C.CDLL(LIB)
        raw = C.CDLL(LIB)          # second handle with raw-pointer signatures
        V = C.c_void_p
        raw.pfi_flat_predict.argtypes = [V, C.c_int, V, V]
        raw.pfi_hier_predict.argtypes = [V, C.c_int, V, V, V]
        raw.pfi_preprocess.argtypes = [V, C.c_int, V]
        raw.pfi_route.argtypes = [V, C.c_int, V]
        raw.pfi_spec_predict.argtypes = [C.c_int, V, C.c_int, V]
        for fn in ("pfi_flat_predict", "pfi_hier_predict", "pfi_preprocess", "pfi_route", "pfi_spec_predict"):
            getattr(raw, fn).restype = None
        self.raw = raw
        self.binding = binding
        self._out = np.empty(max_batch, np.int32)
        self._grp = np.empty(max_batch, np.int32)
        self._X = np.empty((max_batch, 784), np.float32)
        self._po, self._pg, self._pX = self._out.ctypes.data, self._grp.ctypes.data, self._X.ctypes.data
        lib.pfi_load_model.restype = C.c_int
        lib.pfi_load_model.argtypes = [C.c_char_p, _p(np.int32), C.c_int]
        lib.pfi_setup.argtypes = [C.c_int, C.c_int, _p(np.int32), _p(np.int32), _p(np.int32),
                                  C.c_int, C.c_float, C.c_float, C.c_int]
        lib.pfi_flat_predict.argtypes = [_p(np.uint8), C.c_int, _p(np.int32), _p(np.int64)]
        lib.pfi_hier_predict.argtypes = [_p(np.uint8), C.c_int, _p(np.int32), _p(np.int32), _p(np.int64)]
        lib.pfi_logits.argtypes = [C.c_int, _p(np.float32), C.c_int, _p(np.float32), C.c_int]
        lib.pfi_preprocess.argtypes = [_p(np.uint8), C.c_int, _p(np.float32)]
        lib.pfi_route.argtypes = [_p(np.float32), C.c_int, _p(np.int32)]
        lib.pfi_spec_predict.argtypes = [C.c_int, _p(np.float32), C.c_int, _p(np.int32)]
        lib.pfi_bench_dense.argtypes = [C.c_int, C.c_int, _p(np.float32), C.c_int, C.c_int,
                                        _p(np.float32), C.c_int, C.c_int, _p(np.int64)]
        lib.pfi_scratch_bytes.restype = C.c_size_t
        self.lib = lib
        self.manifest = manifest
        self.handles = {}
        for name, m in manifest["models"].items():
            dims = np.array(m["dims"], dtype=np.int32)
            h = lib.pfi_load_model(os.path.join(CKPT, m["bin"]).encode(), dims, len(dims))
            assert h >= 0, f"failed to load {name}"
            self.handles[name] = h
        spec = np.array([self.handles.get(f"spec{g}", -1) if len(c) > 1 else -1
                         for g, (_, c) in enumerate(GROUPS)], dtype=np.int32)
        flat_cls = np.array([c for _, cl in GROUPS for c in cl], dtype=np.int32)
        off = np.cumsum([0] + [len(cl) for _, cl in GROUPS]).astype(np.int32)
        pp = manifest["preprocess"]
        lib.pfi_setup(self.handles["flat"], self.handles["router"], spec, flat_cls, off,
                      len(GROUPS), pp["mean"], pp["std"], max_batch)
        self.set_threads(threads)
        self.set_kernel(kernel)
        self._t = np.zeros(4, dtype=np.int64)
        self._pt = self._t.ctypes.data
        if binding == "raw":
            self.flat_predict, self.hier_predict = self._flat_raw, self._hier_raw
            self.preprocess, self.route, self.spec_predict = self._pre_raw, self._route_raw, self._spec_raw

    # ---- raw-pointer hot path (default). Inputs must be C-contiguous (asserted by callers).
    def _flat_raw(self, x_u8, timings=None):
        B = x_u8.shape[0]
        self.raw.pfi_flat_predict(x_u8.__array_interface__["data"][0], B, self._po, self._pt)
        if timings is not None:
            timings.append(tuple(self._t))
        return self._out[:B].copy(), None

    def _hier_raw(self, x_u8, timings=None):
        B = x_u8.shape[0]
        self.raw.pfi_hier_predict(x_u8.__array_interface__["data"][0], B, self._po, self._pg, self._pt)
        if timings is not None:
            timings.append(tuple(self._t))
        return self._out[:B].copy(), self._grp[:B].copy()

    def _pre_raw(self, x_u8):
        B = x_u8.shape[0]
        out = np.empty((B, 784), np.float32)
        self.raw.pfi_preprocess(np.ascontiguousarray(x_u8).__array_interface__["data"][0], B, out.ctypes.data)
        return out

    def _route_raw(self, X):
        B = X.shape[0]
        self.raw.pfi_route(X.__array_interface__["data"][0], B, self._pg)
        return self._grp[:B].copy()

    def _spec_raw(self, g, X):
        B = X.shape[0]
        if B:
            X = np.ascontiguousarray(X)
            self.raw.pfi_spec_predict(int(g), X.__array_interface__["data"][0], B, self._po)
        return self._out[:B].copy()

    def set_threads(self, t):
        self.lib.pfi_set_threads(int(t))

    def set_kernel(self, k):
        self.lib.pfi_set_kernel(int(k))

    def flat_predict(self, x_u8, timings=None):
        B = x_u8.shape[0]
        out = np.empty(B, dtype=np.int32)
        self.lib.pfi_flat_predict(x_u8.reshape(B, 784), B, out, self._t)
        if timings is not None:
            timings.append(tuple(self._t))
        return out, None

    def hier_predict(self, x_u8, timings=None):
        B = x_u8.shape[0]
        out = np.empty(B, dtype=np.int32)
        grp = np.empty(B, dtype=np.int32)
        self.lib.pfi_hier_predict(x_u8.reshape(B, 784), B, out, grp, self._t)
        if timings is not None:
            timings.append(tuple(self._t))
        return out, grp

    def logits(self, name, X, layer_stop=0):
        B = X.shape[0]
        dims = self.manifest["models"][name]["dims"]
        K = dims[layer_stop] if layer_stop > 0 else dims[-1]
        out = np.empty((B, K), dtype=np.float32)
        self.lib.pfi_logits(self.handles[name], np.ascontiguousarray(X, dtype=np.float32), B, out, layer_stop)
        return out

    def preprocess(self, x_u8):
        B = x_u8.shape[0]
        out = np.empty((B, 784), dtype=np.float32)
        self.lib.pfi_preprocess(np.ascontiguousarray(x_u8.reshape(B, 784)), B, out)
        return out

    def route(self, X):
        g = np.empty(X.shape[0], dtype=np.int32)
        self.lib.pfi_route(X, X.shape[0], g)
        return g

    def spec_predict(self, g, X):
        lab = np.empty(X.shape[0], dtype=np.int32)
        if X.shape[0]:
            self.lib.pfi_spec_predict(int(g), X, X.shape[0], lab)
        return lab

    def bench_dense(self, kernel, threads, X, model, layer, reps):
        B = X.shape[0]
        O = self.manifest["models"][model]["dims"][layer + 1]
        Y = np.empty((B, O), dtype=np.float32)
        ns = np.empty(reps, dtype=np.int64)
        self.lib.pfi_bench_dense(kernel, threads, X, self.handles[model], layer, Y, B, reps, ns)
        return ns, Y
