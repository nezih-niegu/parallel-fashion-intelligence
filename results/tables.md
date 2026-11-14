## End-to-end response time (us), median / p95 / p99 with 95% bootstrap CI

| config | B | p50 | p95 | p99 | img/s at p50 |
|---|---|---|---|---|---|
| flat_custom_T1 | 1 | 14.3 [14.3, 14.3] | 22.2 [21.3, 23.0] | 44.7 [42.6, 48.0] | 70067 |
| flat_custom_T1 | 64 | 502.1 [499.2, 505.8] | 560.2 [549.6, 575.1] | 600.0 [585.0, 617.6] | 127460 |
| flat_custom_T1 | 256 | 2180.7 [2172.6, 2187.8] | 2345.7 [2309.1, 2417.3] | 2631.5 [2521.1, 2683.4] | 117395 |
| flat_custom_T1_ndpointer | 1 | 22.2 [22.1, 22.4] | 47.7 [44.2, 50.4] | 96.5 [83.6, 114.1] | 44944 |
| flat_custom_T1_ndpointer | 64 | 515.6 [509.5, 517.7] | 759.7 [734.7, 776.7] | 858.4 [798.4, 1452.9] | 124120 |
| flat_custom_T1_ndpointer | 256 | 2177.3 [2154.9, 2190.7] | 2368.9 [2335.9, 2458.8] | 2588.2 [2511.8, 3035.1] | 117578 |
| flat_custom_T1_scalar | 1 | 143.4 [143.3, 143.6] | 182.3 [180.2, 185.6] | 235.6 [224.0, 250.6] | 6972 |
| flat_custom_T1_scalar | 64 | 8967.3 [8313.3, 9066.3] | 9542.6 [9440.5, 9646.6] | 11374.7 [10270.1, 12476.0] | 7137 |
| flat_custom_T1_scalar | 256 | 35510.9 [34106.5, 36206.1] | 38558.7 [38128.6, 38809.7] | 39593.4 [39129.6, 41021.5] | 7209 |
| flat_custom_T1_simd | 1 | 25.2 [25.2, 25.2] | 35.2 [33.8, 36.4] | 56.5 [53.3, 57.9] | 39634 |
| flat_custom_T1_simd | 64 | 1557.8 [1548.6, 1567.4] | 1744.6 [1683.2, 1818.1] | 2315.0 [2019.3, 2496.4] | 41085 |
| flat_custom_T1_simd | 256 | 5324.3 [5269.3, 5490.8] | 6417.3 [6338.6, 6535.9] | 7397.8 [6767.8, 9875.4] | 48081 |
| flat_custom_T1_simd_ilp | 1 | 14.2 [14.1, 14.2] | 20.1 [19.1, 21.3] | 38.5 [36.5, 40.7] | 70477 |
| flat_custom_T1_simd_ilp | 64 | 856.1 [851.5, 860.5] | 919.6 [909.6, 930.0] | 988.1 [937.0, 1159.7] | 74755 |
| flat_custom_T1_simd_ilp | 256 | 3230.4 [3218.2, 3242.5] | 3553.1 [3533.9, 3564.0] | 3693.1 [3605.8, 4020.5] | 79247 |
| flat_custom_T2 | 1 | 12.8 [12.7, 12.8] | 17.5 [17.1, 18.0] | 34.9 [31.5, 38.0] | 78327 |
| flat_custom_T2 | 64 | 251.0 [249.0, 252.6] | 340.4 [331.0, 354.3] | 388.1 [359.8, 423.5] | 254985 |
| flat_custom_T2 | 256 | 1013.8 [1011.5, 1017.1] | 1208.0 [1173.3, 1236.0] | 1383.4 [1273.7, 1496.4] | 252527 |
| flat_custom_T4 | 1 | 123.7 [123.4, 123.9] | 159.8 [157.8, 161.6] | 215.2 [196.9, 243.1] | 8087 |
| flat_custom_T4 | 64 | 366.2 [361.8, 369.6] | 577.7 [548.0, 604.2] | 1069.2 [648.5, 1267.7] | 174767 |
| flat_custom_T4 | 256 | 1157.4 [1151.3, 1166.8] | 1791.6 [1751.8, 1837.5] | 2022.4 [1920.1, 2091.2] | 221180 |
| flat_torch_T1 | 1 | 61.5 [61.3, 61.9] | 137.4 [134.2, 141.6] | 206.5 [192.5, 223.8] | 16251 |
| flat_torch_T1 | 64 | 441.7 [434.1, 448.9] | 648.4 [630.3, 666.2] | 767.4 [706.0, 824.5] | 144906 |
| flat_torch_T1 | 256 | 1192.9 [1182.0, 1210.5] | 1670.3 [1624.7, 1704.0] | 1858.6 [1758.9, 2070.3] | 214603 |
| flat_torch_T2 | 1 | 55.9 [55.8, 56.0] | 100.1 [97.4, 102.2] | 125.7 [122.5, 128.9] | 17893 |
| flat_torch_T2 | 64 | 306.8 [299.8, 313.7] | 958.8 [902.0, 1024.8] | 1211.7 [1092.2, 1463.7] | 208575 |
| flat_torch_T2 | 256 | 857.0 [849.0, 867.3] | 1033.5 [1000.3, 1058.0] | 1140.8 [1109.2, 1312.8] | 298722 |
| flat_torch_T4 | 1 | 182.4 [182.0, 183.1] | 287.8 [273.7, 299.1] | 401.9 [382.8, 420.5] | 5482 |
| flat_torch_T4 | 64 | 655.6 [651.2, 660.0] | 807.8 [775.6, 842.5] | 980.3 [873.9, 1051.4] | 97626 |
| flat_torch_T4 | 256 | 1357.2 [1350.3, 1363.1] | 1658.4 [1599.3, 1731.8] | 2107.1 [1798.9, 3099.0] | 188627 |
| hier_custom_T1 | 1 | 10.5 [10.4, 10.5] | 17.6 [17.1, 18.3] | 42.4 [38.6, 48.8] | 95625 |
| hier_custom_T1 | 64 | 276.6 [273.1, 279.4] | 328.3 [322.1, 338.2] | 367.7 [350.4, 515.3] | 231415 |
| hier_custom_T1 | 256 | 1115.6 [1109.4, 1119.2] | 1657.4 [1448.2, 1809.8] | 2893.9 [2684.3, 2961.4] | 229477 |
| hier_custom_T1_ndpointer | 1 | 20.5 [20.3, 20.6] | 38.4 [35.7, 40.8] | 69.9 [65.6, 74.8] | 48798 |
| hier_custom_T1_ndpointer | 64 | 288.6 [284.8, 292.2] | 371.1 [361.4, 385.4] | 453.4 [411.1, 466.9] | 221780 |
| hier_custom_T1_ndpointer | 256 | 1144.3 [1135.7, 1149.0] | 1739.0 [1383.1, 1871.3] | 1969.9 [1930.9, 2004.1] | 223717 |
| hier_custom_T1_scalar | 1 | 72.0 [70.8, 73.7] | 129.0 [126.1, 134.6] | 270.9 [230.3, 288.2] | 13891 |
| hier_custom_T1_scalar | 64 | 4444.6 [4424.4, 4467.5] | 4855.3 [4787.9, 4917.8] | 5162.9 [4997.8, 6083.9] | 14399 |
| hier_custom_T1_scalar | 256 | 15975.8 [15746.5, 16177.2] | 18971.4 [18794.5, 19164.8] | 20889.3 [19536.8, 23674.2] | 16024 |
| hier_custom_T1_simd | 1 | 14.3 [14.0, 14.4] | 21.5 [20.7, 22.2] | 43.3 [38.8, 46.5] | 70126 |
| hier_custom_T1_simd | 64 | 635.1 [626.0, 640.9] | 803.5 [793.5, 836.7] | 928.9 [861.6, 949.0] | 100771 |
| hier_custom_T1_simd | 256 | 2888.4 [2837.4, 2905.2] | 4612.3 [4507.1, 4726.6] | 4864.1 [4765.0, 4905.3] | 88631 |
| hier_custom_T1_simd_ilp | 1 | 10.9 [10.8, 11.0] | 17.7 [17.3, 18.4] | 38.4 [33.9, 41.4] | 91550 |
| hier_custom_T1_simd_ilp | 64 | 403.5 [399.4, 408.8] | 482.1 [465.0, 526.3] | 639.1 [562.7, 660.1] | 158602 |
| hier_custom_T1_simd_ilp | 256 | 1482.9 [1468.6, 1497.1] | 1828.0 [1770.9, 1863.0] | 1952.0 [1872.6, 2310.9] | 172633 |
| hier_custom_T2 | 1 | 15.7 [15.6, 15.8] | 24.1 [23.2, 25.2] | 60.0 [52.2, 65.0] | 63773 |
| hier_custom_T2 | 64 | 171.9 [170.3, 173.5] | 270.7 [249.9, 288.6] | 330.9 [306.2, 368.5] | 372296 |
| hier_custom_T2 | 256 | 632.4 [628.8, 634.6] | 962.2 [933.6, 992.8] | 1836.8 [1052.4, 3554.2] | 404827 |
| hier_custom_T4 | 1 | 184.0 [183.3, 184.7] | 228.7 [226.4, 231.2] | 277.5 [261.5, 309.3] | 5434 |
| hier_custom_T4 | 64 | 487.3 [484.5, 490.4] | 625.1 [585.1, 649.0] | 687.7 [663.9, 703.4] | 131324 |
| hier_custom_T4 | 256 | 897.6 [893.8, 907.8] | 1192.3 [1072.7, 1216.0] | 1503.9 [1275.1, 3062.2] | 285211 |
| hier_torch_T1 | 1 | 106.5 [105.6, 107.3] | 190.7 [187.5, 194.4] | 267.5 [251.2, 289.0] | 9391 |
| hier_torch_T1 | 64 | 579.0 [565.1, 590.0] | 814.1 [783.9, 840.4] | 965.8 [863.0, 1240.0] | 110529 |
| hier_torch_T1 | 256 | 1329.5 [1308.0, 1350.8] | 1710.8 [1649.7, 1743.0] | 1926.0 [1807.1, 2080.1] | 192549 |
| hier_torch_T2 | 1 | 113.0 [112.2, 113.9] | 194.7 [190.1, 198.4] | 287.6 [267.7, 298.2] | 8850 |
| hier_torch_T2 | 64 | 524.3 [517.0, 533.5] | 790.4 [747.5, 823.2] | 1037.7 [863.7, 1134.2] | 122067 |
| hier_torch_T2 | 256 | 1109.6 [1095.3, 1128.2] | 1546.5 [1500.2, 1606.3] | 1748.0 [1682.8, 1906.6] | 230720 |
| hier_torch_T4 | 1 | 229.6 [227.0, 232.2] | 342.7 [335.9, 348.0] | 629.3 [562.6, 699.9] | 4356 |
| hier_torch_T4 | 64 | 1045.1 [1040.2, 1052.2] | 1461.0 [1317.7, 1706.1] | 2779.9 [2010.6, 3405.7] | 61239 |
| hier_torch_T4 | 256 | 1872.9 [1855.8, 1896.3] | 2912.3 [2740.2, 3098.8] | 4148.6 [3353.7, 4756.4] | 136686 |

