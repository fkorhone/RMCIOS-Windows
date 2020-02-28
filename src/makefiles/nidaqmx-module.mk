SRC_DIR:=RMCIOS-NI-DAQmx-module
SOURCES:=$(SRC_DIR)/*.c
FILENAME:=nidaqmx-module
CFLAGS+=libnidaqmx.a 
CFLAGS+=-I$(SRC_DIR)/linklib
CC?=gcc
DLLTOOL?=dlltool
MAKE?=make
export

compile:
	$(DLLTOOL) -m i386 -k -d $(SRC_DIR)/linklib/NIDAQmx.def -l libnidaqmx.a 
	$(MAKE) -f module_dll.mk compile
