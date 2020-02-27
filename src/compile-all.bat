set EXIT_FAST="%~1"

set ORIGINAL_DIR=%CD%
cd %~dp0\compile_bats

call compile_base-module.bat %EXIT_FAST%
call compile_std-module.bat %EXIT_FAST%
call compile_windows-module.bat %EXIT_FAST%
call compile_windows-serial-module.bat %EXIT_FAST%
call compile_windows-gui-module.bat %EXIT_FAST%
call compile_windows-pipe-module.bat %EXIT_FAST%
call compile_windows-program-module.bat %EXIT_FAST%
call compile_windows-socket-module.bat %EXIT_FAST%
call run_program.bat %EXIT_FAST%
call compile_RMCIOS-windows.bat %EXIT_FAST%

cd %ORIGINAL_DIR%

