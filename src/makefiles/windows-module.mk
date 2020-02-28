SRC_DIR:=RMCIOS-windows-module
SOURCES:=$(SRC_DIR)/windows_channels.c
FILENAME?=windows-module
CFLAGS?=
CFLAGS+=-lwinmm
CFLAGS+=-mwindows
CC?=gcc
MAKE?=make
export

compile:
	$(MAKE) -f module_dll.mk compile
