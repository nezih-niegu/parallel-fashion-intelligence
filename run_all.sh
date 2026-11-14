#!/usr/bin/env bash
# Full benchmark campaign. Every repetition is a fresh process; the repetition index is
# the outer loop so that slow drift of the machine is spread over all configurations.
set -uo pipefail
cd "$(dirname "$0")"
export OMPI_ALLOW_RUN_AS_ROOT=1 OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1
export PYTHONWARNINGS=ignore
REPS=${REPS:-5}
mkdir -p results/raw results/logs
{
  echo "date: $(date -Is)"; lscpu | grep -E "Model name|^CPU\(s\)|Thread|Core|Socket|L1d|L2|L3|Hypervisor"
  echo "governor: $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || echo 'not exposed (KVM guest)')"
  echo "kernel: $(uname -r)"; g++ --version | head -1; python3 --version
  python3 -c "import torch,numpy,mpi4py;print('torch',torch.__version__,'numpy',numpy.__version__,'mpi4py',mpi4py.__version__)"
  mpirun --version | head -1; uptime
} > results/logs/environment.txt 2>&1

mpi_flags() {  # P <= cores: one rank per core, pinned; P > cores: oversubscribed contention runs
  if [ "$1" -le 2 ]; then echo "--map-by core --bind-to core --mca mpi_yield_when_idle 1";
  else echo "--oversubscribe --bind-to none --mca mpi_yield_when_idle 1"; fi
}

for r in $(seq 0 $((REPS-1))); do
  echo "=== repetition $r $(date +%T)"
  for T in 1 2 4; do for s in flat hier; do for b in torch custom; do
    python3 bench.py --system $s --backend $b --threads $T --run $r
  done; done; done
  for s in flat hier; do python3 bench.py --system $s --backend custom --threads 1 --binding ndpointer --run $r; done
  for k in scalar simd simd_ilp; do for s in flat hier; do
    python3 bench.py --system $s --backend custom --threads 1 --kernel $k --run $r
  done; done
  python3 ablation_dense.py --mode custom --run $r > /dev/null
  for T in 1 2 4; do python3 ablation_dense.py --mode torch --threads $T --run $r > /dev/null; done
  for P in 1 2 3 4; do for b in custom torch; do
    timeout 600 mpirun $(mpi_flags $P) -np $P python3 mpi_hier.py --backend $b --mode bench --run $r | cut -c1-120
    timeout 600 mpirun $(mpi_flags $P) -np $P python3 mpi_hier.py --backend $b --mode throughput --run $r | cut -c1-120
  done; done
done
echo "done $(date +%T)"
