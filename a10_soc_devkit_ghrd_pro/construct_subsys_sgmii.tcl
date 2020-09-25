#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2015-2020 Intel Corporation.
#
#****************************************************************************
#
# This script construct sub system of SGMII for higher level integration
# The GHRD create_ghrd_qsys.tcl will call each of those subsystem construct script
# automatically based on the corresponding parameter argument defined

#     sub_qsys_sgmii   : <name your subsystem qsys>,
#     devicefamily     : <FPGA device family>,
#     device           : <FPGA device part number>
#
# example command to execute this script file separately
#   qsys-script --script=create_ghrd_qsys.tcl --cmd="set sub_qsys_sgmii subsys_sgmii"
#
#****************************************************************************

source ./design_config.tcl

if { ![ info exists devicefamily ] } {
  set devicefamily $DEVICE_FAMILY
} else {
  puts "-- Accepted parameter \$devicefamily = $devicefamily"
}
    
if { ![ info exists device ] } {
  set device $FPGA_DEVICE
} else {
  puts "-- Accepted parameter \$device = $device"
}
    
if { ![ info exists sub_qsys_sgmii ] } {
  set sub_qsys_sgmii subsys_sgmii
} else {
  puts "-- Accepted parameter \$sub_qsys_sgmii = $sub_qsys_sgmii"
}

package require -exact qsys 17.1

create_system $sub_qsys_sgmii

set_project_property DEVICE_FAMILY $devicefamily
set_project_property DEVICE $device

add_component_param "altera_clock_bridge sgmii_clk 
                     IP_FILE_PATH ip/$sub_qsys_sgmii/sgmii_clk.ip
                     EXPLICIT_CLOCK_RATE 100000000.0
                     NUM_CLOCK_OUTPUTS 1"   

add_component_param "altera_reset_bridge sgmii_rst_in 
                     IP_FILE_PATH ip/$sub_qsys_sgmii/sgmii_rst_in.ip
                     ACTIVE_LOW_RESET 1
                     SYNCHRONOUS_EDGES none
                     NUM_RESET_OUTPUTS 1
                     USE_RESET_REQUEST 0"

add_component_param "altera_clock_bridge clk_125 
                     IP_FILE_PATH ip/$sub_qsys_sgmii/clk_125.ip
                     EXPLICIT_CLOCK_RATE 100000000.0
                     NUM_CLOCK_OUTPUTS 1"

add_instance gmii2sgmii altera_gmii_to_sgmii_converter 

# For Arria10 only, Stratix10 will instantiate its dedicated PLL Modules
if {$USE_ATX_PLL == 1} {
add_component_param "altera_xcvr_atx_pll_a10 pll_txclk 
                     IP_FILE_PATH ip/$sub_qsys_sgmii/pll_txclk.ip
                     generate_docs 1
                     set_output_clock_frequency 1250.0
                     set_auto_reference_clock_frequency 125.0"
} elseif {$USE_CMU_PLL == 1} {
add_component_param "altera_xcvr_cdr_pll_a10 pll_txclk 
                     IP_FILE_PATH ip/$sub_qsys_sgmii/pll_txclk.ip
                     generate_docs 1
                     reference_clock_frequency 125.0
                     output_clock_frequency 1250"
} else {
add_component_param "altera_xcvr_fpll_a10 pll_txclk 
                     IP_FILE_PATH ip/$sub_qsys_sgmii/pll_txclk.ip
                     gui_fpll_mode 2
                     gui_bw_sel low
                     generate_docs 1
                     gui_desired_refclk_frequency 125.0
                     gui_hssi_output_clock_frequency 1250.0"
}

add_component_param "altera_xcvr_reset_control xcvr_ctrl 
                     IP_FILE_PATH ip/$sub_qsys_sgmii/xcvr_ctrl.ip
                     SYS_CLK_IN_MHZ 125
                     T_TX_ANALOGRESET 70000
                     T_TX_DIGITALRESET 70000
                     RX_ENABLE 1
                     T_RX_ANALOGRESET 70000
                     T_RX_DIGITALRESET 4000
                     gui_pll_cal_busy 1"

