@echo off
setlocal
set "BUNDLE=%~dp0.."
set "FFMPEG_BINARY=%BUNDLE%\ffmpeg\bin\ffmpeg.exe"
set "IMAGEIO_FFMPEG_EXE=%FFMPEG_BINARY%"
"%BUNDLE%\python\3.12.10-embed-amd64\python.exe" -B "%~dp0launch.py" %*
exit /b %errorlevel%
