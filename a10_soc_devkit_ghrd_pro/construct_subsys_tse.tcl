#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2016-2020 Intel Corporation.
#
#****************************************************************************
#
# This script construct sub system of TSE for higher level integration
# The GHRD create_ghrd_qsys.tcl will call each of those subsystem construct script
# automatically based on the corresponding parameter argument defined

# --- alternatively, input arguments could be passed in to select other FPGA variant. 
#     sub_qsys_tse          : <name your subsystem qsys>,
#     devicefamily          : <FPGA device family>,
#     device                : <FPGA device part number>
#     tse_variant           : MAC_PCS, PCS_ONLY or MAC_ONLY
#     tse_interface         : MII_GMII or RGMII
#     transceiver_type      : GXB or NONE
#     dma_prefetch_enable   : 1 or 0
#     reconfig_enable       : 1 or 0
#     mdio_enable           : 1 or 0
#     mdio_clk_div          : 40 for 100MHz or 50 for 125MHz
#     niosii_en             : 1 or 0
#
# example command to execute this script file separately
#   qsys-script --script=create_ghrd_qsys.tcl --cmd="set sub_qsys_pcie subsys_pcie"
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
    
if { ![ info exists sub_qsys_tse ] } {
  set sub_qsys_tse subsys_tse
} else {
  puts "-- Accepted parameter \$sub_qsys_tse = $sub_qsys_tse"
}

if { ![ info exists tse_variant ] } {
  set tse_variant $TSE_VARIANT
} else {
  puts "-- Accepted parameter \$tse_variant = $tse_variant"
}

if { ![ info exists tse_interface ] } {
  set tse_interface $TSE_INTERFACE
} else {
  puts "-- Accepted parameter \$tse_interface = $tse_interface"
}

if { ![ info exists transceiver_type ] } {
  set transceiver_type $TRANSCEIVER_TYPE
} else {
  puts "-- Accepted parameter \$transceiver_type = $transceiver_type"
}

if { ![ info exists dma_prefetch_enable ] } {
  set dma_prefetch_enable $DMA_PREFETCH_ENABLE
} else {
  puts "-- Accepted parameter \$dma_prefetch_enable = $dma_prefetch_enable"
}

if { ![ info exists reconfig_enable ] } {
  set reconfig_enable $RECONFIGURATION_ENABLE
} else {
  puts "-- Accepted parameter \$reconfig_enable = $reconfig_enable"
}

if { ![ info exists mdio_enable ] } {
  set mdio_enable $MDIO_ENABLE
} else {
  puts "-- Accepted parameter \$mdio_enable = $mdio_enable"
}

if { ![ info exists mdio_clk_div ] } {
  set mdio_clk_div $MDIO_CLK_DIVIDER
} else {
  puts "-- Accepted parameter \$mdio_clk_div = $mdio_clk_div"
}

if { ![ info exists niosii_en ] } {
  set niosii_en $NIOSII_ENABLE
} else {
  puts "-- Accepted parameter \$niosii_en = $niosii_en"
}

package require -exact qsys 17.1

create_system $sub_qsys_tse

set_project_property DEVICE_FAMILY $devicefamily
set_project_property DEVICE $device

add_component_param "altera_clock_bridge tse_clk 
                     IP_FILE_PATH ip/$sub_qsys_tse/tse_clk.ip
                     NUM_CLOCK_OUTPUTS 1"
if { $mdio_clk_div == 40} {
if { $niosii_en == 0} {
set_component_param "tse_clk    
                    EXPLICIT_CLOCK_RATE 100000000.0"
} else {
set_component_param "tse_clk    
                    EXPLICIT_CLOCK_RATE 96000000.0"
}
} else {
if { $niosii_en == 0} {
set_component_param "tse_clk    
                    EXPLICIT_CLOCK_RATE 125000000.0"
} else {
set_component_param "tse_clk    
                    EXPLICIT_CLOCK_RATE 118000000.0"
}
}

