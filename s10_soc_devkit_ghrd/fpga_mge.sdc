#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2020 Intel Corporation.
#
#****************************************************************************
#
# Sample SDC for S10 GHRD. Targeting MGE component.
#
#****************************************************************************

#False path for PIO
set_false_path -from {*|alt_mge_phy_inst|mge_pcs|GMII_PCS.gmii_pcs|*} -to {*|altera_avalon_pio_inst|d1_data_in[*]}
set_false_path -from {*|alt_mge_phy_inst|mge_pcs|GMII_PCS.gmii_pcs|*} -to {*|altera_avalon_pio_inst|readdata[*]}
set_false_path -from {*|altera_xcvr_reset_control_s10_inst|*} -to {*|altera_avalon_pio_inst|d1_data_in[*]}
set_false_path -from {*|altera_xcvr_reset_control_s10_inst|*} -to {*|altera_avalon_pio_inst|readdata[*]}
set_false_path -from {*|mge_rcfg_inst|mge_rcfg_fsm_i|status[*]} -to {*|altera_avalon_pio_inst|d1_data_in[*]}
set_false_path -from {*|mge_rcfg_inst|mge_rcfg_fsm_i|status[*]} -to {*|altera_avalon_pio_inst|readdata[*]}

##Remove clock related to MGE 2.5Gbps mode
#remove_clock [get_clocks {*|alt_mge_phy_inst|profile1|*}] 

set_clock_groups -exclusive -group [get_clocks {*|enet_iopll_0|*outclk0}] -group [get_clocks {*|enet_iopll_0|*outclk1}] -group [get_clocks {*|enet_iopll_0|*outclk2}] -group [get_clocks {hps_emac*_gtx_clk}]

#False path as tx_d, tx_en, tx_err is clocked with posedge of hps_emac*_gtx_clk for HPS EMAC Hard IP
set_false_path -fall_from [get_clocks {hps_emac*_gtx_clk}] -to {*|u_hps_to_mge_gmii_adapter_core|mac_tx*_d*}