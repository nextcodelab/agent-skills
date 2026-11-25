@echo off
setlocal
set "ROOT=%~dp0..\.."
"%ROOT%\tools\python\3.12.10-embed-amd64\python.exe" "%~dp0podcast_hook.py" %*
exit /b %errorlevel%
