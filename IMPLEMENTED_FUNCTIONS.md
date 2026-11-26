# Implemented functions and verified work

## AnyPS5 integration

- Merged the public AnyPS5 `main` branch into the user-owned fork's isolated branch `codex/gtavi-compatibility-advance`; merge commit `dd95a75a55`. This brings the public upstream changes to libSceAgcDriver/AGC, shader recompiler, system libraries, build tooling, and tests into the fork branch. It does not claim every export/path is complete.
- The merge commit itself is the exact source change boundary. Review the source history and test files with `git show --stat dd95a75a55` in `third_party/AnyPS5`.

## Windows x64 build evidence

- Configured full-runtime mode with tests enabled, SPIRV-Tools enabled, and bundled dependencies using MSYS2 UCRT64 MinGW-w64 GCC 16.1, CMake 4.4.4, Ninja, and Vulkan SDK 1.4.363.0.
- Successfully built the shader recompiler/AGC driver target and PRX targets for `libSceAgcDriver`, `libSceSystemService`, `libSceUserService`, `libSceSaveData`, `libSceAppContent`, and `libSceSysmodule`.
- Semantic tests passed for shader overwrite proof, memory decoder tolerance, scalar scratch-load unsupported behavior, SystemService, UserService, Sysmodule, AGC pipelined fill, and pixel execution interpolation. The AGC cases also passed with the Khronos Vulkan validation layer loaded.
- Targeted test/build means those code paths compile and their listed assertions pass. It does not establish console ABI equivalence, general Vulkan correctness, or guest-app compatibility.

## MIMG packed image stores

- `core/shader/recompiler/Translation/src/MemoryInstructions/ImageInstructions.cpp::TranslationContext::imageBy` now lowers MIMG `IMAGE_STORE_PCK2`, `IMAGE_STORE_PCK4`, and their mip forms to IR `ImageWrite` with packed width, mip, and address metadata. The prior implementation incorrectly routed store opcodes through `ImageRead`.
- `core/shader/recompiler/SpirvBackend/src/SpirvImageEmitter.cpp::EmitWriteOp` unpacks each packed 32-bit source word and emits per-texel storage image writes. It checks full-block bounds, clamps mip extents, rejects invalid mips, and retains explicit refusal for unmeasured layouts. `PackedStoreTexel` maps components using the guest packed format.
- Verified subset: 2D storage images, one dword of packed data, identity-swizzled UNORM/UINT/SINT layouts; PCK2 supports R8, R16, and RG8; PCK4 supports R8. The GPU test checks exact guest texture bytes, untouched bytes, edge lanes, and mip 1; unsupported combinations are asserted to fail during compilation.
- Regression tests: `core/libs/tests/ImagePckN.cpp` (`image_pck_n`) checks all four store opcode forms lower to `ImageWrite` and preserve memory metadata. `core/libs/prx/libSceAgcDriver/tests/execution/ImagePckN.cpp` (`agc_driver_image_pck_n`) executes PCK2/PCK4 stores on NVIDIA RTX 4060 and checks byte-accurate results. Both passed in Release and Debug; the Release Vulkan test passed with `VK_LAYER_KHRONOS_validation` enabled.
- This adds four opcode forms to the implemented behavior; it does not resolve all gfx1013 reference forms or all recompiler throw sites.

## Previous isolated libkernel work

- `execl`, `execle`, and `execlp` variadic entry points are present in `third_party/AnyPS5/core/libs/prx/libkernel/System/src/Process.cpp`, declarations in `Api.hpp`, from public AnyPS5 commit `65eaf885f894447d9782f439dcd93e07cdd1cffc` (included in the branch history before the current merge).
- The earlier `guest_exec_variadic` targeted build and test passed; successful process replacement and console-specific variadic ABI are not verified.

## DS_SRC2 64-bit LDS shader forms

- `RdnaMemoryOpDecoder.cpp` now recognizes the gfx1013 DS_SRC2 U64/I64/F64 forms for add, sub, reverse-sub, inc/dec, signed/unsigned min/max, bitwise and/or/xor, write, and finite-value floating min/max. `MemoryInstructionDispatch.cpp` maps these to existing shared-memory 64-bit atomic IR operations; `SharedMemoryInstructions.cpp::dsSrc2U64` reads the second LDS operand at `offset1`, operates on the target at `offset0`, and honors exec masks and denormal-flush metadata.
- GDS variants still throw explicitly because no GDS implementation or behavior oracle exists. Floating min/max GPU coverage currently uses finite non-NaN values; NaN payload/propagation, signed-zero ties, infinities, and denormals are not individually verified.
- `agc_driver_lds_src2` executes all 15 opcodes and compares both result dwords for each of 32 lanes against scalar reference functions. It passed on NVIDIA RTX 4060 with `VK_LAYER_KHRONOS_validation` loaded. `ds_src2_u64` checks the generated IR operation mapping. The focused tests do not establish all possible edge-case semantics.

## Scalar buffer stores

- The SMEM decoder recognizes scalar buffer store opcodes `0x18`, `0x19`, and `0x1a` as DWORD, DWORDX2, and DWORDX4. Descriptor base validation now requires four SGPRs for scalar buffer load/store descriptors; other scalar address forms retain pair validation.
- `TranslationContext::sBufferStore` emits a buffer write with the decoded immediate offset, dynamic scalar offset, coherence metadata, and component width. It elects one active lane with `ReadFirstLane` and the EXEC mask to avoid duplicate wave-wide writes.
- `scalar_buffer_store` verifies decoder fields, width metadata, generated IR and active-lane guard. `agc_driver_sbuffer_store` executes all three widths on the RTX 4060 and verifies exact target and untouched buffer words. Both pass; runtime execution also passes under the Khronos Vulkan validation layer.
- AnyPS5 commit `8774f2f9b9` (`feat(shader): translate scalar buffer stores`) is pushed to `Neyvoris/AnyPS5:codex/gtavi-compatibility-advance`. These tests cover aligned, in-bounds DWORD stores and do not claim all SMEM address modes or unusual EXEC masks.

## Scalar buffer atomic add

- SMEM opcode `0x42` now decodes as `S_BUFFER_ATOMIC_ADD`. The translation reuses the existing `BufferAtomicIAdd32` Vulkan lowering, elects one active lane per wave, and broadcasts the returned old value when GLC is set. Without GLC, the operation does not write a return value to the SGPR.
- `scalar_buffer_atomic_add` checks both GLC forms and IR lane guarding. `agc_driver_sbuffer_atomic_add` dispatches a 32-lane shader on RTX 4060, verifies the buffer was incremented once (not once per lane), and checks the returned pre-operation value by storing it to a second word. Both pass with Khronos validation enabled and no validation errors in the log.
- AnyPS5 commit `b1acbb97cc` (`feat(shader): translate scalar buffer atomic add`) is pushed to the fork branch. Verified scope is 32-bit add, aligned in-bounds descriptor access, one wave, and GLC return/no-return; other atomic operators and multi-wave contention remain unverified.

Function-level completion claims require a behavior test and authoritative or synthetic expected results. Aggregate progress counters are not proof by themselves.
