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

# Board Power Management. Only board "devkit" is supported: linear, enpirion
BOARD_PWRMGT ?= linear

#FM61 (devkit, mUDV1, mUDV2, char)
#QUARTUS_DEVICE ?= AGFB014R24B2E2V
#QUARTUS_DEVICE ?= AGFB014R24A3E3VR0

#FM87 (devkit, mUDV1, mUDV2, char)
#QUARTUS_DEVICE ?= AGIB027R31B1E2VR0

#FM86 revA(lookout, pyramid, mcgowan)
#QUARTUS_DEVICE ?= AGFB027R24C2E2V

#FM86 revB(lookout, pyramid, mcgowan)
QUARTUS_DEVICE ?= AGFB027R24C2E2VR2

#HPS EMIF Reference Clock
HPS_EMIF_REF_CLK_FREQ_MHZ ?= "166.625"
HPS_EMIF_MEM_CLK_FREQ_MHZ ?= "1333.0"
HPS_EMIF_WIDTH ?= "32"
HPS_EMIF_BANK_GP_WIDTH ?= "2"
HPS_EMIF_COMP_PRESET ?= "DDR4-3200AA CL22 Component 1CS 8Gb (1Gb x8)"

# Publicly Available DC: devkit_dc_oobe, devkit_dc_nand, devkit_dc_emmc
DAUGHTER_CARD ?= devkit_dc_oobe

# HPS SGMII Enablement
HPS_ENABLE_SGMII ?= 0

ENABLE_NIOSV_SUBSYS ?= 0