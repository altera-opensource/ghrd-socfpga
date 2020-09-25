#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2017-2020 Intel Corporation.
#
#****************************************************************************
#
# This file host all the enabled HPS Daugther Card
#
#****************************************************************************

if {$daughter_card == "devkit_dc1"} {
set hps_usb0_en 1
set hps_emac0_rgmii_en 1
set hps_uart0_q3_en 1
set hps_i2c1_q3_en 1
set hps_sdmmc4b_q4_en 1
set hps_mdio0_q4_en 1
set hps_cm_q 4
set hps_cm_io 7
set hps_jtag_en 1
set hps_gpio1_en 1
set hps_gpio1_list "0 1 4 5 19 20 21"

} elseif {$daughter_card == "devkit_dc2"} {
set hps_sdmmc4b_q1_en 1
set hps_mdio0_q1_en 1
set hps_mdio2_q1_en 1
set hps_i2c_emac1_q1_en 1
set hps_emac0_rgmii_en 1
set hps_emac2_rgmii_en 1
set hps_spim1_q3_en 1
set hps_uart1_q3_en 1
set hps_cm_q 3
set hps_cm_io 5
set hps_jtag_en 1
set hps_gpio1_en 1
set hps_gpio1_list "5"

} elseif {$daughter_card == "devkit_dc3"} {
set hps_nand_q12_en 1
set hps_nand_16b_en 1
set hps_cm_q 2
set hps_cm_io 4
set hps_i2c1_q3_en 1
set hps_emac2_rgmii_en 1
set hps_uart0_q3_en 1
set hps_mdio2_q3_en 1
set hps_gpio1_en 1
set hps_gpio1_list "0 1 4 5 10 11"

} elseif {$daughter_card == "devkit_dc4"} {
set hps_cm_q 4
set hps_cm_io 3
set hps_uart1_q1_en 1
set hps_sdmmc4b_q1_en 1
set hps_mdio0_q1_en 1
set hps_emac0_rgmii_en 1
set hps_spim1_q3_en 1
set hps_i2c1_q3_en 1
set hps_trace_q34_en 1
set hps_trace_8b_en 1
set hps_jtag_en 1
set hps_gpio0_en 1
set hps_gpio0_list "8 9"
set hps_gpio1_en 1
set hps_gpio1_list "4 5 12 13"

} elseif {$daughter_card == "devkit_dc5"} {
set hps_sdmmc8b_q1_en 1
set hps_cm_q 2
set hps_cm_io 4
set hps_i2c1_q3_en 1
set hps_emac2_rgmii_en 1
set hps_uart0_q3_en 1
set hps_mdio2_q3_en 1
set hps_gpio1_en 1
set hps_gpio1_list "0 1 4 5 10 11"

} elseif {$daughter_card == "pe_dc1"} {
set hps_usb0_en 1
set hps_emac0_rgmii_en 1
# set hps_mdio2_q3_en 1   ##changed to mdio0 due to megawizard limitation, case:458946
set hps_mdio0_q3_en 1
set hps_uart0_q3_en 1
set hps_uart0_fc_en 1
set hps_i2c1_q3_en 1
set hps_trace_q34_en 1
set hps_cm_q 4
set hps_cm_io 4
set hps_gpio1_en 1
set hps_gpio1_list "4"

} elseif {$daughter_card == "pe_dc2"} {
set hps_spim0_q1_en 1
set hps_spim0_2ss_en 1
set hps_spis1_q1_en 1
set hps_usb1_en 1
set hps_uart0_q3_en 1
set hps_uart0_fc_en 1
set hps_uart1_q3_en 1
set hps_uart1_fc_en 1
set hps_i2c1_q4_en 1
# Temporary disable i2cemac due to case:458841
set hps_i2c_emac0_q4_en 1
set hps_i2c_emac1_q4_en 1
set hps_i2c_emac2_q4_en 1
set hps_cm_q 4
set hps_cm_io 4
set hps_gpio1_en 1
set hps_gpio1_list "8 14 16 17"

### Disable from support as latest PE spreadsheet no longer contain this Daughter card
#} elseif {$daughter_card == "pe_dc3"} {
#	set hps_uart0_q1_en 1
#	set hps_uart0_fc_en 1
#	set hps_mdio0_q1_en 1
#	set hps_mdio1_q1_en 1
#	set hps_mdio2_q1_en 1
#	set hps_emac0_rmii_en 1
#	set hps_emac1_rgmii_en 1
#	set hps_emac2_rmii_en 1
#	set hps_cm_q 4
#	set hps_cm_io 12
### tentatively disable osc_clk as hps_io_q4_12 cannot apply CM:

} elseif {$daughter_card == "pe_dc6"} {
### tentatively disable as NAND:RE_N conflicts with OSC_CLK
# set hps_nand_q12_en 1
set hps_cm_q 1
set hps_cm_io 4
set hps_gpio0_list "12 13 14 15 16 17 18 19 20 21 22 23"
### alternatively disable one GPIO12 to give way for OSC_CLK and enable NAND 8-bit
# set hps_gpio0_list "13 14 15 16 17 18 19 20 21 22 23"
# set hps_cm_q 2
# set hps_cm_io 1

set hps_gpio0_en 1
set hps_gpio1_en 1
set hps_gpio1_list "0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23"


### Disable from support as latest PE spreadsheet no longer contain this Daughter card
#} elseif {$daughter_card == "pe_dc7"} {
#	set hps_usb0_en 1
#	set hps_usb1_en 1
#	set hps_uart0_q3_en 1
#	set hps_uart0_fc_en 1
#	set hps_cm_q 4
#	set hps_cm_io 12
### tentatively disable osc_clk as hps_io_q4_12 cannot apply CM
#	set hps_gpio1_en 1
#	set hps_gpio1_list "4 5 6 7"
#	set hps_sdmmc8b_q1_en 1

} elseif {$daughter_card == "pe_dc9"} {
set hps_uart0_q1_en 1
set hps_uart0_fc_en 1
set hps_mdio0_q1_en 1
set hps_mdio1_q1_en 1
set hps_mdio2_q1_en 1
set hps_emac0_rgmii_en 1
set hps_emac1_rgmii_en 1
set hps_emac2_rmii_en 1
set hps_cm_q 4
set hps_cm_io 12
### tentatively disable osc_clk as hps_io_q4_12 cannot apply CM:

} elseif {$daughter_card == "pe_dc10"} {
set hps_trace_q12_en 1
set hps_trace_16b_en 1
set hps_cm_q 1
set hps_cm_io 4
set hps_gpio1_en 1
set hps_gpio1_list "4 5 6 7"
set hps_pll_out_en 1
set hps_io_custom "24 CM:PLL0 25 CM:PLL1 26 CM:PLL2 27 CM:PLL3"
### USB0 of this DC is disable as no complete buses established in DC	

} elseif {$daughter_card == "pe_dc11"} {
set hps_usb0_en 1
set hps_usb1_en 1
set hps_uart0_q3_en 1
set hps_uart0_fc_en 1
set hps_cm_q 4
set hps_cm_io 12
### tentatively disable osc_clk as hps_io_q4_12 cannot apply CM
set hps_gpio1_en 1
set hps_gpio1_list "4 5"
set hps_sdmmc8b_q4_en 1

} elseif {$daughter_card == "pe_dc12"} {
set hps_uart0_q1_en 1
set hps_uart0_fc_en 1
set hps_mdio0_q1_en 1
set hps_mdio1_q1_en 1
set hps_mdio2_q1_en 1
set hps_emac0_rmii_en 1
set hps_emac1_rgmii_en 1
set hps_emac2_rmii_en 1
set hps_cm_q 4
set hps_cm_io 12
### tentatively disable osc_clk as hps_io_q4_12 cannot apply CM:

} elseif {$daughter_card == "pe_dc13"} {
set hps_cm_q 4
set hps_cm_io 12
### tentatively disable osc_clk as hps_io_q4_12 cannot apply CM:
set hps_gpio0_en 1
set hps_gpio0_list "0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23"
set hps_gpio1_en 1
set hps_gpio1_list "0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22"

} elseif {$daughter_card == "pe_nand"} {
set hps_nand_q12_en 1
set hps_nand_16b_en 1
set hps_cm_q 2
set hps_cm_io 4

} elseif {$daughter_card == "pe_sdmmc"} {
set hps_i2c0_q3_en 1
set hps_sdmmc8b_q4_en 1
set hps_cm_q 4
set hps_cm_io 12
set hps_gpio0_en 1
set hps_gpio0_list "0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23"
set hps_gpio1_en 1
set hps_gpio1_list "0 1 4 5 6 7 8 9 10 11 22"

} else {
puts "Inserted daughter_card variant: $daughter_card NOT supported"
}

