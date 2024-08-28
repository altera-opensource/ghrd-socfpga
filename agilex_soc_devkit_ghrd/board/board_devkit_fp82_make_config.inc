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
BOARD_PWRMGT = linear

#FP82 (devkit, mUDV1, mUDV2, char)
QUARTUS_DEVICE = AGMF039R47A1E2VR0

#HPS EMIF Reference Clock
HPS_EMIF_REF_CLK_FREQ_MHZ = "100.0"

# Option to set HPS EMIF CLK frequency in MHz
HPS_EMIF_MEM_CLK_FREQ_MHZ = "1600"

HPS_EMIF_TYPE = ddr5

# Publicly Available DC: devkit_dc_oobe, devkit_dc_nand, devkit_dc_emmc
DAUGHTER_CARD = devkit_dc_oobe

# Disable HPS SGMII
HPS_ENABLE_SGMII = 0

# Disable ETILE 1588v2 PTP
ENABLE_ETILE_1588 = 0

# Disable NiosV subsystem
ENABLE_NIOSV_SUBSYS = 0

# HPS_EMIF_WIDTH
HPS_EMIF_WIDTH = 32

# F2H_WIDTH
F2H_WIDTH = 256

# Disable HPS_F2S_IRQ 
HPS_F2S_IRQ_EN = 0

# Disable HPS_STM
HPS_STM_EN = 0

# Disable SGPIO
FPGA_SGPIO_EN = 0

# Disable HPS_EMIF_ECC
ENABLE_HPS_EMIF_ECC = 0

# Disable WATCHDOG_RST
ENABLE_WATCHDOG_RST = 0