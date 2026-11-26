# Blockers and limits

- **Parent integration:** AnyPS5 fork branch `Neyvoris/AnyPS5:codex/gtavi-libkernel-exec-variadic` contains the change; update the parent `.gitmodules` URL and gitlink before calling it integrated.
- **Behavioral evidence:** aggregate missing-function and shader-path counts are not executable requirements. Without a public spec or a synthetic test oracle, implementing guessed semantics would be unsafe.
- **SPIR-V validation:** SPIR-V Tools are enabled in the active build, but the full shader/AGC test suite is not complete yet.
- **Windows Security:** the system quarantined generated `agc_shader_replay.exe`, so its post-build `objcopy` step failed with `Invalid argument`. This is an observed local block, not confirmed as a false positive; security settings were not changed.
- **Runtime compatibility:** no legally available PS5 homebrew has been supplied or run. GTA VI, game files, and first-frame rendering were not tested.
- **Vulkan runtime:** `vulkaninfo` detects the NVIDIA RTX 4060 and loading `VK_LAYER_KHRONOS_validation` succeeded; AGC execution and a rendered frame are still unverified.
