@echo off
setlocal EnableExtensions

REM BetterTTY Windows portable ZIP helper wrapper.
REM Run after scripts\windows-deploy-release.bat.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0windows-package-portable.ps1" %*
exit /b %ERRORLEVEL%
