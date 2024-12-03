################################################
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2023 Intel Corporation.
#
################################################
#
# Makefile for HPS Wipe Firmware
#
################################################

# Environment check
ifeq ($(CROSS_COMPILE),)
$(error CORSS_COMPILE not defined)
endif

CC:= $(CROSS_COMPILE)as
OBJCOPY := $(CROSS_COMPILE)objcopy
OBJDUMP := $(CROSS_COMPILE)objdump

SRC := hps_wipe.s
ENTRY_POINT:=0x0

IHEX := $(patsubst %.s,%.ihex,$(SRC))
ELF  := $(patsubst %.s,%.elf,$(SRC))
BIN  := $(patsubst %.s,%.bin,$(SRC))
OBJDUMP_FILE = $(patsubst %.s,%.objdump,$(SRC))

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