# connections and connection parameters
add_connection clk_125.out_clk xcvr_ctrl.clock 

add_connection sgmii_clk.out_clk gmii2sgmii.clock_in 

add_connection clk_125.out_clk pll_txclk.pll_refclk0 

add_connection clk_125.out_clk gmii2sgmii.tse_pcs_ref_clk_clock_connection 

add_connection clk_125.out_clk gmii2sgmii.tse_rx_cdr_refclk 

add_connection xcvr_ctrl.pll_cal_busy pll_txclk.pll_cal_busy 
set_connection_parameter_value xcvr_ctrl.pll_cal_busy/pll_txclk.pll_cal_busy endPort {}
set_connection_parameter_value xcvr_ctrl.pll_cal_busy/pll_txclk.pll_cal_busy endPortLSB {0}
set_connection_parameter_value xcvr_ctrl.pll_cal_busy/pll_txclk.pll_cal_busy startPort {}
set_connection_parameter_value xcvr_ctrl.pll_cal_busy/pll_txclk.pll_cal_busy startPortLSB {0}
set_connection_parameter_value xcvr_ctrl.pll_cal_busy/pll_txclk.pll_cal_busy width {0}

add_connection xcvr_ctrl.pll_locked pll_txclk.pll_locked 
set_connection_parameter_value xcvr_ctrl.pll_locked/pll_txclk.pll_locked endPort {}
set_connection_parameter_value xcvr_ctrl.pll_locked/pll_txclk.pll_locked endPortLSB {0}
set_connection_parameter_value xcvr_ctrl.pll_locked/pll_txclk.pll_locked startPort {}
set_connection_parameter_value xcvr_ctrl.pll_locked/pll_txclk.pll_locked startPortLSB {0}
set_connection_parameter_value xcvr_ctrl.pll_locked/pll_txclk.pll_locked width {0}

add_connection xcvr_ctrl.pll_powerdown pll_txclk.pll_powerdown 
set_connection_parameter_value xcvr_ctrl.pll_powerdown/pll_txclk.pll_powerdown endPort {}
set_connection_parameter_value xcvr_ctrl.pll_powerdown/pll_txclk.pll_powerdown endPortLSB {0}
set_connection_parameter_value xcvr_ctrl.pll_powerdown/pll_txclk.pll_powerdown startPort {}
set_connection_parameter_value xcvr_ctrl.pll_powerdown/pll_txclk.pll_powerdown startPortLSB {0}
set_connection_parameter_value xcvr_ctrl.pll_powerdown/pll_txclk.pll_powerdown width {0}

add_connection xcvr_ctrl.rx_analogreset gmii2sgmii.tse_rx_analogreset 
set_connection_parameter_value xcvr_ctrl.rx_analogreset/gmii2sgmii.tse_rx_analogreset endPort {}
set_connection_parameter_value xcvr_ctrl.rx_analogreset/gmii2sgmii.tse_rx_analogreset endPortLSB {0}
set_connection_parameter_value xcvr_ctrl.rx_analogreset/gmii2sgmii.tse_rx_analogreset startPort {}
set_connection_parameter_value xcvr_ctrl.rx_analogreset/gmii2sgmii.tse_rx_analogreset startPortLSB {0}
set_connection_parameter_value xcvr_ctrl.rx_analogreset/gmii2sgmii.tse_rx_analogreset width {0}

add_connection xcvr_ctrl.rx_cal_busy gmii2sgmii.tse_rx_cal_busy 
set_connection_parameter_value xcvr_ctrl.rx_cal_busy/gmii2sgmii.tse_rx_cal_busy endPort {}
set_connection_parameter_value xcvr_ctrl.rx_cal_busy/gmii2sgmii.tse_rx_cal_busy endPortLSB {0}
set_connection_parameter_value xcvr_ctrl.rx_cal_busy/gmii2sgmii.tse_rx_cal_busy startPort {}
set_connection_parameter_value xcvr_ctrl.rx_cal_busy/gmii2sgmii.tse_rx_cal_busy startPortLSB {0}
set_connection_parameter_value xcvr_ctrl.rx_cal_busy/gmii2sgmii.tse_rx_cal_busy width {0}

