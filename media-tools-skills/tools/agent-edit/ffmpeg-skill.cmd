@echo off
setlocal
set "ROOT=%~dp0..\.."
set "PATH=%ROOT%\tools\ffmpeg\bin;%PATH%"
"%ROOT%\tools\python\3.12.10-embed-amd64\python.exe" "%~dp0launch.py" ffmpeg %*
exit /b %errorlevel%
