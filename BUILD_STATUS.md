# Build status

Updated: 2026-11-26.

## Full AnyPS5 Windows x64 runtime

- Source: `third_party/AnyPS5` at `7d69cb0e68519660a3842134ac7f2dcb6ad03976` on `codex/gtavi-compatibility-advance` (user-owned fork).
- Compiler: MSYS2 UCRT64 MinGW-w64 GCC/G++ 16.1.0, target `x86_64-w64-mingw32`; CMake feature checks accepted the required Windows SEH and shared-pointer atomic support.
- Generator: Ninja 1.13.2; CMake 4.4.4.
- Release build directory: `D:\GTAVI-Recomp-build\a5-msys2-ucrt` (move to D: after the C: volume filled during the initial attempt).
- Configure: full runtime (`ANYPS5_RELINKER_ONLY=OFF`), tests on, bundled dependencies, SPIRV-Tools on. `SKIP_SPIRV_TOOLS_INSTALL=ON` avoids a CMake export-set failure caused by the global `windows_seh_personalities` link target; no dependency source was changed.
- Build result: PARTIAL/FAILED. Ninja keep-going completed independent work; 413 PRX artifacts were produced. 37 AGC tool/test executable targets failed post-link after Windows Security quarantined generated `.exe` files, causing `objcopy` to report `Invalid argument`. Security settings were not modified. See `TEST_RESULTS.md`.
- Validation-enabled configure/build/test recipe: `scripts/build-anyps5-windows.ps1` (`Release` or `Debug`). Use `-BuildDirectory D:\...` when the repository volume has limited free space.
- Debug build: NOT RUN.

## Focused implementation build

- Existing full-runtime Ninja tree: `D:\a5adv3` (Release, Windows x64 MinGW; source checkout `D:\GTAVI-Recomp-dev-d\third_party\AnyPS5` at the same pinned commit).
- Rebuilt focused targets for scalar buffer tests, packed image tests, DS/GDS SRC2 tests, and their translation tests successfully. The build completed without compile/link errors for those targets.

## Parent repository baseline

Before this task, the parent project's existing Windows Release build passed three CTest tests; 44 Python unit tests and 10 app0 fixture tests passed. The AnyPS5 MSVC test attempt was incompatible with GNU extensions and is superseded by the MinGW full-runtime attempt.

## Reproduction

From a PowerShell prompt in the repository:

```powershell
scripts\build-anyps5-windows.ps1 -Configuration Release
scripts\build-anyps5-windows.ps1 -Configuration Debug
```

The script validates the x86-64 MinGW target, initializes recursive submodules, configures the full runtime with tests and SPIR-V validation, builds, then runs CTest. Supply `-MinGWBin` if GCC is not on PATH or in a recognized MSYS2 UCRT64 location.
