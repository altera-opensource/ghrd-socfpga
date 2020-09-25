#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2017-2020 Intel Corporation.
#
#****************************************************************************
#
# This file define the location, io standard, current drive strength, signal width, 
# and signal direction settings for every port available on the FPGA side for devkit board.
#
#****************************************************************************

source ./arguments_solver.tcl

#define all the location assignments in sequence for specific port data with signal width more than one
if {$board_rev == "A1"} {
    set fpga_led_pio_pin_list {
    A24
    F22
    B24
    E22
    }

    set fpga_dipsw_pio_pin_list {
    B23
    C23
    E23
    E24
    }

    set fpga_button_pio_pin_list {
    A26
    A25
    D23
    D24
    }
} else {
    set fpga_led_pio_pin_list {
    H21
    J21
    L19
    K19
    }

    set fpga_dipsw_pio_pin_list {
    N21
    P21
    N20
    P20
    }

    set fpga_button_pio_pin_list {
    BG17
    BE17
    BH18
    BJ19
    }
}

set fpga_led_pio_qsys_exported_port_list {
led_pio_external_connection_in_port
led_pio_external_connection_out_port
}

set pcie_tx_out_pin_list {
AE3
AC3
AD1
AA3
AB1
W3
Y1
V1
}

set pcie_rx_in_pin_list {
AC7
AD5
AA7
AB5
W7
Y5
V5
U7
}

dict set pin_assignment_table fpga_clk_100 location AW10
dict set pin_assignment_table fpga_clk_100 io_standard "1.8 V"
dict set pin_assignment_table fpga_clk_100 direction input
dict set pin_assignment_table fpga_clk_100 width_in_bits 1
dict set pin_assignment_table fpga_clk_100 qsys_exported_port "clk_100_clk"

dict set pin_assignment_table fpga_reset_n location BC15
dict set pin_assignment_table fpga_reset_n io_standard "1.8 V"
dict set pin_assignment_table fpga_reset_n direction input
dict set pin_assignment_table fpga_reset_n width 1
dict set pin_assignment_table fpga_reset_n qsys_exported_port "reset_reset_n"

dict set pin_assignment_table fpga_led_pio location $fpga_led_pio_pin_list
dict set pin_assignment_table fpga_led_pio io_standard "1.8 V"
dict set pin_assignment_table fpga_led_pio direction output
dict set pin_assignment_table fpga_led_pio width_in_bits 4
dict set pin_assignment_table fpga_led_pio qsys_exported_port $fpga_led_pio_qsys_exported_port_list

dict set pin_assignment_table fpga_dipsw_pio location $fpga_dipsw_pio_pin_list
dict set pin_assignment_table fpga_dipsw_pio io_standard "1.8 V"
dict set pin_assignment_table fpga_dipsw_pio direction input
dict set pin_assignment_table fpga_dipsw_pio width_in_bits 4
dict set pin_assignment_table fpga_dipsw_pio qsys_exported_port "dipsw_pio_external_connection_export"

dict set pin_assignment_table fpga_button_pio location $fpga_button_pio_pin_list
dict set pin_assignment_table fpga_button_pio io_standard "1.8 V"
dict set pin_assignment_table fpga_button_pio direction input
dict set pin_assignment_table fpga_button_pio width_in_bits 4
dict set pin_assignment_table fpga_button_pio qsys_exported_port "button_pio_external_connection_export"

