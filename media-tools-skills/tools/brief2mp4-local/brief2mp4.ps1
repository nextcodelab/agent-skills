param(
    [Parameter(Position = 0, Mandatory = $true)]
    [ValidateSet('doctor', 'init', 'render', 'lint', 'check-hf', 'snapshot', 'docs', 'finish', 'check', 'art-route', 'beat-grid', 'help')]
    [string]$Action,
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Arguments = @()
)

$ErrorActionPreference = 'Stop'
$toolRoot = Split-Path -Parent $PSScriptRoot
$root = Split-Path -Parent $toolRoot
$ffmpeg = Join-Path $toolRoot 'ffmpeg\bin\ffmpeg.exe'
$ffprobe = Join-Path $toolRoot 'ffmpeg\bin\ffprobe.exe'
$python = Join-Path $toolRoot 'python\3.12.10-embed-amd64\python.exe'
$hyperframes = Join-Path $toolRoot 'hyperframes\hyperframes-local.cmd'
$skillRoot = Join-Path $root '.agents\skills\brief2mp4-local'
$scripts = Join-Path $skillRoot 'scripts'
$env:PATH = (Join-Path $toolRoot 'ffmpeg\bin') + ';' + $env:PATH

function Invoke-HyperFrames([string[]]$CliArguments) {
    if (-not (Test-Path -LiteralPath $hyperframes)) { throw "Bundled HyperFrames wrapper missing: $hyperframes" }
    & $hyperframes @CliArguments
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

function Get-Option([string[]]$Items, [string]$Name, [string]$Default = '') {
    for ($i = 0; $i -lt $Items.Count; $i++) {
        if ($Items[$i] -eq $Name -and ($i + 1) -lt $Items.Count) { return $Items[$i + 1] }
    }
    return $Default
}

switch ($Action) {
    'help' {
        @'
brief2mp4 local bridge (PowerShell, no duplicate runtimes)
  doctor
  init <project-folder> [HyperFrames init arguments]
  render <project-folder> [render arguments]
  lint|check-hf|snapshot|docs [HyperFrames arguments]
  finish --in <video.mp4> --out <final.mp4> --seconds <n> [--audio <file>] [--size 1080x1920] [--fps 30]
  check <video.mp4> [--seconds <n>]
  art-route <brief.md>
  beat-grid <audio-file> [arguments passed to upstream script]
'@
    }
    'doctor' {
        $items = @(
            @{ Name = 'FFmpeg'; Path = $ffmpeg },
            @{ Name = 'ffprobe'; Path = $ffprobe },
            @{ Name = 'Portable Python'; Path = $python },
            @{ Name = 'HyperFrames wrapper'; Path = $hyperframes }
        )
        foreach ($item in $items) {
            if (Test-Path -LiteralPath $item.Path) { Write-Output "OK  $($item.Name): $($item.Path)" }
            else { Write-Output "MISSING  $($item.Name): $($item.Path)" }
        }
        if ((Test-Path $ffmpeg) -and (Test-Path $ffprobe) -and (Test-Path $python) -and (Test-Path $hyperframes)) {
            Write-Output 'Uses the toolkit-bundled runtimes; no installer or hosted service is called.'
        } else { exit 2 }
    }
    'init' {
        if (-not $Arguments -or $Arguments.Count -lt 1) { throw 'Usage: brief2mp4.ps1 init <project-folder> [HyperFrames init arguments]' }
        $cli = @('init') + $Arguments
        if ($cli -notcontains '--skip-skills') { $cli += '--skip-skills' }
        Invoke-HyperFrames $cli
    }
    { $_ -in 'render', 'lint', 'check-hf', 'snapshot', 'docs' } {
        $verb = if ($Action -eq 'check-hf') { 'check' } else { $Action }
        Invoke-HyperFrames (@($verb) + $Arguments)
    }
    'finish' {
        if (-not (Test-Path $ffmpeg)) { throw "Bundled FFmpeg missing: $ffmpeg" }
        $inputFile = Get-Option $Arguments '--in'
        $outputFile = Get-Option $Arguments '--out'
        $seconds = Get-Option $Arguments '--seconds'
        $audioFile = Get-Option $Arguments '--audio'
        $size = Get-Option $Arguments '--size' '1080x1920'
        $fps = Get-Option $Arguments '--fps' '30'
        if (-not $inputFile -or -not $outputFile -or -not $seconds) { throw 'Usage: finish --in INPUT --out OUTPUT --seconds SECONDS [--audio AUDIO] [--size WxH] [--fps N]' }
        if (-not (Test-Path -LiteralPath $inputFile)) { throw "Input not found: $inputFile" }
        if ($audioFile -and -not (Test-Path -LiteralPath $audioFile)) { throw "Audio not found: $audioFile" }
        if ($size -notmatch '^\d+x\d+$') { throw "Invalid --size '$size'; use WIDTHxHEIGHT." }
        $parts = $size -split 'x'
        $width = [int]$parts[0]
        $height = [int]$parts[1]
        $vf = "scale=${width}:${height}:force_original_aspect_ratio=decrease,pad=${width}:${height}:(ow-iw)/2:(oh-ih)/2,setsar=1,fps=${fps},format=yuv420p"
        $cmd = @('-hide_banner', '-y', '-i', $inputFile)
        if ($audioFile) { $cmd += @('-i', $audioFile) }
        else { $cmd += @('-f', 'lavfi', '-t', $seconds, '-i', 'anullsrc=channel_layout=stereo:sample_rate=48000') }
        $audioIndex = if ($audioFile) { '1:a:0' } else { '1:a:0' }
        $cmd += @('-map', '0:v:0', '-map', $audioIndex, '-vf', $vf, '-af', 'loudnorm=I=-14:TP=-1.5:LRA=11', '-t', $seconds, '-c:v', 'libx264', '-preset', 'slow', '-crf', '18', '-c:a', 'aac', '-b:a', '192k', '-ar', '48000', '-ac', '2', '-movflags', '+faststart', $outputFile)
        & $ffmpeg @cmd
        if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    }
    'check' {
        if (-not $Arguments -or -not (Test-Path -LiteralPath $Arguments[0])) { throw 'Usage: check <video.mp4> [--seconds N]' }
        $file = $Arguments[0]
        $expected = Get-Option $Arguments '--seconds'
        $raw = & $ffprobe -v error -show_streams -show_format -of json $file
        if ($LASTEXITCODE -ne 0) { throw 'ffprobe could not read the video.' }
        $info = ($raw -join "`n") | ConvertFrom-Json
        $video = $info.streams | Where-Object codec_type -eq 'video' | Select-Object -First 1
        $audio = $info.streams | Where-Object codec_type -eq 'audio' | Select-Object -First 1
        if (-not $video) { throw 'FAIL: no video stream found.' }
        $duration = [double]$info.format.duration
        Write-Output ("Video: {0}x{1}, {2}, {3} fps, {4:N3} seconds" -f $video.width, $video.height, $video.codec_name, $video.avg_frame_rate, $duration)
        if ($audio) { Write-Output ("Audio: {0}, {1} Hz, {2} channels" -f $audio.codec_name, $audio.sample_rate, $audio.channels) }
        else { Write-Output 'WARN: no audio stream.' }
        if ($expected) {
            $delta = [math]::Abs($duration - [double]$expected)
            if ($delta -le 0.04) { Write-Output "PASS: duration within 0.04 s of $expected s." }
            else { Write-Output "FAIL: duration differs by $([math]::Round($delta, 3)) s from $expected s."; $global:brief2mp4DurationMismatch = $true }
        }
        & $ffmpeg -v error -i $file -f null NUL
        if ($LASTEXITCODE -ne 0) { throw 'FAIL: FFmpeg decode reported errors.' }
        Write-Output 'PASS: full file decodes without FFmpeg errors.'
        if ($global:brief2mp4DurationMismatch) { exit 1 }
    }
    'art-route' {
        $script = Join-Path $scripts 'art_route.py'
        & $python $script @Arguments
        exit $LASTEXITCODE
    }
    'beat-grid' {
        $script = Join-Path $scripts 'beat_grid.py'
        & $python $script @Arguments
        exit $LASTEXITCODE
    }
}