add_component_param "altera_reset_bridge tse_rst_in 
                     IP_FILE_PATH ip/$sub_qsys_tse/tse_rst_in.ip
                     ACTIVE_LOW_RESET 1
                     SYNCHRONOUS_EDGES deassert
                     NUM_RESET_OUTPUTS 1
                     USE_RESET_REQUEST 0"

add_component_param "altera_eth_tse tse 
                     IP_FILE_PATH ip/$sub_qsys_tse/tse.ip
                     core_variation $tse_variant
                     ifGMII $tse_interface
                     enable_hd_logic 1
                     enable_gmii_loopback 1
                     enable_sup_addr 1
                     ext_stat_cnt_ena 1
                     ena_hash 1
                     enable_mac_flow_ctrl 1
                     enable_mac_vlan 1"
# notes type
if { $tse_variant == "MAC_PCS" || $tse_variant == "PCS_ONLY"} {
set_component_param "tse    
                    transceiver_type GXB    
                    enable_sgmii 1"
} else {
set_component_param "tse    
                    transceiver_type NONE"
}
if { $tse_variant == "MAC_PCS" || $tse_variant == "MAC_ONLY"} {
set_component_param "tse    
                    eg_addr 11  
                    ing_addr 11"
}
if { $mdio_enable == 1} {
set_component_param "tse    
                    useMDIO 1   
                    mdio_clk_div $mdio_clk_div"
}
if { $reconfig_enable == 1} {
set_component_param "tse    
                    nf_phyip_rcfg_enable 1"
} else {
set_component_param "tse    
                    nf_phyip_rcfg_enable 0"
}

add_component_param "altera_avalon_mm_bridge mm_bg_0 
                     IP_FILE_PATH ip/$sub_qsys_tse/mm_bg_0.ip
                     DATA_WIDTH 32
                     ADDRESS_WIDTH 10
                     USE_AUTO_ADDRESS_WIDTH 1
                     MAX_BURST_SIZE 1
                     MAX_PENDING_RESPONSES 4"

