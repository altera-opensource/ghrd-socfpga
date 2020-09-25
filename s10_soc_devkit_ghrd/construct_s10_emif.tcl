#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2017-2020 Intel Corporation.
#
#****************************************************************************
#
# This file contains S10 HPS EMIF configuration and export of signals/ports
# Tentatively, planned support to S10 SoC Devkit and S10 PE board revC
# DDR4 is currently planned for both boards stated above, DDR3 is also supported on the devkit.
# This file will be source by GHRD construct_hps.tcl

#****************************************************************************
source ./utils.tcl

if {$hps_emif_en == 1} {
set total_hps_emif_width $hps_emif_width
if {$hps_emif_ecc_en} {
   incr total_hps_emif_width 8
}
}
if {$fpga_emif_en == 1} {
set total_fpga_emif_width $fpga_emif_width
if {$fpga_emif_ecc_en} {
   incr total_fpga_emif_width 8
}
}

set emif_configuration_file "./board/emif_configuration_${board}.tcl"
if {[file exist $emif_configuration_file]} {
    source $emif_configuration_file
} else {
    error "$emif_configuration_file not exist!! Please make sure the board settings files are included in folder ./board/"
}

