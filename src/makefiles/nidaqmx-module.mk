SRC_DIR:=RMCIOS-NI-DAQmx-module
SOURCES:=$(SRC_DIR)/*.c
FILENAME:=nidaqmx-module
CFLAGS+=libnidaqmx.a 
CFLAGS+=-I$(SRC_DIR)/linklib
CC?=gcc
DLLTOOL?=dlltool
MAKE?=make
LINKDEF?=NIDAQmx.def
export

compile:
	$(DLLTOOL) -k -d $(SRC_DIR)/linklib/$(LINKDEF) -l libnidaqmx.a 
	$(MAKE) -f module_dll.mk compile
