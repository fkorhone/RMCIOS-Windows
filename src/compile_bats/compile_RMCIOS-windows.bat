@echo off
:: **************************************************
:: This is compile script for Windows
:: **************************************************

:: Add compiler to path
call "toolpath.bat"

:: Store directory
set SCRIPTDIR=%CD%
cd ..

:: create VERSION_STR CFLAG -macro: 
set SRC_DIR=RMCIOS-system
set INTERFACE_DIR=RMCIOS-interface
set PROJECTDIR=%CD%
call "%SCRIPTDIR%\version_str.bat"

:: Sources to compile:
set SOURCES=RMCIOS-windows.c 
set SOURCES=%SOURCES% string-conversion.c 
set SOURCES=%SOURCES% %SRC_DIR%\RMCIOS-system.c 
set SOURCES=%SOURCES% %INTERFACE_DIR%\RMCIOS-functions.c

: Set directories and files:
set OUTPUT_DIR=..
set OUTPUT_FILE=RMCIOS.exe

:: Compiler flags
::set CFLAGS=%CFLAGS% -s 
set CFLAGS=%CFLAGS:% -O0 
::set CFLAGS=%CFLAGS% -flto
::set CFLAGS=%CFLAGS% -Wimplicit
set CFLAGS=%CFLAGS% -static-libgcc 
set CFLAGS=%CFLAGS% -g 
set CFLAGS=%CFLAGS% -I %SRC_DIR%
set CFLAGS=%CFLAGS% -I %INTERFACE_DIR% 
set CFLAGS=%CFLAGS% -D API_ENTRY_FUNC=""
set CFLAGS=%CFLAGS% -Wall
set CFLAGS=%CFLAGS% -Wextra
set CFLAGS=%CFLAGS% -Wno-unused-parameter
set CFLAGS=%CFLAGS% -Wno-sign-compare
set CFLAGS=%CFLAGS% -Wno-switch

:: create VERSION_STR CFLAG -macro
call "%SCRIPTDIR%\version_str.bat"

:: Remove earlier produced file. (clean)
IF EXIST %OUTPUT_DIR%\%OUTPUT_FILE% (del %OUTPUT_DIR%\%OUTPUT_FILE%)

:: Compile
echo compiling %SOURCES%
gcc %SOURCES% -o %OUTPUT_DIR%\%OUTPUT_FILE% %CFLAGS%

:: Check if output was generated
IF NOT EXIST %OUTPUT_DIR%\%OUTPUT_FILE% (
    echo COMPILE ERROR!
    pause
    exit
)

:: Execute program
echo Running %OUTPUT_DIR%\%OUTPUT_FILE%
cd %OUTPUT_DIR%
%OUTPUT_FILE%


