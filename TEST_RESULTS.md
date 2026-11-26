# Test results

Updated: 2026-11-26. This file records only observed results.

## Parent repository baseline

- `cmd /c scripts\build-windows.bat Release`: PASS; all 3 CTest tests.
- `python scripts/update_progress.py --check`: PASS.
- `python -m unittest discover -s tests/python -v`: PASS, 44 tests.
- `python -I tests/test_check_app0.py`: PASS, 10 synthetic fixture tests.

## AnyPS5 full runtime on MinGW

- First configure: PASS for Release with tests on and full runtime enabled.
- First build: FAILED at 8,175/11,731 Ninja steps with `ld.exe: final link failed: No space left on device`; C: had zero free space. The generated build directory was moved to D:.
- Validation-enabled configure: PASS at `D:\GTAVI-Recomp-build\a5-msys2-ucrt` with `ANYPS5_ENABLE_SPIRV_TOOLS=ON`, `SKIP_SPIRV_TOOLS_INSTALL=ON`, tests on, and full runtime enabled. Without `SKIP_SPIRV_TOOLS_INSTALL`, CMake generation failed because an exported SPIRV-Tools target depends on AnyPS5's global `windows_seh_personalities` object target.
- First full build attempt stopped at `agc_shader_replay.exe`; Windows Security quarantined the generated file, so the post-build `objcopy` reported `Invalid argument`. A keep-going build is compiling remaining targets.
- Targeted runtime build: PASS; `guest_exec_variadic_tests.exe` compiled and linked from AnyPS5 commit `97919d82f8456c70bcb7b739b9d418d8c375bba7`.
- Targeted CTest: PASS, `ctest -R ^guest_exec_variadic$` (1/1).
- Full CTest: NOT RUN yet.
- SPIR-V validation/AGC tests: pending the keep-going build.
- Vulkan: `vulkaninfo --summary` detected NVIDIA RTX 4060, driver 617.14; setting `VK_INSTANCE_LAYERS=VK_LAYER_KHRONOS_validation` loaded Khronos validation. AGC rendering/validation tests are not yet run.
- Homebrew, GTA VI, game runtime, and first rendered frame: NOT TESTED.

Update this file with exact counts, failures, skip reasons, and commands after each completed run. Do not turn skipped GPU tests into passes.
