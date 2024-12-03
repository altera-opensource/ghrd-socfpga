#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2021 Intel Corporation.
#
#****************************************************************************
#
# This file define the location, io standard, current drive strength, signal width, 
# and signal direction settings for every port available on the FPGA side for Agilex SoC Devkit Board.
#
# Define all the location assignments in sequence for specific port data with signal width more than one
#
#****************************************************************************

## BOARD devkit

source ./arguments_solver.tcl

## -----------------------------
## PINOUT Location & IOSTANDARD & CURRENT_STRENGTH & SLEW RATE & PULLUP
## -----------------------------

## Clock and Reset
set fpga_clk_100_pin_list "BK31"
set fpga_clk_100_iostandard "3.3-V LVCMOS"

set fpga_reset_n_pin_list "BU28"
set fpga_reset_n_iostandard "3.3-V LVCMOS"

## Peripheral IOs
set fpga_led_pio_pin_list "CF12"
set fpga_led_pio_iostandard "3.3-V LVCMOS"
# set fpga_led_pio_slewrate "0"

set fpga_dipsw_pio_pin_list {
BU22
CH12
}

set fpga_dipsw_pio_iostandard "3.3-V LVCMOS"
set fpga_dipsw_pio_weakpullup "ON"

set fpga_button_pio_pin_list "BW19"
set fpga_button_pio_iostandard "3.3-V LVCMOS"

## PCIE Related IOs
set pcie_tx_p_out_pin_list {
BP55
BN52
BK55
BJ52
BF55
BE52
BB55
BA52
AV55
AU52
AP55
AN52
AK55
AJ52
AF55
AE52
}

set pcie_tx_n_out_pin_list {
BR56
BM53
BL56
BH53
BG56
BD53
BC56
AY53
AW56
AT53
AR56
AM53
AL56
AH53
AG56
AD53
}


set pcie_rx_p_in_pin_list {
BP61
BN58
BK61
BJ58
BF61
BE58
BB61
BA58
AV61
AU58
AP61
AN58
AK61
AJ58
AF61
AE58
}

set pcie_rx_n_in_pin_list {
BR62
BM59
BL62
BH59
BG62
BD59
BC62
AY59
AW62
AT59
AR62
AM59
AL62
AH59
AG62
AD59
}

set pcie_refclk0_pin "AJ48"
set pcie_refclk1_pin "AE48"
set pcie_refclk_iostandard "HCSL"

set pcie_perst_pin "BU58"
set pcie_perst_iostandard "1.8 V"

# Use in devkit for remote PERST assertion
set fpga_gpio0_pin "V45"

#Etile 25GbE
# REFCLK_GXEp0 156.25MHz
set etile_clk_ref_pin "AT13"

# FPGA_GPIO_REFCLK0 156.25MHz
set etile_master_todclk_ref_pin "DC22"

# CH15 (QSFPDD_TXp3)-> first channel; CH14 (QSFPDD_TXp1); CH13 (QSFPDD_TXp2); CH12 (QSFPDD_TXp0)
set etile_tx_serial_pin {
BL4
BK1
BG4
BF1
}
set etile_tx_serial_n_pin {
BM5
BJ2
BH5
BE2
}
set etile_rx_serial_pin {
BL10
BK7
BG10
BF7
}
set etile_rx_serial_n_pin {
BM11
BJ8
BH11
BE8
}

set fpga_rgmii_rxd_pin {
A30
B30
A33
A35
}

set fpga_rgmii_txd_pin {
A8
B4
A11
B11
}


set qsfpdd_modprsn_pin "CT3"
set qsfpdd_resetn_pin "CV3"
set qsfpdd_modseln_pin "CR4"
set qsfpdd_intn_pin "CU4"
set qsfpdd_initmode_pin "CT5"
set qsfpdd_i2c_scl_pin "CT1"
set qsfpdd_i2c_sda_pin "CY5"

set usb31_io_vbus_det                   "BU31"
set usb31_io_flt_bar                    "BP22"
set usb31_io_usb_ctrl                   "BM28"
set usb31_io_usb31_id                   "BR22"
set usb31_phy_refclk_p_clk              "AP120"
set usb31_phy_refclk_n_clk              "AP115"
set usb31_phy_rx_serial_n_i_rx_serial_n "AM133"
set usb31_phy_rx_serial_p_i_rx_serial_p "AM135"
set usb31_phy_tx_serial_n_o_tx_serial_n "AN126"
set usb31_phy_tx_serial_p_o_tx_serial_p "AN129"


## Preparing the dictionary for IOs PIN configuration
dict set pin_assignment_table usb31_io_vbus_det location $usb31_io_vbus_det
dict set pin_assignment_table usb31_io_vbus_det io_standard "3.3-V LVCMOS"
dict set pin_assignment_table usb31_io_vbus_det direction input
dict set pin_assignment_table usb31_io_vbus_det width_in_bits 1

