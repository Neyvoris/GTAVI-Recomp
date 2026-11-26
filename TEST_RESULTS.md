# Test results

Updated: 2026-11-26. The current regression batch was observed on AnyPS5 commit `12d719db7f85b8eb5c0daec15429515e316674bb`; prior results are on merge `dd95a75a55`, except where explicitly labeled earlier baseline.

## Targeted tests on merged source

- Current worktree regression batch: PASS 96/96 Release tests across shader recompiler, SystemService, UserService, Sysmodule, AppContent, SaveData, and AGC. This includes the two new PCK store tests and all previously tracked focused tests in those suites.
- `image_pck_n`: PASS in Release and Debug. Verifies the PCK2/PCK4 store and mip store opcodes decode and lower to one IR `ImageWrite` while preserving packed width, dmask, data size, and mip metadata.
- `agc_driver_image_pck_n`: PASS in Release and Debug on NVIDIA RTX 4060. Validates PCK2 R8/R16/RG8, PCK4 R8, and mip variants by comparing guest texture bytes, including bounds and no-write regions. Invalid format/layout combinations are rejected. Release also passed with `VK_LAYER_KHRONOS_validation` explicitly enabled.
- Debug PCK batch: PASS 2/2 after routing MinGW temporary output to D: because the default C: temp volume had no free space.

- Shader recompiler: PASS 3/3 — `shader_image_overwrite_proof`, `shader_memory_decoder_tolerance`, `scalar_scratch_load`. The scratch test confirms the expected unsupported behavior and decoder coverage; it does not verify a working scratch-load translation.
- System/service tests: PASS 43/43 — `guest_system_service|guest_sysmodule|guest_user_service`, including bounded path/profile cases, title metadata, lifecycle, login-list, and invalid sysmodule IDs.
- AppContent: PASS 9/9 — `guest_appcontent`, including download quota boundaries, entitlement parsing, license responses, and mount alias collisions.
- SaveData: PASS 35/35 — `guest_savedata`, including bounds, backup/recovery, search/size/delete/convert, mount status, event callbacks, host-space handling, and icon round trips.
- AGC/Vulkan execution: PASS 2/2 — `agc_driver_pipelined_fill`, `agc_driver_pixel_exec_interpolation`.
- Repeated the two AGC tests with `VK_LAYER_KHRONOS_validation` set in the process environment: PASS 2/2.
- Aggregate selected Release result: 92/92 tests passed. No homebrew/title runtime tests were run.
- Debug configuration: selected recompiler/AGC and six PRX targets built; shader trio `shader_image_overwrite_proof`, `shader_memory_decoder_tolerance`, and `scalar_scratch_load` passed 3/3. Full Debug CTest was not run.

## Earlier full-suite baseline (older AnyPS5 revision)

- Full CTest: 6,651 registered tests; 6,492 passed, 122 failed, 37 skipped. This is not the current merged-source result and was not rerun after merging `main`.
- Failures included unavailable/quarantined AGC executables and independent upstream checks. Earlier full build produced 413 PRX artifacts but was not clean; Windows Security quarantined some generated AGC executables before post-link `objcopy`.
- Earlier three Vulkan validation cases (`agc_driver_pipelined_fill`, `agc_driver_pixel_exec_interpolation`, `guest_video_out_vblank_status`) passed on NVIDIA RTX 4060. The two AGC cases have now been reconfirmed on the merged source with validation enabled; video-out case was not repeated.
- `guest_exec_variadic` passed on the prior isolated branch before this merge; it was not repeated in this targeted run.

## Limits

Build success, unit-test success, and application runtime compatibility are separate claims. Full build, full CTest on the merged source, Debug, guest executable loading, homebrew, GTA VI, and first rendered frame remain unverified.
