SRC_DIR:=RMCIOS-base-module
SOURCES:=$(SRC_DIR)/*.c
FILENAME?=base-module
CFLAGS?=
MAKE?=make
export

compile:
	$(MAKE) -f module_dll.mk compile
