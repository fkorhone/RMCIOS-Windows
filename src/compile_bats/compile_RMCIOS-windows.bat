:: **************************************************
:: This is compile script for Windows
:: **************************************************

:: parameter to skip running compiled program and pausing on errors
set EXIT_FAST="%~1"

:: Store directory
set ORIG_DIR=%CD%
set SCRIPTDIR=%~dp0
cd %SCRIPTDIR%
call "toolpath.bat"
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

:: User notification about compilation status:
IF NOT EXIST %OUTPUT_DIR%\%OUTPUT_FILE% (
    echo COMPILE ERROR!
    IF %EXIT_FAST% == "" (
       pause
    )
) ELSE (
    echo %OUTPUT_DIR%\%OUTPUT_FILE% ready
    IF %EXIT_FAST% == "" (
       echo Running %OUTPUT_DIR%\%OUTPUT_FILE%
       cd %OUTPUT_DIR%
       %OUTPUT_FILE%
       pause
    )
)

:: Restore working dir
cd %ORIG_DIR%

