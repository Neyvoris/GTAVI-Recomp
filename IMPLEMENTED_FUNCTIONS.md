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

## Directed f32 rounding for f16 interpolation

- `Translation/src/AttributeInstructions.cpp::interpolationModeF16` carries FLOAT_MODE f32 rounding (`nearest-even`, `+infinity`, `-infinity`, `zero`) for `v_interp_p1ll_f16` and `v_interp_p1lv_f16`, whose results are f32. SPIR-V backends use exact directed rounding, preserve directed signed-zero behavior, and select infinity versus max finite correctly on overflow.
- `InterpolationModes.cpp::RunDirectedF32` checks positive/negative half-ULP ties, the least subnormal midpoint, and finite-input overflow for both instruction forms across all four rounding modes and integer/Float64 backends where available. Release rebuild passed; `agc_driver_interpolation_f16`, `agc_driver_interpolation_modes`, and `agc_driver_pixel_exec_interpolation` passed 3/3 on RTX 4060.
- AnyPS5 commit `2e9fce90f53ba81057ceea786728d7247b5374f4` is pushed to `Neyvoris/AnyPS5:codex/gtavi-compatibility-advance`. This does not establish general arithmetic-rounding completeness or PS5 application compatibility.

## Previous isolated libkernel work

- `execl`, `execle`, and `execlp` variadic entry points are present in `third_party/AnyPS5/core/libs/prx/libkernel/System/src/Process.cpp`, declarations in `Api.hpp`, from public AnyPS5 commit `65eaf885f894447d9782f439dcd93e07cdd1cffc` (included in the branch history before the current merge).
- The earlier `guest_exec_variadic` targeted build and test passed; successful process replacement and console-specific variadic ABI are not verified.

## DS_SRC2 64-bit LDS and GDS shader forms

- `RdnaMemoryOpDecoder.cpp` now recognizes the gfx1013 DS_SRC2 U64/I64/F64 forms for add, sub, reverse-sub, inc/dec, signed/unsigned min/max, bitwise and/or/xor, write, and finite-value floating min/max. `MemoryInstructionDispatch.cpp` maps these to existing shared-memory 64-bit atomic IR operations; `SharedMemoryInstructions.cpp::dsSrc2U64` reads the second LDS operand at `offset1`, operates on the target at `offset0`, and honors exec masks and denormal-flush metadata.
- GDS source-2 instructions now use the existing M0-base address mapping and GDS memory resource. `agc_driver_gds_m0_base` executes `ds_add_src2_u32` and `ds_add_src2_u64` with 32 active lanes, verifies exact final words, and checks untouched neighboring words. The 64-bit floating GDS min/max path remains explicitly rejected. GPU coverage currently establishes ADD at U32/U64, not every GDS source-2 opcode.
- Floating min/max GPU coverage currently uses finite non-NaN LDS values; NaN payload/propagation, signed-zero ties, infinities, and denormals are not individually verified.
- `agc_driver_lds_src2` executes all 15 opcodes and compares both result dwords for each of 32 lanes against scalar reference functions. `ds_src2_u64` checks the generated IR operation mapping. The focused tests do not establish all possible edge-case semantics.
- Commit `7d69cb0e68519660a3842134ac7f2dcb6ad03976` adds GDS source-2 translation and U32/U64 GPU checks. `agc_driver_gds_m0_base`, `agc_driver_lds_src2`, and `ds_src2_u64` passed 3/3 on RTX 4060. A separate rerun of the GDS execution test confirmed `VK_LAYER_KHRONOS_validation` was loaded and reported no VUID or validation errors.

## Scalar buffer stores