## Speedups (ratio of the statistic, 95% CI)

| comparison | p50 | p95 | p99 |
|---|---|---|---|
| S_backend|flat|T1|B1 | 4.31x [4.29, 4.34] faster | 6.18x [5.93, 6.51] | 4.62x [4.20, 5.05] |
| S_backend|hier|T1|B1 | 10.18x [10.08, 10.28] faster | 10.84x [10.35, 11.24] | 6.30x [5.42, 7.06] |
| S_system|torch|T1|B1 | 0.58x [0.57, 0.58] within run-to-run variation | 0.72x [0.70, 0.75] | 0.77x [0.69, 0.85] |
| S_system|custom|T1|B1 | 1.36x [1.36, 1.37] within run-to-run variation | 1.26x [1.19, 1.32] | 1.05x [0.91, 1.19] |
| S_backend|flat|T1|B64 | 0.88x [0.86, 0.89] within run-to-run variation | 1.16x [1.11, 1.20] | 1.28x [1.16, 1.38] |
| S_backend|hier|T1|B64 | 2.09x [2.04, 2.14] faster | 2.48x [2.36, 2.58] | 2.63x [1.70, 3.49] |
| S_system|torch|T1|B64 | 0.76x [0.74, 0.79] within run-to-run variation | 0.80x [0.76, 0.84] | 0.79x [0.59, 0.92] |
| S_system|custom|T1|B64 | 1.82x [1.79, 1.84] faster | 1.71x [1.65, 1.76] | 1.63x [1.15, 1.75] |
| S_backend|flat|T1|B256 | 0.55x [0.54, 0.56] slower | 0.71x [0.68, 0.73] | 0.71x [0.66, 0.81] |
| S_backend|hier|T1|B256 | 1.19x [1.17, 1.21] within run-to-run variation | 1.03x [0.93, 1.19] | 0.67x [0.62, 0.87] |
| S_system|torch|T1|B256 | 0.90x [0.88, 0.92] within run-to-run variation | 0.98x [0.94, 1.02] | 0.97x [0.86, 1.13] |
| S_system|custom|T1|B256 | 1.95x [1.95, 1.97] faster | 1.42x [1.29, 1.64] | 0.91x [0.86, 1.01] |
| S_backend|flat|T2|B1 | 4.38x [4.36, 4.39] faster | 5.72x [5.47, 5.89] | 3.60x [3.28, 4.00] |
| S_backend|hier|T2|B1 | 7.21x [7.14, 7.27] faster | 8.06x [7.71, 8.42] | 4.80x [4.30, 5.57] |
| S_system|torch|T2|B1 | 0.49x [0.49, 0.50] slower | 0.51x [0.50, 0.53] | 0.44x [0.42, 0.48] |
| S_system|custom|T2|B1 | 0.81x [0.81, 0.82] slower | 0.72x [0.69, 0.76] | 0.58x [0.51, 0.69] |
| S_backend|flat|T2|B64 | 1.22x [1.19, 1.26] within run-to-run variation | 2.82x [2.60, 3.04] | 3.12x [2.74, 3.92] |
| S_backend|hier|T2|B64 | 3.05x [3.00, 3.11] faster | 2.92x [2.66, 3.19] | 3.14x [2.47, 3.55] |
| S_system|torch|T2|B64 | 0.59x [0.57, 0.60] within run-to-run variation | 1.21x [1.12, 1.34] | 1.17x [1.00, 1.47] |
| S_system|custom|T2|B64 | 1.46x [1.44, 1.48] within run-to-run variation | 1.26x [1.18, 1.38] | 1.17x [1.00, 1.33] |
| S_backend|flat|T2|B256 | 0.85x [0.84, 0.86] within run-to-run variation | 0.86x [0.82, 0.89] | 0.82x [0.75, 1.00] |
| S_backend|hier|T2|B256 | 1.75x [1.73, 1.79] faster | 1.61x [1.54, 1.69] | 0.95x [0.48, 1.66] |
| S_system|torch|T2|B256 | 0.77x [0.76, 0.79] slower | 0.67x [0.63, 0.70] | 0.65x [0.59, 0.77] |
| S_system|custom|T2|B256 | 1.60x [1.60, 1.61] within run-to-run variation | 1.26x [1.21, 1.31] | 0.75x [0.36, 1.32] |
| S_backend|flat|T4|B1 | 1.48x [1.47, 1.48] faster | 1.80x [1.71, 1.88] | 1.87x [1.65, 2.05] |
| S_backend|hier|T4|B1 | 1.25x [1.23, 1.26] faster | 1.50x [1.46, 1.53] | 2.27x [1.90, 2.58] |
| S_system|torch|T4|B1 | 0.79x [0.79, 0.80] slower | 0.84x [0.80, 0.88] | 0.64x [0.57, 0.72] |
| S_system|custom|T4|B1 | 0.67x [0.67, 0.68] slower | 0.70x [0.69, 0.71] | 0.78x [0.67, 0.88] |
| S_backend|flat|T4|B64 | 1.79x [1.77, 1.82] faster | 1.40x [1.31, 1.50] | 0.92x [0.74, 1.51] |
| S_backend|hier|T4|B64 | 2.14x [2.13, 2.16] faster | 2.34x [2.09, 2.77] | 4.04x [2.94, 5.07] |
| S_system|torch|T4|B64 | 0.63x [0.62, 0.63] slower | 0.55x [0.46, 0.62] | 0.35x [0.28, 0.50] |
| S_system|custom|T4|B64 | 0.75x [0.74, 0.76] slower | 0.92x [0.87, 1.00] | 1.55x [0.95, 1.89] |
| S_backend|flat|T4|B256 | 1.17x [1.16, 1.18] within run-to-run variation | 0.93x [0.89, 0.98] | 1.04x [0.87, 1.59] |
| S_backend|hier|T4|B256 | 2.09x [2.06, 2.11] faster | 2.44x [2.30, 2.75] | 2.76x [1.25, 3.62] |
| S_system|torch|T4|B256 | 0.72x [0.72, 0.73] slower | 0.57x [0.53, 0.61] | 0.51x [0.38, 0.81] |
| S_system|custom|T4|B256 | 1.29x [1.27, 1.30] faster | 1.50x [1.46, 1.67] | 1.34x [0.64, 1.60] |
| S_overall(flat torch / hier custom)|T1|B1 | 5.88x [5.84, 5.93] faster | 7.81x [7.46, 8.13] | 4.87x [4.22, 5.48] |
| S_overall(flat torch / hier custom)|T1|B64 | 1.60x [1.56, 1.63] faster | 1.98x [1.89, 2.05] | 2.09x [1.44, 2.26] |
| S_overall(flat torch / hier custom)|T1|B256 | 1.07x [1.06, 1.09] within run-to-run variation | 1.01x [0.91, 1.16] | 0.64x [0.61, 0.76] |
| S_overall(flat torch / hier custom)|T2|B1 | 3.56x [3.55, 3.58] faster | 4.14x [3.96, 4.32] | 2.10x [1.92, 2.42] |
| S_overall(flat torch / hier custom)|T2|B64 | 1.78x [1.74, 1.83] faster | 3.54x [3.26, 3.95] | 3.66x [3.10, 4.46] |
| S_overall(flat torch / hier custom)|T2|B256 | 1.36x [1.34, 1.37] within run-to-run variation | 1.07x [1.02, 1.12] | 0.62x [0.31, 1.11] |

