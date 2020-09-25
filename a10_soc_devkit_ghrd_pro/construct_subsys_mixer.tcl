#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2016-2020 Intel Corporation.
#
#****************************************************************************
#
# This script construct sub system of VIP Mixer II for higher level integration
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
    
if { ![ info exists sub_qsys_vip ] } {
  set sub_qsys_vip subsys_mixer_pr
} else {
  puts "-- Accepted parameter \$sub_qsys_vip = $sub_qsys_vip"
}

if { ![ info exists pr_persona ] } {
  set pr_persona $PR_PERSONA
} else {
  puts "-- Accepted parameter \$pr_persona = $pr_persona"
}


package require -exact qsys 17.1

create_system $sub_qsys_vip

set_project_property DEVICE_FAMILY $devicefamily
set_project_property DEVICE $device

add_component_param "altera_clock_bridge mixer_clk_100 
                     IP_FILE_PATH ip/$sub_qsys_vip/mixer_clk_100.ip
                     EXPLICIT_CLOCK_RATE 100000000.0
                     NUM_CLOCK_OUTPUTS 1"

add_component_param "altera_reset_bridge mixer_rst_in 
                     IP_FILE_PATH ip/$sub_qsys_vip/mixer_rst_in.ip
                     ACTIVE_LOW_RESET 1
                     SYNCHRONOUS_EDGES deassert
                     NUM_RESET_OUTPUTS 1
                     USE_RESET_REQUEST 0"

add_component_param "altera_avalon_mm_bridge mixer_pr_mm_bdg 
                     IP_FILE_PATH ip/$sub_qsys_vip/mixer_pr_mm_bdg.ip
                     DATA_WIDTH 32
                     ADDRESS_WIDTH 22
                     USE_AUTO_ADDRESS_WIDTH 0
                     MAX_BURST_SIZE 1
                     MAX_PENDING_RESPONSES 1"

add_component_param "altera_avalon_onchip_memory2 onchip_mem 
                     IP_FILE_PATH ip/$sub_qsys_vip/onchip_mem.ip
                     DATA_WIDTH 32
                     initializationFileName control_onchip_mem
                     memorySize 90000.0
                     useNonDefaultInitFile 1
                     enPRInitMode 1"

add_component_param "altera_avalon_st_adapter st_adpt_0 
                     IP_FILE_PATH ip/$sub_qsys_vip/st_adpt_0.ip
                     inBitsPerSymbol 10
                     inUsePackets 1
                     inDataWidth 60
                     inMaxChannel 0
                     inChannelWidth 0
                     inErrorWidth 0
                     inUseEmptyPort 1
                     inReadyLatency 1
                     outDataWidth 60
                     outMaxChannel 0
                     outChannelWidth 0
                     outErrorWidth 0
                     outUseEmptyPort 1
                     outReadyLatency 1"

add_component_param "altera_avalon_st_adapter st_adpt_1 
                     IP_FILE_PATH ip/$sub_qsys_vip/st_adpt_1.ip
                     inBitsPerSymbol 10
                     inUsePackets 1
                     inDataWidth 60
                     inMaxChannel 0
                     inChannelWidth 0
                     inErrorWidth 0
                     inUseEmptyPort 1
                     inReadyLatency 1
                     outDataWidth 60
                     outMaxChannel 0
                     outChannelWidth 0
                     outErrorWidth 0
                     outUseEmptyPort 1
                     outReadyLatency 1"

if {$pr_persona == 1} {
add_component_param "alt_vip_cl_mixer mixer_0 
                     IP_FILE_PATH ip/$sub_qsys_vip/mixer_0.ip
                     BITS_PER_SYMBOL 10
                     NUMBER_OF_COLOR_PLANES 2
                     PIXELS_IN_PARALLEL 2
                     NO_OF_INPUTS 2
                     MAX_WIDTH 1920
                     MAX_HEIGHT 1080
                     PATTERN uniform
                     USER_PACKET_SUPPORT DISCARD
                     USER_PACKET_FIFO_DEPTH 0"

add_component_param "ICON_GEN_ST icon_gen 
                     IP_FILE_PATH ip/$sub_qsys_vip/icon_gen.ip"

add_component_param "altera_avalon_sysid_qsys mixer_pr_sysid 
                     IP_FILE_PATH ip/$sub_qsys_vip/mixer_pr_sysid.ip
                     id 2309737967"
} else {
add_component_param "altera_avalon_sysid_qsys mixer_pr_sysid 
                     IP_FILE_PATH ip/$sub_qsys_vip/mixer_pr_sysid.ip
                     id 19088743"
}
    
