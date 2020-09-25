#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2015-2020 Intel Corporation.
#
#****************************************************************************
#
# This script construct sub system of PCIe for higher level integration
# The GHRD create_ghrd_qsys.tcl will call each of those subsystem construct script
# automatically based on the corresponding parameter argument defined

# --- alternatively, input arguments could be passed in to select other FPGA variant. 
#     sub_qsys_pcie    : <name your subsystem qsys>,
#     devicefamily     : <FPGA device family>,
#     device           : <FPGA device part number>
#     pcie_gen         : 2 or 3
#     pcie_count       : 4 or 8 (x8 currently supported for gen2 only)
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

if { ![ info exists pcie_gen ] } {
  set pcie_gen $GEN_ENABLE
} else {
  puts "-- Accepted parameter \$pcie_gen = $pcie_gen"
}

if { ![ info exists pcie_count ] } {
  set pcie_count $PCIE_COUNT
} else {
  puts "-- Accepted parameter \$pcie_count = $pcie_count"
}
    
if { ![ info exists sub_qsys_pcie ] } {
  set sub_qsys_pcie subsys_pcie
} else {
  puts "-- Accepted parameter \$sub_qsys_pcie = $sub_qsys_pcie"
}

package require -exact qsys 17.1

create_system $sub_qsys_pcie

set_project_property DEVICE_FAMILY $devicefamily
set_project_property DEVICE $device

add_component_param "altera_address_span_extender ext_f2sdram 
                     IP_FILE_PATH ip/$sub_qsys_pcie/ext_f2sdram.ip
                     BURSTCOUNT_WIDTH 6
                     MASTER_ADDRESS_WIDTH 32
                     ENABLE_SLAVE_PORT 0
                     MAX_PENDING_READS 16"
if {$pcie_gen == 3 && $pcie_count == 8} {
set_component_param "ext_f2sdram    
                    DATA_WIDTH 256  
                    SLAVE_ADDRESS_WIDTH 25"
} else {
set_component_param "ext_f2sdram    
                    DATA_WIDTH 128  
                    SLAVE_ADDRESS_WIDTH 26"
}

add_component_param "altera_avalon_mm_clock_crossing_bridge ccb_h2f 
                     IP_FILE_PATH ip/$sub_qsys_pcie/ccb_h2f.ip
                     MAX_BURST_SIZE 32
                     ADDRESS_WIDTH 29
                     USE_AUTO_ADDRESS_WIDTH 1
                     COMMAND_FIFO_DEPTH 4
                     RESPONSE_FIFO_DEPTH 128"
if {$pcie_gen == 3 && $pcie_count == 8} {
set_component_param "ccb_h2f    
                    DATA_WIDTH 32"
} else {
set_component_param "ccb_h2f    
                    DATA_WIDTH 128"
}

add_component_param "altera_clock_bridge pcie_clk_100 
                     IP_FILE_PATH ip/$sub_qsys_pcie/pcie_clk_100.ip
                     EXPLICIT_CLOCK_RATE 100000000.0
                     NUM_CLOCK_OUTPUTS 1"

add_component_param "altera_reset_bridge pcie_rst_in 
                     IP_FILE_PATH ip/$sub_qsys_pcie/pcie_rst_in.ip
                     ACTIVE_LOW_RESET 1
                     SYNCHRONOUS_EDGES deassert
                     NUM_RESET_OUTPUTS 1
                     USE_RESET_REQUEST 0"

if {$pcie_gen == 3 || $pcie_count == 8} {
add_component_param "altera_clock_bridge pcie_clk_125 
                     IP_FILE_PATH ip/$sub_qsys_pcie/pcie_clk_125.ip
                     EXPLICIT_CLOCK_RATE 125000000.0
                     NUM_CLOCK_OUTPUTS 1"   
}

add_component_param "altera_clock_bridge coreclk_fan 
                     IP_FILE_PATH ip/$sub_qsys_pcie/coreclk_fan.ip
                     EXPLICIT_CLOCK_RATE 125000000.0
                     NUM_CLOCK_OUTPUTS 1"