## Thread scaling L(T=1)/L(T)

| config | p50 | verdict |
|---|---|---|
| flat|torch|T2|B1 | 1.10x [1.10, 1.11] | within run-to-run variation |
| flat|torch|T2|B64 | 1.44x [1.40, 1.48] | within run-to-run variation |
| flat|torch|T2|B256 | 1.39x [1.37, 1.42] | faster |
| flat|torch|T4|B1 | 0.34x [0.34, 0.34] | slower |
| flat|torch|T4|B64 | 0.67x [0.66, 0.69] | slower |
| flat|torch|T4|B256 | 0.88x [0.87, 0.89] | within run-to-run variation |
| flat|custom|T2|B1 | 1.12x [1.11, 1.12] | within run-to-run variation |
| flat|custom|T2|B64 | 2.00x [1.98, 2.02] | faster |
| flat|custom|T2|B256 | 2.15x [2.14, 2.16] | faster |
| flat|custom|T4|B1 | 0.12x [0.12, 0.12] | slower |
| flat|custom|T4|B64 | 1.37x [1.35, 1.39] | faster |
| flat|custom|T4|B256 | 1.88x [1.87, 1.90] | faster |
| hier|torch|T2|B1 | 0.94x [0.93, 0.95] | within run-to-run variation |
| hier|torch|T2|B64 | 1.10x [1.07, 1.13] | within run-to-run variation |
| hier|torch|T2|B256 | 1.20x [1.17, 1.22] | within run-to-run variation |
| hier|torch|T4|B1 | 0.46x [0.46, 0.47] | slower |
| hier|torch|T4|B64 | 0.55x [0.54, 0.56] | slower |
| hier|torch|T4|B256 | 0.71x [0.70, 0.72] | slower |
| hier|custom|T2|B1 | 0.67x [0.66, 0.67] | slower |
| hier|custom|T2|B64 | 1.61x [1.59, 1.63] | within run-to-run variation |
| hier|custom|T2|B256 | 1.76x [1.75, 1.78] | faster |
| hier|custom|T4|B1 | 0.06x [0.06, 0.06] | slower |
| hier|custom|T4|B64 | 0.57x [0.56, 0.57] | slower |
| hier|custom|T4|B256 | 1.24x [1.23, 1.25] | within run-to-run variation |

