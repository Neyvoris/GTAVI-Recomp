param(
    [ValidateSet('Release', 'Debug')]
    [string]$Configuration = 'Release',
    [string]$MinGWBin,
    [string]$BuildDirectory,
    [switch]$SkipSubmoduleUpdate
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$sourceDir = Join-Path $repoRoot 'third_party/AnyPS5'
$buildDir = if ($BuildDirectory) {
    [System.IO.Path]::GetFullPath($BuildDirectory)
} else {
    Join-Path $repoRoot "build/anyps5-windows-x64/$Configuration"
}

function Find-Tool([string]$Name, [string[]]$Candidates) {
    $fromPath = Get-Command $Name -ErrorAction SilentlyContinue
    if ($fromPath) { return $fromPath.Source }
    foreach ($candidate in $Candidates) {
        if ($candidate -and (Test-Path -LiteralPath $candidate -PathType Leaf)) { return $candidate }
    }
    throw "Could not find $Name. Add it to PATH or pass its location in the documented environment."
}

if (-not $SkipSubmoduleUpdate) {
    & git -C $repoRoot submodule update --init --recursive
    if ($LASTEXITCODE -ne 0) { throw 'Recursive submodule initialization failed.' }
}
if (-not (Test-Path -LiteralPath (Join-Path $sourceDir 'CMakeLists.txt'))) {
    throw "AnyPS5 submodule is missing: $sourceDir"
}

if (-not $MinGWBin) {
    $gxxOnPath = Get-Command g++.exe -ErrorAction SilentlyContinue
    if ($gxxOnPath) { $MinGWBin = Split-Path -Parent $gxxOnPath.Source }
}
$gccCandidates = @()
if ($MinGWBin) { $gccCandidates += (Join-Path $MinGWBin 'gcc.exe') }
$gccCandidates += @('C:\msys64\ucrt64\bin\gcc.exe', 'G:\MSYS2\ucrt64\bin\gcc.exe')
$gxxCandidates = @()
if ($MinGWBin) { $gxxCandidates += (Join-Path $MinGWBin 'g++.exe') }
$gxxCandidates += @('C:\msys64\ucrt64\bin\g++.exe', 'G:\MSYS2\ucrt64\bin\g++.exe')
$gcc = Find-Tool 'gcc.exe' $gccCandidates
$gxx = Find-Tool 'g++.exe' $gxxCandidates
$MinGWBin = Split-Path -Parent $gxx
$env:PATH = "$MinGWBin;$env:PATH"
$cmake = Find-Tool 'cmake.exe' @('C:\Program Files\CMake\bin\cmake.exe')
$ctest = Find-Tool 'ctest.exe' @((Join-Path (Split-Path -Parent $cmake) 'ctest.exe'))
$ninja = Find-Tool 'ninja.exe' @(
    'C:\Users\ivano\AppData\Local\Microsoft\WinGet\Packages\Ninja-build.Ninja_Microsoft.Winget.Source_8wekyb3d8bbwe\ninja.exe'
)

$target = (& $gcc -dumpmachine).Trim()
if ($LASTEXITCODE -ne 0 -or $target -notmatch '^x86_64-w64-mingw32$') {
    throw "Expected x86_64-w64-mingw32 GCC; detected '$target'."
}
$gccVersion = (& $gcc -dumpfullversion).Trim()
Write-Host "AnyPS5 Windows x64 build: $Configuration"
Write-Host "GCC: $gccVersion ($target)"
Write-Host "CMake: $cmake"
Write-Host "Ninja: $ninja"
Write-Host "Build directory: $buildDir"

& $cmake -S $sourceDir -B $buildDir -G Ninja `
    "-DCMAKE_MAKE_PROGRAM:FILEPATH=$ninja" `
    "-DCMAKE_C_COMPILER:FILEPATH=$($gcc.Replace('\','/'))" `
    "-DCMAKE_CXX_COMPILER:FILEPATH=$($gxx.Replace('\','/'))" `
    "-DCMAKE_BUILD_TYPE=$Configuration" `
    -DBUILD_TESTING=ON `
    -DANYPS5_RELINKER_ONLY=OFF `
    -DANYPS5_USE_SYSTEM_DEPS=OFF `
    -DSKIP_SPIRV_TOOLS_INSTALL=ON `
    -DANYPS5_ENABLE_SPIRV_TOOLS=ON
if ($LASTEXITCODE -ne 0) { throw 'AnyPS5 CMake configure failed.' }

$buildLog = Join-Path $buildDir 'build.log'
$buildTemp = Join-Path $buildDir 'tmp'
New-Item -ItemType Directory -Force -Path $buildTemp | Out-Null
$env:TMP = $buildTemp
$env:TEMP = $buildTemp
$env:TMPDIR = $buildTemp.Replace('\', '/')
& $cmake --build $buildDir --parallel 12 2>&1 | Tee-Object -FilePath $buildLog
$buildExitCode = $LASTEXITCODE
if ($buildExitCode -ne 0) { throw "AnyPS5 build failed; see $buildLog" }

$testLog = Join-Path $buildDir 'ctest.log'
& $cmake -E env "PATH=$((Split-Path -Parent $gcc));$env:PATH" $ctest --test-dir $buildDir --output-on-failure --no-tests=error --parallel 12 2>&1 | Tee-Object -FilePath $testLog
$testExitCode = $LASTEXITCODE
if ($testExitCode -ne 0) { throw "AnyPS5 CTest run failed; see $testLog" }

Write-Host "PASS: AnyPS5 $Configuration runtime build and registered tests."