add_connection xcvr_ctrl.rx_digitalreset gmii2sgmii.tse_rx_digitalreset 
set_connection_parameter_value xcvr_ctrl.rx_digitalreset/gmii2sgmii.tse_rx_digitalreset endPort {}
set_connection_parameter_value xcvr_ctrl.rx_digitalreset/gmii2sgmii.tse_rx_digitalreset endPortLSB {0}
set_connection_parameter_value xcvr_ctrl.rx_digitalreset/gmii2sgmii.tse_rx_digitalreset startPort {}
set_connection_parameter_value xcvr_ctrl.rx_digitalreset/gmii2sgmii.tse_rx_digitalreset startPortLSB {0}
set_connection_parameter_value xcvr_ctrl.rx_digitalreset/gmii2sgmii.tse_rx_digitalreset width {0}

add_connection xcvr_ctrl.rx_is_lockedtodata gmii2sgmii.tse_rx_is_lockedtodata 
set_connection_parameter_value xcvr_ctrl.rx_is_lockedtodata/gmii2sgmii.tse_rx_is_lockedtodata endPort {}
set_connection_parameter_value xcvr_ctrl.rx_is_lockedtodata/gmii2sgmii.tse_rx_is_lockedtodata endPortLSB {0}
set_connection_parameter_value xcvr_ctrl.rx_is_lockedtodata/gmii2sgmii.tse_rx_is_lockedtodata startPort {}
set_connection_parameter_value xcvr_ctrl.rx_is_lockedtodata/gmii2sgmii.tse_rx_is_lockedtodata startPortLSB {0}
set_connection_parameter_value xcvr_ctrl.rx_is_lockedtodata/gmii2sgmii.tse_rx_is_lockedtodata width {0}

add_connection xcvr_ctrl.tx_analogreset gmii2sgmii.tse_tx_analogreset 
set_connection_parameter_value xcvr_ctrl.tx_analogreset/gmii2sgmii.tse_tx_analogreset endPort {}
set_connection_parameter_value xcvr_ctrl.tx_analogreset/gmii2sgmii.tse_tx_analogreset endPortLSB {0}
set_connection_parameter_value xcvr_ctrl.tx_analogreset/gmii2sgmii.tse_tx_analogreset startPort {}
set_connection_parameter_value xcvr_ctrl.tx_analogreset/gmii2sgmii.tse_tx_analogreset startPortLSB {0}
set_connection_parameter_value xcvr_ctrl.tx_analogreset/gmii2sgmii.tse_tx_analogreset width {0}

add_connection xcvr_ctrl.tx_cal_busy gmii2sgmii.tse_tx_cal_busy 
set_connection_parameter_value xcvr_ctrl.tx_cal_busy/gmii2sgmii.tse_tx_cal_busy endPort {}
set_connection_parameter_value xcvr_ctrl.tx_cal_busy/gmii2sgmii.tse_tx_cal_busy endPortLSB {0}
set_connection_parameter_value xcvr_ctrl.tx_cal_busy/gmii2sgmii.tse_tx_cal_busy startPort {}
set_connection_parameter_value xcvr_ctrl.tx_cal_busy/gmii2sgmii.tse_tx_cal_busy startPortLSB {0}
set_connection_parameter_value xcvr_ctrl.tx_cal_busy/gmii2sgmii.tse_tx_cal_busy width {0}

add_connection xcvr_ctrl.tx_digitalreset gmii2sgmii.tse_tx_digitalreset 
set_connection_parameter_value xcvr_ctrl.tx_digitalreset/gmii2sgmii.tse_tx_digitalreset endPort {}
set_connection_parameter_value xcvr_ctrl.tx_digitalreset/gmii2sgmii.tse_tx_digitalreset endPortLSB {0}
set_connection_parameter_value xcvr_ctrl.tx_digitalreset/gmii2sgmii.tse_tx_digitalreset startPort {}
set_connection_parameter_value xcvr_ctrl.tx_digitalreset/gmii2sgmii.tse_tx_digitalreset startPortLSB {0}
set_connection_parameter_value xcvr_ctrl.tx_digitalreset/gmii2sgmii.tse_tx_digitalreset width {0}

