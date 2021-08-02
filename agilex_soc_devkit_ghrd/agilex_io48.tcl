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

} elseif {$daughter_card == "devkit_dc_nand"} {
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

} elseif {$daughter_card == "devkit_dc_emmc"} {
set hps_sdmmc8b_q1_en 1
set hps_cm_q 2
set hps_cm_io 4
set hps_i2c1_q3_en 1
set hps_emac2_rgmii_en 1
set hps_uart0_q3_en 1
set hps_mdio2_q3_en 1
set hps_gpio1_en 1
set hps_gpio1_list "0 1 4 5 10 11"

} elseif {$daughter_card == "pcie_devkit"} {
set hps_sdmmc4b_q4_en 1
set hps_i2c1_q3_en 1
set hps_emac0_rgmii_en 1
set hps_uart0_q3_en 1
set hps_gpio0_en 1
set hps_gpio0_list "11"
set hps_gpio1_en 1
set hps_gpio1_list "0"
set hps_mdio0_q4_en 1
set hps_jtag_en 1
set hps_cm_q 4
set hps_cm_io 7

} elseif {$daughter_card == "hps_dc8"} {
set hps_usb0_en 1
set hps_usb1_en 1
set hps_uart0_q3_en 1
set hps_uart0_fc_en 1
set hps_gpio1_en 1
set hps_gpio1_list "4 5"
set hps_jtag_en 1
set hps_sdmmc4b_q4_en 1
set hps_sdmmc4b_q4_pwr_en 1
set hps_cm_q 4
set hps_cm_io 7

} elseif {$daughter_card == "hps_dc9"} {
set hps_uart0_q1_en 1
set hps_uart0_fc_en 1
set hps_mdio0_q1_en 1
set hps_mdio1_q1_en 1
set hps_emac0_rgmii_en 1
set hps_emac1_rmii_en 1
set hps_jtag_en 1
set hps_sdmmc4b_q4_en 1
set hps_sdmmc4b_q4_pwr_en 1
set hps_cm_q 4
set hps_cm_io 7

} elseif {$daughter_card == "hps_dc10"} {
set hps_sdmmc8b_q1_en 1
set hps_emac0_rgmii_en 1
set hps_uart0_q3_en 1
set hps_uart0_fc_en 1
set hps_jtag_en 1
set hps_cm_q 4
set hps_cm_io 7
set hps_mdio0_q4_en 1

} elseif {$daughter_card == "hps_dc13"} {
set hps_nand_q12_en 1
set hps_nand_16b_en 1
set hps_uart0_q3_en 1
set hps_uart0_fc_en 1
set hps_gpio1_en 1
set hps_gpio1_list "4"
set hps_jtag_en 1
set hps_cm_q 4
set hps_cm_io 7

} elseif {$daughter_card == "none"} {
puts "Disable all HPS IO48 IO"
set hps_io_off 1
} else {
puts "Inserted daughter_card variant: $daughter_card NOT supported"
}

