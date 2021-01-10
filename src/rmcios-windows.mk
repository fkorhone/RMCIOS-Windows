SRC_DIR:=RMCIOS-system
INTERFACE_DIR:=RMCIOS-interface
STD_CONTEXT_DIR:=RMCIOS-std-context
include version_str.mk
GCC?=gcc

SOURCES=RMCIOS-windows.c 
SOURCES+= $(SRC_DIR)/convert.c 
SOURCES+= $(SRC_DIR)/RMCIOS-system.c 
SOURCES+= $(INTERFACE_DIR)/RMCIOS-functions.c
SOURCES+= $(STD_CONTEXT_DIR)/*.c

OUTPUT_DIR:=$(OUTPUT_PATH)
OUTPUT_FILE?=RMCIOS.exe

CFLAGS=
CFLAGS+=-DVERSION_STR=\"$(VERSION_STR)\"
#CFLAGS+=s
CFLAGS+=-O0 
#CFLAGS+=-flto
CFLAGS+=-Wimplicit
CFLAGS+=-static-libgcc 
CFLAGS+=-ggdb3 
CFLAGS+=-I $(SRC_DIR)
CFLAGS+=-I $(INTERFACE_DIR) 
CFLAGS+=-I $(STD_CONTEXT_DIR) 
CFLAGS+=-D API_ENTRY_FUNC=""
CFLAGS+=-Wall
CFLAGS+=-Wextra
CFLAGS+=-Wno-unused-parameter
CFLAGS+=-Wno-sign-compare
CFLAGS+=-Wno-switch

rmcios:
	$(GCC) $(SOURCES) -o $(OUTPUT_DIR)/$(OUTPUT_FILE) $(CFLAGS)

