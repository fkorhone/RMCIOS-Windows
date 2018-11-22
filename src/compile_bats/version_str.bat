@echo off
:: *****************************************************************************
:: Script to create variables that represent git revisions for sources used.
:: Needed enviroment variables:
:: PROJECT_DIR=  RMCIOS impementation root dir
:: INTERFACE_DIR = RMCIOS-Interface dir
:: SRC_DIR = compiled source directory
:: *****************************************************************************

:: Variable for build revision id
for /f %%i in ('git show -s --format^=%%h') do set REVISION_ID=%%i
::for /f %%i in ('hg id -n') do set REVISION_NUM=%%i
set REVISION=Rev:%REVISION_ID%

:: Variable for interface revision id
cd %PROJECT_DIR%
cd %INTERFACE_DIR%
for /f %%i in ('git show -s --format^=%%h') do set IREVISION_ID=%%i
set IREVISION=iRev:%IREVISION_ID%

:: Variable for source revision id
cd %PROJECTDIR%
cd %SRC_DIR%
for /f %%i in ('git show -s --format^=%%h') do set SREVISION_ID=%%i
set SREVISION=sRev:%SREVISION_ID%
cd %PROJECTDIR%

:: Generate ISO8601 date string
for /f "tokens=2 delims==" %%G in ('wmic os get localdatetime /value') do set datetime=%%G
set year=%datetime:~0,4%
set month=%datetime:~4,2%
set day=%datetime:~6,2%
set hour=%datetime:~8,2%
set minute=%datetime:~10,2%
set seconds=%datetime:~12,2%
set ISO8601DATETIME=%year%-%month%-%day%T%hour%:%minute%:%seconds%

:: set version string
set CFLAGS=%CFLAGS% -D VERSION_STR="\"%REVISION% Built:%ISO8601DATETIME% %SREVISION% %IREVISION%\""