## Dense-kernel ablation (784->256 + bias + ReLU)

| variant | B | p50 us [CI] | p99 us | GFLOP/s | weight GB/s |
|---|---|---|---|---|---|
| blocked_1T | B1 | 8.25 [8.25, 8.25] | 20.54 | 48.6 | 97.3 |
| blocked_1T | B64 | 329.18 [328.34, 329.76] | 526.64 | 78.0 | 2.4 |
| blocked_1T | B256 | 1259.32 [1247.71, 1273.76] | 2730.39 | 81.6 | 0.6 |
| blocked_omp_1T | B1 | 8.87 [8.86, 8.87] | 28.66 | 45.3 | 90.5 |
| blocked_omp_1T | B64 | 372.53 [367.86, 376.95] | 777.54 | 69.0 | 2.2 |
| blocked_omp_1T | B256 | 1608.72 [1605.69, 1614.83] | 2457.51 | 63.9 | 0.5 |
| blocked_omp_2T | B1 | 6.29 [6.27, 6.30] | 25.10 | 63.8 | 127.7 |
| blocked_omp_2T | B64 | 209.46 [208.59, 210.87] | 870.07 | 122.6 | 3.8 |
| blocked_omp_2T | B256 | 834.06 [829.65, 838.42] | 1319.89 | 123.2 | 1.0 |
| blocked_omp_4T | B1 | 59.51 [59.28, 59.70] | 113.62 | 6.7 | 13.5 |
| blocked_omp_4T | B64 | 257.43 [256.32, 258.84] | 413.64 | 99.8 | 3.1 |
| blocked_omp_4T | B256 | 880.56 [874.29, 884.25] | 1557.55 | 116.7 | 0.9 |
| scalar_1T | B1 | 118.38 [117.86, 118.42] | 162.56 | 3.4 | 6.8 |
| scalar_1T | B64 | 7751.35 [7739.99, 7763.92] | 13027.20 | 3.3 | 0.1 |
| scalar_1T | B256 | 27220.77 [25806.06, 28140.23] | 36512.84 | 3.8 | 0.0 |
| simd_1T | B1 | 17.95 [17.94, 17.96] | 33.34 | 22.4 | 44.7 |
| simd_1T | B64 | 960.76 [958.87, 963.61] | 1331.19 | 26.7 | 0.8 |
| simd_1T | B256 | 3855.10 [3842.07, 3869.61] | 6835.17 | 26.7 | 0.2 |
| simd_ilp_1T | B1 | 11.82 [11.80, 11.84] | 25.96 | 33.9 | 67.9 |
| simd_ilp_1T | B64 | 660.71 [656.15, 664.06] | 912.65 | 38.9 | 1.2 |
| simd_ilp_1T | B256 | 2403.60 [2392.79, 2417.88] | 3507.50 | 42.8 | 0.3 |
| simd_omp_1T | B1 | 18.52 [18.52, 18.53] | 36.09 | 21.7 | 43.3 |
| simd_omp_1T | B64 | 1040.32 [1026.07, 1051.12] | 1923.51 | 24.7 | 0.8 |
| simd_omp_1T | B256 | 4075.41 [3997.98, 4131.64] | 8802.27 | 25.2 | 0.2 |
| simd_omp_2T | B1 | 11.03 [11.02, 11.03] | 31.97 | 36.4 | 72.8 |
| simd_omp_2T | B64 | 635.75 [633.62, 638.32] | 972.78 | 40.4 | 1.3 |
| simd_omp_2T | B256 | 2443.23 [2375.25, 2472.52] | 3532.42 | 42.1 | 0.3 |
| simd_omp_4T | B1 | 59.05 [58.90, 59.17] | 111.73 | 6.8 | 13.6 |
| simd_omp_4T | B64 | 689.11 [687.01, 691.19] | 1246.56 | 37.3 | 1.2 |
| simd_omp_4T | B256 | 2616.71 [2609.55, 2635.32] | 4665.66 | 39.3 | 0.3 |
| torch_linear_1T | B1 | 16.18 [16.18, 16.18] | 51.82 | 24.8 | 49.6 |
| torch_linear_1T | B64 | 207.64 [206.10, 209.00] | 298.39 | 123.7 | 3.9 |
| torch_linear_1T | B256 | 830.17 [809.55, 837.24] | 1030.01 | 123.8 | 1.0 |
| torch_linear_2T | B1 | 12.11 [12.10, 12.12] | 39.15 | 33.1 | 66.3 |
| torch_linear_2T | B64 | 131.89 [131.25, 132.68] | 325.84 | 194.8 | 6.1 |
| torch_linear_2T | B256 | 451.04 [447.22, 455.56] | 765.28 | 227.8 | 1.8 |
| torch_linear_4T | B1 | 56.79 [56.66, 56.92] | 167.56 | 7.1 | 14.1 |
| torch_linear_4T | B64 | 190.68 [189.67, 191.92] | 414.28 | 134.7 | 4.2 |
| torch_linear_4T | B256 | 630.93 [627.04, 636.14] | 966.70 | 162.9 | 1.3 |

