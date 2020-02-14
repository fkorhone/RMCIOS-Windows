# RMCIOS For Windows
NOTE:
RMCIOS is still under development and changes in interfaces are likely to be expected.

## Before Compiling
Compile scripts require git and gcc to operate properly.

### GIT installed
You need to have git installed in path or at location defined in src/toolpath.bat. default is realative to repository root: ../PortableGit/bin/
git can most likely be downloaded from: https://git-scm.com/download/win

### GCC installed
You need to have GCC or equivalent C-compiler installed in path or at location defined in src/toolpath.bat deftult is relative to repository root: ../mingw/bin/
GCC can most likely be installed using mingw-get-setup.exe installer from http://www.mingw.org/

### Clone submodules before compiling:
execute from command prompt:
git submodule update --init --recursive

or use src/compile\_bats/checkout\_submodules.bat

## Compiling
Compiler used is GCC(MinGW). Define compiler and git path inside src/compile\_bats/toolpath.bat and execute: src/compile\_all.bat

## Directories and files:
* src/compile\_all.bat - Compile whole system including channel modules.
* RMCIOS.exe - compiled rmcios executable. It will automatically look for channel (.dll) modules under modules/ 
* examples/ - example RMCIOS bat confiturations
* modules / - Contains compiled channel modules (.dll) 
* tests/ - Some tests for functionality.
* src/ - Source code base dir contains windows specific sources and system independent/specific submodules in directories.
* src/compile\_bats/ - Direct compile bats for compiling 
* src/RMCIOS-interface/ - RMCIOS interface submodule. Backbone of the system.
* src/RMCIOS-system/ - RMCIOS system submodule. OS independent system implementation.
* src/RMCIOS-base-module/ - RMCIOS base channel submodule. No other depencies than RMCIOS-Interface
* src/RMCIOS-std-module/ -RMCIOS std channel submodule.
* src/RMCIOS-windows-module/ - RMCIOS windows specific channel submodule

## Copying

RMCIOS - Reactive Multipurpose Control Input Output System
Copyright (c) 2018 Frans Korhonen

RMCIOS was originally developed at Institute for Atmospheric 
and Earth System Research / Physics, Faculty of Science, 
University of Helsinki, Finland

Assistance, experience and feedback from following persons have been 
critical for development of RMCIOS: Erkki Siivola, Juha Kangasluoma, 
Lauri Ahonen, Ella Häkkinen, Pasi Aalto, Joonas Enroth, Runlong Cai, 
Markku Kulmala and Tuukka Petäjä.

This file is part of RMCIOS. This notice was encoded using utf-8.

RMCIOS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

RMCIOS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public Licenses
along with RMCIOS.  If not, see <http://www.gnu.org/licenses/>.

