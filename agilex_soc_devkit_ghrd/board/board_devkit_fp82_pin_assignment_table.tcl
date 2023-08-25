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
set fpga_clk_100_pin_list "H31"
#set fpga_clk_100_iostandard "1.2 V"
#set fpga_clk_100_iostandard "TRUE DIFFERENTIAL SIGNALING"

set fpga_reset_n_pin_list "L28"
#set fpga_reset_n_iostandard "1.2 V"
#SGPIO
# set fpga_sgpio_sync_pin_list "Y49"
# set fpga_sgpio_sync_iostandard "1.2 V"

# set fpga_sgpio_clk_pin_list "W48"
# set fpga_sgpio_clk_iostandard "1.2 V"

# set fpga_sgpi_pin_list "T49"
# set fpga_sgpi_iostandard "1.2 V"

# set fpga_sgpo_pin_list "U48"
# set fpga_sgpo_iostandard "1.2 V"

## Peripheral IOs
set fpga_led_pio_pin_list {
E26
B27
A26
D29
}

set fpga_led_pio_iostandard "1.2 V"
set fpga_led_pio_slewrate "0"

# set fpga_dipsw_pio_pin_list {
# H45
# F45
# J44
# G44
# }

# set fpga_dipsw_pio_iostandard "1.2 V"
# set fpga_dipsw_pio_weakpullup "ON"

# set fpga_button_pio_pin_list {
# CY47
# CW48


# }

# set fpga_button_pio_iostandard "1.2 V"

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
dict set pin_assignment_table fpga_clk_100[0] location $fpga_clk_100_pin_list
# dict set pin_assignment_table fpga_clk_100 io_standard $fpga_clk_100_iostandard
dict set pin_assignment_table fpga_clk_100[0] direction input
dict set pin_assignment_table fpga_clk_100[0] width_in_bits 1

dict set pin_assignment_table fpga_reset_n[0] location $fpga_reset_n_pin_list
# dict set pin_assignment_table fpga_reset_n io_standard $fpga_reset_n_iostandard
dict set pin_assignment_table fpga_reset_n[0] direction input
dict set pin_assignment_table fpga_reset_n[0] width 1

#if {$SGPIO_EN == 1} {
# dict set pin_assignment_table fpga_sgpio_sync location $fpga_sgpio_sync_pin_list
# dict set pin_assignment_table fpga_sgpio_sync io_standard $fpga_sgpio_sync_iostandard
# dict set pin_assignment_table fpga_sgpio_sync direction input
# dict set pin_assignment_table fpga_sgpio_sync width 1

# dict set pin_assignment_table fpga_sgpio_clk location $fpga_sgpio_clk_pin_list
# dict set pin_assignment_table fpga_sgpio_clk io_standard $fpga_sgpio_clk_iostandard
# dict set pin_assignment_table fpga_sgpio_clk direction input
# dict set pin_assignment_table fpga_sgpio_clk width 1

# dict set pin_assignment_table fpga_sgpi location $fpga_sgpi_pin_list
# dict set pin_assignment_table fpga_sgpi io_standard $fpga_sgpi_iostandard
# dict set pin_assignment_table fpga_sgpi direction input
# dict set pin_assignment_table fpga_sgpi width 1

# dict set pin_assignment_table fpga_sgpo location $fpga_sgpo_pin_list
# dict set pin_assignment_table fpga_sgpo io_standard $fpga_sgpo_iostandard
# dict set pin_assignment_table fpga_sgpo direction output
# dict set pin_assignment_table fpga_sgpo width 1
#}
#else {
dict set pin_assignment_table fpga_led_pio location $fpga_led_pio_pin_list
dict set pin_assignment_table fpga_led_pio io_standard $fpga_led_pio_iostandard
dict set pin_assignment_table fpga_led_pio direction output
dict set pin_assignment_table fpga_led_pio width_in_bits $fpga_led_pio_width
dict set pin_assignment_table fpga_led_pio slewrate $fpga_led_pio_slewrate

#dict set pin_assignment_table fpga_dipsw_pio location $fpga_dipsw_pio_pin_list
#dict set pin_assignment_table fpga_dipsw_pio io_standard $fpga_dipsw_pio_iostandard
#dict set pin_assignment_table fpga_dipsw_pio direction input
#dict set pin_assignment_table fpga_dipsw_pio width_in_bits $fpga_dipsw_pio_width
#dict set pin_assignment_table fpga_dipsw_pio weakpullup $fpga_dipsw_pio_weakpullup
#}

