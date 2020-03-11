SRC_DIR:=RMCIOS-python
SOURCES:=$(SRC_DIR)/*.c
FILENAME:=python-module
CFLAGS+=-I../../python/include/
CFLAGS+=libpython.a 
GCC?=gcc
DLLTOOL?=dlltool
MAKE?=make
export

compile:
	gendef $(PYTHONHOME)\python38.dll
	$(DLLTOOL) -k --output-lib libpython.a --input-def python38.def
	$(MAKE) -f module_dll.mk compile
