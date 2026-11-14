"""Extract per-kernel instruction evidence from the disassembly (build/libpfi_cpu.dis).

For each kernel reports: vector width actually used (xmm/ymm/zmm), FP instruction mix,
and the number of distinct accumulator registers in the hot loop -> evidence for SIMD
and instruction-level-parallelism claims. Writes build/asm_evidence.txt.
"""
import re
import sys
from collections import Counter

dis = open(sys.argv[1] if len(sys.argv) > 1 else "build/libpfi_cpu.dis").read()
blocks = re.split(r"\n(?=[0-9a-f]+ <)", dis)
targets = {
    "K_SCALAR dense_scalar_rows": "dense_scalar_rows",
    "K_SIMD dot_simd (omp simd)": "dot_simd(",
    "K_SIMD_ILP dense_simd_rows (inlined dot_ilp)": "dense_simd_rows",
    "K_BLOCKED micro<4,4,1>": "micro<4, 4, 1>",
    "K_BLOCKED micro<1,4,1> (batch-1, 64 outputs)": "micro<1, 4, 1>",
    "K_BLOCKED micro<1,2,2> (batch-1, i-split ILP)": "micro<1, 2, 2>",
}
out = []
for label, key in targets.items():
    blk = next((b for b in blocks if key in b.split("\n")[0]), None)
    if blk is None:
        out.append(f"{label}: not found (inlined)")
        continue
    lines = blk.split("\n")[1:]
    ops = [l.split("\t")[-1].strip() for l in lines if "\t" in l]
    fp = Counter(o.split()[0] for o in ops if re.match(r"v(fmadd|mul|add)\w*(ps|ss)", o))
    widths = Counter(re.findall(r"%(xmm|ymm|zmm)\d+", " ".join(o for o in ops if re.match(r"v(fmadd|mul|add)", o))))
    # hot loop = the backward jump target region containing the most FP ops
    best = (0, [])
    addrs = [int(l.split(":")[0], 16) for l in lines if re.match(r"\s*[0-9a-f]+:", l)]
    for i, l in enumerate(lines):
        m = re.search(r"\tj\w+\s+([0-9a-f]+) <", l)
        if not m:
            continue
        tgt, here = int(m.group(1), 16), int(l.split(":")[0], 16)
        if tgt >= here:
            continue
        body = [x for x in lines if re.match(r"\s*[0-9a-f]+:", x) and tgt <= int(x.split(":")[0], 16) <= here]
        nfp = sum(1 for x in body if re.search(r"\tv(fmadd|add|mul)\w*[ps][sd]\s", x))
        if nfp > best[0]:
            best = (nfp, body)
    acc = set()
    for x in best[1]:
        m = re.search(r"\tv(fmadd\d+[ps]s|add[ps]s)\s+.*,(%[xyz]mm\d+)$", x.strip()) or \
            re.search(r"v(fmadd\d+[ps]s|add[ps]s)\s+.*,(%[xyz]mm\d+)\s*$", x)
        if m:
            acc.add(m.group(2))
    out.append(f"== {label}\n   FP instruction mix: {dict(fp)}\n   register widths in FP ops: {dict(widths)}\n"
               f"   hot loop: {len(best[1])} instructions, {best[0]} vector FP ops, "
               f"distinct accumulator destinations: {len(acc)} {sorted(acc)}")
    out.append("   hot loop listing:\n" + "\n".join("     " + x.strip() for x in best[1][:40]))
txt = "\n".join(out)
open("build/asm_evidence.txt", "w").write(txt + "\n")
print(txt)
