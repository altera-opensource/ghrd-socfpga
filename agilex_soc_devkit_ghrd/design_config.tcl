#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2021 Intel Corporation.
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
set PROJECT_NAME ghrd_agilex
set TOP_NAME ghrd_agilex_top
set DEVICE_FAMILY "Agilex"
set DEVICE AGFB014R24A3E3VR0

##### features of GHRD enabling #####

# setting to enable clock gating for NINIT_DONE
set CLK_GATE_EN 0

## ----------------
## Board
## ----------------

set BOARD "DK-SI-AGF014E"
# Only valid for board="DK-SI-AGF014E"; "enpirion" or "linear"
set BOARD_PWRMGT "linear"

# SoC Board revision
set BOARD_REV "A1"

# SoC Board Selected MSEL
set CONFIG_SCHEME "ACTIVE SERIAL X4"

# Configuration clock source
set DEVICE_INITIALIZATION_CLOCK "INIT_INTOSC"

#  IO48 DAUGHTER_CARD, available options such as "devkit_dc_oobe", "devkit_dc_nand", "devkit_dc_emmc"
set DAUGHTER_CARD "devkit_dc_oobe"

set FPGA_PERIPHERAL_EN 1

set FPGA_SGPIO_EN 1

set NIOSV_SUBSYS_EN 1

## ----------------
## OCM
## ----------------

set JTAG_OCM_EN 1
set OCM_DATAWIDTH 128
set OCM_MEMSIZE 262144.0

## ----------------
## HPS EMIF
## ----------------

# Option to enable HPS EMIF
set HPS_EMIF_EN 1
#Option to enable custom DIMM types for HPS_EMIF
set HPS_EMIF_MEM_PART "default_part"
# Option to specify HPS EMIF memory type
set HPS_EMIF_TYPE ddr4
# Option to set HPS EMIF RATE
set HPS_EMIF_RATE RATE_QUARTER
# Option to set HPS EMIF REF CLK frequency in MHz
set HPS_EMIF_REF_CLK_FREQ_MHZ 100.0
# Option to set HPS EMIF CLK frequency in MHz
set HPS_EMIF_MEM_CLK_FREQ_MHZ 1200.0
# Option to set HPS EMIF width (ignoring extra bits for ECC)
set HPS_EMIF_WIDTH 64
# Option to enable HPS EMIF ECC
set HPS_EMIF_ECC_EN 0

# Addtional Option to set HPS EMIF Memory Parameters
# only for custom or termination_sweep
set HPS_EMIF_COMP_PRESET "DDR4-3200AA CL22 Component 1CS 8Gb (512Mb x16)"
set HPS_EMIF_MEM_FORMAT MEM_FORMAT_DISCRETE
set HPS_EMIF_TCL 14
set HPS_EMIF_WTCL 11
set HPS_EMIF_BANK_ADDR_WIDTH 2
set HPS_EMIF_BANK_GP_WIDTH 1
set HPS_EMIF_NUM_DIMMS 1
set HPS_EMIF_RANKS_PER_DIMM 1
set HPS_EMIF_EXPORT_SEQ_AVALON_SLAVE CAL_DEBUG_EXPORT_MODE_DISABLED
set HPS_EMIF_JTAG_UART_EN false
set HPS_EMIF_EXTRA_CONFIGS " "

# only for termination_sweep
set HPS_EMIF_RTT_WR_ENUM DDR4_RTT_WR_ODT_DISABLED
set HPS_EMIF_DRV_STR_ENUM DDR4_DRV_STR_RZQ_7
set HPS_EMIF_RTT_NOM_ENUM DDR4_RTT_NOM_ODT_DISABLED
set HPS_EMIF_RTT_PARK "DDR4_RTT_PARK_RZQ_4"
set HPS_EMIF_USE_DEFAULT_ODT "false"
set HPS_EMIF_R_ODT0_1X1 "off"
set HPS_EMIF_W_ODT0_1X1 "off"
set HPS_EMIF_AC_IO_STD_ENUM IO_STD_SSTL_12
set HPS_EMIF_CK_IO_STD_ENUM IO_STD_SSTL_12
set HPS_EMIF_DATA_IO_STD_ENUM IO_STD_POD_12
set HPS_EMIF_AC_MODE_ENUM OUT_OCT_40_CAL
set HPS_EMIF_CK_MODE_ENUM OUT_OCT_40_CAL
set HPS_EMIF_DATA_OUT_MODE_ENUM OUT_OCT_34_CAL
set HPS_EMIF_DATA_IN_MODE_ENUM IN_OCT_60_CAL
set HPS_EMIF_REF_CLK_IO_STD_ENUM IO_STD_TRUE_DIFF_SIGNALING
set HPS_EMIF_RZQ_IO_STD_ENUM IO_STD_CMOS_12
set HPS_EMIF_DIAG_SOFT_NIOS_MODE SOFT_NIOS_MODE_DISABLED

