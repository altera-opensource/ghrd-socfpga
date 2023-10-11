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
set fpga_clk_100_pin_list "BK109"
set fpga_clk_100_iostandard "3.3-V LVCMOS"

set fpga_reset_n_pin_list "BR112"
set fpga_reset_n_iostandard "3.3-V LVCMOS"

## Peripheral IOs
set fpga_led_pio_pin_list {
BM59
BH59
BH62
BP62
}

set fpga_led_pio_iostandard "1.1 V"
set fpga_led_pio_slewrate "0"

set fpga_dipsw_pio_pin_list {
CH12
BU22
BW19
BH28
}

set fpga_dipsw_pio_iostandard "3.3-V LVCMOS"
set fpga_dipsw_pio_weakpullup "ON"

set fpga_button_pio_pin_list {
BK31
BP22
BK28
BR22
}

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


## SGMII Related IOs
if {$board_pwrmgt == "linear"} {
set enet_refclk_pin "CG24"
} else {
set enet_refclk_pin "CN22"
}
set emac_sgmii_rxp_pin "CH21"
set emac_sgmii_rxn_pin "CF21"
set emac_sgmii_txp_pin "CG22"
set emac_sgmii_txn_pin "CE22"
set emac_mdio_pin "CE46"
set emac_mdc_pin "CL50"
set emac_phy_rst_n_pin "CL56"
set emac_phy_irq_n_pin "CN56"

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
set qsfpdd_modprsn_pin "CT3"
set qsfpdd_resetn_pin "CV3"
set qsfpdd_modseln_pin "CR4"
set qsfpdd_intn_pin "CU4"
set qsfpdd_initmode_pin "CT5"
set qsfpdd_i2c_scl_pin "CT1"
set qsfpdd_i2c_sda_pin "CY5"

## Preparing the dictionary for IOs PIN configuration
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
dict set pin_assignment_table fpga_led_pio slewrate $fpga_led_pio_slewrate

dict set pin_assignment_table fpga_dipsw_pio location $fpga_dipsw_pio_pin_list
dict set pin_assignment_table fpga_dipsw_pio io_standard $fpga_dipsw_pio_iostandard
dict set pin_assignment_table fpga_dipsw_pio direction input
dict set pin_assignment_table fpga_dipsw_pio width_in_bits $fpga_dipsw_pio_width
dict set pin_assignment_table fpga_dipsw_pio weakpullup $fpga_dipsw_pio_weakpullup

dict set pin_assignment_table fpga_button_pio location $fpga_button_pio_pin_list
dict set pin_assignment_table fpga_button_pio io_standard $fpga_button_pio_iostandard
dict set pin_assignment_table fpga_button_pio direction input
dict set pin_assignment_table fpga_button_pio width_in_bits $fpga_button_pio_width

dict set pin_assignment_table enet_refclk location $enet_refclk_pin
dict set pin_assignment_table enet_refclk io_standard "TRUE DIFFERENTIAL SIGNALING"
dict set pin_assignment_table enet_refclk direction input
dict set pin_assignment_table enet_refclk width_in_bits 1
dict set pin_assignment_table enet_refclk qsys_exported_port "enet_refclk"

puts "Number of ports: [dict size $pin_assignment_table]"


## EMIF PINOUT
# Pin Support Matrix for AGILEX SoC Devkit
# note that we have to perform a logical remapping of pins to support the HPS hard pinout.
# The DQ* Bits within each byte lane can be swizzled between the DevKit and UDV.  This has no impact on GHRD.  The GHRD can just use the example design/pinout below.
# Pins obtain from Dharmesh GHRD_Requirements_EMIF_Pinmapping_Rev1_0.xlsx

