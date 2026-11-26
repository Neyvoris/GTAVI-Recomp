# Development status

Updated: 2026-11-26. Parent branch: `codex/windows-x64-preflight`. AnyPS5 branch: `codex/gtavi-compatibility-advance`.

## Current checkpoint

- Integrated public `Neyvoris/AnyPS5` `main` into the isolated AnyPS5 fork branch. Merge commit: `dd95a75a55` (full source commit recorded in Git). The upstream repository was not modified and nothing was pushed.
- Windows x64 Release configuration with MinGW-w64 GCC 16.1, CMake/Ninja, Vulkan SDK and SPIRV-Tools completed in `D:\a5adv3`. The selected runtime targets built, including `shader_recompiler_agc_driver`, `libSceAgcDriver.prx`, `libSceSystemService.prx`, `libSceUserService.prx`, `libSceSaveData.prx`, `libSceAppContent.prx`, and `libSceSysmodule.prx`.
- 48 focused tests passed: three shader recompiler tests, 43 SystemService/UserService/Sysmodule tests, and two AGC Vulkan execution tests. The two AGC tests also passed with `VK_LAYER_KHRONOS_validation` explicitly enabled.
- This is a targeted build/test checkpoint, not a clean rebuild of every target or a full green CTest run. Debug configuration, homebrew execution, GTA VI, and first-frame rendering were not tested.

## Coverage snapshot

`tools/progress.py` on the tested AnyPS5 source reported 2,959/4,240 for the selected library counters (69.79%); 1,484/1,560 gfx1013 reference forms decoded and translated (95.13%); 1,460/1,460 scanned shader forms decoded; and 127 unsupported shader recompiler throw sites. The throw-site count and form count measure different things.

Selected libraries: `libc` 1,874/1,882; `libkernel` 754/800; `libSceAgcDriver` 97/167; `libSceAppContent` 30/39; `libSceSaveData` 1/19; `libSceSysmodule` 13/21; `libSceSystemService` 146/617; `libSceUserService` 44/695. These are repository progress metrics, not application compatibility percentages.

## Evidence and limitations

- Exact build and test evidence is in [BUILD_STATUS.md](BUILD_STATUS.md) and [TEST_RESULTS.md](TEST_RESULTS.md).
- Remaining API and shader work is in [REMAINING_FUNCTIONS.md](REMAINING_FUNCTIONS.md); blockers and missing behavioral oracles are in [BLOCKERS.md](BLOCKERS.md).
- Use only public source and synthetic/upstream tests. No leaked source, proprietary game files, console keys, or unauthorized game content were used. GTA VI compatibility is not established.
