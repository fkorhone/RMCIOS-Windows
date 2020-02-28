FILENAME?=run_program
OUTPUT_DIR?=..
OUTPUT_FILE?=$(FILENAME).dll
SOURCES:=run_program.c

CFLAGS+=-static-libgcc 
CFLAGS+=-shared
CFLAGS+=-Wl,--subsystem,windows
GCC?=gcc

compile:
	 $(GCC) $(SOURCES) -o $(OUTPUT_DIR)/$(OUTPUT_FILE) $(CFLAGS)
 
