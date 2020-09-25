#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2015-2020 Intel Corporation.
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
set QUARTUS_NAME ghrd_10as066n2
set SYS_TOP_NAME ghrd_a10_top
set DEVICE_FAMILY "Arria 10"
set FPGA_DEVICE 10AS066N3F40E2SG

#################################################
#    GHRD to support both revA and revB devkit  #

# Setting to indicate if generating GHRD for revA, revB or revC board
set BOARD_REV "C"
#                                               #
#################################################

#Option to indicate using Qsys Pro or Qsys Classic
set QSYS_PRO 1

#################################################
#     GHRD features enable                      #

# memory chip device determine speedbin, timing parameters, rank choice selection in EMIF configuration, 
#  "MT41K512M16TNA-107"=D9RPL ,   -- DDR3 dual ranks at 800MHz
#  "MT41J256M16HA-093"=D9PZN ,    -- DDR3 single rank at 1066MHz
#  "MT40A256M16HA-093E:A"=D9RGX   -- DDR4 single rank at 1066MHz
#  "MT40A512M16JY-075E:B"=D9TNZ   -- DDR4 single rank at 1066MHz
set HPS_SDRAM_DEVICE D9RGX

# setting to enable ECC of HPS SDRAM
set HPS_SDRAM_ECC_ENABLE 1

# ARM boot device selection
#  choice of "SDMMC", "QSPI", "NAND" or "FPGA"
set BOOT_SOURCE SDMMC

# setting to enable Cross Triggering
set CROSS_TRIGGER_ENABLE 0

# setting to enable Fast Trace x32 routed via FPGA, Fast Trace and Early Trace are exclusively exist
set FTRACE_ENABLE 0

# enable hps early io release in result to splitted or combined RBF conversion
set EARLY_IO_RELEASE 0

# setting to enable SGMII Ethernet port(s) in HPS, SGMII Enet and Early Trace are exclusively exist in revA board
set SGMII_ENABLE 0

# setting to enable Display Port 
set DISP_PORT_ENABLE 0

# existance of PCIe
set PCIE_ENABLE 0

# enable partial reconfiguration with freeze controller & bridge IP, pr_freeze_region instatantiation
set PARTIAL_RECONFIGURATION 0

#Option to enable Niosii soft Processor instead of HPS
set NIOSII_ENABLE 0

#Option to enable MMU from the Niosii soft Processor 
set NIOSII_MMU_ENABLE 1

#Option to enable TSE soft MAC & PCS IP
set TSE_ENABLE 0
#                                  #
####################################

####################################
#   System based IP configuration  #

#   Generic  #
# scratch pad onchip memory data width
set OCM_WIDTH 8

set F2SDRAM_COUNT 0
#                                  #
####################################
#    Override Boot Selection       #
# "0:RESERVED" 
# "1:FPGA" 
# "2:NAND Flash (1.8v)" 
# "3:NAND Flash (3.0v)" 
# "4:SD/MMC External Transceiver (1.8v)" 
# "5:SD/MMC Internal Transceiver (3.0v)" 
# "6:Quad SPI Flash (1.8v)" 
# "7:Quad SPI Flash (3.0v)"
set BSEL_EN 0
set BSEL 0

########################
# Add SPIM0 to the FPGA. This is useful for testing
# the SPIM IP on the A10 dev kit in loopback mode
# since SPIM1 is connected to the Max V.
# SPIM1 will not be affected by this change.
# 1 is enabled
# 0 is disabled
set SPIM0_EN 0

##### to be added
# OCM_SIZE
# FPGA_SDRAM_DEVICE
# FPGA_SDRAM_ECC_ENABLE

##   HPS EMAC SGMII  ##
# This is a workaround for CMU PLL pending fix, default should use CMU PLL
set USE_ATX_PLL 0
set USE_CMU_PLL 0

#Option to set number of HPS EMAC SGMII ports
set SGMII_COUNT 2

##   Display Port  ##
# For hw testing, the frame buffer will be disabled for Display Port
set ADD_FRAME_BUFFER 1

# #Option to configure the actual coordinates as well as width, height for reserved LogicLock Region when Display Port enabled together with PR
# set PR_X_ORIGIN 8
# set PR_Y_ORIGIN 115
# set PR_WIDTH 44
# set PR_HEIGHT 49

##   PCIe  ##
#Option for selecting generation in PCIe (Gen2 or Gen3)
set GEN_ENABLE 2

#Option for enable lane in PCIe (x4 or x8, x8 currently supported for Gen2 only)
set PCIE_COUNT 8

##   Partial Reconfiguration  ##
#Option to generate persona PR subsystem Qsys
set PR_PERSONA 0

#Option to set number of PR Regions
set PR_REGION_COUNT 1

#Option to generate PR design with acknowledgement port delayed
set FREEZE_ACK_DELAY_ENABLE 0

# enable partial reconfiguration with Display Port, Mixer Subsystem as pr_freeze_region instatantiation
set PARTIAL_RECONFIGURATION_DISP_PORT_MIX_ENABLE 0

#Option to configure the actual coordinates as well as width, height for reserved LogicLock Region
set PR_X_ORIGIN 3
set PR_Y_ORIGIN 15
set PR_WIDTH 140
set PR_HEIGHT 75

# Enable the PR IP core in the FPGA design
set PARTIAL_RECONFIGURATION_CORE_IP 0

# Enable MSGDMA between HPS and on-chip ram in FPGA
set FPGA_OCM_MSGDMA 0
##   TSE soft MAC & PCS ##

#Option for enable prefetcher module in mSGDMA
set DMA_PREFETCH_ENABLE 1

#Other options: MAC_PCS, PCS_ONLY or MAC_ONLY
set TSE_VARIANT "MAC_PCS" 
#Other options: MII_GMII or RGMII
set TSE_INTERFACE "MII_GMII"
set MDIO_ENABLE 1
#set transceiver type: GXB or NONE
set TRANSCEIVER_TYPE "GXB"
#set enable transceiver dynamic reconfiguration
set RECONFIGURATION_ENABLE 0
#set 50 for 125MHz or 40 for 100MHz MAC control clock
set MDIO_CLK_DIVIDER 50
