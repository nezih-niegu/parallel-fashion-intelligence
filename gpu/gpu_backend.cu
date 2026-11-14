// CUDA + cuDNN inference backend for the flat reference and the hierarchy.
//
// STATUS: compiled (nvcc, cuDNN 9 headers) and link-checked in the development
// environment, which has NO GPU. It has NOT been executed; no GPU number in the report
// is a measurement. Run `./gpu_bench` on a CUDA machine to produce results/raw/gpu_*.csv.
//
// Design (everything below "setup" is untimed and reported as cold-start cost):
//   setup   : upload frozen weights once; build cuDNN descriptors + pick algorithms
//             for every (layer, N) with N in [1, max_batch]; allocate one workspace,
//             all activation buffers and pinned host buffers; create stream + events.
//   request : H2D copy of uint8 images (pinned, async)               [CUDA]
//             preprocess kernel uint8 -> normalized fp32              [custom CUDA]
//             dense layers = 1x1 convolutions N x I x 1 x 1           [cuDNN]
//               hidden: cudnnConvolutionBiasActivationForward (fused bias+ReLU, cuDNN)
//                       or cudnnConvolutionForward + bias_relu kernel  [custom, ablation]
//               last  : cudnnConvolutionForward + bias_argmax kernel   [custom]
//             router -> route_pack kernel: argmax, stable per-group compaction of ids
//             (one block, warp-ballot prefix sums), gather rows into packed buffer
//             mode SYNC   : copy 4 group counts D2H (one mid-request sync) and launch
//                           each specialist on exactly its rows
//             mode SPEC   : no mid-request sync: every specialist runs speculatively on
//                           the whole batch, select kernel keeps the routed result
//             final kernel maps local -> global labels and scatters to input order
//             D2H labels (pinned) + stream sync                       [CUDA]
#include <cuda_runtime.h>
#include <cudnn.h>

#include <algorithm>
#include <chrono>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>
#include <vector>

#define CK(x) do { cudaError_t e_ = (x); if (e_ != cudaSuccess) { \
  std::fprintf(stderr, "CUDA %s at %s:%d\n", cudaGetErrorString(e_), __FILE__, __LINE__); std::exit(1); } } while (0)
#define CD(x) do { cudnnStatus_t s_ = (x); if (s_ != CUDNN_STATUS_SUCCESS) { \
  std::fprintf(stderr, "cuDNN %s at %s:%d\n", cudnnGetErrorString(s_), __FILE__, __LINE__); std::exit(1); } } while (0)

constexpr int MAXB = 256;
constexpr int IN = 784;

// ------------------------------- custom kernels ------------------------------------
__global__ void preprocess_u8(const uint8_t* __restrict x, float* __restrict y, int n, float mean, float inv_std) {
  int k = blockIdx.x * blockDim.x + threadIdx.x;
  if (k < n) y[k] = (float(x[k]) * (1.0f / 255.0f) - mean) * inv_std;
}

// Brief's fused bias + ReLU on the N x O output of a preceding (cuDNN) matmul.
__global__ void bias_relu(float* Z, const float* bias, size_t count, int O) {
  size_t k = size_t(blockIdx.x) * blockDim.x + threadIdx.x;
  if (k < count) { float z = Z[k] + bias[k % O]; Z[k] = z > 0.0f ? z : 0.0f; }
}

