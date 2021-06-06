MAKE?=make
GCC?=gcc
GENDATE?=
DLLTOOL?=dlltool
MAKEFILEDIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
INSTALLDIR?=${MAKEFILEDIR}/../
NIDAQDEF?=NIDAQmx.def
LJMDEF?=LabJackM.def
export

all: rmcios nidaqmx-module labjack-module python-module base-module std-module windows-module

gentime:
	$(GENDATE)

artifacts: all
	${COPY} ../LICENSE $(INSTALLDIR)
	${COPY_DIR} ../examples $(INSTALLDIR)

rmcios: gentime 
	$(MAKE) -f rmcios-windows.mk OUTPUT_DIR=${INSTALLDIR}

nidaqmx-module: gentime 
	$(MAKE) -C RMCIOS-NI-DAQmx-module LINKDEF=${NIDAQDEF}
	$(MAKE) -C RMCIOS-NI-DAQmx-module install INSTALLDIR=${INSTALLDIR}

labjack-module: gentime
	$(MAKE) -C RMCIOS-Labjack-module LINKDEF=${LJMDEF}
	$(MAKE) -C RMCIOS-Labjack-module install INSTALLDIR=${INSTALLDIR}

python-module: gentime
	$(MAKE) -C RMCIOS-Python
	$(MAKE) -C RMCIOS-Python install INSTALLDIR=${INSTALLDIR}

base-module: gentime 
	$(MAKE) -C RMCIOS-base-module
	$(MAKE) -C RMCIOS-base-module install INSTALLDIR=${INSTALLDIR}

std-module: gentime 
	$(MAKE) -C RMCIOS-std-module
	$(MAKE) -C RMCIOS-std-module install INSTALLDIR=${INSTALLDIR}

windows-module: gentime 
	$(MAKE) -C RMCIOS-windows-module
	$(MAKE) -C RMCIOS-windows-module install INSTALLDIR=${INSTALLDIR}