if { $tse_variant == "MAC_PCS" || $tse_variant == "MAC_ONLY"} {
add_component_param "altera_msgdma dma_rx 
                     IP_FILE_PATH ip/$sub_qsys_tse/dma_rx.ip
                     MODE 2
                     DATA_WIDTH 32
                     USE_FIX_ADDRESS_WIDTH 1
                     DATA_FIFO_DEPTH 128
                     DESCRIPTOR_FIFO_DEPTH 256
                     RESPONSE_PORT 0
                     MAX_BYTE 65536
                     TRANSFER_TYPE {Unaligned Accesses}
                     BURST_ENABLE 1
                     MAX_BURST_COUNT 4
                     ENHANCED_FEATURES 1
                     PACKET_ENABLE 1
                     ERROR_ENABLE 1
                     ERROR_WIDTH 6"
if { $dma_prefetch_enable == 1} {
set_component_param "dma_rx 
                    PREFETCHER_ENABLE 1 
                    PREFETCHER_READ_BURST_ENABLE 1  
                    PREFETCHER_MAX_READ_BURST_COUNT 4"
if { $niosii_en == 0} {
set_component_param "dma_rx 
                    PREFETCHER_DATA_WIDTH 128"
}
}

add_component_param "altera_msgdma dma_tx 
                     IP_FILE_PATH ip/$sub_qsys_tse/dma_tx.ip
                     MODE 1
                     DATA_WIDTH 32
                     USE_FIX_ADDRESS_WIDTH 1
                     DATA_FIFO_DEPTH 128
                     DESCRIPTOR_FIFO_DEPTH 256
                     RESPONSE_PORT 2
                     MAX_BYTE 65536
                     TRANSFER_TYPE {Unaligned Accesses}
                     BURST_ENABLE 1
                     MAX_BURST_COUNT 4
                     ENHANCED_FEATURES 1
                     PACKET_ENABLE 1
                     ERROR_ENABLE 1
                     ERROR_WIDTH 1"
if { $dma_prefetch_enable == 1} {
set_component_param "dma_tx 
                    PREFETCHER_ENABLE 1 
                    PREFETCHER_READ_BURST_ENABLE 1  
                    PREFETCHER_MAX_READ_BURST_COUNT 4"
if { $niosii_en == 0} {
set_component_param "dma_tx 
                    PREFETCHER_DATA_WIDTH 128"
}
}

add_connection tse.receive dma_rx.st_sink 

add_connection dma_tx.st_source tse.transmit 

add_connection tse_clk.out_clk dma_tx.clock 

add_connection tse_clk.out_clk dma_rx.clock     

add_connection tse_rst_in.out_reset dma_tx.reset_n 

add_connection tse_rst_in.out_reset dma_rx.reset_n 

add_connection tse_clk.out_clk tse.receive_clock_connection 

add_connection tse_clk.out_clk tse.transmit_clock_connection 
if { $dma_prefetch_enable == 1} {
add_connection mm_bg_0.m0 dma_tx.prefetcher_csr
set_connection_parameter_value mm_bg_0.m0/dma_tx.prefetcher_csr arbitrationPriority {1}
set_connection_parameter_value mm_bg_0.m0/dma_tx.prefetcher_csr baseAddress {0x0480}
set_connection_parameter_value mm_bg_0.m0/dma_tx.prefetcher_csr defaultConnection {0}

add_connection mm_bg_0.m0 dma_rx.prefetcher_csr
set_connection_parameter_value mm_bg_0.m0/dma_rx.prefetcher_csr arbitrationPriority {1}
set_connection_parameter_value mm_bg_0.m0/dma_rx.prefetcher_csr baseAddress {0x0500}
set_connection_parameter_value mm_bg_0.m0/dma_rx.prefetcher_csr defaultConnection {0}
} else {
add_connection mm_bg_0.m0 dma_tx.descriptor_slave
set_connection_parameter_value mm_bg_0.m0/dma_tx.descriptor_slave arbitrationPriority {1}
set_connection_parameter_value mm_bg_0.m0/dma_tx.descriptor_slave baseAddress {0x0480}
set_connection_parameter_value mm_bg_0.m0/dma_tx.descriptor_slave defaultConnection {0}

add_connection mm_bg_0.m0 dma_rx.response
set_connection_parameter_value mm_bg_0.m0/dma_rx.response arbitrationPriority {1}
set_connection_parameter_value mm_bg_0.m0/dma_rx.response baseAddress {0x0440}
set_connection_parameter_value mm_bg_0.m0/dma_rx.response defaultConnection {0}

add_connection mm_bg_0.m0 dma_rx.descriptor_slave
set_connection_parameter_value mm_bg_0.m0/dma_rx.descriptor_slave arbitrationPriority {1}
set_connection_parameter_value mm_bg_0.m0/dma_rx.descriptor_slave baseAddress {0x0420}
set_connection_parameter_value mm_bg_0.m0/dma_rx.descriptor_slave defaultConnection {0}
}

add_connection mm_bg_0.m0 dma_tx.csr
set_connection_parameter_value mm_bg_0.m0/dma_tx.csr arbitrationPriority {1}
set_connection_parameter_value mm_bg_0.m0/dma_tx.csr baseAddress {0x0460}
set_connection_parameter_value mm_bg_0.m0/dma_tx.csr defaultConnection {0}

add_connection mm_bg_0.m0 dma_rx.csr
set_connection_parameter_value mm_bg_0.m0/dma_rx.csr arbitrationPriority {1}
set_connection_parameter_value mm_bg_0.m0/dma_rx.csr baseAddress {0x0400}
set_connection_parameter_value mm_bg_0.m0/dma_rx.csr defaultConnection {0}
}

