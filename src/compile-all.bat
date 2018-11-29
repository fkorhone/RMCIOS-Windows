@echo off

cd compile_bats
start compile_base-module.bat
start compile_std-module.bat
start compile_windows-module.bat
start compile_windows-serial-module.bat
start compile_windows-gui-module 
start compile_windows-pipe-module 
start compile_windows-program-module 
start run_program 

echo "Wait until all modules have been compiled. Press key to compile+run main module"
pause
start compile_RMCIOS-windows.bat

