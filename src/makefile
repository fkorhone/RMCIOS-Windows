MAKE?=make
GCC?=gcc
MKDIR=makefiles
GCC_CROSS_WIN32?=i686-w64-mingw32-gcc
GCC_CROSS_WIN64?=x86_64-w64-mingw32-gcc
DLLTOOL_CROSS_WIN32?=i686-w64-mingw32-dlltool
DLLTOOL_CROSS_WIN64?=x86_64-w64-mingw32-dlltool
export

all: rmcios
all-cross-win32: rmcios-cross-win32

rmcios:
	$(MAKE) -f $(MKDIR)/rmcios.mk all

cross-win32:
	$(MAKE) -f $(MKDIR)/rmcios.mk GCC=$(GCC_CROSS_WIN32) DLLTOOL=$(DLLTOOL_CROSS_WIN32) all
	$(MAKE) -f $(MKDIR)/run_program.mk GCC=$(GCC_CROSS_WIN32)
	$(MAKE) -f $(MKDIR)/run_program.mk GCC=$(GCC_CROSS_WIN64) FILENAME=run_program64

cross-win64:
	$(MAKE) -f $(MKDIR)/rmcios.mk CC=$(CC_CROSS_WIN64) DLLTOOL=$(DLLTOOL_CROSS_WIN64) all
	$(MAKE) -f $(MKDIR)/run_program.mk CC=$(CC_CROSS_WIN32)
	$(MAKE) -f $(MKDIR)/run_program.mk CC=$(CC_CROSS_WIN64) FILENAME=run_program64

run_program:
	$(MAKE) -f $(MKDIR)/run_program.mk 
