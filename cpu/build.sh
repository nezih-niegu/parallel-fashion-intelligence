#!/usr/bin/env bash
# Build the custom CPU backend and collect vectorization evidence.
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p build
FLAGS="-O3 -march=native -fopenmp -fPIC -std=c++17 -Wall -Wno-unused-function"
g++ $FLAGS -fopt-info-vec-optimized=build/vec_report.txt -shared -o build/libpfi_cpu.so hpc_cpu.cpp
g++ $FLAGS -S -o build/hpc_cpu.s hpc_cpu.cpp
objdump -d --no-show-raw-insn -C build/libpfi_cpu.so > build/libpfi_cpu.dis
g++ --version | head -1 > build/compiler.txt
echo "built build/libpfi_cpu.so"
python3 asm_evidence.py build/libpfi_cpu.dis > /dev/null
