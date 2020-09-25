#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2017-2020 Intel Corporation.
#
#****************************************************************************
#
# This script generates the top level RTL for the GHRD
# to use this script, 
# example command to execute this script file
#   tclsh create_ghrd_top.tcl
#
# --- alternatively, input arguments could be passed in to select other design variant. 
#    hps_sdram  : input of memory device FBGA code to identify EMIF configuration for targeted memory. 
#                 D9RPL = "MT41K512M16TNA-107" DDR3 Dual Ranks at 800MHz,
#                 D9PZN = "MT41J256M16HA-093" DDR3 Single Rank at 1066MHz,
#                 D9RGX = "MT40A256M16HA-093E:A" DDR4 Single Rank at 1066MHz 
#    hps_sdram_ecc : enable ECC on HPS SDRAM controller
#                    1 = enable, or
#                    0 = disable
#    hps_sgmii  : enable hps emac routing to FPGA as SGMII Enet
#                 1 = enable, or 
#                 0 = disable
#    sgmii_count: number of SGMII interface
#                 1 = single SGMII, HPS EMAC1 will be used
#                 2 = dual SGMII, HPS EMAC1 and EMAC2 will be used
#    fpga_dp    : enable display port in FPGA 
#                 1 = enable, or 
#                 0 = disable
#    frame_buffer : enable frame buffer module for the display port in FPGA 
#                 1 = enable, or 
#                 0 = disable
#    fpga_pcie  : enable PCIe in FPGA 
#                 1 = enable, or 
#                 0 = disable
#    pcie_gen   : enable generation select for PCIe in FPGA
#                 1 = Gen1
#                 2 = Gen2
#                 3 = Gen3
#    pcie_count   number of lane in the PCIe Interface
#                 4 = 4 lanes
#                 8 = 8 lanes
#    boot_device: Select boot source between SDMMC, QSPI, NAND
#    fast_trace : enable trace x16 with FPGA IO
#                 1 = enable, or
#                 0 = disable
#    board_rev  : A = revision A board
#                 B = revision B board and beyond
#   qsys_pro    : determine if qsys_pro is select or not
#                1 = use qsys pro
#                0 = use qsys classic
#   pr_enable   : enable partial reconfiguration
#                1 = enable
#                0 = disable
#   freeze_ack_dly_enable   : enable delay with pio on freeze ack signals 
#                1 = enable
#                0 = disable
# example command to execute this script file
#   tclsh create_ghrd_qsys.tcl hps_sdram D9PZN
#
#****************************************************************************


source $::env(QUARTUS_ROOTDIR)/../ip/altera/common/hw_tcl_packages/altera_terp.tcl

#package require altera_terp

source ./design_config.tcl

proc show_cmd_args {} {
  global HPS_SDRAM_DEVICE
  global HPS_SDRAM_ECC_ENABLE
  global SGMII_ENABLE
  global SGMII_COUNT
  global DISP_PORT_ENABLE
  global PCIE_ENABLE
  global GEN_ENABLE
  global PCIE_COUNT
  global BOOT_SOURCE
  global FTRACE_ENABLE
  global ADD_FRAME_BUFFER
  global QSYS_NAME
  global BOARD_REV
  global QSYS_PRO_ENABLE
  global PARTIAL_RECONFIGURATION
  global FREEZE_ACK_DELAY_ENABLE
 
  foreach {name val} $::argv {
     puts "-> Accepted parameter: $name,  \tValue: $val"
     if {$name == "hps_sdram"} {
        set HPS_SDRAM_DEVICE $val
        #puts "$HPS_SDRAM_DEVICE is inserted"
     }
     if {$name == "hps_sdram_ecc"} {
        set HPS_SDRAM_ECC_ENABLE $val
        #puts "$HPS_SDRAM_ECC_ENABLE is inserted"
     }
     if {$name == "hps_sgmii"} {
        set SGMII_ENABLE $val
        #puts "$SGMII_ENABLE is inserted"
     }
     if {$name == "fpga_dp"} {
        set DISP_PORT_ENABLE $val
        #puts "$DISP_PORT_ENABLE is inserted"
     }
     if {$name == "frame_buffer"} {
      set ADD_FRAME_BUFFER $val
     }
     if {$name == "fpga_pcie"} {
        set PCIE_ENABLE $val
        #puts "$PCIE_ENABLE is inserted"
     }
     if {$name == "pcie_gen"} {
        set GEN_ENABLE $val
        #puts "$GEN_ENABLE is inserted"
     }
     if {$name == "pcie_count"} {
        set PCIE_COUNT $val
        #puts "$PCIE_COUNT is inserted"
     }
     if {$name == "boot_device"} {
        set BOOT_SOURCE $val
        #puts "$$BOOT_SOURCE is inserted"
     }
     if {$name == "fast_trace"} {
        set FTRACE_ENABLE $val
        #puts "$$FTRACE_ENABLE is inserted"
     }
     if {$name == "qsys_name"} {
        set QSYS_NAME $val
        #puts "$$QSYS_NAME is inserted"
     }
     if {$name == "board_rev"} {
        set BOARD_REV $val
        #puts "$$BOARD_REV is inserted"
     }
     if {$name == "sgmii_count"} {
        set SGMII_COUNT $val
        #puts "$$SGMII_COUNT is inserted"
     }
     if {$name == "qsys_pro"} {
        set QSYS_PRO_ENABLE $val
        #puts "$$QSYS_PRO_ENABLE is inserted"
     }
     if {$name == "pr_enable"} {
        set PARTIAL_RECONFIGURATION $val
        #puts "$$PARTIAL_RECONFIGURATION is inserted"
     }
     if {$name == "freeze_ack_dly_enable"} {
        set FREEZE_ACK_DELAY_ENABLE $val
        #puts "$$FREEZE_ACK_DELAY_ENABLE is inserted"
     }
  }

}
show_cmd_args


# path to the TERP template
set template_path "top_level_template.v.terp" 
# file handle for template
set template_fh [open $template_path] 
# template contents
set template   [read $template_fh] 
# we are done with the file so we should close it
close $template_fh 

# construct parameters value used in terp file
set param(SYS_TOP_NAME)           $SYS_TOP_NAME
set param(QSYS_NAME)              $QSYS_NAME
set param(HPS_SDRAM_DEVICE)       $HPS_SDRAM_DEVICE
set param(HPS_SDRAM_ECC_ENABLE)   $HPS_SDRAM_ECC_ENABLE
set param(DISP_PORT_ENABLE)       $DISP_PORT_ENABLE
set param(ADD_FRAME_BUFFER)       $ADD_FRAME_BUFFER
set param(SGMII_ENABLE)           $SGMII_ENABLE
set param(SGMII_COUNT)            $SGMII_COUNT
set param(PCIE_ENABLE)            $PCIE_ENABLE
set param(GEN_ENABLE)             $GEN_ENABLE
set param(PCIE_COUNT)             $PCIE_COUNT
set param(FTRACE_ENABLE)          $FTRACE_ENABLE
set param(BOOT_SOURCE)            $BOOT_SOURCE
set param(BOARD_REV)              $BOARD_REV
set param(QSYS_PRO_ENABLE)        $QSYS_PRO_ENABLE
set param(PARTIAL_RECONFIGURATION) $PARTIAL_RECONFIGURATION
set param(FREEZE_ACK_DELAY_ENABLE) $FREEZE_ACK_DELAY_ENABLE

set content [altera_terp $template param]
set fo [open "./${SYS_TOP_NAME}.v" "w"] 
puts $fo $content
close $fo

