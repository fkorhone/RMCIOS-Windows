GCC?=gcc

objects := $(wildcard *.c) # Right
# RMCIOS interface sources
INTERFACE_DIR:=RMCIOS-interface
SOURCES+= string-conversion.c 
SOURCES+= $(INTERFACE_DIR)/RMCIOS-functions.c
include version_str.mk

:: Output
OUTPUT_DIR:=$(OUTPUT_PATH)/modules
OUTPUT_FILE:=$(FILENAME).dll

# Compiler flags
# CFLAGS+=" -s" 
CFLAGS+=-O0 
CFLAGS+=-ggdb3
# CFLAGS+=" -flto"
# CFLAGS+=" -g"
CFLAGS+=-DVERSION_STR=\"$(VERSION_STR)\"
CFLAGS+=-static-libgcc
CFLAGS+=-shared
CFLAGS+=-Wl,--subsystem,windows
CFLAGS+=-I$(INTERFACE_DIR)
CFLAGS+=-DAPI_ENTRY_FUNC="__declspec(dllexport) __cdecl"
CFLAGS+=-Wall
CFLAGS+=-Wextra
CFLAGS+=-Wno-unused-parameter
CFLAGS+=-Wno-sign-compare
CFLAGS+=-Wno-switch

compile:
	$(GCC) $(SOURCES) -o $(OUTPUT_DIR)/$(OUTPUT_FILE) $(CFLAGS)