# dict set pin_assignment_table fpga_button_pio location $fpga_button_pio_pin_list
# dict set pin_assignment_table fpga_button_pio io_standard $fpga_button_pio_iostandard
# dict set pin_assignment_table fpga_button_pio direction input
# dict set pin_assignment_table fpga_button_pio width_in_bits $fpga_button_pio_width

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

if {$hps_etile_1588_en == 1} {
dict set pin_assignment_table etile_clk_ref location $etile_clk_ref_pin
dict set pin_assignment_table etile_clk_ref io_standard "DIFFERENTIAL LVPECL"
dict set pin_assignment_table etile_clk_ref direction input
dict set pin_assignment_table etile_clk_ref width_in_bits 1
dict set pin_assignment_table etile_clk_ref qsys_exported_port "etile_clk_ref"

dict set pin_assignment_table etile_master_todclk_ref location $etile_master_todclk_ref_pin
dict set pin_assignment_table etile_master_todclk_ref io_standard "TRUE DIFFERENTIAL SIGNALING"
dict set pin_assignment_table etile_master_todclk_ref direction input
dict set pin_assignment_table etile_master_todclk_ref width_in_bits 1
dict set pin_assignment_table etile_master_todclk_ref qsys_exported_port "etile_master_todclk_ref"

set etile_tx_serial_pin_list_rebuild [lrange $etile_tx_serial_pin 0 [expr {$hps_etile_1588_count-1}]]
dict set pin_assignment_table etile_tx_serial location $etile_tx_serial_pin_list_rebuild
dict set pin_assignment_table etile_tx_serial io_standard "HSSI DIFFERENTIAL I/O"
dict set pin_assignment_table etile_tx_serial direction output
dict set pin_assignment_table etile_tx_serial width_in_bits $hps_etile_1588_count
dict set pin_assignment_table etile_tx_serial qsys_exported_port "etile_tx_serial"

set etile_tx_serial_n_pin_list_rebuild [lrange $etile_tx_serial_n_pin 0 [expr {$hps_etile_1588_count-1}]]
dict set pin_assignment_table etile_tx_serial_n location $etile_tx_serial_n_pin_list_rebuild
dict set pin_assignment_table etile_tx_serial_n io_standard "HSSI DIFFERENTIAL I/O"
dict set pin_assignment_table etile_tx_serial_n direction output
dict set pin_assignment_table etile_tx_serial_n width_in_bits $hps_etile_1588_count
dict set pin_assignment_table etile_tx_serial_n qsys_exported_port "etile_tx_serial_n"

set etile_rx_serial_pin_list_rebuild [lrange $etile_rx_serial_pin 0 [expr {$hps_etile_1588_count-1}]]
dict set pin_assignment_table etile_rx_serial location $etile_rx_serial_pin_list_rebuild
dict set pin_assignment_table etile_rx_serial io_standard "HSSI DIFFERENTIAL I/O"
dict set pin_assignment_table etile_rx_serial direction output
dict set pin_assignment_table etile_rx_serial width_in_bits $hps_etile_1588_count
dict set pin_assignment_table etile_rx_serial qsys_exported_port "etile_rx_serial"

set etile_rx_serial_n_pin_list_rebuild [lrange $etile_rx_serial_n_pin 0 [expr {$hps_etile_1588_count-1}]]
dict set pin_assignment_table etile_rx_serial_n location $etile_rx_serial_n_pin_list_rebuild
dict set pin_assignment_table etile_rx_serial_n io_standard "HSSI DIFFERENTIAL I/O"
dict set pin_assignment_table etile_rx_serial_n direction output
dict set pin_assignment_table etile_rx_serial_n width_in_bits $hps_etile_1588_count
dict set pin_assignment_table etile_rx_serial_n qsys_exported_port "etile_rx_serial_n"

dict set pin_assignment_table qsfpdd_modprsn location $qsfpdd_modprsn_pin
dict set pin_assignment_table qsfpdd_modprsn io_standard "1.2 V"
dict set pin_assignment_table qsfpdd_modprsn direction input
dict set pin_assignment_table qsfpdd_modprsn width_in_bits 1
dict set pin_assignment_table qsfpdd_modprsn qsys_exported_port "qsfpdd_modprsn"

dict set pin_assignment_table qsfpdd_resetn location $qsfpdd_resetn_pin
dict set pin_assignment_table qsfpdd_resetn io_standard "1.2 V"
dict set pin_assignment_table qsfpdd_resetn direction input
dict set pin_assignment_table qsfpdd_resetn width_in_bits 1
dict set pin_assignment_table qsfpdd_resetn qsys_exported_port "qsfpdd_resetn"

dict set pin_assignment_table qsfpdd_modseln location $qsfpdd_modseln_pin
dict set pin_assignment_table qsfpdd_modseln io_standard "1.2 V"
dict set pin_assignment_table qsfpdd_modseln direction input
dict set pin_assignment_table qsfpdd_modseln width_in_bits 1
dict set pin_assignment_table qsfpdd_modseln qsys_exported_port "qsfpdd_modseln"

dict set pin_assignment_table qsfpdd_intn location $qsfpdd_intn_pin
dict set pin_assignment_table qsfpdd_intn io_standard "1.2 V"
dict set pin_assignment_table qsfpdd_intn direction input
dict set pin_assignment_table qsfpdd_intn width_in_bits 1
dict set pin_assignment_table qsfpdd_intn qsys_exported_port "qsfpdd_intn"

dict set pin_assignment_table qsfpdd_initmode location $qsfpdd_initmode_pin
dict set pin_assignment_table qsfpdd_initmode io_standard "1.2 V"
dict set pin_assignment_table qsfpdd_initmode direction input
dict set pin_assignment_table qsfpdd_initmode width_in_bits 1
dict set pin_assignment_table qsfpdd_initmode qsys_exported_port "qsfpdd_initmode"

dict set pin_assignment_table qsfpdd_i2c_scl location $qsfpdd_i2c_scl_pin
dict set pin_assignment_table qsfpdd_i2c_scl io_standard "1.2 V"
dict set pin_assignment_table qsfpdd_i2c_scl direction input
dict set pin_assignment_table qsfpdd_i2c_scl width_in_bits 1
dict set pin_assignment_table qsfpdd_i2c_scl qsys_exported_port "qsfpdd_i2c_scl"

dict set pin_assignment_table qsfpdd_i2c_sda location $qsfpdd_i2c_sda_pin
dict set pin_assignment_table qsfpdd_i2c_sda io_standard "1.2 V"
dict set pin_assignment_table qsfpdd_i2c_sda direction input
dict set pin_assignment_table qsfpdd_i2c_sda width_in_bits 1
dict set pin_assignment_table qsfpdd_i2c_sda qsys_exported_port "qsfpdd_i2c_sda"
}

