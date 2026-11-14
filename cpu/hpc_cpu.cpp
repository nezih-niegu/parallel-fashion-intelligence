// Custom CPU inference backend: OpenMP threading + SIMD dense layers.
//
// Vectorization methods (documented, see build.sh for compiler reports / assembly):
//   K_SCALAR   : plain C++ loop, auto-vectorization disabled per function -> scalar FMAs
//   K_SIMD     : teaching-grade dot product, `#pragma omp simd reduction` (W in [O][I])
//   K_SIMD_ILP : AVX-512 intrinsics dot product with 4 independent accumulators (ILP)
//   K_BLOCKED  : AVX-512 register-blocked kernel on transposed weights Wt[I][O]:
//                NB samples x NV*16 outputs held in zmm registers, broadcast X, FMA rows
// Threading: OpenMP. One parallel region spans an entire inference request; layers are
// separated by the implicit barrier of `omp for` (the layer dependency). Unit of work:
//   K_SIMD     : (sample, output) pairs, collapse(2) static schedule (as in the brief)
//   K_BLOCKED  : (sample-block, output-tile) tiles; tile width shrinks for small batches
//                so that #tiles >= #threads (batch 1 would otherwise serialize).
// No threaded library is called. Library thread counts: this .so links only libgomp;
// the benchmark process for this backend does not import PyTorch.
#include <immintrin.h>
#include <omp.h>

#include <algorithm>
#include <chrono>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <vector>

