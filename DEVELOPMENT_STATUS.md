# Development status

Updated: 2026-11-26. Work is on `codex/windows-x64-preflight`, isolated from upstream.

## Current phase

- GTAVI-Recomp baseline recorded at parent commit `0b332f88343b0fdebf20a640a5c625a2132a521b`; audit note commit `196d39a59a522503dcc7032460e692c101cdd6c7` is on this branch.
- AnyPS5 source branch: user-owned `Neyvoris/AnyPS5:codex/gtavi-compatibility-advance`, pinned at `7d69cb0e68519660a3842134ac7f2dcb6ad03976` (GPL-2.0-only). This branch includes the earlier `execl` family work plus packed MIMG stores, 64-bit LDS `DS_SRC2`, scalar buffer loads/stores/atomics, scalar-address memory operations, and GDS `DS_SRC2` atomics. The parent now pins this tested branch tip.
- Windows x64 MinGW-w64/UCRT64 GCC 16.1.0 full-runtime Release build with tests enabled reached the end of the keep-going pass in `D:\GTAVI-Recomp-build\a5-msys2-ucrt`. 413 PRX library artifacts were produced, but 37 AGC tool/test executable targets failed post-link because Windows Security quarantined their output. This is a partial build, not a successful complete runtime build. The first attempt on C: ran out of disk space; generated build outputs were moved to D:.
- Current configuration has `ANYPS5_RELINKER_ONLY=OFF`, `BUILD_TESTING=ON`, `ANYPS5_USE_SYSTEM_DEPS=OFF`, `ANYPS5_ENABLE_SPIRV_TOOLS=ON`, and `SKIP_SPIRV_TOOLS_INSTALL=ON`. The last option avoids exporting the bundled static tools, which otherwise exposed the globally linked `windows_seh_personalities` target during CMake generation.
- A reproducible configure/build/test entry point is available at `scripts/build-anyps5-windows.ps1`.
- Implemented `execl`, `execle`, and `execlp` from public AnyPS5 commit `65eaf885f894447d9782f439dcd93e07cdd1cffc`; the Windows x64 targeted build and `guest_exec_variadic` test pass. This test covers varargs beyond register slots and `ENOENT`/`E2BIG`, not successful process replacement.
- Full CTest completed: 6,651 registered tests, 6,492 passed, 122 failed, and 37 were skipped. Failures include missing/quarantined AGC executables plus other independent upstream test failures; see `TEST_RESULTS.md` and the saved log outside the repository. A focused Vulkan validation smoke run passed three tests on the RTX 4060.
- Rebuilt the focused image and memory test targets from the pinned source in `D:\a5adv3`; 14/14 tests passed across packed MIMG stores/mips/guards, scalar buffer operations, LDS `DS_SRC2`, and GDS `DS_SRC2`. See `TEST_RESULTS.md`.
- Current source scanner: gfx1013 reference 1,557/1,560 translated forms; 127 unsupported throw sites; libSceAgcDriver 97 implemented and 70 remaining by the scanner. These source counts do not mean all other paths or runtime behavior are complete.

## Scope and evidence

Development uses public source and synthetic/upstream tests only. No game files, console files, keys, leaked materials, or proprietary SDKs were accessed. GTA VI compatibility and game runtime are not verified.

AnyPS5 source changes are committed to the user-owned fork. The parent `.gitmodules` URL and gitlink now point to the fork and tested commit on this branch. Latest implementation commits include `12d719db7f` (packed image stores), `bd1983813` (64-bit DS SRC2 LDS), scalar buffer/address changes from `8774f2f9b` through `126087d9e`, and `7d69cb0e6` (GDS DS SRC2 atomics).

See [BUILD_STATUS.md](BUILD_STATUS.md), [TEST_RESULTS.md](TEST_RESULTS.md), and [BLOCKERS.md](BLOCKERS.md) for current evidence.
