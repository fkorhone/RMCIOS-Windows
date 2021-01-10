@echo off
:: **************************************************
:: This is script for automatically indenting code
:: **************************************************

call toolpath
2
set INDENTER_FLAGS=-npsl --indent-level4 --no-tabs --brace-indent0 --comment-indentation9

IF (%1)==() GOTO error
dir /b /ad %1 >nul 2>nul && GOTO indentDir
IF NOT EXIST %1 GOTO error
goto indentFile

:indentDir
set searchdir=%1

IF (%2)==() GOTO assignDefaultSuffix
set filesuffix=%2

GOTO run

:assignDefaultSuffix
::echo !!!!DEFAULT SUFFIX!!!
set filesuffix=*

:run
FOR /F "tokens=*" %%G IN ('DIR /B /S %searchdir%\*.%filesuffix%') DO (
echo Indenting file "%%G"
"indent.exe" "%%G" -o indentoutput.tmp %INDENTER_FLAGS%
move /Y indentoutput.tmp "%%G"

)
GOTO ende

:indentFile
echo Indenting one file %1
"indent.exe" "%1" -o indentoutput.tmp %INDENTER_FLAGS%
move /Y indentoutput.tmp "%1"


GOTO ende

:error
echo .
echo ERROR: As parameter given directory or file does not exist!
echo Syntax is: call_GNU_Indent.bat dirname filesuffix
echo Syntax is: call_GNU_Indent.bat filename
echo Example: call_GNU_Indent.bat temp cpp
echo .

:ende
