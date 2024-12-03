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

# FP82 OPN default. 
QUARTUS_DEVICE ?= AGMF039R47A1E2VR0

#HPS EMIF Reference Clock
HPS_EMIF_REF_CLK_FREQ_MHZ ?= "100.0"

# Option to set HPS EMIF CLK frequency in MHz
HPS_EMIF_MEM_CLK_FREQ_MHZ ?= "1600"

HPS_EMIF_TYPE ?= ddr5

# HPS_EMIF_WIDTH
HPS_EMIF_WIDTH ?= 32

# F2H_WIDTH
F2H_WIDTH ?= 256
