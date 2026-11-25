@echo off
setlocal
set "ROOT=%~dp0..\.."
set "PATH=%ROOT%\tools\ffmpeg\bin;%PATH%"
set "VIDEO_EDITING_FFMPEG_SKILL_DIR=%ROOT%\.agents\skills\ffmpeg-skill"
"%ROOT%\tools\python\3.12.10-embed-amd64\python.exe" "%~dp0launch.py" timeline %*
exit /b %errorlevel%