namespace {

using clk = std::chrono::steady_clock;
inline int64_t now_ns() {
  return std::chrono::duration_cast<std::chrono::nanoseconds>(clk::now().time_since_epoch()).count();
}

float* aligned_floats(size_t n) {
  size_t bytes = ((n * sizeof(float) + 63) / 64) * 64;
  if (bytes == 0) bytes = 64;
  float* p = static_cast<float*>(std::aligned_alloc(64, bytes));
  std::memset(p, 0, bytes);
  return p;
}

enum Kernel { K_SCALAR = 0, K_SIMD = 1, K_SIMD_ILP = 2, K_BLOCKED = 3 };

struct Layer {
  int I = 0, O = 0;
  float* W = nullptr;   // [O][I]  (PyTorch layout)
  float* Wt = nullptr;  // [I][O]  (transposed copy for the blocked kernel)
  float* b = nullptr;   // [O]
};

struct Model {
  std::vector<Layer> layers;
  int max_width = 0;
};

std::vector<Model> g_models;
int g_kernel = K_BLOCKED;

// ----------------------------------------------------------------------------------
// Dense kernels. All compute Y[n][o] = act(sum_i X[n][i] * W[o][i] + b[o]).
// The *_rows variants process outputs [o_begin, o_end) for samples [n_begin, n_end)
// and are called from inside a parallel region (work already split by the caller).
// ----------------------------------------------------------------------------------

__attribute__((optimize("no-tree-vectorize"), noinline))
void dense_scalar_rows(const float* X, const Layer& L, float* Y, int n0, int n1, int o0, int o1, bool relu) {
  const int I = L.I, O = L.O;
  for (int n = n0; n < n1; ++n)
    for (int o = o0; o < o1; ++o) {
      float sum = 0.0f;
      const float* x = X + size_t(n) * I;
      const float* w = L.W + size_t(o) * I;
      for (int i = 0; i < I; ++i) sum += x[i] * w[i];
      float z = sum + L.b[o];
      Y[size_t(n) * O + o] = (relu && z < 0.0f) ? 0.0f : z;
    }
}

__attribute__((noinline))
float dot_simd(const float* __restrict x, const float* __restrict w, int I) {
  float sum = 0.0f;
#pragma omp simd reduction(+ : sum)
  for (int i = 0; i < I; ++i) sum += x[i] * w[i];
  return sum;
}

#ifdef __AVX512F__
inline float dot_ilp(const float* __restrict x, const float* __restrict w, int I) {
  __m512 a0 = _mm512_setzero_ps(), a1 = _mm512_setzero_ps();
  __m512 a2 = _mm512_setzero_ps(), a3 = _mm512_setzero_ps();
  int i = 0;
  for (; i + 64 <= I; i += 64) {  // 4 independent FMA chains hide the 4-cycle FMA latency
    a0 = _mm512_fmadd_ps(_mm512_loadu_ps(x + i), _mm512_loadu_ps(w + i), a0);
    a1 = _mm512_fmadd_ps(_mm512_loadu_ps(x + i + 16), _mm512_loadu_ps(w + i + 16), a1);
    a2 = _mm512_fmadd_ps(_mm512_loadu_ps(x + i + 32), _mm512_loadu_ps(w + i + 32), a2);
    a3 = _mm512_fmadd_ps(_mm512_loadu_ps(x + i + 48), _mm512_loadu_ps(w + i + 48), a3);
  }
  for (; i + 16 <= I; i += 16) a0 = _mm512_fmadd_ps(_mm512_loadu_ps(x + i), _mm512_loadu_ps(w + i), a0);
  if (i < I) {
    __mmask16 m = (__mmask16)((1u << (I - i)) - 1u);
    a1 = _mm512_fmadd_ps(_mm512_maskz_loadu_ps(m, x + i), _mm512_maskz_loadu_ps(m, w + i), a1);
  }
  return _mm512_reduce_add_ps(_mm512_add_ps(_mm512_add_ps(a0, a1), _mm512_add_ps(a2, a3)));
}
#else
inline float dot_ilp(const float* x, const float* w, int I) { return dot_simd(x, w, I); }
#endif

__attribute__((noinline))
void dense_simd_rows(const float* X, const Layer& L, float* Y, int n0, int n1, int o0, int o1, bool relu, bool ilp) {
  const int I = L.I, O = L.O;
  for (int n = n0; n < n1; ++n)
    for (int o = o0; o < o1; ++o) {
      float s = ilp ? dot_ilp(X + size_t(n) * I, L.W + size_t(o) * I, I)
                    : dot_simd(X + size_t(n) * I, L.W + size_t(o) * I, I);
      float z = s + L.b[o];
      Y[size_t(n) * O + o] = (relu && z < 0.0f) ? 0.0f : z;
    }
}

#ifdef __AVX512F__
// Register-blocked micro-kernel on Wt[I][O]: NB samples x NV vectors of 16 outputs.
// U independent copies of the accumulators split the i-loop when NB*NV is small,
// so that at least ~4 FMA chains are in flight (hides FMA latency at batch 1).
template <int NB, int NV, int U>
inline void micro(const float* __restrict X, int I, const float* __restrict Wt, int O,
                  const float* __restrict b, float* __restrict Y, int n0, int o0, int ocount, bool relu) {
  __m512 acc[U][NB][NV];
  for (int u = 0; u < U; ++u)
    for (int r = 0; r < NB; ++r)
      for (int v = 0; v < NV; ++v) acc[u][r][v] = _mm512_setzero_ps();
  __mmask16 mask[NV];
  for (int v = 0; v < NV; ++v) {
    int rem = ocount - 16 * v;
    mask[v] = rem >= 16 ? (__mmask16)0xFFFF : (rem <= 0 ? (__mmask16)0 : (__mmask16)((1u << rem) - 1u));
  }
  const float* xr[NB];
  for (int r = 0; r < NB; ++r) xr[r] = X + size_t(n0 + r) * I;
  const float* wcol = Wt + o0;
  int i = 0;
  for (; i + U <= I; i += U) {
    for (int u = 0; u < U; ++u) {
      const float* wrow = wcol + size_t(i + u) * O;
      __m512 w[NV];
      for (int v = 0; v < NV; ++v) w[v] = _mm512_maskz_loadu_ps(mask[v], wrow + 16 * v);
      for (int r = 0; r < NB; ++r) {
        __m512 xb = _mm512_set1_ps(xr[r][i + u]);
        for (int v = 0; v < NV; ++v) acc[u][r][v] = _mm512_fmadd_ps(xb, w[v], acc[u][r][v]);
      }
    }
  }
  for (; i < I; ++i) {
    const float* wrow = wcol + size_t(i) * O;
    for (int r = 0; r < NB; ++r) {
      __m512 xb = _mm512_set1_ps(xr[r][i]);
      for (int v = 0; v < NV; ++v)
        acc[0][r][v] = _mm512_fmadd_ps(xb, _mm512_maskz_loadu_ps(mask[v], wrow + 16 * v), acc[0][r][v]);
    }
  }
  const __m512 zero = _mm512_setzero_ps();
  for (int r = 0; r < NB; ++r)
    for (int v = 0; v < NV; ++v) {
      __m512 s = acc[0][r][v];
      for (int u = 1; u < U; ++u) s = _mm512_add_ps(s, acc[u][r][v]);
      s = _mm512_add_ps(s, _mm512_maskz_loadu_ps(mask[v], b + o0 + 16 * v));  // fused bias
      if (relu) s = _mm512_max_ps(s, zero);                                    // fused ReLU
      _mm512_mask_storeu_ps(Y + size_t(n0 + r) * O + o0 + 16 * v, mask[v], s);
    }
}

template <int NB>
inline void micro_nv(int nv, const float* X, int I, const float* Wt, int O, const float* b, float* Y,
                     int n0, int o0, int oc, bool relu) {
  // pick i-split U so that NB*NV*U >= 4 independent chains
  switch (nv) {
    case 1: micro<NB, 1, (NB >= 4 ? 1 : 4 / NB)>(X, I, Wt, O, b, Y, n0, o0, oc, relu); break;
    case 2: micro<NB, 2, (NB >= 2 ? 1 : 2)>(X, I, Wt, O, b, Y, n0, o0, oc, relu); break;
    case 3: micro<NB, 3, 1>(X, I, Wt, O, b, Y, n0, o0, oc, relu); break;
    default: micro<NB, 4, 1>(X, I, Wt, O, b, Y, n0, o0, oc, relu); break;
  }
}

void blocked_tile(const float* X, const Layer& L, float* Y, int n0, int nb, int o0, int oc, bool relu) {
  int nv = (oc + 15) / 16;
  switch (nb) {
    case 1: micro_nv<1>(nv, X, L.I, L.Wt, L.O, L.b, Y, n0, o0, oc, relu); break;
    case 2: micro_nv<2>(nv, X, L.I, L.Wt, L.O, L.b, Y, n0, o0, oc, relu); break;
    case 3: micro_nv<3>(nv, X, L.I, L.Wt, L.O, L.b, Y, n0, o0, oc, relu); break;
    default: micro_nv<4>(nv, X, L.I, L.Wt, L.O, L.b, Y, n0, o0, oc, relu); break;
  }
}
#endif

// Called by every thread of an active parallel region (or serially when not in one).
void dense_layer_inregion(const float* X, const Layer& L, float* Y, int B, bool relu, int kernel) {
  if (B <= 0) return;
  const int O = L.O;
  if (kernel == K_SCALAR) {
#pragma omp for collapse(2) schedule(static)
    for (int n = 0; n < B; ++n)
      for (int o = 0; o < O; ++o) dense_scalar_rows(X, L, Y, n, n + 1, o, o + 1, relu);
    return;
  }
  if (kernel == K_SIMD || kernel == K_SIMD_ILP) {
    const bool ilp = kernel == K_SIMD_ILP;
#pragma omp for collapse(2) schedule(static)
    for (int n = 0; n < B; ++n)
      for (int o = 0; o < O; ++o) dense_simd_rows(X, L, Y, n, n + 1, o, o + 1, relu, ilp);
    return;
  }
#ifdef __AVX512F__
  // K_BLOCKED: tile = 4 samples x TW outputs. TW in {64,32,16} chosen so that
  // #tiles >= #threads where possible (batch-1 parallelism comes only from outputs).
  const int T = omp_get_num_threads();
  const int nblk = (B + 3) / 4;
  int TW = 64;
  while (TW > 16 && nblk * ((O + TW - 1) / TW) < T) TW /= 2;
  const int otiles = (O + TW - 1) / TW;
  const int ntiles = nblk * otiles;
#pragma omp for schedule(static)
  for (int t = 0; t < ntiles; ++t) {
    int nbi = t / otiles, oti = t % otiles;
    int n0 = nbi * 4, nb = std::min(4, B - n0);
    int o0 = oti * TW, oc = std::min(TW, O - o0);
    blocked_tile(X, L, Y, n0, nb, o0, oc, relu);
  }
#else
#pragma omp for collapse(2) schedule(static)
  for (int n = 0; n < B; ++n)
    for (int o = 0; o < O; ++o) dense_simd_rows(X, L, Y, n, n + 1, o, o + 1, relu, false);
#endif
}

// Whole MLP forward inside a region. bufA/bufB: B*max_width scratch. Returns logits ptr.
float* mlp_inregion(const Model& M, const float* X, int B, float* bufA, float* bufB, int kernel) {
  const float* in = X;
  float* out = bufA;
  for (size_t l = 0; l < M.layers.size(); ++l) {
    bool last = l + 1 == M.layers.size();
    dense_layer_inregion(in, M.layers[l], out, B, !last, kernel);  // implicit barrier = dependency
    in = out;
    out = (out == bufA) ? bufB : bufA;
  }
  return const_cast<float*>(in);
}

inline int argmax_row(const float* z, int K) {
  int best = 0;
  for (int k = 1; k < K; ++k)
    if (z[k] > z[best]) best = k;  // first max wins, same as torch.argmax on CPU
  return best;
}

// ----------------------------- system state ---------------------------------------
struct Hier {
  int router = -1;
  std::vector<int> spec;                 // model handle per group, -1 = singleton
  std::vector<std::vector<int>> classes; // local -> global label
  float mean = 0, inv_std = 1;
  int max_batch = 0;
  float *X = nullptr, *A = nullptr, *Bf = nullptr, *P = nullptr;  // scratch
  std::vector<int> grp, order, cnt, off;
  int flat = -1;
} H;

void ensure_scratch(int maxB) {
  if (maxB <= H.max_batch) return;
  int w = 784;
  for (auto& m : g_models) w = std::max(w, m.max_width);
  std::free(H.X); std::free(H.A); std::free(H.Bf); std::free(H.P);
  H.X = aligned_floats(size_t(maxB) * 784);
  H.A = aligned_floats(size_t(maxB) * w);
  H.Bf = aligned_floats(size_t(maxB) * w);
  H.P = aligned_floats(size_t(maxB) * 784);
  H.grp.resize(maxB); H.order.resize(maxB);
  H.max_batch = maxB;
}

inline void preprocess_inregion(const uint8_t* x, int B, float* out) {
  const float s = 1.0f / 255.0f, m = H.mean, is = H.inv_std;
  const long N = long(B) * 784;
#pragma omp for simd schedule(static)
  for (long k = 0; k < N; ++k) out[k] = (float(x[k]) * s - m) * is;
}

}  // namespace

