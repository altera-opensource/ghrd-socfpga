################################################
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2021-2021 Intel Corporation.
#
################################################
#
# Make include file for Board "PCIE Devkit"
# This file define the supported configuration
#
################################################

##################################################
#
# recommended make commands for production dev kit
#
# []$ make \
# BOARD_TYPE=pcie_devkit \
# BOARD_PWRMGT=linear \
# QUARTUS_DEVICE=AGFB014R24B2E2V \
# ENABLE_HPS_EMIF_ECC=1 \
# HPS_ENABLE_SGMII=0 \
# ENABLE_NIOSV_SUBSYS=0 \
# generate_from_tcl
#
# []$ make \
# BOARD_TYPE=pcie_devkit \
# BOARD_PWRMGT=linear \
# QUARTUS_DEVICE=AGFB014R24B2E2V \
# ENABLE_HPS_EMIF_ECC=1 \
# HPS_ENABLE_SGMII=0 \
# ENABLE_NIOSV_SUBSYS=0 \
# sof
#
##################################################

#FM61 (devkit, mUDV1, mUDV2, char)
QUARTUS_DEVICE ?= AGFB014R24A3E3VR0
#QUARTUS_DEVICE ?= AGFB014R24A2E2VR1

#HPS EMIF Reference Clock
HPS_EMIF_REF_CLK_FREQ_MHZ ?= "33.333"