puts "Number of ports: [dict size $pin_assignment_table]"


## EMIF PINOUT
# Pin Support Matrix for AGILEX SoC Devkit
# note that we have to perform a logical remapping of pins to support the HPS hard pinout.
# The DQ* Bits within each byte lane can be swizzled between the DevKit and UDV.  This has no impact on GHRD.  The GHRD can just use the example design/pinout below.
# Pins obtain from Dharmesh GHRD_Requirements_EMIF_Pinmapping_Rev1_0.xlsx

set emif_name "emif_hps"
#unused
set pin_matrix [ list \
      [ list "NAME"                            		 	"MEM"       "fp82"                 ] \
      [ list "${emif_name}_ref_clk_clk"      	 		"ddr5"      "PIN_T21"              ] \
      [ list "${emif_name}_oct_oct_rzqin"      		 	"ddr5"      "PIN_AB25"             ] \
      [ list "${emif_name}_mem_mem_ca[0]"      		 	"ddr5"      "PIN_N24"              ] \
      [ list "${emif_name}_mem_mem_ca[1]"     		 	"ddr5"      "PIN_P25"              ] \
      [ list "${emif_name}_mem_mem_ca[2]"     	 	 	"ddr5"      "PIN_T25"              ] \
      [ list "${emif_name}_mem_mem_ca[3]"      		 	"ddr5"      "PIN_U24"              ] \
      [ list "${emif_name}_mem_mem_ca[4]"      		 	"ddr5"      "PIN_N22"              ] \
      [ list "${emif_name}_mem_mem_ca[5]"     	 	 	"ddr5"      "PIN_P23"              ] \
      [ list "${emif_name}_mem_mem_ca[6]"      		 	"ddr5"      "PIN_U22"              ] \
      [ list "${emif_name}_mem_mem_ca[7]"      		 	"ddr5"      "PIN_T23"              ] \
      [ list "${emif_name}_mem_mem_ca[8]"      		 	"ddr5"      "PIN_N20"              ] \
      [ list "${emif_name}_mem_mem_ca[9]"      		 	"ddr5"      "PIN_P21"              ] \
      [ list "${emif_name}_mem_mem_ca[10]"     		 	"ddr5"      "PIN_Y25"              ] \
      [ list "${emif_name}_mem_mem_ca[11]"     		 	"ddr5"      "PIN_W22"              ] \
      [ list "${emif_name}_mem_mem_ca[12]"     		 	"ddr5"      "PIN_Y23"              ] \
      [ list "${emif_name}_mem_mem_dm_n[0]"    		 	"ddr5"      "PIN_L22"              ] \
      [ list "${emif_name}_mem_mem_dm_n[1]"   		 	"ddr5"      "PIN_E20"              ] \
	  [ list "${emif_name}_mem_mem_dm_n[2]"    		 	"ddr5"      "PIN_U16"              ] \
	  [ list "${emif_name}_mem_mem_dm_n[3]"    		 	"ddr5"      "PIN_L16"              ] \
      [ list "${emif_name}_noc_pll_lock_o_pll_lock_o"	"ddr5"      "PIN_T63"              ] \
      [ list "${emif_name}_noc_refclk_clk"       		"ddr5"      "PIN_AU52"             ] \
      [ list "${emif_name}_mem_mem_ba[0]"       		"ddr5"      unused                 ] \
      [ list "${emif_name}_mem_mem_ba[1]"       		"ddr5"      unused                 ] \
      [ list "${emif_name}_mem_mem_bg[0]"       		"ddr5"      unused                 ] \
      [ list "${emif_name}_mem_mem_act_n"       		"ddr5"      unused                 ] \
      [ list "${emif_name}_mem_mem_alert_n"     		"ddr5"      "PIN_W24"              ] \
      [ list "${emif_name}_mem_mem_ck_c"        		"ddr5"      "PIN_AB23"             ] \
      [ list "${emif_name}_mem_mem_ck_t"        		"ddr5"      "PIN_AC22"             ] \
      [ list "${emif_name}_mem_mem_cke[0]"      		"ddr5"      unused                 ] \
      [ list "${emif_name}_mem_mem_cs_n"        		"ddr5"      "PIN_Y21"              ] \
      [ list "${emif_name}_mem_mem_odt[0]"      		"ddr5"      unused                 ] \
      [ list "${emif_name}_mem_mem_par"         		"ddr5"      unused                 ] \
      [ list "${emif_name}_mem_mem_reset_n"     		"ddr5"      "PIN_AC24"             ] \
      [ list "${emif_name}_mem_mem_dqs_c[0]"    		"ddr5"      "PIN_H23"              ] \
      [ list "${emif_name}_mem_mem_dqs_c[1]"    		"ddr5"      "PIN_B21"              ] \
	  [ list "${emif_name}_mem_mem_dqs_c[2]"    		"ddr5"      "PIN_P17"              ] \
	  [ list "${emif_name}_mem_mem_dqs_c[3]"    		"ddr5"      "PIN_H17"              ] \
      [ list "${emif_name}_mem_mem_dqs_t[0]"    		"ddr5"      "PIN_G22"              ] \
      [ list "${emif_name}_mem_mem_dqs_t[1]"    		"ddr5"      "PIN_A20"              ] \
      [ list "${emif_name}_mem_mem_dqs_t[2]"    		"ddr5"      "PIN_N16"              ] \
	  [ list "${emif_name}_mem_mem_dqs_t[3]"    		"ddr5"      "PIN_G16"              ] \
	  [ list "${emif_name}_mem_mem_dqs[4]"      		"ddr5"      unused                 ] \
      [ list "${emif_name}_mem_mem_dqs[5]"      		"ddr5"      unused                 ] \
      [ list "${emif_name}_mem_mem_dqs[6]"      		"ddr5"      unused                 ] \
      [ list "${emif_name}_mem_mem_dqs[7]"      		"ddr5"      unused                 ] \
      [ list "${emif_name}_mem_mem_dqs[8]"      		"ddr5"      unused                 ] \
      [ list "${emif_name}_mem_mem_dq[0]"       		"ddr5"      "PIN_H25"              ] \
      [ list "${emif_name}_mem_mem_dq[1]"       		"ddr5"      "PIN_G24"              ] \
      [ list "${emif_name}_mem_mem_dq[2]"       		"ddr5"      "PIN_L24"              ] \
      [ list "${emif_name}_mem_mem_dq[3]"       		"ddr5"      "PIN_K25"              ] \
      [ list "${emif_name}_mem_mem_dq[4]"       		"ddr5"      "PIN_G20"              ] \
      [ list "${emif_name}_mem_mem_dq[5]"       		"ddr5"      "PIN_H21"              ] \
      [ list "${emif_name}_mem_mem_dq[6]"       		"ddr5"      "PIN_K21"              ] \
      [ list "${emif_name}_mem_mem_dq[7]"       		"ddr5"      "PIN_L20"              ] \
      [ list "${emif_name}_mem_mem_dq[8]"       		"ddr5"      "PIN_A22"              ] \
      [ list "${emif_name}_mem_mem_dq[9]"       		"ddr5"      "PIN_B23"              ] \
      [ list "${emif_name}_mem_mem_dq[10]"      		"ddr5"      "PIN_D23"              ] \
      [ list "${emif_name}_mem_mem_dq[11]"      		"ddr5"      "PIN_E22"              ] \
      [ list "${emif_name}_mem_mem_dq[12]"      		"ddr5"      "PIN_A18"              ] \
      [ list "${emif_name}_mem_mem_dq[13]"      		"ddr5"      "PIN_B19"              ] \
      [ list "${emif_name}_mem_mem_dq[14]"      		"ddr5"      "PIN_D19"              ] \
      [ list "${emif_name}_mem_mem_dq[15]"      		"ddr5"      "PIN_E18"              ] \
      [ list "${emif_name}_mem_mem_dq[16]"      		"ddr5"      "PIN_N18"              ] \
      [ list "${emif_name}_mem_mem_dq[17]"      		"ddr5"      "PIN_P19"              ] \
      [ list "${emif_name}_mem_mem_dq[18]"     			"ddr5"      "PIN_U18"              ] \
      [ list "${emif_name}_mem_mem_dq[19]"      		"ddr5"      "PIN_T19"              ] \
      [ list "${emif_name}_mem_mem_dq[20]"      		"ddr5"      "PIN_N14"              ] \
      [ list "${emif_name}_mem_mem_dq[21]"      		"ddr5"      "PIN_P15"              ] \
      [ list "${emif_name}_mem_mem_dq[22]"      		"ddr5"      "PIN_T15"              ] \
      [ list "${emif_name}_mem_mem_dq[23]"      		"ddr5"      "PIN_U14"              ] \
      [ list "${emif_name}_mem_mem_dq[24]"      		"ddr5"      "PIN_G18"              ] \
      [ list "${emif_name}_mem_mem_dq[25]"      		"ddr5"      "PIN_H19"              ] \
      [ list "${emif_name}_mem_mem_dq[26]"      		"ddr5"      "PIN_L18"              ] \
      [ list "${emif_name}_mem_mem_dq[27]"      		"ddr5"      "PIN_K19"              ] \
      [ list "${emif_name}_mem_mem_dq[28]"      		"ddr5"      "PIN_G14"              ] \
      [ list "${emif_name}_mem_mem_dq[29]"      		"ddr5"      "PIN_H15"              ] \
      [ list "${emif_name}_mem_mem_dq[30]"      		"ddr5"      "PIN_L14"              ] \
      [ list "${emif_name}_mem_mem_dq[31]"      		"ddr5"      "PIN_K15"              ] \
      [ list "${emif_name}_mem_mem_dq[32]"      		"ddr5"      unused                 ] \
      [ list "${emif_name}_mem_mem_dq[33]"      		"ddr5"      unused                 ] \
      [ list "${emif_name}_mem_mem_dq[34]"      		"ddr5"      unused                 ] \
      [ list "${emif_name}_mem_mem_dq[35]"      		"ddr5"      unused                 ] \
      [ list "${emif_name}_mem_mem_dq[36]"      		"ddr5"      unused                 ] \
      [ list "${emif_name}_mem_mem_dq[37]"      		"ddr5"      unused                 ] \
      [ list "${emif_name}_mem_mem_dq[38]"      		"ddr5"      unused                 ] \
      [ list "${emif_name}_mem_mem_dq[39]"      		"ddr5"      unused                 ] \
      
]

