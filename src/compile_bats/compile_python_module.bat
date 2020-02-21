@echo off
:: **************************************************
:: This is compile script for Windows
:: **************************************************

call "toolpath.bat"

:: Settings
set SCRIPTDIR=%CD%
cd ..

set FILENAME=python-module
set OUTPUT_DIR=..\modules
set OUTPUT_FILE=%FILENAME%.dll

:: create VERSION_STR CFLAG -macro: 
set SRC_DIR=RMCIOS-std-module
set INTERFACE_DIR=RMCIOS-interface
set PROJECTDIR=%CD%
call "%SCRIPTDIR%\version_str.bat"

set SOURCES=RMCIOS-python\*.c
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
set CFLAGS=%CFLAGS% -I%CD%\%INTERFACE_DIR%\
set CFLAGS=%CFLAGS% -I%PYTHONHOME%\include
::set CFLAGS=%CFLAGS% -L%PYTHONHOME%\libs
set CFLAGS=%CFLAGS% -D API_ENTRY_FUNC="__declspec(dllexport) __cdecl"
set CFLAGS=%CFLAGS% -Wall
set CFLAGS=%CFLAGS% -Wextra
set CFLAGS=%CFLAGS% -Wno-unused-parameter
set CFLAGS=%CFLAGS% -Wno-sign-compare
set CFLAGS=%CFLAGS% -Wno-switch
::set CFLAGS=%CFLAGS% %PYTHONHOME%/libs/python38.lib
set CFLAGS=%CFLAGS% libpython38.a 

:: Remove earlier produced file. (clean)
IF EXIST %OUTPUT_DIR%\%OUTPUT_FILE% (del %OUTPUT_DIR%\%OUTPUT_FILE%)

:: Compile the program
echo compiling %SOURCES%
gendef %PYTHONHOME%\python38.dll
::dlltool --as-flags=--64 -m i386:x86-64 -k --output-lib libpython38.a --input-def python38.def
dlltool -k --output-lib libpython38.a --input-def python38.def
gcc %SOURCES% -o %OUTPUT_DIR%\%OUTPUT_FILE% %CFLAGS%

IF NOT EXIST %OUTPUT_DIR%\%OUTPUT_FILE% (
    echo COMPILE ERROR!
    pause
    exit
)

echo %OUTPUT_DIR%\%OUTPUT_FILE% ready
timeout /T 5
exit



