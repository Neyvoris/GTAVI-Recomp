# Build status

Updated: 2026-11-26.

## Tested source

- Parent: `codex/windows-x64-preflight`, working copy `D:\GTAVI-Recomp-dev-d`.
- AnyPS5: `third_party/AnyPS5`, branch `codex/gtavi-compatibility-advance`, latest tested/pushed commit `aacb4abb48` (`feat(shader): translate scalar address stores`), based on merge `dd95a75a55`. Upstream repositories were not modified.
- Build tree: `D:\a5adv3`.

## Windows x64 Release targeted build

- Compiler: MSYS2 UCRT64 MinGW-w64 GCC/G++ 16.1.0, target x86_64-w64-mingw32.
- CMake 4.4.4, Ninja, Vulkan SDK 1.4.363.0, SPIRV-Tools enabled; bundled dependencies; full-runtime configuration (`ANYPS5_RELINKER_ONLY=OFF`), tests on, `SKIP_SPIRV_TOOLS_INSTALL=ON`.
- **PASS for requested targets:** `shader_recompiler_agc_driver`; PRX libraries `libSceAgcDriver`, `libSceSystemService`, `libSceUserService`, `libSceSaveData`, `libSceAppContent`, and `libSceSysmodule`; and the test binaries listed in `TEST_RESULTS.md`. Focused AppContent and SaveData suites were built and passed after the initial service/shader test batch.
- This was a targeted build, not a clean all-target build. Third-party glslang/STL warnings appeared, but selected targets linked successfully.
- Debug configuration succeeded at `D:\a5advdbg`. The same shader recompiler/AGC target, six selected PRX libraries, and three shader test executables built successfully; rerunning Ninja confirmed exit code 0. Debug CTest for the three shader tests passed 3/3. This is still targeted, not a full Debug build.
- After the DS_SRC2 source changes, a clean Release rebuild of the AGC library and its dependencies completed, including the previously stale `agc_driver_address_draw_space_reuse_tests` link. The new `agc_driver_lds_src2_tests` and `ds_src2_u64_tests` targets then built successfully in `D:\a5adv3`; this was a clean AGC-target dependency rebuild, not a clean all-runtime build.
- After scalar SMEM store changes, Release targets `scalar_buffer_store_tests` and `agc_driver_sbuffer_store_tests` compiled and linked successfully in `D:\a5adv3`. This rebuilt shader recompiler, libSceAgcDriver PRX, and test dependencies; it is not a full-runtime build.
- After scalar buffer atomic add changes, Release targets `scalar_buffer_atomic_add_tests` and `agc_driver_sbuffer_atomic_add_tests` compiled and linked successfully in `D:\a5adv3`; the shader recompiler and libSceAgcDriver PRX dependencies rebuilt. This remains a targeted build.
- After adding the other 32-bit scalar buffer atomic operators, the same Release targets rebuilt and passed. The focused 6-test regression batch also passed after this change; this is still not a full-runtime build.
- After adding scalar buffer compare-swap DWORD/X2 decoding and translation, Release target rebuild `scalar_buffer_atomic_add_tests agc_driver_sbuffer_atomic_add_tests` succeeded in `D:\a5adv3`; focused IR and RTX 4060 Vulkan tests passed 2/2. This does not rebuild every runtime target.
- After adding scalar buffer INC/DEC DWORD/X2 decoding and translation, the same Release targets rebuilt; the GPU and IR tests passed 2/2. The adjacent six-test regression batch passed 6/6 on commit `17f36dc3f6`.
- After adding scalar-address `S_ATOMIC_ADD` DWORD/X2, Release targets `scalar_buffer_atomic_add_tests` and `agc_driver_sbuffer_atomic_add_tests` rebuilt successfully. RTX 4060 GPU+IR tests and the adjacent six-test regression batch passed (2/2 targeted and 6/6 regression) on commit `45a0194afa`.
- After adding scalar raw-address `S_STORE_DWORD/X2/X4`, the same Release targets rebuilt; exact RTX 4060 GPU and IR checks passed, followed by the adjacent regression batch 6/6 on commit `aacb4abb48`. An initial raw pointer test faulted because no BDA mapping existed; the passing test registers the same memory through a normal buffer descriptor, matching runtime address-mapping requirements.
- After the packed-store changes, the focused Debug `agc_driver_image_pck_n_tests` and `image_pck_n_tests` targets built and passed 2/2. C: had no free space for MinGW's default temporary output; setting `TMP`, `TEMP`, and `TMPDIR` to `D:\a5temp\mingw-temp` allowed this targeted build to complete. The full Debug build remains unverified.
- A complete Release `ninja` build was attempted (`11,086` planned operations). It stopped at the AGC tool post-link step for `agc_shader_replay.exe`: Windows Security identifies it as `Trojan:Win64/ShellCode.MKA!MTB` (ThreatID `2147960850`) and blocks reads, so GNU `objcopy` reports `Invalid argument`. The alert is reproduced in Defender's read-only threat history. No protection settings were changed. At the stop, all 413 patched `.prx` output paths existed; 408 had been written during this build attempt and five predated it. The complete all-target build did not finish.

## Reproduction

The repo helper `scripts/build-anyps5-windows.ps1` configures and builds the full runtime, and now places `TMP`, `TEMP`, and MinGW `TMPDIR` under the selected build directory. This checkpoint's CMake build directory was `D:\a5adv3`; it completed all 413 patched PRX outputs before Windows Security blocked the AGC replay tool post-link step. The helper does not bypass that blocker.
