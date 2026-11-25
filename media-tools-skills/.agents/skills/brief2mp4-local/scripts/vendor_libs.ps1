param(
    [Parameter(Mandatory = $true)][string]$Project,
    [switch]$Three,
    [string]$Fonts = ""
)
$ErrorActionPreference = 'Stop'
if ($Fonts) { throw 'This portable toolkit uses project-local assets or installed system fonts. External font downloads are disabled.' }
$toolkitRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..\..')).Path
$cache = Join-Path $toolkitRoot 'tools\brief2mp4-local\vendor-cache'
$projectRoot = (Resolve-Path $Project).Path
$vendor = Join-Path $projectRoot 'vendor'
New-Item -ItemType Directory -Force -Path $vendor | Out-Null
$gsap = Join-Path $cache 'gsap.min.js'
if (-not (Test-Path $gsap)) { throw "Shared GSAP file is missing: $gsap" }
Copy-Item -LiteralPath $gsap -Destination (Join-Path $vendor 'gsap.min.js') -Force
Write-Output 'vendor: shared GSAP 3.15.0 -> vendor/gsap.min.js'
if ($Three) {
    $three = Join-Path $cache 'three.module.js'
    if (-not (Test-Path $three)) { throw "Shared Three.js file is missing: $three" }
    Copy-Item -LiteralPath $three -Destination (Join-Path $vendor 'three.module.js') -Force
    Copy-Item -LiteralPath (Join-Path $cache 'LICENSE-three.txt') -Destination (Join-Path $vendor 'LICENSE-three.txt') -Force
    Write-Output 'vendor: shared Three.js 0.170.0 -> vendor/three.module.js'
}
