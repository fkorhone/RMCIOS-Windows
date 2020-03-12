call toolpath.bat
%MAKE% -C ../ -f makefiles/rmcios.mk python-module
..\..\RMCIOS.exe
pause


