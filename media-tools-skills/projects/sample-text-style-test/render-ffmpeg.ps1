param([string]$OutputPath)
if (-not $OutputPath) { $OutputPath = Join-Path $env:USERPROFILE 'Downloads\Sample\text-style-test-15s.mp4' }
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$ffmpeg = Join-Path $root 'tools\ffmpeg\bin\ffmpeg.exe'
if (-not (Test-Path -LiteralPath $ffmpeg)) { throw "Bundled FFmpeg not found: $ffmpeg" }
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $OutputPath) | Out-Null
$graph = Join-Path $PSScriptRoot 'ffmpeg-filtergraph.txt'
& $ffmpeg -hide_banner -y -f lavfi -i 'color=c=0x0c1018:s=1080x1920:r=30:d=3.2' -f lavfi -i 'color=c=0x0c1018:s=1080x1920:r=30:d=3.2' -f lavfi -i 'color=c=0x0c1018:s=1080x1920:r=30:d=3.2' -f lavfi -i 'color=c=0x0c1018:s=1080x1920:r=30:d=3.2' -f lavfi -i 'color=c=0x0c1018:s=1080x1920:r=30:d=3.2' -filter_complex_script $graph -map '[vout]' -t 15 -r 30 -c:v libx264 -preset medium -crf 20 -pix_fmt yuv420p -movflags +faststart $OutputPath
if ($LASTEXITCODE -ne 0) { throw "FFmpeg exited with code $LASTEXITCODE" }
Write-Output "Rendered $OutputPath"