add_connection pll_txclk.tx_serial_clk gmii2sgmii.tse_tx_serial_clk 

add_connection sgmii_rst_in.out_reset xcvr_ctrl.reset 

add_connection sgmii_rst_in.out_reset gmii2sgmii.reset_in 

# exported interfaces
add_interface clk clock sink
set_interface_property clk EXPORT_OF sgmii_clk.in_clk
add_interface reset reset sink
set_interface_property reset EXPORT_OF sgmii_rst_in.in_reset
add_interface clk_125 clock sink
set_interface_property clk_125 EXPORT_OF clk_125.in_clk
add_interface emac conduit end
set_interface_property emac EXPORT_OF gmii2sgmii.emac
add_interface emac_gtx_clk clock sink
set_interface_property emac_gtx_clk EXPORT_OF gmii2sgmii.emac_gtx_clk
add_interface emac_rx_clk_in clock source
set_interface_property emac_rx_clk_in EXPORT_OF gmii2sgmii.emac_rx_clk_in
add_interface emac_rx_reset reset sink
set_interface_property emac_rx_reset EXPORT_OF gmii2sgmii.emac_rx_reset
add_interface emac_tx_clk_in clock source
set_interface_property emac_tx_clk_in EXPORT_OF gmii2sgmii.emac_tx_clk_in
add_interface emac_tx_reset reset sink
set_interface_property emac_tx_reset EXPORT_OF gmii2sgmii.emac_tx_reset
add_interface pcs_control_port avalon slave
set_interface_property pcs_control_port EXPORT_OF gmii2sgmii.eth_tse_control_port
add_interface gmii_to_sgmii_adapter_avalon_slave avalon slave
set_interface_property gmii_to_sgmii_adapter_avalon_slave EXPORT_OF gmii2sgmii.gmii_to_sgmii_adapter_avalon_slave
add_interface emac_mdio conduit end
set_interface_property emac_mdio EXPORT_OF gmii2sgmii.hps_emac_mdio
add_interface emac_ptp conduit end
set_interface_property emac_ptp EXPORT_OF gmii2sgmii.hps_emac_ptp
add_interface tse_rx_is_lockedtoref conduit end
set_interface_property tse_rx_is_lockedtoref EXPORT_OF gmii2sgmii.tse_rx_is_lockedtoref
add_interface tse_rx_set_locktodata conduit end
set_interface_property tse_rx_set_locktodata EXPORT_OF gmii2sgmii.tse_rx_set_locktodata
add_interface tse_rx_set_locktoref conduit end
set_interface_property tse_rx_set_locktoref EXPORT_OF gmii2sgmii.tse_rx_set_locktoref
add_interface tse_serdes_control_connection conduit end
set_interface_property tse_serdes_control_connection EXPORT_OF gmii2sgmii.tse_serdes_control_connection
add_interface tse_serial_connection conduit end
set_interface_property tse_serial_connection EXPORT_OF gmii2sgmii.tse_serial_connection
add_interface tse_sgmii_status_connection conduit end
set_interface_property tse_sgmii_status_connection EXPORT_OF gmii2sgmii.tse_sgmii_status_connection
add_interface tse_status_led_connection conduit end
set_interface_property tse_status_led_connection EXPORT_OF gmii2sgmii.tse_status_led_connection
add_interface xcvr_reset_control_0_pll_select conduit end
set_interface_property xcvr_reset_control_0_pll_select EXPORT_OF xcvr_ctrl.pll_select
add_interface xcvr_reset_control_0_rx_ready conduit end
set_interface_property xcvr_reset_control_0_rx_ready EXPORT_OF xcvr_ctrl.rx_ready
add_interface xcvr_reset_control_0_tx_ready conduit end
set_interface_property xcvr_reset_control_0_tx_ready EXPORT_OF xcvr_ctrl.tx_ready

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {HANDSHAKE}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}

sync_sysinfo_parameters
save_system ${sub_qsys_sgmii}.qsys

