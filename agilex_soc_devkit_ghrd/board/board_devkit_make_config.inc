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

# Valid DAUGTHER_CARD Values: none, devkit_dc1, devkit_dc3, devkit_dc4
DAUGHTER_CARD ?= devkit_dc1