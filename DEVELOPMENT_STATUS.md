# Development status

Updated: 2026-11-26. Parent branch: `codex/windows-x64-preflight`. AnyPS5 branch: `codex/gtavi-compatibility-advance`.

## Current checkpoint

- Integrated public `Neyvoris/AnyPS5` `main` into the isolated AnyPS5 fork branch. Merge commit: `dd95a75a55`. The parent and AnyPS5 feature branches were pushed to the user's forks; upstream repositories were not modified.
- Added and locally committed the verified MIMG packed-store implementation as AnyPS5 commit `12d719db7f85b8eb5c0daec15429515e316674bb` on `codex/gtavi-compatibility-advance`.
- Windows x64 Release configuration with MinGW-w64 GCC 16.1, CMake/Ninja, Vulkan SDK and SPIRV-Tools completed in `D:\a5adv3`. The selected runtime targets built, including `shader_recompiler_agc_driver`, `libSceAgcDriver.prx`, `libSceSystemService.prx`, `libSceUserService.prx`, `libSceSaveData.prx`, `libSceAppContent.prx`, and `libSceSysmodule.prx`.
- Implemented and GPU-verified MIMG `IMAGE_STORE_PCK2/PCK4` and mip variants for the measured 2D, single-dword, identity-swizzled R8/R16/RG8 subset; PCK4 is limited to R8. Coverage and boundaries are described in `IMPLEMENTED_FUNCTIONS.md`.
- Added gfx1013 DS_SRC2 64-bit arithmetic, min/max, bitwise, write, and finite-value floating min/max forms (15 forms) and GPU-verified all 15 across 32 lanes on the RTX 4060. This advances the decoded/translated gfx1013 inventory from 1,484/1,560 to 1,499/1,560; the unsupported throw-site scan is now 128 because unsupported 64-bit GDS is explicitly rejected.
- Committed and pushed the DS_SRC2 implementation to `Neyvoris/AnyPS5` branch `codex/gtavi-compatibility-advance`: `bd1983813d30ea8b9bdcd0c43d1096b853992a44`.
- Added scalar `S_BUFFER_STORE_DWORD`, `S_BUFFER_STORE_DWORDX2`, and `S_BUFFER_STORE_DWORDX4` decoding and translation, with four-word descriptor validation and first-active-lane write election. Commit `8774f2f9b9` is pushed to the AnyPS5 fork branch. IR tests and RTX 4060 Vulkan execution validate exact buffer contents for all widths.
- Focused scalar store, buffer descriptor runtime, and decoder-tolerance tests pass 4/4 in Release. Vulkan execution was run with `VK_LAYER_KHRONOS_validation` explicitly enabled.
- Added `S_BUFFER_ATOMIC_ADD` opcode `0x42` with scalar-wave leader election and GLC old-value broadcast. Both no-return and return-old paths pass IR and RTX 4060 Vulkan tests; validation layer was explicitly loaded and the focused log contains no VUID or validation errors. AnyPS5 commit `b1acbb97cc` is pushed to the fork branch.
- The current focused regression batch passes 6/6 (`shader_memory_decoder_tolerance`, buffer descriptor runtime, scalar buffer store IR/GPU, and scalar buffer atomic IR/GPU). The latest gfx1013 inventory was 1,522/1,560 after the x2 scalar atomics; compare-swap was added afterward and needs a refreshed metric.
- Extended scalar buffer atomics to SWAP, ADD, SUB, signed/unsigned MIN/MAX, AND, OR, and XOR. IR and RTX 4060 GPU tests cover all ten operations with GLC return and no-return; the signed/unsigned cases use values with opposite high-bit interpretation. The complete focused regression batch passes 6/6. AnyPS5 commit `9c0dfddfe1` is pushed to the fork.
- Added scalar buffer compare-swap decoding and translation for DWORD and X2 forms, using existing typed Vulkan buffer atomic IR and preserving the two distinct comparator/desired operands. IR asserts check arity, types and leader-lane guard; RTX 4060 GPU tests exercise successful compare-and-replace and GLC/no-GLC paths for both widths. Targeted tests passed 2/2; the broader six-test regression batch passed after the preceding x2 implementation.
- 96 focused Release tests passed on the current worktree, including shader, service, AppContent, SaveData, AGC, and PCK tests. The PCK GPU test and IR decoder test also passed in Debug. PCK execution passed with `VK_LAYER_KHRONOS_validation` explicitly enabled.
- Full Release build was attempted but stopped at the `agc_shader_replay.exe` post-link step because Windows Security marks that generated tool as `Trojan:Win64/ShellCode.MKA!MTB` and blocks `objcopy`; all 413 patched PRX output paths existed at the stop (408 were refreshed during the attempt). The precise blocker is recorded in `BUILD_STATUS.md` and `BLOCKERS.md`.
- This is a targeted build/test checkpoint, not a clean rebuild of every target or a full green CTest run. Homebrew execution, GTA VI, and first-frame rendering were not tested.