add_component_param "altera_reset_bridge rst_in_coreclk_fan 
                     IP_FILE_PATH ip/$sub_qsys_pcie/rst_in_coreclk_fan.ip
                     ACTIVE_LOW_RESET 1
                     SYNCHRONOUS_EDGES deassert
                     NUM_RESET_OUTPUTS 1
                     USE_RESET_REQUEST 0"

add_component_param "altera_clock_bridge coreclk_out 
                     IP_FILE_PATH ip/$sub_qsys_pcie/coreclk_out.ip
                     EXPLICIT_CLOCK_RATE 125000000.0
                     NUM_CLOCK_OUTPUTS 1"
if {$pcie_gen == 3 || $pcie_count == 8} {
set_component_param "coreclk_out    
                    EXPLICIT_CLOCK_RATE 250000000.0"
} else {
set_component_param "coreclk_out    
                    EXPLICIT_CLOCK_RATE 125000000.0"
}

if { ($pcie_gen == 3 && $pcie_count != 8) || $pcie_gen == 2} {
add_component_param "altera_msgdma msgdma_0 
                     IP_FILE_PATH ip/$sub_qsys_pcie/msgdma_0.ip
                     MODE 0
                     USE_FIX_ADDRESS_WIDTH 0
                     FIX_ADDRESS_WIDTH 32
                     DATA_FIFO_DEPTH 256
                     DESCRIPTOR_FIFO_DEPTH 8
                     RESPONSE_PORT 2
                     MAX_BYTE 524288
                     TRANSFER_TYPE {Full Word Accesses Only}
                     BURST_ENABLE 1"
if {$pcie_count == 8 || $pcie_gen == 3} {
set_component_param "msgdma_0   
                    DATA_WIDTH 256  
                    MAX_BURST_COUNT 16"
} else {
set_component_param "msgdma_0   
                    DATA_WIDTH 128  
                    MAX_BURST_COUNT 32"
}

add_component_param "altera_avalon_mm_bridge pb_addr_0 
                     IP_FILE_PATH ip/$sub_qsys_pcie/pb_addr_0.ip
                     DATA_WIDTH 128
                     MAX_BURST_SIZE 32
                     ADDRESS_WIDTH 29
                     USE_AUTO_ADDRESS_WIDTH 1
                     MAX_PENDING_RESPONSES 16"
}

add_component_param "altera_msi_to_gic_gen msi_irq 
                     IP_FILE_PATH ip/$sub_qsys_pcie/msi_irq.ip
                     MSG_DATA_WORD 32
                     DATA_ENTRY_DEPTH 4
                     MEMORY_TYPE RAM_BLOCK_TYPE=MLAB"

add_component_param "altera_reset_bridge hps_nrst 
                     IP_FILE_PATH ip/$sub_qsys_pcie/hps_nrst.ip
                     ACTIVE_LOW_RESET 1
                     SYNCHRONOUS_EDGES deassert
                     NUM_RESET_OUTPUTS 1
                     USE_RESET_REQUEST 0"

add_component_param "altera_avalon_mm_bridge pb_2_ocm 
                     IP_FILE_PATH ip/$sub_qsys_pcie/pb_2_ocm.ip
                     MAX_BURST_SIZE 32
                     ADDRESS_WIDTH 18
                     USE_AUTO_ADDRESS_WIDTH 0
                     MAX_PENDING_RESPONSES 16"
if {$pcie_gen == 3 && $pcie_count == 8} {
set_component_param "pb_2_ocm   
                    DATA_WIDTH 256"
} else {
set_component_param "pb_2_ocm   
                    DATA_WIDTH 128"
}

add_component_param "altera_avalon_mm_bridge pb_periph 
                     IP_FILE_PATH ip/$sub_qsys_pcie/pb_periph.ip
                     DATA_WIDTH 32
                     ADDRESS_WIDTH 10
                     USE_AUTO_ADDRESS_WIDTH 1
                     MAX_BURST_SIZE 1
                     MAX_PENDING_RESPONSES 1"

add_component_param "altera_avalon_mm_bridge pb_addr_1 
                     IP_FILE_PATH ip/$sub_qsys_pcie/pb_addr_1.ip
                     DATA_WIDTH 32
                     ADDRESS_WIDTH 7
                     USE_AUTO_ADDRESS_WIDTH 1
                     MAX_BURST_SIZE 1
                     MAX_PENDING_RESPONSES 2"

