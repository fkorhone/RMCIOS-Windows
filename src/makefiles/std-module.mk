SRC_DIR:=RMCIOS-std-module
SOURCES:=$(SRC_DIR)/*.c
FILENAME?=std-module
CFLAGS?=
CC?=gcc
MAKE?=make
export

compile:
	$(MAKE) -f module_dll.mk compile
