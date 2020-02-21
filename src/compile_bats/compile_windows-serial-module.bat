:: parameter to skip user delay and pauses after compilation in automated runs
set EXIT_FAST="%~1"

:: settings
set SRC_DIR=RMCIOS-Windows-module
set SOURCES=%SRC_DIR%\serial_channels.c
set FILENAME=windows-serial-module
set CFLAGS=%CFLAGS% -lwinmm
set CFLAGS=%CFLAGS% -mwindows

set ORIG_DIR=%CD%
cd %~dp0
call compile_module_dll.cmd %SRC_DIR% %SOURCES% %FILENAME% 
cd %ORIG_DIR%

