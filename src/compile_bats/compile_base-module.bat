:: parameter to skip user delay and pauses after compilation in automated runs
set EXIT_FAST="%~1"

:: settings
set SRC_DIR=RMCIOS-base-module
set SOURCES=%SRC_DIR%\*.c
set FILENAME=base-module
set CFLAGS=

set ORIG_DIR=%CD%
cd %~dp0
call compile_module_dll.cmd %SRC_DIR% %SOURCES% %FILENAME% 
cd %ORIG_DIR%