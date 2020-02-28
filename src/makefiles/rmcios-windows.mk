SRC_DIR:=RMCIOS-system
INTERFACE_DIR:=RMCIOS-interface
include version_str.mk
GCC?=gcc

SOURCES=RMCIOS-windows.c 
SOURCES+= string-conversion.c 
SOURCES+= $(SRC_DIR)/RMCIOS-system.c 
SOURCES+=$(INTERFACE_DIR)/RMCIOS-functions.c

OUTPUT_DIR?=..
OUTPUT_FILE?=RMCIOS.exe

CFLAGS=
CFLAGS+=-DVERSION_STR=\"$(VERSION_STR)\"
CFLAGS+=-s 
CFLAGS+=-O0 
CFLAGS+=-flto
CFLAGS+=-Wimplicit
CFLAGS+=-static-libgcc 
CFLAGS+=-g 
CFLAGS+=-I $(SRC_DIR)
CFLAGS+=-I $(INTERFACE_DIR) 
CFLAGS+=-D API_ENTRY_FUNC=""
CFLAGS+=-Wall
CFLAGS+=-Wextra
CFLAGS+=-Wno-unused-parameter
CFLAGS+=-Wno-sign-compare
CFLAGS+=-Wno-switch

rmcios:
	$(GCC) $(SOURCES) -o $(OUTPUT_DIR)/$(OUTPUT_FILE) $(CFLAGS)

