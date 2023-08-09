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
set TOP_NAME ghrd_agilex5_top
set DEVICE_FAMILY "Agilex 5"
set DEVICE A5ED065BB32AE5SR0

##### features of GHRD enabling #####

# setting to enable clock gating for NINIT_DONE
set CLK_GATE_EN 0

## ----------------
## Board
## ----------------

set BOARD "hidden"
# Only valid for board="DK-SI-AGF014E"; "enpirion" or "linear"
set BOARD_PWRMGT "linear"

#  IO48 DAUGHTER_CARD, available options such as "devkit_dc_oobe", "devkit_dc_nand", "devkit_dc_emmc"
set DAUGHTER_CARD "devkit_dc_oobe"

set FPGA_PERIPHERAL_EN 1

## ----------------
## OCM
## ----------------

set JTAG_OCM_EN 1
set OCM_DATAWIDTH 128
set OCM_MEMSIZE 262144.0

## ----------------
## HPS
## ----------------

# Option to enable Hard Processor System
set HPS_EN 1
# Option to enable H2F User Clock0 Output Port
set USER0_CLK_SRC_SELECT 0
set USER1_CLK_SRC_SELECT 0
set USER0_CLK_FREQ 500
set USER1_CLK_FREQ 500

# Option to enable HPS EMIF
set HPS_EMIF_EN 0

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
set RESET_WATCHDOG_EN 0

# Option to enable HPS Warm Reset
set RESET_HPS_WARM_EN 0

# Option to enable HPS-to-FPGA Cold Reset
set RESET_H2F_COLD_EN 0

# Option to select how the SDM handles the watchdog reset
set RESET_SDM_WATCHDOG_CFG 0

# Options to enable and set width of each AXI Bridge
set H2F_WIDTH 128
set F2H_WIDTH 64
set LWH2F_WIDTH 32
set F2S_DATA_WIDTH 256
set F2S_ADDRESS_WIDTH 32
set F2SDRAM_DATA_WIDTH 256
set F2SDRAM_ADDRESS_WIDTH 32
set H2F_F2H_LOOPBACK_EN 0
set LWH2F_F2H_LOOPBACK_EN 0
set F2H_ADDR_WIDTH 32
set H2F_ADDR_WIDTH 38
set LWH2F_ADDR_WIDTH 29
set F2H_CLK_SOURCE 0
set H2F_CLK_SOURCE 0
set LWH2F_CLK_SOURCE 0
set OCM_CLK_SOURCE 0
set SECURE_F2H_AXI_SLAVE 0
set HPS_PERI_IRQ_LOOPBACK_EN 0
set HPS_F2S_IRQ_EN 1

# setting to enable Cross Triggering
set CROSS_TRIGGER_EN 0
set HPS_STM_EN 0
