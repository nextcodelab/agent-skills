@echo off
call "%~dp0python-video.cmd" "%~dp0compose.py" %*
exit /b %errorlevel%
