@echo off
setlocal
set "ROOT=%~dp0..\.."
set "PY=%ROOT%\tools\python\3.12.10-embed-amd64\python.exe"
if not exist "%PY%" (echo Missing bundled Python runtime. See tools\README.md & exit /b 2)
"%PY%" "%~dp0scripts\caption_batch.py" %*
exit /b %ERRORLEVEL%
