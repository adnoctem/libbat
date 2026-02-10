@echo OFF

@REM This script is mainly for testing.
@REM ---------------------------------------------------------------------------
@REM source library files
@REM CALL "%~dp0..\lib\download.bat"
@REM CALL "%~dp0..\lib\url.bat"
@REM ---------------------------------------------------------------------------

@REM @echo ~dp0= %~dp0
@REM @echo ~dp0= "%~dp0..\lib\download.bat"
@REM @echo ~dp1= %~dp1
@REM @echo ~dp2= %~dp2
@REM @echo ~dp0~nx1= "%~dp0%~nx1"
@REM @echo %~dp0%~nx1

set url=%~2

@REM set /P url="Enter the URL to download: "
@REM echo Good, now downloading from: %url% ...
@REM :download_file "%url%"
@REM pause

@REM echo Filename would be: %filename%

@REM :parse_url "%url%"
@REM :parse_url_path "%url%"
@REM :parse_url_filename "%url%"

@REM cd /d "%~dp0"

@REM setlocal enabledelayedexpansion
@REM set "url=https://delta4x4.com/some/hidden/dir/test.zip"

@REM for %%a in ("%url%") do (
@REM    set "urlPath=!url:%%~NXa=!"
@REM    set "urlName=%%~NXa"
@REM )
@REM echo URL path: "%urlPath%"
@REM echo URL name: "%urlName%"


for /f "delims=" %%v in ('call %~dp0..\lib\url.bat parse_url_filename "https://delta4x4.com/test.zip"') do (
  set "urlPath=%%v"
)

echo Parsed file from URL: %urlPath%

@REM call "%~dp0..\lib\log.bat" :log "Testing log function with URL path: %urlPath%"
@REM call "%~dp0..\lib\log.bat" :log_error "Testing log_error function with URL path: %urlPath%"
@REM call "%~dp0..\lib\log.bat" :log_warning "Testing log_warning function with URL path: %urlPath%"

call "%~dp0..\lib\permission.bat" :require_admin || (
  call "%~dp0..\lib\log.bat" :log_warning "Exiting script due to lack of admin privileges."
  exit /b 1
)