// Last layer epilogue: add bias, argmax over K (first max wins, matches torch),
// map local -> global label, scatter to original position order[row]. One warp per row.
__global__ void bias_argmax_scatter(const float* __restrict Z, const float* __restrict bias, int N, int K,
                                    const int* __restrict order, const int* __restrict label_map,
                                    int* __restrict out) {
  int row = blockIdx.x * (blockDim.x / 32) + threadIdx.x / 32;
  int lane = threadIdx.x & 31;
  if (row >= N) return;
  float best = -INFINITY; int arg = 0x7fffffff;
  for (int k = lane; k < K; k += 32) {
    float v = Z[size_t(row) * K + k] + bias[k];
    if (v > best || (v == best && k < arg)) { best = v; arg = k; }
  }
  for (int off = 16; off; off >>= 1) {
    float ob = __shfl_down_sync(0xffffffffu, best, off);
    int oa = __shfl_down_sync(0xffffffffu, arg, off);
    if (ob > best || (ob == best && oa < arg)) { best = ob; arg = oa; }
  }
  if (lane == 0) out[order ? order[row] : row] = label_map ? label_map[arg] : arg;
}

// Router epilogue + stable counting sort by group, single block of 256 threads
// (N <= 256). Produces group[n], counts[G], offsets[G+1], order[k] (sample id at
// packed position k). Stability comes from a block prefix sum over sample index.
template <int G>
__global__ void route_pack(const float* __restrict Z, const float* __restrict bias, int N,
                           int* __restrict group, int* __restrict counts, int* __restrict offsets,
                           int* __restrict order) {
  __shared__ int warp_cnt[G][8];
  __shared__ int base[G + 1];
  int n = threadIdx.x;
  int g = -1;
  if (n < N) {
    float best = Z[n * G] + bias[0]; g = 0;
    for (int k = 1; k < G; ++k) { float v = Z[n * G + k] + bias[k]; if (v > best) { best = v; g = k; } }
    group[n] = g;
  }
  int warp = n / 32, lane = n & 31;
  unsigned lt = (1u << lane) - 1u;
  int rank_in_warp[G];
  for (int k = 0; k < G; ++k) {
    unsigned m = __ballot_sync(0xffffffffu, g == k);
    rank_in_warp[k] = __popc(m & lt);
    if (lane == 0) warp_cnt[k][warp] = __popc(m);
  }
  __syncthreads();
  if (n == 0) {
    int acc = 0;
    for (int k = 0; k < G; ++k) {
      base[k] = acc;
      int c = 0;
      for (int w = 0; w < 8; ++w) { int t = warp_cnt[k][w]; warp_cnt[k][w] = c; c += t; }
      counts[k] = c; offsets[k] = acc; acc += c;
    }
    base[G] = acc; offsets[G] = acc;
  }
  __syncthreads();
  if (g >= 0) order[base[g] + warp_cnt[g][warp] + rank_in_warp[g]] = n;
}

__global__ void gather_rows(const float* __restrict X, const int* __restrict order, float* __restrict P, int N) {
  int row = blockIdx.y;
  if (row >= N) return;
  int src = order[row];
  for (int i = blockIdx.x * blockDim.x + threadIdx.x; i < IN; i += gridDim.x * blockDim.x)
    P[size_t(row) * IN + i] = X[size_t(src) * IN + i];
}

// Singleton group (Bag): router decides, write the label for its packed range.
__global__ void fill_singleton(const int* __restrict order, const int* __restrict offsets, int g, int label,
                               int* __restrict out) {
  int k = offsets[g] + blockIdx.x * blockDim.x + threadIdx.x;
  if (k < offsets[g + 1]) out[order[k]] = label;
}

// Speculative mode: every specialist ran on all N rows; keep the routed one.
__global__ void select_routed(const int* __restrict group, const int* __restrict spec_labels, int N, int G,
                              int* __restrict out) {
  int n = blockIdx.x * blockDim.x + threadIdx.x;
  if (n < N) out[n] = spec_labels[group[n] * MAXB + n];
}

// ------------------------------- cuDNN dense layer ---------------------------------
struct Layer {
  int I, O;
  float *W, *b;
  cudnnFilterDescriptor_t wd;
  cudnnTensorDescriptor_t bd;
  std::vector<cudnnTensorDescriptor_t> xd, yd;    // per N in [1, MAXB]
  std::vector<cudnnConvolutionFwdAlgo_t> algo;    // per N, plain conv
};

