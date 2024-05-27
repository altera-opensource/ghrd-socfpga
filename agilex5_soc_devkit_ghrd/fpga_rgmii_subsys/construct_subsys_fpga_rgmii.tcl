#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2023 Intel Corporation.
#
#****************************************************************************
#
# This script construct Peripherals subsystem for higher level integration later.
# The Makefile in $prjroot folder will pass in variable needed by this TCL as defined
# in the subsystem Makefile automatically. User will have the ability to modify the 
# defined variable dynamically during (MAKE) target flow of generate_from_tcl.
#
#****************************************************************************
set currentdir [pwd]
set foldername [file tail $currentdir]
puts "\[GHRD:info\] Directory name: $foldername"

puts "\[GHRD:info\] \$prjroot = ${prjroot} "
source ${prjroot}/arguments_solver.tcl
source ${prjroot}/utils.tcl

if {$board == "cvr"} {
	    source $prjroot/board/board_cvr_config.tcl
	} else {
	    source $prjroot/board/board_DK-A5E065BB32AES1_config.tcl
	}

set subsys_name $foldername

package require -exact qsys 23.4

#proc do_create_bbb {} {
#global subsys_name
#global device
#global device_family

# create the system
	create_system $subsys_name
	#set_project_property BOARD {default}
	set_project_property DEVICE $device
	set_project_property DEVICE_FAMILY $device_family
	# set_project_property HIDE_FROM_IP_CATALOG {false}
	# set_use_testbench_naming_pattern 0 {}

# add HDL parameters

	add_component_param "altera_clock_bridge clock_in 
                    IP_FILE_PATH ip/$subsys_name/clock_in.ip 
                    EXPLICIT_CLOCK_RATE 100000000 
                    NUM_CLOCK_OUTPUTS 1
                    "
    
    add_component_param "intel_gmii_to_rgmii_converter intel_gmii_to_rgmii_converter_0 
                    IP_FILE_PATH ip/$subsys_name/intel_gmii_to_rgmii_converter_0.ip 
                    RX_PIPELINE_DEPTH 5
                    TX_PIPELINE_DEPTH 2
                    "
    
	add_component_param "altera_iopll iopll_0 
                    IP_FILE_PATH 				ip/$subsys_name/iopll_0.ip 
                    gui_number_of_clocks 		2
					gui_clock_name_string0 		outclk0 
					gui_output_clock_frequency0	25.0
					gui_clock_name_string1 		outclk1
					gui_output_clock_frequency1	2.5					
					"
    
    add_component_param "altera_reset_bridge reset_in 
            IP_FILE_PATH ip/$subsys_name/reset_in.ip 
            SYNC_RESET 0
            NUM_RESET_OUTPUTS 1
            "

# Add the connection  
    connect " clock_in.out_clk intel_gmii_to_rgmii_converter_0.peri_clock
              clock_in.out_clk iopll_0.refclk
              clock_in.out_clk reset_in.clk
              iopll_0.outclk0 intel_gmii_to_rgmii_converter_0.pll_25m_clock
              iopll_0.outclk1 intel_gmii_to_rgmii_converter_0.pll_2_5m_clock
              iopll_0.locked intel_gmii_to_rgmii_converter_0.locked_pll_tx
              reset_in.out_reset intel_gmii_to_rgmii_converter_0.peri_reset
              reset_in.out_reset iopll_0.reset
            "
    
# Add the exports
    
    export clock_in in_clk clk
    export reset_in in_reset reset
    export intel_gmii_to_rgmii_converter_0 phy_rgmii phy_rgmii
    export intel_gmii_to_rgmii_converter_0 hps_gmii hps_gmii
    
# save the system
	sync_sysinfo_parameters
	save_system ${subsys_name}.qsys
