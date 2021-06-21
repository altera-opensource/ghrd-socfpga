#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2021-2021 Intel Corporation.
#
#****************************************************************************
#
# This script construct sub system of SGMII for higher level integration
# The GHRD create_ghrd_qsys.tcl will call each of those subsystem construct script
# automatically based on the corresponding parameter argument defined
#
#****************************************************************************

source ./arguments_solver.tcl
source ./utils.tcl
set sub_qsys_sgmii subsys_sgmii
  
package require -exact qsys 19.1

create_system $sub_qsys_sgmii

set_project_property DEVICE_FAMILY $devicefamily
set_project_property DEVICE $device

add_component_param "altera_clock_bridge sgmii_csr_clk 
                     IP_FILE_PATH ip/$sub_qsys_sgmii/sgmii_csr_clk.ip
                     EXPLICIT_CLOCK_RATE 100000000.0
                     NUM_CLOCK_OUTPUTS 1"   

add_component_param "altera_reset_bridge sgmii_rst_in 
                     IP_FILE_PATH ip/$sub_qsys_sgmii/sgmii_rst_in.ip
                     ACTIVE_LOW_RESET 1
                     SYNCHRONOUS_EDGES both
                     NUM_RESET_OUTPUTS 1
                     USE_RESET_REQUEST 0"

add_component_param "altera_clock_bridge sgmii_clk_125 
                     IP_FILE_PATH ip/$sub_qsys_sgmii/sgmii_clk_125.ip
                     EXPLICIT_CLOCK_RATE 125000000.0
                     NUM_CLOCK_OUTPUTS 1"

add_component_param "altera_avalon_mm_bridge sgmii_csr
                     IP_FILE_PATH ip/$sub_qsys_sgmii/sgmii_csr.ip 
                     DATA_WIDTH 32
                     ADDRESS_WIDTH 32
                     USE_AUTO_ADDRESS_WIDTH 1
                     MAX_BURST_SIZE 1
                     MAX_PENDING_RESPONSES 1
                     "

add_component_param "altera_hps_emac_interface_splitter emac_splitter_0
                    IP_FILE_PATH ip/$sub_qsys_sgmii/emac_splitter_0.ip
                    "

add_component_param "altera_gmii_to_sgmii_adapter gmii_sgmii_adapter_0 
                     IP_FILE_PATH ip/$sub_qsys_sgmii/gmii_sgmii_adapter_0.ip
                     "

add_component_param "altera_eth_tse eth_tse_0 
                     IP_FILE_PATH ip/$sub_qsys_sgmii/eth_tse_0.ip
                     core_variation {PCS_ONLY}
                     ifGMII {MII_GMII}
                     transceiver_type {LVDS_IO}
                     enable_sgmii {1}
                     enable_ecc {0}
                     phy_identifier {0}
                     "

# For debug usage
add_component_param "altera_avalon_pio sgmii_debug_status_pio 
                     IP_FILE_PATH ip/$sub_qsys_sgmii/sgmii_debug_status_pio.ip 
                     captureEdge 1
                     direction Input
                     edgeType RISING
                     generateIRQ 0
                     width 13
                     "

connect "sgmii_csr_clk.out_clk          sgmii_rst_in.clk
         sgmii_csr_clk.out_clk          sgmii_csr.clk
         sgmii_rst_in.out_reset         sgmii_csr.reset
         
         sgmii_csr_clk.out_clk          gmii_sgmii_adapter_0.peri_clock
         sgmii_rst_in.out_reset         gmii_sgmii_adapter_0.peri_reset
         emac_splitter_0.hps_gmii       gmii_sgmii_adapter_0.hps_gmii
         gmii_sgmii_adapter_0.pcs_transmit_reset    eth_tse_0.pcs_transmit_reset_connection
         gmii_sgmii_adapter_0.pcs_receive_reset     eth_tse_0.pcs_receive_reset_connection
         eth_tse_0.pcs_transmit_clock_connection    gmii_sgmii_adapter_0.pcs_transmit_clock
         eth_tse_0.pcs_receive_clock_connection     gmii_sgmii_adapter_0.pcs_receive_clock
         gmii_sgmii_adapter_0.pcs_clock_enable      eth_tse_0.clock_enable_connection
         gmii_sgmii_adapter_0.pcs_gmii              eth_tse_0.gmii_connection
         gmii_sgmii_adapter_0.pcs_mii               eth_tse_0.mii_connection
         
         sgmii_clk_125.out_clk          eth_tse_0.pcs_ref_clk_clock_connection
         sgmii_csr_clk.out_clk          eth_tse_0.control_port_clock_connection
         sgmii_rst_in.out_reset         eth_tse_0.reset_connection
         
         sgmii_csr_clk.out_clk          sgmii_debug_status_pio.clk
         sgmii_rst_in.out_reset         sgmii_debug_status_pio.reset
        "

connect_map "sgmii_csr.m0               gmii_sgmii_adapter_0.avalon_slave       0x40
             sgmii_csr.m0               eth_tse_0.control_port                  0x0
             sgmii_csr.m0               sgmii_debug_status_pio.s1               0x50
            "

# exported interfaces
export sgmii_csr_clk   in_clk          csr_clk
export sgmii_rst_in    in_reset        rst_in
export sgmii_clk_125   in_clk          clk_125
export sgmii_csr       s0              csr

export emac_splitter_0 emac            splitter_emac
export emac_splitter_0 emac_gtx_clk    emac_gtx_clk
export emac_splitter_0 emac_rx_clk_in  emac_rx_clk_in
export emac_splitter_0 emac_rx_reset   emac_rx_reset
export emac_splitter_0 emac_tx_clk_in  emac_tx_clk_in
export emac_splitter_0 emac_tx_reset   emac_tx_reset
export emac_splitter_0 mdio            mdio
export emac_splitter_0 ptp             ptp

export eth_tse_0       sgmii_status_connection      sgmii_status
export eth_tse_0       status_led_connection        status_led
export eth_tse_0       serdes_control_connection    serdes_control
export eth_tse_0       lvds_tx_pll_locked           lvds_tx_pll_locked
export eth_tse_0       serial_connection            serial_connection
export sgmii_debug_status_pio   external_connection     sgmii_debug_status_pio

# interconnect requirements
set_domain_assignment {$system} {qsys_mm.clockCrossingAdapter} {AUTO}
set_domain_assignment {$system} {qsys_mm.maxAdditionalLatency} {1}
set_domain_assignment {$system} {qsys_mm.enableEccProtection} {FALSE}
set_domain_assignment {$system} {qsys_mm.insertDefaultSlave} {FALSE}

sync_sysinfo_parameters
save_system ${sub_qsys_sgmii}.qsys