- The SMEM decoder recognizes scalar buffer store opcodes `0x18`, `0x19`, and `0x1a` as DWORD, DWORDX2, and DWORDX4. Descriptor base validation now requires four SGPRs for scalar buffer load/store descriptors; other scalar address forms retain pair validation.
- `TranslationContext::sBufferStore` emits a buffer write with the decoded immediate offset, dynamic scalar offset, coherence metadata, and component width. It elects one active lane with `ReadFirstLane` and the EXEC mask to avoid duplicate wave-wide writes.
- `scalar_buffer_store` verifies decoder fields, width metadata, generated IR and active-lane guard. `agc_driver_sbuffer_store` executes all three widths on the RTX 4060 and verifies exact target and untouched buffer words. Both pass; runtime execution also passes under the Khronos Vulkan validation layer.
- AnyPS5 commit `8774f2f9b9` (`feat(shader): translate scalar buffer stores`) is pushed to `Neyvoris/AnyPS5:codex/gtavi-compatibility-advance`. These tests cover aligned, in-bounds DWORD stores and do not claim all SMEM address modes or unusual EXEC masks.

## Scalar buffer atomics

- SMEM opcodes `0x40`, `0x42–0x4a`, `0x60`, and `0x62–0x6a` decode to scalar buffer SWAP, ADD, SUB, signed/unsigned MIN/MAX, AND, OR, and XOR at 32 and 64 bits. Translation uses existing Vulkan atomic IR, elects one active lane per wave, and broadcasts the prior value when GLC is set. `scalar_buffer_atomic_add` and `agc_driver_sbuffer_atomic_add` cover each operation with GLC off/on; signed and unsigned min/max use values whose order differs.
- Follow-up adds `S_BUFFER_ATOMIC_CMPSWAP` and `_X2` at SMEM opcodes `0x41` and `0x61`, respectively. Translation supplies both desired and comparator operands to existing `BufferAtomicCmpSwap32/64` IR. IR tests check arity/types and wave leader guard; RTX 4060 execution tests verify successful compare-and-replace for both widths and GLC forms. Opcode encodings are also listed by LLVM's [GFX10 SM instruction definitions](https://github.com/llvm/llvm-project/blob/main/llvm/lib/Target/AMDGPU/SMInstructions.td).
- Follow-up also adds `S_BUFFER_ATOMIC_INC/DEC` and X2 forms (SMEM `0x4b/0x4c/0x6b/0x6c`) using existing backend atomic update ops. GPU reference functions cover the wrap/limit branch (`old >= limit` for INC; `old == 0 || old > limit` for DEC); IR checks verify routing and lane guard. These tests passed alongside the compare-swap cases, 2/2.
- Implemented the complete scalar-address `S_ATOMIC_*` set: 13 DWORD forms at SMEM `0x80–0x8c` and 13 X2 forms at `0xa0–0xac` (swap, compare-swap, add/sub, signed/unsigned min/max, bitwise ops, INC/DEC). Translation uses the existing `AddressAtomic` IR/backend, elects one active EXEC lane per wave, and broadcasts GLC results, splitting U64 returns into SGPR pairs. IR tests verify all 26 opcode mappings, operand arity, width, and lane guards. RTX 4060 Vulkan tests validate the exact memory/result function for every opcode with GLC off/on, including successful compare-swap and INC/DEC limit behavior. The GPU+IR pair passed 2/2, and the adjacent regression suite passed 6/6.
- Added raw scalar `S_STORE_DWORD/X2/X4` (SMEM `0x10–0x12`) using `StoreAddressU32/U32x2/U32x4`. Translation elects one active EXEC lane and passes the SGPR base pair plus scalar offset into existing physical-address store operations. IR checks verify resource metadata, component width, and guard; RTX 4060 Vulkan tests verify all written words and surrounding sentinels. The test maps the target through a buffer descriptor in the same shader because raw host pointers without a registered BDA mapping correctly faulted.
- Scalar-buffer atomic ops pass at both widths; all scalar-address atomic ops pass DWORD/X2; scalar raw stores pass DWORD/X2/X4. Vulkan validation was explicitly enabled for prior buffer RMW runs; validation-layer loading was not confirmed for the latest new-path tests. Verified raw-address access is aligned, in-bounds, and one wave at a time. Multi-wave contention, BDA fault-boundary behavior, and memory-order interactions remain unverified. Commits `bd28b1e3ab`, `17f36dc3f6`, `45a0194afa`, `aacb4abb48`, and `126087d9ea` are pushed.

Function-level completion claims require a behavior test and authoritative or synthetic expected results. Aggregate progress counters are not proof by themselves.
