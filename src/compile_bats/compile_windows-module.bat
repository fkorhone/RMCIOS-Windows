@echo off
:: **************************************************
:: This is compile script for Windows
:: **************************************************

call "toolpath.bat"

:: Settings
set SCRIPTDIR=%CD%
cd ..

set FILENAME=windows-module
set OUTPUT_DIR=..\modules
set OUTPUT_FILE=%FILENAME%.dll

:: create VERSION_STR CFLAG -macro: 
set PROJECTDIR=%CD%
set SRC_DIR=RMCIOS-Windows-module
set INTERFACE_DIR=RMCIOS-interface
call "%SCRIPTDIR%\version_str.bat"

: Set directories and files:
set SRC_DIR=RMCIOS-Windows-module\
set INTERFACE_DIR=RMCIOS-interface\
set SOURCES=%SRC_DIR%\windows_channels.c
set SOURCES=%SOURCES% string-conversion.c  
set SOURCES=%SOURCES% %INTERFACE_DIR%\RMCIOS-functions.c

:: compiler flags
::set CFLAGS=%CFLAGS% -s
set CFLAGS=%CFLAGS% -O0
set CFLAGS=%CFLAGS% -g
set CFLAGS=%CFLAGS% -static-libgcc 
set CFLAGS=%CFLAGS% -shared -Wl,--subsystem,windows 
set CFLAGS=%CFLAGS% -lwinmm
set CFLAGS=%CFLAGS% -mwindows
set CFLAGS=%CFLAGS% -I %PROJECTDIR%\RMCIOS-interface
set CFLAGS=%CFLAGS% -D API_ENTRY_FUNC="__declspec(dllexport) __cdecl"

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


