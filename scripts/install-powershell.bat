@echo off

goto description
@REM This script installs PowerShell on the system. Since all Windows versions bundle the Windows PowerShell by default, this script focuses 
@REM on installing PowerShell Core (PowerShell 7) which is the cross-platform version of PowerShell. It checks if PowerShell 7 is already 
@REM installed and if not, it downloads and installs it using the latest release obtained from the official GitHub repository.
:description
