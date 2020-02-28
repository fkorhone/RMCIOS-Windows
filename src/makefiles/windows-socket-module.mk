SRC_DIR:=RMCIOS-windows-module
SOURCES:=$(SRC_DIR)/socket_channels.c
FILENAME?=windows-socket-module
CFLAGS?=
CFLAGS+=-lwinmm
CFLAGS+=-mwindows
CFLAGS+=-lws2_32
CC?=gcc
MAKE?=make
export

compile:
	$(MAKE) -f module_dll.mk compile
