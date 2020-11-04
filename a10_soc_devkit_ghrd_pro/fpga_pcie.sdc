#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2015-2020 Intel Corporation.
#
#****************************************************************************
#
# Sample SDC for A10 GHRD. Targeting PCIE component.
#
#****************************************************************************

# Clock Group
# create_clock -name PCIE_REFCLK -period 10 [get_ports pcie_refclk_100]
derive_pll_clocks -create_base_clocks
derive_clock_uncertainty

set_false_path -from [ get_ports {pcie_a10_hip_npor_pin_perst}]
set_clock_groups -asynchronous -group [get_clocks {MAIN_CLOCK}] -group [get_clocks {soc_inst|pcie_0|*|wys~CORE_CLK_OUT}]

#to false path the reset output into the reset synchronizer input port due to new reset requirement(synchronous assert & de-assertion) of mSGDMA
set_false_path -from {soc_inst|rst_controller|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out} -to [get_registers {soc_inst|pcie_0|rst_controller_*|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain[1]}]
set_false_path -from {soc_inst|*|g_rst_sync.syncrstn_avmm_sriov.app_rstn_altpcie_reset_delay_sync_altpcie_a10_hip_hwtcl|sync_rst[0]} -to [get_registers {soc_inst|pcie_0|rst_controller_*|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain[1]}]