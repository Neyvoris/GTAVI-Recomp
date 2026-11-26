# Test results

Updated: 2026-11-26. The current regression batch is on pushed AnyPS5 commit `45a0194afa`; prior results are on merge `dd95a75a55`, except where explicitly labeled earlier baseline.

## Targeted tests on merged source

- Current worktree regression batch: PASS 96/96 Release tests across shader recompiler, SystemService, UserService, Sysmodule, AppContent, SaveData, and AGC. This includes the two new PCK store tests and all previously tracked focused tests in those suites.
- `image_pck_n`: PASS in Release and Debug. Verifies the PCK2/PCK4 store and mip store opcodes decode and lower to one IR `ImageWrite` while preserving packed width, dmask, data size, and mip metadata.
- `agc_driver_image_pck_n`: PASS in Release and Debug on NVIDIA RTX 4060. Validates PCK2 R8/R16/RG8, PCK4 R8, and mip variants by comparing guest texture bytes, including bounds and no-write regions. Invalid format/layout combinations are rejected. Release also passed with `VK_LAYER_KHRONOS_validation` explicitly enabled.
- New DS_SRC2 64-bit verification: PASS 2/2 — `agc_driver_lds_src2` GPU execution and `ds_src2_u64` IR test. The execution test covers 15 forms across 32 lanes each and passed under Vulkan 1.4.363 with the Khronos validation layer explicitly inserted on NVIDIA RTX 4060; the captured log contained no `VUID-` or validation error. Float min/max coverage uses finite inputs only. A standalone `spirv-val` invocation was not run.
- Scalar buffer store verification: PASS 4/4 — `scalar_buffer_store`, `agc_driver_sbuffer_store`, `shader_memory_decoder_tolerance`, and `agc_driver_buffer_descriptor_runtime`. The first two verify `S_BUFFER_STORE_DWORD/X2/X4` decoder and IR details and exact GPU buffer writes on RTX 4060. Vulkan layer insertion was enabled for the GPU test; no validation errors appeared. This is aligned, in-bounds synthetic coverage.
- Scalar buffer atomic verification after x2: PASS 2/2 — `scalar_buffer_atomic_add` and `agc_driver_sbuffer_atomic_add`. Covers ten 32-bit and ten 64-bit RMW operators for `GLC=0/1`, one elected lane in a 32-lane wave, and returned old values through following stores. The previously tracked adjacent focused regression batch passed 6/6.
- Compare-swap/INC/DEC verification: PASS 2/2 — the scalar atomic IR test asserts desired/comparator operands for DWORD/X2 compare-swap, opcode routing and leader lane guard; RTX 4060 Vulkan execution confirms successful compare-and-replace and increment/decrement wrap-limit branches at both widths, with GLC on/off. Validation was not re-enabled for this latest run; earlier RMW GPU tests passed with the Khronos layer enabled. The adjacent regression batch passed 6/6 on this commit.
- Scalar-address atomic ADD verification on `45a0194afa`: PASS 2/2 targeted IR+GPU tests for DWORD/X2 and GLC on/off. The GPU test confirms one-wave memory changes from 7 to 12 and the returned old value is 7; the subsequent six-test regression batch passed 6/6. Loader environment forcing did not confirm that `VK_LAYER_KHRONOS_validation` was actually loaded for this run, so no validation-layer claim is made for this new path.
- Debug PCK batch: PASS 2/2 after routing MinGW temporary output to D: because the default C: temp volume had no free space.

- Shader recompiler: PASS 3/3 — `shader_image_overwrite_proof`, `shader_memory_decoder_tolerance`, `scalar_scratch_load`. The scratch test confirms the expected unsupported behavior and decoder coverage; it does not verify a working scratch-load translation.
- System/service tests: PASS 43/43 — `guest_system_service|guest_sysmodule|guest_user_service`, including bounded path/profile cases, title metadata, lifecycle, login-list, and invalid sysmodule IDs.
- AppContent: PASS 9/9 — `guest_appcontent`, including download quota boundaries, entitlement parsing, license responses, and mount alias collisions.
- SaveData: PASS 35/35 — `guest_savedata`, including bounds, backup/recovery, search/size/delete/convert, mount status, event callbacks, host-space handling, and icon round trips.
- AGC/Vulkan execution: PASS 2/2 — `agc_driver_pipelined_fill`, `agc_driver_pixel_exec_interpolation`.
- Repeated the two AGC tests with `VK_LAYER_KHRONOS_validation` set in the process environment: PASS 2/2.
- Aggregate selected Release result: 92/92 tests passed. No homebrew/title runtime tests were run.
- AGC storage write-back follow-up on restored source: recorder target build passed; `agc_storage_write_back` and `agc_storage_write_back_scratch` passed 2/2 using the agent's CMake/CTest installation. The opt-in `agc_storage_write_back_host_retile` route-count assertion still fails for `linear 240x135, 2 mips`: `linearRows` rejects tail mips before host import (`0 direct, 0 host-blocked, 1 other`). Texel, row-padding, and outside-byte checks passed via scratch fallback in the diagnostic run; only the fast-path assertion failed. This does not establish direct-retile correctness for tail-mip layouts, so no guard or expectation was changed. The root shell used for this follow-up did not have `ctest`/CMake available for independent rerun.
- Debug configuration: selected recompiler/AGC and six PRX targets built; shader trio `shader_image_overwrite_proof`, `shader_memory_decoder_tolerance`, and `scalar_scratch_load` passed 3/3. Full Debug CTest was not run.

## Earlier full-suite baseline (older AnyPS5 revision)

- Full CTest: 6,651 registered tests; 6,492 passed, 122 failed, 37 skipped. This is not the current merged-source result and was not rerun after merging `main`.
- Failures included unavailable/quarantined AGC executables and independent upstream checks. Earlier full build produced 413 PRX artifacts but was not clean; Windows Security quarantined some generated AGC executables before post-link `objcopy`.
- Earlier three Vulkan validation cases (`agc_driver_pipelined_fill`, `agc_driver_pixel_exec_interpolation`, `guest_video_out_vblank_status`) passed on NVIDIA RTX 4060. The two AGC cases have now been reconfirmed on the merged source with validation enabled; video-out case was not repeated.
- `guest_exec_variadic` passed on the prior isolated branch before this merge; it was not repeated in this targeted run.

## Limits

Build success, unit-test success, and application runtime compatibility are separate claims. Full build, full CTest on the merged source, Debug, guest executable loading, homebrew, GTA VI, and first rendered frame remain unverified.
