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
QUARTUS_DEVICE ?= AGFB014R24A3E3VR0
#QUARTUS_DEVICE ?= AGFB014R24A2E2VR1

# Publicly Available DC: devkit_dc_oobe, devkit_dc_nand, devkit_dc_emmc
DAUGHTER_CARD ?= devkit_dc_oobe

# HPS SGMII Enablement
HPS_ENABLE_SGMII ?= 0

