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

if {$daughter_card == "devkit_dc_oobe"} {
set hps_cm_q 1
set hps_cm_io 1
set hps_gpio0_en 1
set hps_gpio0_list "1 10 11"
set hps_uart0_q1_en 1
set hps_emac2_q1_en 1
set hps_mdio2_q1_en 1
#temporary turn off I3C for first compilation succeed
set hps_i3c1_q1_en 0
set hps_usb1_en 1
#temporary turn off sdmmc for first compilation succeed
set hps_sdmmc4b_q3_en 0
set hps_gpio1_en 1
set hps_gpio1_list "3 4"
#temporary turn off sdmmc for first compilation succeed
set hps_sdmmc8b_q3_alt_en 0
set hps_jtag_en 1
set hps_emac2_rgmii_en 1

} elseif {$daughter_card == "devkit_dc_nand"} {
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
set hps_sdmmc8b_q3_alt_en 1
set hps_jtag_en 1
set hps_sdmmc_pupd_q4_en 1
set hps_cm_q 4
set hps_cm_io 2
set hps_trace_q34_en 1
set hps_trace_8b_en 1

} elseif {$daughter_card == "tsn_phy_aic0"} {
set hps_emac0_q1_en 1
set hps_uart0_q1_en 1
set hps_emac2_q1_en 1
set hps_mdio2_q1_en 1
set hps_cm_q 1
set hps_cm_io 10
set hps_mdio0_q1_en 1
set hps_emac0_rgmii_en 1
set hps_sdmmc4b_q1_en 1
set hps_sdmmc4b_q1_sel_en 1
set hps_sdmmc4b_q1_alt_en 1
set hps_sdmmc8b_q1_alt_en 1
set hps_jtag_en 1
set hps_emac2_rgmii_en 1

} elseif {$daughter_card == "tsn_phy_aic2"} {
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

