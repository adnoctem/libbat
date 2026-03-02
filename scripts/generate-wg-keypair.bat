@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem ==============================================================
rem Generate WireGuard private/public key pair
rem
rem Usage:
rem   generate-wg-keypair.bat <output-path> [private-filename] [public-filename]
rem
rem Defaults:
rem   private-filename = privatekey
rem   public-filename  = publickey
rem ==============================================================

if "%~1"=="" goto :usage

set "OUT_DIR=%~1"
set "PRIVATE_NAME=%~2"
set "PUBLIC_NAME=%~3"

if "%PRIVATE_NAME%"=="" set "PRIVATE_NAME=privatekey"
if "%PUBLIC_NAME%"=="" set "PUBLIC_NAME=publickey"

if "%PRIVATE_NAME%"=="%PUBLIC_NAME%" (
	echo [ERROR] Private and public key filenames must be different. 1>&2
	exit /b 1
)

where wg >nul 2>&1
if errorlevel 1 (
	echo [ERROR] 'wg' command is not available in PATH. 1>&2
	exit /b 1
)

if not exist "%OUT_DIR%" (
	mkdir "%OUT_DIR%" >nul 2>&1 || (
		echo [ERROR] Failed to create output directory: %OUT_DIR% 1>&2
		exit /b 1
	)
)

set "PRIVATE_PATH=%OUT_DIR%\%PRIVATE_NAME%"
set "PUBLIC_PATH=%OUT_DIR%\%PUBLIC_NAME%"

echo [INFO] Output directory : %OUT_DIR%
echo [INFO] Private key file : %PRIVATE_PATH%
echo [INFO] Public key file  : %PUBLIC_PATH%

rem Generate private key file (overwrites if exists).
wg genkey > "%PRIVATE_PATH%"
if errorlevel 1 (
	echo [ERROR] Failed to generate private key. 1>&2
	exit /b 1
)

rem Read first non-empty line from private key and derive public key.
set "PRIVATE_KEY="
for /f "usebackq delims=" %%K in ("%PRIVATE_PATH%") do (
	if not "%%K"=="" (
		set "PRIVATE_KEY=%%K"
		goto :have_private_key
	)
)

echo [ERROR] Private key file is empty or unreadable: %PRIVATE_PATH% 1>&2
exit /b 1

:have_private_key
echo !PRIVATE_KEY!| wg pubkey > "%PUBLIC_PATH%"
if errorlevel 1 (
	echo [ERROR] Failed to derive public key. 1>&2
	exit /b 1
)

echo [INFO] WireGuard key pair generated successfully.
exit /b 0

:usage
echo [ERROR] Missing required output path argument. 1>&2
echo Usage: %~nx0 ^<output-path^> [private-filename] [public-filename]
echo Example: %~nx0 "Z:\Migration\WG\Alice" "alice_private.key" "alice_public.key"
exit /b 1
