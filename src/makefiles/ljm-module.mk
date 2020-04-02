SRC_DIR:=RMCIOS-Labjack-module
SOURCES:=$(SRC_DIR)/ljm_channels.c
FILENAME:=ljm-module
MAKE?=make
CFLAGS+=liblabjackm.a 
CFLAGS+=-I$(SRC_DIR)/linklib
LINKDEF?=LabJackM.def
export

compile:
	$(DLLTOOL) -k -d $(SRC_DIR)/linklib/${LINKDEF} -l liblabjackm.a 
	$(MAKE) -f module_dll.mk compile
