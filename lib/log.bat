@echo off

@REM -----
@REM ref: https://stackoverflow.com/a/18746066
@REM Routing function calls ensure that the correct function is executed based on the label provided as an argument when calling the script.
@REM This allows for modular code organization and makes it easier to maintain and reuse functions across different batch scripts.
call:%*
exit /b %errorlevel%
@REM -----

goto :description
@REM Batch functions for logging messages with different severity levels (INFO, WARNING, ERROR) along with timestamps.
@REM These functions can be used to log messages in a consistent format throughout the batch scripts.
:description

@REM ---------------------------------------------------------------------------
@REM Logging function with an INFO level and timestamp
@REM Usage: call :log "Your log message here"
:log
  setlocal
  set "msg=%~1"
  rem Log a message with a timestamp
  echo (%time%) [INFO]: %msg%
  endlocal
exit /b 0

@REM ---------------------------------------------------------------------------
@REM Logging function with a WARNING level and timestamp
@REM Usage: call :log_warning "Your warning message here"
:log_warning
  setlocal
  set "msg=%~1"
  rem Log a warning message with a timestamp
  echo (%time%) [WARN]: %msg%
  endlocal
exit /b 0

@REM ---------------------------------------------------------------------------
@REM Logging function with an ERROR level and timestamp
@REM Usage: call :log_error "Your error message here"
:log_error
  setlocal
  set "msg=%~1"
  rem Log an error message with a timestamp
  echo (%time%) [ERROR]: %msg%
  endlocal
exit /b 0