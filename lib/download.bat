@echo off

goto introduction
ref: https://stackoverflow.com/questions/4619088/windows-batch-file-file-download-from-a-url
Batch funcsions to download files using bitsadmin, a built-in Windows tool for managing background file transfers. The functions allow downloading single or multiple files, and also support downloading through a proxy server.
:introduction

@REM ---------------------------------------------------------------------------
@REM Batch function to download files using bitsadmin
@REM Usage: call :download_file "http://example.com/file.zip"
:download_file
  setlocal
  set "url=%~1"
  rem Download a file using the 'bitsadmin' built-in Windows tool
  bitsadmin /transfer DL /download /priority normal "%url%" "%~dp0%~nx1"
  endlocal
goto :eof

@REM ---------------------------------------------------------------------------
@REM Batch function to download multiple files using bitsadmin
@REM Usage: call :download_files "http://example.com/file1.zip http://example.com/file2.zip"
:download_files
  setlocal
  set "urls=%~1"
  for %%u in (%urls%) do (
    call :download_file "%%u"
  )
  endlocal
goto :eof

@REM ---------------------------------------------------------------------------
@REM Download a file using a proxy server
@REM Usage: call :download_file_with_proxy "http://example.com/file.zip" "http://proxyserver:port"
:download_file_with_proxy
  setlocal
  set "url=%~1"
  set "proxy=%~2"
  rem Download a file using the 'bitsadmin' built-in Windows tool with proxy settings
  bitsadmin /transfer DL /download /priority normal /proxy "%proxy%" "%url%" "%~dp0%~nx1"
  endlocal
goto :eof