set emif_name "emif_hps"
set pin_matrix [ list \
      [ list "NAME"                                    "MEM"       "LOC"            "x16_r1"     "x32_r1"   ] \
      [ list "${emif_name}_emif_ref_clk_0_clk"         "lpddr4"    "PIN_M105"     "PIN_M105"    "PIN_M105"  ] \
      [ list "${emif_name}_emif_oct_0_oct_rzqin"       "lpddr4"    "PIN_AK111"    "PIN_AK111"   "PIN_AK111" ] \
      [ list "${emif_name}_emif_mem_0_mem_ck_t"        "lpddr4"    "PIN_AK107"    "PIN_AK107"   "PIN_AK107" ] \
      [ list "${emif_name}_emif_mem_0_mem_ck_c"        "lpddr4"    "PIN_AK104"    "PIN_AK104"   "PIN_AK104" ] \
      [ list "${emif_name}_emif_mem_0_mem_cke"         "lpddr4"    "PIN_V108"     "PIN_V108"    "PIN_V108"  ] \
      [ list "${emif_name}_emif_mem_0_mem_cs"          "lpddr4"    "PIN_T105"     "PIN_T105"    "PIN_T105"  ] \
      [ list "${emif_name}_emif_mem_0_mem_reset_n"     "lpddr4"    "PIN_AG111"    "PIN_AG111"   "PIN_AG111" ] \
      [ list "${emif_name}_emif_mem_0_mem_dqs_t[0]"    "lpddr4"    "PIN_B122"     "PIN_B122"    "PIN_B122"  ] \
      [ list "${emif_name}_emif_mem_0_mem_dqs_t[1]"    "lpddr4"    "PIN_F114"     "PIN_F114"    "PIN_F114"  ] \
      [ list "${emif_name}_emif_mem_0_mem_dqs_c[0]"    "lpddr4"    "PIN_A125"     "PIN_A125"    "PIN_A125"  ] \
      [ list "${emif_name}_emif_mem_0_mem_dqs_c[1]"    "lpddr4"    "PIN_D114"     "PIN_D114"    "PIN_D114"  ] \
      [ list "${emif_name}_emif_mem_0_mem_ca[0]"       "lpddr4"    "PIN_T114"     "PIN_T114"    "PIN_T114"  ] \
      [ list "${emif_name}_emif_mem_0_mem_ca[1]"       "lpddr4"    "PIN_P114"     "PIN_P114"    "PIN_P114"  ] \
      [ list "${emif_name}_emif_mem_0_mem_ca[2]"       "lpddr4"    "PIN_V117"     "PIN_V117"    "PIN_V117"  ] \
      [ list "${emif_name}_emif_mem_0_mem_ca[3]"       "lpddr4"    "PIN_T117"     "PIN_T117"    "PIN_T117"  ] \
      [ list "${emif_name}_emif_mem_0_mem_ca[4]"       "lpddr4"    "PIN_M114"     "PIN_M114"    "PIN_M114"  ] \
      [ list "${emif_name}_emif_mem_0_mem_ca[5]"       "lpddr4"    "PIN_K114"     "PIN_K114"    "PIN_K114"  ] \
      [ list "${emif_name}_emif_mem_0_mem_dmi[0]"      "lpddr4"    "PIN_B119"     "PIN_B119"    "PIN_B119"  ] \
      [ list "${emif_name}_emif_mem_0_mem_dmi[1]"      "lpddr4"    "PIN_F105"     "PIN_F105"    "PIN_F105"  ] \
      [ list "${emif_name}_emif_mem_0_mem_dq[0]"       "lpddr4"    "PIN_B128"     "PIN_B128"    "PIN_B128"  ] \
      [ list "${emif_name}_emif_mem_0_mem_dq[1]"       "lpddr4"    "PIN_A128"     "PIN_A128"    "PIN_A128"  ] \
      [ list "${emif_name}_emif_mem_0_mem_dq[2]"       "lpddr4"    "PIN_B130"     "PIN_B130"    "PIN_B130"  ] \
      [ list "${emif_name}_emif_mem_0_mem_dq[3]"       "lpddr4"    "PIN_A130"     "PIN_A130"    "PIN_A130"  ] \
      [ list "${emif_name}_emif_mem_0_mem_dq[4]"       "lpddr4"    "PIN_B116"     "PIN_B116"    "PIN_B116"  ] \
      [ list "${emif_name}_emif_mem_0_mem_dq[5]"       "lpddr4"    "PIN_A116"     "PIN_A116"    "PIN_A116"  ] \
      [ list "${emif_name}_emif_mem_0_mem_dq[6]"       "lpddr4"    "PIN_B113"     "PIN_B113"    "PIN_B113"  ] \
      [ list "${emif_name}_emif_mem_0_mem_dq[7]"       "lpddr4"    "PIN_A113"     "PIN_A113"    "PIN_A113"  ] \
      [ list "${emif_name}_emif_mem_0_mem_dq[8]"       "lpddr4"    "PIN_F117"     "PIN_F117"    "PIN_F117"  ] \
      [ list "${emif_name}_emif_mem_0_mem_dq[9]"       "lpddr4"    "PIN_H117"     "PIN_H117"    "PIN_H117"  ] \
      [ list "${emif_name}_emif_mem_0_mem_dq[10]"      "lpddr4"    "PIN_K117"     "PIN_K117"    "PIN_K117"  ] \
      [ list "${emif_name}_emif_mem_0_mem_dq[11]"      "lpddr4"    "PIN_M117"     "PIN_M117"    "PIN_M117"  ] \
      [ list "${emif_name}_emif_mem_0_mem_dq[12]"      "lpddr4"    "PIN_H108"     "PIN_H108"    "PIN_H108"  ] \
      [ list "${emif_name}_emif_mem_0_mem_dq[13]"      "lpddr4"    "PIN_F108"     "PIN_F108"    "PIN_F108"  ] \
      [ list "${emif_name}_emif_mem_0_mem_dq[14]"      "lpddr4"    "PIN_M108"     "PIN_M108"    "PIN_M108"  ] \
      [ list "${emif_name}_emif_mem_0_mem_dq[15]"      "lpddr4"    "PIN_K108"     "PIN_K108"    "PIN_K108"  ] \
      [ list "${emif_name}_emif_mem_0_mem_dq[16]"      "lpddr4"      unused         unused        unused    ] \
      [ list "${emif_name}_emif_mem_0_mem_dq[17]"      "lpddr4"      unused         unused        unused    ] \
      [ list "${emif_name}_emif_mem_0_mem_dq[18]"      "lpddr4"      unused         unused        unused    ] \
      [ list "${emif_name}_emif_mem_0_mem_dq[19]"      "lpddr4"      unused         unused        unused    ] \
      [ list "${emif_name}_emif_mem_0_mem_dq[20]"      "lpddr4"      unused         unused        unused    ] \
      [ list "${emif_name}_emif_mem_0_mem_dq[21]"      "lpddr4"      unused         unused        unused    ] \
      [ list "${emif_name}_emif_mem_0_mem_dq[22]"      "lpddr4"      unused         unused        unused    ] \
      [ list "${emif_name}_emif_mem_0_mem_dq[23]"      "lpddr4"      unused         unused        unused    ] \
      [ list "${emif_name}_emif_mem_0_mem_dq[24]"      "lpddr4"      unused         unused        unused    ] \
      [ list "${emif_name}_emif_mem_0_mem_dq[25]"      "lpddr4"      unused         unused        unused    ] \
      [ list "${emif_name}_emif_mem_0_mem_dq[26]"      "lpddr4"      unused         unused        unused    ] \
      [ list "${emif_name}_emif_mem_0_mem_dq[27]"      "lpddr4"      unused         unused        unused    ] \
      [ list "${emif_name}_emif_mem_0_mem_dq[28]"      "lpddr4"      unused         unused        unused    ] \
      [ list "${emif_name}_emif_mem_0_mem_dq[29]"      "lpddr4"      unused         unused        unused    ] \
      [ list "${emif_name}_emif_mem_0_mem_dq[30]"      "lpddr4"      unused         unused        unused    ] \
      [ list "${emif_name}_emif_mem_0_mem_dq[31]"      "lpddr4"      unused         unused        unused    ] \
]