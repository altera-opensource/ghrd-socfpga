################################################
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2017-2020 Intel Corporation.
#
################################################
#
# Makefile for HPS Wipe Firmware
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

CC_FLAGS := -g --target=$(TARGET_PROCESSOR)
LD_FLAGS := --scatter=$(SCATTER_FILE) --entry=0xffe00000

OBJ.S := $(patsubst %.S,%.o,$(filter %.S,$(SRC)))

OBJ := $(OBJ.S)

# Select build rules based on Windows or Unix
ifdef WINDIR
DONE=@if exist $(1) echo Build completed.
RM=if exist $(1) del /q $(1)
SHELL=$(WINDIR)\system32\cmd.exe
else
ifdef windir
DONE=@if exist $(1) echo Build completed.
RM=if exist $(1) del /q $(1)
SHELL=$(windir)\system32\cmd.exe
else
DONE=@if [ -f $(1) ]; then echo Build completed.; fi
RM=rm -f $(1)
endif
endif


.PHONY: all
all: $(AXF) $(IHEX) $(OBJDUMP_FILE)

clean:
	$(call RM,*.o)
	$(call RM,$(AXF) $(IHEX) $(OBJDUMP_FILE))

$(AXF): $(OBJ) $(SCATTER_FILE)
	$(LD) $(LD_FLAGS) $(OBJ) -o $@

$(OBJDUMP_FILE): %.objdump: %.axf
	$(OD) -s -t --disassemble $< > $@

$(IHEX): %.ihex: %.axf
	$(OBJCOPY) -O ihex $< $@ 

$(OBJ.S): %.o: %.S
	$(CC) -c $(CC_FLAGS) $< -o $@


