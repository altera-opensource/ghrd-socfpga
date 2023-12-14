#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2021 Intel Corporation.
#
#****************************************************************************
#
# This file host all the enabled HPS Daugther Card
#
#****************************************************************************
#
#
# Following are HPS IO quadrants feature for individual peripherals
# Variable naming convention: hps_<peripheral>_<quadrant>_en
# Set default of veriables disable

 # -- the quadrant # of CM:HPS_OSC_CLK selected
 # -- the IO # within a quadrant for CM:HPS_OSC_CLK
set hps_cm_q                 0 
set hps_cm_io                0 
set hps_pll_clk0_en          0
set hps_pll_clk1_en          0
set hps_pll_clk2_en          0
set hps_pll_clk3_en          0
set hps_jtag_en              0
set hps_spim0_q1_en          0
set hps_spim0_q4_en          0
set hps_spim1_q1_en          0
set hps_spim1_q2_en          0
set hps_spim1_q3_en          0
set hps_spis0_q1_en          0
set hps_spis0_q2_en          0
set hps_spis0_q3_en          0
set hps_spis1_q1_en          0
set hps_spis1_q3_en          0
set hps_spis1_q4_en          0
set hps_uart0_q1_en          0
set hps_uart0_q2_en          0
set hps_uart0_q3_en          0
set hps_uart1_q1_en          0
set hps_uart1_q3_en          0
set hps_i2c0_q1_en           0
set hps_i2c0_q2_en           0
set hps_i2c0_q3_en           0
set hps_i2c1_q1_en           0
set hps_i2c1_q2_en           0
set hps_i2c1_q3_en           0
set hps_i2c1_q4_en           0
set hps_i2c_emac0_q1_en      0
set hps_i2c_emac0_q3_en      0
set hps_i2c_emac0_q4_en      0
set hps_i2c_emac1_q1_en      0
set hps_i2c_emac1_q4_en      0
set hps_i2c_emac2_q1_en      0
set hps_i2c_emac2_q3_en      0
set hps_i2c_emac2_q4_en      0
set hps_pps_emac0_q1_en      0
set hps_pps_emac0_q3_en      0
set hps_pps_emac1_q1_en      0
set hps_pps_emac2_q1_en      0
set hps_pps_emac2_q3_en      0
set hps_trig_emac0_q1_en     0
set hps_trig_emac0_q3_en     0
set hps_trig_emac1_q1_en     0
set hps_trig_emac2_q1_en     0
set hps_trig_emac2_q3_en     0
set hps_emac0_q2_en          0
set hps_emac1_q3_en          0
set hps_emac2_q4_en          0
set hps_mdio0_q1_en          0
set hps_mdio0_q3_en          0
set hps_mdio0_q4_en          0
set hps_mdio1_q1_en          0
set hps_mdio1_q4_en          0
set hps_mdio2_q3_en          0
set hps_i3c0_q1_en           0
set hps_i3c0_q2_en           0
set hps_i3c0_q3_en           0
set hps_i3c0_q4_en           0
set hps_i3c1_q1_en           0
set hps_i3c1_q2_en           0
set hps_i3c1_q3_en           0
set hps_i3c1_q4_en           0
set hps_nand_q12_en          0
set hps_nand_q34_en          0
set hps_emmc_q34_en          0
set hps_sdmmc4b_q1_en        0
set hps_sdmmc8b_q1_en        0
set hps_sdmmc_wp_q1_en       0
set hps_sdmmc_pupd_q2_en     0
set hps_sdmmc_pwr_q2_en      0
set hps_sdmmc_dstrb_q2_en    0
set hps_sdmmc4b_q3_en        0
set hps_sdmmc_wp_q3_en       0
set hps_sdmmc_pupd_q4_en     0
set hps_sdmmc_pwr_q4_en      0
set hps_sdmmc_dstrb_q4_en    0
set hps_usb0_en              0
set hps_usb1_en              0
set hps_trace_en             0
set hps_gpio0_en             0
set hps_gpio0_list ""
set hps_gpio1_en             0
set hps_gpio1_list ""