struct Net { std::vector<Layer> L; int K; int maxw; };

struct Ctx {
  cudnnHandle_t h;
  cudaStream_t s;
  cudnnConvolutionDescriptor_t conv;
  cudnnActivationDescriptor_t relu, ident;
  void* ws = nullptr; size_t ws_bytes = 0;
  bool fused = true;     // hidden layers: fused cuDNN bias+ReLU vs conv + custom bias_relu
} C;

std::vector<float> read_floats(const std::string& p, size_t n, size_t off) {
  std::vector<float> v(n);
  FILE* f = std::fopen(p.c_str(), "rb");
  if (!f) { std::perror(p.c_str()); std::exit(1); }
  std::fseek(f, long(off * 4), SEEK_SET);
  if (std::fread(v.data(), 4, n, f) != n) { std::fprintf(stderr, "short read %s\n", p.c_str()); std::exit(1); }
  std::fclose(f);
  return v;
}

Net load_net(const std::string& path, const std::vector<int>& dims) {
  Net net; size_t off = 0; net.maxw = 0;
  for (size_t l = 0; l + 1 < dims.size(); ++l) {
    Layer L; L.I = dims[l]; L.O = dims[l + 1];
    auto W = read_floats(path, size_t(L.O) * L.I, off); off += size_t(L.O) * L.I;
    auto b = read_floats(path, L.O, off); off += L.O;
    CK(cudaMalloc(&L.W, W.size() * 4)); CK(cudaMemcpy(L.W, W.data(), W.size() * 4, cudaMemcpyHostToDevice));
    CK(cudaMalloc(&L.b, b.size() * 4)); CK(cudaMemcpy(L.b, b.data(), b.size() * 4, cudaMemcpyHostToDevice));
    CD(cudnnCreateFilterDescriptor(&L.wd));
    CD(cudnnSetFilter4dDescriptor(L.wd, CUDNN_DATA_FLOAT, CUDNN_TENSOR_NCHW, L.O, L.I, 1, 1));
    CD(cudnnCreateTensorDescriptor(&L.bd));
    CD(cudnnSetTensor4dDescriptor(L.bd, CUDNN_TENSOR_NCHW, CUDNN_DATA_FLOAT, 1, L.O, 1, 1));
    L.xd.resize(MAXB + 1); L.yd.resize(MAXB + 1); L.algo.resize(MAXB + 1);
    for (int N = 1; N <= MAXB; ++N) {        // plan construction: untimed setup
      CD(cudnnCreateTensorDescriptor(&L.xd[N]));
      CD(cudnnSetTensor4dDescriptor(L.xd[N], CUDNN_TENSOR_NCHW, CUDNN_DATA_FLOAT, N, L.I, 1, 1));
      CD(cudnnCreateTensorDescriptor(&L.yd[N]));
      CD(cudnnSetTensor4dDescriptor(L.yd[N], CUDNN_TENSOR_NCHW, CUDNN_DATA_FLOAT, N, L.O, 1, 1));
      cudnnConvolutionFwdAlgoPerf_t perf[8]; int got = 0;
      CD(cudnnGetConvolutionForwardAlgorithm_v7(C.h, L.xd[N], L.wd, C.conv, L.yd[N], 8, &got, perf));
      L.algo[N] = perf[0].algo;
      size_t need = 0;
      CD(cudnnGetConvolutionForwardWorkspaceSize(C.h, L.xd[N], L.wd, C.conv, L.yd[N], L.algo[N], &need));
      size_t need2 = 0;  // fused path requires IMPLICIT_PRECOMP_GEMM
      CD(cudnnGetConvolutionForwardWorkspaceSize(C.h, L.xd[N], L.wd, C.conv, L.yd[N],
                                                 CUDNN_CONVOLUTION_FWD_ALGO_IMPLICIT_PRECOMP_GEMM, &need2));
      C.ws_bytes = std::max({C.ws_bytes, need, need2});
    }
    net.maxw = std::max(net.maxw, L.O);
    net.L.push_back(L);
  }
  net.K = dims.back();
  return net;
}

