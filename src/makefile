MAKE?=make
GCC?=gcc
MKDIR=.
GCC_CROSS_WIN32?=i686-w64-mingw32-gcc
GCC_CROSS_WIN64?=x86_64-w64-mingw32-gcc
DLLTOOL_CROSS_WIN32?=i686-w64-mingw32-dlltool
DLLTOOL_CROSS_WIN64?=x86_64-w64-mingw32-dlltool
MAKEFILEDIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

ifeq ($(OS),Windows_NT)     # is Windows_NT on XP, 2000, 7, Vista, 10...
   COPY_DIR:=xcopy /E /I
   COPY:=copy
else
   COPY:=cp
   COPY_DIR:=cp -r
endif

export

all: rmcios
all-cross-win32: rmcios-cross-win32

rmcios:${}
	$(MAKE) -f $(MKDIR)/rmcios.mk all

win32-artifacts:
	$(MAKE) -f $(MKDIR)/rmcios.mk INSTALLDIR=${MAKEFILEDIR}/../artifacts/win32 artifacts
	$(MAKE) -f $(MKDIR)/run_program.mk OUTPUT_PATH=${MAKEFILEDIR}/../artifacts/win32

win64-artifacts:
	$(MAKE) -f $(MKDIR)/rmcios.mk NIDAQDEF=NIDAQmx64.def LJMDEF=LabJack64.def INSTALLDIR=${MAKEFILEDIR}/../artifacts/win64 artifacts
	$(MAKE) -f $(MKDIR)/run_program.mk OUTPUT_PATH=${MAKEFILEDIR}/../artifacts/win64

cross-win32-artifacts:
	$(MAKE) -f $(MKDIR)/rmcios.mk GCC=$(GCC_CROSS_WIN32) DLLTOOL=$(DLLTOOL_CROSS_WIN32) INSTALLDIR=${MAKEFILEDIR}/../artifacts/win32 artifacts
	$(MAKE) -f $(MKDIR)/run_program.mk GCC=$(GCC_CROSS_WIN32) OUTPUT_PATH=${MAKEFILEDIR}/../artifacts/win32
	$(MAKE) -f $(MKDIR)/run_program.mk GCC=$(GCC_CROSS_WIN64) OUTPUT_PATH=${MAKEFILEDIR}/../artifacts/win32 FILENAME=run_program64

cross-win64-artifacts:
	$(MAKE) -f $(MKDIR)/rmcios.mk GCC=$(GCC_CROSS_WIN64) DLLTOOL=$(DLLTOOL_CROSS_WIN64) NIDAQDEF=NIDAQmx64.def LJMDEF=LabJackM64.def INSTALLDIR=${MAKEFILEDIR}/../artifacts/win64 artifacts
	$(MAKE) -f $(MKDIR)/run_program.mk GCC=$(GCC_CROSS_WIN32) OUTPUT_PATH=${MAKEFILEDIR}/../artifacts/win64
	$(MAKE) -f $(MKDIR)/run_program.mk GCC=$(GCC_CROSS_WIN64) OUTPUT_PATH=${MAKEFILEDIR}/../artifacts/win64 FILENAME=run_program64

run_program:
	$(MAKE) -f $(MKDIR)/run_program.mk 
