@echo off

@REM -----
@REM ref: https://stackoverflow.com/a/18746066
@REM Routing function calls ensure that the correct function is executed based on the label provided as an argument when calling the script.
@REM This allows for modular code organization and makes it easier to maintain and reuse functions across different batch scripts.
call:%*
exit /b %errorlevel%
@REM -----

goto :description
@REM ref: https://stackoverflow.com/questions/4619088/windows-batch-file-file-download-from-a-url
@REM Batch functions to download files using either bitsadmin or curl, both of which are built-in Windows tools for managing file transfers.
@REM The functions allow downloading single or multiple files, and also support downloading through a proxy server. The functions prefer the
@REM use of curl if it is available, as it provides more features and better error handling compared to bitsadmin. If curl is not found, the
@REM script falls back to using bitsadmin for downloading files.
:description

@REM ---------------------------------------------------------------------------
@REM Batch function to download files using either curl.exe or bitsadmin.exe.
@REM
@REM Usage:
@REM    call :download "http://example.com/file.zip" "C:\path\to\save\file.zip"
:download
  setlocal
  set "URL=%~1"
  set "DESTINATION=%~2"
  if "%DESTINATION%"=="" (
      set "DESTINATION=%~dp0%~nx1"
  )

  @rem Check if 'curl.exe' is available, if so, use it; otherwise, fall back to 'bitsadmin.exe'
  set "TOOL=bitsadmin"
  where curl.exe >nul 2>&1 && set "TOOL=curl"

  rem Download the data using 'curl' or the 'bitsadmin' tools
  echo Downloading "%URL%" to "%DESTINATION%" using %TOOL%...
  if "%TOOL%"=="curl" (
    curl "%URL%" --output "%DESTINATION%" --fail --silent --show-error
  ) else (
    bitsadmin /transfer DL /download /priority normal "%URL%" "%DESTINATION%"
  )
  endlocal
exit /b %errorlevel%


@REM ---------------------------------------------------------------------------
@REM Batch function to download multiple files using either curl or bitsadmin
@REM
@REM Usage:
@REM    call :download_urls "http://example.com/file1.zip http://example.com/file2.zip"
:download_urls
  setlocal enabledelayedexpansion
  set urls=%*
  echo Downloading files: %* ...
  for %%u in (%urls%) do (
    call :download "%%u"
  )
  endlocal
exit /b 0

@REM ---------------------------------------------------------------------------
@REM Download a file using a proxy server. If needed basic authentication is supported, however only for curl.exe, bitsadmin.exe does not
@REM support proxy authentication.
@REM
@REM Usage:
@REM    call :proxy_download "http://example.com/file.zip" "C:\path\to\save\file.zip" "http://proxyserver:port" "username:password"
:proxy_download
  setlocal
  set "URL=%~1"
  set "DESTINATION=%~2"
  if "%DESTINATION%"=="" (
      set "DESTINATION=%~dp0%~nx1"
  )
  set "PROXY=%~3"
  set "USER=%~4"

  @rem Check if 'curl.exe' is available, if so, use it; otherwise, fall back to 'bitsadmin.exe'
  set "TOOL=bitsadmin"
  where curl.exe >nul 2>&1 && set "TOOL=curl"

  rem Download the data using 'curl' or the 'bitsadmin' tools
  echo Downloading "%URL%" to "%DESTINATION%" using %TOOL%...
  if "%TOOL%"=="curl" (
    if not "%USER%"=="" (
      curl "%URL%" -x "%PROXY%" -U "%USER%" --output "%DESTINATION%" --fail --silent --show-error
    ) else (
      curl "%URL%" -x "%PROXY%" --output "%DESTINATION%" --fail --silent --show-error
    )
  ) else (
    bitsadmin /transfer DL /download /priority normal /proxy "%PROXY%" "%URL%" "%DESTINATION%"
  )
  endlocal
exit /b 0