if {$daughter_card == "devkit_dc_oobe"} {
set hps_cm_q 1
set hps_cm_io 11
set hps_gpio0_en 1
set hps_gpio0_list "0 1 11"
set hps_uart0_q1_en 1
set hps_emac2_q1_en 1
set hps_mdio2_q1_en 1
#temporary turn off I3C for first compilation succeed
set hps_i3c1_q1_en 1
set hps_usb1_en 1
#temporary turn off sdmmc for first compilation succeed
set hps_sdmmc4b_q3_en 1
set hps_gpio1_en 1
set hps_gpio1_list "3"
set hps_sdmmc_wp_q3_en 1
set hps_jtag_en 1
set hps_emac2_rgmii_en 1

} elseif {$daughter_card == "devkit_dc_nand" || $daughter_card == "devkit_dc_emmc"  } {
if {$daughter_card == "devkit_dc_nand"} {
set hps_emac0_q1_en 1
set hps_uart0_q1_en 1
set hps_i2c0_q1_en 1
set hps_gpio0_en 1
set hps_gpio0_list "6 7"
set hps_i3c1_q1_en 1
set hps_mdio0_q1_en 1
set hps_emac0_rgmii_en 1
set hps_nand_q34_en 1
set hps_gpio1_en 1
set hps_gpio1_list "16 19"
set hps_cm_q 4
set hps_cm_io 6
set hps_spis1_q4_en 1
} elseif {$daughter_card == "devkit_dc_emmc"} {
set hps_emac0_q1_en 1
set hps_uart0_q1_en 1
set hps_i2c0_q1_en 1
set hps_gpio0_en 1
set hps_gpio0_list "6 7"
set hps_i3c1_q1_en 1
set hps_mdio0_q1_en 1
set hps_emac0_rgmii_en 1
set hps_sdmmc4b_q3_en 1
set hps_sdmmc12b_q3_alt_en 1
set hps_sdmmc_wp_q3_en 1
set hps_sdmmc_pupd_q4_en 1
set hps_sdmmc_pwr_q4_en 1
set hps_sdmmc_dstrb_q4_en 1
set hps_gpio1_en 1
set hps_gpio1_list "16 19"
set hps_cm_q 4
set hps_cm_io 6
set hps_spis1_q4_en 1
}

} elseif {$daughter_card == "debug2"} {
set hps_emac0_q1_en 1
set hps_uart0_q1_en 1
set hps_spim0_q1_en 1
set hps_i3c1_q1_en 1
set hps_mdio0_q1_en 1
set hps_emac0_rgmii_en 1
set hps_sdmmc4b_q3_en 1
set hps_gpio1_en 1
set hps_gpio1_list "3 4"
set hps_jtag_en 1
set hps_sdmmc_pupd_q4_en 1
set hps_cm_q 4
set hps_cm_io 2
set hps_trace_q34_en 1
set hps_trace_8b_en 1

} elseif {$daughter_card == "tsn_aic0"} {
set hps_emac0_q1_en 1
set hps_uart0_q1_en 1
set hps_emac2_q1_en 1
set hps_mdio2_q1_en 1
set hps_cm_q 1
set hps_cm_io 10
set hps_mdio0_q1_en 1
set hps_emac0_rgmii_en 1
set hps_sdmmc4b_q3_en 1
set hps_sdmmc_wp_q3_en 1
#set hps_sdmmc4b_q1_sel_en 1
#set hps_sdmmc4b_q1_alt_en 1
set hps_jtag_en 1
set hps_emac2_rgmii_en 1

} elseif {$daughter_card == "tsn_aic2"} {
set hps_emac0_q1_en 1
set hps_emac1_q1_en 1
set hps_emac2_q1_en 1
set hps_mdio2_q1_en 1
set hps_mdio1_q1_en 1
set hps_mdio0_q1_en 1
set hps_emac0_rgmii_en 1
set hps_emac1_rgmii_en 1
set hps_emac2_rgmii_en 1

} elseif {$daughter_card == "none"} {
puts "Disable all HPS IO48 IO"
set hps_io_off 1

} else {
puts "Inserted daughter_card variant: $daughter_card NOT supported"
}

