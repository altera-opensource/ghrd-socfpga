#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2021-2021 Intel Corporation.
#
#****************************************************************************
#
# Sample SDC for Agilex HPS SGMII GHRD.
#
#****************************************************************************

set_false_path -from * -to [get_keepers {*|sgmii_debug_status_pio|altera_avalon_pio_inst|d1_data_in[*]}]
set_false_path -from * -to [get_keepers {*|sgmii_debug_status_pio|altera_avalon_pio_inst|readdata[*]}]

set_clock_groups -asynchronous -group [get_clocks {PCS_CLOCK}] -group [get_clocks {hps_emac1_gtx_clk}]
set_false_path -from [get_clocks {PCS_CLOCK}] -to [get_registers "soc_inst|*|altera_gmii_to_sgmii_adapter_inst|u_txbuffer|wr_data_flp\[*\]"]
set_false_path -fall_from [get_clocks {hps_emac1_gtx_clk}] -to [get_registers "soc_inst|*|altera_gmii_to_sgmii_adapter_inst|u_txbuffer|wr_data_flp\[*\]"]

set_net_delay -from [get_pins -compatibility_mode "*subsys_sgmii_emac*\|u_pcs_tx_clk_gated|en_flp|q"] -to [get_pins -compatibility_mode "*subsys_sgmii_emac*\|clk_gated\|combout"] -min 0.9

