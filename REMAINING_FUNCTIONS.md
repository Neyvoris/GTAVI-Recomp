# Remaining functions and implementation work

The latest pushed AnyPS5 source is commit `17f36dc3f6` on the fork branch, based on merge `dd95a75a55`. The current aggregate progress scan reports:

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
| Shader throw sites | 128 | 128 still marked unsupported |

The scanned shader forms are 1,460/1,460 decoded. The instruction-form inventory, decoded-form inventory, and throw-site count have different denominators and must not be added or treated as interchangeable.

Other broad compatibility areas remain outside this checkpoint, including `libSceVideoOut` (78/290), `libSceAudioOut` (78/219), and `libScePad` (56/222) in the prior audit. No full execution of a legally available PS5 homebrew app or correct rendered first frame was achieved.

Names/NIDs and aggregate counters do not establish API ABI or semantics. Remaining functions should be prioritized from public behavioral documentation or focused synthetic tests; don't convert an unknown export into success-returning behavior without an oracle. See [BLOCKERS.md](BLOCKERS.md).

The 15 newly covered gfx1013 forms are the DS_SRC2 64-bit operations; three scalar buffer store forms, three scalar raw-address store forms, 26 scalar buffer atomic forms, and all 26 scalar-address atomic forms are implemented and tested. The three remaining decoded-reference forms are scalar scratch-store DWORD/X2/X4. GDS source-2 behavior and F64 floating edge cases remain outside the verified subset.

## Latest implemented shader slice

PCK2/PCK4 image store and mip-store opcodes have a verified, deliberately bounded path, 15 DS_SRC2 64-bit forms pass a focused 32-lane GPU test, scalar buffer DWORD/X2/X4 and scalar raw DWORD/X2/X4 stores pass exact GPU checks, all scalar buffer and scalar-address atomic DWORD/X2 forms pass on GPU, and the current gfx1013 reference-form inventory is 1,557/1,560 (see `IMPLEMENTED_FUNCTIONS.md`). The unsupported throw-site counter is 128; it is a static source-site count, not the number of unresolved opcodes and not a runtime failure count. Scalar scratch stores, unmeasured image shapes/swizzles, 64-bit DS_SRC2 GDS, and F64 floating edge cases remain unsupported or unverified.
