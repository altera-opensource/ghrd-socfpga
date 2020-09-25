#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2017-2020 Intel Corporation.
#
#****************************************************************************
#
# This script construct sub system of PCIe for higher level integration
# The GHRD create_ghrd_qsys.tcl will call each of those subsystem construct script
# automatically based on the corresponding parameter argument defined
#
#****************************************************************************

source ./arguments_solver.tcl
source ./utils.tcl

if { ![ info exists sub_qsys_pcie ] } {
  set sub_qsys_pcie subsys_pcie
} else {
  puts "-- Accepted parameter \$sub_qsys_pcie = $sub_qsys_pcie"
}

set pcie_inst "pcie_s10"

package require -exact qsys 18.1

create_system $sub_qsys_pcie

set_project_property DEVICE_FAMILY $device_family
set_project_property DEVICE $device

# add_component_param "altera_avalon_mm_clock_crossing_bridge txs_ccb
                     # IP_FILE_PATH ip/$sub_qsys_pcie/txs_ccb.ip
                     # MAX_BURST_SIZE 16
                     # USE_AUTO_ADDRESS_WIDTH 1
                     # COMMAND_FIFO_DEPTH 4
                     # RESPONSE_FIFO_DEPTH 128
                     # SLAVE_SYNC_DEPTH 3"

add_component_param "altera_address_span_extender ext_f2sdram 
                     IP_FILE_PATH ip/$sub_qsys_pcie/ext_f2sdram.ip
                     BURSTCOUNT_WIDTH 6
                     MASTER_ADDRESS_WIDTH 33
                     ENABLE_SLAVE_PORT 0
                     MAX_PENDING_READS 16
                     DATA_WIDTH 128 
                     SLAVE_ADDRESS_WIDTH 27"
                
add_component_param "altera_address_span_extender ext_f2sdram_upper2GB
                     IP_FILE_PATH ip/$sub_qsys_pcie/ext_f2sdram_upper2GB.ip
                     BURSTCOUNT_WIDTH 6
                     MASTER_ADDRESS_WIDTH 33
                     ENABLE_SLAVE_PORT 0
                     MAX_PENDING_READS 16
                     DATA_WIDTH 128 
                     SLAVE_ADDRESS_WIDTH 27
                     MASTER_ADDRESS_DEF 0x180000000"

add_component_param "altera_clock_bridge pcie_clk_100 
                     IP_FILE_PATH ip/$sub_qsys_pcie/pcie_clk_100.ip
                     EXPLICIT_CLOCK_RATE 100000000.0
                     NUM_CLOCK_OUTPUTS 1"

add_component_param "altera_reset_bridge pcie_rst_in 
                     IP_FILE_PATH ip/$sub_qsys_pcie/pcie_rst_in.ip
                     ACTIVE_LOW_RESET 1
                     SYNCHRONOUS_EDGES both
                     NUM_RESET_OUTPUTS 1
                     USE_RESET_REQUEST 0"

add_component_param "altera_clock_bridge coreclk_out 
                     IP_FILE_PATH ip/$sub_qsys_pcie/coreclk_out.ip
                     EXPLICIT_CLOCK_RATE 250000000.0
                     NUM_CLOCK_OUTPUTS 1"
                             
add_component_param "altera_msi_to_gic_gen msi_irq 
                     IP_FILE_PATH ip/$sub_qsys_pcie/msi_irq.ip
                     MSG_DATA_WORD 32
                     DATA_ENTRY_DEPTH 4
                     MEMORY_TYPE RAM_BLOCK_TYPE=M20K"                    

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
                     DATA_WIDTH 256
                     USE_AUTO_ADDRESS_WIDTH 0
                     MAX_PENDING_RESPONSES 16"

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
                 
                    
add_component_param "altera_pcie_s10_hip_avmm_bridge $pcie_inst 
                     IP_FILE_PATH ip/$sub_qsys_pcie/$pcie_inst.ip
                     virtual_rp_ep_mode_hwtcl {Root Port}
                     enable_hip_status_for_avmm_hwtcl 1
                     user_txs_address_width_hwtcl 27
                     pf0_pci_type0_device_id_hwtcl 57344
                     pf0_revision_id_hwtcl 1
                     hip_reconfig_hwtcl 1
                     pf0_class_code_hwtcl 394240
                     pf0_subsys_vendor_id_hwtcl 4466
                     pf0_subsys_dev_id_hwtcl 57344
                     virtual_maxpayload_size_hwtcl 512
                     avmm_addr_width_hwtcl 64"

