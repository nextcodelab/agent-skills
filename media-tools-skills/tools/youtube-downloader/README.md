# YouTube video downloader (local)

Downloads separate video and audio streams at the selected quality, then merges them into an MKV without re-encoding. Uses 10 MiB HTTP chunks and disables the yt-dlp cache. The first run downloads the official yt-dlp Windows executable from the yt-dlp GitHub release page into this tool folder.

```powershell
.\download-video.ps1 -Url "https://www.youtube.com/watch?v=VIDEO_ID" -OutputDirectory "C:\Users\Robel\Downloads\Clipping"
```

By default, `yt-dlp` selects the best available quality. Pass a format expression to limit resolution or choose a specific stream when disk space is limited. For example:

```powershell
.\download-video.ps1 -Url "https://www.youtube.com/watch?v=VIDEO_ID" -OutputDirectory "C:\Users\Robel\Downloads\Clipping" -Format "bv*[height<=1080]+ba/b[height<=1080]"
```

Output filenames use the YouTube video ID. Requires internet access and FFmpeg on PATH (or alongside yt-dlp). Use only for videos you are authorized to download.
