@echo off
setlocal
set "ROOT=%~dp0..\.."
set "PY=%ROOT%\tools\python\3.12.10-embed-amd64\python.exe"
if not exist "%PY%" (echo Bundled Python not found: "%PY%" 1>&2 & exit /b 2)
"%PY%" "%~dp0scripts\media_workbench.py" %*
exit /b %errorlevel%
