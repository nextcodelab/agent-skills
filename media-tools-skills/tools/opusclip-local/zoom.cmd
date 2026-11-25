@echo off
setlocal
set "ROOT=%~dp0..\.."
set "PY=%ROOT%\tools\python\3.12.10-embed-amd64\python.exe"
if not exist "%PY%" (echo Missing bundled Python runtime & exit /b 2)
"%PY%" "%~dp0scripts\zoom.py" %*
exit /b %ERRORLEVEL%