if { $tse_variant == "MAC_PCS" || $tse_variant == "PCS_ONLY"} {
add_component_param "altera_clock_bridge refclk_125 
                     IP_FILE_PATH ip/$sub_qsys_tse/refclk_125.ip
                     EXPLICIT_CLOCK_RATE 125000000.0
                     NUM_CLOCK_OUTPUTS 1"

if {$devicefamily == "Arria 10"} {
if {$USE_ATX_PLL == 1} {
add_component_param "altera_xcvr_atx_pll_a10 pll_txclk 
                     IP_FILE_PATH ip/$sub_qsys_tse/pll_txclk.ip
                     generate_docs 1
                     set_output_clock_frequency 1250.0
                     set_auto_reference_clock_frequency 125.0"
} elseif {$USE_CMU_PLL == 1} {
add_component_param "altera_xcvr_cdr_pll_a10 pll_txclk 
                     IP_FILE_PATH ip/$sub_qsys_tse/pll_txclk.ip
                     generate_docs 1
                     reference_clock_frequency 125.0
                     output_clock_frequency 1250"
} else {
add_component_param "altera_xcvr_fpll_a10 pll_txclk 
                     IP_FILE_PATH ip/$sub_qsys_tse/pll_txclk.ip
                     gui_fpll_mode 2
                     gui_bw_sel low
                     generate_docs 1
                     gui_desired_refclk_frequency 125.0
                     gui_hssi_output_clock_frequency 1250.0"
}

add_component_param "altera_xcvr_reset_control xcvr_ctrl 
                     IP_FILE_PATH ip/$sub_qsys_tse/xcvr_ctrl.ip
                     T_TX_ANALOGRESET 70000
                     T_TX_DIGITALRESET 70000
                     RX_ENABLE 1
                     T_RX_ANALOGRESET 70000
                     T_RX_DIGITALRESET 4000
                     gui_pll_cal_busy 1"
if { $mdio_clk_div == 40} {
if { $niosii_en == 0} {
set_component_param "xcvr_ctrl  
                    SYS_CLK_IN_MHZ 100"
} else {
set_component_param "xcvr_ctrl  
                    SYS_CLK_IN_MHZ 96"
}
} else {
if { $niosii_en == 0} {
set_component_param "xcvr_ctrl  
                    SYS_CLK_IN_MHZ 125"
} else {
set_component_param "xcvr_ctrl  
                    SYS_CLK_IN_MHZ 118"
}
}

add_connection tse_clk.out_clk xcvr_ctrl.clock 

add_connection pll_txclk.tx_serial_clk tse.tx_serial_clk 

add_connection refclk_125.out_clk pll_txclk.pll_refclk0 

add_connection refclk_125.out_clk tse.rx_cdr_refclk 

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

add_connection tse.rx_analogreset xcvr_ctrl.rx_analogreset 
set_connection_parameter_value tse.rx_analogreset/xcvr_ctrl.rx_analogreset endPort {}
set_connection_parameter_value tse.rx_analogreset/xcvr_ctrl.rx_analogreset endPortLSB {0}
set_connection_parameter_value tse.rx_analogreset/xcvr_ctrl.rx_analogreset startPort {}
set_connection_parameter_value tse.rx_analogreset/xcvr_ctrl.rx_analogreset startPortLSB {0}
set_connection_parameter_value tse.rx_analogreset/xcvr_ctrl.rx_analogreset width {0}

add_connection xcvr_ctrl.rx_cal_busy tse.rx_cal_busy 
set_connection_parameter_value xcvr_ctrl.rx_cal_busy/tse.rx_cal_busy endPort {}
set_connection_parameter_value xcvr_ctrl.rx_cal_busy/tse.rx_cal_busy endPortLSB {0}
set_connection_parameter_value xcvr_ctrl.rx_cal_busy/tse.rx_cal_busy startPort {}
set_connection_parameter_value xcvr_ctrl.rx_cal_busy/tse.rx_cal_busy startPortLSB {0}
set_connection_parameter_value xcvr_ctrl.rx_cal_busy/tse.rx_cal_busy width {0}

add_connection xcvr_ctrl.rx_digitalreset tse.rx_digitalreset 
set_connection_parameter_value xcvr_ctrl.rx_digitalreset/tse.rx_digitalreset endPort {}
set_connection_parameter_value xcvr_ctrl.rx_digitalreset/tse.rx_digitalreset endPortLSB {0}
set_connection_parameter_value xcvr_ctrl.rx_digitalreset/tse.rx_digitalreset startPort {}
set_connection_parameter_value xcvr_ctrl.rx_digitalreset/tse.rx_digitalreset startPortLSB {0}
set_connection_parameter_value xcvr_ctrl.rx_digitalreset/tse.rx_digitalreset width {0}

add_connection xcvr_ctrl.rx_is_lockedtodata tse.rx_is_lockedtodata 
set_connection_parameter_value xcvr_ctrl.rx_is_lockedtodata/tse.rx_is_lockedtodata endPort {}
set_connection_parameter_value xcvr_ctrl.rx_is_lockedtodata/tse.rx_is_lockedtodata endPortLSB {0}
set_connection_parameter_value xcvr_ctrl.rx_is_lockedtodata/tse.rx_is_lockedtodata startPort {}
set_connection_parameter_value xcvr_ctrl.rx_is_lockedtodata/tse.rx_is_lockedtodata startPortLSB {0}
set_connection_parameter_value xcvr_ctrl.rx_is_lockedtodata/tse.rx_is_lockedtodata width {0}

add_connection xcvr_ctrl.tx_analogreset tse.tx_analogreset 
set_connection_parameter_value xcvr_ctrl.tx_analogreset/tse.tx_analogreset endPort {}
set_connection_parameter_value xcvr_ctrl.tx_analogreset/tse.tx_analogreset endPortLSB {0}
set_connection_parameter_value xcvr_ctrl.tx_analogreset/tse.tx_analogreset startPort {}
set_connection_parameter_value xcvr_ctrl.tx_analogreset/tse.tx_analogreset startPortLSB {0}
set_connection_parameter_value xcvr_ctrl.tx_analogreset/tse.tx_analogreset width {0}

add_connection xcvr_ctrl.tx_cal_busy tse.tx_cal_busy 
set_connection_parameter_value xcvr_ctrl.tx_cal_busy/tse.tx_cal_busy endPort {}
set_connection_parameter_value xcvr_ctrl.tx_cal_busy/tse.tx_cal_busy endPortLSB {0}
set_connection_parameter_value xcvr_ctrl.tx_cal_busy/tse.tx_cal_busy startPort {}
set_connection_parameter_value xcvr_ctrl.tx_cal_busy/tse.tx_cal_busy startPortLSB {0}
set_connection_parameter_value xcvr_ctrl.tx_cal_busy/tse.tx_cal_busy width {0}

add_connection tse.tx_digitalreset xcvr_ctrl.tx_digitalreset 
set_connection_parameter_value tse.tx_digitalreset/xcvr_ctrl.tx_digitalreset endPort {}
set_connection_parameter_value tse.tx_digitalreset/xcvr_ctrl.tx_digitalreset endPortLSB {0}
set_connection_parameter_value tse.tx_digitalreset/xcvr_ctrl.tx_digitalreset startPort {}
set_connection_parameter_value tse.tx_digitalreset/xcvr_ctrl.tx_digitalreset startPortLSB {0}
set_connection_parameter_value tse.tx_digitalreset/xcvr_ctrl.tx_digitalreset width {0}

add_connection tse_rst_in.out_reset xcvr_ctrl.reset 

if { $reconfig_enable == 1} {
add_connection tse_clk.out_clk tse.reconfig_clk

add_connection tse_rst_in.out_reset tse.reconfig_reset
}
}   

add_connection refclk_125.out_clk tse.pcs_ref_clk_clock_connection 
}

