MAKE?=make
GCC?=gcc
GENDATE?=
MAKEFILEDIR=makefiles
export

all: rmcios nidaqmx-module base-module std-module windows-module serial-module socket-module gui-module pipe-module program-module

gentime:
	$(GENDATE)

rmcios: gentime
	$(MAKE) -f $(MAKEFILEDIR)/rmcios-windows.mk

nidaqmx-module: gentime
	$(MAKE) -f $(MAKEFILEDIR)/nidaqmx-module.mk

base-module: gentime
	$(MAKE) -f $(MAKEFILEDIR)/base-module.mk

std-module: gentime
	$(MAKE) -f $(MAKEFILEDIR)/std-module.mk

windows-module: gentime
	$(MAKE) -f $(MAKEFILEDIR)/windows-module.mk

serial-module: gentime
	$(MAKE) -f $(MAKEFILEDIR)/windows-serial-module.mk

socket-module: gentime
	$(MAKE) -f $(MAKEFILEDIR)/windows-socket-module.mk

gui-module: gentime
	$(MAKE) -f $(MAKEFILEDIR)/windows-gui-module.mk

pipe-module: gentime
	$(MAKE) -f $(MAKEFILEDIR)/windows-pipe-module.mk

program-module: gentime
	$(MAKE) -f $(MAKEFILEDIR)/windows-program-module.mk

run_program: gentime
	$(MAKE) -f $(MAKEFILEDIR)/run_program.mk

