@echo off
setlocal
set "ROOT=%~dp0..\.."
set "OUTPUT=%USERPROFILE%\Downloads\Sample\text-style-test-15s-hyperframes.mp4"
"%ROOT%\tools\hyperframes\hyperframes-local.cmd" render "%~dp0" --output "%OUTPUT%"
exit /b %ERRORLEVEL%
