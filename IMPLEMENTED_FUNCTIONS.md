# Implemented functions

## libkernel

- Added `execl_nid_postfix`, `execle_nid_postfix`, and `execlp_nid_postfix` in `third_party/AnyPS5/core/libs/prx/libkernel/System/src/Process.cpp`, with declarations in `Api.hpp`.
- The Windows path reads the guest System V variadic argument list, including arguments beyond register slots, then forwards to existing `execv`/`execve`/`execvp` paths.
- Backported from public commit `65eaf885f894447d9782f439dcd93e07cdd1cffc`; committed to `Neyvoris/AnyPS5:codex/gtavi-libkernel-exec-variadic` as `97919d82f8456c70bcb7b739b9d418d8c375bba7`.
- Verified: targeted Windows x64 build and CTest `guest_exec_variadic` passed. The test covers ABI register/stack varargs, environment-list handling, and `ENOENT`/`E2BIG`. Successful process replacement and console variadic ABI behavior remain unverified.

## Development tooling delivered

- `scripts/build-anyps5-windows.ps1`: reproducible Windows x64 configure/build/CTest entry point for the full AnyPS5 runtime, recursively initializes the pinned submodules, and enables SPIR-V validation/tests.

Function-level compatibility claims require a source patch, a semantic test, and recorded passing results.
