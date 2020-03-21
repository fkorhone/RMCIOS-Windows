set GDB_PATH=%~dp0\bin
set PATH=%PATH%;%GDB_PATH%

gdb -ex run --args %~dp0\RMCIOS.exe %*

