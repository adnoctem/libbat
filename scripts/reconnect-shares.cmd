@echo off

rem ==============================================================
rem Reconnect all unavailable mapped network drives
rem
rem Parses the output of 'net use' to find drives with an 'Unavailable' status
rem and attempts to reconnect each one without requiring hardcoded paths.
rem
rem Usage:
rem   reconnect-shares.cmd
rem ==============================================================

set "LIB_DIR=%~dp0..\lib"

setlocal enabledelayedexpansion
set "RECONNECTED=0"
set "FAILED=0"

call "%LIB_DIR%\log.cmd" :log "Scanning for unavailable network drives..."

@REM Parse 'net use' output — columns are: Status  Drive  RemotePath  Network
for /f "tokens=1,2,3" %%a in ('net use') do (
    if /i "%%a"=="Unavailable" (
        call "%LIB_DIR%\log.cmd" :log "Reconnecting %%b -> %%c ..."

        @REM Remove the stale mapping before re-establishing it
        net use "%%b" /delete /yes >nul 2>&1

        net use "%%b" "%%c" /persistent:yes >nul 2>&1
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