add_component_param "altera_pcie_a10_hip pcie_a10 
                     IP_FILE_PATH ip/$sub_qsys_pcie/pcie_a10.ip
                     interface_type_hwtcl {Avalon-MM}
                     port_type_hwtcl {Root port}
                     rx_buffer_credit_alloc_hwtcl Balanced
                     avmm_addr_width_hwtcl 32
                     enable_hip_status_for_avmm_hwtcl 1
                     cg_a2p_addr_map_num_entries_hwtcl 2
                     cg_a2p_addr_map_pass_thru_bits_hwtcl 27
                     bar2_type_hwtcl Disabled
                     bar2_address_width_hwtcl 0
                     adme_enable_hwtcl 1
                     device_id_hwtcl 57344
                     revision_id_hwtcl 1
                     class_code_hwtcl 394240
                     subsystem_vendor_id_hwtcl 4466
                     subsystem_device_id_hwtcl 57344
                     maximum_payload_size_hwtcl 256
                     completion_timeout_hwtcl ABCD
                     advance_error_reporting_hwtcl 1"
if {$pcie_gen == 3} {
if {$pcie_count == 8} {
set_component_param "pcie_a10   
                    wrala_hwtcl 0"
} else {
set_component_param "pcie_a10   
                    wrala_hwtcl 2"
}
} else {
# for Gen2 wih x4 or x8
if {$pcie_count == 8} {
set_component_param "pcie_a10   
                    wrala_hwtcl 7"
} else {
set_component_param "pcie_a10   
                    wrala_hwtcl 8"
}
}
if {$pcie_gen == 3} {
set_component_param "pcie_a10   
                    deemphasis_enable_hwtcl 1"
} else {
set_component_param "pcie_a10   
                    deemphasis_enable_hwtcl 0"
}

add_component_param "altera_avalon_performance_counter perf_cnt_0 
                     IP_FILE_PATH ip/$sub_qsys_pcie/perf_cnt_0.ip
                     numberOfSections 1"

