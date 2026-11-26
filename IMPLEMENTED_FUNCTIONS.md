# Implemented functions

## libkernel

- Added `execl_nid_postfix`, `execle_nid_postfix`, and `execlp_nid_postfix` in `third_party/AnyPS5/core/libs/prx/libkernel/System/src/Process.cpp`, with declarations in `Api.hpp`.
- The Windows path reads the guest System V variadic argument list, including arguments beyond register slots, then forwards to existing `execv`/`execve`/`execvp` paths.
- Backported from public commit `65eaf885f894447d9782f439dcd93e07cdd1cffc`; committed to `Neyvoris/AnyPS5:codex/gtavi-libkernel-exec-variadic` as `97919d82f8456c70bcb7b739b9d418d8c375bba7`.
- Verified: targeted Windows x64 build and CTest `guest_exec_variadic` passed. The test covers ABI register/stack varargs, environment-list handling, and `ENOENT`/`E2BIG`. Successful process replacement and console variadic ABI behavior remain unverified.

## Development tooling delivered

- `scripts/build-anyps5-windows.ps1`: reproducible Windows x64 configure/build/CTest entry point for the full AnyPS5 runtime, recursively initializes the pinned submodules, and enables SPIR-V validation/tests.

## Shader and graphics work in the pinned AnyPS5 branch

- `12d719db7f`: implemented packed MIMG PCK2/PCK4 image stores and mip variants. Execution tests cover stored texels, mip selection, guards, and rejected inputs.
- `bd1983813`: implemented 64-bit LDS `DS_SRC2` operations.
- `8774f2f9b` through `126087d9e`: implemented scalar buffer stores/atomics and scalar-address stores/atomics, with focused translation and AGC execution tests.
- `7d69cb0e6`: implemented GDS `DS_SRC2` U32/U64 atomic-add forms using the M0 base.
- Current focused validation rebuilt the relevant tests and passed 14/14 (see `TEST_RESULTS.md`). These changes improve particular tested paths; they do not establish complete shader coverage or full AGC compatibility.

Function-level compatibility claims require a source patch, a semantic test, and recorded passing results.
