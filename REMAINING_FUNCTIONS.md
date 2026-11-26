# Remaining functions and implementation work

No AnyPS5 compatibility function has been changed in this task so far. Existing debt figures below come from the pinned project's own documented audit, not from GTA VI imports or measured application compatibility:

- `libSceAgcDriver`: 97 of 167 functions declared implemented; 312 documented behavior-gap entries.
- `libSceVideoOut`: 78 of 290.
- `libSceAudioOut`: 78 of 219.
- `libScePad`: 56 of 222.
- gfx1013 reference shader forms: 1,484 of 1,560 decoded; 126 unsupported recompiler paths (these are separate project metrics and should not be summed).

These figures do not identify which missing behavior is needed by an application. A code change needs an authoritative public behavioral source or a synthetic upstream test oracle. The current validation-enabled shader/AGC tests are not part of the first build configuration; `scripts/build-anyps5-windows.ps1` enables them for the follow-up build.

No unknown or untested API is marked complete. See `BLOCKERS.md` for source-boundary and runtime constraints.