| step | p50 speedup |
|---|---|
| step scalar_1T->simd_1T|B1 | 6.60x [6.57, 6.60] faster |
| step simd_1T->simd_ilp_1T|B1 | 1.52x [1.52, 1.52] faster |
| step simd_ilp_1T->blocked_1T|B1 | 1.43x [1.43, 1.43] faster |
| step blocked_1T->blocked_omp_2T|B1 | 1.31x [1.31, 1.32] within run-to-run variation |
| cmp simd_omp_1T->simd_omp_2T|B1 | 1.68x [1.68, 1.68] faster |
| cmp blocked_omp_1T->blocked_omp_2T|B1 | 1.41x [1.41, 1.41] faster |
| cmp blocked_omp_2T->blocked_omp_4T|B1 | 0.11x [0.11, 0.11] slower |
| cmp simd_1T->simd_omp_1T|B1 | 0.97x [0.97, 0.97] within run-to-run variation |
| cmp blocked_1T->blocked_omp_1T|B1 | 0.93x [0.93, 0.93] slower |
| cmp torch_linear_1T->blocked_1T|B1 | 1.96x [1.96, 1.96] faster |
| cmp torch_linear_2T->blocked_omp_2T|B1 | 1.93x [1.92, 1.93] faster |
| cmp scalar_1T->blocked_omp_2T|B1 | 18.83x [18.73, 18.88] faster |
| step scalar_1T->simd_1T|B64 | 8.07x [8.04, 8.09] faster |
| step simd_1T->simd_ilp_1T|B64 | 1.45x [1.45, 1.46] faster |
| step simd_ilp_1T->blocked_1T|B64 | 2.01x [1.99, 2.02] faster |
| step blocked_1T->blocked_omp_2T|B64 | 1.57x [1.56, 1.58] within run-to-run variation |
| cmp simd_omp_1T->simd_omp_2T|B64 | 1.64x [1.61, 1.65] faster |
| cmp blocked_omp_1T->blocked_omp_2T|B64 | 1.78x [1.75, 1.80] within run-to-run variation |
| cmp blocked_omp_2T->blocked_omp_4T|B64 | 0.81x [0.81, 0.82] within run-to-run variation |
| cmp simd_1T->simd_omp_1T|B64 | 0.92x [0.91, 0.94] within run-to-run variation |
| cmp blocked_1T->blocked_omp_1T|B64 | 0.88x [0.87, 0.90] within run-to-run variation |
| cmp torch_linear_1T->blocked_1T|B64 | 0.63x [0.63, 0.64] slower |
| cmp torch_linear_2T->blocked_omp_2T|B64 | 0.63x [0.62, 0.63] slower |
| cmp scalar_1T->blocked_omp_2T|B64 | 37.01x [36.76, 37.16] faster |
| step scalar_1T->simd_1T|B256 | 7.06x [6.69, 7.30] faster |
| step simd_1T->simd_ilp_1T|B256 | 1.60x [1.59, 1.61] faster |
| step simd_ilp_1T->blocked_1T|B256 | 1.91x [1.89, 1.93] faster |
| step blocked_1T->blocked_omp_2T|B256 | 1.51x [1.49, 1.53] faster |
| cmp simd_omp_1T->simd_omp_2T|B256 | 1.67x [1.63, 1.72] faster |
| cmp blocked_omp_1T->blocked_omp_2T|B256 | 1.93x [1.92, 1.94] faster |
| cmp blocked_omp_2T->blocked_omp_4T|B256 | 0.95x [0.94, 0.96] within run-to-run variation |
| cmp simd_1T->simd_omp_1T|B256 | 0.95x [0.93, 0.97] within run-to-run variation |
| cmp blocked_1T->blocked_omp_1T|B256 | 0.78x [0.77, 0.79] within run-to-run variation |
| cmp torch_linear_1T->blocked_1T|B256 | 0.66x [0.64, 0.67] slower |
| cmp torch_linear_2T->blocked_omp_2T|B256 | 0.54x [0.54, 0.55] slower |
| cmp scalar_1T->blocked_omp_2T|B256 | 32.64x [30.93, 33.70] faster |

## Kernel choice at system level (custom, 1 thread)

- flat|scalar|B1: p50 143.4 [143.3, 143.6] us, vs scalar 1.00x [1.00, 1.00]
- flat|scalar|B64: p50 8967.3 [8313.3, 9066.3] us, vs scalar 1.00x [1.00, 1.00]
- flat|scalar|B256: p50 35510.9 [34106.5, 36206.1] us, vs scalar 1.00x [1.00, 1.00]
- flat|simd|B1: p50 25.2 [25.2, 25.2] us, vs scalar 5.69x [5.68, 5.69]
- flat|simd|B64: p50 1557.8 [1548.6, 1567.4] us, vs scalar 5.76x [5.33, 5.84]
- flat|simd|B256: p50 5324.3 [5269.3, 5490.8] us, vs scalar 6.67x [6.33, 6.84]
- flat|simd_ilp|B1: p50 14.2 [14.1, 14.2] us, vs scalar 10.11x [10.08, 10.14]
- flat|simd_ilp|B64: p50 856.1 [851.5, 860.5] us, vs scalar 10.47x [9.70, 10.61]
- flat|simd_ilp|B256: p50 3230.4 [3218.2, 3242.5] us, vs scalar 10.99x [10.55, 11.22]
- flat|blocked|B1: p50 14.3 [14.3, 14.3] us, vs scalar 10.05x [10.04, 10.06]
- flat|blocked|B64: p50 502.1 [499.2, 505.8] us, vs scalar 17.86x [16.54, 18.10]
- flat|blocked|B256: p50 2180.7 [2172.6, 2187.8] us, vs scalar 16.28x [15.62, 16.61]
- hier|scalar|B1: p50 72.0 [70.8, 73.7] us, vs scalar 1.00x [1.00, 1.00]
- hier|scalar|B64: p50 4444.6 [4424.4, 4467.5] us, vs scalar 1.00x [1.00, 1.00]
- hier|scalar|B256: p50 15975.8 [15746.5, 16177.2] us, vs scalar 1.00x [1.00, 1.00]
- hier|simd|B1: p50 14.3 [14.0, 14.4] us, vs scalar 5.05x [4.94, 5.19]
- hier|simd|B64: p50 635.1 [626.0, 640.9] us, vs scalar 7.00x [6.92, 7.11]
- hier|simd|B256: p50 2888.4 [2837.4, 2905.2] us, vs scalar 5.53x [5.44, 5.65]
- hier|simd_ilp|B1: p50 10.9 [10.8, 11.0] us, vs scalar 6.59x [6.47, 6.77]
- hier|simd_ilp|B64: p50 403.5 [399.4, 408.8] us, vs scalar 11.01x [10.87, 11.14]
- hier|simd_ilp|B256: p50 1482.9 [1468.6, 1497.1] us, vs scalar 10.77x [10.59, 10.96]
- hier|blocked|B1: p50 10.5 [10.4, 10.5] us, vs scalar 6.88x [6.76, 7.06]
- hier|blocked|B64: p50 276.6 [273.1, 279.4] us, vs scalar 16.07x [15.89, 16.26]
- hier|blocked|B256: p50 1115.6 [1109.4, 1119.2] us, vs scalar 14.32x [14.11, 14.54]