// Forward of all but the last layer's epilogue; returns pre-bias logits buffer.
const float* forward_logits_nobias(const Net& net, const float* X, int N, float* A, float* Bf) {
  const float one = 1.0f, zero = 0.0f;
  const float* in = X; float* out = A;
  for (size_t l = 0; l < net.L.size(); ++l) {
    const Layer& L = net.L[l];
    bool last = l + 1 == net.L.size();
    if (!last && C.fused) {
      CD(cudnnConvolutionBiasActivationForward(C.h, &one, L.xd[N], in, L.wd, L.W, C.conv,
          CUDNN_CONVOLUTION_FWD_ALGO_IMPLICIT_PRECOMP_GEMM, C.ws, C.ws_bytes, &zero, L.yd[N], out,
          L.bd, L.b, C.relu, L.yd[N], out));
    } else {
      CD(cudnnConvolutionForward(C.h, &one, L.xd[N], in, L.wd, L.W, C.conv, L.algo[N], C.ws, C.ws_bytes,
                                 &zero, L.yd[N], out));
      if (!last) {
        size_t cnt = size_t(N) * L.O;
        bias_relu<<<unsigned((cnt + 255) / 256), 256, 0, C.s>>>(out, L.b, cnt, L.O);
      }
    }
    in = out; out = (out == A) ? Bf : A;
  }
  return in;
}

// ---------------------------------- system -----------------------------------------
struct System {
  float mean, inv_std;
  Net flat, router; std::vector<Net> spec; std::vector<int> has_spec;
  std::vector<std::vector<int>> classes;
  int G = 4;
  // device buffers
  uint8_t* d_x; float *d_X, *d_P, *d_A, *d_B; int *d_group, *d_counts, *d_offsets, *d_order, *d_out, *d_maps,
      *d_spec_lab;
  // pinned host
  uint8_t* h_x; int* h_out; int* h_counts;
  cudaEvent_t e0, e1;
};

void alloc_system(System& S) {
  int w = std::max({S.flat.maxw, S.router.maxw, IN});
  for (auto& n : S.spec) w = std::max(w, n.maxw);
  CK(cudaMalloc(&S.d_x, MAXB * IN));
  CK(cudaMalloc(&S.d_X, size_t(MAXB) * IN * 4)); CK(cudaMalloc(&S.d_P, size_t(MAXB) * IN * 4));
  CK(cudaMalloc(&S.d_A, size_t(MAXB) * w * 4)); CK(cudaMalloc(&S.d_B, size_t(MAXB) * w * 4));
  CK(cudaMalloc(&S.d_group, MAXB * 4)); CK(cudaMalloc(&S.d_counts, 8 * 4)); CK(cudaMalloc(&S.d_offsets, 8 * 4));
  CK(cudaMalloc(&S.d_order, MAXB * 4)); CK(cudaMalloc(&S.d_out, MAXB * 4));
  CK(cudaMalloc(&S.d_spec_lab, size_t(S.G) * MAXB * 4));
  std::vector<int> maps(S.G * 4, 0);
  for (int g = 0; g < S.G; ++g) for (size_t k = 0; k < S.classes[g].size(); ++k) maps[g * 4 + k] = S.classes[g][k];
  CK(cudaMalloc(&S.d_maps, maps.size() * 4));
  CK(cudaMemcpy(S.d_maps, maps.data(), maps.size() * 4, cudaMemcpyHostToDevice));
  CK(cudaMallocHost(&S.h_x, MAXB * IN)); CK(cudaMallocHost(&S.h_out, MAXB * 4)); CK(cudaMallocHost(&S.h_counts, 8 * 4));
  CK(cudaMalloc(&C.ws, std::max<size_t>(C.ws_bytes, 256)));
  CK(cudaEventCreate(&S.e0)); CK(cudaEventCreate(&S.e1));
}

