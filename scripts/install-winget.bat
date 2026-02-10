@echo off

@REM This script installs winget, the Windows Package Manager, on the system.
@REM It checks if winget is already installed and if not, it downloads and installs it using the latest release obtained from the official GitHub repository.

set "install=0"

@REM Check if winget is already installed
where winget >nul 2>&1
if %errorlevel% equ 0 (
    echo 'winget' is already installed.
    set "install=1"
)



@echo on

