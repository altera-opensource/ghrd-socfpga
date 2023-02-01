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
BOARD_PWRMGT ?= enpirion

#FM61 (devkit, mUDV1, mUDV2, char)
#QUARTUS_DEVICE ?= AGFB014R24B2E2V
#QUARTUS_DEVICE ?= AGFB014R24A3E3VR0

#FM87 (devkit, mUDV1, mUDV2, char)
QUARTUS_DEVICE ?= AGIB027R31B1E1VAA
#QUARTUS_DEVICE ?= AGFB014R24A3E3VR0

#HPS EMIF Reference Clock
HPS_EMIF_REF_CLK_FREQ_MHZ ?= "166.666"

# Option to set HPS EMIF CLK frequency in MHz
HPS_EMIF_MEM_CLK_FREQ_MHZ ?= "1333.33"

# Publicly Available DC: devkit_dc_oobe, devkit_dc_nand, devkit_dc_emmc
DAUGHTER_CARD ?= devkit_dc_oobe

# HPS SGMII Enablement
HPS_ENABLE_SGMII ?= 0

# Enable ETILE 1588v2 PTP
ENABLE_ETILE_1588 ?= 0

# Enable NiosV subsystem
ENABLE_NIOSV_SUBSYS ?= 0
