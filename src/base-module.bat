@echo off
:: **************************************************
:: This is compile script for Windows
:: **************************************************
call "toolpath.bat"

:: Settings
set PROJECTDIR=%CD%
set FILENAME=%~n0

set OUTPUT_DIR=..\modules
set OUTPUT_FILE=%FILENAME%.dll

set SRC_DIR=RMCIOS-base-module\
set INTERFACE_DIR=RMCIOS-interface\
set SOURCES=%SRC_DIR%*.c 
set SOURCES=%SOURCES% string-conversion.c 
set SOURCES=%SOURCES% %INTERFACE_DIR%RMCIOS-functions.c

:: create VERSION_STR CFLAG -macro
call "version_str.bat"

:: Compiler flags
set CFLAGS=%CFLAGS% -s -Os -flto
set CFLAGS=%CFLAGS% -static-libgcc
set CFLAGS=%CFLAGS% -shared 
set CFLAGS=%CFLAGS% -Wl,--subsystem,windows
set CFLAGS=%CFLAGS% -I %PROJECTDIR%\RMCIOS\
set CFLAGS=%CFLAGS% -I %PROJECTDIR%\RMCIOS-interface\
set CFLAGS=%CFLAGS% -D API_ENTRY_FUNC="__declspec(dllexport) __cdecl"
set CFLAGS=%CFLAGS% -Wall
set CFLAGS=%CFLAGS% -Wextra
set CFLAGS=%CFLAGS% -Wno-unused-parameter
set CFLAGS=%CFLAGS% -Wno-sign-compare
set CFLAGS=%CFLAGS% -Wno-switch


:: Remove earlier produced file. (clean)
IF EXIST %OUTPUT_DIR%\%OUTPUT_FILE% (del %OUTPUT_DIR%\%OUTPUT_FILE%)

:: Compile the program
echo compiling %SOURCES%
gcc %SOURCES% -o %OUTPUT_DIR%\%OUTPUT_FILE% %CFLAGS%

IF NOT EXIST %OUTPUT_DIR%\%OUTPUT_FILE% (
    echo COMPILE ERROR!
    pause
    exit
)

echo %OUTPUT_DIR%\%OUTPUT_FILE% ready
timeout /T 5
exit


