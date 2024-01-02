#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2021 Intel Corporation.
#
#****************************************************************************
#
# Sample SDC for Agilex GHRD.
#
#****************************************************************************

set_time_format -unit ns -decimal_places 3

# 100MHz board input clock, 133.3333MHz for EMIF refclk
create_clock -name MAIN_CLOCK -period 10 [get_ports fpga_clk_100]
create_clock -name EMIF_REF_CLOCK -period 8.0 [get_ports emif_hps_emif_ref_clk_0_clk]

set_false_path -from [get_ports {fpga_reset_n}]

# sourcing JTAG related SDC
source ./jtag.sdc

# FPGA IO port constraints
set_false_path -from [get_ports {fpga_button_pio[0]}] -to *
set_false_path -from [get_ports {fpga_button_pio[1]}] -to *
set_false_path -from [get_ports {fpga_button_pio[2]}] -to *
set_false_path -from [get_ports {fpga_button_pio[3]}] -to *
set_false_path -from [get_ports {fpga_dipsw_pio[0]}] -to *
set_false_path -from [get_ports {fpga_dipsw_pio[1]}] -to *
set_false_path -from [get_ports {fpga_dipsw_pio[2]}] -to *
set_false_path -from [get_ports {fpga_dipsw_pio[3]}] -to *
set_false_path -from [get_ports {fpga_led_pio[0]}] -to *
set_false_path -from [get_ports {fpga_led_pio[1]}] -to *
set_false_path -from [get_ports {fpga_led_pio[2]}] -to *
set_false_path -from [get_ports {fpga_led_pio[3]}] -to *
set_false_path -from * -to [get_ports {fpga_led_pio[0]}]
set_false_path -from * -to [get_ports {fpga_led_pio[1]}]
set_false_path -from * -to [get_ports {fpga_led_pio[2]}]
set_false_path -from * -to [get_ports {fpga_led_pio[3]}]
 
# False Path between debounced and reset synchronizer
set_false_path -from fpga_reset_n_debounced -to {soc_inst|rst_controller_*|altera_reset_synchronizer_int_chain[1]}


create_generated_clock -name emac0_phy_txclk_o_hio_from_i2_5 -master_clock [get_clocks 2_5m_3mux1] -source [get_pins {soc_inst|subsys_hps|agilex_hps|intel_agilex_5_soc_inst|sm_hps|sundancemesa_hps_inst|emac0_phy_txclk_i}] [get_pins {soc_inst|subsys_hps|agilex_hps|intel_agilex_5_soc_inst|sm_hps|sundancemesa_hps_inst|emac0_phy_txclk_o_hio}] -add
create_generated_clock -name emac0_phy_txclk_o_hio_from_i25  -master_clock [get_clocks 25m_3mux1]  -source [get_pins {soc_inst|subsys_hps|agilex_hps|intel_agilex_5_soc_inst|sm_hps|sundancemesa_hps_inst|emac0_phy_txclk_i}] [get_pins {soc_inst|subsys_hps|agilex_hps|intel_agilex_5_soc_inst|sm_hps|sundancemesa_hps_inst|emac0_phy_txclk_o_hio}] -add
create_generated_clock -name emac0_phy_txclk_o_hio_from_i125 -source [get_registers {soc_inst|subsys_hps|agilex_hps|intel_agilex_5_soc_inst|sm_hps|sundancemesa_hps_inst~emac0_rgmii_txclk_cm.reg}] [get_pins {soc_inst|subsys_hps|agilex_hps|intel_agilex_5_soc_inst|sm_hps|sundancemesa_hps_inst|emac0_phy_txclk_o_hio}] -add
set_clock_groups -logically_exclusive -group emac0_phy_txclk_o_hio_from_i2_5 -group emac0_phy_txclk_o_hio_from_i25 -group emac0_phy_txclk_o_hio_from_i125

set_clock_groups -logically_exclusive -group [ get_clocks emac0_phy_txclk_o_hio_from_i125 ] -group [ get_clocks 250m_3mux1] -group [ get_clocks 25m_3mux1] -group [ get_clocks 2_5m_3mux1]
set_clock_groups -logically_exclusive -group [ get_clocks emac0_phy_txclk_o_hio_from_i25 ] -group [ get_clocks 250m_3mux1] -group [ get_clocks 2_5m_3mux1] -group [ get_clocks 25m_3mux1]
set_clock_groups -logically_exclusive -group [ get_clocks emac0_phy_txclk_o_hio_from_i2_5 ] -group [ get_clocks 250m_3mux1] -group [ get_clocks 25m_3mux1] -group [ get_clocks 2_5m_3mux1]

set_false_path -from * -to [get_keepers -no_duplicates {soc_inst|subsys_fpga_rgmii|intel_gmii_to_rgmii_converter_0|intel_gmii_to_rgmii_converter_inst|u_intel_gmii_to_rgmii_adapter_core|u_rx_clk_reset_even_sync|din_sync_2}]
set_false_path -from * -to [get_keepers -no_duplicates {soc_inst|subsys_fpga_rgmii|intel_gmii_to_rgmii_converter_0|intel_gmii_to_rgmii_converter_inst|u_intel_gmii_to_rgmii_adapter_core|u_rx_clk_reset_even_sync|din_sync_1}]

#set_false_path -from [get_keepers -no_duplicates {soc_inst|subsys_fpga_rgmii|intel_gmii_to_rgmii_converter_0|intel_gmii_to_rgmii_converter_inst|rst_controller|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out}] -to [get_keepers -no_duplicates {soc_inst|subsys_fpga_rgmii|intel_gmii_to_rgmii_converter_0|intel_gmii_to_rgmii_converter_inst|u_intel_gmii_to_rgmii_adapter_core|u_rx_clk_reset_even_sync|din_sync_2}]
#set_false_path -from [get_keepers -no_duplicates {soc_inst|subsys_fpga_rgmii|intel_gmii_to_rgmii_converter_0|intel_gmii_to_rgmii_converter_inst|rst_controller|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out}] -to [get_keepers -no_duplicates {soc_inst|subsys_fpga_rgmii|intel_gmii_to_rgmii_converter_0|intel_gmii_to_rgmii_converter_inst|u_intel_gmii_to_rgmii_adapter_core|u_rx_clk_reset_even_sync|din_sync_1}]