#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2022 Intel Corporation.
#
#****************************************************************************
#
# This script construct subsystem of Etile 25GbE 1588 Control for higher level integration
# The GHRD create_ghrd_qsys.tcl will call each of those subsystem construct script
# automatically based on the corresponding parameter argument defined
#
#****************************************************************************

source ./arguments_solver.tcl
source ./utils.tcl

package require -exact qsys 19.1

reload_ip_catalog

set subsys_name subsys_etile_25gbe_1588_ctrl
create_system $subsys_name

set_project_property DEVICE_FAMILY $device_family
set_project_property DEVICE $device
set_validation_property AUTOMATIC_VALIDATION false



add_component_param "altera_clock_bridge etile_25gbe_1588_ctrl_clk
                     IP_FILE_PATH ip/$subsys_name/etile_25gbe_1588_ctrl_clk.ip
                     EXPLICIT_CLOCK_RATE 156250000
                     NUM_CLOCK_OUTPUTS 1
                     "

add_component_param "altera_reset_bridge etile_25gbe_1588_ctrl_reset
                     IP_FILE_PATH ip/$subsys_name/etile_25gbe_1588_ctrl_reset.ip
                     ACTIVE_LOW_RESET 1
                     SYNCHRONOUS_EDGES both
                     NUM_RESET_OUTPUTS 1
                     USE_RESET_REQUEST 0
                     "

add_component_param "altera_avalon_mm_bridge etile_25gbe_1588_ctrl_csr
                     IP_FILE_PATH ip/$subsys_name/etile_25gbe_1588_ctrl_csr.ip
                     DATA_WIDTH 32
                     ADDRESS_WIDTH 32
                     USE_AUTO_ADDRESS_WIDTH 1
                     MAX_BURST_SIZE 1
                     MAX_PENDING_RESPONSES 1
                     "

if {$hps_etile_1588_count == 2} {
set sfp_ctrl_pio_width 6
set etile_25gbe_status_pio_width 6
set etile_25gbe_debug_status_pio_width 17
} else {
set sfp_ctrl_pio_width 3
set etile_25gbe_status_pio_width 3
set etile_25gbe_debug_status_pio_width 10
}

add_component_param "altera_avalon_pio sfp_control_pio
                     IP_FILE_PATH ip/$subsys_name/sfp_control_pio.ip
                     captureEdge 1
                     direction InOut
                     edgeType RISING
                     generateIRQ 1
                     resetValue 0x6
                     width $sfp_ctrl_pio_width
                     "

add_component_param "altera_avalon_pio etile_25gbe_status_pio
                     IP_FILE_PATH ip/$subsys_name/etile_25gbe_status_pio.ip
                     captureEdge 1
                     direction Input
                     edgeType RISING
                     generateIRQ 1
                     width $etile_25gbe_status_pio_width
                     "

add_component_param "altera_avalon_pio etile_25gbe_debug_status_pio
                     IP_FILE_PATH ip/$subsys_name/etile_25gbe_debug_status_pio.ip
                     captureEdge 1
                     direction Input
                     edgeType RISING
                     generateIRQ 0
                     width $etile_25gbe_debug_status_pio_width
                     "

add_component_param "altera_avalon_pio etile_25gbe_mac_link_status_pio
                     IP_FILE_PATH ip/$subsys_name/etile_25gbe_mac_link_status_pio.ip
                     captureEdge 1
                     direction Input
                     edgeType RISING
                     generateIRQ 1
                     width $hps_etile_1588_count
                     "

add_component_param "altera_avalon_pio etile_25gbe_tod_start_sync_ctrl_pio
                     IP_FILE_PATH ip/$subsys_name/etile_25gbe_tod_start_sync_ctrl_pio.ip
                     captureEdge 1
                     direction InOut
                     edgeType RISING
                     generateIRQ 1
                     resetValue 0x0
                     width $hps_etile_1588_count
                     "

# --------------- Connections and connection parameters ------------------#
connect "etile_25gbe_1588_ctrl_clk.out_clk            etile_25gbe_1588_ctrl_reset.clk
         etile_25gbe_1588_ctrl_clk.out_clk            etile_25gbe_1588_ctrl_csr.clk
         etile_25gbe_1588_ctrl_reset.out_reset        etile_25gbe_1588_ctrl_csr.reset
         etile_25gbe_1588_ctrl_clk.out_clk            sfp_control_pio.clk
         etile_25gbe_1588_ctrl_reset.out_reset        sfp_control_pio.reset
         etile_25gbe_1588_ctrl_clk.out_clk            etile_25gbe_status_pio.clk
         etile_25gbe_1588_ctrl_reset.out_reset        etile_25gbe_status_pio.reset
         etile_25gbe_1588_ctrl_clk.out_clk            etile_25gbe_debug_status_pio.clk
         etile_25gbe_1588_ctrl_reset.out_reset        etile_25gbe_debug_status_pio.reset
         etile_25gbe_1588_ctrl_clk.out_clk            etile_25gbe_mac_link_status_pio.clk
         etile_25gbe_1588_ctrl_reset.out_reset        etile_25gbe_mac_link_status_pio.reset
         etile_25gbe_1588_ctrl_clk.out_clk            etile_25gbe_tod_start_sync_ctrl_pio.clk
         etile_25gbe_1588_ctrl_reset.out_reset        etile_25gbe_tod_start_sync_ctrl_pio.reset
         "

connect_map "etile_25gbe_1588_ctrl_csr.m0             sfp_control_pio.s1                      0x00
             etile_25gbe_1588_ctrl_csr.m0             etile_25gbe_status_pio.s1               0x10
             etile_25gbe_1588_ctrl_csr.m0             etile_25gbe_debug_status_pio.s1         0x20
             etile_25gbe_1588_ctrl_csr.m0             etile_25gbe_mac_link_status_pio.s1      0x30
             etile_25gbe_1588_ctrl_csr.m0             etile_25gbe_tod_start_sync_ctrl_pio.s1  0x40
             "

# --------------------    Exported Interfaces     -----------------------#
export etile_25gbe_1588_ctrl_clk            in_clk                  clk
export etile_25gbe_1588_ctrl_reset          in_reset                reset
export etile_25gbe_1588_ctrl_csr            s0                      csr

export sfp_control_pio                      external_connection     sfp_control_pio
export etile_25gbe_status_pio               external_connection     etile_25gbe_status_pio
export etile_25gbe_debug_status_pio         external_connection     etile_25gbe_debug_status_pio
export etile_25gbe_mac_link_status_pio      external_connection     etile_25gbe_mac_link_status_pio
export etile_25gbe_tod_start_sync_ctrl_pio  external_connection     etile_25gbe_tod_start_sync_ctrl_pio

export sfp_control_pio                      irq                     sfp_control_pio_irq
export etile_25gbe_status_pio               irq                     etile_25gbe_status_pio_irq
export etile_25gbe_mac_link_status_pio      irq                     etile_25gbe_mac_link_status_pio_irq

# interconnect requirements
set_domain_assignment {$system} {qsys_mm.clockCrossingAdapter} {AUTO}
set_domain_assignment {$system} {qsys_mm.maxAdditionalLatency} {1}
set_domain_assignment {$system} {qsys_mm.enableEccProtection} {FALSE}
set_domain_assignment {$system} {qsys_mm.insertDefaultSlave} {FALSE}

sync_sysinfo_parameters

save_system ${subsys_name}.qsys