if {$fpga_pcie == 1} {
#rebuild list that follow the pcie_count
set pcie_tx_out_pin_list_rebuild [lrange $pcie_tx_out_pin_list 0 [expr {$pcie_count-1}]]
dict set pin_assignment_table pcie_hip_serial_tx_out location $pcie_tx_out_pin_list_rebuild
dict set pin_assignment_table pcie_hip_serial_tx_out io_standard "HIGH SPEED DIFFERENTIAL I/O"
dict set pin_assignment_table pcie_hip_serial_tx_out direction output
dict set pin_assignment_table pcie_hip_serial_tx_out width_in_bits $pcie_count
dict set pin_assignment_table pcie_hip_serial_tx_out qsys_exported_port "pcie_hip_serial_tx_out"

set pcie_rx_in_pin_list_rebuild [lrange $pcie_rx_in_pin_list 0 [expr {$pcie_count-1}]]
dict set pin_assignment_table pcie_hip_serial_rx_in location $pcie_rx_in_pin_list_rebuild
dict set pin_assignment_table pcie_hip_serial_rx_in io_standard "HIGH SPEED DIFFERENTIAL I/O"
dict set pin_assignment_table pcie_hip_serial_rx_in direction input
dict set pin_assignment_table pcie_hip_serial_rx_in width_in_bits $pcie_count
dict set pin_assignment_table pcie_hip_serial_rx_in qsys_exported_port "pcie_hip_serial_rx_in"

dict set pin_assignment_table pcie_hip_refclk_clk location V12
dict set pin_assignment_table pcie_hip_refclk_clk io_standard "HCSL"
dict set pin_assignment_table pcie_hip_refclk_clk direction input
dict set pin_assignment_table pcie_hip_refclk_clk width_in_bits 1
dict set pin_assignment_table pcie_hip_refclk_clk qsys_exported_port "pcie_hip_refclk_clk"

dict set pin_assignment_table pcie_hip_npor_pin_perst location AE14
dict set pin_assignment_table pcie_hip_npor_pin_perst io_standard "3.0-V LVTTL"
dict set pin_assignment_table pcie_hip_npor_pin_perst direction input
dict set pin_assignment_table pcie_hip_npor_pin_perst width_in_bits 1
dict set pin_assignment_table pcie_hip_npor_pin_perst qsys_exported_port "pcie_hip_npor_pin_perst"
}

