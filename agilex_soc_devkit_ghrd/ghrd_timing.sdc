#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2020 Intel Corporation.
#
#****************************************************************************
#
# Sample SDC for Agilex GHRD.
#
#****************************************************************************

set_time_format -unit ns -decimal_places 3

# 100MHz board input clock, 133.3333MHz for EMIF refclk
create_clock -name MAIN_CLOCK -period 10 [get_ports fpga_clk_100[0]]
create_clock -name EMIF_REF_CLOCK -period 10 [get_ports emif_hps_pll_ref_clk]
create_clock -name PCS_CLOCK -period 8 [get_ports enet_refclk]

## This is required as the HPS SDC is not working for hps_user_clk constraints. HSDES: 1507301642
#create_clock -name hps_user_clk -period 2.5 [get_pins {soc_inst|agilex_hps|intel_agilex_hps_inst|fpga_interfaces|hps_inst|s2f_module|s2f_user_clk1_hio}]

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
