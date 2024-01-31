#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2023 Intel Corporation.
#
#****************************************************************************
#
# This script construct JTAG AVMM MAster subsystem for higher level integration later.
# The Makefile in $prjroot folder will pass in variable needed by this TCL as defined
# in the subsystem Makefile automatically. User will have the ability to modify the 
# defined variable dynamically during (MAKE) target flow of generate_from_tcl.
#
#****************************************************************************
set currentdir [pwd]
set foldername [file tail $currentdir]
puts "\[GHRD:info\] Directory name: $foldername"
 
 # set prjroot ${currentdir}/../
puts "\[GHRD:info\] \$prjroot = $prjroot"
source ${prjroot}/arguments_solver.tcl
source ${prjroot}/utils.tcl

# set foldername [file dirname [file normalize [info construct_subsys_jtag_master.tcl]]]
# puts "\$foldername got: ${foldername}"
set subqsys_name $foldername

package require -exact qsys 19.1

create_system $subqsys_name

set_project_property DEVICE_FAMILY $device_family
set_project_property DEVICE $device
set_validation_property AUTOMATIC_VALIDATION false
    
add_component_param "altera_clock_bridge jtag_clk 
                    IP_FILE_PATH ip/$subqsys_name/jtag_clk.ip  
                    EXPLICIT_CLOCK_RATE 100000000 
                    NUM_CLOCK_OUTPUTS 1
                    "

add_component_param "altera_reset_bridge jtag_rst_in 
                    IP_FILE_PATH ip/$subqsys_name/jtag_rst_in.ip 
                    ACTIVE_LOW_RESET 1
                    SYNCHRONOUS_EDGES both
                    NUM_RESET_OUTPUTS 1
                    USE_RESET_REQUEST 0
                    "
    
add_component_param "altera_jtag_avalon_master hps_m 
                    IP_FILE_PATH ip/$subqsys_name/hps_m.ip 
                    "

add_component_param "altera_jtag_avalon_master fpga_m 
                    IP_FILE_PATH ip/$subqsys_name/fpga_m.ip 
                    "

# connections and connection parameters
connect "   jtag_clk.out_clk fpga_m.clk
            jtag_clk.out_clk jtag_rst_in.clk
            jtag_rst_in.out_reset fpga_m.clk_reset
"

connect "   jtag_clk.out_clk hps_m.clk
            jtag_rst_in.out_reset hps_m.clk_reset
"

# exported interfaces
export jtag_rst_in in_reset reset
export jtag_clk in_clk clk
export fpga_m master fpga_m_master
export hps_m master hps_m_master


# interconnect requirements
#set_domain_assignment {$system} {qsys_mm.clockCrossingAdapter} {AUTO}
#set_domain_assignment {$system} {qsys_mm.maxAdditionalLatency} {1}
#set_domain_assignment {$system} {qsys_mm.enableEccProtection} {FALSE}
#set_domain_assignment {$system} {qsys_mm.insertDefaultSlave} {FALSE}
    
sync_sysinfo_parameters 
    
save_system ${subqsys_name}.qsys

sync_sysinfo_parameters 

