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
set fpga_clk_100_pin_list "CK18"
#set fpga_clk_100_iostandard "1.2 V"
set fpga_clk_100_iostandard "TRUE DIFFERENTIAL SIGNALING"

set fpga_reset_n_pin_list "A45"
set fpga_reset_n_iostandard "1.2 V"

set fpga_led0_pin_list "B50"
set fpga_led0_iostandard "1.2 V"

set fpga_led1_pin_list "A49"
set fpga_led1_iostandard "1.2 V"

set fpga_led2_pin_list "D48"
set fpga_led2_iostandard "1.2 V"

set fpga_led3_pin_list "E47"
set fpga_led3_iostandard "1.2 V"

# Peripheral IOs
set fpga_led_pio_pin_list {
B50
A49
D48
E47
}

set fpga_led_pio_iostandard "1.2 V"


#set fpga_dipsw_pio_pin_list {
#H45
#F45
#J44
#G44
#}

#set fpga_dipsw_pio_iostandard "1.2 V"
#set fpga_dipsw_pio_weakpullup "ON"

#set fpga_button_pio_pin_list {
#CY47
#CW48
#}

#set fpga_button_pio_iostandard "1.2 V"

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

#set SGPIO_EN $SGPIO_EN
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


#else {
#
#dict set pin_assignment_table fpga_dipsw_pio location $fpga_dipsw_pio_pin_list
#dict set pin_assignment_table fpga_dipsw_pio io_standard $fpga_dipsw_pio_iostandard
#dict set pin_assignment_table fpga_dipsw_pio direction input
#dict set pin_assignment_table fpga_dipsw_pio width_in_bits $fpga_dipsw_pio_width
#dict set pin_assignment_table fpga_dipsw_pio weakpullup $fpga_dipsw_pio_weakpullup
#}

#dict set pin_assignment_table fpga_button_pio location $fpga_button_pio_pin_list
#dict set pin_assignment_table fpga_button_pio io_standard $fpga_button_pio_iostandard
#dict set pin_assignment_table fpga_button_pio direction input
#dict set pin_assignment_table fpga_button_pio width_in_bits $fpga_button_pio_width



