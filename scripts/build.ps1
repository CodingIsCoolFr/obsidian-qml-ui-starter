param(
    [ValidateSet("Debug", "Release")]
    [string]$Configuration = "Release",
    [string]$BuildDirectory = "build"
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$build = Join-Path $root $BuildDirectory

cmake -S $root -B $build -DCMAKE_BUILD_TYPE=$Configuration
cmake --build $build --config $Configuration --parallel

Write-Host "Built Obsidian UI Starter in $build"
