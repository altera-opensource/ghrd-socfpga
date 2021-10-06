#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2020 Intel Corporation.
#
#****************************************************************************
#
# This script construct sub system of MGE 10GbE 1588 Control Signals for higher level integration
# The GHRD create_ghrd_qsys.tcl will call each of those subsystem construct script
# automatically based on the corresponding parameter argument defined
#
#****************************************************************************


source ./arguments_solver.tcl
source ./utils.tcl
  
package require -exact qsys 18.1

reload_ip_catalog

set subsys_10gbe_name subsys_mge_10gbe_1588_ctrl
create_system $subsys_10gbe_name

set_project_property DEVICE_FAMILY $device_family
set_project_property DEVICE $device
set_validation_property AUTOMATIC_VALIDATION false



add_component_param "altera_clock_bridge mge_10gbe_1588_ctrl_clk
                     IP_FILE_PATH ip/$subsys_10gbe_name/mge_10gbe_1588_ctrl_clk.ip 
                     EXPLICIT_CLOCK_RATE 156250000 
                     NUM_CLOCK_OUTPUTS 1
                     "

add_component_param "altera_reset_bridge mge_10gbe_1588_ctrl_reset
                     IP_FILE_PATH ip/$subsys_10gbe_name/mge_10gbe_1588_ctrl_reset.ip 
                     ACTIVE_LOW_RESET 1
                     SYNCHRONOUS_EDGES both
                     NUM_RESET_OUTPUTS 1
                     USE_RESET_REQUEST 0
                     "
                     
add_component_param "altera_avalon_mm_bridge mge_10gbe_1588_ctrl_csr
                     IP_FILE_PATH ip/$subsys_10gbe_name/mge_10gbe_1588_ctrl_csr.ip 
                     DATA_WIDTH 32
                     ADDRESS_WIDTH 32
                     USE_AUTO_ADDRESS_WIDTH 1
                     MAX_BURST_SIZE 1
                     MAX_PENDING_RESPONSES 1
                     "

if {$hps_mge_10gbe_1588_count == 2} {
set sfp_ctrl_pio_width 6
set mge_10gbe_status_pio_width 6
set mge_10gbe_debug_status_pio_width 17
} else {
set sfp_ctrl_pio_width 3
set mge_10gbe_status_pio_width 3
set mge_10gbe_debug_status_pio_width 10
} 
add_component_param "altera_avalon_pio sfp_control_pio 
                     IP_FILE_PATH ip/$subsys_10gbe_name/sfp_control_pio.ip 
                     captureEdge 1
                     direction InOut
                     edgeType RISING
                     generateIRQ 1
                     resetValue 0x6
                     width $sfp_ctrl_pio_width
                     "

add_component_param "altera_avalon_pio mge_10gbe_status_pio 
                     IP_FILE_PATH ip/$subsys_10gbe_name/mge_10gbe_status_pio.ip 
                     captureEdge 1
                     direction Input
                     edgeType RISING
                     generateIRQ 1
                     width $mge_10gbe_status_pio_width
                     "

add_component_param "altera_avalon_pio mge_10gbe_debug_status_pio 
                     IP_FILE_PATH ip/$subsys_10gbe_name/mge_10gbe_debug_status_pio.ip 
                     captureEdge 1
                     direction Input
                     edgeType RISING
                     generateIRQ 0
                     width $mge_10gbe_debug_status_pio_width
                     "

add_component_param "altera_avalon_pio mge_10gbe_mac_link_status_pio 
                     IP_FILE_PATH ip/$subsys_10gbe_name/mge_10gbe_mac_link_status_pio.ip 
                     captureEdge 1
                     direction Input
                     edgeType RISING
                     generateIRQ 1
                     width $hps_mge_10gbe_1588_count
                     "
                     
add_component_param "altera_avalon_pio mge_10gbe_tod_start_sync_ctrl_pio 
                     IP_FILE_PATH ip/$subsys_10gbe_name/mge_10gbe_tod_start_sync_ctrl_pio.ip 
                     captureEdge 1
                     direction InOut
                     edgeType RISING
                     generateIRQ 0
                     resetValue 0x0
                     width $hps_mge_10gbe_1588_count
                     "
                     
# --------------- Connections and connection parameters ------------------#
connect "mge_10gbe_1588_ctrl_clk.out_clk            mge_10gbe_1588_ctrl_reset.clk
         mge_10gbe_1588_ctrl_clk.out_clk            mge_10gbe_1588_ctrl_csr.clk
         mge_10gbe_1588_ctrl_reset.out_reset        mge_10gbe_1588_ctrl_csr.reset
         mge_10gbe_1588_ctrl_clk.out_clk            sfp_control_pio.clk
         mge_10gbe_1588_ctrl_reset.out_reset        sfp_control_pio.reset
         mge_10gbe_1588_ctrl_clk.out_clk            mge_10gbe_status_pio.clk
         mge_10gbe_1588_ctrl_reset.out_reset        mge_10gbe_status_pio.reset
         mge_10gbe_1588_ctrl_clk.out_clk            mge_10gbe_debug_status_pio.clk
         mge_10gbe_1588_ctrl_reset.out_reset        mge_10gbe_debug_status_pio.reset
         mge_10gbe_1588_ctrl_clk.out_clk            mge_10gbe_mac_link_status_pio.clk
         mge_10gbe_1588_ctrl_reset.out_reset        mge_10gbe_mac_link_status_pio.reset
         mge_10gbe_1588_ctrl_clk.out_clk            mge_10gbe_tod_start_sync_ctrl_pio.clk
         mge_10gbe_1588_ctrl_reset.out_reset        mge_10gbe_tod_start_sync_ctrl_pio.reset
         "
         

connect_map "mge_10gbe_1588_ctrl_csr.m0             sfp_control_pio.s1                    0x00
             mge_10gbe_1588_ctrl_csr.m0             mge_10gbe_status_pio.s1               0x10
             mge_10gbe_1588_ctrl_csr.m0             mge_10gbe_debug_status_pio.s1         0x20
             mge_10gbe_1588_ctrl_csr.m0             mge_10gbe_mac_link_status_pio.s1      0x30
             mge_10gbe_1588_ctrl_csr.m0             mge_10gbe_tod_start_sync_ctrl_pio.s1  0x40
             "


# --------------------    Exported Interfaces     -----------------------#
export mge_10gbe_1588_ctrl_clk    in_clk      clk
export mge_10gbe_1588_ctrl_reset  in_reset    reset
export mge_10gbe_1588_ctrl_csr    s0          csr

export sfp_control_pio                    external_connection     sfp_control_pio
export mge_10gbe_status_pio               external_connection     mge_10gbe_status_pio
export mge_10gbe_debug_status_pio         external_connection     mge_10gbe_debug_status_pio
export mge_10gbe_mac_link_status_pio      external_connection     mge_10gbe_mac_link_status_pio
export mge_10gbe_tod_start_sync_ctrl_pio  external_connection     mge_10gbe_tod_start_sync_ctrl_pio

export sfp_control_pio                    irq     sfp_control_pio_irq
export mge_10gbe_status_pio               irq     mge_10gbe_status_pio_irq
export mge_10gbe_mac_link_status_pio      irq     mge_10gbe_mac_link_status_pio_irq

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {AUTO}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
    
sync_sysinfo_parameters 
    
save_system ${subsys_10gbe_name}.qsys
