@echo off

rem ==============================================================
rem Install winget (Windows Package Manager)
rem
rem Usage:
rem   install-winget.cmd <version>
rem
rem Arguments:
rem   <version>  The winget release version to install (e.g. 1.9.25200)
rem ==============================================================

set "LIB_DIR=%~dp0..\lib"
set "VERSION=%~1"

@REM Ensure a version argument was provided
if "%VERSION%"=="" (
    call "%LIB_DIR%\log.cmd" :log_error "No version specified. Usage: install-winget.cmd <version>"
    exit /b 1
)

@REM Check if winget is already installed
where winget >nul 2>&1
if %errorlevel% equ 0 (
    call "%LIB_DIR%\log.cmd" :log "winget is already installed."
    goto :eof
)

@REM Require administrative privileges
call "%LIB_DIR%\permission.cmd" :require_admin
if %errorlevel% neq 0 exit /b 1

@REM Construct download URLs from the version number
set "BASE_URL=https://github.com/microsoft/winget-cli/releases/download/v%VERSION%"
set "MSIX_URL=%BASE_URL%/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
set "LICENSE_URL=%BASE_URL%/%VERSION%_License1.xml"

@REM Determine the correct VCLibs URL based on processor architecture
set "VCLIBS_URL=https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx"
if /i "%PROCESSOR_ARCHITECTURE%"=="ARM64" set "VCLIBS_URL=https://aka.ms/Microsoft.VCLibs.arm64.14.00.Desktop.appx"

@REM Set up a temporary directory for downloaded files
set "TEMP_DIR=%TEMP%\winget-install"
mkdir "%TEMP_DIR%" >nul 2>&1

set "MSIX_FILE=%TEMP_DIR%\winget.msixbundle"
set "LICENSE_FILE=%TEMP_DIR%\license.xml"
set "VCLIBS_FILE=%TEMP_DIR%\VCLibs.appx"

@REM Download the winget package and its dependencies
call "%LIB_DIR%\log.cmd" :log "Downloading winget %VERSION%..."
call "%LIB_DIR%\transfer.cmd" :download_file "%MSIX_URL%" "%MSIX_FILE%"

call "%LIB_DIR%\log.cmd" :log "Downloading VCLibs dependency..."
call "%LIB_DIR%\transfer.cmd" :download_file "%VCLIBS_URL%" "%VCLIBS_FILE%"

call "%LIB_DIR%\log.cmd" :log "Downloading winget license..."
call "%LIB_DIR%\transfer.cmd" :download_file "%LICENSE_URL%" "%LICENSE_FILE%"

@REM Install VCLibs dependency first
call "%LIB_DIR%\log.cmd" :log "Installing VCLibs dependency..."
dism /Online /Add-ProvisionedAppxPackage /PackagePath:"%VCLIBS_FILE%" /SkipLicense >nul

@REM Install winget as a provisioned package (available to all users)
call "%LIB_DIR%\log.cmd" :log "Installing winget %VERSION%..."
dism /Online /Add-ProvisionedAppxPackage /PackagePath:"%MSIX_FILE%" /LicensePath:"%LICENSE_FILE%"

if %errorlevel% equ 0 (
    call "%LIB_DIR%\log.cmd" :log "winget %VERSION% installed successfully."
) else (
    call "%LIB_DIR%\log.cmd" :log_error "winget installation failed with error code %errorlevel%."
    rmdir /s /q "%TEMP_DIR%"
    exit /b 1
)

@REM Clean up temporary files
rmdir /s /q "%TEMP_DIR%"

@echo on

