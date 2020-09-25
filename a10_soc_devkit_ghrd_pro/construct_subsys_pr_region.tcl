#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2016-2020 Intel Corporation.
#
#****************************************************************************
#
# This script construct sub system of PR freeze region for higher level integration
#
#****************************************************************************

source ./design_config.tcl
source ./utils.tcl

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

if { ![ info exists pr_persona ] } {
  set pr_persona $PR_PERSONA
} else {
  puts "-- Accepted parameter \$pr_persona = $pr_persona"
}
    
if { ![ info exists pr_region_id_switch ] } {
  set pr_region_id_switch 0
} else {
  puts "-- Accepted parameter \$pr_region_id_switch = $pr_region_id_switch"
}   
    
if { ![ info exists sub_qsys_pr ] } {
  set sub_qsys_pr pr_region
} else {
  puts "-- Accepted parameter \$sub_qsys_pr = $sub_qsys_pr"
}

if {$pr_region_id_switch == 1} {
set index 1
} else {
set index 0
}

package require -exact qsys 17.1

create_system $sub_qsys_pr

set_project_property DEVICE_FAMILY $devicefamily
set_project_property DEVICE $device

add_component_param "altera_clock_bridge pr_clk_100_${sub_qsys_pr}_${index}
                     IP_FILE_PATH ip/$sub_qsys_pr/pr_clk_100_${sub_qsys_pr}_${index}.ip
                     EXPLICIT_CLOCK_RATE 100000000.0
                     NUM_CLOCK_OUTPUTS 1"

add_component_param "altera_reset_bridge pr_rst_in_${sub_qsys_pr}_${index}
                     IP_FILE_PATH ip/$sub_qsys_pr/pr_rst_in_${sub_qsys_pr}_${index}.ip
                     ACTIVE_LOW_RESET 1
                     SYNCHRONOUS_EDGES deassert
                     NUM_RESET_OUTPUTS 1
                     USE_RESET_REQUEST 0"

add_component_param "altera_avalon_mm_bridge pr_mm_bdg_${sub_qsys_pr}_${index}
                     IP_FILE_PATH ip/$sub_qsys_pr/pr_mm_bdg_${sub_qsys_pr}_${index}.ip
                     DATA_WIDTH 32
                     ADDRESS_WIDTH 10
                     USE_AUTO_ADDRESS_WIDTH 0
                     MAX_BURST_SIZE 1
                     MAX_PENDING_RESPONSES 1"

add_component_param "altera_avalon_sysid_qsys pr_sysid_${sub_qsys_pr}_${index}
                     IP_FILE_PATH ip/$sub_qsys_pr/pr_sysid_${sub_qsys_pr}_${index}.ip"
                     
if {$pr_region_id_switch == 1} {
if {$pr_persona == 1} {
set_component_param "pr_sysid_${sub_qsys_pr}_${index}   
                    id 2309737967"
} else {
set_component_param "pr_sysid_${sub_qsys_pr}_${index}   
                    id 19088743"
}
} else {
if {$pr_persona == 1} {
set_component_param "pr_sysid_${sub_qsys_pr}_${index}   
                    id -87110914"
} else {
set_component_param "pr_sysid_${sub_qsys_pr}_${index}   
                    id -889259314"
}
}

add_component_param "altera_avalon_onchip_memory2 pr_ocm_${sub_qsys_pr}_${index} 
                     IP_FILE_PATH ip/$sub_qsys_pr/pr_ocm_${sub_qsys_pr}_${index}.ip
                     dataWidth 32
                     memorySize 256.0"

# connections and connection parameters
add_connection pr_mm_bdg_${sub_qsys_pr}_${index}.m0 pr_sysid_${sub_qsys_pr}_${index}.control_slave
set_connection_parameter_value pr_mm_bdg_${sub_qsys_pr}_${index}.m0/pr_sysid_${sub_qsys_pr}_${index}.control_slave arbitrationPriority {1}
if {$pr_persona == 1} {
set_connection_parameter_value pr_mm_bdg_${sub_qsys_pr}_${index}.m0/pr_sysid_${sub_qsys_pr}_${index}.control_slave baseAddress {0x100}
} else {
set_connection_parameter_value pr_mm_bdg_${sub_qsys_pr}_${index}.m0/pr_sysid_${sub_qsys_pr}_${index}.control_slave baseAddress {0x0}
}
set_connection_parameter_value pr_mm_bdg_${sub_qsys_pr}_${index}.m0/pr_sysid_${sub_qsys_pr}_${index}.control_slave defaultConnection {0}

add_connection pr_mm_bdg_${sub_qsys_pr}_${index}.m0 pr_ocm_${sub_qsys_pr}_${index}.s1
set_connection_parameter_value pr_mm_bdg_${sub_qsys_pr}_${index}.m0/pr_ocm_${sub_qsys_pr}_${index}.s1 arbitrationPriority {1}
if {$pr_persona == 1} {
set_connection_parameter_value pr_mm_bdg_${sub_qsys_pr}_${index}.m0/pr_ocm_${sub_qsys_pr}_${index}.s1 baseAddress {0x0}
} else {
set_connection_parameter_value pr_mm_bdg_${sub_qsys_pr}_${index}.m0/pr_ocm_${sub_qsys_pr}_${index}.s1 baseAddress {0x100}
}
set_connection_parameter_value pr_mm_bdg_${sub_qsys_pr}_${index}.m0/pr_ocm_${sub_qsys_pr}_${index}.s1 defaultConnection {0}

add_connection pr_clk_100_${sub_qsys_pr}_${index}.out_clk pr_mm_bdg_${sub_qsys_pr}_${index}.clk

add_connection pr_clk_100_${sub_qsys_pr}_${index}.out_clk pr_sysid_${sub_qsys_pr}_${index}.clk

add_connection pr_clk_100_${sub_qsys_pr}_${index}.out_clk pr_rst_in_${sub_qsys_pr}_${index}.clk

add_connection pr_rst_in_${sub_qsys_pr}_${index}.out_reset pr_sysid_${sub_qsys_pr}_${index}.reset

add_connection pr_rst_in_${sub_qsys_pr}_${index}.out_reset pr_mm_bdg_${sub_qsys_pr}_${index}.reset

add_connection pr_clk_100_${sub_qsys_pr}_${index}.out_clk pr_ocm_${sub_qsys_pr}_${index}.clk1

add_connection pr_rst_in_${sub_qsys_pr}_${index}.out_reset pr_ocm_${sub_qsys_pr}_${index}.reset1

# exported interfaces
add_interface clk clock sink
set_interface_property clk EXPORT_OF pr_clk_100_${sub_qsys_pr}_${index}.in_clk
add_interface pr_mm_bridge_0_s0 avalon slave
set_interface_property pr_mm_bridge_0_s0 EXPORT_OF pr_mm_bdg_${sub_qsys_pr}_${index}.s0
add_interface reset reset sink
set_interface_property reset EXPORT_OF pr_rst_in_${sub_qsys_pr}_${index}.in_reset

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {AUTO}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}

sync_sysinfo_parameters
save_system ${sub_qsys_pr}.qsys
