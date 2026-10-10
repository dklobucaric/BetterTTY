<#
BetterTTY Windows portable ZIP helper.

Run after scripts\windows-deploy-release.bat has produced dist\windows-release.

Usage:
  powershell -ExecutionPolicy Bypass -File scripts\windows-package-portable.ps1

Optional overrides:
  powershell -ExecutionPolicy Bypass -File scripts\windows-package-portable.ps1 -Version 1.0.2 -Arch x86_64
#>

param(
    [string]$Version = "",
    [string]$Arch = "x86_64",
    [string]$DistDir = "dist\windows-release",
    [string]$OutputDir = "dist"
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Resolve-Path (Join-Path $scriptDir "..")

function Get-ProjectVersion {
    $cmakeFile = Join-Path $projectRoot "CMakeLists.txt"
    if (-not (Test-Path $cmakeFile)) {
        throw "Cannot extract project(VERSION ...) from CMakeLists.txt."
    }

    $content = Get-Content -Path $cmakeFile -Raw
    $match = [regex]::Match($content, '(?m)^\s*VERSION\s+(\d+\.\d+\.\d+)\s*$')
    if ($match.Success) {
        return $match.Groups[1].Value
    }

    throw "Cannot extract project(VERSION ...) from CMakeLists.txt."
}

if ([string]::IsNullOrWhiteSpace($Version)) {
    $Version = Get-ProjectVersion
}

$distPath = Resolve-Path -Path (Join-Path $projectRoot $DistDir) -ErrorAction SilentlyContinue
if (-not $distPath) {
    Write-Error "Windows portable folder not found: $DistDir. Run scripts\windows-deploy-release.bat first."
}

$exePath = Join-Path $distPath "BetterTTY.exe"
if (-not (Test-Path $exePath)) {
    Write-Error "BetterTTY.exe not found in $DistDir. Run scripts\windows-deploy-release.bat first."
}

$outputPath = Join-Path $projectRoot $OutputDir
New-Item -ItemType Directory -Force -Path $outputPath | Out-Null

$zipName = "BetterTTY-$Version-Windows-$Arch-portable.zip"
$zipPath = Join-Path $outputPath $zipName

if (Test-Path $zipPath) {
    Remove-Item -Force $zipPath
}

Write-Host "[BetterTTY] Package version: $Version"
Write-Host "[BetterTTY] Creating Windows portable ZIP: $zipPath"
Compress-Archive -Path (Join-Path $distPath "*") -DestinationPath $zipPath -CompressionLevel Optimal
Write-Host "[BetterTTY] Windows portable ZIP ready: $zipPath"