// =================================== C API =========================================
extern "C" {

void pfi_set_threads(int t) { omp_set_num_threads(t); }
int pfi_get_threads() { return omp_get_max_threads(); }
void pfi_set_kernel(int k) { g_kernel = k; }
int pfi_has_avx512() {
#ifdef __AVX512F__
  return 1;
#else
  return 0;
#endif
}

int pfi_load_model(const char* path, const int* dims, int ndims) {
  FILE* f = std::fopen(path, "rb");
  if (!f) return -1;
  Model M;
  for (int l = 0; l + 1 < ndims; ++l) {
    Layer L;
    L.I = dims[l]; L.O = dims[l + 1];
    L.W = aligned_floats(size_t(L.O) * L.I);
    L.Wt = aligned_floats(size_t(L.O) * L.I);
    L.b = aligned_floats(L.O);
    if (std::fread(L.W, sizeof(float), size_t(L.O) * L.I, f) != size_t(L.O) * L.I) return -2;
    if (std::fread(L.b, sizeof(float), L.O, f) != size_t(L.O)) return -2;
    for (int o = 0; o < L.O; ++o)
      for (int i = 0; i < L.I; ++i) L.Wt[size_t(i) * L.O + o] = L.W[size_t(o) * L.I + i];
    M.layers.push_back(L);
    M.max_width = std::max(M.max_width, L.O);
  }
  std::fclose(f);
  g_models.push_back(M);
  return int(g_models.size()) - 1;
}

// classes_flat: concatenated global labels; class_off: G+1 offsets; spec: handle or -1
void pfi_setup(int flat, int router, const int* spec, const int* classes_flat, const int* class_off,
               int G, float mean, float stdv, int max_batch) {
  H.flat = flat; H.router = router;
  H.spec.assign(spec, spec + G);
  H.classes.assign(G, {});
  for (int g = 0; g < G; ++g) H.classes[g].assign(classes_flat + class_off[g], classes_flat + class_off[g + 1]);
  H.mean = mean; H.inv_std = 1.0f / stdv;
  H.cnt.assign(G, 0); H.off.assign(G + 1, 0);
  ensure_scratch(max_batch);
}

void pfi_preprocess(const uint8_t* x, int B, float* out) {
#pragma omp parallel
  preprocess_inregion(x, B, out);
}

// Logits of one model on preprocessed input (used by correctness tests).
void pfi_logits(int handle, const float* X, int B, float* logits, int layer_stop) {
  const Model& M = g_models[handle];
  ensure_scratch(B);
  int K = M.layers.back().O;
  float* res = nullptr;
  Model sub = M;
  if (layer_stop > 0 && layer_stop < int(M.layers.size())) { sub.layers.resize(layer_stop); K = sub.layers.back().O; }
#pragma omp parallel
  {
    // when stopping early the last computed layer keeps its ReLU (hidden activation)
    const float* in = X; float* out = H.A;
    for (size_t l = 0; l < sub.layers.size(); ++l) {
      bool relu = l + 1 < M.layers.size();
      dense_layer_inregion(in, sub.layers[l], out, B, relu, g_kernel);
      in = out; out = (out == H.A) ? H.Bf : H.A;
    }
#pragma omp single
    res = const_cast<float*>(in);
  }
  std::memcpy(logits, res, sizeof(float) * size_t(B) * K);
}

// Flat reference, full request: uint8 -> labels. t[0]=preprocess t[1]=forward+argmax
void pfi_flat_predict(const uint8_t* x, int B, int32_t* out, int64_t* t) {
  ensure_scratch(B);
  const Model& M = g_models[H.flat];
  const int K = M.layers.back().O;
  int64_t t0 = now_ns(), t1 = 0;
#pragma omp parallel
  {
    preprocess_inregion(x, B, H.X);
#pragma omp master
    t1 = now_ns();
    float* z = mlp_inregion(M, H.X, B, H.A, H.Bf, g_kernel);
#pragma omp for schedule(static)
    for (int n = 0; n < B; ++n) out[n] = argmax_row(z + size_t(n) * K, K);
  }
  int64_t t2 = now_ns();
  if (t) { t[0] = t1 - t0; t[1] = t2 - t1; t[2] = 0; t[3] = 0; }
}

// Hierarchy, full request in one parallel region.
// t[0]=preprocess t[1]=router(+argmax) t[2]=specialists t[3]=pack/scatter/label-map
void pfi_hier_predict(const uint8_t* x, int B, int32_t* out, int32_t* groups, int64_t* t) {
  ensure_scratch(B);
  const int G = int(H.spec.size());
  const Model& R = g_models[H.router];
  const int KR = R.layers.back().O;
  int64_t tp = 0, tr = 0, tpk = 0;
  int64_t t0 = now_ns();
#pragma omp parallel
  {
    preprocess_inregion(x, B, H.X);
#pragma omp master
    tp = now_ns();
    float* z = mlp_inregion(R, H.X, B, H.A, H.Bf, g_kernel);
#pragma omp for schedule(static)
    for (int n = 0; n < B; ++n) H.grp[n] = argmax_row(z + size_t(n) * KR, KR);
#pragma omp single
    {
      tr = now_ns();
      // stable counting-sort of sample ids by group (B <= 256: serial is cheapest)
      std::fill(H.cnt.begin(), H.cnt.end(), 0);
      for (int n = 0; n < B; ++n) H.cnt[H.grp[n]]++;
      H.off[0] = 0;
      for (int g = 0; g < G; ++g) H.off[g + 1] = H.off[g] + H.cnt[g];
      std::vector<int> pos(H.off.begin(), H.off.end() - 1);
      for (int n = 0; n < B; ++n) H.order[pos[H.grp[n]]++] = n;
    }
    // gather packed inputs (skipped when one group owns the whole batch: zero-copy)
    const bool single_group = B > 0 && H.cnt[H.grp[0]] == B;
    if (!single_group) {
#pragma omp for schedule(static)
      for (int k = 0; k < B; ++k)
        std::memcpy(H.P + size_t(k) * 784, H.X + size_t(H.order[k]) * 784, 784 * sizeof(float));
    }
    const float* packed = single_group ? H.X : H.P;
#pragma omp master
    tpk = now_ns() - tr;
    for (int g = 0; g < G; ++g) {
      const int n = H.cnt[g];
      if (n == 0) continue;
      const int base = H.off[g];
      if (H.spec[g] < 0) {  // singleton group: router decides
#pragma omp for schedule(static)
        for (int k = 0; k < n; ++k) out[H.order[base + k]] = H.classes[g][0];
        continue;
      }
      const Model& S = g_models[H.spec[g]];
      const int K = S.layers.back().O;
      float* zs = mlp_inregion(S, packed + size_t(base) * 784, n, H.A, H.Bf, g_kernel);
#pragma omp for schedule(static)
      for (int k = 0; k < n; ++k)  // local -> global label, scatter to original position
        out[H.order[base + k]] = H.classes[g][argmax_row(zs + size_t(k) * K, K)];
    }
  }
  int64_t t3 = now_ns();
  if (groups) std::memcpy(groups, H.grp.data(), sizeof(int32_t) * B);
  if (t) { t[0] = tp - t0; t[1] = tr - tp; t[3] = tpk; t[2] = (t3 - tr) - tpk; }
}

// Pieces used by the MPI coordinator / workers (input already preprocessed).
void pfi_route(const float* X, int B, int32_t* groups) {
  ensure_scratch(B);
  const Model& R = g_models[H.router];
  const int K = R.layers.back().O;
#pragma omp parallel
  {
    float* z = mlp_inregion(R, X, B, H.A, H.Bf, g_kernel);
#pragma omp for schedule(static)
    for (int n = 0; n < B; ++n) groups[n] = argmax_row(z + size_t(n) * K, K);
  }
}

void pfi_spec_predict(int g, const float* X, int B, int32_t* labels) {
  if (B <= 0) return;
  ensure_scratch(B);
  if (H.spec[g] < 0) { for (int n = 0; n < B; ++n) labels[n] = H.classes[g][0]; return; }
  const Model& S = g_models[H.spec[g]];
  const int K = S.layers.back().O;
#pragma omp parallel
  {
    float* z = mlp_inregion(S, X, B, H.A, H.Bf, g_kernel);
#pragma omp for schedule(static)
    for (int n = 0; n < B; ++n) labels[n] = H.classes[g][argmax_row(z + size_t(n) * K, K)];
  }
}

// Ablation driver: run one dense layer `reps` times with kernel k, writing per-rep ns.
// threads==0 -> no parallel region at all (pure single-thread code path).
void pfi_bench_dense(int k, int threads, const float* X, int handle, int layer, float* Y, int B,
                     int reps, int64_t* ns) {
  const Layer& L = g_models[handle].layers[layer];
  for (int r = 0; r < reps; ++r) {
    int64_t t0 = now_ns();
    if (threads == 0) {
      dense_layer_inregion(X, L, Y, B, true, k);  // orphaned omp for -> runs serially
    } else {
#pragma omp parallel num_threads(threads)
      dense_layer_inregion(X, L, Y, B, true, k);
    }
    ns[r] = now_ns() - t0;
  }
}

size_t pfi_scratch_bytes() {
  int w = 784;
  for (auto& m : g_models) w = std::max(w, m.max_width);
  return size_t(H.max_batch) * (784 * 2 + 2 * size_t(w)) * sizeof(float);
}

}  // extern "C"
