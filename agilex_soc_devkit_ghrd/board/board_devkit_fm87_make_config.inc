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

#FM87 (devkit, mUDV1, mUDV2, char)
#QUARTUS_DEVICE ?= AGIB027R31B1E1VAA
#QUARTUS_DEVICE ?= AGFB014R24A3E3VR0

#FM87 Rev C (Default OPN release to customer)
QUARTUS_DEVICE ?= AGIB027R31B1E1VB

#HPS EMIF Reference Clock
HPS_EMIF_REF_CLK_FREQ_MHZ ?= "166.666"

# Option to set HPS EMIF CLK frequency in MHz
HPS_EMIF_MEM_CLK_FREQ_MHZ ?= "1333.33"