## Coverage snapshot

`tools/progress.py` on current AnyPS5 commit `7d69cb0e68` reports 1,557/1,560 gfx1013 reference forms decoded and translated; 1,460/1,460 scanned shader forms decoded; and 127 unsupported shader recompiler throw sites. The remaining three reference forms are scalar scratch-store widths. The throw-site count and form count measure different things. Full-library inventory is 18,609/39,467; the older selected-library subset scan (2,959/4,240) has different scope.

Selected libraries: `libc` 1,874/1,882; `libkernel` 754/800; `libSceAgcDriver` 97/167; `libSceAppContent` 30/39; `libSceSaveData` 1/19; `libSceSysmodule` 13/21; `libSceSystemService` 146/617; `libSceUserService` 44/695. These are repository progress metrics, not application compatibility percentages.

## Evidence and limitations

- Follow-up audit on 2026-11-26 confirmed the three remaining gfx1013 reference forms are `S_SCRATCH_STORE_DWORD/X2/X4` (SMEM `0x15–0x17`). The source currently has no guest `FLAT_SCRATCH`/scalar scratch base mapping; the Vulkan scratch pool is an internal per-invocation allocation. A raw BDA store or using `RdnaOperand.value` as a scale would be semantically wrong, so no decoder-only patch was retained. Public AMD RDNA2 ISA and LLVM GFX10 encoding were consulted; implementation remains blocked until guest scratch-address mapping is modeled.
- Rebuilt `scalar_buffer_atomic_add_tests` and `agc_driver_sbuffer_atomic_add_tests` on 2026-11-26 in `D:\a5adv3`; Ninja completed the incremental build, including `libkernel.prx`, `shader_recompiler_agc_driver`, and `libSceAgcDriver.prx`. Focused tests passed 2/2. An existing GCC 16 STL `-Wstringop-overread` warning appeared in a library vector comparison; the build completed successfully.
- Added GDS M0-base addressing to DS_SRC2 translation, retaining an explicit rejection for 64-bit floating GDS min/max. New 32-lane GPU checks for `ds_add_src2_u32` and `_u64` passed alongside existing LDS SRC2 and IR tests (3/3). AnyPS5 commit `7d69cb0e68519660a3842134ac7f2dcb6ad03976` is pushed to the fork branch.

- Exact build and test evidence is in [BUILD_STATUS.md](BUILD_STATUS.md) and [TEST_RESULTS.md](TEST_RESULTS.md).
- Remaining API and shader work is in [REMAINING_FUNCTIONS.md](REMAINING_FUNCTIONS.md); blockers and missing behavioral oracles are in [BLOCKERS.md](BLOCKERS.md).
- Use only public source and synthetic/upstream tests. No leaked source, proprietary game files, console keys, or unauthorized game content were used. GTA VI compatibility is not established.