if {$hps_mge_en == 1} {
dict set pin_assignment_table enet_refclk location V9
dict set pin_assignment_table enet_refclk io_standard "LVDS"
dict set pin_assignment_table enet_refclk direction input
dict set pin_assignment_table enet_refclk width_in_bits 1
dict set pin_assignment_table enet_refclk qsys_exported_port "enet_refclk"

dict set pin_assignment_table emac1_sgmii_rxp location J7
dict set pin_assignment_table emac1_sgmii_rxp io_standard "HIGH SPEED DIFFERENTIAL I/O"
dict set pin_assignment_table emac1_sgmii_rxp direction input
dict set pin_assignment_table emac1_sgmii_rxp width_in_bits 1
dict set pin_assignment_table emac1_sgmii_rxp qsys_exported_port "emac1_sgmii_rxp"

dict set pin_assignment_table emac1_sgmii_txp location H1
dict set pin_assignment_table emac1_sgmii_txp io_standard "HIGH SPEED DIFFERENTIAL I/O"
dict set pin_assignment_table emac1_sgmii_txp direction output
dict set pin_assignment_table emac1_sgmii_txp width_in_bits 1
dict set pin_assignment_table emac1_sgmii_txp qsys_exported_port "emac1_sgmii_txp"

dict set pin_assignment_table emac1_mdc location AV18
dict set pin_assignment_table emac1_mdc io_standard "1.8 V"
dict set pin_assignment_table emac1_mdc direction output
dict set pin_assignment_table emac1_mdc width_in_bits 1
dict set pin_assignment_table emac1_mdc qsys_exported_port "emac1_mdc"

dict set pin_assignment_table emac1_mdio location AW16
dict set pin_assignment_table emac1_mdio io_standard "1.8 V"
dict set pin_assignment_table emac1_mdio direction inout
dict set pin_assignment_table emac1_mdio width_in_bits 1
dict set pin_assignment_table emac1_mdio qsys_exported_port "emac1_mdio"

dict set pin_assignment_table emac1_phy_irq location BH12
dict set pin_assignment_table emac1_phy_irq io_standard "1.8 V"
dict set pin_assignment_table emac1_phy_irq direction output
dict set pin_assignment_table emac1_phy_irq width_in_bits 1
dict set pin_assignment_table emac1_phy_irq qsys_exported_port "emac1_phy_irq"

dict set pin_assignment_table emac1_phy_rst_n location BB13
dict set pin_assignment_table emac1_phy_rst_n io_standard "1.8 V"
dict set pin_assignment_table emac1_phy_rst_n direction inout
dict set pin_assignment_table emac1_phy_rst_n width_in_bits 1
dict set pin_assignment_table emac1_phy_rst_n qsys_exported_port "emac1_phy_rst_n"
if {$sgmii_count == 2} {
dict set pin_assignment_table emac2_sgmii_rxp location F5
dict set pin_assignment_table emac2_sgmii_rxp io_standard "HIGH SPEED DIFFERENTIAL I/O"
dict set pin_assignment_table emac2_sgmii_rxp direction input
dict set pin_assignment_table emac2_sgmii_rxp width_in_bits 1
dict set pin_assignment_table emac2_sgmii_rxp qsys_exported_port "emac2_sgmii_rxp"

dict set pin_assignment_table emac2_sgmii_txp location J3
dict set pin_assignment_table emac2_sgmii_txp io_standard "HIGH SPEED DIFFERENTIAL I/O"
dict set pin_assignment_table emac2_sgmii_txp direction output
dict set pin_assignment_table emac2_sgmii_txp width_in_bits 1
dict set pin_assignment_table emac2_sgmii_txp qsys_exported_port "emac2_sgmii_txp"

dict set pin_assignment_table emac2_mdc location AY18
dict set pin_assignment_table emac2_mdc io_standard "1.8 V"
dict set pin_assignment_table emac2_mdc direction output
dict set pin_assignment_table emac2_mdc width_in_bits 1
dict set pin_assignment_table emac2_mdc qsys_exported_port "emac2_mdc"

dict set pin_assignment_table emac2_mdio location AW18
dict set pin_assignment_table emac2_mdio io_standard "1.8 V"
dict set pin_assignment_table emac2_mdio direction inout
dict set pin_assignment_table emac2_mdio width_in_bits 1
dict set pin_assignment_table emac2_mdio qsys_exported_port "emac2_mdio"


dict set pin_assignment_table emac2_phy_irq location AV17
dict set pin_assignment_table emac2_phy_irq io_standard "1.8 V"
dict set pin_assignment_table emac2_phy_irq direction output
dict set pin_assignment_table emac2_phy_irq width_in_bits 1
dict set pin_assignment_table emac2_phy_irq qsys_exported_port "emac2_phy_irq"

dict set pin_assignment_table emac2_phy_rst_n location AV16
dict set pin_assignment_table emac2_phy_rst_n io_standard "1.8 V"
dict set pin_assignment_table emac2_phy_rst_n direction inout
dict set pin_assignment_table emac2_phy_rst_n width_in_bits 1
dict set pin_assignment_table emac2_phy_rst_n qsys_exported_port "emac2_phy_rst_n"
}
}