# connections and connection parameters
add_connection pcie_clk_100.out_clk pcie_rst_in.clk
if { ($pcie_gen == 3 && $pcie_count != 8) || $pcie_gen == 2} {
if {$pcie_count == 8 || $pcie_gen == 3} {
add_connection pcie_clk_125.out_clk msgdma_0.clock 
} else { 
add_connection pcie_a10.coreclkout_hip msgdma_0.clock
}
add_connection pcie_a10.app_nreset_status msgdma_0.reset_n 

add_connection pcie_rst_in.out_reset msgdma_0.reset_n 

add_connection pb_periph.m0 msgdma_0.csr 
set_connection_parameter_value pb_periph.m0/msgdma_0.csr arbitrationPriority {1}
set_connection_parameter_value pb_periph.m0/msgdma_0.csr baseAddress {0x40c0}
set_connection_parameter_value pb_periph.m0/msgdma_0.csr defaultConnection {0}

add_connection pb_periph.m0 msgdma_0.descriptor_slave 
set_connection_parameter_value pb_periph.m0/msgdma_0.descriptor_slave arbitrationPriority {1}
set_connection_parameter_value pb_periph.m0/msgdma_0.descriptor_slave baseAddress {0x40e0}
set_connection_parameter_value pb_periph.m0/msgdma_0.descriptor_slave defaultConnection {0}

add_connection msgdma_0.mm_read pb_addr_0.s0 
set_connection_parameter_value msgdma_0.mm_read/pb_addr_0.s0 arbitrationPriority {1}
set_connection_parameter_value msgdma_0.mm_read/pb_addr_0.s0 baseAddress {0xd0000000}
set_connection_parameter_value msgdma_0.mm_read/pb_addr_0.s0 defaultConnection {0}

add_connection msgdma_0.mm_write pb_addr_0.s0 
set_connection_parameter_value msgdma_0.mm_write/pb_addr_0.s0 arbitrationPriority {1}
set_connection_parameter_value msgdma_0.mm_write/pb_addr_0.s0 baseAddress {0xd0000000}
set_connection_parameter_value msgdma_0.mm_write/pb_addr_0.s0 defaultConnection {0} 

add_connection msgdma_0.mm_read pb_2_ocm.s0 
set_connection_parameter_value msgdma_0.mm_read/pb_2_ocm.s0 arbitrationPriority {1}
set_connection_parameter_value msgdma_0.mm_read/pb_2_ocm.s0 baseAddress {0x40000000}
set_connection_parameter_value msgdma_0.mm_read/pb_2_ocm.s0 defaultConnection {0}

add_connection msgdma_0.mm_write pb_2_ocm.s0 
set_connection_parameter_value msgdma_0.mm_write/pb_2_ocm.s0 arbitrationPriority {1}
set_connection_parameter_value msgdma_0.mm_write/pb_2_ocm.s0 baseAddress {0x40000000}
set_connection_parameter_value msgdma_0.mm_write/pb_2_ocm.s0 defaultConnection {0}

add_connection msgdma_0.mm_read ext_f2sdram.windowed_slave 
set_connection_parameter_value msgdma_0.mm_read/ext_f2sdram.windowed_slave arbitrationPriority {1}
set_connection_parameter_value msgdma_0.mm_read/ext_f2sdram.windowed_slave baseAddress {0x0000}
set_connection_parameter_value msgdma_0.mm_read/ext_f2sdram.windowed_slave defaultConnection {0}

add_connection msgdma_0.mm_write ext_f2sdram.windowed_slave 
set_connection_parameter_value msgdma_0.mm_write/ext_f2sdram.windowed_slave arbitrationPriority {1}
set_connection_parameter_value msgdma_0.mm_write/ext_f2sdram.windowed_slave baseAddress {0x0000}
set_connection_parameter_value msgdma_0.mm_write/ext_f2sdram.windowed_slave defaultConnection {0}

add_connection pcie_a10.rxm_bar0 pb_2_ocm.s0 
set_connection_parameter_value pcie_a10.rxm_bar0/pb_2_ocm.s0 arbitrationPriority {1}
set_connection_parameter_value pcie_a10.rxm_bar0/pb_2_ocm.s0 baseAddress {0x40000000}
set_connection_parameter_value pcie_a10.rxm_bar0/pb_2_ocm.s0 defaultConnection {0}

add_connection pb_addr_0.m0 pcie_a10.txs 
set_connection_parameter_value pb_addr_0.m0/pcie_a10.txs arbitrationPriority {1}
set_connection_parameter_value pb_addr_0.m0/pcie_a10.txs baseAddress {0x0000}
set_connection_parameter_value pb_addr_0.m0/pcie_a10.txs defaultConnection {0}
} else {
add_connection pcie_a10.rxm_bar0 pb_2_ocm.s0 
set_connection_parameter_value pcie_a10.rxm_bar0/pb_2_ocm.s0 arbitrationPriority {1}
set_connection_parameter_value pcie_a10.rxm_bar0/pb_2_ocm.s0 baseAddress {0x40000000}
set_connection_parameter_value pcie_a10.rxm_bar0/pb_2_ocm.s0 defaultConnection {0}
}

add_connection pcie_a10.rxm_bar0 ext_f2sdram.windowed_slave 
set_connection_parameter_value pcie_a10.rxm_bar0/ext_f2sdram.windowed_slave arbitrationPriority {1}
set_connection_parameter_value pcie_a10.rxm_bar0/ext_f2sdram.windowed_slave baseAddress {0x0000}
set_connection_parameter_value pcie_a10.rxm_bar0/ext_f2sdram.windowed_slave defaultConnection {0}

add_connection pcie_a10.coreclkout_hip ext_f2sdram.clock 

add_connection pb_periph.m0 perf_cnt_0.control_slave 
set_connection_parameter_value pb_periph.m0/perf_cnt_0.control_slave arbitrationPriority {1}
set_connection_parameter_value pb_periph.m0/perf_cnt_0.control_slave baseAddress {0x40a0}
set_connection_parameter_value pb_periph.m0/perf_cnt_0.control_slave defaultConnection {0}

