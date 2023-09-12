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
create_clock -name EMIF_REF_CLOCK -period 6.0 [get_ports emif_hps_emif_ref_clk_0_clk]

set_false_path -from [get_ports {fpga_reset_n[0]}]

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


