@echo off
:: **************************************************
:: Basic compile script. 
:: Compiles c source with same basename.
:: ***************************************************
call "toolpath.bat"

:: Settings
set SCRIPTDIR=%CD%
cd ../

set FILENAME=run_program
set PROJECTDIR=%CD%
set OUTPUT_DIR=..
set OUTPUT_FILE=%FILENAME%.dll
set SOURCES=run_program.c

:: Compiler flags
set CFLAGS=%CFLAGS% -static-libgcc 
set CFLAGS=%CFLAGS% -shared
set CFLAGS=%CFLAGS% -Wl,--subsystem,windows

:: Remove earlier produced file. (clean)
IF EXIST %OUTPUT_DIR%\%OUTPUT_FILE% (del %OUTPUT_DIR%\%OUTPUT_FILE%)

:: Compile program
echo compiling %SOURCES%
gcc %SOURCES% -o %OUTPUT_DIR%\%FILENAME%.dll %CFLAGS%

IF NOT EXIST %OUTPUT_DIR%\%OUTPUT_FILE% (
    echo COMPILE ERROR!
    pause
    exit
)

echo %OUTPUT_DIR%\%OUTPUT_FILE% ready
timeout /T 5
exit


