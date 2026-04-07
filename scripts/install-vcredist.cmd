@echo off

rem ==============================================================
rem Install a Visual C++ Redistributable
rem
rem Usage:
rem   install-vcredist.cmd <version>
rem
rem Arguments:
rem   <version>  The VC++ version to install (e.g. 14.0, 12.0, 11.0, 10.0, 9.0, 8.0)
rem ==============================================================

set "LIB_DIR=%~dp0..\lib"
set "VERSION=%~1"

@REM Ensure a version argument was provided
if "%VERSION%"=="" (
    call "%LIB_DIR%\log.cmd" :log_error "No version specified. Usage: install-vcredist.cmd <version>"
    call "%LIB_DIR%\log.cmd" :log_error "Supported versions: 14.0, 12.0, 11.0, 10.0, 9.0, 8.0"
    exit /b 1
)

@REM Extract major version number (e.g. 14 from 14.0)
for /f "delims=. tokens=1" %%v in ("%VERSION%") do set "MAJOR_VER=%%v"

@REM Determine architecture from the current processor
set "ARCH=x86"
if /i "%PROCESSOR_ARCHITECTURE%"=="AMD64" set "ARCH=x64"
if /i "%PROCESSOR_ARCHITECTURE%"=="ARM64" set "ARCH=ARM64"

@REM ARM64 builds are only available for VC++ 14.0; fall back to x64 for older versions
if /i "%ARCH%"=="ARM64" if "%MAJOR_VER%" neq "14" (
    call "%LIB_DIR%\log.cmd" :log_warning "ARM64 is not supported for VC++ %VERSION%. Falling back to x64."
    set "ARCH=x64"
)

@REM Check if this version is already installed via the registry
reg query "HKLM\SOFTWARE\Microsoft\VisualStudio\%MAJOR_VER%.0\VC\Runtimes\%ARCH%" /v Installed >nul 2>&1
if %errorlevel% equ 0 (
    call "%LIB_DIR%\log.cmd" :log "VC++ %VERSION% (%ARCH%) is already installed."
    goto :eof
)

@REM Require administrative privileges
call "%LIB_DIR%\permission.cmd" :require_admin
if %errorlevel% neq 0 exit /b 1

@REM Determine the download URL based on version and architecture
@REM Source: https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist
set "DOWNLOAD_URL="

if "%VERSION%"=="14.0" (
    if /i "%ARCH%"=="x64"   set "DOWNLOAD_URL=https://aka.ms/vc14/vc_redist.x64.exe"
    if /i "%ARCH%"=="x86"   set "DOWNLOAD_URL=https://aka.ms/vc14/vc_redist.x86.exe"
    if /i "%ARCH%"=="ARM64" set "DOWNLOAD_URL=https://aka.ms/vc14/vc_redist.arm64.exe"
)
if "%VERSION%"=="12.0" (
    if /i "%ARCH%"=="x64" set "DOWNLOAD_URL=https://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x64.exe"
    if /i "%ARCH%"=="x86" set "DOWNLOAD_URL=https://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x86.exe"
)
if "%VERSION%"=="11.0" (
    if /i "%ARCH%"=="x64" set "DOWNLOAD_URL=https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x64.exe"
    if /i "%ARCH%"=="x86" set "DOWNLOAD_URL=https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe"
)
if "%VERSION%"=="10.0" (
    if /i "%ARCH%"=="x64" set "DOWNLOAD_URL=https://download.microsoft.com/download/A/8/0/A80747C3-41BD-45DF-B505-E9710D2744E0/vcredist_x64.exe"
    if /i "%ARCH%"=="x86" set "DOWNLOAD_URL=https://download.microsoft.com/download/C/6/D/C6D0FD4E-9E53-4897-9B91-836EBA2FA716/vcredist_x86.exe"
)
if "%VERSION%"=="9.0" (
    if /i "%ARCH%"=="x64" set "DOWNLOAD_URL=https://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x64.exe"
    if /i "%ARCH%"=="x86" set "DOWNLOAD_URL=https://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x86.exe"
)
if "%VERSION%"=="8.0" (
    if /i "%ARCH%"=="x64" set "DOWNLOAD_URL=https://download.microsoft.com/download/8/B/4/8B42259F-5D70-43F4-AC2E-4B208FD8D66A/vcredist_x64.EXE"
    if /i "%ARCH%"=="x86" set "DOWNLOAD_URL=https://download.microsoft.com/download/8/B/4/8B42259F-5D70-43F4-AC2E-4B208FD8D66A/vcredist_x86.EXE"
)

if "%DOWNLOAD_URL%"=="" (
    call "%LIB_DIR%\log.cmd" :log_error "No download URL found for VC++ %VERSION% (%ARCH%). Supported versions: 14.0, 12.0, 11.0, 10.0, 9.0, 8.0"
    exit /b 1
)

@REM Set up a temporary directory for downloaded files
set "TEMP_DIR=%TEMP%\vcredist-install"
mkdir "%TEMP_DIR%" >nul 2>&1
set "INSTALLER=%TEMP_DIR%\vcredist_%ARCH%.exe"

@REM Download the installer
call "%LIB_DIR%\log.cmd" :log "Downloading VC++ %VERSION% (%ARCH%)..."
call "%LIB_DIR%\transfer.cmd" :download_file "%DOWNLOAD_URL%" "%INSTALLER%"

@REM Install silently without prompting for a restart
call "%LIB_DIR%\log.cmd" :log "Installing VC++ %VERSION% (%ARCH%)..."
"%INSTALLER%" /install /quiet /norestart

if %errorlevel% equ 0 (
    call "%LIB_DIR%\log.cmd" :log "VC++ %VERSION% (%ARCH%) installed successfully."
) else (
    call "%LIB_DIR%\log.cmd" :log_error "VC++ installation failed with error code %errorlevel%."
    rmdir /s /q "%TEMP_DIR%"
    exit /b 1
)

@REM Clean up temporary files
rmdir /s /q "%TEMP_DIR%"

@echo on

