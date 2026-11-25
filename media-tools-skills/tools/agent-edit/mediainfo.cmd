@echo off
setlocal
"%~dp0..\mediainfo\26.10\MediaInfo.exe" %*
exit /b %errorlevel%