add_connection pb_periph.m0 pcie_a10.cra 
set_connection_parameter_value pb_periph.m0/pcie_a10.cra arbitrationPriority {1}
set_connection_parameter_value pb_periph.m0/pcie_a10.cra baseAddress {0x0000}
set_connection_parameter_value pb_periph.m0/pcie_a10.cra defaultConnection {0}

add_connection pb_periph.m0 msi_irq.csr 
set_connection_parameter_value pb_periph.m0/msi_irq.csr arbitrationPriority {1}
set_connection_parameter_value pb_periph.m0/msi_irq.csr baseAddress {0x4080}
set_connection_parameter_value pb_periph.m0/msi_irq.csr defaultConnection {0}

add_connection ccb_h2f.m0 pcie_a10.txs 
set_connection_parameter_value ccb_h2f.m0/pcie_a10.txs arbitrationPriority {1}
set_connection_parameter_value ccb_h2f.m0/pcie_a10.txs baseAddress {0x0000}
set_connection_parameter_value ccb_h2f.m0/pcie_a10.txs defaultConnection {0}

add_connection pb_periph.m0 msi_irq.vector_slave 
set_connection_parameter_value pb_periph.m0/msi_irq.vector_slave arbitrationPriority {1}
set_connection_parameter_value pb_periph.m0/msi_irq.vector_slave baseAddress {0x4000}
set_connection_parameter_value pb_periph.m0/msi_irq.vector_slave defaultConnection {0}

add_connection pb_addr_1.m0 msi_irq.vector_slave 
set_connection_parameter_value pb_addr_1.m0/msi_irq.vector_slave arbitrationPriority {1}
set_connection_parameter_value pb_addr_1.m0/msi_irq.vector_slave baseAddress {0x4000}
set_connection_parameter_value pb_addr_1.m0/msi_irq.vector_slave defaultConnection {0}

add_connection pcie_a10.rxm_bar0 pb_addr_1.s0 
set_connection_parameter_value pcie_a10.rxm_bar0/pb_addr_1.s0 arbitrationPriority {1}
set_connection_parameter_value pcie_a10.rxm_bar0/pb_addr_1.s0 baseAddress {0xff210000}
set_connection_parameter_value pcie_a10.rxm_bar0/pb_addr_1.s0 defaultConnection {0}

if { ($pcie_gen == 3 && $pcie_count != 8) || $pcie_gen == 2} {
add_connection pcie_a10.coreclkout_hip pb_addr_0.clk 

add_connection pcie_a10.app_nreset_status pb_addr_0.reset 

add_connection pcie_rst_in.out_reset pb_addr_0.reset
}

if {$pcie_gen == 3  || $pcie_count == 8} {
add_connection pcie_clk_125.out_clk ccb_h2f.s0_clk 

#temporary feed to pcie_clk_100 due to dts generation issue
# add_connection pcie_clk_125.out_clk perf_cnt_0.clk 

# add_connection pcie_clk_125.out_clk msi_irq.clock  

add_connection pcie_clk_100.out_clk perf_cnt_0.clk 

add_connection pcie_clk_100.out_clk msi_irq.clock  
} else {
add_connection pcie_clk_100.out_clk ccb_h2f.s0_clk

#temporary feed to pcie_clk_100 due to dts generation issue
# add_connection pcie_a10.coreclkout_hip perf_cnt_0.clk 

# add_connection pcie_a10.coreclkout_hip msi_irq.clock 
    
add_connection pcie_clk_100.out_clk perf_cnt_0.clk 

add_connection pcie_clk_100.out_clk msi_irq.clock  
}

add_connection pcie_a10.coreclkout_hip hps_nrst.clk 

add_connection pcie_a10.coreclkout_hip pb_periph.clk   

add_connection pcie_a10.coreclkout_hip pb_addr_1.clk 

add_connection pcie_a10.coreclkout_hip pb_2_ocm.clk 

add_connection pcie_a10.coreclkout_hip coreclk_fan.in_clk 

add_connection pcie_a10.coreclkout_hip coreclk_out.in_clk 

add_connection pcie_a10.coreclkout_hip ccb_h2f.m0_clk 

