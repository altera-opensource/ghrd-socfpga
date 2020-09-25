#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2016-2020 Intel Corporation.
#
#****************************************************************************
#
# Sample SDC for CV GHRD. Targeting PCIE component.
#
#****************************************************************************
#create_clock -period "125 MHz" -name {coreclk} {*coreclk*}
# False path for reset inputs
set_false_path -from [get_ports pcie_npor_pin_perst] -to *
set_false_path -from [get_ports pcie_npor_npor] -to *
#False path for reset output
set_false_path -from * -to [get_ports pcie_perstn_out]
set_output_delay -clock {fpga_clk_50} -add_delay 10 [get_ports pcie_perstn_out]
############################################################################
# derive_pll_clock is used to calculate all clock derived from PCIe refclk
#  the derive_pll_clocks and derive clock_uncertainty should only
# be applied once across all of the SDC files used in a project
create_clock -period "100MHz" -name {refclk_pci_express} {*refclk_*}
derive_pll_clocks -create_base_clocks
derive_clock_uncertainty
##############################################################################
# PHY IP reconfig controller constraints
# Set reconfig_xcvr clock
# this line will likely need to be modified to match the actual clock pin name
# used for this clock, and also changed to have the correct period set for the actually used clock
create_clock -period "125 MHz" -name {reconfig_xcvr_clk} {*reconfig_xcvr_clk*}

######################################################################
# HIP Soft reset controller SDC constraints
set_false_path -to   [get_registers *altpcie_rs_serdes|fifo_err_sync_r[0]]
set_false_path -from [get_registers *sv_xcvr_pipe_native*] -to [get_registers *altpcie_rs_serdes|*]

# HIP testin pins SDC constraints
set_false_path -from [get_pins -compatibility_mode *hip_ctrl*]