// Full request; x is a host pointer to N*784 uint8 (copied into pinned staging, as a
// request would arrive in an ordinary host buffer). Returns labels in out_host.
// dev_ms: device time between events (H2D start -> D2H end).
void predict(System& S, bool hier, bool speculative, const uint8_t* x, int N, int* out_host, float* dev_ms) {
  std::memcpy(S.h_x, x, size_t(N) * IN);
  CK(cudaEventRecord(S.e0, C.s));
  CK(cudaMemcpyAsync(S.d_x, S.h_x, size_t(N) * IN, cudaMemcpyHostToDevice, C.s));
  int cnt = N * IN;
  preprocess_u8<<<(cnt + 255) / 256, 256, 0, C.s>>>(S.d_x, S.d_X, cnt, S.mean, S.inv_std);
  if (!hier) {
    const float* z = forward_logits_nobias(S.flat, S.d_X, N, S.d_A, S.d_B);
    const Layer& Lz = S.flat.L.back();
    bias_argmax_scatter<<<(N + 7) / 8, 256, 0, C.s>>>(z, Lz.b, N, S.flat.K, nullptr, nullptr, S.d_out);
  } else {
    const float* zr = forward_logits_nobias(S.router, S.d_X, N, S.d_A, S.d_B);
    route_pack<4><<<1, 256, 0, C.s>>>(zr, S.router.L.back().b, N, S.d_group, S.d_counts, S.d_offsets, S.d_order);
    if (speculative) {
      for (int g = 0; g < S.G; ++g) {
        if (!S.has_spec[g]) {
          fill_singleton<<<1, 256, 0, C.s>>>(S.d_order, S.d_offsets, g, S.classes[g][0], S.d_spec_lab + g * MAXB);
          continue;
        }
        const float* z = forward_logits_nobias(S.spec[g], S.d_X, N, S.d_A, S.d_B);
        bias_argmax_scatter<<<(N + 7) / 8, 256, 0, C.s>>>(z, S.spec[g].L.back().b, N, S.spec[g].K, nullptr,
                                                           S.d_maps + g * 4, S.d_spec_lab + g * MAXB);
      }
      // the Bag fill above wrote at order[] positions within its own row; select by group
      select_routed<<<(N + 255) / 256, 256, 0, C.s>>>(S.d_group, S.d_spec_lab, N, S.G, S.d_out);
    } else {
      gather_rows<<<dim3(4, N), 256, 0, C.s>>>(S.d_X, S.d_order, S.d_P, N);
      CK(cudaMemcpyAsync(S.h_counts, S.d_counts, S.G * 4, cudaMemcpyDeviceToHost, C.s));
      CK(cudaStreamSynchronize(C.s));          // the one mid-request host sync
      int off = 0;
      for (int g = 0; g < S.G; ++g) {
        int n = S.h_counts[g];
        if (n > 0) {
          if (!S.has_spec[g]) {
            fill_singleton<<<(n + 255) / 256, 256, 0, C.s>>>(S.d_order, S.d_offsets, g, S.classes[g][0], S.d_out);
          } else {
            const float* z = forward_logits_nobias(S.spec[g], S.d_P + size_t(off) * IN, n, S.d_A, S.d_B);
            bias_argmax_scatter<<<(n + 7) / 8, 256, 0, C.s>>>(z, S.spec[g].L.back().b, n, S.spec[g].K,
                                                               S.d_order + off, S.d_maps + g * 4, S.d_out);
          }
        }
        off += n;
      }
    }
  }
  CK(cudaMemcpyAsync(S.h_out, S.d_out, size_t(N) * 4, cudaMemcpyDeviceToHost, C.s));
  CK(cudaEventRecord(S.e1, C.s));
  CK(cudaStreamSynchronize(C.s));
  std::memcpy(out_host, S.h_out, size_t(N) * 4);
  if (dev_ms) CK(cudaEventElapsedTime(dev_ms, S.e0, S.e1));
}

