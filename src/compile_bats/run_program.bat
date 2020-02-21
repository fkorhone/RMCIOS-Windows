:: parameter to skip user delay and pauses after compilation in automated runs
set EXIT_FAST="%~1"

:: Setup environment variables
set ORIG_DIR=%CD%
set SCRIPTDIR=%~dp0
call "toolpath.bat"
cd %SCRIPTDIR%\..\

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

:: User notification about compilation status:
IF NOT EXIST %OUTPUT_DIR%\%OUTPUT_FILE% (
    echo COMPILE ERROR!
    IF %EXIT_FAST% == "" (
       pause
    )
) ELSE (
    echo %OUTPUT_DIR%\%OUTPUT_FILE% ready
    IF %EXIT_FAST% == "" (
       timeout /T 5
    )
)

:: Restore working dir
cd %ORIG_DIR%

