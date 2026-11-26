# Build status

Updated: 2026-11-26.

## Tested source

- Parent: `codex/windows-x64-preflight`, working copy `D:\GTAVI-Recomp-dev-d`.
- AnyPS5: `third_party/AnyPS5`, branch `codex/gtavi-compatibility-advance`, current tested commit `12d719db7f85b8eb5c0daec15429515e316674bb` (`Implement packed MIMG image stores`), based on merge `dd95a75a55`. The baseline branch was pushed to the user's fork; upstream repositories were not modified. The new commit is local until push verification completes.
- Build tree: `D:\a5adv3`.

## Windows x64 Release targeted build

- Compiler: MSYS2 UCRT64 MinGW-w64 GCC/G++ 16.1.0, target x86_64-w64-mingw32.
- CMake 4.4.4, Ninja, Vulkan SDK 1.4.363.0, SPIRV-Tools enabled; bundled dependencies; full-runtime configuration (`ANYPS5_RELINKER_ONLY=OFF`), tests on, `SKIP_SPIRV_TOOLS_INSTALL=ON`.
- **PASS for requested targets:** `shader_recompiler_agc_driver`; PRX libraries `libSceAgcDriver`, `libSceSystemService`, `libSceUserService`, `libSceSaveData`, `libSceAppContent`, and `libSceSysmodule`; and the test binaries listed in `TEST_RESULTS.md`. Focused AppContent and SaveData suites were built and passed after the initial service/shader test batch.
- This was a targeted build, not a clean all-target build. Third-party glslang/STL warnings appeared, but selected targets linked successfully.
- Debug configuration succeeded at `D:\a5advdbg`. The same shader recompiler/AGC target, six selected PRX libraries, and three shader test executables built successfully; rerunning Ninja confirmed exit code 0. Debug CTest for the three shader tests passed 3/3. This is still targeted, not a full Debug build.
- After the packed-store changes, the focused Debug `agc_driver_image_pck_n_tests` and `image_pck_n_tests` targets built and passed 2/2. C: had no free space for MinGW's default temporary output; setting `TMP`, `TEMP`, and `TMPDIR` to `D:\a5temp\mingw-temp` allowed this targeted build to complete. The full Debug build remains unverified.

## Reproduction

The repo helper `scripts/build-anyps5-windows.ps1` configures and builds the full runtime; specify a D: build directory to avoid the previously observed full C: volume. This checkpoint's focused CMake build directory was `D:\a5adv3`. The full-runtime helper has not been rerun to completion on the merged source; consult test results for the earlier full-suite baseline and its failures.
