# Implemented functions

No PS5 system, Vulkan/AGC, or shader-recompiler functions have been added or marked implemented in this work. Compatibility code is in the separate AnyPS5 submodule, and no user-owned AnyPS5 fork has been identified for safe source changes.

## Development tooling delivered

- `scripts/build-anyps5-windows.ps1`: reproducible Windows x64 configure/build/CTest entry point for the full AnyPS5 runtime, recursively initializes the pinned submodules, and enables SPIR-V validation/tests. This is build tooling, not a runtime compatibility implementation.

Function-level compatibility claims require a source patch, a semantic test, and recorded passing results.
