# Development status

Updated: 2026-11-26. Work is on `codex/windows-x64-preflight`, isolated from upstream.

## Current phase

- GTAVI-Recomp baseline recorded at parent commit `0b332f88343b0fdebf20a640a5c625a2132a521b`; audit note commit `196d39a59a522503dcc7032460e692c101cdd6c7` is on this branch.
- Base AnyPS5 pin: `15826135019b8c7de27f42661a850a1dd9750932`, GPL-2.0-only. User-owned fork: `Neyvoris/AnyPS5`, development branch `codex/gtavi-libkernel-exec-variadic`, commit `97919d82f8456c70bcb7b739b9d418d8c375bba7`.
- Windows x64 MinGW-w64/UCRT64 GCC 16.1.0 full-runtime Release build with tests enabled is in progress in `D:\GTAVI-Recomp-build\a5-msys2-ucrt` (8,419 Ninja steps remained when the keep-going pass started). The first attempt on C: ran out of disk space at 8,175 of 11,731 steps; generated build outputs were moved to D:.
- Current configuration has `ANYPS5_RELINKER_ONLY=OFF`, `BUILD_TESTING=ON`, `ANYPS5_USE_SYSTEM_DEPS=OFF`, `ANYPS5_ENABLE_SPIRV_TOOLS=ON`, and `SKIP_SPIRV_TOOLS_INSTALL=ON`. The last option avoids exporting the bundled static tools, which otherwise exposed the globally linked `windows_seh_personalities` target during CMake generation.
- A reproducible configure/build/test entry point is available at `scripts/build-anyps5-windows.ps1`.
- Implemented `execl`, `execle`, and `execlp` from public AnyPS5 commit `65eaf885f894447d9782f439dcd93e07cdd1cffc`; the Windows x64 targeted build and `guest_exec_variadic` test pass. This test covers varargs beyond register slots and `ENOENT`/`E2BIG`, not successful process replacement.
- The full build encountered Windows Security quarantine of generated `agc_shader_replay.exe`; its post-build `objcopy` failed because the file was unavailable. Security settings remain enabled; keep-going build is in progress.

## Scope and evidence

Development uses public source and synthetic/upstream tests only. No game files, console files, keys, leaked materials, or proprietary SDKs were accessed. GTA VI compatibility and game runtime are not verified.

AnyPS5 source changes are committed to the user-owned fork. The parent branch still needs its submodule URL and gitlink updated to reference that fork branch.

See [BUILD_STATUS.md](BUILD_STATUS.md), [TEST_RESULTS.md](TEST_RESULTS.md), and [BLOCKERS.md](BLOCKERS.md) for current evidence.
