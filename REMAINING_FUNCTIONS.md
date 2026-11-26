# Remaining functions and implementation work

The tested AnyPS5 source is the fork branch at merge `dd95a75a55`. The current progress scan (`tools/progress.py`, restricted to the named libraries) reports:

| Library / area | Current metric | Remaining by this metric |
|---|---:|---:|
| Selected libraries combined | 2,959 / 4,240 (69.79%) | 1,281 |
| `libSceAgcDriver` | 97 / 167 | 70 |
| `libSceSystemService` | 146 / 617 | 471 |
| `libSceUserService` | 44 / 695 | 651 |
| `libSceSaveData` | 1 / 19 | 18 |
| `libSceAppContent` | 30 / 39 | 9 |
| `libSceSysmodule` | 13 / 21 | 8 |
| `libkernel` | 754 / 800 | 46 |
| `libc` | 1,874 / 1,882 | 8 |
| gfx1013 reference forms | 1,484 / 1,560 | 76 |
| Shader throw sites | 127 | 127 still marked unsupported |

The scanned shader forms are 1,460/1,460 decoded. The instruction-form inventory, decoded-form inventory, and throw-site count have different denominators and must not be added or treated as interchangeable.

Other broad compatibility areas remain outside this checkpoint, including `libSceVideoOut` (78/290), `libSceAudioOut` (78/219), and `libScePad` (56/222) in the prior audit. No full execution of a legally available PS5 homebrew app or correct rendered first frame was achieved.

Names/NIDs and aggregate counters do not establish API ABI or semantics. Remaining functions should be prioritized from public behavioral documentation or focused synthetic tests; don't convert an unknown export into success-returning behavior without an oracle. See [BLOCKERS.md](BLOCKERS.md).

## Latest implemented shader slice

PCK2/PCK4 image store and mip-store opcodes now have a verified, deliberately bounded path (see `IMPLEMENTED_FUNCTIONS.md`). The gfx1013 reference-form counter remains 1,484/1,560 because it measures the pinned LLVM instruction-form inventory and does not count these MIMG opcode cases. The unsupported throw-site counter remains 127; it is a static source-site count, not the number of unresolved opcodes and not a runtime failure count. The new backend still explicitly rejects image shapes, swizzles, and packed formats outside its tested subset.
