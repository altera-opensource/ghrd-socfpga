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
#    fpga_pcie  : enable PCIe in FPGA 
#                 1 = enable, or 
#                 0 = disable
#
# example command to execute this script file
#   tclsh create_ghrd_qsys.tcl hps_sdram D9PZN
#
#****************************************************************************


source $::env(QUARTUS_ROOTDIR)/../ip/altera/common/hw_tcl_packages/altera_terp.tcl

#package require altera_terp

source ./design_config.tcl

proc show_cmd_args {} {
  global PCIE_ENABLE
 
  foreach {name val} $::argv {
     puts "-> Accepted parameter: $name,  \tValue: $val"
     if {$name == "fpga_pcie"} {
        set PCIE_ENABLE $val
        #puts "$PCIE_ENABLE is inserted"
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
# set param(SYS_TOP_NAME)           $SYS_TOP_NAME
# set param(QSYS_NAME)              $QSYS_NAME
set param(PCIE_ENABLE)            $PCIE_ENABLE


set content [altera_terp $template param]
set fo [open "./ghrd_top.v" "w"] 
puts $fo $content
close $fo

