# Remaining functions and implementation work

Further AnyPS5 compatibility work remains. Existing debt figures below come from the project's documented audit, not from GTA VI imports or measured application compatibility:

- `libSceAgcDriver`: 97 of 167 functions declared implemented; 312 documented behavior-gap entries.
- `libSceVideoOut`: 78 of 290.
- `libSceAudioOut`: 78 of 219.
- `libScePad`: 56 of 222.
- gfx1013 reference forms: 1,557 of 1,560 translated by the current scanner. The scanner also reports 127 unsupported throw sites; this is a different metric from the older 126-path audit and does not itself identify actionable forms.

These figures do not identify which missing behavior is needed by an application. A code change needs an authoritative public behavioral source or a synthetic upstream test oracle. The validation-enabled shader/AGC build is partial because of the Windows Security quarantine block; `scripts/build-anyps5-windows.ps1` enables those tests. The three remaining gfx1013 reference forms are `S_SCRATCH_STORE_DWORD`, `S_SCRATCH_STORE_DWORDX2`, and `S_SCRATCH_STORE_DWORDX4`; their gfx1013 scratch address mapping remains unestablished. `sceKernelStopUnloadModule` still lacks a proven `module_stop` entry address/ABI in relinker metadata, so ELF `DT_FINI` is not substituted.

The `execl` family test does not cover successful process replacement. Runtime execution of homebrew and actual title imports remain unverified. No unknown or untested API is marked complete. Full CTest had 122 failures and 37 skipped tests; many AGC failures were unlaunchable binaries after Windows Security quarantine, while additional upstream checks failed independently. Consult `TEST_RESULTS.md` before treating the baseline suite as green. See `BLOCKERS.md` for source-boundary and runtime constraints.
