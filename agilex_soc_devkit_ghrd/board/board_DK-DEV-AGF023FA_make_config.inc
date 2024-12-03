################################################
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2021-2021 Intel Corporation.
#
################################################
#
# Make include file for Board "Devkit"
# This file define the supported configuration
#
################################################


#FM76
QUARTUS_DEVICE ?= AGFD023R24C2E1VC

#HPS EMIF Reference Clock
HPS_EMIF_REF_CLK_FREQ_MHZ ?= "166.625"
HPS_EMIF_MEM_CLK_FREQ_MHZ ?= "1333.0"
HPS_EMIF_WIDTH ?= "32"
HPS_EMIF_BANK_GP_WIDTH ?= "2"
HPS_EMIF_COMP_PRESET ?= "DDR4-3200AA CL22 Component 1CS 8Gb (1Gb x8)"

