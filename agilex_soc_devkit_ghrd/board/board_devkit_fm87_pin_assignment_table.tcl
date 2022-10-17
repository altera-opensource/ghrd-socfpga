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
set fpga_clk_100_pin_list "CM29"
#set fpga_clk_100_iostandard "1.2 V"
set fpga_clk_100_iostandard "TRUE DIFFERENTIAL SIGNALING"

set fpga_reset_n_pin_list "AB53"
set fpga_reset_n_iostandard "1.2 V"
##SGPIO
set fpga_sgpio_sync_pin_list "Y49"
set fpga_sgpio_sync_iostandard "1.2 V"

set fpga_sgpio_clk_pin_list "W48"
set fpga_sgpio_clk_iostandard "1.2 V"

set fpga_sgpi_pin_list "T49"
set fpga_sgpi_iostandard "1.2 V"

set fpga_sgpo_pin_list "U48"
set fpga_sgpo_iostandard "1.2 V"

## Peripheral IOs
set fpga_led_pio_pin_list {
D43
B43
C42
A42
}

set fpga_led_pio_iostandard "1.2 V"
set fpga_led_pio_slewrate "0"

set fpga_dipsw_pio_pin_list {
H45
F45
J44
G44
}

set fpga_dipsw_pio_iostandard "1.2 V"
set fpga_dipsw_pio_weakpullup "ON"

set fpga_button_pio_pin_list {
CY47
CW48


}

set fpga_button_pio_iostandard "1.2 V"

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
dict set pin_assignment_table fpga_clk_100 location $fpga_clk_100_pin_list
dict set pin_assignment_table fpga_clk_100 io_standard $fpga_clk_100_iostandard
dict set pin_assignment_table fpga_clk_100 direction input
dict set pin_assignment_table fpga_clk_100 width_in_bits 1

dict set pin_assignment_table fpga_reset_n location $fpga_reset_n_pin_list
dict set pin_assignment_table fpga_reset_n io_standard $fpga_reset_n_iostandard
dict set pin_assignment_table fpga_reset_n direction input
dict set pin_assignment_table fpga_reset_n width 1

#if {$SGPIO_EN == 1} {
dict set pin_assignment_table fpga_sgpio_sync location $fpga_sgpio_sync_pin_list
dict set pin_assignment_table fpga_sgpio_sync io_standard $fpga_sgpio_sync_iostandard
dict set pin_assignment_table fpga_sgpio_sync direction input
dict set pin_assignment_table fpga_sgpio_sync width 1

dict set pin_assignment_table fpga_sgpio_clk location $fpga_sgpio_clk_pin_list
dict set pin_assignment_table fpga_sgpio_clk io_standard $fpga_sgpio_clk_iostandard
dict set pin_assignment_table fpga_sgpio_clk direction input
dict set pin_assignment_table fpga_sgpio_clk width 1

dict set pin_assignment_table fpga_sgpi location $fpga_sgpi_pin_list
dict set pin_assignment_table fpga_sgpi io_standard $fpga_sgpi_iostandard
dict set pin_assignment_table fpga_sgpi direction input
dict set pin_assignment_table fpga_sgpi width 1

dict set pin_assignment_table fpga_sgpo location $fpga_sgpo_pin_list
dict set pin_assignment_table fpga_sgpo io_standard $fpga_sgpo_iostandard
dict set pin_assignment_table fpga_sgpo direction output
dict set pin_assignment_table fpga_sgpo width 1
#}
#else {
#dict set pin_assignment_table fpga_led_pio location $fpga_led_pio_pin_list
#dict set pin_assignment_table fpga_led_pio io_standard $fpga_led_pio_iostandard
#dict set pin_assignment_table fpga_led_pio direction output
#dict set pin_assignment_table fpga_led_pio width_in_bits $fpga_led_pio_width
#dict set pin_assignment_table fpga_led_pio slewrate $fpga_led_pio_slewrate

#dict set pin_assignment_table fpga_dipsw_pio location $fpga_dipsw_pio_pin_list
#dict set pin_assignment_table fpga_dipsw_pio io_standard $fpga_dipsw_pio_iostandard
#dict set pin_assignment_table fpga_dipsw_pio direction input
#dict set pin_assignment_table fpga_dipsw_pio width_in_bits $fpga_dipsw_pio_width
#dict set pin_assignment_table fpga_dipsw_pio weakpullup $fpga_dipsw_pio_weakpullup
#}

