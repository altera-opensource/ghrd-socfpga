################################################
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2017-2020 Intel Corporation.
#
################################################
#
# Makefile for HPS Wipe Firmware ARMCLANG
#
################################################

AS := armasm
CC := armclang
LD := armlink
OD := fromelf
OBJCOPY := objcopy

TARGET_PROCESSOR := aarch64-arm-none-eabi

AXF := hps_debug.axf
IHEX := $(patsubst %.axf,%.ihex,$(AXF))
OBJDUMP_FILE := $(patsubst %.axf,%.objdump,$(AXF))

SRC := hps_debug.S
SCATTER_FILE := scatter.scat

CC_FLAGS := -g --target=$(TARGET_PROCESSOR) -mcpu=Cortex-A53
LD_FLAGS := --scatter=$(SCATTER_FILE) --entry=0xffe00000

OBJ.S := $(patsubst %.S,%.o,$(filter %.S,$(SRC)))

OBJ := $(OBJ.S)

RM := rm -rf

.PHONY: all
all: $(AXF) $(IHEX) $(OBJDUMP_FILE)

clean:
	$(RM) *.o
	$(RM) $(AXF) $(IHEX) $(OBJDUMP_FILE)

$(AXF): $(OBJ) $(SCATTER_FILE)
	$(LD) $(LD_FLAGS) $(OBJ) -o $@

$(OBJDUMP_FILE): %.objdump: %.axf
	$(OD) -s -t --disassemble $< > $@

$(IHEX): %.ihex: %.axf
	$(OBJCOPY) -O ihex $< $@ 

$(OBJ.S): %.o: %.S
	$(CC) -c $(CC_FLAGS) $< -o $@


