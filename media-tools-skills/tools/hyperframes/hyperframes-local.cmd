@echo off
setlocal
set "HF_ROOT=%~dp0"
set "HF_NODE=%HF_ROOT%runtime\node-v26.8.1-win-x64\node.exe"
set "HF_CLI=%HF_ROOT%app\node_modules\hyperframes\bin\hyperframes.mjs"
set "PATH=%HF_ROOT%..\ffmpeg\bin;%PATH%"
if not exist "%HF_NODE%" (echo Missing bundled Node runtime & exit /b 2)
if not exist "%HF_CLI%" (echo Missing local HyperFrames package & exit /b 2)
set "HF_BROWSER=%HF_ROOT%..\browser\chrome-headless-shell-win64\chrome-headless-shell.exe"
if not exist "%HF_BROWSER%" set "HF_BROWSER=%HF_ROOT%..\browser\chrome.exe"
if not exist "%HF_BROWSER%" set "HF_BROWSER=%HF_ROOT%..\browser\chrome-headless-shell-158.0.8127.36-win64\chrome-headless-shell.exe"
if exist "%HF_BROWSER%" set "HYPERFRAMES_BROWSER_PATH=%HF_BROWSER%"
if /I "%~1"=="cloud" exit /b 3
if /I "%~1"=="publish" exit /b 3
if /I "%~1"=="share" exit /b 3
if /I "%~1"=="lambda" exit /b 3
if /I "%~1"=="cloudrun" exit /b 3
if /I "%~1"=="media-use" exit /b 3
"%HF_NODE%" "%HF_CLI%" %*
exit /b %ERRORLEVEL%
