@echo off

rem ==============================================================
rem Reconnect all mapped network drives
rem
rem Parses the output of 'net use' and attempts to reconnect every mapped
rem drive, regardless of its current status. Drives that are currently
rem unavailable will be noted in the log and re-established by the script.
rem
rem Usage:
rem   reconnect-shares.cmd [extra net use args]
rem
rem Examples:
rem   reconnect-shares.cmd
rem   reconnect-shares.cmd /user:mydomain\DomainUser
rem   reconnect-shares.cmd /user:mydomain\DomainUser MyPassword
rem ==============================================================

set "LIB_DIR=%~dp0..\lib"

@REM Require administrative privileges
@REM call "%LIB_DIR%\permission.cmd" :require_admin
@REM if %errorlevel% neq 0 exit /b 1

setlocal enabledelayedexpansion
set "RECONNECTED=0"
set "FAILED=0"
set "EXTRA_ARGS=%*"

call "%LIB_DIR%\log.cmd" :log "Scanning for mapped network drives..."

@REM Parse 'net use' output — columns are: Status  Drive  RemotePath  Network
@REM Filter to lines where the second token is a drive letter (e.g. X:)
for /f "tokens=1,2,3" %%a in ('net use') do (
    set "DRIVE=%%b"
    if "!DRIVE:~1,1!"==":" (
        if /i "%%a"=="Unavailable" (
            call "%LIB_DIR%\log.cmd" :log "%%b is currently unavailable and will be reconnected."
        )
        call "%LIB_DIR%\log.cmd" :log "Reconnecting %%b -> %%c ..."

        @REM Remove the existing mapping before re-establishing it
        net use "%%b" /delete /yes >nul 2>&1

        net use "%%b" "%%c" /persistent:yes %EXTRA_ARGS% >nul 2>&1
        set "RC=!errorlevel!"

        if "!RC!"=="0" (
            call "%LIB_DIR%\log.cmd" :log "Successfully reconnected %%b."
            set /a RECONNECTED+=1
        ) else (
            call "%LIB_DIR%\log.cmd" :log_warning "Failed to reconnect %%b to %%c (error !RC!)."
            set /a FAILED+=1
        )
    )
)

call "%LIB_DIR%\log.cmd" :log "Done. Reconnected: !RECONNECTED!, Failed: !FAILED!."
endlocal

@echo on
