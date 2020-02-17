:: ******************************************************
:: Tool locations are set here. Other scripts call this.
:: ******************************************************


IF "%TOOLPATH_SET%" == "set" (
  goto :eof 
)
set TOOLPATH_SET="set"

set MAKE=make
set MAKEFILEDIR=makefiles

set TOOLPATH=..\..\..\

set GITDIR=%TOOLPATH%PortableGit\bin\
set COMPILER_PATH=%TOOLPATH%minGW\bin\
set INDENTER_DIR=%TOOLPATH%indenters\
set PYTHON_DIR=%TOOLPATH%python\

:: Add GIT to path.
set PROJECTDIR=%CD%
cd %GITDIR%
set PATH=%PATH%;%CD%
cd %PROJECTDIR%

:: Add compiler to PATH
cd %COMPILER_PATH%
set PATH=%PATH%;%CD%
cd %PROJECTDIR%

:: Add indenters to PATH
cd %INDENTER_DIR%
set PATH=%PATH%;%CD%
cd %PROJECTDIR%

:: add python to path
cd %PYTHON_DIR%
set PYTHONPATH=%CD%\DLLs;%CD%\Lib;%CD%\Lib\site-packages
set PYTHONHOME=%CD%
cd %PROJECTDIR%