if {$hps_mge_10gbe_1588_en == 1} {
dict set pin_assignment_table mge_refclk_125m location AT9
dict set pin_assignment_table mge_refclk_125m io_standard "LVDS"
dict set pin_assignment_table mge_refclk_125m direction input
dict set pin_assignment_table mge_refclk_125m width_in_bits 1
dict set pin_assignment_table mge_refclk_125m qsys_exported_port "mge_refclk_125m"

dict set pin_assignment_table mge_refclk_csr location V9
dict set pin_assignment_table mge_refclk_csr io_standard "LVDS"
dict set pin_assignment_table mge_refclk_csr direction input
dict set pin_assignment_table mge_refclk_csr width_in_bits 1
dict set pin_assignment_table mge_refclk_csr qsys_exported_port "mge_refclk_csr"

dict set pin_assignment_table mge_refclk_10g location AM12
dict set pin_assignment_table mge_refclk_10g io_standard "LVDS"
dict set pin_assignment_table mge_refclk_10g direction input
dict set pin_assignment_table mge_refclk_10g width_in_bits 1
dict set pin_assignment_table mge_refclk_10g qsys_exported_port "mge_refclk_10g"

dict set pin_assignment_table mge_10gbe_rxp[0] location BH9
dict set pin_assignment_table mge_10gbe_rxp[0] io_standard "CURRENT MODE LOGIC (CML)"
dict set pin_assignment_table mge_10gbe_rxp[0] direction input
dict set pin_assignment_table mge_10gbe_rxp[0] width_in_bits 1

dict set pin_assignment_table mge_10gbe_txp[0] location BJ4
dict set pin_assignment_table mge_10gbe_txp[0] io_standard "HSSI DIFFERENTIAL I/O"
dict set pin_assignment_table mge_10gbe_txp[0] direction output
dict set pin_assignment_table mge_10gbe_txp[0] width_in_bits 1

dict set pin_assignment_table sfpa_txdisable location AB14
dict set pin_assignment_table sfpa_txdisable io_standard "1.8 V"
dict set pin_assignment_table sfpa_txdisable direction output
dict set pin_assignment_table sfpa_txdisable width_in_bits 1
dict set pin_assignment_table sfpa_txdisable qsys_exported_port "sfpa_txdisable"

dict set pin_assignment_table sfpa_ratesel location {AB13 AD14}
dict set pin_assignment_table sfpa_ratesel io_standard "1.8 V"
dict set pin_assignment_table sfpa_ratesel direction inout
dict set pin_assignment_table sfpa_ratesel width_in_bits 2
dict set pin_assignment_table sfpa_ratesel qsys_exported_port "sfpa_ratesel"

# dict set pin_assignment_table emac1_phy_irq location AD14
# dict set pin_assignment_table emac1_phy_irq io_standard "1.8 V"
# dict set pin_assignment_table emac1_phy_irq direction output
# dict set pin_assignment_table emac1_phy_irq width_in_bits 1
# dict set pin_assignment_table emac1_phy_irq qsys_exported_port "sfpa_ratesel[1]"

dict set pin_assignment_table sfpa_los location AC15
dict set pin_assignment_table sfpa_los io_standard "1.8 V"
dict set pin_assignment_table sfpa_los direction inout
dict set pin_assignment_table sfpa_los width_in_bits 1
dict set pin_assignment_table sfpa_los qsys_exported_port "sfpa_los"

dict set pin_assignment_table sfpa_txfault location AD15
dict set pin_assignment_table sfpa_txfault io_standard "1.8 V"
dict set pin_assignment_table sfpa_txfault direction inout
dict set pin_assignment_table sfpa_txfault width_in_bits 1
dict set pin_assignment_table sfpa_txfault qsys_exported_port "sfpa_txfault"

dict set pin_assignment_table sfpa_mod0_prstn location AC14
dict set pin_assignment_table sfpa_mod0_prstn io_standard "1.8 V"
dict set pin_assignment_table sfpa_mod0_prstn direction inout
dict set pin_assignment_table sfpa_mod0_prstn width_in_bits 1
dict set pin_assignment_table sfpa_mod0_prstn qsys_exported_port "sfpa_mod0_prstn"

dict set pin_assignment_table sfpa_i2c_scl location AY27
dict set pin_assignment_table sfpa_i2c_scl io_standard "1.8 V"
dict set pin_assignment_table sfpa_i2c_scl direction inout
dict set pin_assignment_table sfpa_i2c_scl width_in_bits 1
dict set pin_assignment_table sfpa_i2c_scl qsys_exported_port "sfpa_i2c_scl"

dict set pin_assignment_table sfpa_i2c_sda location AY28
dict set pin_assignment_table sfpa_i2c_sda io_standard "1.8 V"
dict set pin_assignment_table sfpa_i2c_sda direction inout
dict set pin_assignment_table sfpa_i2c_sda width_in_bits 1
dict set pin_assignment_table sfpa_i2c_sda qsys_exported_port "sfpa_i2c_sda"
}

puts "Number of ports: [dict size $pin_assignment_table]"
