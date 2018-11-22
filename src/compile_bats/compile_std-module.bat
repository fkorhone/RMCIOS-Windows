@echo off
:: **************************************************
:: This is compile script for Windows
:: **************************************************

call "toolpath.bat"

:: Settings
set SCRIPTDIR=%CD%
cd ..

set FILENAME=std-module
set OUTPUT_DIR=..\modules
set OUTPUT_FILE=%FILENAME%.dll

:: create VERSION_STR CFLAG -macro: 
set SRC_DIR=RMCIOS-std-module
set INTERFACE_DIR=RMCIOS-interface
set PROJECTDIR=%CD%
call "%SCRIPTDIR%\version_str.bat"

set SOURCES=RMCIOS-std-module\*.c
set SOURCES=%SOURCES% string-conversion.c 
set SOURCES=%SOURCES% RMCIOS-interface\RMCIOS-functions.c

:: Compiler flags
::set CFLAGS=%CFLAGS% -s 
set CFLAGS=%CFLAGS% -O0 
::set CFLAGS=%CFLAGS% -flto
::set CFLAGS=%CFLAGS% -g
set CFLAGS=%CFLAGS% -static-libgcc
set CFLAGS=%CFLAGS% -shared 
set CFLAGS=%CFLAGS% -Wl,--subsystem,windows
set CFLAGS=%CFLAGS% -I %INTERFACE_DIR%\
set CFLAGS=%CFLAGS% -D API_ENTRY_FUNC="__declspec(dllexport) __cdecl"
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