// ---------------------------------- driver -----------------------------------------
// gpu_config.txt (written by export_gpu.py):
//   mean std
//   model <name> <bin path> <ndims> d0 d1 ...
//   group <g> <has_spec> <nclasses> c0 c1 ...
//   test <u8 path> <labels path> <n> ; ref <torch hier preds int32 path> ; seq <bench seq int32 path>
std::vector<uint8_t> read_u8(const std::string& p, size_t n) {
  std::vector<uint8_t> v(n); FILE* f = std::fopen(p.c_str(), "rb");
  if (!f || std::fread(v.data(), 1, n, f) != n) { std::fprintf(stderr, "read %s\n", p.c_str()); std::exit(1); }
  std::fclose(f); return v;
}
std::vector<int> read_i32(const std::string& p, size_t n) {
  std::vector<int> v(n); FILE* f = std::fopen(p.c_str(), "rb");
  if (!f || std::fread(v.data(), 4, n, f) != n) { std::fprintf(stderr, "read %s\n", p.c_str()); std::exit(1); }
  std::fclose(f); return v;
}

int main(int argc, char** argv) {
  std::string cfgp = argc > 1 ? argv[1] : "gpu_config.txt";
  std::string outdir = argc > 2 ? argv[2] : "../results/raw";
  int run = argc > 3 ? std::atoi(argv[3]) : 0;
  using clk = std::chrono::steady_clock;
  auto t_setup0 = clk::now();
  CK(cudaSetDevice(0));
  cudaDeviceProp prop; CK(cudaGetDeviceProperties(&prop, 0));
  CK(cudaStreamCreateWithFlags(&C.s, cudaStreamNonBlocking));
  CD(cudnnCreate(&C.h)); CD(cudnnSetStream(C.h, C.s));
  CD(cudnnCreateConvolutionDescriptor(&C.conv));
  CD(cudnnSetConvolution2dDescriptor(C.conv, 0, 0, 1, 1, 1, 1, CUDNN_CROSS_CORRELATION, CUDNN_DATA_FLOAT));
  CD(cudnnSetConvolutionMathType(C.conv, CUDNN_FMA_MATH));      // FP32 primary: no TF32
  CD(cudnnCreateActivationDescriptor(&C.relu));
  CD(cudnnSetActivationDescriptor(C.relu, CUDNN_ACTIVATION_RELU, CUDNN_NOT_PROPAGATE_NAN, 0.0));

  System S; FILE* f = std::fopen(cfgp.c_str(), "r");
  if (!f) { std::perror(cfgp.c_str()); return 1; }
  float mean, sd; if (std::fscanf(f, "%f %f", &mean, &sd) != 2) return 1;
  S.mean = mean; S.inv_std = 1.0f / sd;
  S.spec.resize(4); S.has_spec.assign(4, 0); S.classes.resize(4);
  char key[64], name[64], path[512];
  std::string test_u8, test_lab, ref_p, seq_p; int ntest = 0;
  while (std::fscanf(f, "%63s", key) == 1) {
    std::string k = key;
    if (k == "model") {
      int nd; if (std::fscanf(f, "%63s %511s %d", name, path, &nd) != 3) return 1;
      std::vector<int> d(nd); for (auto& x : d) if (std::fscanf(f, "%d", &x) != 1) return 1;
      Net n = load_net(path, d); std::string nm = name;
      if (nm == "flat") S.flat = n; else if (nm == "router") S.router = n;
      else { int g = nm[4] - '0'; S.spec[g] = n; S.has_spec[g] = 1; }
    } else if (k == "group") {
      int g, hs, nc; if (std::fscanf(f, "%d %d %d", &g, &hs, &nc) != 3) return 1;
      S.classes[g].resize(nc); for (auto& c : S.classes[g]) if (std::fscanf(f, "%d", &c) != 1) return 1;
    } else if (k == "test") {
      if (std::fscanf(f, "%511s", path) != 1) return 1; test_u8 = path;
      if (std::fscanf(f, "%511s %d", path, &ntest) != 2) return 1; test_lab = path;
    } else if (k == "ref") { if (std::fscanf(f, "%511s", path) != 1) return 1; ref_p = path; }
    else if (k == "seq") { if (std::fscanf(f, "%511s", path) != 1) return 1; seq_p = path; }
  }
  std::fclose(f);
  alloc_system(S);
  double setup_ms = std::chrono::duration<double, std::milli>(clk::now() - t_setup0).count();
  auto X = read_u8(test_u8, size_t(ntest) * IN);
  auto Y = read_i32(test_lab, ntest);
  auto ref = read_i32(ref_p, ntest);
  auto seq = read_i32(seq_p, 1000);
  std::vector<int> out(MAXB);

  // ---- correctness: full test set in batches of 256 (partial last batch), both modes
  for (int spec_mode = 0; spec_mode < 2; ++spec_mode) {
    int mism = 0, correct = 0;
    for (int i = 0; i < ntest; i += MAXB) {
      int n = std::min(MAXB, ntest - i);
      predict(S, true, spec_mode, X.data() + size_t(i) * IN, n, out.data(), nullptr);
      for (int k = 0; k < n; ++k) { mism += out[k] != ref[i + k]; correct += out[k] == Y[i + k]; }
    }
    std::printf("[%s] hierarchy vs torch mismatches=%d accuracy=%.4f\n", spec_mode ? "speculative" : "sync", mism,
                correct / double(ntest));
  }

  // ---- benchmark protocol: 20 warm-up, 1000 x B=1, 100 x B=64 / B=256
  std::vector<uint8_t> bx(size_t(MAXB) * IN);
  std::srand(11);
  struct Cfg { const char* name; bool hier, spec, fused; };
  Cfg cfgs[] = {{"flat_cudnn", false, false, true}, {"hier_cudnn_sync", true, false, true},
                {"hier_cudnn_spec", true, true, true}, {"hier_cudnn_sync_custombias", true, false, false}};
  for (auto& c : cfgs) {
    C.fused = c.fused;
    std::string fn = outdir + "/gpu_" + c.name + "_run" + std::to_string(run) + ".csv";
    FILE* o = std::fopen(fn.c_str(), "w");
    std::fprintf(o, "batch,request,latency_ns,device_ms\n");
    for (int i = 0; i < 20; ++i) predict(S, c.hier, c.spec, X.data() + size_t(seq[i]) * IN, 1, out.data(), nullptr);
    for (int i = 0; i < 1000; ++i) {
      float dm = 0; auto t0 = clk::now();
      predict(S, c.hier, c.spec, X.data() + size_t(seq[i]) * IN, 1, out.data(), &dm);
      long ns = std::chrono::duration_cast<std::chrono::nanoseconds>(clk::now() - t0).count();
      std::fprintf(o, "1,%d,%ld,%.6f\n", i, ns, dm);
    }
    for (int B : {64, 256}) {
      for (int r = -5; r < 100; ++r) {
        for (int k = 0; k < B; ++k) std::memcpy(bx.data() + size_t(k) * IN, X.data() + size_t(std::rand() % ntest) * IN, IN);
        float dm = 0; auto t0 = clk::now();
        predict(S, c.hier, c.spec, bx.data(), B, out.data(), &dm);
        long ns = std::chrono::duration_cast<std::chrono::nanoseconds>(clk::now() - t0).count();
        if (r >= 0) std::fprintf(o, "%d,%d,%ld,%.6f\n", B, r, ns, dm);
      }
    }
    std::fclose(o);
  }
  std::printf("GPU %s, setup (cold start) %.1f ms, workspace %zu bytes\n", prop.name, setup_ms, C.ws_bytes);
  return 0;
}
