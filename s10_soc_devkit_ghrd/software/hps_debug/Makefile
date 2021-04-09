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

#COMPILER ?= GCC
#COMPILER ?= ARMCLANG

WHICH = which

#Check GCC Version
GCCVERSION_7 := $(shell $(WHICH) aarch64-linux-gnu-gcc  2>/dev/null)
GCCVERSION_9 := $(shell $(WHICH) aarch64-none-linux-gnu-gcc 2>/dev/null)
 
ifneq ($(GCCVERSION_9),)
    CROSS_COMPILE ?= "aarch64-none-linux-gnu-"
else ifneq ($(GCCVERSION_7),)
    CROSS_COMPILE ?= "aarch64-linux-gnu-"
else
    CROSS_COMPILE = "NOT_FOUND"
endif

ifndef COMPILER
    #If no COMPILER defined Try GCC First, then try ARMCLANG
    
    ifneq ($(CROSS_COMPILE), "NOT_FOUND")
        include Makefile_GCC.inc
    else ifneq ($(shell $(WHICH) armclang 2>/dev/null),)
        include Makefile_ARMCLANG.inc
    else
        $(error "ERROR :: GCC or ARMCLANG Compiler not found, please install either one of the compiler to continue")
    endif

else ifeq ("$(COMPILER)","GCC")  

    ifneq ($(CROSS_COMPILE), "NOT_FOUND")
        include Makefile_GCC.inc
    else
        $(error "ERROR :: COMPILER=GCC is chosen, please install gcc compiler to continue or try COMPILER=ARMCC")
    endif

else ifeq ("$(COMPILER)","ARMCLANG")
    
    ifneq ("$(shell $(WHICH) armclang 2>/dev/null)", "")
        include Makefile_ARMCLANG.inc
    else
        $(error "ERROR :: COMPILER=ARMCLANG is chosen, please install arm compiler to continue or try COMPILER=GCC")
    endif

else

    $(error "ERROR :: Invalid Compiler option, choose only GCC or ARMCLANG")

endif

