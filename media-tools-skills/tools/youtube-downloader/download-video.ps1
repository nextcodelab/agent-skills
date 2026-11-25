param(
    [Parameter(Mandatory = $true)]
    [string]$Url,
    [Parameter(Mandatory = $true)]
    [string]$OutputDirectory,
    [string]$Format = 'bv*+ba/b',
    [string]$HttpChunkSize = '10M'
)

$ErrorActionPreference = 'Stop'
$toolDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$downloader = Join-Path $toolDir 'yt-dlp.exe'

if (-not (Test-Path -LiteralPath $downloader)) {
    $releaseUrl = 'https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe'
    Invoke-WebRequest -Uri $releaseUrl -OutFile $downloader
}

New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
$outputTemplate = Join-Path $OutputDirectory '%(id)s.%(ext)s'
& $downloader --no-cache-dir --no-playlist --http-chunk-size $HttpChunkSize --format $Format --merge-output-format mkv --output $outputTemplate $Url
if ($LASTEXITCODE -ne 0) {
    throw "yt-dlp exited with code $LASTEXITCODE"
}
