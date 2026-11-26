# Blockers and limits

- **AnyPS5 development fork:** the pinned code is a Git submodule of GTAVI-Recomp and is not owned by the parent fork. No AnyPS5 fork under the connected GitHub accounts was found. Keep the submodule clean and unchanged until a suitable fork/branch is available; do not write into upstream.
- **Behavioral evidence:** aggregate missing-function and shader-path counts are not executable requirements. Without a public spec or a synthetic test oracle, implementing guessed semantics would be unsafe.
- **SPIR-V validation:** the initial full build uses the project default `ANYPS5_ENABLE_SPIRV_TOOLS=OFF`; a separate validation-enabled build/test pass is needed before shader output can be claimed validated.
- **Runtime compatibility:** no legally available PS5 homebrew has been supplied or run. GTA VI, game files, and first-frame rendering were not tested.
- **Vulkan validation layer:** presence and successful activation of the Khronos validation layer on the local NVIDIA device have not yet been confirmed. A compiled AGC/Vulkan path is not equivalent to a validated rendered frame.