if {$fpga_pcie == 1} {
#rebuild list that follow the pcie_count
#set pcie_tx_p_out_pin_list_rebuild [lrange $pcie_tx_p_out_pin_list 0 [expr {$pcie_count-1}]]
#bifurcation GEN 4x4

##TX_P
set pcie_tx_p_out_pin_list_rebuild [lrange $pcie_tx_p_out_pin_list 0 15]
dict set pin_assignment_table pcie_hip_serial_tx_p_out location $pcie_tx_p_out_pin_list_rebuild
#dict set pin_assignment_table pcie_hip_serial_tx_p_out io_standard "HIGH SPEED DIFFERENTIAL I/O"
#dict set pin_assignment_table pcie_hip_serial_tx_p_out io_standard "NULL"
dict set pin_assignment_table pcie_hip_serial_tx_p_out direction output
#dict set pin_assignment_table pcie_hip_serial_tx_p_out width_in_bits $pcie_count
dict set pin_assignment_table pcie_hip_serial_tx_p_out width_in_bits 16

#TX_N
set pcie_tx_n_out_pin_list_rebuild [lrange $pcie_tx_n_out_pin_list 0 15]
dict set pin_assignment_table pcie_hip_serial_tx_n_out location $pcie_tx_n_out_pin_list_rebuild
#dict set pin_assignment_table pcie_hip_serial_tx_n_out io_standard "HIGH SPEED DIFFERENTIAL I/O"
#dict set pin_assignment_table pcie_hip_serial_tx_n_out io_standard "NULL"
dict set pin_assignment_table pcie_hip_serial_tx_n_out direction output
#dict set pin_assignment_table pcie_hip_serial_tx_n_out width_in_bits $pcie_count
dict set pin_assignment_table pcie_hip_serial_tx_n_out width_in_bits 16

##RX_P
#set pcie_rx_p_in_pin_list_rebuild [lrange $pcie_rx_p_in_pin_list 0 [expr {$pcie_count-1}]]
set pcie_rx_p_in_pin_list_rebuild [lrange $pcie_rx_p_in_pin_list 0 15]
dict set pin_assignment_table pcie_hip_serial_rx_p_in location $pcie_rx_p_in_pin_list_rebuild
#dict set pin_assignment_table pcie_hip_serial_rx_p_in io_standard "HIGH SPEED DIFFERENTIAL I/O"
#dict set pin_assignment_table pcie_hip_serial_rx_p_in io_standard "NULL"
dict set pin_assignment_table pcie_hip_serial_rx_p_in direction input
#dict set pin_assignment_table pcie_hip_serial_rx_p_in width_in_bits $pcie_count
dict set pin_assignment_table pcie_hip_serial_rx_p_in width_in_bits 16
#RX_N
#set pcie_rx_n_in_pin_list_rebuild [lrange $pcie_rx_n_in_pin_list 0 [expr {$pcie_count-1}]]
set pcie_rx_n_in_pin_list_rebuild [lrange $pcie_rx_n_in_pin_list 0 15]
dict set pin_assignment_table pcie_hip_serial_rx_n_in location $pcie_rx_n_in_pin_list_rebuild
#dict set pin_assignment_table pcie_hip_serial_rx_n_in io_standard "HIGH SPEED DIFFERENTIAL I/O"
#dict set pin_assignment_table pcie_hip_serial_rx_n_in io_standard "NULL"
dict set pin_assignment_table pcie_hip_serial_rx_n_in direction input
#dict set pin_assignment_table pcie_hip_serial_rx_n_in width_in_bits $pcie_count
dict set pin_assignment_table pcie_hip_serial_rx_n_in width_in_bits 16


dict set pin_assignment_table pcie_hip_refclk0_clk location $pcie_refclk0_pin
dict set pin_assignment_table pcie_hip_refclk0_clk io_standard $pcie_refclk_iostandard
dict set pin_assignment_table pcie_hip_refclk0_clk direction input
dict set pin_assignment_table pcie_hip_refclk0_clk width_in_bits 1

dict set pin_assignment_table pcie_hip_refclk1_clk location $pcie_refclk1_pin
dict set pin_assignment_table pcie_hip_refclk1_clk io_standard $pcie_refclk_iostandard
dict set pin_assignment_table pcie_hip_refclk1_clk direction input
dict set pin_assignment_table pcie_hip_refclk1_clk width_in_bits 1


dict set pin_assignment_table pcie_hip_npor_pin_perst location $pcie_perst_pin
dict set pin_assignment_table pcie_hip_npor_pin_perst io_standard $pcie_perst_iostandard
dict set pin_assignment_table pcie_hip_npor_pin_perst direction input
dict set pin_assignment_table pcie_hip_npor_pin_perst width_in_bits 1

# This is only valid for devkit for Remote PERST
dict set pin_assignment_table fpga_gpio0 location $fpga_gpio0_pin
dict set pin_assignment_table fpga_gpio0 io_standard "1.2 V"
dict set pin_assignment_table fpga_gpio0 direction output
dict set pin_assignment_table fpga_gpio0 width_in_bits 1
dict set pin_assignment_table fpga_gpio0 slewrate "1"
}

