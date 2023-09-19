################################################
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2017-2023 Intel Corporation.
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

AXF := hps_wipe.axf
IHEX := $(patsubst %.axf,%.ihex,$(AXF))
OBJDUMP_FILE := $(patsubst %.axf,%.objdump,$(AXF))

SRC := hps_wipe.s
SCATTER_FILE := scatter.scat

CC_FLAGS := -g --target=$(TARGET_PROCESSOR) -mcpu=Cortex-A53
LD_FLAGS := --scatter=$(SCATTER_FILE) --entry=0x0

OBJ.s := $(patsubst %.s,%.o,$(filter %.s,$(SRC)))

OBJ := $(OBJ.s)

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

$(OBJ.s): %.o: %.s
	$(CC) -c $(CC_FLAGS) $< -o $@