if {($pcie_gen == 3 && $pcie_count == 8) || ($pcie_gen == 2 && $pcie_count == 16)} {
set_component_param "$pcie_inst 
                    wrala_hwtcl {Gen${pcie_gen}x${pcie_count}, Interface - 256 bit, 250 MHz}"
} else {
set_component_param "$pcie_inst 
                    wrala_hwtcl {Gen${pcie_gen}x${pcie_count}, Interface - 256 bit, 125 MHz}"
}

if {$pcie_hptxs == 1} {
set_component_param "$pcie_inst                      
                     hptxs_enabled_mapping_hwtcl 1
                     hptxs_address_translation_table_address_width_hwtcl 1
                     hptxs_address_translation_window_address_width_hwtcl 27
                     hptxs_enabled_hwtcl 1"
} else {
set_component_param "$pcie_inst 
                     txs_enabled_hwtcl 1"
}                   
                     
add_component_param "altera_avalon_performance_counter perf_cnt_0 
                     IP_FILE_PATH ip/$sub_qsys_pcie/perf_cnt_0.ip
                     numberOfSections 1"

# connections and connection parameters
connect "   pcie_clk_100.out_clk ${pcie_inst}.hip_reconfig_clk
            pcie_clk_100.out_clk pcie_rst_in.clk
            pcie_clk_100.out_clk perf_cnt_0.clk 
            pcie_clk_100.out_clk msi_irq.clock
            ${pcie_inst}.coreclkout_hip ext_f2sdram.clock
            ${pcie_inst}.coreclkout_hip ext_f2sdram_upper2GB.clock
            ${pcie_inst}.coreclkout_hip hps_nrst.clk
            ${pcie_inst}.coreclkout_hip pb_periph.clk 
            ${pcie_inst}.coreclkout_hip pb_addr_1.clk
            ${pcie_inst}.coreclkout_hip pb_2_ocm.clk
            ${pcie_inst}.coreclkout_hip coreclk_out.in_clk
            ${pcie_inst}.app_nreset_status ${pcie_inst}.hip_reconfig_rst
            ${pcie_inst}.app_nreset_status hps_nrst.in_reset
            ${pcie_inst}.app_nreset_status pb_addr_1.reset
            ${pcie_inst}.app_nreset_status pb_periph.reset
            ${pcie_inst}.app_nreset_status pb_2_ocm.reset
            ${pcie_inst}.app_nreset_status ext_f2sdram.reset
            ${pcie_inst}.app_nreset_status ext_f2sdram_upper2GB.reset
            ${pcie_inst}.app_nreset_status perf_cnt_0.reset
            ${pcie_inst}.app_nreset_status msi_irq.reset
            pcie_rst_in.out_reset ext_f2sdram.reset
            pcie_rst_in.out_reset ext_f2sdram_upper2GB.reset
            pcie_rst_in.out_reset msi_irq.reset
            pcie_rst_in.out_reset perf_cnt_0.reset
            pcie_rst_in.out_reset pb_addr_1.reset
            pcie_rst_in.out_reset pb_periph.reset
            pcie_rst_in.out_reset pb_2_ocm.reset"

