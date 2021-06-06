#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2017-2021 Intel Corporation.
#
#****************************************************************************
# USAGE OF THIS FILE 
# ------------------
# Parameters set in this file are served as default value to configure GHRD for generation.
# Higher level sripts that call upon create_ghrd_*.tcl can over-write value of parameters 
# by arguments to be passed in during execution of script.
#
#****************************************************************************

set QSYS_NAME qsys_top
set PROJECT_NAME ghrd_1sx280lu2f50e2vgs3
#set PROJECT_NAME ghrd_1sx280lu3f50i3vg
set TOP_NAME ghrd_s10_top
set DEVICE_FAMILY "STRATIX10"
set DEVICE 1SX280LU2F50E2VG
#Production revC OPN
#set DEVICE 1SX280LU3F50I3VG 

##### features of GHRD enabling #####

# SoC Board revision
set BOARD_REV "A1"

# Option to disable c2p on initial revB unit
set C2P_EARLY_REVB_OFF 0

#  IO48 DAUGHTER_CARD, available options such as "devkit_dc1", "devkit_dc2", "devkit_dc3", "devkit_dc4"
set DAUGHTER_CARD "devkit_dc1"

# setting to enable clock gating for NINIT_DONE
set CLK_GATE_EN 0

# setting to enable Cross Triggering
set CROSS_TRIGGER_EN 0
set HPS_STM_EN 1

#Option to enable Niosii soft Processor instead of HPS
set NIOSII_EN 0

#Option to enable MMU option in the Niosii soft Processor
set NIOSII_MMU_EN 0

#System Memory for Nios II Processor, ocm for onchip ram or ddr for EMIF
set NIOSII_MEM ocm

# Option to enable FPGA EMIF
set FPGA_EMIF_EN 0 

# Option to enable HPS EMIF
set HPS_EMIF_EN 1 

# Option to specify HPS EMIF memory type
set HPS_EMIF_TYPE ddr4

# Option to set HPS EMIF width (ignoring extra bits for ECC)
set HPS_EMIF_WIDTH 64

# Option to set FPGA EMIF width (ignoring extra bits for ECC)
set FPGA_EMIF_WIDTH 32

# Option to enable HPS EMIF ECC
set HPS_EMIF_ECC_EN 1

# Option to enable FPGA EMIF ECC
set FPGA_EMIF_ECC_EN 0

# Option to enable Hard Processor System
set HPS_EN 1

# Option to enable H2F User Clock0 Output Port
set H2F_USER_CLK_EN 0

# Option to enable HPS initialization first or after FPGA initialization done
set SYS_INITIALIZATION "fpga"

# Option to select HPS debug access port modes
set HPS_DAP_MODE 1

# Option to enable Fast Trace x32/x16 routed via FPGA, Fast Trace and Early Trace are exclusively exist
set FTRACE_EN 0

# Option to select x32/x16 output width for Fast Trace routed via FPGA
set FTRACE_OUTPUT_WIDTH 16

# Option to export the HPS PLL reference clock source to be feed by F2S clock
set HPS_PLL_SOURCE_EXPORT 0

# Option to enable WatchDog reset
set WATCHDOG_RST_EN 1

# Option for WatchDog reset action
set WATCHDOG_RST_ACT 0

# existance of PCIe
set PCIE_EN 0

# Options to enable and set width of each AXI Bridge
set H2F_WIDTH 128
set F2H_WIDTH 128
set LWH2F_WIDTH 32
set H2F_F2H_LOOPBACK_EN 0
set LWH2F_F2H_LOOPBACK_EN 0
set H2F_F2SDRAM0_LOOPBACK_EN 0
set H2F_F2SDRAM1_LOOPBACK_EN 0
set H2F_F2SDRAM2_LOOPBACK_EN 0
set GPIO_LOOPBACK_EN 0
set FPGA_I2C_EN 0
set F2H_ADDR_WIDTH 32
set H2F_ADDR_WIDTH 32
set LWH2F_ADDR_WIDTH 21

set HPS_PERI_IRQ_LOOPBACK_EN 0

set F2SDRAM0_WIDTH 3
set F2SDRAM1_WIDTH 3
set F2SDRAM2_WIDTH 3


set BOARD "devkit"

set FPGA_PERIPHERAL_EN 1

##### to be added

##   PCIe  ##
#Option for selecting generation in PCIe
set GEN_SEL 3

#Option for enable lane in PCIe
set PCIE_COUNT 8

#Option for enable high performance TXS interface in PCIe
set PCIE_HPTXS 1

set PCIE_F2H 1

set SGMII_COUNT 2

set HPS_MGE_EN 0

set HPS_MGE_10GBE_1588_EN 0

set HPS_MGE_10GBE_1588_COUNT 1

set HPS_MGE_10GBE_1588_MAX_COUNT 2

##   Partial Reconfiguration  ##
#Option to generate persona PR subsystem Qsys
set PR_PERSONA 0

# Option to enable PR
set PR_ENABLE 0
#Option to set number of PR Regions
set PR_REGION_COUNT 1

#Option to generate PR design with acknowledgement port delayed
set FREEZE_ACK_DELAY_ENABLE 0

# Enable the PR IP core in the FPGA design
set PARTIAL_RECONFIGURATION_CORE_IP 0

#Option to configure the actual coordinates as well as width, height for reserved LogicLock Region
set PR_X_ORIGIN 3
set PR_Y_ORIGIN 15
set PR_WIDTH 140
set PR_HEIGHT 75

#option for partion region naming
set PR_REGION_NAME "pr_region"
