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

#FM61 (devkit, mUDV1, mUDV2, char)
QUARTUS_DEVICE ?= AGFB014R24A2E2V
#QUARTUS_DEVICE ?= AGFB014R24A2E2VR1

#HPS EMIF Reference Clock
HPS_EMIF_REF_CLK_FREQ_MHZ ?= "33.333"