# connect " pcie_clk_100.out_clk txs_ccb.m0_clk 
            # ${pcie_inst}.coreclkout_hip txs_ccb.s0_clk
            # ${pcie_inst}.app_nreset_status txs_ccb.m0_reset
            # ${pcie_inst}.app_nreset_status txs_ccb.s0_reset
            # pcie_rst_in.out_reset txs_ccb.m0_reset
            # pcie_rst_in.out_reset txs_ccb.s0_reset"

connect_map "${pcie_inst}.rxm_bar0 pb_2_ocm.s0 0x80000000"

connect_map "${pcie_inst}.rxm_bar0 ext_f2sdram.windowed_slave 0x0"
connect_map "${pcie_inst}.rxm_bar0 ext_f2sdram_upper2GB.windowed_slave 0x180000000"

connect_map "pb_periph.m0 perf_cnt_0.control_slave 0x80a0"

connect_map "pb_periph.m0 ${pcie_inst}.cra 0x0"

connect_map "pb_periph.m0 msi_irq.csr 0x8080"

connect_map "pb_periph.m0 msi_irq.vector_slave 0x8000"

connect_map "pb_addr_1.m0 msi_irq.vector_slave 0x8000"

connect_map "${pcie_inst}.rxm_bar0 pb_addr_1.s0 0xf9010000"

# if {$pcie_hptxs == 1} {
# connect_map "txs_ccb.m0 ${pcie_inst}.hptxs 0x0"
# } else {
# connect_map "txs_ccb.m0 ${pcie_inst}.txs 0x0"
# }
# exported interfaces
# export txs_ccb s0 txs_ccb

if {$pcie_hptxs == 1} {
export ${pcie_inst} hptxs hptxs
} else {
export ${pcie_inst} txs txs
}

export ${pcie_inst} hip_reconfig hip_reconfig

export ext_f2sdram            expanded_master ext_expanded_master
export ext_f2sdram_upper2GB   expanded_master ext_expanded_master_upper2GB

export pcie_clk_100 in_clk clk

export pcie_rst_in in_reset reset

export coreclk_out out_clk coreclkout_out

export msi_irq interrupt_sender msi2gic_interrupt

export hps_nrst out_reset nreset_status_out

export pb_2_ocm m0 pb_2_ocm_m0

export pb_periph s0 pb_lwh2f_pcie

export ${pcie_inst} cra_irq pcie_hip_cra_irq

export ${pcie_inst} currentspeed pcie_hip_currentspeed

export ${pcie_inst} hip_ctrl pcie_hip_ctrl

export ${pcie_inst} hip_pipe pcie_hip_pipe

export ${pcie_inst} hip_serial pcie_hip_serial

export ${pcie_inst} hip_status pcie_hip_status

export ${pcie_inst} npor pcie_hip_npor

export ${pcie_inst} refclk pcie_hip_refclk

export ${pcie_inst} rxm_irq pcie_rxm_irq

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {AUTO}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {4}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}

set_interconnect_requirement {mm_interconnect_1|pcie_s10_rxm_bar0_agent.cp/router.sink} qsys_mm.postTransform.pipelineCount {1}
set_interconnect_requirement {mm_interconnect_1|pcie_s10_rxm_bar0_limiter.cmd_src/cmd_demux.sink} qsys_mm.postTransform.pipelineCount {1}
set_interconnect_requirement {mm_interconnect_1|router.src/pcie_s10_rxm_bar0_limiter.cmd_sink} qsys_mm.postTransform.pipelineCount {1}
set_interconnect_requirement {mm_interconnect_1|ext_f2sdram_windowed_slave_cmd_width_adapter.src/ext_f2sdram_windowed_slave_agent.cp} qsys_mm.postTransform.pipelineCount {1}
set_interconnect_requirement {mm_interconnect_1|ext_f2sdram_upper2GB_windowed_slave_cmd_width_adapter.src/ext_f2sdram_upper2GB_windowed_slave_agent.cp} qsys_mm.postTransform.pipelineCount {1}

sync_sysinfo_parameters
save_system ${sub_qsys_pcie}.qsys
