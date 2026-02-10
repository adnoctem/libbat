@echo off

@REM -----
@REM ref: https://stackoverflow.com/a/18746066
@REM Routing function calls ensure that the correct function is executed based on the label provided as an argument when calling the script.
@REM This allows for modular code organization and makes it easier to maintain and reuse functions across different batch scripts.
call:%*
exit /b %errorlevel%
@REM -----

goto :description
@REM Batch functions for checking administrative privileges in a batch script.
:description

@REM ---------------------------------------------------------------------------
@REM Batch function to check for administrative privileges
@REM Usage: call :require_admin
:require_admin
  net session >nul 2>&1 || (
    call "%~dp0\log.bat" :log_error "This script requires administrative privileges. Please run as administrator."
    exit /b 1
  )
exit /b 0