dict set pin_assignment_table fpga_button_pio location $fpga_button_pio_pin_list
dict set pin_assignment_table fpga_button_pio io_standard $fpga_button_pio_iostandard
dict set pin_assignment_table fpga_button_pio direction input
dict set pin_assignment_table fpga_button_pio width_in_bits $fpga_button_pio_width

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
set pin_matrix [ list \
      [ list "NAME"                             "MEM"       "LOC"           "x16_r1"     "x24_r1"     "x32_r1"       "x40_r1"       "x64_r1"       "x72_r1"         ] \
      [ list "${emif_name}_pll_ref_clk"         "ddr4"      "PIN_U34"       "PIN_U34"     "PIN_U34"     "PIN_U34"      "PIN_U34"       "PIN_U34"       "PIN_U34"       ] \
      [ list "${emif_name}_oct_oct_rzqin"       "ddr4"      "PIN_W34"       "PIN_W34"     "PIN_W34"     "PIN_W34"      "PIN_W34"       "PIN_W34"       "PIN_W34"       ] \
      [ list "${emif_name}_mem_mem_a[0]"        "ddr4"      "PIN_L32"       "PIN_L32"     "PIN_L32"     "PIN_L32"      "PIN_L32"       "PIN_L32"       "PIN_L32"       ] \
      [ list "${emif_name}_mem_mem_a[1]"        "ddr4"      "PIN_M33"       "PIN_M33"     "PIN_M33"     "PIN_M33"      "PIN_M33"       "PIN_M33"       "PIN_M33"       ] \
      [ list "${emif_name}_mem_mem_a[2]"        "ddr4"      "PIN_R32"       "PIN_R32"     "PIN_R32"     "PIN_R32"      "PIN_R32"       "PIN_R32"       "PIN_R32"       ] \
      [ list "${emif_name}_mem_mem_a[3]"        "ddr4"      "PIN_P33"       "PIN_P33"     "PIN_P33"     "PIN_P33"      "PIN_P33"       "PIN_P33"       "PIN_P33"       ] \
      [ list "${emif_name}_mem_mem_a[4]"        "ddr4"      "PIN_L30"       "PIN_L30"     "PIN_L30"     "PIN_L30"      "PIN_L30"       "PIN_L30"       "PIN_L30"       ] \
      [ list "${emif_name}_mem_mem_a[5]"        "ddr4"      "PIN_M31"       "PIN_M31"     "PIN_M31"     "PIN_M31"      "PIN_M31"       "PIN_M31"       "PIN_M31"       ] \
      [ list "${emif_name}_mem_mem_a[6]"        "ddr4"      "PIN_R30"       "PIN_R30"     "PIN_R30"     "PIN_R30"      "PIN_R30"       "PIN_R30"       "PIN_R30"       ] \
      [ list "${emif_name}_mem_mem_a[7]"        "ddr4"      "PIN_P31"       "PIN_P31"     "PIN_P31"     "PIN_P31"      "PIN_P31"       "PIN_P31"       "PIN_P31"       ] \
      [ list "${emif_name}_mem_mem_a[8]"        "ddr4"      "PIN_L28"       "PIN_L28"     "PIN_L28"     "PIN_L28"      "PIN_L28"       "PIN_L28"       "PIN_L28"       ] \
      [ list "${emif_name}_mem_mem_a[9]"        "ddr4"      "PIN_M29"       "PIN_M29"     "PIN_M29"     "PIN_M29"      "PIN_M29"       "PIN_M29"       "PIN_M29"       ] \
      [ list "${emif_name}_mem_mem_a[10]"       "ddr4"      "PIN_R28"       "PIN_R28"     "PIN_R28"     "PIN_R28"      "PIN_R28"       "PIN_R28"       "PIN_R28"       ] \
      [ list "${emif_name}_mem_mem_a[11]"       "ddr4"      "PIN_P29"       "PIN_P29"     "PIN_P29"     "PIN_P29"      "PIN_P29"       "PIN_P29"       "PIN_P29"       ] \
      [ list "${emif_name}_mem_mem_a[12]"       "ddr4"      "PIN_Y35"       "PIN_Y35"     "PIN_Y35"     "PIN_Y35"      "PIN_Y35"       "PIN_Y35"       "PIN_Y35"       ] \
      [ list "${emif_name}_mem_mem_a[13]"       "ddr4"      "PIN_U32"       "PIN_U32"     "PIN_U32"     "PIN_U32"      "PIN_U32"       "PIN_U32"       "PIN_U32"       ] \
      [ list "${emif_name}_mem_mem_a[14]"       "ddr4"      "PIN_T33"       "PIN_T33"     "PIN_T33"     "PIN_T33"      "PIN_T33"       "PIN_T33"       "PIN_T33"       ] \
      [ list "${emif_name}_mem_mem_a[15]"       "ddr4"      "PIN_W32"       "PIN_W32"     "PIN_W32"     "PIN_W32"      "PIN_W32"       "PIN_W32"       "PIN_W32"       ] \
      [ list "${emif_name}_mem_mem_a[16]"       "ddr4"      "PIN_Y33"       "PIN_Y33"     "PIN_Y33"     "PIN_Y33"      "PIN_Y33"       "PIN_Y33"       "PIN_Y33"       ] \
      [ list "${emif_name}_mem_mem_ba[0]"       "ddr4"      "PIN_T31"       "PIN_T31"     "PIN_T31"     "PIN_T31"      "PIN_T31"       "PIN_T31"       "PIN_T31"       ] \
      [ list "${emif_name}_mem_mem_ba[1]"       "ddr4"      "PIN_W30"       "PIN_W30"     "PIN_W30"     "PIN_W30"      "PIN_W30"       "PIN_W30"       "PIN_W30"       ] \
      [ list "${emif_name}_mem_mem_bg[0]"       "ddr4"      "PIN_Y31"       "PIN_Y31"     "PIN_Y31"     "PIN_Y31"      "PIN_Y31"       "PIN_Y31"       "PIN_Y31"       ] \
      [ list "${emif_name}_mem_mem_act_n"       "ddr4"      "PIN_P39"       "PIN_P39"     "PIN_P39"     "PIN_P39"      "PIN_P39"       "PIN_P39"       "PIN_P39"       ] \
      [ list "${emif_name}_mem_mem_alert_n"     "ddr4"      "PIN_U30"       "PIN_U30"     "PIN_U30"     "PIN_U30"      "PIN_U30"       "PIN_U30"       "PIN_U30"       ] \
      [ list "${emif_name}_mem_mem_ck[0]"       "ddr4"      "PIN_L34"       "PIN_L34"     "PIN_L34"     "PIN_L34"      "PIN_L34"       "PIN_L34"       "PIN_L34"       ] \
      [ list "${emif_name}_mem_mem_ck_n[0]"     "ddr4"      "PIN_M35"       "PIN_M35"     "PIN_M35"     "PIN_M35"      "PIN_M35"       "PIN_M35"       "PIN_M35"       ] \
      [ list "${emif_name}_mem_mem_cke[0]"      "ddr4"      "PIN_R36"       "PIN_R36"     "PIN_R36"     "PIN_R36"      "PIN_R36"       "PIN_R36"       "PIN_R36"       ] \
      [ list "${emif_name}_mem_mem_cs_n[0]"     "ddr4"      "PIN_R38"       "PIN_R38"     "PIN_R38"     "PIN_R38"      "PIN_R38"       "PIN_R38"       "PIN_R38"       ] \
      [ list "${emif_name}_mem_mem_odt[0]"      "ddr4"      "PIN_L36"       "PIN_L36"     "PIN_L36"     "PIN_L36"      "PIN_L36"       "PIN_L36"       "PIN_L36"       ] \
      [ list "${emif_name}_mem_mem_par"         "ddr4"      "PIN_P35"       "PIN_P35"     "PIN_P35"     "PIN_P35"      "PIN_P35"       "PIN_P35"       "PIN_P35"       ] \
      [ list "${emif_name}_mem_mem_reset_n"     "ddr4"      "PIN_M39"       "PIN_M39"     "PIN_M39"     "PIN_M39"      "PIN_M39"       "PIN_M39"       "PIN_M39"       ] \
      [ list "${emif_name}_mem_mem_dqs[0]"      "ddr4"      "PIN_G24"       "PIN_G24"     "PIN_G24"     "PIN_G24"      "PIN_G24"       "PIN_G24"       "PIN_G24"       ] \
      [ list "${emif_name}_mem_mem_dqs[1]"      "ddr4"      "PIN_E28"       "PIN_E28"     "PIN_E28"     "PIN_E28"      "PIN_E28"       "PIN_E28"       "PIN_E28"       ] \
      [ list "${emif_name}_mem_mem_dqs[2]"      "ddr4"      "PIN_G30"       unused        "PIN_G30"     "PIN_G30"      "PIN_G30"       "PIN_G30"       "PIN_G30"       ] \
      [ list "${emif_name}_mem_mem_dqs[3]"      "ddr4"      "PIN_A34"       unused        unused        "PIN_A34"      "PIN_A34"       "PIN_A34"       "PIN_A34"       ] \
      [ list "${emif_name}_mem_mem_dqs[4]"      "ddr4"      "PIN_AA38"      unused        unused        unused         "PIN_AA38"      "PIN_AA38"      "PIN_AA38"      ] \
      [ list "${emif_name}_mem_mem_dqs[5]"      "ddr4"      "PIN_U38"       unused        unused        unused         unused          "PIN_U38"       "PIN_U38"       ] \
      [ list "${emif_name}_mem_mem_dqs[6]"      "ddr4"      "PIN_G42"       unused        unused        unused         unused          "PIN_G42"       "PIN_G42"       ] \
      [ list "${emif_name}_mem_mem_dqs[7]"      "ddr4"      "PIN_L42"       unused        unused        unused         unused          "PIN_L42"       "PIN_L42"       ] \
      [ list "${emif_name}_mem_mem_dqs[8]"      "ddr4"      "PIN_AA32"      unused        unused        unused         unused          "PIN_AA32"      "PIN_AA32"      ] \
      [ list "${emif_name}_mem_mem_dqs_n[0]"    "ddr4"      "PIN_F25"       "PIN_F25"     "PIN_F25"     "PIN_F25"      "PIN_F25"       "PIN_F25"       "PIN_F25"       ] \
      [ list "${emif_name}_mem_mem_dqs_n[1]"    "ddr4"      "PIN_D29"       "PIN_D29"     "PIN_D29"     "PIN_D29"      "PIN_D29"       "PIN_D29"       "PIN_D29"       ] \
      [ list "${emif_name}_mem_mem_dqs_n[2]"    "ddr4"      "PIN_F31"       unused        "PIN_F31"     "PIN_F31"      "PIN_F31"       "PIN_F31"       "PIN_F31"       ] \
      [ list "${emif_name}_mem_mem_dqs_n[3]"    "ddr4"      "PIN_B35"       unused        unused        "PIN_B35"      "PIN_B35"       "PIN_B35"       "PIN_B35"       ] \
      [ list "${emif_name}_mem_mem_dqs_n[4]"    "ddr4"      "PIN_AB39"      unused        unused        unused         "PIN_AB39"      "PIN_AB39"      "PIN_AB39"      ] \
      [ list "${emif_name}_mem_mem_dqs_n[5]"    "ddr4"      "PIN_T39"       unused        unused        unused         unused          "PIN_T39"       "PIN_T39"       ] \
      [ list "${emif_name}_mem_mem_dqs_n[6]"    "ddr4"      "PIN_F43"       unused        unused        unused         unused          "PIN_F43"       "PIN_F43"       ] \
      [ list "${emif_name}_mem_mem_dqs_n[7]"    "ddr4"      "PIN_M43"       unused        unused        unused         unused          "PIN_M43"       "PIN_M43"       ] \
      [ list "${emif_name}_mem_mem_dqs_n[8]"    "ddr4"      "PIN_AB33"      unused        unused        unused         unused          "PIN_AB33"      "PIN_AB33"      ] \
      [ list "${emif_name}_mem_mem_dbi_n[0]"    "ddr4"      "PIN_J24"       "PIN_J24"     "PIN_J24"     "PIN_J24"      "PIN_J24"       "PIN_J24"       "PIN_J24"       ] \
      [ list "${emif_name}_mem_mem_dbi_n[1]"    "ddr4"      "PIN_A28"       "PIN_A28"     "PIN_A28"     "PIN_A28"      "PIN_A28"       "PIN_A28"       "PIN_A28"       ] \
      [ list "${emif_name}_mem_mem_dbi_n[2]"    "ddr4"      "PIN_J30"       unused        "PIN_J30"     "PIN_J30"      "PIN_J30"       "PIN_J30"       "PIN_J30"       ] \
      [ list "${emif_name}_mem_mem_dbi_n[3]"    "ddr4"      "PIN_E34"       unused        unused        "PIN_E34"      "PIN_E34"       "PIN_E34"       "PIN_E34"       ] \
      [ list "${emif_name}_mem_mem_dbi_n[4]"    "ddr4"      "PIN_AE38"      unused        unused        unused         "PIN_AE38"      "PIN_AE38"      "PIN_AE38"      ] \
      [ list "${emif_name}_mem_mem_dbi_n[5]"    "ddr4"      "PIN_W38"       unused        unused        unused         unused          "PIN_W38"       "PIN_W38"       ] \
      [ list "${emif_name}_mem_mem_dbi_n[6]"    "ddr4"      "PIN_J42"       unused        unused        unused         unused          "PIN_J42"       "PIN_J42"       ] \
      [ list "${emif_name}_mem_mem_dbi_n[7]"    "ddr4"      "PIN_R42"       unused        unused        unused         unused          "PIN_R42"       "PIN_R42"       ] \
      [ list "${emif_name}_mem_mem_dbi_n[8]"    "ddr4"      "PIN_AE32"      unused        unused        unused         unused          "PIN_AE32"      "PIN_AE32"      ] \
      [ list "${emif_name}_mem_mem_dq[0]"       "ddr4"      "PIN_G26"       "PIN_G26"     "PIN_G26"     "PIN_G26"      "PIN_G26"       "PIN_G26"       "PIN_G26"       ] \
      [ list "${emif_name}_mem_mem_dq[1]"       "ddr4"      "PIN_F27"       "PIN_F27"     "PIN_F27"     "PIN_F27"      "PIN_F27"       "PIN_F27"       "PIN_F27"       ] \
      [ list "${emif_name}_mem_mem_dq[2]"       "ddr4"      "PIN_J26"       "PIN_J26"     "PIN_J26"     "PIN_J26"      "PIN_J26"       "PIN_J26"       "PIN_J26"       ] \
      [ list "${emif_name}_mem_mem_dq[3]"       "ddr4"      "PIN_K27"       "PIN_K27"     "PIN_K27"     "PIN_K27"      "PIN_K27"       "PIN_K27"       "PIN_K27"       ] \
      [ list "${emif_name}_mem_mem_dq[4]"       "ddr4"      "PIN_G22"       "PIN_G22"     "PIN_G22"     "PIN_G22"      "PIN_G22"       "PIN_G22"       "PIN_G22"       ] \
      [ list "${emif_name}_mem_mem_dq[5]"       "ddr4"      "PIN_F23"       "PIN_F23"     "PIN_F23"     "PIN_F23"      "PIN_F23"       "PIN_F23"       "PIN_F23"       ] \
      [ list "${emif_name}_mem_mem_dq[6]"       "ddr4"      "PIN_J22"       "PIN_J22"     "PIN_J22"     "PIN_J22"      "PIN_J22"       "PIN_J22"       "PIN_J22"       ] \
      [ list "${emif_name}_mem_mem_dq[7]"       "ddr4"      "PIN_K23"       "PIN_K23"     "PIN_K23"     "PIN_K23"      "PIN_K23"       "PIN_K23"       "PIN_K23"       ] \
      [ list "${emif_name}_mem_mem_dq[8]"       "ddr4"      "PIN_A30"       "PIN_A30"     "PIN_A30"     "PIN_A30"      "PIN_A30"       "PIN_A30"       "PIN_A30"       ] \
      [ list "${emif_name}_mem_mem_dq[9]"       "ddr4"      "PIN_B31"       "PIN_B31"     "PIN_B31"     "PIN_B31"      "PIN_B31"       "PIN_B31"       "PIN_B31"       ] \
      [ list "${emif_name}_mem_mem_dq[10]"      "ddr4"      "PIN_D31"       "PIN_D31"     "PIN_D31"     "PIN_D31"      "PIN_D31"       "PIN_D31"       "PIN_D31"       ] \
      [ list "${emif_name}_mem_mem_dq[11]"      "ddr4"      "PIN_E30"       "PIN_E30"     "PIN_E30"     "PIN_E30"      "PIN_E30"       "PIN_E30"       "PIN_E30"       ] \
      [ list "${emif_name}_mem_mem_dq[12]"      "ddr4"      "PIN_A26"       "PIN_A26"     "PIN_A26"     "PIN_A26"      "PIN_A26"       "PIN_A26"       "PIN_A26"       ] \
      [ list "${emif_name}_mem_mem_dq[13]"      "ddr4"      "PIN_B27"       "PIN_B27"     "PIN_B27"     "PIN_B27"      "PIN_B27"       "PIN_B27"       "PIN_B27"       ] \
      [ list "${emif_name}_mem_mem_dq[14]"      "ddr4"      "PIN_E26"       "PIN_E26"     "PIN_E26"     "PIN_E26"      "PIN_E26"       "PIN_E26"       "PIN_E26"       ] \
      [ list "${emif_name}_mem_mem_dq[15]"      "ddr4"      "PIN_D27"       "PIN_D27"     "PIN_D27"     "PIN_D27"      "PIN_D27"       "PIN_D27"       "PIN_D27"       ] \
      [ list "${emif_name}_mem_mem_dq[16]"      "ddr4"      "PIN_G32"       unused        "PIN_G32"     "PIN_G32"      "PIN_G32"       "PIN_G32"       "PIN_G32"       ] \
      [ list "${emif_name}_mem_mem_dq[17]"      "ddr4"      "PIN_K33"       unused        "PIN_K33"     "PIN_K33"      "PIN_K33"       "PIN_K33"       "PIN_K33"       ] \
      [ list "${emif_name}_mem_mem_dq[18]"      "ddr4"      "PIN_J32"       unused        "PIN_J32"     "PIN_J32"      "PIN_J32"       "PIN_J32"       "PIN_J32"       ] \
      [ list "${emif_name}_mem_mem_dq[19]"      "ddr4"      "PIN_F33"       unused        "PIN_F33"     "PIN_F33"      "PIN_F33"       "PIN_F33"       "PIN_F33"       ] \
      [ list "${emif_name}_mem_mem_dq[20]"      "ddr4"      "PIN_G28"       unused        "PIN_G28"     "PIN_G28"      "PIN_G28"       "PIN_G28"       "PIN_G28"       ] \
      [ list "${emif_name}_mem_mem_dq[21]"      "ddr4"      "PIN_F29"       unused        "PIN_F29"     "PIN_F29"      "PIN_F29"       "PIN_F29"       "PIN_F29"       ] \
      [ list "${emif_name}_mem_mem_dq[22]"      "ddr4"      "PIN_J28"       unused        "PIN_J28"     "PIN_J28"      "PIN_J28"       "PIN_J28"       "PIN_J28"       ] \
      [ list "${emif_name}_mem_mem_dq[23]"      "ddr4"      "PIN_K29"       unused        "PIN_K29"     "PIN_K29"      "PIN_K29"       "PIN_K29"       "PIN_K29"       ] \
      [ list "${emif_name}_mem_mem_dq[24]"      "ddr4"      "PIN_A36"       unused        unused        "PIN_A36"      "PIN_A36"       "PIN_A36"       "PIN_A36"       ] \
      [ list "${emif_name}_mem_mem_dq[25]"      "ddr4"      "PIN_B37"       unused        unused        "PIN_B37"      "PIN_B37"       "PIN_B37"       "PIN_B37"       ] \
      [ list "${emif_name}_mem_mem_dq[26]"      "ddr4"      "PIN_E36"       unused        unused        "PIN_E36"      "PIN_E36"       "PIN_E36"       "PIN_E36"       ] \
      [ list "${emif_name}_mem_mem_dq[27]"      "ddr4"      "PIN_D37"       unused        unused        "PIN_D37"      "PIN_D37"       "PIN_D37"       "PIN_D37"       ] \
      [ list "${emif_name}_mem_mem_dq[28]"      "ddr4"      "PIN_A32"       unused        unused        "PIN_A32"      "PIN_A32"       "PIN_A32"       "PIN_A32"       ] \
      [ list "${emif_name}_mem_mem_dq[29]"      "ddr4"      "PIN_B33"       unused        unused        "PIN_B33"      "PIN_B33"       "PIN_B33"       "PIN_B33"       ] \
      [ list "${emif_name}_mem_mem_dq[30]"      "ddr4"      "PIN_E32"       unused        unused        "PIN_E32"      "PIN_E32"       "PIN_E32"       "PIN_E32"       ] \
      [ list "${emif_name}_mem_mem_dq[31]"      "ddr4"      "PIN_D33"       unused        unused        "PIN_D33"      "PIN_D33"       "PIN_D33"       "PIN_D33"       ] \
      [ list "${emif_name}_mem_mem_dq[32]"      "ddr4"      "PIN_AE40"      unused        unused        unused         "PIN_AE40"      "PIN_AE40"      "PIN_AE40"      ] \
      [ list "${emif_name}_mem_mem_dq[33]"      "ddr4"      "PIN_AA40"      unused        unused        unused         "PIN_AA40"      "PIN_AA40"      "PIN_AA40"      ] \
      [ list "${emif_name}_mem_mem_dq[34]"      "ddr4"      "PIN_AD41"      unused        unused        unused         "PIN_AD41"      "PIN_AD41"      "PIN_AD41"      ] \
      [ list "${emif_name}_mem_mem_dq[35]"      "ddr4"      "PIN_AB41"      unused        unused        unused         "PIN_AB41"      "PIN_AB41"      "PIN_AB41"      ] \
      [ list "${emif_name}_mem_mem_dq[36]"      "ddr4"      "PIN_AD37"      unused        unused        unused         "PIN_AD37"      "PIN_AD37"      "PIN_AD37"      ] \
      [ list "${emif_name}_mem_mem_dq[37]"      "ddr4"      "PIN_AE36"      unused        unused        unused         "PIN_AE36"      "PIN_AE36"      "PIN_AE36"      ] \
      [ list "${emif_name}_mem_mem_dq[38]"      "ddr4"      "PIN_AB37"      unused        unused        unused         "PIN_AB37"      "PIN_AB37"      "PIN_AB37"      ] \
      [ list "${emif_name}_mem_mem_dq[39]"      "ddr4"      "PIN_AA36"      unused        unused        unused         "PIN_AA36"      "PIN_AA36"      "PIN_AA36"      ] \
      [ list "${emif_name}_mem_mem_dq[40]"      "ddr4"      "PIN_T41"       unused        unused        unused          unused         "PIN_T41"       "PIN_T41"       ] \
      [ list "${emif_name}_mem_mem_dq[41]"      "ddr4"      "PIN_U40"       unused        unused        unused          unused         "PIN_U40"       "PIN_U40"       ] \
      [ list "${emif_name}_mem_mem_dq[42]"      "ddr4"      "PIN_Y41"       unused        unused        unused          unused         "PIN_Y41"       "PIN_Y41"       ] \
      [ list "${emif_name}_mem_mem_dq[43]"      "ddr4"      "PIN_W40"       unused        unused        unused          unused         "PIN_W40"       "PIN_W40"       ] \
      [ list "${emif_name}_mem_mem_dq[44]"      "ddr4"      "PIN_U36"       unused        unused        unused          unused         "PIN_U36"       "PIN_U36"       ] \
      [ list "${emif_name}_mem_mem_dq[45]"      "ddr4"      "PIN_T37"       unused        unused        unused          unused         "PIN_T37"       "PIN_T37"       ] \
      [ list "${emif_name}_mem_mem_dq[46]"      "ddr4"      "PIN_W36"       unused        unused        unused          unused         "PIN_W36"       "PIN_W36"       ] \
      [ list "${emif_name}_mem_mem_dq[47]"      "ddr4"      "PIN_Y37"       unused        unused        unused          unused         "PIN_Y37"       "PIN_Y37"       ] \
      [ list "${emif_name}_mem_mem_dq[48]"      "ddr4"      "PIN_F45"       unused        unused        unused          unused         "PIN_F45"       "PIN_F45"       ] \
      [ list "${emif_name}_mem_mem_dq[49]"      "ddr4"      "PIN_G44"       unused        unused        unused          unused         "PIN_G44"       "PIN_G44"       ] \
      [ list "${emif_name}_mem_mem_dq[50]"      "ddr4"      "PIN_K45"       unused        unused        unused          unused         "PIN_K45"       "PIN_K45"       ] \
      [ list "${emif_name}_mem_mem_dq[51]"      "ddr4"      "PIN_J44"       unused        unused        unused          unused         "PIN_J44"       "PIN_J44"       ] \
      [ list "${emif_name}_mem_mem_dq[52]"      "ddr4"      "PIN_J40"       unused        unused        unused          unused         "PIN_J40"       "PIN_J40"       ] \
      [ list "${emif_name}_mem_mem_dq[53]"      "ddr4"      "PIN_K41"       unused        unused        unused          unused         "PIN_K41"       "PIN_K41"       ] \
      [ list "${emif_name}_mem_mem_dq[54]"      "ddr4"      "PIN_G40"       unused        unused        unused          unused         "PIN_G40"       "PIN_G40"       ] \
      [ list "${emif_name}_mem_mem_dq[55]"      "ddr4"      "PIN_F41"       unused        unused        unused          unused         "PIN_F41"       "PIN_F41"       ] \
      [ list "${emif_name}_mem_mem_dq[56]"      "ddr4"      "PIN_L44"       unused        unused        unused          unused         "PIN_L44"       "PIN_L44"       ] \
      [ list "${emif_name}_mem_mem_dq[57]"      "ddr4"      "PIN_P45"       unused        unused        unused          unused         "PIN_P45"       "PIN_P45"       ] \
      [ list "${emif_name}_mem_mem_dq[58]"      "ddr4"      "PIN_M45"       unused        unused        unused          unused         "PIN_M45"       "PIN_M45"       ] \
      [ list "${emif_name}_mem_mem_dq[59]"      "ddr4"      "PIN_R44"       unused        unused        unused          unused         "PIN_R44"       "PIN_R44"       ] \
      [ list "${emif_name}_mem_mem_dq[60]"      "ddr4"      "PIN_L40"       unused        unused        unused          unused         "PIN_L40"       "PIN_L40"       ] \
      [ list "${emif_name}_mem_mem_dq[61]"      "ddr4"      "PIN_M41"       unused        unused        unused          unused         "PIN_M41"       "PIN_M41"       ] \
      [ list "${emif_name}_mem_mem_dq[62]"      "ddr4"      "PIN_R40"       unused        unused        unused          unused         "PIN_R40"       "PIN_R40"       ] \
      [ list "${emif_name}_mem_mem_dq[63]"      "ddr4"      "PIN_P41"       unused        unused        unused          unused         "PIN_P41"       "PIN_P41"       ] \
      [ list "${emif_name}_mem_mem_dq[64]"      "ddr4"      "PIN_AA34"      unused        unused        unused          unused         unused          "PIN_AA34"      ] \
      [ list "${emif_name}_mem_mem_dq[65]"      "ddr4"      "PIN_AB35"      unused        unused        unused          unused         unused          "PIN_AB35"      ] \
      [ list "${emif_name}_mem_mem_dq[66]"      "ddr4"      "PIN_AE34"      unused        unused        unused          unused         unused          "PIN_AE34"      ] \
      [ list "${emif_name}_mem_mem_dq[67]"      "ddr4"      "PIN_AD35"      unused        unused        unused          unused         unused          "PIN_AD35"      ] \
      [ list "${emif_name}_mem_mem_dq[68]"      "ddr4"      "PIN_AA30"      unused        unused        unused          unused         unused          "PIN_AA30"      ] \
      [ list "${emif_name}_mem_mem_dq[69]"      "ddr4"      "PIN_AB31"      unused        unused        unused          unused         unused          "PIN_AB31"      ] \
      [ list "${emif_name}_mem_mem_dq[70]"      "ddr4"      "PIN_AE30"      unused        unused        unused          unused         unused          "PIN_AE30"      ] \
      [ list "${emif_name}_mem_mem_dq[71]"      "ddr4"      "PIN_AD31"      unused        unused        unused          unused         unused          "PIN_AD31"      ] \
]