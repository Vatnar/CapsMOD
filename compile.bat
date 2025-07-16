	@echo off


REM Paths and filenames
set "AHK_COMPILER=C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe"
set "SOURCE=main.ahk"
set "DEST=C:\Users\peter\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\CapsMOD.exe"
set "ICON=Z:\CapsMOD\capmod.ico"
set "BASEFILE=C:\Program Files\AutoHotkey\v1.1.37.02\Unicode 64-bit.bin"

REM Kill running CapsMOD.exe if running
tasklist /FI "IMAGENAME eq CapsMOD.exe" | find /I "CapsMOD.exe" >nul
if not errorlevel 1 (
    echo CapsMOD.exe is running. Terminating...
    taskkill /F /IM CapsMOD.exe
    timeout /t 2 /nobreak >nul
)

REM Delete old executable if exists
if exist "%DEST%" (
    echo Deleting old executable...
    del "%DEST%"
)

REM Compile with Ahk2Exe
echo Compiling...
"%AHK_COMPILER%" /in "%SOURCE%" /out "%DEST%" /icon "%ICON%" /base "%BASEFILE%" /compress 0

REM Check if compilation was successful
if errorlevel 1 (
    echo Compilation failed.
    pause
    exit /b 1
) else (
    echo Compilation succeeded. EXE placed at:
    echo %DEST%
)

REM Run the compiled EXE
echo Running compiled executable...
start "" "%DEST%"


