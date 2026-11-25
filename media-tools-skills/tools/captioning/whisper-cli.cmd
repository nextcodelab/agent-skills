@echo off
setlocal
"%~dp0bin\whisper-bin-x64-b5454\Release\whisper-cli.exe" %*
exit /b %ERRORLEVEL%