add_connection pcie_a10.coreclkout_hip rst_in_coreclk_fan.clk

add_connection pcie_a10.app_nreset_status rst_in_coreclk_fan.in_reset 

add_connection pcie_a10.app_nreset_status hps_nrst.in_reset 

add_connection pcie_a10.app_nreset_status pb_addr_1.reset 

add_connection pcie_a10.app_nreset_status pb_periph.reset 

add_connection pcie_a10.app_nreset_status pb_2_ocm.reset 

add_connection pcie_a10.app_nreset_status ext_f2sdram.reset 

add_connection pcie_a10.app_nreset_status perf_cnt_0.reset 

add_connection pcie_a10.app_nreset_status msi_irq.reset 

add_connection pcie_a10.app_nreset_status ccb_h2f.s0_reset 

add_connection pcie_a10.app_nreset_status ccb_h2f.m0_reset 

add_connection pcie_rst_in.out_reset ccb_h2f.m0_reset 

add_connection pcie_rst_in.out_reset ext_f2sdram.reset 

add_connection pcie_rst_in.out_reset msi_irq.reset 

add_connection pcie_rst_in.out_reset perf_cnt_0.reset 

add_connection pcie_rst_in.out_reset pb_addr_1.reset 

add_connection pcie_rst_in.out_reset pb_periph.reset 

add_connection pcie_rst_in.out_reset pb_2_ocm.reset 

add_connection pcie_rst_in.out_reset ccb_h2f.s0_reset 

# exported interfaces
if { ($pcie_gen == 3 && $pcie_count != 8) || $pcie_gen == 2} {
if {$pcie_count == 8 || $pcie_gen == 3} {
add_interface clk_125_in_clk clock sink
set_interface_property clk_125_in_clk EXPORT_OF pcie_clk_125.in_clk
}
add_interface msgdma_0_csr_irq interrupt sender
set_interface_property msgdma_0_csr_irq EXPORT_OF msgdma_0.csr_irq
} else {
add_interface clk_125_in_clk clock sink
set_interface_property clk_125_in_clk EXPORT_OF pcie_clk_125.in_clk
}

add_interface address_span_extender_0_expanded_master avalon master
set_interface_property address_span_extender_0_expanded_master EXPORT_OF ext_f2sdram.expanded_master
add_interface ccb_h2f_s0 avalon slave
set_interface_property ccb_h2f_s0 EXPORT_OF ccb_h2f.s0
add_interface clk clock sink
set_interface_property clk EXPORT_OF pcie_clk_100.in_clk
add_interface reset reset sink
set_interface_property reset EXPORT_OF pcie_rst_in.in_reset
add_interface coreclk_fanout_clk clock source
set_interface_property coreclk_fanout_clk EXPORT_OF coreclk_fan.out_clk
add_interface coreclk_fanout_clk_reset reset source
set_interface_property coreclk_fanout_clk_reset EXPORT_OF rst_in_coreclk_fan.out_reset
add_interface coreclkout_out clock source
set_interface_property coreclkout_out EXPORT_OF coreclk_out.out_clk
add_interface msi_to_gic_gen_0_interrupt_sender interrupt sender
set_interface_property msi_to_gic_gen_0_interrupt_sender EXPORT_OF msi_irq.interrupt_sender
add_interface nreset_status_out_reset reset source
set_interface_property nreset_status_out_reset EXPORT_OF hps_nrst.out_reset
add_interface pb_2_ocm_m0 avalon master
set_interface_property pb_2_ocm_m0 EXPORT_OF pb_2_ocm.m0
add_interface pb_lwh2f_pcie_s0 avalon slave
set_interface_property pb_lwh2f_pcie_s0 EXPORT_OF pb_periph.s0
add_interface pcie_a10_hip_avmm_cra_irq interrupt sender
set_interface_property pcie_a10_hip_avmm_cra_irq EXPORT_OF pcie_a10.cra_irq
add_interface pcie_a10_hip_avmm_currentspeed conduit end
set_interface_property pcie_a10_hip_avmm_currentspeed EXPORT_OF pcie_a10.currentspeed
add_interface pcie_a10_hip_avmm_hip_ctrl conduit end
set_interface_property pcie_a10_hip_avmm_hip_ctrl EXPORT_OF pcie_a10.hip_ctrl
add_interface pcie_a10_hip_avmm_hip_pipe conduit end
set_interface_property pcie_a10_hip_avmm_hip_pipe EXPORT_OF pcie_a10.hip_pipe
add_interface pcie_a10_hip_avmm_hip_serial conduit end
set_interface_property pcie_a10_hip_avmm_hip_serial EXPORT_OF pcie_a10.hip_serial
add_interface pcie_a10_hip_avmm_hip_status conduit end
set_interface_property pcie_a10_hip_avmm_hip_status EXPORT_OF pcie_a10.hip_status
add_interface pcie_a10_hip_avmm_npor conduit end
set_interface_property pcie_a10_hip_avmm_npor EXPORT_OF pcie_a10.npor
add_interface pcie_a10_hip_avmm_refclk clock sink
set_interface_property pcie_a10_hip_avmm_refclk EXPORT_OF pcie_a10.refclk
add_interface pcie_a10_hip_avmm_rxm_irq interrupt receiver
set_interface_property pcie_a10_hip_avmm_rxm_irq EXPORT_OF pcie_a10.rxm_irq

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {AUTO}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}