## Stage breakdown at B=1 (median us)

- flat_custom_T1: total_ns=15.0, preprocess_ns=0.5, router_or_forward_ns=10.7, specialists_ns=0.0, pack_scatter_ns=0.0, outside_stages_median_us=3.7, compute_only_median_us=10.7
- flat_custom_T1_ndpointer: total_ns=23.4, preprocess_ns=0.6, router_or_forward_ns=11.5, specialists_ns=0.0, pack_scatter_ns=0.0, outside_stages_median_us=11.4, compute_only_median_us=11.5
- flat_custom_T1_scalar: total_ns=145.1, preprocess_ns=0.6, router_or_forward_ns=139.8, specialists_ns=0.0, pack_scatter_ns=0.0, outside_stages_median_us=5.4, compute_only_median_us=139.8
- flat_custom_T1_simd: total_ns=26.1, preprocess_ns=0.4, router_or_forward_ns=22.4, specialists_ns=0.0, pack_scatter_ns=0.0, outside_stages_median_us=3.2, compute_only_median_us=22.4
- flat_custom_T1_simd_ilp: total_ns=16.2, preprocess_ns=0.4, router_or_forward_ns=12.5, specialists_ns=0.0, pack_scatter_ns=0.0, outside_stages_median_us=3.2, compute_only_median_us=12.5
- flat_custom_T2: total_ns=13.5, preprocess_ns=2.3, router_or_forward_ns=8.0, specialists_ns=0.0, pack_scatter_ns=0.0, outside_stages_median_us=2.9, compute_only_median_us=8.0
- flat_custom_T4: total_ns=125.8, preprocess_ns=39.4, router_or_forward_ns=74.7, specialists_ns=0.0, pack_scatter_ns=0.0, outside_stages_median_us=10.1, compute_only_median_us=74.7
- flat_torch_T1: total_ns=54.5, preprocess_ns=11.5, router_or_forward_ns=37.0, specialists_ns=0.0, pack_scatter_ns=0.0, outside_stages_median_us=5.5, compute_only_median_us=37.0
- flat_torch_T2: total_ns=57.4, preprocess_ns=12.6, router_or_forward_ns=38.4, specialists_ns=0.0, pack_scatter_ns=0.0, outside_stages_median_us=5.7, compute_only_median_us=38.4
- flat_torch_T4: total_ns=182.4, preprocess_ns=22.7, router_or_forward_ns=144.8, specialists_ns=0.0, pack_scatter_ns=0.0, outside_stages_median_us=13.6, compute_only_median_us=144.8
- hier_custom_T1: total_ns=10.7, preprocess_ns=0.5, router_or_forward_ns=2.7, specialists_ns=3.3, pack_scatter_ns=0.3, outside_stages_median_us=4.0, compute_only_median_us=6.1
- hier_custom_T1_ndpointer: total_ns=20.2, preprocess_ns=0.5, router_or_forward_ns=2.8, specialists_ns=3.3, pack_scatter_ns=0.2, outside_stages_median_us=13.2, compute_only_median_us=6.1
- hier_custom_T1_scalar: total_ns=67.8, preprocess_ns=0.5, router_or_forward_ns=29.6, specialists_ns=32.0, pack_scatter_ns=0.2, outside_stages_median_us=3.7, compute_only_median_us=62.6
- hier_custom_T1_simd: total_ns=15.0, preprocess_ns=0.4, router_or_forward_ns=4.8, specialists_ns=5.8, pack_scatter_ns=0.2, outside_stages_median_us=3.3, compute_only_median_us=10.7
- hier_custom_T1_simd_ilp: total_ns=10.8, preprocess_ns=0.4, router_or_forward_ns=2.6, specialists_ns=3.7, pack_scatter_ns=0.2, outside_stages_median_us=3.2, compute_only_median_us=6.7
- hier_custom_T2: total_ns=14.8, preprocess_ns=2.0, router_or_forward_ns=3.7, specialists_ns=4.6, pack_scatter_ns=0.7, outside_stages_median_us=3.9, compute_only_median_us=8.2
- hier_custom_T4: total_ns=174.6, preprocess_ns=31.7, router_or_forward_ns=41.2, specialists_ns=71.0, pack_scatter_ns=21.6, outside_stages_median_us=8.3, compute_only_median_us=112.5
- hier_torch_T1: total_ns=100.8, preprocess_ns=13.0, router_or_forward_ns=23.5, specialists_ns=34.5, pack_scatter_ns=20.3, outside_stages_median_us=8.0, compute_only_median_us=57.3
- hier_torch_T2: total_ns=119.0, preprocess_ns=15.4, router_or_forward_ns=27.3, specialists_ns=41.1, pack_scatter_ns=23.3, outside_stages_median_us=9.8, compute_only_median_us=69.0
- hier_torch_T4: total_ns=237.8, preprocess_ns=19.9, router_or_forward_ns=80.6, specialists_ns=92.0, pack_scatter_ns=32.6, outside_stages_median_us=15.2, compute_only_median_us=168.5

## MPI

