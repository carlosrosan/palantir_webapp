@echo off
REM Use this instead of 'pip install' — the venv's pip launcher points to an old path.
REM Usage: pip-install.bat <package>   e.g.   pip-install.bat mysqlclient
cd /d "%~dp0"
"%~dp0palantir_venv\Scripts\python.exe" -m pip %*
