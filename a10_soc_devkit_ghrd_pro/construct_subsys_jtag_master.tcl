#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2016-2020 Intel Corporation.
#
#****************************************************************************
#
# This script construct JTAG AVMM MAster sub system for higher level integration
# The GHRD create_ghrd_qsys.tcl will call each of those subsystem construct script
# automatically based on the corresponding parameter argument defined
# --- alternatively, input arguments could be passed in to select other FPGA variant. 
#     sub_qsys_jtag: <name your sub qsys name>,
#     devicefamily : <FPGA device family>,
#     device       : <FPGA device part number>
#     f2sdram_count: 1 or 2
# example command to execute this script file
#   qsys-script --script=construct_subsys_jtag_master.tcl --cmd="set sub_qsys_jtag qsys_jtag"
#
#****************************************************************************

if {[ file exists ./design_config.tcl ]} {
  source ./design_config.tcl
}
    
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

if { ![ info exists niosii_en ] } {
  set niosii_en $NIOSII_EN
} else {
  puts "-- Accepted parameter \$niosii_en = $niosii_en"
}

if { ![ info exists f2sdram_count ] } {
  set f2sdram_count $F2SDRAM_COUNT
} else {
  puts "-- Accepted parameter \$f2sdram_count = $f2sdram_count"
}

if { ![ info exists sub_qsys_jtag ] } {
  set sub_qsys_jtag subsys_jtg_mst
} else {
  puts "-- Accepted parameter \$sub_qsys_jtag = $sub_qsys_jtag"
}

package require -exact qsys 17.1

create_system $sub_qsys_jtag

set_project_property DEVICE_FAMILY $devicefamily
set_project_property DEVICE $device
set_validation_property AUTOMATIC_VALIDATION false

add_component_param "altera_clock_bridge jtag_clk 
                     IP_FILE_PATH ip/$sub_qsys_jtag/jtag_clk.ip 
                    EXPLICIT_CLOCK_RATE 100000000.0 
                    NUM_CLOCK_OUTPUTS 1"

add_component_param "altera_reset_bridge jtag_rst_in 
                     IP_FILE_PATH ip/$sub_qsys_jtag/jtag_rst_in.ip  
                    ACTIVE_LOW_RESET 1  
                    SYNCHRONOUS_EDGES deassert  
                    NUM_RESET_OUTPUTS 1 
                    USE_RESET_REQUEST 0"

if {$niosii_en == 0} {  
add_component_param "altera_jtag_avalon_master hps_m 
                     IP_FILE_PATH ip/$sub_qsys_jtag/hps_m.ip"
}

for {set x 0} {$x<$f2sdram_count} {incr x} {
add_component_param "altera_jtag_avalon_master f2sdram_m_${x} 
                     IP_FILE_PATH ip/$sub_qsys_jtag/2sdram_m_${x}.ip"
}
add_component_param "altera_jtag_avalon_master fpga_m 
                     IP_FILE_PATH ip/$sub_qsys_jtag/fpga_m.ip"
add_instance fpga_m altera_jtag_avalon_master

# connections and connection parameters
add_connection jtag_clk.out_clk jtag_rst_in.clk

add_connection jtag_clk.out_clk fpga_m.clk

add_connection jtag_rst_in.out_reset fpga_m.clk_reset

if {$niosii_en == 0} {
add_connection jtag_clk.out_clk hps_m.clk

add_connection jtag_rst_in.out_reset hps_m.clk_reset
}

for {set x 0} {$x<$f2sdram_count} {incr x} {
add_connection jtag_clk.out_clk f2sdram_m_$x.clk

add_connection jtag_rst_in.out_reset f2sdram_m_$x.clk_reset
}

# exported interfaces
add_interface clk clock sink
set_interface_property clk EXPORT_OF jtag_clk.in_clk
add_interface reset reset sink
set_interface_property reset EXPORT_OF jtag_rst_in.in_reset
add_interface fpga_m_master avalon master
set_interface_property fpga_m_master EXPORT_OF fpga_m.master
if {$niosii_en == 0} {
add_interface hps_m_master_master avalon master
set_interface_property hps_m_master_master EXPORT_OF hps_m.master
}
for {set x 0} {$x<$f2sdram_count} {incr x} {
add_interface f2sdram_m_${x}_master avalon master
set_interface_property f2sdram_m_${x}_master EXPORT_OF f2sdram_m_${x}.master
}

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {AUTO}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
    
sync_sysinfo_parameters
save_system ${sub_qsys_jtag}.qsys
