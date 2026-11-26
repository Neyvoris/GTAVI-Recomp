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
- Validation-enabled build: IN PROGRESS; configured Ninja graph has 11,710 steps. No pass/fail claim yet.
- CTest: NOT RUN for this build yet.
- SPIR-V validation/AGC tests: NOT RUN yet; validation-enabled build is underway.
- Vulkan device/validation-layer tests: NOT RUN yet.
- Homebrew, GTA VI, game runtime, and first rendered frame: NOT TESTED.

Update this file with exact counts, failures, skip reasons, and commands after each completed run. Do not turn skipped GPU tests into passes.