dict set pin_assignment_table usb31_io_flt_bar location $usb31_io_flt_bar
dict set pin_assignment_table usb31_io_flt_bar io_standard "3.3-V LVCMOS"
dict set pin_assignment_table usb31_io_flt_bar direction input
dict set pin_assignment_table usb31_io_flt_bar width_in_bits 1

dict set pin_assignment_table usb31_io_usb31_id location $usb31_io_usb31_id
dict set pin_assignment_table usb31_io_usb31_id io_standard "3.3-V LVCMOS"
dict set pin_assignment_table usb31_io_usb31_id direction input
dict set pin_assignment_table usb31_io_usb31_id width_in_bits 1

dict set pin_assignment_table usb31_io_usb_ctrl location $usb31_io_usb_ctrl
dict set pin_assignment_table usb31_io_usb_ctrl io_standard "3.3-V LVCMOS"
dict set pin_assignment_table usb31_io_usb_ctrl direction output
dict set pin_assignment_table usb31_io_usb_ctrl width_in_bits 1

dict set pin_assignment_table usb31_phy_refclk_p_clk location $usb31_phy_refclk_p_clk
dict set pin_assignment_table usb31_phy_refclk_p_clk io_standard "Current Mode Logic (CML)"
dict set pin_assignment_table usb31_phy_refclk_p_clk direction input
dict set pin_assignment_table usb31_phy_refclk_p_clk width_in_bits 1
#FACING placement issue for n pair at AP115, workaround is to avoid assignment in QSF, leave it to Quartus automap
# dict set pin_assignment_table usb31_phy_refclk_n_clk location $usb31_phy_refclk_n_clk
# dict set pin_assignment_table usb31_phy_refclk_n_clk io_standard "Current Mode Logic (CML)"
# dict set pin_assignment_table usb31_phy_refclk_n_clk direction input
# dict set pin_assignment_table usb31_phy_refclk_n_clk width_in_bits 1

dict set pin_assignment_table usb31_phy_rx_serial_p_i_rx_serial_p location $usb31_phy_rx_serial_p_i_rx_serial_p
dict set pin_assignment_table usb31_phy_rx_serial_p_i_rx_serial_p io_standard "High Speed Differential I/O"
dict set pin_assignment_table usb31_phy_rx_serial_p_i_rx_serial_p direction input
dict set pin_assignment_table usb31_phy_rx_serial_p_i_rx_serial_p width_in_bits 1

dict set pin_assignment_table usb31_phy_rx_serial_n_i_rx_serial_n location $usb31_phy_rx_serial_n_i_rx_serial_n
dict set pin_assignment_table usb31_phy_rx_serial_n_i_rx_serial_n io_standard "High Speed Differential I/O"
dict set pin_assignment_table usb31_phy_rx_serial_n_i_rx_serial_n direction input
dict set pin_assignment_table usb31_phy_rx_serial_n_i_rx_serial_n width_in_bits 1

dict set pin_assignment_table usb31_phy_tx_serial_p_o_tx_serial_p location $usb31_phy_tx_serial_p_o_tx_serial_p
dict set pin_assignment_table usb31_phy_tx_serial_p_o_tx_serial_p io_standard "High Speed Differential I/O"
dict set pin_assignment_table usb31_phy_tx_serial_p_o_tx_serial_p direction output
dict set pin_assignment_table usb31_phy_tx_serial_p_o_tx_serial_p width_in_bits 1

dict set pin_assignment_table usb31_phy_tx_serial_n_o_tx_serial_n location $usb31_phy_tx_serial_n_o_tx_serial_n
dict set pin_assignment_table usb31_phy_tx_serial_n_o_tx_serial_n io_standard "High Speed Differential I/O"
dict set pin_assignment_table usb31_phy_tx_serial_n_o_tx_serial_n direction output
dict set pin_assignment_table usb31_phy_tx_serial_n_o_tx_serial_n width_in_bits 1

dict set pin_assignment_table fpga_clk_100 location $fpga_clk_100_pin_list
dict set pin_assignment_table fpga_clk_100 io_standard $fpga_clk_100_iostandard
dict set pin_assignment_table fpga_clk_100 direction input
dict set pin_assignment_table fpga_clk_100 width_in_bits 1

dict set pin_assignment_table fpga_reset_n location $fpga_reset_n_pin_list
dict set pin_assignment_table fpga_reset_n io_standard $fpga_reset_n_iostandard
dict set pin_assignment_table fpga_reset_n direction input
dict set pin_assignment_table fpga_reset_n width 1