if {$hps_sgmii_en == 1} {
## For devkit, it has only one SGMII. The separation of EMAC1 and EMAC2 purely
#  for script testing. The assigned pins are the same on both EMAC1 and EMAC2 setup.
#  That means, only one of it can be enable at a time.
if {$hps_sgmii_emac1_en == 1 && $hps_sgmii_emac2_en == 1} {
	error "Error: For devkit, either EMAC1 or EMAC2 can active at a time as only one SGMMI available on board"
}


dict set pin_assignment_table enet_refclk location $enet_refclk_pin
dict set pin_assignment_table enet_refclk io_standard "TRUE DIFFERENTIAL SIGNALING"
dict set pin_assignment_table enet_refclk direction input
dict set pin_assignment_table enet_refclk width_in_bits 1
dict set pin_assignment_table enet_refclk qsys_exported_port "enet_refclk"

if {$hps_sgmii_emac1_en == 1} {
dict set pin_assignment_table emac1_sgmii_rxp location $emac_sgmii_rxp_pin
dict set pin_assignment_table emac1_sgmii_rxp io_standard "TRUE DIFFERENTIAL SIGNALING"
dict set pin_assignment_table emac1_sgmii_rxp direction input
dict set pin_assignment_table emac1_sgmii_rxp width_in_bits 1
dict set pin_assignment_table emac1_sgmii_rxp qsys_exported_port "emac1_sgmii_rxp"

dict set pin_assignment_table emac1_sgmii_rxn location $emac_sgmii_rxn_pin
dict set pin_assignment_table emac1_sgmii_rxn io_standard "TRUE DIFFERENTIAL SIGNALING"
dict set pin_assignment_table emac1_sgmii_rxn direction input
dict set pin_assignment_table emac1_sgmii_rxn width_in_bits 1
dict set pin_assignment_table emac1_sgmii_rxn qsys_exported_port "emac1_sgmii_rxn"

dict set pin_assignment_table emac1_sgmii_txp location $emac_sgmii_txp_pin
dict set pin_assignment_table emac1_sgmii_txp io_standard "TRUE DIFFERENTIAL SIGNALING"
dict set pin_assignment_table emac1_sgmii_txp direction input
dict set pin_assignment_table emac1_sgmii_txp width_in_bits 1
dict set pin_assignment_table emac1_sgmii_txp qsys_exported_port "emac1_sgmii_txp"

dict set pin_assignment_table emac1_sgmii_txn location $emac_sgmii_txn_pin
dict set pin_assignment_table emac1_sgmii_txn io_standard "TRUE DIFFERENTIAL SIGNALING"
dict set pin_assignment_table emac1_sgmii_txn direction input
dict set pin_assignment_table emac1_sgmii_txn width_in_bits 1
dict set pin_assignment_table emac1_sgmii_txn qsys_exported_port "emac1_sgmii_txn"

dict set pin_assignment_table emac1_mdc location $emac_mdc_pin
dict set pin_assignment_table emac1_mdc io_standard "1.2 V"
dict set pin_assignment_table emac1_mdc direction output
dict set pin_assignment_table emac1_mdc width_in_bits 1
dict set pin_assignment_table emac1_mdc qsys_exported_port "emac1_mdc"

dict set pin_assignment_table emac1_mdio location $emac_mdio_pin
dict set pin_assignment_table emac1_mdio io_standard "1.2 V"
dict set pin_assignment_table emac1_mdio direction inout
dict set pin_assignment_table emac1_mdio width_in_bits 1
dict set pin_assignment_table emac1_mdio qsys_exported_port "emac1_mdio"

dict set pin_assignment_table emac1_phy_irq_n location $emac_phy_irq_n_pin
dict set pin_assignment_table emac1_phy_irq_n io_standard "1.2 V"
dict set pin_assignment_table emac1_phy_irq_n direction output
dict set pin_assignment_table emac1_phy_irq_n width_in_bits 1
dict set pin_assignment_table emac1_phy_irq_n qsys_exported_port "emac1_phy_irq_n"

dict set pin_assignment_table emac1_phy_rst_n location $emac_phy_rst_n_pin
dict set pin_assignment_table emac1_phy_rst_n io_standard "1.2 V"
dict set pin_assignment_table emac1_phy_rst_n direction inout
dict set pin_assignment_table emac1_phy_rst_n width_in_bits 1
dict set pin_assignment_table emac1_phy_rst_n qsys_exported_port "emac1_phy_rst_n"
}
if {$hps_sgmii_emac2_en == 1} {
dict set pin_assignment_table emac2_sgmii_rxp location $emac_sgmii_rxp_pin
dict set pin_assignment_table emac2_sgmii_rxp io_standard "TRUE DIFFERENTIAL SIGNALING"
dict set pin_assignment_table emac2_sgmii_rxp direction input
dict set pin_assignment_table emac2_sgmii_rxp width_in_bits 1
dict set pin_assignment_table emac2_sgmii_rxp qsys_exported_port "emac2_sgmii_rxp"

dict set pin_assignment_table emac2_sgmii_rxn location $emac_sgmii_rxn_pin
dict set pin_assignment_table emac2_sgmii_rxn io_standard "TRUE DIFFERENTIAL SIGNALING"
dict set pin_assignment_table emac2_sgmii_rxn direction input
dict set pin_assignment_table emac2_sgmii_rxn width_in_bits 1
dict set pin_assignment_table emac2_sgmii_rxn qsys_exported_port "emac2_sgmii_rxn"

dict set pin_assignment_table emac2_sgmii_txp location $emac_sgmii_txp_pin
dict set pin_assignment_table emac2_sgmii_txp io_standard "TRUE DIFFERENTIAL SIGNALING"
dict set pin_assignment_table emac2_sgmii_txp direction input
dict set pin_assignment_table emac2_sgmii_txp width_in_bits 1
dict set pin_assignment_table emac2_sgmii_txp qsys_exported_port "emac2_sgmii_txp"

dict set pin_assignment_table emac2_sgmii_txn location $emac_sgmii_txn_pin
dict set pin_assignment_table emac2_sgmii_txn io_standard "TRUE DIFFERENTIAL SIGNALING"
dict set pin_assignment_table emac2_sgmii_txn direction input
dict set pin_assignment_table emac2_sgmii_txn width_in_bits 1
dict set pin_assignment_table emac2_sgmii_txn qsys_exported_port "emac2_sgmii_txn"

dict set pin_assignment_table emac2_mdc location $emac_mdc_pin
dict set pin_assignment_table emac2_mdc io_standard "1.2 V"
dict set pin_assignment_table emac2_mdc direction output
dict set pin_assignment_table emac2_mdc width_in_bits 1
dict set pin_assignment_table emac2_mdc qsys_exported_port "emac2_mdc"

dict set pin_assignment_table emac2_mdio location $emac_mdio_pin
dict set pin_assignment_table emac2_mdio io_standard "1.2 V"
dict set pin_assignment_table emac2_mdio direction inout
dict set pin_assignment_table emac2_mdio width_in_bits 1
dict set pin_assignment_table emac2_mdio qsys_exported_port "emac2_mdio"

dict set pin_assignment_table emac2_phy_irq_n location $emac_phy_irq_n_pin
dict set pin_assignment_table emac2_phy_irq_n io_standard "1.2 V"
dict set pin_assignment_table emac2_phy_irq_n direction output
dict set pin_assignment_table emac2_phy_irq_n width_in_bits 1
dict set pin_assignment_table emac2_phy_irq_n qsys_exported_port "emac2_phy_irq_n"

dict set pin_assignment_table emac2_phy_rst_n location $emac_phy_rst_n_pin
dict set pin_assignment_table emac2_phy_rst_n io_standard "1.2 V"
dict set pin_assignment_table emac2_phy_rst_n direction inout
dict set pin_assignment_table emac2_phy_rst_n width_in_bits 1
dict set pin_assignment_table emac2_phy_rst_n qsys_exported_port "emac2_phy_rst_n"
}
}

