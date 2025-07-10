::[Bat To Exe Converter]
::
::fBE1pAF6MU+EWHreyHcjLQlHcBeNPW/uOpEZ++Pv4Pq7kkQeQPctfZzn2LWNK/UD1nfhe5cg01hDvMoYCThXaxy/ax16uX0T1g==
::fBE1pAF6MU+EWHreyHcjLQlHcBeNPW/uOpEZ++Pv4Pq7kkQeQPctfZzn2LWNK/UD1nfhe5cg01hDvdMYCRVLdx2lTQAhp3pHpCqVJJb8
::fBE1pAF6MU+EWHreyHcjLQlHcBeNPW/uOpEZ++Pv4Pq7kkQeQPctfZzn2LWNK/UD1nDqcZkf03Rblc5CHAgJHg==
::YAwzoRdxOk+EWAjk
::fBw5plQjdCyDJGyX8VAjFAhbTQDWAE+1EbsQ5+n//Na3q04JQfA6a7OKiObYebNKvgvtdplN
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSDk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+JeA==
::cxY6rQJ7JhzQF1fEqQJQ
::ZQ05rAF9IBncCkqN+0xwdVs0
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCyDJGyX8VAjFAhbTQDWAE+/Fb4I5/jH3+OEtlgPUfEDbIrIzr2AJ9wj5VLhZ4Ul03ZW2O0FAB5LPiGkfBsGrGBDu2GXecKEtm8=
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
:menu
cls
echo ===========================================
echo        File Rename Utility Menu
echo ===========================================
echo 1. Rename files by date + counter
echo 2. Rename files by extension + counter
echo 3. Undo renaming from log file
echo 4. Exit
echo.

set /p choice=Choose an option [1-4]: 

if "%choice%"=="1" goto rename_date
if "%choice%"=="2" goto rename_ext
if "%choice%"=="3" goto undo
if "%choice%"=="4" goto :exit

echo Invalid choice. Press any key to try again.
pause >nul
goto menu

:rename_date
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0RenameByDateCounter.ps1"
pause
goto menu

:rename_ext
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0RenameByExtensionCounter.ps1"
pause
goto menu

:undo
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0UndoRename.ps1"
pause
goto menu

:exit
cls
echo Exiting launcher...
timeout /t 1 >nul

:: Debug: check current folder
echo Working directory: %~dp0
timeout /t 1 >nul

:: Delete scripts (must match actual file names!)
del /f /q "%~dp0RenameByDateCounter.ps1" >nul 2>&1
del /f /q "%~dp0RenameByExtensionCounter.ps1" >nul 2>&1
del /f /q "%~dp0UndoRename.ps1" >nul 2>&1

echo Done deleting script files.
timeout /t 2 >nul
exit


