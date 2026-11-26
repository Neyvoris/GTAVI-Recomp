# Remaining functions and implementation work

The latest pushed AnyPS5 source is commit `7d69cb0e68` on the fork branch, based on merge `dd95a75a55`. Current `tools/progress.py` reports 18,609/39,467 library inventory entries and 127 shader throw sites. The older selected-library subset scan below has a narrower scope.

| Library / area | Current metric | Remaining by this metric |
|---|---:|---:|
| Selected libraries combined (earlier subset scan) | 2,959 / 4,240 (69.79%) | 1,281 |
| `libSceAgcDriver` | 97 / 167 | 70 |
| `libSceSystemService` | 146 / 617 | 471 |
| `libSceUserService` | 44 / 695 | 651 |
| `libSceSaveData` | 1 / 19 | 18 |
| `libSceAppContent` | 30 / 39 | 9 |
| `libSceSysmodule` | 13 / 21 | 8 |
| `libkernel` | 754 / 800 | 46 |
| `libc` | 1,874 / 1,882 | 8 |
| gfx1013 reference forms | 1,557 / 1,560 | 3 |
| Shader throw sites | 127 | 127 still marked unsupported |

The scanned shader forms are 1,460/1,460 decoded. The instruction-form inventory, decoded-form inventory, and throw-site count have different denominators and must not be added or treated as interchangeable.

Other broad compatibility areas remain outside this checkpoint, including `libSceVideoOut` (78/290), `libSceAudioOut` (78/219), and `libScePad` (56/222) in the prior audit. No full execution of a legally available PS5 homebrew app or correct rendered first frame was achieved.

Names/NIDs and aggregate counters do not establish API ABI or semantics. Remaining functions should be prioritized from public behavioral documentation or focused synthetic tests; don't convert an unknown export into success-returning behavior without an oracle. See [BLOCKERS.md](BLOCKERS.md).

Implemented gfx1013 slices include DS_SRC2 64-bit operations; three scalar buffer stores; three scalar raw-address stores; 26 scalar buffer atomics; and 26 scalar-address atomics. GDS source-2 translation now applies M0-base addressing; ADD U32/U64 are GPU-tested. The remaining three decoded-reference forms are scalar scratch-store DWORD/X2/X4. Guest FLAT_SCRATCH/per-wave scalar scratch mapping is absent; the current Vulkan scratch pool is internal per-invocation storage and cannot safely use the guest SMEM base. Other GDS source-2 opcodes and F64 floating GDS min/max remain unverified or unsupported.

## Latest implemented shader slice

PCK2/PCK4 image stores and mip stores have a verified, bounded path; 15 DS_SRC2 64-bit LDS forms and GDS ADD U32/U64 pass focused 32-lane GPU checks; scalar buffer/raw stores and atomics pass their exact GPU checks. The gfx1013 reference inventory is 1,557/1,560. The 127 unsupported throw-site count is a static source-site count, not unresolved opcodes or runtime failures. Scalar scratch stores, unmeasured image layouts, other GDS DS_SRC2 opcodes, and floating edge cases remain unsupported or unverified.
