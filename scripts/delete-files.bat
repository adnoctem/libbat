@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem === Argument validation ===
if "%~1"=="" (
    echo [ERROR] Missing root directory argument 1>&2
    exit /b 1
)

if "%~2"=="" (
    echo [ERROR] Missing filename argument 1>&2
    exit /b 1
)

set "ROOT=%~1"
set "TARGET=%~2"

if not exist "%ROOT%" (
    echo [ERROR] Root path does not exist: %ROOT% 1>&2
    exit /b 1
)

rem === Normalize path ===
pushd "%ROOT%" || (
    echo [ERROR] Cannot access root directory 1>&2
    exit /b 1
)

echo [INFO] Searching in: %CD%
echo [INFO] Deleting filename from immediate subfolders: %TARGET%

set "DELETED=0"
set "FAILED=0"

rem === One-level subdirectory iteration ===
for /d %%D in (*) do (
    if exist "%%D\%TARGET%" (
        echo [INFO] Deleting: %CD%\%%D\%TARGET%
        del /f /q "%%D\%TARGET%" || (
            echo [ERROR] Failed to delete: %CD%\%%D\%TARGET% 1>&2
            set "FAILED=1"
        )
        if not errorlevel 1 (
            set /a DELETED+=1
        )
    )
)

popd

echo [INFO] Deleted !DELETED! file(s)

if "!FAILED!"=="1" (
    exit /b 1
)

exit /b 0