add_connection mm_bg_0.m0 tse.control_port
set_connection_parameter_value mm_bg_0.m0/tse.control_port arbitrationPriority {1}
set_connection_parameter_value mm_bg_0.m0/tse.control_port baseAddress {0x0000}
set_connection_parameter_value mm_bg_0.m0/tse.control_port defaultConnection {0}

add_connection tse_clk.out_clk tse.control_port_clock_connection 

add_connection tse_clk.out_clk tse_rst_in.clk

add_connection tse_clk.out_clk mm_bg_0.clk

add_connection tse_rst_in.out_reset mm_bg_0.reset   

add_connection tse_rst_in.out_reset tse.reset_connection 

# exported interfaces
add_interface clk clock sink
set_interface_property clk EXPORT_OF tse_clk.in_clk
add_interface reset reset sink
set_interface_property reset EXPORT_OF tse_rst_in.in_reset
if { $tse_variant == "MAC_PCS" || $tse_variant == "MAC_ONLY"} {
if { $mdio_enable == 1} {
add_interface eth_tse_0_mac_mdio_connection conduit end
set_interface_property eth_tse_0_mac_mdio_connection EXPORT_OF tse.mac_mdio_connection
}
if {$tse_variant == "MAC_ONLY" || $tse_variant == "SMALL_MAC_GIGE" || $tse_variant == "SMALL_MAC_10_100"} {
add_interface eth_tse_0_mac_status conduit end
set_interface_property eth_tse_0_mac_status EXPORT_OF tse.mac_status_connection
add_interface eth_tse_0_pcs_mac_rx_clock clock sink
set_interface_property eth_tse_0_pcs_mac_rx_clock EXPORT_OF tse.pcs_mac_rx_clock_connection
add_interface eth_tse_0_pcs_mac_tx_clock clock sink
set_interface_property eth_tse_0_pcs_mac_tx_clock EXPORT_OF tse.pcs_mac_tx_clock_connection
if { $tse_interface == "RGMII"} {
add_interface eth_tse_0_mac_rgmii_connection conduit end
set_interface_property eth_tse_0_mac_rgmii_connection EXPORT_OF tse.mac_rgmii_connection
}
if { $tse_interface == "GMII" || $tse_interface == "MII_GMII"} {
add_interface eth_tse_0_mac_gmii_connection conduit end
set_interface_property eth_tse_0_mac_gmii_connection EXPORT_OF tse.mac_gmii_connection
}
if { $tse_interface == "MII" || $tse_interface == "MII_GMII"} {
add_interface eth_tse_0_mac_mii_connection conduit end
set_interface_property eth_tse_0_mac_mii_connection EXPORT_OF tse.mac_mii_connection
}
}
add_interface eth_tse_0_mac_misc_connection conduit end
set_interface_property eth_tse_0_mac_misc_connection EXPORT_OF tse.mac_misc_connection
#gmii, mii
#for MAC_PCS, only MII+GMII allowed, no mac*if*, pcs_mac_*_clock connection export but status_led, serdes_control, tbi, 
#PCS only, additional pcs_transmit_reset, pcs_receive_reset, pcs_receive_clock, pcs_transmit_clock, gmii, no mdio, no receive, transmit
add_interface msgdma_rx_csr_irq interrupt sender
set_interface_property msgdma_rx_csr_irq EXPORT_OF dma_rx.csr_irq
add_interface msgdma_rx_mm_write avalon master
set_interface_property msgdma_rx_mm_write EXPORT_OF dma_rx.mm_write
add_interface msgdma_tx_csr_irq interrupt sender
set_interface_property msgdma_tx_csr_irq EXPORT_OF dma_tx.csr_irq
add_interface msgdma_tx_mm_read avalon master
set_interface_property msgdma_tx_mm_read EXPORT_OF dma_tx.mm_read
if { $dma_prefetch_enable == 1} {
add_interface msgdma_tx_descriptor_read_master avalon master
set_interface_property msgdma_tx_descriptor_read_master EXPORT_OF dma_tx.descriptor_read_master
add_interface msgdma_tx_descriptor_write_master avalon master
set_interface_property msgdma_tx_descriptor_write_master EXPORT_OF dma_tx.descriptor_write_master
add_interface msgdma_rx_descriptor_read_master avalon master
set_interface_property msgdma_rx_descriptor_read_master EXPORT_OF dma_rx.descriptor_read_master
add_interface msgdma_rx_descriptor_write_master avalon master
set_interface_property msgdma_rx_descriptor_write_master EXPORT_OF dma_rx.descriptor_write_master
}
}
#notes type
if { $tse_variant == "MAC_PCS" || $tse_variant == "PCS_ONLY"} {
add_interface refclk_125 clock sink
set_interface_property refclk_125 EXPORT_OF refclk_125.in_clk
if {$tse_variant == "PCS_ONLY"} {
add_interface eth_tse_0_gmii_connection conduit end
set_interface_property eth_tse_0_gmii_connection EXPORT_OF tse.gmii_connection
add_interface eth_tse_0_pcs_receive_clock_connection clock source
set_interface_property eth_tse_0_pcs_receive_clock_connection EXPORT_OF tse.pcs_receive_clock_connection
add_interface eth_tse_0_pcs_transmit_clock_connection clock source
set_interface_property eth_tse_0_pcs_transmit_clock_connection EXPORT_OF tse.pcs_transmit_clock_connection
add_interface eth_tse_0_pcs_transmit_reset_connection reset sink
set_interface_property eth_tse_0_pcs_transmit_reset_connection EXPORT_OF tse.pcs_transmit_reset_connection
add_interface eth_tse_0_pcs_receive_reset_connection reset sink
set_interface_property eth_tse_0_pcs_receive_reset_connection EXPORT_OF tse.pcs_receive_reset_connection
}
if {$devicefamily == "Arria 10"} {
if { $reconfig_enable == 1} {
add_interface eth_tse_0_reconfig_avmm avalon slave
set_interface_property eth_tse_0_reconfig_avmm EXPORT_OF tse.reconfig_avmm
}
if { $transceiver_type == "GXB"} {
add_interface eth_tse_0_rx_is_lockedtoref conduit end
set_interface_property eth_tse_0_rx_is_lockedtoref EXPORT_OF tse.rx_is_lockedtoref
add_interface eth_tse_0_rx_set_locktoref conduit end
set_interface_property eth_tse_0_rx_set_locktoref EXPORT_OF tse.rx_set_locktoref
add_interface eth_tse_0_rx_set_locktodata conduit end
set_interface_property eth_tse_0_rx_set_locktodata EXPORT_OF tse.rx_set_locktodata
add_interface xcvr_ctrl_rx_ready conduit end
set_interface_property xcvr_ctrl_rx_ready EXPORT_OF xcvr_ctrl.rx_ready
add_interface xcvr_ctrl_tx_ready conduit end
set_interface_property xcvr_ctrl_tx_ready EXPORT_OF xcvr_ctrl.tx_ready
add_interface xcvr_ctrl_pll_select conduit end
set_interface_property xcvr_ctrl_pll_select EXPORT_OF xcvr_ctrl.pll_select
}
if { $transceiver_type == "NONE"} {
add_interface eth_tse_0_tbi_connection conduit end
set_interface_property eth_tse_0_tbi_connection EXPORT_OF tse.tbi_connection
}
}
add_interface eth_tse_0_status_led_connection conduit end
set_interface_property eth_tse_0_status_led_connection EXPORT_OF tse.status_led_connection
add_interface eth_tse_0_serdes_control_connection conduit end
set_interface_property eth_tse_0_serdes_control_connection EXPORT_OF tse.serdes_control_connection
add_interface eth_tse_0_serial_connection conduit end
set_interface_property eth_tse_0_serial_connection EXPORT_OF tse.serial_connection
}
add_interface mm_bg_0_s0 avalon slave
set_interface_property mm_bg_0_s0 EXPORT_OF mm_bg_0.s0

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {AUTO}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}

sync_sysinfo_parameters
save_system ${sub_qsys_tse}.qsys
