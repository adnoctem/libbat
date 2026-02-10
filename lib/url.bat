@echo off

@REM -----
@REM ref: https://stackoverflow.com/a/18746066
@REM Routing function calls ensure that the correct function is executed based on the label provided as an argument when calling the script.
@REM This allows for modular code organization and makes it easier to maintain and reuse functions across different batch scripts.
call:%*
exit /b %errorlevel%
@REM -----

goto :description
@REM Working with URLs in batch scripts can be tricky, especially when it comes to parsing and extracting components from a URL. 
@REM These functions demonstrate how to parse a URL into its components using batch scripting.
:description

@REM ---------------------------------------------------------------------------
@REM Batch function to parse a URL into its components
@REM Usage: call :parse_url "http://example.com/path/to/file.zip"
:parse_url
  setlocal enabledelayedexpansion
  set "url=%~1"
  rem Parse the URL into components using a regular expression
  for %%v in ("%url%") do (
    set "urlPath=!url:%%~NXv=!"
    set "urlName=%%~NXv"
  )
  echo %urlPath% %urlName%
  endlocal
exit /b 0

@REM ---------------------------------------------------------------------------
@REM Batch function to extract the directory path from a URL
@REM Usage: call :parse_url_path "http://example.com/path/to/file.zip"
:parse_url_path
  setlocal enabledelayedexpansion
  set "url=%~1"
  rem Extract the directory path from the URL
  for %%v in ("%url%") do (
    set "urlPath=!url:%%~NXv=!"
  )
  echo %urlPath%
  endlocal
exit /b 0

@REM ---------------------------------------------------------------------------
@REM Batch function to extract the filename from a URL
@REM Usage: call :parse_url_filename "http://example.com/path/to/file.zip"
:parse_url_filename
  setlocal enabledelayedexpansion
  set "url=%~1"
  rem Extract the filename from the URL
  for %%v in ("%url%") do (
    set "urlName=%%~NXv"
  )
  echo %urlName%
  endlocal
exit /b 0