if {$pcie_count == 8 || $pcie_gen == 3} {
set_interconnect_requirement {mm_interconnect_2|async_fifo_001.out/cmd_mux_001.sink0} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_2|async_fifo_002.out/cmd_mux_002.sink0} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_2|async_fifo_004.out/cmd_mux_001.sink1} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_2|async_fifo_005.out/cmd_mux_002.sink1} {qsys_mm.postTransform.pipelineCount} {1}
if {$pcie_gen == 2} {
set_interconnect_requirement {mm_interconnect_2|cmd_demux_002.src1/cmd_mux_002.sink2} qsys_mm.postTransform.pipelineCount {1}
set_interconnect_requirement {mm_interconnect_2|cmd_mux_002.src/ext_f2sdram_windowed_slave_agent.cp} qsys_mm.postTransform.pipelineCount {1}
}
}
if {$pcie_gen == 3} {
set_interconnect_requirement {mm_interconnect_2|pcie_a10_rxm_bar0_agent.cp/router_002.sink} qsys_mm.postTransform.pipelineCount {1}
if {$pcie_count == 8} {
set_interconnect_requirement {mm_interconnect_2|pcie_a10_rxm_bar0_agent.cp/router.sink} qsys_mm.postTransform.pipelineCount {1}
set_interconnect_requirement {mm_interconnect_2|pcie_a10_rxm_bar0_limiter.cmd_src/cmd_demux.sink} qsys_mm.postTransform.pipelineCount {1}
# set_interconnect_requirement {mm_interconnect_2|router.src/pcie_a10_rxm_bar0_limiter.cmd_sink} qsys_mm.postTransform.pipelineCount {1}
} else {
set_interconnect_requirement {mm_interconnect_2|async_fifo.out/cmd_mux.sink0} qsys_mm.postTransform.pipelineCount {1}
set_interconnect_requirement {mm_interconnect_2|pcie_a10_rxm_bar0_limiter.cmd_src/cmd_demux_002.sink} qsys_mm.postTransform.pipelineCount {1}
# set_interconnect_requirement {mm_interconnect_2|router_002.src/pcie_a10_rxm_bar0_limiter.cmd_sink} qsys_mm.postTransform.pipelineCount {1}
set_interconnect_requirement {mm_interconnect_1|pb_addr_0_m0_agent.cp/router_001.sink} qsys_mm.postTransform.pipelineCount {1}
set_interconnect_requirement {mm_interconnect_1|pb_addr_0_m0_cmd_width_adapter.src/cmd_demux_001.sink} qsys_mm.postTransform.pipelineCount {1}
# set_interconnect_requirement {mm_interconnect_1|router_001.src/pb_addr_0_m0_cmd_width_adapter.sink} qsys_mm.postTransform.pipelineCount {1}
}
}   

sync_sysinfo_parameters
save_system ${sub_qsys_pcie}.qsys
