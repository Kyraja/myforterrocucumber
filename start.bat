@echo off
cd /d "%~dp0"
timeout /t 1 /nobreak > nul
start "" "http://localhost:5173"
powershell -ExecutionPolicy Bypass -File "%~dp0server.ps1"
pause