puts "Number of ports: [dict size $pin_assignment_table]"


## EMIF PINOUT
# Pin Support Matrix for AGILEX SoC Devkit
# note that we have to perform a logical remapping of pins to support the HPS hard pinout.
# The DQ* Bits within each byte lane can be swizzled between the DevKit and UDV.  This has no impact on GHRD.  The GHRD can just use the example design/pinout below.
# Pins obtain from Dharmesh GHRD_Requirements_EMIF_Pinmapping_Rev1_0.xlsx

set emif_name "emif_hps"
set pin_matrix [ list \
      [ list "NAME"                             "MEM"       "LOC"           "x16_r1"      "x24_r1"      "x32_r1"       "x40_r1"           ] \
      [ list "${emif_name}_pll_ref_clk"         "ddr4"      "PIN_U5"        "PIN_U5"      "PIN_U5"      "PIN_U5"       "PIN_U5"           ] \
      [ list "${emif_name}_oct_oct_rzqin"       "ddr4"      "PIN_W5"        "PIN_W5"      "PIN_W5"      "PIN_W5"       "PIN_W5"           ] \
      [ list "${emif_name}_mem_mem_a[0]"        "ddr4"      "PIN_U11"       "PIN_U11"     "PIN_U11"     "PIN_U11"      "PIN_U11"          ] \
      [ list "${emif_name}_mem_mem_a[1]"        "ddr4"      "PIN_T12"       "PIN_T12"     "PIN_T12"     "PIN_T12"      "PIN_T12"          ] \
      [ list "${emif_name}_mem_mem_a[2]"        "ddr4"      "PIN_W11"       "PIN_W11"     "PIN_W11"     "PIN_W11"      "PIN_W11"          ] \
      [ list "${emif_name}_mem_mem_a[3]"        "ddr4"      "PIN_Y12"       "PIN_Y12"     "PIN_Y12"     "PIN_Y12"      "PIN_Y12"          ] \
      [ list "${emif_name}_mem_mem_a[4]"        "ddr4"      "PIN_U9"        "PIN_U9"      "PIN_U9"      "PIN_U9"       "PIN_U9"           ] \
      [ list "${emif_name}_mem_mem_a[5]"        "ddr4"      "PIN_T10"       "PIN_T10"     "PIN_T10"     "PIN_T10"      "PIN_T10"          ] \
      [ list "${emif_name}_mem_mem_a[6]"        "ddr4"      "PIN_W9"        "PIN_W9"      "PIN_W9"      "PIN_W9"       "PIN_W9"           ] \
      [ list "${emif_name}_mem_mem_a[7]"        "ddr4"      "PIN_Y10"       "PIN_Y10"     "PIN_Y10"     "PIN_Y10"      "PIN_Y10"          ] \
      [ list "${emif_name}_mem_mem_a[8]"        "ddr4"      "PIN_U7"        "PIN_U7"      "PIN_U7"      "PIN_U7"       "PIN_U7"           ] \
      [ list "${emif_name}_mem_mem_a[9]"        "ddr4"      "PIN_T8"        "PIN_T8"      "PIN_T8"      "PIN_T8"       "PIN_T8"           ] \
      [ list "${emif_name}_mem_mem_a[10]"       "ddr4"      "PIN_W7"        "PIN_W7"      "PIN_W7"      "PIN_W7"       "PIN_W7"           ] \
      [ list "${emif_name}_mem_mem_a[11]"       "ddr4"      "PIN_Y8"        "PIN_Y8"      "PIN_Y8"      "PIN_Y8"       "PIN_Y8"           ] \
      [ list "${emif_name}_mem_mem_a[12]"       "ddr4"      "PIN_Y6"        "PIN_Y6"      "PIN_Y6"      "PIN_Y6"       "PIN_Y6"           ] \
      [ list "${emif_name}_mem_mem_a[13]"       "ddr4"      "PIN_U3"        "PIN_U3"      "PIN_U3"      "PIN_U3"       "PIN_U3"           ] \
      [ list "${emif_name}_mem_mem_a[14]"       "ddr4"      "PIN_T4"        "PIN_T4"      "PIN_T4"      "PIN_T4"       "PIN_T4"           ] \
      [ list "${emif_name}_mem_mem_a[15]"       "ddr4"      "PIN_W3"        "PIN_W3"      "PIN_W3"      "PIN_W3"       "PIN_W3"           ] \
      [ list "${emif_name}_mem_mem_a[16]"       "ddr4"      "PIN_Y4"        "PIN_Y4"      "PIN_Y4"      "PIN_Y4"       "PIN_Y4"           ] \
      [ list "${emif_name}_mem_mem_ba[0]"       "ddr4"      "PIN_T2"        "PIN_T2"      "PIN_T2"      "PIN_T2"       "PIN_T2"           ] \
      [ list "${emif_name}_mem_mem_ba[1]"       "ddr4"      "PIN_W1"        "PIN_W1"      "PIN_W1"      "PIN_W1"       "PIN_W1"           ] \
      [ list "${emif_name}_mem_mem_bg[0]"       "ddr4"      "PIN_Y2"        "PIN_Y2"      "PIN_Y2"      "PIN_Y2"       "PIN_Y2"           ] \
      [ list "${emif_name}_mem_mem_bg[1]"       "ddr4"      "PIN_L11"       "PIN_L11"     "PIN_L11"     "PIN_L11"      "PIN_L11"          ] \
	  [ list "${emif_name}_mem_mem_act_n"       "ddr4"      "PIN_P12"       "PIN_P12"     "PIN_P12"     "PIN_P12"      "PIN_P12"          ] \
	  [ list "${emif_name}_mem_mem_alert_n"     "ddr4"      "PIN_U1"        "PIN_U1"      "PIN_U1"      "PIN_U1"       "PIN_U1"           ] \
	  [ list "${emif_name}_mem_mem_ck[0]"       "ddr4"      "PIN_L7"        "PIN_L7"      "PIN_L7"      "PIN_L7"       "PIN_L7"           ] \
      [ list "${emif_name}_mem_mem_ck_n[0]"     "ddr4"      "PIN_M8"        "PIN_M8"      "PIN_M8"      "PIN_M8"       "PIN_M8"           ] \
	  [ list "${emif_name}_mem_mem_cke[0]"      "ddr4"      "PIN_R9"        "PIN_R9"      "PIN_R9"      "PIN_R9"       "PIN_R9"           ] \
	  [ list "${emif_name}_mem_mem_cs_n[0]"     "ddr4"      "PIN_R11"       "PIN_R11"     "PIN_R11"     "PIN_R11"      "PIN_R11"          ] \
      [ list "${emif_name}_mem_mem_odt[0]"      "ddr4"      "PIN_L9"        "PIN_L9"      "PIN_L9"      "PIN_L9"       "PIN_L9"           ] \
      [ list "${emif_name}_mem_mem_par"         "ddr4"      "PIN_P8"        "PIN_P8"      "PIN_P8"      "PIN_P8"       "PIN_P8"           ] \
      [ list "${emif_name}_mem_mem_reset_n"     "ddr4"      "PIN_M12"       "PIN_M12"     "PIN_M12"     "PIN_M12"      "PIN_M12"          ] \
      [ list "${emif_name}_mem_mem_dqs[0]"      "ddr4"      "PIN_AA5"       unused        "PIN_AA5"     unused         "PIN_AA5"          ] \
      [ list "${emif_name}_mem_mem_dqs[1]"      "ddr4"      "PIN_L3"        "PIN_L3"      "PIN_L3"      "PIN_L3"       "PIN_L3"           ] \
      [ list "${emif_name}_mem_mem_dqs[2]"      "ddr4"      "PIN_A7"        "PIN_A7"      "PIN_A7"      "PIN_A7"       "PIN_A7"           ] \
      [ list "${emif_name}_mem_mem_dqs[3]"      "ddr4"      "PIN_G3"        unused        unused        "PIN_G3"       "PIN_G3"           ] \
      [ list "${emif_name}_mem_mem_dqs[4]"      "ddr4"      "PIN_G9"        unused        unused        "PIN_G9"       "PIN_G9"           ] \
      [ list "${emif_name}_mem_mem_dqs_n[0]"    "ddr4"      "PIN_AB6"       unused        "PIN_AB6"     unused         "PIN_AB6"          ] \
      [ list "${emif_name}_mem_mem_dqs_n[1]"    "ddr4"      "PIN_M4"        "PIN_M4"      "PIN_M4"      "PIN_M4"       "PIN_M4"           ] \
      [ list "${emif_name}_mem_mem_dqs_n[2]"    "ddr4"      "PIN_B8"        "PIN_B8"      "PIN_B8"      "PIN_B8"       "PIN_B8"           ] \
      [ list "${emif_name}_mem_mem_dqs_n[3]"    "ddr4"      "PIN_F4"        unused        unused        "PIN_F4"       "PIN_F4"           ] \
      [ list "${emif_name}_mem_mem_dqs_n[4]"    "ddr4"      "PIN_F10"       unused        unused        "PIN_F10"      "PIN_F10"          ] \
      [ list "${emif_name}_mem_mem_dbi_n[0]"    "ddr4"      "PIN_AA3"       unused        "PIN_AA3"     unused         "PIN_AA3"          ] \
      [ list "${emif_name}_mem_mem_dbi_n[1]"    "ddr4"      "PIN_R3"        "PIN_R3"      "PIN_R3"      "PIN_R3"       "PIN_R3"           ] \
      [ list "${emif_name}_mem_mem_dbi_n[2]"    "ddr4"      "PIN_E7"        "PIN_E7"      "PIN_E7"      "PIN_E7"       "PIN_E7"           ] \
      [ list "${emif_name}_mem_mem_dbi_n[3]"    "ddr4"      "PIN_J3"        unused        unused        "PIN_J3"       "PIN_J3"           ] \
      [ list "${emif_name}_mem_mem_dbi_n[4]"    "ddr4"      "PIN_J9"        unused        unused        "PIN_J9"       "PIN_J9"           ] \
      [ list "${emif_name}_mem_mem_dq[0]"       "ddr4"      "PIN_AA7"       unused        "PIN_AA7"     unused         "PIN_AA7"          ] \
      [ list "${emif_name}_mem_mem_dq[1]"       "ddr4"      "PIN_AD2"       unused        "PIN_AD2"     unused         "PIN_AD2"          ] \
      [ list "${emif_name}_mem_mem_dq[2]"       "ddr4"      "PIN_AB2"       unused        "PIN_AB2"     unused         "PIN_AB2"          ] \
      [ list "${emif_name}_mem_mem_dq[3]"       "ddr4"      "PIN_AB8"       unused        "PIN_AB8"     unused         "PIN_AB8"          ] \
      [ list "${emif_name}_mem_mem_dq[4]"       "ddr4"      "PIN_AA1"       unused        "PIN_AA1"     unused         "PIN_AA1"          ] \
      [ list "${emif_name}_mem_mem_dq[5]"       "ddr4"      "PIN_AE7"       unused        "PIN_AE7"     unused         "PIN_AE7"          ] \
      [ list "${emif_name}_mem_mem_dq[6]"       "ddr4"      "PIN_AE1"       unused        "PIN_AE1"     unused         "PIN_AE1"          ] \
      [ list "${emif_name}_mem_mem_dq[7]"       "ddr4"      "PIN_AD6"       unused        "PIN_AD6"     unused         "PIN_AD6"          ] \
      [ list "${emif_name}_mem_mem_dq[8]"       "ddr4"      "PIN_M6"        "PIN_M6"      "PIN_M6"      "PIN_M6"       "PIN_M6"           ] \
      [ list "${emif_name}_mem_mem_dq[9]"       "ddr4"      "PIN_P2"        "PIN_P2"      "PIN_P2"      "PIN_P2"       "PIN_P2"           ] \
      [ list "${emif_name}_mem_mem_dq[10]"      "ddr4"      "PIN_L5"        "PIN_L5"      "PIN_L5"      "PIN_L5"       "PIN_L5"           ] \
      [ list "${emif_name}_mem_mem_dq[11]"      "ddr4"      "PIN_R1"        "PIN_R1"      "PIN_R1"      "PIN_R1"       "PIN_R1"           ] \
      [ list "${emif_name}_mem_mem_dq[12]"      "ddr4"      "PIN_P6"        "PIN_P6"      "PIN_P6"      "PIN_P6"       "PIN_P6"           ] \
      [ list "${emif_name}_mem_mem_dq[13]"      "ddr4"      "PIN_R5"        "PIN_R5"      "PIN_R5"      "PIN_R5"       "PIN_R5"           ] \
      [ list "${emif_name}_mem_mem_dq[14]"      "ddr4"      "PIN_M2"        "PIN_M2"      "PIN_M2"      "PIN_M2"       "PIN_M2"           ] \
      [ list "${emif_name}_mem_mem_dq[15]"      "ddr4"      "PIN_L1"        "PIN_L1"      "PIN_L1"      "PIN_L1"       "PIN_L1"           ] \
      [ list "${emif_name}_mem_mem_dq[16]"      "ddr4"      "PIN_A9"        "PIN_A9"      "PIN_A9"      "PIN_A9"       "PIN_A9"           ] \
      [ list "${emif_name}_mem_mem_dq[17]"      "ddr4"      "PIN_B6"        "PIN_B6"      "PIN_B6"      "PIN_B6"       "PIN_B6"           ] \
      [ list "${emif_name}_mem_mem_dq[18]"      "ddr4"      "PIN_E9"        "PIN_E9"      "PIN_E9"      "PIN_E9"       "PIN_E9"           ] \
      [ list "${emif_name}_mem_mem_dq[19]"      "ddr4"      "PIN_D6"        "PIN_D6"      "PIN_D6"      "PIN_D6"       "PIN_D6"           ] \
      [ list "${emif_name}_mem_mem_dq[20]"      "ddr4"      "PIN_D10"       "PIN_D10"     "PIN_D10"     "PIN_D10"      "PIN_D10"          ] \
      [ list "${emif_name}_mem_mem_dq[21]"      "ddr4"      "PIN_C5"        "PIN_C5"      "PIN_C5"      "PIN_C5"       "PIN_C5"           ] \
      [ list "${emif_name}_mem_mem_dq[22]"      "ddr4"      "PIN_B10"       "PIN_B10"     "PIN_B10"     "PIN_B10"      "PIN_B10"          ] \
      [ list "${emif_name}_mem_mem_dq[23]"      "ddr4"      "PIN_E5"        "PIN_E5"      "PIN_E5"      "PIN_E5"       "PIN_E5"           ] \
      [ list "${emif_name}_mem_mem_dq[24]"      "ddr4"      "PIN_F6"        unused        unused        "PIN_F6"       "PIN_F6"           ] \
      [ list "${emif_name}_mem_mem_dq[25]"      "ddr4"      "PIN_J1"        unused        unused        "PIN_J1"       "PIN_J1"           ] \
      [ list "${emif_name}_mem_mem_dq[26]"      "ddr4"      "PIN_F2"        unused        unused        "PIN_F2"       "PIN_F2"           ] \
      [ list "${emif_name}_mem_mem_dq[27]"      "ddr4"      "PIN_K2"        unused        unused        "PIN_K2"       "PIN_K2"           ] \
      [ list "${emif_name}_mem_mem_dq[28]"      "ddr4"      "PIN_K6"        unused        unused        "PIN_K6"       "PIN_K6"           ] \
      [ list "${emif_name}_mem_mem_dq[29]"      "ddr4"      "PIN_J5"        unused        unused        "PIN_J5"       "PIN_J5"           ] \
      [ list "${emif_name}_mem_mem_dq[30]"      "ddr4"      "PIN_G5"        unused        unused        "PIN_G5"       "PIN_G5"           ] \
      [ list "${emif_name}_mem_mem_dq[31]"      "ddr4"      "PIN_G1"        unused        unused        "PIN_G1"       "PIN_G1"           ] \
      [ list "${emif_name}_mem_mem_dq[32]"      "ddr4"      "PIN_F12"       unused        unused        "PIN_F12"      "PIN_F12"          ] \
      [ list "${emif_name}_mem_mem_dq[33]"      "ddr4"      "PIN_F8"        unused        unused        "PIN_F8"       "PIN_F8"           ] \
      [ list "${emif_name}_mem_mem_dq[34]"      "ddr4"      "PIN_G11"       unused        unused        "PIN_G11"      "PIN_G11"          ] \
      [ list "${emif_name}_mem_mem_dq[35]"      "ddr4"      "PIN_K8"        unused        unused        "PIN_K8"       "PIN_K8"           ] \
      [ list "${emif_name}_mem_mem_dq[36]"      "ddr4"      "PIN_J11"       unused        unused        "PIN_J11"      "PIN_J11"          ] \
      [ list "${emif_name}_mem_mem_dq[37]"      "ddr4"      "PIN_G7"        unused        unused        "PIN_G7"       "PIN_G7"           ] \
      [ list "${emif_name}_mem_mem_dq[38]"      "ddr4"      "PIN_K12"       unused        unused        "PIN_K12"      "PIN_K12"          ] \
      [ list "${emif_name}_mem_mem_dq[39]"      "ddr4"      "PIN_J7"        unused        unused        "PIN_J7"       "PIN_J7"           ] \
]