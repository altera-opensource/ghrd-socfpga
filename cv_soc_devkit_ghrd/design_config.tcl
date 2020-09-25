#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2013-2020 Intel Corporation.
#
#****************************************************************************
# USAGE OF THIS FILE 
# ------------------
# Parameters set in this file are served as default value to configure GHRD for generation.
# Higher level sripts that call upon create_ghrd_*.tcl can over-write value of parameters 
# by arguments to be passed in during execution of script.
#
#****************************************************************************
set QSYS_NAME soc_system
set QUARTUS_NAME soc_system
set SYS_TOP_NAME ghrd_top
set DEVICE_FAMILY "CYCLONEV"
set FPGA_DEVICE 5CSXFC6D6F31C6 

#                                               #
#################################################

#################################################
#     GHRD features enable                      #

# existance of PCIe
set PCIE_ENABLE 0