## ----------------
## FPGA EMIF
## ----------------

# Option to enable FPGA EMIF
set FPGA_EMIF_EN 0
# Option to set FPGA EMIF width (ignoring extra bits for ECC)
set FPGA_EMIF_WIDTH 32
# Option to enable FPGA EMIF ECC
set FPGA_EMIF_ECC_EN 0

## ----------------
## HPS
## ----------------

# Option to enable Hard Processor System
set HPS_EN 1
# Option to enable H2F User Clock0 Output Port
set H2F_USER0_CLK_EN 0
set H2F_USER1_CLK_EN 0
set H2F_USER1_FREQ 100

# Option to enable HPS initialization first or after FPGA initialization done
set SYS_INITIALIZATION "fpga"

# Option to select HPS debug access port modes
set HPS_DAP_MODE 2

# Option to enable Fast Trace x32/x16 routed via FPGA, Fast Trace and Early Trace are exclusively exist
set FTRACE_EN 0

# Option to select x32/x16 output width for Fast Trace routed via FPGA
set FTRACE_OUTPUT_WIDTH 16

# Option to export the HPS PLL reference clock source to be feed by F2S clock
set HPS_PLL_SOURCE_EXPORT 0

# Option to enable WatchDog reset
set WATCHDOG_RST_EN 0

# Option for WatchDog reset action
set WATCHDOG_RST_ACT 0

# Options to enable and set width of each AXI Bridge
set H2F_WIDTH 128
set F2H_WIDTH 512
set LWH2F_WIDTH 32
set H2F_F2H_LOOPBACK_EN 0
set LWH2F_F2H_LOOPBACK_EN 0
set GPIO_LOOPBACK_EN 0
set H2F_F2H_LOOPBACK_CCT_EN 0
set F2H_ADDR_WIDTH 32
set H2F_ADDR_WIDTH 32
set LWH2F_ADDR_WIDTH 21
set F2H_CLK_SOURCE 0
set H2F_CLK_SOURCE 0
set LWH2F_CLK_SOURCE 0
set OCM_CLK_SOURCE 0
set SECURE_F2H_AXI_SLAVE 0

set HPS_PERI_IRQ_LOOPBACK_EN 0

set HPS_F2S_IRQ_EN 1

# setting to enable Cross Triggering
set CROSS_TRIGGER_EN 0
set HPS_STM_EN 1

## ----------------
## PCIE
## ----------------

# existance of PCIe
set PCIE_EN 0

#Option for selecting generation in PCIe
set GEN_SEL 4

#Option for enable lane in PCIe
set PCIE_COUNT 4

#Option for enable high performance TXS interface in PCIe
set PCIE_HPTXS 1

## ----------------
## Partial Reconfiguration
## ----------------

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
set PR_X_ORIGIN 100
set PR_Y_ORIGIN 100
set PR_WIDTH 140
set PR_HEIGHT 75

#option for partion region naming
set PR_REGION_NAME "pr_region"

## ----------------
## SGMII (HPS EMAC + TSE PHY (SGMII))
## ----------------
# setting to enable SGMII Ethernet port(s) in HPS, SGMII Enet
set SGMII_EMAC1_ENABLE 0
set SGMII_EMAC2_ENABLE 0

## ----------------
## JOP
## ----------------
# setting to enable JOP for remote debug
set JOP_EN 0

## ----------------
## Etile 25GbE
## ----------------
#Option for etile 25GbE 1588
set HPS_ETILE_1588_EN 0
set HPS_ETILE_1588_COUNT 1
set HPS_ETILE_1588_25GBE_EN 0
set HPS_ETILE_1588_10GBE_EN 0
