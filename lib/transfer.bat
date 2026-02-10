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
@REM Batch functions to download files using bitsadmin, a built-in Windows tool for managing background file transfers.
@REM The functions allow downloading single or multiple files, and also support downloading through a proxy server.
:description

@REM ---------------------------------------------------------------------------
@REM Batch function to download files using bitsadmin
@REM Usage: call :download_file "http://example.com/file.zip" "C:\path\to\save\file.zip"
:download_file
  setlocal
  set "url=%~1"
  set "filename=%~2"
  if "%filename%"=="" (
      set "filename=%~dp0%~nx1"
  )

  rem Download a file using the 'bitsadmin' built-in Windows tool
  echo Downloading "%url%" to "%filename%" ...
  bitsadmin /transfer DL /download /priority normal "%url%" "%filename%"
  endlocal
exit /b 0

@REM ---------------------------------------------------------------------------
@REM Batch function to download multiple files using bitsadmin
@REM Usage: call :download_files "http://example.com/file1.zip http://example.com/file2.zip"
:download_files
  setlocal enabledelayedexpansion
  set urls=%*
  echo Downloading files: %* ...
  for %%u in (%urls%) do (
    call :download_file "%%u"
  )
  endlocal
exit /b 0

@REM ---------------------------------------------------------------------------
@REM Download a file using a proxy server
@REM Usage: call :download_file_with_proxy "http://example.com/file.zip" "C:\path\to\save\file.zip" "http://proxyserver:port"
:download_file_with_proxy
  setlocal
  set "url=%~1"
  set "filename=%~2"
   if "%filename%"=="" (
      set "filename=%~dp0%~nx1"
  )
  set "proxy=%~3"
  rem Download a file using the 'bitsadmin' built-in Windows tool with proxy settings
  echo Downloading "%url%" to "%filename%" using proxy "%proxy%" ...
  bitsadmin /transfer DL /download /priority normal /proxy "%proxy%" "%url%" "%filename%"
  endlocal
exit /b 0