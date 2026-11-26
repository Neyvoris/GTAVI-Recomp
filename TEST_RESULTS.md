# Test results

Updated: 2026-11-26. This file records only observed results.

## Focused compatibility additions on `7d69cb0e68519660a3842134ac7f2dcb6ad03976`

- Built the focused Release test targets in `D:\a5adv3`: `agc_driver_gcn_scalar_buffer_base_tests`, `agc_driver_gds_m0_base_tests`, `agc_driver_lds_src2_tests`, `agc_driver_sbuffer_atomic_add_tests`, `agc_driver_sbuffer_store_tests`, `agc_driver_scalar_buffer_runtime_word3_tests`, `scalar_buffer_atomic_add_tests`, `scalar_buffer_store_tests`, `agc_driver_image_table_packed_tests`, `image_pck_n_tests`, and `ds_src2_u64_tests`.
- CTest PASS 14/14: `agc_driver_gcn_scalar_buffer_base`, `agc_driver_gds_m0_base`, `agc_driver_lds_src2`, `agc_driver_sbuffer_atomic_add`, `agc_driver_sbuffer_store`, `agc_driver_scalar_buffer_runtime_word3`, `agc_driver_image_table_packed_stores`, `agc_driver_image_table_packed_guards`, `agc_driver_image_table_packed_rejected`, `agc_driver_image_table_packed_mips`, `ds_src2_u64`, `image_pck_n`, `scalar_buffer_atomic_add`, and `scalar_buffer_store`.
- These tests exercise specific operations locally through Vulkan and synthetic shader translation fixtures. They do not verify every instruction variant or title runtime.

## Parent repository baseline

- `cmd /c scripts\build-windows.bat Release`: PASS; all 3 CTest tests.
- `python scripts/update_progress.py --check`: PASS.
- `python -m unittest discover -s tests/python -v`: PASS, 44 tests.
- `python -I tests/test_check_app0.py`: PASS, 10 synthetic fixture tests.

## AnyPS5 full runtime on MinGW

- First configure: PASS for Release with tests on and full runtime enabled.
- First build: FAILED at 8,175/11,731 Ninja steps with `ld.exe: final link failed: No space left on device`; C: had zero free space. The generated build directory was moved to D:.
- Validation-enabled configure: PASS at `D:\GTAVI-Recomp-build\a5-msys2-ucrt` with `ANYPS5_ENABLE_SPIRV_TOOLS=ON`, `SKIP_SPIRV_TOOLS_INSTALL=ON`, tests on, and full runtime enabled. Without `SKIP_SPIRV_TOOLS_INSTALL`, CMake generation failed because an exported SPIRV-Tools target depends on AnyPS5's global `windows_seh_personalities` object target.
- Keep-going build finished with 37 AGC executable targets failing after generated binaries were quarantined by Windows Security; 413 PRX library artifacts were produced. Full runtime build is not clean.
- Targeted runtime build: PASS; `guest_exec_variadic_tests.exe` compiled and linked from AnyPS5 commit `97919d82f8456c70bcb7b739b9d418d8c375bba7`.
- Targeted CTest: PASS, `ctest -R ^guest_exec_variadic$` (1/1).
- Full CTest: all 6,651 registered tests completed in 1,284.23 seconds; 6,492 passed, 122 failed, and 37 were skipped. Failures include missing/quarantined AGC executables (`BAD_COMMAND`/`Not Run`) and independent failures such as shader-cache source checks, `pr_overlap_tools`, `performance_bisect`, `conventions_doc_links`, `title_run`, `test_executable_manifests` (timeout), `nid_patch_dependencies`, `test_thread_local_destructors`, and several AGC runtime checks. Full log: `D:\GTAVI-Recomp-build\a5-msys2-ucrt\ctest-full-dtemp.log`; CTest failure index: `D:\GTAVI-Recomp-build\a5-msys2-ucrt\Testing\Temporary\LastTestsFailed.log`.
- Focused Vulkan validation run: PASS, 3/3: `agc_driver_pipelined_fill`, `agc_driver_pixel_exec_interpolation`, and `guest_video_out_vblank_status`. Explicit `VK_INSTANCE_LAYERS=VK_LAYER_KHRONOS_validation` was verified in loader debug output for the interpolation test; it selected NVIDIA GeForce RTX 4060. Interpolation test matched 932 pixels for wave32 and wave64 cases. No validation error/VUID was present in that smoke output. This was not a full-rendering or app-start test.
- Vulkan setup: `vulkaninfo --summary` detected NVIDIA RTX 4060, driver 617.14; `spirv-val.exe --version` passed.
- Debug build: NOT RUN.
- Homebrew, GTA VI, game runtime, and first rendered frame: NOT TESTED. The 37 skipped tests are reported as skipped; none are counted as passes.
