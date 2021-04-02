################################################
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2020 Intel Corporation.
#
################################################
#
# Makefile for HPS Wipe Firmware
#
################################################

COMPILER ?= GCC
#COMPILER ?= ARMCLANG

ifeq ("$(COMPILER)","GCC")
    
#Check GCC Version
    GCCVERSION_7 = $(shell aarch64-linux-gnu-gcc --version | head -n1 | cut -d " " -f1 || 1)
    GCCVERSION_9 = $(shell aarch64-none-linux-gnu-gcc --version | head -n1 | cut -d " " -f1 || 1)
     
    ifeq "$(GCCVERSION_9)" "aarch64-none-linux-gnu-gcc"
        CROSS_COMPILE ?= "aarch64-none-linux-gnu-"
    eles ifeq "$(GCCVERSION_9)" "aarch64-none-linux-gnu-gcc.exe"
        CROSS_COMPILE ?= "aarch64-none-linux-gnu-"
    else ifeq "$(GCCVERSION_7)" "aarch64-linux-gnu-gcc"
        CROSS_COMPILE ?= "aarch64-linux-gnu-"
    else ifeq "$(GCCVERSION_7)" "aarch64-linux-gnu-gcc.exe"
        CROSS_COMPILE ?= "aarch64-linux-gnu-"
    else
        $(error ERROR :: linaro gcc compiler not found)
    endif

    include Makefile_GCC.inc

else ifeq "$(COMPILER)" "ARMCLANG"

    include Makefile_ARMCLANG.inc

else

    $(error "ERROR :: Invalid Compiler option, choose only GCC or ARMCLANG")

endif