add_component_param "altera_clock_bridge clk_bdg_vid 
                     IP_FILE_PATH ip/$sub_qsys_vip/clk_bdg_vid.ip
                     EXPLICIT_CLOCK_RATE 74250000.0
                     NUM_CLOCK_OUTPUTS 1"

if {$pr_persona == 1} {
set_component_param "mixer_pr_sysid 
                    id 2309737967"
} else {
set_component_param "mixer_pr_sysid 
                    id 19088743"
}

# connections and connection parameters
if {$pr_persona == 1} {
add_connection mixer_pr_mm_bdg.m0 mixer_0.control
set_connection_parameter_value mixer_pr_mm_bdg.m0/mixer_0.control arbitrationPriority {1}
set_connection_parameter_value mixer_pr_mm_bdg.m0/mixer_0.control baseAddress {0x0000}
set_connection_parameter_value mixer_pr_mm_bdg.m0/mixer_0.control defaultConnection {0}

add_connection icon_gen.avalon_streaming_source mixer_0.din1

add_connection st_adpt_0.out_0 mixer_0.din0

add_connection mixer_0.dout st_adpt_1.in_0

add_connection clk_bdg_vid.out_clk icon_gen.avalon_st_clock

add_connection clk_bdg_vid.out_clk mixer_0.main_clock

add_connection mixer_rst_in.out_reset icon_gen.avalon_st_reset

add_connection mixer_rst_in.out_reset mixer_0.main_reset
} else {
add_connection st_adpt_0.out_0 st_adpt_1.in_0
}

add_connection mixer_pr_mm_bdg.m0 mixer_pr_sysid.control_slave
set_connection_parameter_value mixer_pr_mm_bdg.m0/mixer_pr_sysid.control_slave arbitrationPriority {1}
set_connection_parameter_value mixer_pr_mm_bdg.m0/mixer_pr_sysid.control_slave baseAddress {0x0200}
set_connection_parameter_value mixer_pr_mm_bdg.m0/mixer_pr_sysid.control_slave defaultConnection {0}

add_connection mixer_pr_mm_bdg.m0 onchip_mem.s1 
set_connection_parameter_value mixer_pr_mm_bdg.m0/onchip_mem.s1 arbitrationPriority {1}
set_connection_parameter_value mixer_pr_mm_bdg.m0/onchip_mem.s1 baseAddress {0x00200000}
set_connection_parameter_value mixer_pr_mm_bdg.m0/onchip_mem.s1 defaultConnection {0}

add_connection mixer_clk_100.out_clk mixer_pr_mm_bdg.clk

add_connection mixer_clk_100.out_clk mixer_pr_sysid.clk

add_connection mixer_clk_100.out_clk mixer_rst_in.clk

add_connection clk_bdg_vid.out_clk st_adpt_0.in_clk_0

add_connection clk_bdg_vid.out_clk st_adpt_1.in_clk_0

add_connection mixer_clk_100.out_clk onchip_mem.clk1

add_connection mixer_rst_in.out_reset mixer_pr_sysid.reset

add_connection mixer_rst_in.out_reset mixer_pr_mm_bdg.reset

add_connection mixer_rst_in.out_reset st_adpt_0.in_rst_0

add_connection mixer_rst_in.out_reset st_adpt_1.in_rst_0

add_connection mixer_rst_in.out_reset/onchip_mem.reset1

# exported interfaces
add_interface clk clock sink
set_interface_property clk EXPORT_OF mixer_clk_100.in_clk
add_interface clock_bridge_0_vid_in clock sink
set_interface_property clock_bridge_0_vid_in EXPORT_OF clk_bdg_vid.in_clk
add_interface st_adpt_in_pr avalon_streaming sink
set_interface_property st_adpt_in_pr EXPORT_OF st_adpt_0.in_0
add_interface st_adpt_out_pr avalon_streaming source
set_interface_property st_adpt_out_pr EXPORT_OF st_adpt_1.out_0
add_interface onchip_mem_freeze_interface conduit end
set_interface_property onchip_mem_freeze_interface EXPORT_OF onchip_mem.freeze_interface
add_interface pr_mm_bdg_s0 avalon slave
set_interface_property pr_mm_bdg_s0 EXPORT_OF mixer_pr_mm_bdg.s0
add_interface reset reset sink
set_interface_property reset EXPORT_OF mixer_rst_in.in_reset

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {AUTO}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}

sync_sysinfo_parameters
save_system ${sub_qsys_vip}.qsys
