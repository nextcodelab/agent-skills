@echo off
setlocal
"%~dp0..\python\3.12.10-embed-amd64\python.exe" -B "%~dp0lyrics_video.py" %*
exit /b %errorlevel%
