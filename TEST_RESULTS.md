# Test results

Updated: 2026-11-26. Results below were observed on AnyPS5 merge `dd95a75a55`, except where explicitly labeled earlier baseline.

## Targeted tests on merged source

- Shader recompiler: PASS 3/3 — `shader_image_overwrite_proof`, `shader_memory_decoder_tolerance`, `scalar_scratch_load`. The scratch test confirms the expected unsupported behavior and decoder coverage; it does not verify a working scratch-load translation.
- System/service tests: PASS 43/43 — `guest_system_service|guest_sysmodule|guest_user_service`, including bounded path/profile cases, title metadata, lifecycle, login-list, and invalid sysmodule IDs.
- AGC/Vulkan execution: PASS 2/2 — `agc_driver_pipelined_fill`, `agc_driver_pixel_exec_interpolation`.
- Repeated the two AGC tests with `VK_LAYER_KHRONOS_validation` set in the process environment: PASS 2/2.
- Aggregate selected result: 48/48 tests passed. No homebrew/title runtime tests were run.
- Debug configuration: selected recompiler/AGC and six PRX targets built; shader trio `shader_image_overwrite_proof`, `shader_memory_decoder_tolerance`, and `scalar_scratch_load` passed 3/3. Full Debug CTest was not run.

## Earlier full-suite baseline (older AnyPS5 revision)

- Full CTest: 6,651 registered tests; 6,492 passed, 122 failed, 37 skipped. This is not the current merged-source result and was not rerun after merging `main`.
- Failures included unavailable/quarantined AGC executables and independent upstream checks. Earlier full build produced 413 PRX artifacts but was not clean; Windows Security quarantined some generated AGC executables before post-link `objcopy`.
- Earlier three Vulkan validation cases (`agc_driver_pipelined_fill`, `agc_driver_pixel_exec_interpolation`, `guest_video_out_vblank_status`) passed on NVIDIA RTX 4060. The two AGC cases have now been reconfirmed on the merged source with validation enabled; video-out case was not repeated.
- `guest_exec_variadic` passed on the prior isolated branch before this merge; it was not repeated in this targeted run.

## Limits

Build success, unit-test success, and application runtime compatibility are separate claims. Full build, full CTest on the merged source, Debug, guest executable loading, homebrew, GTA VI, and first rendered frame remain unverified.
