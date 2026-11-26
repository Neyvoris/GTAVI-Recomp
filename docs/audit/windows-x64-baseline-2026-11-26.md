# Windows x64 baseline (2026-11-26)

## Source

- Repository: `Neyvoris/GTAVI-Recomp`, branch `main` at `0b332f88343b0fdebf20a640a5c625a2132a521b`.
- Upstream: `JamesCicada/GTAVI-Recomp`; the inspected fork tree is the same project snapshot, one progress-only commit behind upstream at inspection.
- AnyPS5 submodule: `15826135019b8c7de27f42661a850a1dd9750932`.
- License: GPL-2.0-only in both projects. No game files, keys, console system files, leaked assets, or proprietary SDK material were used.

## Host

Windows x64, Visual Studio 2026 MSVC 19.51.36260.0, Windows SDK 10.0.26100.0, CMake 4.4.4, Python 3.x, Git 2.56.0.4, and Vulkan SDK 1.4.363.0. Ninja and MinGW-w64 x86-64 GCC 15.2.0 were not available. CMake was invoked with the Visual Studio generator for the MSVC-only project baseline. AnyPS5 documents MinGW-w64 GCC for its Windows build.

## Baseline results

- GTAVI-Recomp: `cmd /c scripts\\build-windows.bat Release` — PASS; MSVC Release build completed and all 3 CTest tests passed.
- Progress consistency: `python scripts/update_progress.py --check` — PASS.
- Python project tests: `python -m unittest discover -s tests/python -v` — PASS, 44 tests.
- app0 preflight fixture tests: `python -I tests/test_check_app0.py` — PASS, 10 tests. These fixtures contain no game data.
- AnyPS5 relinker-only configured with MSVC 19.51 and built. The relinker executable and core library were produced, but the full test build FAILED because tests use GCC/Clang extensions unsupported by MSVC, including `__builtin_cpu_supports` and `__attribute__((sysv_abi))`. Other tests pass GNU link flags such as `-static` that MSVC ignores.
- AnyPS5 CTest discovers 1,084 tests. A full run was stopped after CMake-driven Python tests failed because Ninja was absent and a complete nested dependency checkout was not available. This is not a green AnyPS5 test baseline.
- Full AnyPS5 Windows runtime, Vulkan/AGC libraries, shader tools and the `libs` target were not built. The pinned build documentation requires x86-64 MinGW-w64 GCC with POSIX threads and SEH or DWARF exceptions, plus dependency submodules.
- No GTA VI compatibility, first render, or game behaviour was tested. The project's public research policy blocks work requiring game files; only the lawful public source and non-game fixture tests were used.

## Existing capability gaps

The fork's `docs/research/limitations-and-risks.md`, based on the pinned AnyPS5 debt data, identifies concrete work areas: libSceAgcDriver (97/167 functions and 312 behaviour-gap entries), libSceVideoOut (78/290), libSceAudioOut (78/219), libScePad (56/222), core library debt, and shader recompiler coverage of 1,484/1,560 gfx1013 reference forms with 126 unsupported code paths. These are AnyPS5 implementation/debt counts, not GTA VI import requirements or proof of game compatibility. Without lawful game imports and behavior fixtures, selecting a game-specific first missing API or implementing an AGC/shader function would be speculation.

## Reproduce

From a Visual Studio Developer PowerShell x64 prompt, use the existing repository commands:

```powershell
scripts\\build-windows.bat Release
python scripts/update_progress.py --check
python -m unittest discover -s tests/python -v
python -I tests/test_check_app0.py
```

For the documented Windows AnyPS5 runtime build, install the exact MinGW-w64 distribution/version and its prerequisites listed in `docs/build.md` and the pinned AnyPS5 build guide, then run the documented CMake configure/build/tests and `libs` target. Do not change compiler families mid-build.
