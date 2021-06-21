#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2021-2021 Intel Corporation.
#
#****************************************************************************
#
# This script generates the Partial Reconfiguration Revision for the PR GHRD.
# To execute this script using quartus_sh for generating PR revision QSF accordingly
#   quartus_sh --script=add_sdc_post_qsys.tcl -projectname $(QUARTUS_BASE) -revision $(QUARTUS_BASE_REVISION) -hps_enable_sgmii $(HPS_ENABLE_SGMII)
#
#****************************************************************************

package require cmdline

set options {\
    { "projectname.arg" "" "Project name" } \
    { "hps_enable_sgmii.arg" "" "HPS SGMII ENABLE" }
}
array set opts [::cmdline::getoptions quartus(args) $options]

project_open $opts(projectname) -current_revision

if {$opts(hps_enable_sgmii) == 1} {
   set_global_assignment -name SDC_FILE sgmii_timing.sdc
}
project_close