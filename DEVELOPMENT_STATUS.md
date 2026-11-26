# Development status

Updated: 2026-11-26. Parent branch: `codex/windows-x64-preflight`. AnyPS5 branch: `codex/gtavi-compatibility-advance`.

## Current checkpoint

- Integrated public `Neyvoris/AnyPS5` `main` into the isolated AnyPS5 fork branch. Merge commit: `dd95a75a55`. The parent and AnyPS5 feature branches were pushed to the user's forks; upstream repositories were not modified.
- Added and locally committed the verified MIMG packed-store implementation as AnyPS5 commit `12d719db7f85b8eb5c0daec15429515e316674bb` on `codex/gtavi-compatibility-advance`.
- Windows x64 Release configuration with MinGW-w64 GCC 16.1, CMake/Ninja, Vulkan SDK and SPIRV-Tools completed in `D:\a5adv3`. The selected runtime targets built, including `shader_recompiler_agc_driver`, `libSceAgcDriver.prx`, `libSceSystemService.prx`, `libSceUserService.prx`, `libSceSaveData.prx`, `libSceAppContent.prx`, and `libSceSysmodule.prx`.
- Implemented and GPU-verified MIMG `IMAGE_STORE_PCK2/PCK4` and mip variants for the measured 2D, single-dword, identity-swizzled R8/R16/RG8 subset; PCK4 is limited to R8. Coverage and boundaries are described in `IMPLEMENTED_FUNCTIONS.md`.
- 96 focused Release tests passed on the current worktree, including shader, service, AppContent, SaveData, AGC, and PCK tests. The PCK GPU test and IR decoder test also passed in Debug. PCK execution passed with `VK_LAYER_KHRONOS_validation` explicitly enabled.
- Full Release build was attempted but stopped at the `agc_shader_replay.exe` post-link step because Windows Security marks that generated tool as `Trojan:Win64/ShellCode.MKA!MTB` and blocks `objcopy`; all 413 patched PRX output paths existed at the stop (408 were refreshed during the attempt). The precise blocker is recorded in `BUILD_STATUS.md` and `BLOCKERS.md`.
- This is a targeted build/test checkpoint, not a clean rebuild of every target or a full green CTest run. Homebrew execution, GTA VI, and first-frame rendering were not tested.

## Coverage snapshot

`tools/progress.py` on the tested AnyPS5 source reported 2,959/4,240 for the selected library counters (69.79%); 1,484/1,560 gfx1013 reference forms decoded and translated (95.13%); 1,460/1,460 scanned shader forms decoded; and 127 unsupported shader recompiler throw sites. The throw-site count and form count measure different things.

Selected libraries: `libc` 1,874/1,882; `libkernel` 754/800; `libSceAgcDriver` 97/167; `libSceAppContent` 30/39; `libSceSaveData` 1/19; `libSceSysmodule` 13/21; `libSceSystemService` 146/617; `libSceUserService` 44/695. These are repository progress metrics, not application compatibility percentages.

## Evidence and limitations

- Exact build and test evidence is in [BUILD_STATUS.md](BUILD_STATUS.md) and [TEST_RESULTS.md](TEST_RESULTS.md).
- Remaining API and shader work is in [REMAINING_FUNCTIONS.md](REMAINING_FUNCTIONS.md); blockers and missing behavioral oracles are in [BLOCKERS.md](BLOCKERS.md).
- Use only public source and synthetic/upstream tests. No leaked source, proprietary game files, console keys, or unauthorized game content were used. GTA VI compatibility is not established.
