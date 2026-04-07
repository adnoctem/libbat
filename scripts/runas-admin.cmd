@echo off

rem ==============================================================
rem Run a .cmd script with administrator privileges
rem
rem Usage:
rem   runas-admin.cmd <script>
rem
rem Arguments:
rem   <script>  Full path to the .cmd script to run as Administrator.
rem ==============================================================

set "LIB_DIR=%~dp0..\lib"
set "TARGET=%~1"

@REM Ensure a target script argument was provided
if "%TARGET%"=="" (
    call "%LIB_DIR%\log.cmd" :log_error "No script specified. Usage: runas-admin.cmd <script>"
    exit /b 1
)

@REM Check if we are currently running with administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    call "%LIB_DIR%\log.cmd" :log_error "This script must be run as Administrator. Right-click and select 'Run as Administrator'."
    exit /b 1
)

@REM Run the target script in the current command prompt session with inherited privileges
call "%LIB_DIR%\log.cmd" :log "Running '%TARGET%' as Administrator..."
call "%TARGET%"

if %errorlevel% equ 0 (
    call "%LIB_DIR%\log.cmd" :log "'%TARGET%' completed successfully."
) else (
    call "%LIB_DIR%\log.cmd" :log_error "'%TARGET%' failed with error code %errorlevel%."
    exit /b %errorlevel%
)
