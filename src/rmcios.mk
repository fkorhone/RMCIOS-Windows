MAKE?=make
GCC?=gcc
GENDATE?=
DLLTOOL?=dlltool
OUTPUT_PATH?=../
NIDAQDEF?=NIDAQmx.def
LJMDEF?=LabJackM.def
export

all: rmcios nidaqmx-module labjack-module python-module base-module std-module windows-module

gentime:
	$(GENDATE)

artifacts: all
	${COPY} ../LICENSE $(OUTPUT_PATH)
	${COPY_DIR} ../examples $(OUTPUT_PATH)

rmcios: gentime 
	$(MAKE) -f rmcios-windows.mk

nidaqmx-module: gentime 
	$(MAKE) -C RMCIOS-NI-DAQmx-module
	$(MAKE) -C RMCIOS-NI-DAQmx-module install

labjack-module: gentime
	$(MAKE) -C RMCIOS-Labjack-module
	$(MAKE) -C RMCIOS-Labjack-module install

python-module: gentime
	$(MAKE) -C RMCIOS-Python
	$(MAKE) -C RMCIOS-Python install

base-module: gentime 
	$(MAKE) -C RMCIOS-base-module
	$(MAKE) -C RMCIOS-base-module install

std-module: gentime 
	$(MAKE) -C RMCIOS-std-module
	$(MAKE) -C RMCIOS-std-module install

windows-module: gentime 
	$(MAKE) -C RMCIOS-windows-module
	$(MAKE) -C RMCIOS-windows-module install

run_program: gentime 
	$(MAKE) -f run_program.mk

