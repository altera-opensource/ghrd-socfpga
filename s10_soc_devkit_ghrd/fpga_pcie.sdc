#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2017-2020 Intel Corporation.
#
#****************************************************************************
#
# Sample SDC for S10 GHRD. Targeting PCIE component.
#
#****************************************************************************

# Clock Group
# create_clock -name PCIE_REFCLK -period 10 [get_ports pcie_refclk_100]
derive_clock_uncertainty

set_false_path -from [ get_ports {pcie_hip_npor_pin_perst}]

set_false_path -from {*|pcie_s10|altera_pcie_s10_hip_avmm_bridge_inst|hip|*} -to {*|altera_avalon_pio_inst|d1_data_in[*]}
set_false_path -from {*|pcie_s10|altera_pcie_s10_hip_avmm_bridge_inst|hip|*} -to {*|altera_avalon_pio_inst|readdata[*]}

#temporary workaround to waive ISSP reset timing violations in PCIe system
#set_false_path -from {soc_inst|src_prb_rst|altera_in_system_sources_probes_inst|issp_impl|*|metastable_l2_reg[0]} -to {soc_inst|rst_controller_*|alt_rst_sync_*|altera_reset_synchronizer_int_chain[1]}
#set_false_path -from {soc_inst|src_prb_rst|altera_in_system_sources_probes_inst|issp_impl|*|metastable_l2_reg[0]} -to {soc_inst|pcie_0|pcie_s10|altera_pcie_s10_hip_avmm_bridge_inst|hip|altera_pcie_s10_hip_ast_pipen1b_inst|npor_sync_altera_pcie_s10_reset_delay_sync|sync|din_s1}
#set_false_path -from {soc_inst|src_prb_rst|altera_in_system_sources_probes_inst|issp_impl|*|metastable_l2_reg[0]} -to {soc_inst|pcie_0|pcie_s10|altera_pcie_s10_hip_avmm_bridge_inst|hip|altera_pcie_s10_hip_ast_pipen1b_inst|npor_sync_altera_pcie_s10_reset_delay_sync|sync|dreg[1]}
#set_false_path -from {soc_inst|src_prb_rst|altera_in_system_sources_probes_inst|issp_impl|*|metastable_l2_reg[0]} -to {soc_inst|pcie_0|pcie_s10|altera_pcie_s10_hip_avmm_bridge_inst|hip|altera_pcie_s10_hip_ast_pipen1b_inst|npor_sync_altera_pcie_s10_reset_delay_sync|sync|dreg[0]}
#set_clock_groups -asynchronous -group [get_clocks {MAIN_CLOCK}] -group [get_clocks {soc_inst|*|phy_g3x8|xcvr_hip_native|ch0}

set_false_path -from {soc_inst|*axi_bridge_for_acp_128_inst|csr_*} -to {soc_inst|s10_hps|altera_stratix10_hps_inst|*}