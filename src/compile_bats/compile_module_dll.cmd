:: **************************************************
:: This is compile script for Windows
:: **************************************************f

:: Setup environment variables
set ORIG_DIR=%CD%
set SCRIPTDIR=%~dp0
call "toolpath.bat"
cd %SCRIPTDIR%\..\

:: Parameters
set SRC_DIR=%1
set SOURCES=%2
set FILENAME=%3

:: Output
set OUTPUT_DIR=..\modules
set OUTPUT_FILE=%FILENAME%.dll

:: create VERSION_STR CFLAG -macro: 
set INTERFACE_DIR=RMCIOS-interface
set PROJECTDIR=%CD%
call "%SCRIPTDIR%\version_str.bat"

:: RMCIOS interface sources
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
set CFLAGS=%CFLAGS% -I %CD%\%INTERFACE_DIR%\
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
echo gcc %SOURCES% -o %OUTPUT_DIR%\%OUTPUT_FILE% %CFLAGS%
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
       timeout /T 5
    )
)

:: Restore working dir
cd %ORIG_DIR%

