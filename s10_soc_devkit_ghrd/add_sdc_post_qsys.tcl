#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2017-2020 Intel Corporation.
#
#****************************************************************************
#
# This script generates the Partial Reconfiguration Revision for the PR GHRD.
# To execute this script using quartus_sh for generating PR revision QSF accordingly
#   quartus_sh --script=add_sdc_post_qsys.tcl -projectname $(QUARTUS_BASE) -revision $(QUARTUS_BASE_REVISION) -hps_enable_sgmii $(HPS_ENABLE_SGMII) -hps_enable_10gbe $(HPS_ENABLE_10GbE)
#
#****************************************************************************

package require cmdline

set options {\
    { "projectname.arg" "" "Project name" } \
    { "hps_enable_sgmii.arg" "" "HPS MGE ENABLE" } \
    { "hps_enable_10gbe.arg" "" "HPS MGE 10GbE 1588 ENABLE" }
}
array set opts [::cmdline::getoptions quartus(args) $options]

project_open $opts(projectname) -current_revision

if {$opts(hps_enable_sgmii) == 1} {
   set_global_assignment -name SDC_FILE fpga_mge.sdc
}

if {$opts(hps_enable_10gbe) == 1} {
   set_global_assignment -name SDC_FILE fpga_mge_10g.sdc
}
project_close