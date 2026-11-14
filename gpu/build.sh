#!/usr/bin/env bash
# Build the CUDA/cuDNN backend. Paths default to the pip-installed CUDA 13 / cuDNN 9
# wheels used during development; override CUDA_HOME / CUDNN_HOME on a real system.
set -euo pipefail
cd "$(dirname "$0")"
SP=$(python3 -c "import site;print(site.getsitepackages()[0])")
CUDA_HOME=${CUDA_HOME:-$SP/nvidia/cu13}
CUDNN_HOME=${CUDNN_HOME:-$SP/nvidia/cudnn}
NVCC=${NVCC:-$CUDA_HOME/bin/nvcc}
ARCH=${ARCH:-sm_80}
mkdir -p build
$NVCC -O3 -std=c++17 -arch=$ARCH -lineinfo -Xptxas -v \
  -I"$CUDNN_HOME/include" -I"$CUDA_HOME/include" \
  gpu_backend.cu -o build/gpu_bench \
  -L"$CUDNN_HOME/lib" -L"$CUDA_HOME/lib" -l:libcudnn.so.9 \
  -Xlinker -rpath -Xlinker "$CUDNN_HOME/lib" -Xlinker -rpath -Xlinker "$CUDA_HOME/lib" 2> build/ptxas.txt
echo "built build/gpu_bench (arch $ARCH); ptxas register/smem report in build/ptxas.txt"
# usage: python3 export_gpu.py && ./build/gpu_bench gpu_config.txt ../results/raw <run>
