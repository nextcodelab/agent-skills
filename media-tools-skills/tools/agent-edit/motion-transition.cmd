@echo off
setlocal
"%~dp0..\python\3.12.10-embed-amd64\python.exe" "%~dp0motion_transition.py" %*
exit /b %errorlevel%
