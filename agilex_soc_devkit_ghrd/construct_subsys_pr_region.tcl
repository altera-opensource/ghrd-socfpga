#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2020 Intel Corporation.
#
#****************************************************************************
#
# This script construct sub system of PR freeze region for higher level integration
# The GHRD create_ghrd_qsys.tcl will call each of those subsystem construct script
# automatically based on the corresponding parameter argument defined
#
#****************************************************************************


source ./arguments_solver.tcl
source ./utils.tcl

package require -exact qsys 19.1

if {$pr_region_id_switch == 1} {
set index 1
} else {
set index 0
}

create_system $sub_qsys_pr

set_project_property DEVICE_FAMILY $device_family
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
if {$pr_persona == 1} {
connect_map "pr_mm_bdg_${sub_qsys_pr}_${index}.m0  pr_sysid_${sub_qsys_pr}_${index}.control_slave  0x100"
connect_map "pr_mm_bdg_${sub_qsys_pr}_${index}.m0  pr_ocm_${sub_qsys_pr}_${index}.s1   0x0"
} else {
connect_map "pr_mm_bdg_${sub_qsys_pr}_${index}.m0  pr_sysid_${sub_qsys_pr}_${index}.control_slave  0x0"
connect_map "pr_mm_bdg_${sub_qsys_pr}_${index}.m0  pr_ocm_${sub_qsys_pr}_${index}.s1   0x100"

}

connect "pr_clk_100_${sub_qsys_pr}_${index}.out_clk   pr_mm_bdg_${sub_qsys_pr}_${index}.clk
         pr_clk_100_${sub_qsys_pr}_${index}.out_clk   pr_sysid_${sub_qsys_pr}_${index}.clk
         pr_clk_100_${sub_qsys_pr}_${index}.out_clk   pr_rst_in_${sub_qsys_pr}_${index}.clk
         
         pr_clk_100_${sub_qsys_pr}_${index}.out_clk pr_ocm_${sub_qsys_pr}_${index}.clk1
         "
connect "pr_rst_in_${sub_qsys_pr}_${index}.out_reset  pr_sysid_${sub_qsys_pr}_${index}.reset
         pr_rst_in_${sub_qsys_pr}_${index}.out_reset pr_mm_bdg_${sub_qsys_pr}_${index}.reset
         
         pr_rst_in_${sub_qsys_pr}_${index}.out_reset pr_ocm_${sub_qsys_pr}_${index}.reset1
         "
         
# exported interfaces
export pr_clk_100_${sub_qsys_pr}_${index}    in_clk      clk
export pr_rst_in_${sub_qsys_pr}_${index}     in_reset    reset
export pr_mm_bdg_${sub_qsys_pr}_${index}     s0          pr_mm_bridge_0_s0


# interconnect requirements
set_domain_assignment {$system} {qsys_mm.clockCrossingAdapter} {AUTO}
set_domain_assignment {$system} {qsys_mm.maxAdditionalLatency} {1}
set_domain_assignment {$system} {qsys_mm.enableEccProtection} {FALSE}
set_domain_assignment {$system} {qsys_mm.insertDefaultSlave} {FALSE}

sync_sysinfo_parameters
save_system ${sub_qsys_pr}.qsys
