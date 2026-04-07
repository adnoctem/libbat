@echo off

rem ==============================================================
rem Install PowerShell Core (PowerShell 7) via winget
rem
rem Since all Windows versions bundle Windows PowerShell by default, this script
rem focuses on installing PowerShell Core (Microsoft.PowerShell), the cross-platform
rem version. winget must be installed first — run 'install-winget.cmd' if needed.
rem
rem Usage:
rem   install-powershell.cmd
rem ==============================================================

set "LIB_DIR=%~dp0..\lib"

@REM Check if winget is available
where winget >nul 2>&1
if %errorlevel% neq 0 (
    call "%LIB_DIR%\log.cmd" :log_error "winget is not installed. Please run 'install-winget.cmd' first."
    exit /b 1
)

@REM Check if PowerShell Core is already installed
where pwsh >nul 2>&1
if %errorlevel% equ 0 (
    call "%LIB_DIR%\log.cmd" :log "PowerShell Core is already installed."
    goto :eof
)

@REM Require administrative privileges
call "%LIB_DIR%\permission.cmd" :require_admin
if %errorlevel% neq 0 exit /b 1

@REM Install PowerShell Core via winget for all users
call "%LIB_DIR%\log.cmd" :log "Installing PowerShell Core..."
winget install --id Microsoft.PowerShell --exact --silent --scope machine --accept-package-agreements --accept-source-agreements

if %errorlevel% equ 0 (
    call "%LIB_DIR%\log.cmd" :log "PowerShell Core installed successfully."
) else (
    call "%LIB_DIR%\log.cmd" :log_error "PowerShell Core installation failed with error code %errorlevel%."
    exit /b 1
)

@echo on
