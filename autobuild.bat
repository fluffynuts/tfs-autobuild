@echo off
set START="%cd%"
cd /d "%~dp0"
powershell -f autobuild.ps1
cd /d "%START%"