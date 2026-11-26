# Implemented functions and verified work

## AnyPS5 integration

- Merged the public AnyPS5 `main` branch into the user-owned fork's isolated branch `codex/gtavi-compatibility-advance`; merge commit `dd95a75a55`. This brings the public upstream changes to libSceAgcDriver/AGC, shader recompiler, system libraries, build tooling, and tests into the fork branch. It does not claim every export/path is complete.
- The merge commit itself is the exact source change boundary. Review the source history and test files with `git show --stat dd95a75a55` in `third_party/AnyPS5`.

## Windows x64 build evidence

- Configured full-runtime mode with tests enabled, SPIRV-Tools enabled, and bundled dependencies using MSYS2 UCRT64 MinGW-w64 GCC 16.1, CMake 4.4.4, Ninja, and Vulkan SDK 1.4.363.0.
- Successfully built the shader recompiler/AGC driver target and PRX targets for `libSceAgcDriver`, `libSceSystemService`, `libSceUserService`, `libSceSaveData`, `libSceAppContent`, and `libSceSysmodule`.
- Semantic tests passed for shader overwrite proof, memory decoder tolerance, scalar scratch-load unsupported behavior, SystemService, UserService, Sysmodule, AGC pipelined fill, and pixel execution interpolation. The AGC cases also passed with the Khronos Vulkan validation layer loaded.
- Targeted test/build means those code paths compile and their listed assertions pass. It does not establish console ABI equivalence, general Vulkan correctness, or guest-app compatibility.

## Previous isolated libkernel work

- `execl`, `execle`, and `execlp` variadic entry points are present in `third_party/AnyPS5/core/libs/prx/libkernel/System/src/Process.cpp`, declarations in `Api.hpp`, from public AnyPS5 commit `65eaf885f894447d9782f439dcd93e07cdd1cffc` (included in the branch history before the current merge).
- The earlier `guest_exec_variadic` targeted build and test passed; successful process replacement and console-specific variadic ABI are not verified.

Function-level completion claims require a behavior test and authoritative or synthetic expected results. Aggregate progress counters are not proof by themselves.
