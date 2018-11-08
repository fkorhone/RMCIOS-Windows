@echo off
:: **************************************************
:: This is compile script for Windows
:: **************************************************

:: Add compiler to path
call "toolpath.bat"

:: Store directory
set PROJECTDIR=%CD%

:: Get basename of this script:
set FILENAME=%~n0

:: Sources to compile:
set SOURCES=%FILENAME%.c 
set SOURCES=%SOURCES% string-conversion.c 
set SOURCES=%SOURCES% RMCIOS\RMCIOS-system.c 
set SOURCES=%SOURCES% RMCIOS-interface\RMCIOS-functions.c

: Set directories and files:
set SRC_DIR=%PROJECTDIR%
set INTERFACE_DIR=RMCIOS-interface\
set OUTPUT_DIR=..
set OUTPUT_FILE=RMCIOS.exe

:: Compiler flags
::set CFLAGS=%CFLAGS% -s -Os -flto
::set CFLAGS=%CFLAGS% -Wimplicit
set CFLAGS=%CFLAGS% -static-libgcc 
set CFLAGS=%CFLAGS% -I %PROJECTDIR%\RMCIOS\ 
set CFLAGS=%CFLAGS% -I %PROJECTDIR%\RMCIOS-interface\ 
set CFLAGS=%CFLAGS% -D API_ENTRY_FUNC=""
set CFLAGS=%CFLAGS% -Wall
set CFLAGS=%CFLAGS% -Wextra
set CFLAGS=%CFLAGS% -Wno-unused-parameter
set CFLAGS=%CFLAGS% -Wno-sign-compare
set CFLAGS=%CFLAGS% -Wno-switch

:: create VERSION_STR CFLAG -macro
call "version_str.bat"

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


