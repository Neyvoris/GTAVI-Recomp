# Blockers and limits

- **Complete full-runtime build:** 37 AGC tool/test executable targets failed during post-link because Windows Security quarantined generated executables before `objcopy` could process them. Host security settings were not changed. 413 PRX library artifacts were produced, but the full runtime build is not clean.
- **Behavioral evidence:** aggregate missing-function and shader-path counts are not executable requirements. Without a public spec or a synthetic test oracle, implementing guessed semantics would be unsafe.
- **CTest:** The full 6,651-test run completed with 6,492 passes, 122 failures, and 37 skipped tests. Failures include missing/quarantined AGC executables and independent upstream test failures; this is not a green suite. See `TEST_RESULTS.md`.
- **Windows Security:** the system quarantined generated `agc_shader_replay.exe`, so its post-build `objcopy` step failed with `Invalid argument`. This is an observed local block, not confirmed as a false positive; security settings were not changed.
- **Runtime compatibility:** no legally available PS5 homebrew has been supplied or run. GTA VI, game files, and first-frame rendering were not tested.
- **Vulkan runtime:** Three focused tests passed with `VK_LAYER_KHRONOS_validation` explicitly loaded on NVIDIA RTX 4060. This validates those test paths only; it does not establish full rendering, presentation, or successful first-frame output from a homebrew application.
