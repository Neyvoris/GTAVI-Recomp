# Development status

Updated: 2026-11-26. Work is on `codex/windows-x64-preflight`, isolated from upstream.

## Current phase

- GTAVI-Recomp baseline recorded at parent commit `0b332f88343b0fdebf20a640a5c625a2132a521b`; audit note commit `196d39a59a522503dcc7032460e692c101cdd6c7` is on this branch.
- Pinned AnyPS5 submodule: `15826135019b8c7de27f42661a850a1dd9750932`, GPL-2.0-only.
- Windows x64 MinGW-w64/UCRT64 GCC 16.1.0 full-runtime Release build with tests enabled is in progress in `D:\GTAVI-Recomp-build\a5-msys2-ucrt` (11,710 Ninja steps after enabling validation). The first attempt on C: ran out of disk space at 8,175 of 11,731 steps; generated build outputs were moved to D: and the build was reconfigured there.
- Current configuration has `ANYPS5_RELINKER_ONLY=OFF`, `BUILD_TESTING=ON`, `ANYPS5_USE_SYSTEM_DEPS=OFF`, `ANYPS5_ENABLE_SPIRV_TOOLS=ON`, and `SKIP_SPIRV_TOOLS_INSTALL=ON`. The last option avoids exporting the bundled static tools, which otherwise exposed the globally linked `windows_seh_personalities` target during CMake generation.
- A reproducible configure/build/test entry point is available at `scripts/build-anyps5-windows.ps1`.

## Scope and evidence

Development uses public source and synthetic/upstream tests only. No game files, console files, keys, leaked materials, or proprietary SDKs were accessed. GTA VI compatibility and game runtime are not verified.

Because AnyPS5 is a separate Git submodule, source changes to it require a user-owned AnyPS5 fork. No such fork was identified among accessible repositories, so do not commit changes inside the submodule or alter its upstream pointer without establishing that fork. Work so far focuses on a repeatable, full Windows build/test path in the GTAVI-Recomp fork.

See [BUILD_STATUS.md](BUILD_STATUS.md), [TEST_RESULTS.md](TEST_RESULTS.md), and [BLOCKERS.md](BLOCKERS.md) for current evidence.
