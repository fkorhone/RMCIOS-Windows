SRC_DIR:=RMCIOS-Labjack-module
SOURCES:=$(SRC_DIR)/labjack-u12-module.c
FILENAME:=labjack-module
MAKE?=make
export

compile:
	$(MAKE) -f module_dll.mk compile
