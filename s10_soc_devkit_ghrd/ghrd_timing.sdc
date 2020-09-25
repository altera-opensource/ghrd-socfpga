#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2017-2020 Intel Corporation.
#
#****************************************************************************
#
# Sample SDC for S10 GHRD.
#
#****************************************************************************

set_time_format -unit ns -decimal_places 3

# 100MHz board input clock, 133.3333MHz for EMIF refclk
create_clock -name MAIN_CLOCK -period 10 [get_ports fpga_clk_100[0]]
create_clock -name EMIF_REF_CLOCK -period 7.5 [get_ports emif_hps_pll_ref_clk]
create_clock -name PCS_CLOCK -period 8 [get_ports enet_refclk]

set_false_path -from [get_ports {fpga_reset_n[0]}]
#set_input_delay -clock MAIN_CLOCK 1 [get_ports {fpga_reset_n[0]}]

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

set_max_skew -to [get_ports "emac1_mdc"] 2
set_max_skew -to [get_ports "emac1_mdio"] 2
set_false_path -from * -to [ get_ports emac1_phy_rst_n ]

set_false_path -from [get_ports {emac1_phy_irq}] -to *

set_max_skew -to [get_ports "emac2_mdc"] 2
set_max_skew -to [get_ports "emac2_mdio"] 2
set_false_path -from * -to [ get_ports emac2_phy_rst_n ]

set_false_path -from [get_ports {emac2_phy_irq}] -to *

set_false_path -from {soc_inst|src_prb_rst|*|sync_src_1_bit[2]} -to {soc_inst|rst_controller_*altera_reset_synchronizer_int_chain[1]}

set_false_path -from {soc_inst|rst_controller_*|altera_reset_synchronizer_int_chain_out} -to {soc_inst|rst_controller_*|altera_reset_synchronizer_int_chain[1]}