- latency|custom|P1|B1: p50 26.8 [26.5, 27.0], p99 85.7 [81.2, 88.8]; rank0 pre_ns=4.2, route_ns=5.1, pack_send_ns=8.1, local_exec_ns=8.3, wait_recv_ns=0.0
- latency|custom|P1|B64: p50 285.0 [282.2, 287.5], p99 403.0 [382.3, 421.6]; rank0 pre_ns=19.9, route_ns=83.4, pack_send_ns=15.3, local_exec_ns=146.3, wait_recv_ns=0.0
- latency|custom|P1|B256: p50 1047.6 [1033.0, 1063.3], p99 2409.2 [2176.3, 2725.1]; rank0 pre_ns=65.1, route_ns=371.3, pack_send_ns=38.1, local_exec_ns=567.3, wait_recv_ns=0.0
- ranks|custom|P1: r0: comm 0.0 ms exec 144.5 ms idle 0.0 ms msgs 0
- throughput|custom|P1: makespan 33.88 ms, 188923 img/s, service p50 0.795 ms, queue p50 16.60 ms
- latency|custom|P2|B1: p50 37.6 [37.4, 37.9], p99 110.4 [101.7, 121.0]; rank0 pre_ns=5.0, route_ns=5.6, pack_send_ns=14.5, local_exec_ns=0.0, wait_recv_ns=8.8
- latency|custom|P2|B64: p50 354.6 [349.8, 357.3], p99 1000.1 [920.7, 1180.3]; rank0 pre_ns=19.1, route_ns=104.0, pack_send_ns=48.4, local_exec_ns=0.0, wait_recv_ns=173.3
- latency|custom|P2|B256: p50 1245.8 [1235.3, 1257.6], p99 2822.1 [2489.6, 3145.4]; rank0 pre_ns=77.8, route_ns=425.9, pack_send_ns=156.6, local_exec_ns=0.0, wait_recv_ns=600.9
- ranks|custom|P2: r0: comm 95.2 ms exec 63.1 ms idle 0.0 ms msgs 1527; r1: comm 23.2 ms exec 87.6 ms idle 336.0 ms msgs 1543
- throughput|custom|P2: makespan 23.68 ms, 270227 img/s, service p50 0.868 ms, queue p50 11.56 ms
- latency|custom|P3|B1: p50 45.6 [45.1, 46.3], p99 137.5 [132.3, 149.2]; rank0 pre_ns=5.6, route_ns=5.7, pack_send_ns=15.1, local_exec_ns=0.0, wait_recv_ns=13.7
- latency|custom|P3|B64: p50 334.6 [329.9, 340.2], p99 591.8 [550.4, 892.4]; rank0 pre_ns=25.8, route_ns=105.9, pack_send_ns=56.9, local_exec_ns=0.0, wait_recv_ns=125.0
- latency|custom|P3|B256: p50 1306.5 [1292.2, 1326.4], p99 2777.4 [2537.4, 3067.2]; rank0 pre_ns=82.3, route_ns=416.9, pack_send_ns=168.9, local_exec_ns=0.0, wait_recv_ns=621.5
- ranks|custom|P3: r0: comm 95.3 ms exec 67.0 ms idle 0.0 ms msgs 1527; r1: comm 26.0 ms exec 58.8 ms idle 358.3 ms msgs 620; r2: comm 46.9 ms exec 35.7 ms idle 357.9 ms msgs 923
- throughput|custom|P3: makespan 24.54 ms, 260783 img/s, service p50 0.973 ms, queue p50 11.97 ms
- latency|custom|P4|B1: p50 55.2 [54.4, 56.1], p99 184.8 [166.0, 200.3]; rank0 pre_ns=6.2, route_ns=6.1, pack_send_ns=16.7, local_exec_ns=0.0, wait_recv_ns=18.0
- latency|custom|P4|B64: p50 434.0 [423.9, 440.6], p99 771.2 [728.6, 1180.3]; rank0 pre_ns=27.4, route_ns=106.4, pack_send_ns=59.2, local_exec_ns=0.0, wait_recv_ns=188.6
- latency|custom|P4|B256: p50 1303.3 [1291.1, 1314.2], p99 2041.1 [1876.4, 2318.4]; rank0 pre_ns=90.6, route_ns=427.9, pack_send_ns=177.9, local_exec_ns=0.0, wait_recv_ns=550.8
- ranks|custom|P4: r0: comm 101.1 ms exec 68.1 ms idle 0.0 ms msgs 1527; r1: comm 29.1 ms exec 68.6 ms idle 364.2 ms msgs 620; r2: comm 14.8 ms exec 14.1 ms idle 423.4 ms msgs 406; r3: comm 19.0 ms exec 27.2 ms idle 438.1 ms msgs 517
- throughput|custom|P4: makespan 30.81 ms, 207731 img/s, service p50 1.197 ms, queue p50 15.54 ms
- S_L|custom|P2|B1: p50 0.71x [0.70, 0.72] slower; p99 0.78x [0.70, 0.85]
- S_L|custom|P2|B64: p50 0.80x [0.79, 0.82] within run-to-run variation; p99 0.40x [0.33, 0.44]
- S_L|custom|P2|B256: p50 0.84x [0.83, 0.86] within run-to-run variation; p99 0.85x [0.73, 1.05]
- S_throughput|custom|P2: S=1.43 [1.06, 1.90] E=0.72 faster
- S_L|custom|P3|B1: p50 0.59x [0.58, 0.60] slower; p99 0.62x [0.56, 0.66]
- S_L|custom|P3|B64: p50 0.85x [0.83, 0.87] within run-to-run variation; p99 0.68x [0.44, 0.74]
- S_L|custom|P3|B256: p50 0.80x [0.79, 0.82] within run-to-run variation; p99 0.87x [0.76, 1.04]
- S_throughput|custom|P3: S=1.38 [0.85, 1.52] E=0.46 no measurable change
- S_L|custom|P4|B1: p50 0.49x [0.48, 0.49] slower; p99 0.46x [0.42, 0.52]
- S_L|custom|P4|B64: p50 0.66x [0.64, 0.67] within run-to-run variation; p99 0.52x [0.33, 0.57]
- S_L|custom|P4|B256: p50 0.80x [0.79, 0.82] within run-to-run variation; p99 1.18x [0.98, 1.43]
- S_throughput|custom|P4: S=1.10 [0.48, 1.44] E=0.27 no measurable change
- latency|torch|P1|B1: p50 112.6 [111.5, 113.6], p99 284.3 [278.4, 296.4]; rank0 pre_ns=18.6, route_ns=30.3, pack_send_ns=12.4, local_exec_ns=45.7, wait_recv_ns=0.0
- latency|torch|P1|B64: p50 561.9 [554.0, 574.7], p99 938.0 [810.7, 1079.8]; rank0 pre_ns=89.7, route_ns=109.9, pack_send_ns=32.4, local_exec_ns=310.2, wait_recv_ns=0.0
- latency|torch|P1|B256: p50 1444.3 [1436.5, 1455.9], p99 2077.9 [2012.8, 2153.1]; rank0 pre_ns=275.1, route_ns=399.9, pack_send_ns=44.6, local_exec_ns=705.7, wait_recv_ns=0.0
- ranks|torch|P1: r0: comm 0.0 ms exec 257.9 ms idle 0.0 ms msgs 0
- throughput|torch|P1: makespan 52.20 ms, 122597 img/s, service p50 1.352 ms, queue p50 26.82 ms
- latency|torch|P2|B1: p50 127.2 [126.3, 128.0], p99 506.6 [465.8, 553.5]; rank0 pre_ns=20.2, route_ns=33.4, pack_send_ns=19.4, local_exec_ns=0.0, wait_recv_ns=48.8
- latency|torch|P2|B64: p50 663.0 [653.1, 670.5], p99 1002.5 [938.4, 1042.9]; rank0 pre_ns=86.1, route_ns=139.7, pack_send_ns=71.0, local_exec_ns=0.0, wait_recv_ns=344.7
- latency|torch|P2|B256: p50 1638.1 [1625.0, 1658.2], p99 3175.6 [2409.6, 3484.6]; rank0 pre_ns=305.8, route_ns=430.5, pack_send_ns=180.8, local_exec_ns=0.0, wait_recv_ns=694.2
- ranks|torch|P2: r0: comm 173.5 ms exec 95.4 ms idle 0.0 ms msgs 1527; r1: comm 30.8 ms exec 155.9 ms idle 378.3 ms msgs 1543
- throughput|torch|P2: makespan 41.46 ms, 154362 img/s, service p50 1.599 ms, queue p50 19.91 ms
- latency|torch|P3|B1: p50 212.0 [208.9, 215.9], p99 749.4 [668.9, 804.8]; rank0 pre_ns=27.1, route_ns=41.2, pack_send_ns=24.4, local_exec_ns=0.0, wait_recv_ns=94.6
- latency|torch|P3|B64: p50 757.6 [748.5, 767.5], p99 1582.9 [1407.1, 1732.9]; rank0 pre_ns=109.6, route_ns=156.8, pack_send_ns=83.4, local_exec_ns=0.0, wait_recv_ns=397.6
- latency|torch|P3|B256: p50 1592.1 [1572.4, 1609.0], p99 3881.8 [2483.3, 6490.8]; rank0 pre_ns=263.3, route_ns=378.2, pack_send_ns=165.9, local_exec_ns=0.0, wait_recv_ns=735.7
- ranks|torch|P3: r0: comm 245.2 ms exec 108.5 ms idle 0.0 ms msgs 1527; r1: comm 32.3 ms exec 112.1 ms idle 599.9 ms msgs 620; r2: comm 51.6 ms exec 110.8 ms idle 580.6 ms msgs 923
- throughput|torch|P3: makespan 53.90 ms, 118743 img/s, service p50 1.999 ms, queue p50 26.89 ms
- latency|torch|P4|B1: p50 253.9 [250.4, 257.8], p99 600.8 [574.2, 637.3]; rank0 pre_ns=34.5, route_ns=46.9, pack_send_ns=28.7, local_exec_ns=0.0, wait_recv_ns=126.3
- latency|torch|P4|B64: p50 793.0 [783.0, 806.4], p99 1229.3 [1167.4, 1305.9]; rank0 pre_ns=124.8, route_ns=174.2, pack_send_ns=95.3, local_exec_ns=0.0, wait_recv_ns=360.0
- latency|torch|P4|B256: p50 1598.6 [1582.5, 1609.0], p99 2059.0 [2007.6, 2172.6]; rank0 pre_ns=288.6, route_ns=391.4, pack_send_ns=176.8, local_exec_ns=0.0, wait_recv_ns=641.4
- ranks|torch|P4: r0: comm 219.7 ms exec 127.8 ms idle 0.0 ms msgs 1527; r1: comm 66.9 ms exec 114.6 ms idle 564.0 ms msgs 620; r2: comm 51.8 ms exec 55.2 ms idle 692.5 ms msgs 406; r3: comm 22.9 ms exec 79.3 ms idle 692.6 ms msgs 517
- throughput|torch|P4: makespan 68.94 ms, 92829 img/s, service p50 2.653 ms, queue p50 34.75 ms
- S_L|torch|P2|B1: p50 0.89x [0.87, 0.90] within run-to-run variation; p99 0.56x [0.51, 0.62]
- S_L|torch|P2|B64: p50 0.85x [0.83, 0.87] within run-to-run variation; p99 0.94x [0.80, 1.12]
- S_L|torch|P2|B256: p50 0.88x [0.87, 0.89] within run-to-run variation; p99 0.65x [0.58, 0.87]
- S_throughput|torch|P2: S=1.26 [1.08, 1.90] E=0.63 faster
- S_L|torch|P3|B1: p50 0.53x [0.52, 0.54] slower; p99 0.38x [0.35, 0.42]
- S_L|torch|P3|B64: p50 0.74x [0.73, 0.76] within run-to-run variation; p99 0.59x [0.49, 0.70]
- S_L|torch|P3|B256: p50 0.91x [0.90, 0.92] within run-to-run variation; p99 0.54x [0.31, 0.84]
- S_throughput|torch|P3: S=0.97 [0.44, 1.40] E=0.32 no measurable change
- S_L|torch|P4|B1: p50 0.44x [0.44, 0.45] slower; p99 0.47x [0.44, 0.50]
- S_L|torch|P4|B64: p50 0.71x [0.69, 0.73] slower; p99 0.76x [0.63, 0.90]
- S_L|torch|P4|B256: p50 0.90x [0.90, 0.92] within run-to-run variation; p99 1.01x [0.94, 1.07]
- S_throughput|torch|P4: S=0.76 [0.65, 1.33] E=0.19 no measurable change
- S_backend|P1|B1: p50 4.21x [4.16, 4.26] faster; p99 3.32x [3.16, 3.54]
- S_backend|P1|B64: p50 1.97x [1.94, 2.02] faster; p99 2.33x [1.97, 2.74]
- S_backend|P1|B256: p50 1.38x [1.36, 1.40] within run-to-run variation; p99 0.86x [0.75, 0.97]
- S_backend|P2|B1: p50 3.38x [3.35, 3.41] faster; p99 4.59x [4.06, 5.27]
- S_backend|P2|B64: p50 1.87x [1.84, 1.90] faster; p99 1.00x [0.81, 1.09]
- S_backend|P2|B256: p50 1.31x [1.30, 1.33] within run-to-run variation; p99 1.13x [0.85, 1.35]
- S_backend|P3|B1: p50 4.65x [4.56, 4.75] faster; p99 5.45x [4.72, 5.96]
- S_backend|P3|B64: p50 2.26x [2.22, 2.31] faster; p99 2.67x [1.71, 3.04]
- S_backend|P3|B256: p50 1.22x [1.19, 1.24] within run-to-run variation; p99 1.40x [0.88, 2.39]
- S_backend|P4|B1: p50 4.60x [4.51, 4.70] faster; p99 3.25x [2.93, 3.65]
- S_backend|P4|B64: p50 1.83x [1.79, 1.88] faster; p99 1.59x [1.02, 1.78]
- S_backend|P4|B256: p50 1.23x [1.21, 1.24] within run-to-run variation; p99 1.01x [0.88, 1.14]