dict set pin_assignment_table fpga_led_pio location $fpga_led_pio_pin_list
dict set pin_assignment_table fpga_led_pio io_standard $fpga_led_pio_iostandard
dict set pin_assignment_table fpga_led_pio direction output
dict set pin_assignment_table fpga_led_pio width_in_bits $fpga_led_pio_width
# dict set pin_assignment_table fpga_led_pio slewrate $fpga_led_pio_slewrate

dict set pin_assignment_table fpga_dipsw_pio location $fpga_dipsw_pio_pin_list
dict set pin_assignment_table fpga_dipsw_pio io_standard $fpga_dipsw_pio_iostandard
dict set pin_assignment_table fpga_dipsw_pio direction input
dict set pin_assignment_table fpga_dipsw_pio width_in_bits $fpga_dipsw_pio_width
dict set pin_assignment_table fpga_dipsw_pio weakpullup $fpga_dipsw_pio_weakpullup

dict set pin_assignment_table fpga_button_pio location $fpga_button_pio_pin_list
dict set pin_assignment_table fpga_button_pio io_standard $fpga_button_pio_iostandard
dict set pin_assignment_table fpga_button_pio direction input
dict set pin_assignment_table fpga_button_pio width_in_bits $fpga_button_pio_width

if {$sub_fpga_rgmii_en == 1} {
dict set pin_assignment_table fpga_rgmii_rx_clk location "B23"
dict set pin_assignment_table fpga_rgmii_rx_clk io_standard "1.8-V LVCMOS"
dict set pin_assignment_table fpga_rgmii_rx_clk direction input
dict set pin_assignment_table fpga_rgmii_rx_clk width_in_bits 1

dict set pin_assignment_table fpga_rgmii_tx_clk location "B14"
dict set pin_assignment_table fpga_rgmii_tx_clk io_standard "1.8-V LVCMOS"
dict set pin_assignment_table fpga_rgmii_tx_clk direction output
dict set pin_assignment_table fpga_rgmii_tx_clk width_in_bits 1

dict set pin_assignment_table fpga_rgmii_rx_ctl location "B20"
dict set pin_assignment_table fpga_rgmii_rx_ctl io_standard "1.8-V LVCMOS"
dict set pin_assignment_table fpga_rgmii_rx_ctl direction input
dict set pin_assignment_table fpga_rgmii_rx_ctl width_in_bits 1

dict set pin_assignment_table fpga_rgmii_tx_ctl location "A14"
dict set pin_assignment_table fpga_rgmii_tx_ctl io_standard "1.8-V LVCMOS"
dict set pin_assignment_table fpga_rgmii_tx_ctl direction output
dict set pin_assignment_table fpga_rgmii_tx_ctl width_in_bits 1

dict set pin_assignment_table fpga_rgmii_rxd location $fpga_rgmii_rxd_pin
dict set pin_assignment_table fpga_rgmii_rxd io_standard "1.8-V LVCMOS"
dict set pin_assignment_table fpga_rgmii_rxd direction input
dict set pin_assignment_table fpga_rgmii_rxd width_in_bits 4

dict set pin_assignment_table fpga_rgmii_txd location $fpga_rgmii_txd_pin
dict set pin_assignment_table fpga_rgmii_txd io_standard "1.8-V LVCMOS"
dict set pin_assignment_table fpga_rgmii_txd direction output
dict set pin_assignment_table fpga_rgmii_txd width_in_bits 4

dict set pin_assignment_table emac1_mdio location "A39"
dict set pin_assignment_table emac1_mdio io_standard "1.8-V LVCMOS"
dict set pin_assignment_table emac1_mdio direction inout
dict set pin_assignment_table emac1_mdio width_in_bits 1

dict set pin_assignment_table emac1_mdc location "B26"
dict set pin_assignment_table emac1_mdc io_standard "1.8-V LVCMOS"
dict set pin_assignment_table emac1_mdc direction output
dict set pin_assignment_table emac1_mdc width_in_bits 1
}

puts "Number of ports: [dict size $pin_assignment_table]"


## EMIF PINOUT
# Pin Support Matrix for AGILEX SoC Devkit
# note that we have to perform a logical remapping of pins to support the HPS hard pinout.
# The DQ* Bits within each byte lane can be swizzled between the DevKit and UDV.  This has no impact on GHRD.  The GHRD can just use the example design/pinout below.
# Pins obtain from Dharmesh GHRD_Requirements_EMIF_Pinmapping_Rev1_0.xlsx

set emif_name "emif_hps"
set pin_matrix [ list \
      [ list "NAME"                                    "MEM"       "LOC"            "x16_r1"      "x24_r1"      "x32_r1"        "x40_r1"        "x64_r1"        "x72_r1"         ] \
]
