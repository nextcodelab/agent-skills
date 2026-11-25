@echo off
call "%~dp0..\python-video\python-video.cmd" "%~dp0render.py" %*
exit /b %errorlevel%
