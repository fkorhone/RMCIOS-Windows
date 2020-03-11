
call toolpath.bat
%MAKE% -C ../ -f makefiles/rmcios.mk rmcios
..\..\RMCIOS.exe
pause

