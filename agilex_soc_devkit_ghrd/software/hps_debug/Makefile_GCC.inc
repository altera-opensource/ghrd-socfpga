################################################
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2020 Intel Corporation.
#
################################################
#
# Makefile for HPS Wipe Firmware GCC
#
################################################

CC:= $(CROSS_COMPILE)as
OBJCOPY := $(CROSS_COMPILE)objcopy
OBJDUMP := $(CROSS_COMPILE)objdump

SRC := hps_debug.S
ENTRY_POINT:=0xffe00000

IHEX := $(patsubst %.S,%.ihex,$(SRC))
ELF  := $(patsubst %.S,%.elf,$(SRC))
BIN  := $(patsubst %.S,%.bin,$(SRC))
OBJDUMP_FILE = $(patsubst %.S,%.objdump,$(SRC))

OBJ_FLAG := -I binary -O ihex --change-address $(ENTRY_POINT)

RM := rm -rf

.PHONY: all
all: $(ELF) $(BIN) $(IHEX) $(OBJDUMP_FILE)

clean:
	$(RM) $(ELF) $(IHEX) $(BIN) $(OBJDUMP_FILE)
                
$(ELF): $(SRC)
	$(CC) $(SRC) -o $@

$(BIN): $(ELF)
	$(OBJCOPY) -O binary $< $@

$(IHEX): $(BIN)
	$(OBJCOPY) $(OBJ_FLAG) $< $@

$(OBJDUMP_FILE): $(ELF)
	$(OBJDUMP) --disassemble $< > $@

