#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2020 Intel Corporation.
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

set pcie_inst "pcie_agilex"

package require -exact qsys 19.1

create_system $sub_qsys_pcie

set_project_property DEVICE_FAMILY $device_family
set_project_property DEVICE $device

if {$f2h_width > 0} {
add_component_param "altera_address_span_extender ext_f2h 
                IP_FILE_PATH ip/$sub_qsys_pcie/ext_f2h.ip
                BURSTCOUNT_WIDTH 6
                MASTER_ADDRESS_WIDTH 32
                ENABLE_SLAVE_PORT 0
                MAX_PENDING_READS 16
                DATA_WIDTH 128   
                SLAVE_ADDRESS_WIDTH 27"
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

add_component_param "altera_clock_bridge coreclk_out 
                IP_FILE_PATH ip/$sub_qsys_pcie/coreclk_out.ip
                NUM_CLOCK_OUTPUTS 1"
                
add_component_param "altera_reset_bridge pcie_nreset_status_merge
                    IP_FILE_PATH ip/$qsys_name/pcie_nreset_status_merge.ip 
                    ACTIVE_LOW_RESET 1
                    SYNCHRONOUS_EDGES deassert
                    NUM_RESET_OUTPUTS 1
                    USE_RESET_REQUEST 0
                    "

# Hack for themporary hack for dummy_user_avmm_rst
add_component_param "altera_clock_bridge pcie_refclk0_bridge
                IP_FILE_PATH ip/$sub_qsys_pcie/pcie_refclk0_bridge.ip
                NUM_CLOCK_OUTPUTS 1"

for {set x 0} {$x < 4} {incr x} {

add_component_param "altera_clock_bridge p${x}_app_clkout 
                IP_FILE_PATH ip/$sub_qsys_pcie/p${x}_app_clkout.ip
                NUM_CLOCK_OUTPUTS 1"


add_component_param "altera_msi_to_gic_gen msi_irq_${x} 
                IP_FILE_PATH ip/$sub_qsys_pcie/msi_irq_${x}.ip
                MSG_DATA_WORD 32
                DATA_ENTRY_DEPTH 4
                MEMORY_TYPE RAM_BLOCK_TYPE=M20K"      

set msi_offset [format 0x%x [expr {$x*0x100 + 0x8000}]]
add_component_param "altera_address_span_extender msi_irq_${x}_span
                IP_FILE_PATH ip/$sub_qsys_pcie/msi_irq_${x}_span.ip
                BURSTCOUNT_WIDTH 1
                MASTER_ADDRESS_WIDTH 16
                ENABLE_SLAVE_PORT 0
                MAX_PENDING_READS 2
                DATA_WIDTH 32   
                SLAVE_ADDRESS_WIDTH 8
                MASTER_ADDRESS_DEF $msi_offset"
                
#add_component_param "altera_avalon_mm_bridge pb_addr_${x} 
#                IP_FILE_PATH ip/$sub_qsys_pcie/pb_addr_${x}.ip
#                DATA_WIDTH 32
#                ADDRESS_WIDTH 7
#                USE_AUTO_ADDRESS_WIDTH 1
#                MAX_BURST_SIZE 1
#                MAX_PENDING_RESPONSES 2"

add_component_param "altera_reset_bridge hps_nrst_${x}
                IP_FILE_PATH ip/$sub_qsys_pcie/hps_nrst_${x}.ip
                ACTIVE_LOW_RESET 1
                SYNCHRONOUS_EDGES deassert
                NUM_RESET_OUTPUTS 1
                USE_RESET_REQUEST 0"                
}

set addr_width [expr { log($ocm_memsize) / log(2)} ]
add_component_param "altera_avalon_mm_bridge pb_2_ocm 
                IP_FILE_PATH ip/$sub_qsys_pcie/pb_2_ocm.ip
                MAX_BURST_SIZE 32
                ADDRESS_WIDTH $addr_width 
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
                
add_component_param "altera_avalon_mm_bridge pb_hip_reconfig 
                IP_FILE_PATH ip/$sub_qsys_pcie/pb_hip_reconfig.ip
                DATA_WIDTH 32S
                ADDRESS_WIDTH 23
                USE_AUTO_ADDRESS_WIDTH 1
                MAX_BURST_SIZE 1
                MAX_PENDING_RESPONSES 1"
                
if {$pcie_hptxs == 1} {
add_component_param "altera_avalon_mm_bridge pb_hptxs 
                IP_FILE_PATH ip/$sub_qsys_pcie/pb_hptxs.ip
                DATA_WIDTH 32
                ADDRESS_WIDTH 28
                USE_AUTO_ADDRESS_WIDTH 1
                MAX_BURST_SIZE 16
                MAX_PENDING_RESPONSES 8
                "
} else {
add_component_param "altera_avalon_mm_bridge pb_txs 
                IP_FILE_PATH ip/$sub_qsys_pcie/pb_txs.ip
                DATA_WIDTH 32
                ADDRESS_WIDTH 28
                USE_AUTO_ADDRESS_WIDTH 1
                MAX_BURST_SIZE 1
                MAX_PENDING_RESPONSES 1
                "
}
               
add_component_param "intel_pcie_ptile_avmm $pcie_inst 
                IP_FILE_PATH ip/$sub_qsys_pcie/$pcie_inst.ip
                avmm_enabled_hwtcl {1}
                top_topology_hwtcl {Gen4x4, Interface - 256 bit}
                virtual_rp_ep_mode_hwtcl {Root Port}
                g3_pld_clkfreq_user_hwtcl {250MHz}
                g4_pld_clkfreq_user_hwtcl {250MHz}
                core16_avmm_addr_width_hwtcl {64}
                core8_avmm_addr_width_hwtcl  {64}
                core4_0_avmm_addr_width_hwtcl {64}
                core4_1_avmm_addr_width_hwtcl {64}
                core16_pf0_pci_type0_device_id_hwtcl 57344
                core8_pf0_pci_type0_device_id_hwtcl 57345
                core4_0_pf0_pci_type0_device_id_hwtcl 57346
                core4_1_pf0_pci_type0_device_id_hwtcl 57347
                core16_pf0_subsys_dev_id_hwtcl 57344
                core8_pf0_subsys_dev_id_hwtcl 57345
                core4_0_pf0_subsys_dev_id_hwtcl 57346
                core4_1_pf0_subsys_dev_id_hwtcl 57347
                core16_pf0_revision_id_hwtcl 1
                core8_pf0_revision_id_hwtcl 1
                core4_0_pf0_revision_id_hwtcl 1
                core4_1_pf0_revision_id_hwtcl 1
                core16_hip_reconfig_hwtcl 1
                core8_hip_reconfig_hwtcl 1
                core4_0_hip_reconfig_hwtcl 1
                core4_1_hip_reconfig_hwtcl 1
                core16_pf0_class_code_hwtcl 394240
                core8_pf0_class_code_hwtcl 394240
                core4_0_pf0_class_code_hwtcl 394240
                core4_1_pf0_class_code_hwtcl 394240
                core16_pf0_subsys_vendor_id_hwtcl 4466
                core8_pf0_subsys_vendor_id_hwtcl 4466
                core4_0_pf0_subsys_vendor_id_hwtcl 4466
                core4_1_pf0_subsys_vendor_id_hwtcl 4466
                core16_pf0_subsys_dev_id_hwtcl 57344
                core8_pf0_subsys_dev_id_hwtcl 57344
                core4_0_pf0_subsys_dev_id_hwtcl 57344
                core4_1_pf0_subsys_dev_id_hwtcl 57344
                core16_virtual_maxpayload_size_hwtcl 512
                core8_virtual_maxpayload_size_hwtcl 512
                core4_0_virtual_maxpayload_size_hwtcl 512
                core4_1_virtual_maxpayload_size_hwtcl 512"


if {$pcie_hptxs == 1} {
set_component_param "$pcie_inst                  
                core16_hptxs_enabled_hwtcl {1}
                core16_hptxs_enabled_mapping_hwtcl {1}
                core16_hptxs_address_translation_table_address_width_hwtcl 1
                core16_hptxs_address_translation_window_address_width_hwtcl 25
                core8_hptxs_enabled_hwtcl {1}
                core8_hptxs_enabled_mapping_hwtcl {1}
                core8_hptxs_address_translation_table_address_width_hwtcl 1
                core8_hptxs_address_translation_window_address_width_hwtcl 25
                core4_0_hptxs_enabled_hwtcl {1}
                core4_0_hptxs_enabled_mapping_hwtcl {1}
                core4_0_hptxs_address_translation_table_address_width_hwtcl 1
                core4_0_hptxs_address_translation_window_address_width_hwtcl 25
                core4_1_hptxs_enabled_hwtcl {1}
                core4_1_hptxs_enabled_mapping_hwtcl {1}
                core4_1_hptxs_address_translation_table_address_width_hwtcl 1
                core4_1_hptxs_address_translation_window_address_width_hwtcl 25
                "
} else {
set_component_param "$pcie_inst  
                core16_txs_enabled_hwtcl 1
                core8_txs_enabled_hwtcl 1
                core4_0_txs_enabled_hwtcl 1
                core4_1_txs_enabled_hwtcl 1
                core16_user_txs_address_width_hwtcl 25
                core8_user_txs_address_width_hwtcl 25
                core4_0_user_txs_address_width_hwtcl 25
                core4_1_user_txs_address_width_hwtcl 25
                "
}              
                
add_component_param "altera_avalon_performance_counter perf_cnt_0 
                IP_FILE_PATH ip/$sub_qsys_pcie/perf_cnt_0.ip
                numberOfSections 1"

# connections and connection parameters
connect "pcie_clk_100.out_clk                pcie_rst_in.clk
         pcie_clk_100.out_clk                perf_cnt_0.clk 
         pcie_clk_100.out_clk                pb_hip_reconfig.clk 
         pcie_clk_100.out_clk                pb_periph.clk 
         ${pcie_inst}.p0_app_clk             pb_2_ocm.clk
         ${pcie_inst}.coreclkout_hip         coreclk_out.in_clk
         ${pcie_inst}.p0_app_clk             pb_hptxs.clk
         ${pcie_inst}.p0_app_clk             pcie_nreset_status_merge.clk

         pcie_rst_in.out_reset               perf_cnt_0.reset
         pcie_rst_in.out_reset               pb_periph.reset
         pcie_rst_in.out_reset               pb_hip_reconfig.reset
         pcie_rst_in.out_reset               ${pcie_inst}.dummy_user_avmm_rst
         pcie_rst_in.out_reset               pb_hptxs.reset
         pcie_rst_in.out_reset               pb_2_ocm.reset"

# connect "pcie_nreset_status_merge.out_reset   pb_periph.reset
#          pcie_nreset_status_merge.out_reset   pb_2_ocm.reset
#          pcie_nreset_status_merge.out_reset   perf_cnt_0.reset
#          "

if {$f2h_width > 0} {
connect "${pcie_inst}.p0_app_clk             ext_f2h.clock
         pcie_rst_in.out_reset               ext_f2h.reset
"
# connect "pcie_nreset_status_merge.out_reset  ext_f2h.reset"
for {set x 0} {$x < 4} {incr x} {
connect_map "${pcie_inst}.p${x}_rxm_bar0     ext_f2h.windowed_slave  0x0"
}
}
# Hack for themporary hack for dummy_user_avmm_rst
connect "pcie_refclk0_bridge.out_clk         ${pcie_inst}.refclk0"

for {set x 0} {$x < 4} {incr x} {
connect "${pcie_inst}.p${x}_app_clk             hps_nrst_${x}.clk
         ${pcie_inst}.p${x}_app_clk             p${x}_app_clkout.in_clk
         pcie_clk_100.out_clk                   msi_irq_${x}.clock
         pcie_clk_100.out_clk                   ${pcie_inst}.p${x}_hip_reconfig_clk
         ${pcie_inst}.p${x}_app_reset_status_n  hps_nrst_${x}.in_reset
         ${pcie_inst}.p${x}_app_clk             msi_irq_${x}_span.clock
         pcie_rst_in.out_reset                  msi_irq_${x}.reset
         pcie_rst_in.out_reset                  msi_irq_${x}_span.reset
         ${pcie_inst}.p${x}_app_reset_status_n  msi_irq_${x}.reset
         ${pcie_inst}.p${x}_app_reset_status_n  msi_irq_${x}_span.reset
         "         
         
connect_map "${pcie_inst}.p${x}_rxm_bar0     pb_2_ocm.s0             0x80000000"

connect_map "${pcie_inst}.p${x}_rxm_bar0     msi_irq_${x}_span.windowed_slave       0xf9010000"

set cra_base_offset [format 0x%x [expr {$x*0x10000}]] 
set msi_offset [format 0x%x [expr {$x*0x100 + 0x8000}]]

connect_map "pb_periph.m0        ${pcie_inst}.p${x}_cra     $cra_base_offset"

connect_map "pb_periph.m0        msi_irq_${x}.csr           [expr {$msi_offset + 0x80}]"

connect_map "pb_periph.m0        msi_irq_${x}.vector_slave  [expr {$msi_offset}]"

connect_map "msi_irq_${x}_span.expanded_master  msi_irq_${x}.vector_slave  [expr {$msi_offset}]"

connect_map "pb_hip_reconfig.m0  ${pcie_inst}.p${x}_hip_reconfig     [expr {${x}*0x200000}]"

if {$pcie_hptxs == 1} {
connect_map "pb_hptxs.m0   ${pcie_inst}.p${x}_hptxs   [expr {${x}*0x04000000}]"
} else {
connect_map "pb_txs.m0     ${pcie_inst}.p${x}_txs     [expr {${x}*0x04000000}]"
}
}

connect_map "pb_periph.m0  perf_cnt_0.control_slave   0x80a0"

for {set x 0} {$x < 4} {incr x} {
export p${x}_app_clkout out_clk pcie_p${x}_app_clk

export hps_nrst_${x} out_reset pcie_p${x}_app_reset_status_n

export ${pcie_inst} p${x}_cra_irq pcie_hip_p${x}_cra_irq

export ${pcie_inst} p${x}_rxm_irq pcie_p${x}_rxm_irq

export ${pcie_inst} p${x}_pld_warm_rst_rdy pcie_p${x}_pld_warm_rst_rdy

export ${pcie_inst} p${x}_link_req_rst_n pcie_p${x}_link_req_rst_n

export msi_irq_${x} interrupt_sender msi2gic_${x}_interrupt
}

if {$f2h_width > 0} {
export ext_f2h expanded_master ext_expanded_master
}

export pcie_clk_100 in_clk clk

export ${pcie_inst} ninit_done pcie_ninit_done

export pcie_rst_in in_reset reset

export pcie_nreset_status_merge in_reset nreset_status_merge

export coreclk_out out_clk coreclkout_out

export pb_2_ocm m0 pb_2_ocm_m0

export pb_periph s0 pb_lwh2f_pcie

export pb_hip_reconfig s0 pb_hip_reconfig

if {$pcie_hptxs == 1} {
export pb_hptxs s0 pb_hptxs
} else {
export pb_txs s0 pb_txs
}

export ${pcie_inst} hip_serial pcie_hip_serial

# Hack for themporary hack for dummy_user_avmm_rst
#export ${pcie_inst} refclk0 pcie_hip_refclk0
export pcie_refclk0_bridge in_clk   pcie_hip_refclk0
export ${pcie_inst}        refclk1  pcie_hip_refclk1

export ${pcie_inst} pin_perst pcie_hip_perst
# 
# export ${pcie_inst} currentspeed pcie_hip_currentspeed
# 
# export ${pcie_inst} hip_ctrl pcie_hip_ctrl
# 
# export ${pcie_inst} hip_pipe pcie_hip_pipe
# 
# export ${pcie_inst} hip_status pcie_hip_status
# 
# export ${pcie_inst} npor pcie_hip_npor
# 
# 
# 
# interconnect requirements
set_domain_assignment {$system} {qsys_mm.clockCrossingAdapter} {AUTO}
set_domain_assignment {$system} {qsys_mm.maxAdditionalLatency} {1}
set_domain_assignment {$system} {qsys_mm.enableEccProtection} {FALSE}
set_domain_assignment {$system} {qsys_mm.insertDefaultSlave} {FALSE}

#set_interconnect_requirement {mm_interconnect_1|pcie_s10_rxm_bar0_agent.cp/router.sink} qsys_mm.postTransform.pipelineCount {1}
#set_interconnect_requirement {mm_interconnect_1|pcie_s10_rxm_bar0_limiter.cmd_src/cmd_demux.sink} qsys_mm.postTransform.pipelineCount {1}
#set_interconnect_requirement {mm_interconnect_1|router.src/pcie_s10_rxm_bar0_limiter.cmd_sink} qsys_mm.postTransform.pipelineCount {1}
#set_interconnect_requirement {mm_interconnect_1|ext_f2sdram_windowed_slave_cmd_width_adapter.src/ext_f2sdram_windowed_slave_agent.cp} qsys_mm.postTransform.pipelineCount {1}

sync_sysinfo_parameters
save_system ${sub_qsys_pcie}.qsys
