#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2018-2020 Intel Corporation.
#
#****************************************************************************
#
# TCL File Generated by Component Editor 15.1
# Wed Jan 27 16:28:32 MYT 2016
# DO NOT MODIFY
#
# custom_reset_synchronizer "Custom Reset Synchronizer" v15.1
# 2016.01.27.16:28:32
# Reset synchronizer that will synchronize an input reset and output a reset that deasserts synchronously and asserts asynchronous/synchronously.
# 
# request TCL package from ACDS 15.1
# 
#****************************************************************************

package require -exact qsys 15.1


# 
# module custom_reset_synchronizer
# 
set_module_property DESCRIPTION "Reset synchronizer that will synchronize an input reset and output a reset that deasserts synchronously and asserts asynchronous/synchronously."
set_module_property NAME custom_reset_synchronizer
set_module_property VERSION 15.1
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR "Intel Corporation"
set_module_property DISPLAY_NAME "Custom Reset Synchronizer"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property GROUP "Example Designs/Component"
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL reset_sync_block
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file reset_sync_block.v VERILOG PATH reset_sync_block.v TOP_LEVEL_FILE
add_fileset_file reset_sync_block.sdc SDC PATH reset_sync_block.sdc

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL reset_sync_block
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file reset_sync_block.v VERILOG PATH reset_sync_block.v

add_fileset SIM_VHDL SIM_VHDL "" ""
set_fileset_property SIM_VHDL TOP_LEVEL reset_sync_block
set_fileset_property SIM_VHDL ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VHDL ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file reset_sync_block.v VERILOG PATH reset_sync_block.v


# 
# parameters
# 
add_parameter INPUT_CLOCK_FREQUENCY INTEGER 50000000 "Input clock frequency in Hz"
set_parameter_property INPUT_CLOCK_FREQUENCY DEFAULT_VALUE 50000000
set_parameter_property INPUT_CLOCK_FREQUENCY DISPLAY_NAME "Input clock frequency"
set_parameter_property INPUT_CLOCK_FREQUENCY TYPE INTEGER
set_parameter_property INPUT_CLOCK_FREQUENCY UNITS Hertz
set_parameter_property INPUT_CLOCK_FREQUENCY ALLOWED_RANGES -2147483648:2147483647
set_parameter_property INPUT_CLOCK_FREQUENCY DESCRIPTION "Input clock frequency in Hz"
set_parameter_property INPUT_CLOCK_FREQUENCY AFFECTS_VALIDATION false
add_parameter INPUT_CLOCK_KNOWN INTEGER 1 "Enable if the input clock frequency is known"
set_parameter_property INPUT_CLOCK_KNOWN DEFAULT_VALUE 1
set_parameter_property INPUT_CLOCK_KNOWN DISPLAY_NAME "Input clock frequency known"
set_parameter_property INPUT_CLOCK_KNOWN TYPE INTEGER
set_parameter_property INPUT_CLOCK_KNOWN UNITS None
set_parameter_property INPUT_CLOCK_KNOWN ALLOWED_RANGES -2147483648:2147483647
set_parameter_property INPUT_CLOCK_KNOWN DESCRIPTION "Enable if the input clock frequency is known"
set_parameter_property INPUT_CLOCK_KNOWN DISPLAY_HINT BOOLEAN
add_parameter DERIVED_CLOCK_RATE LONG 0 "Derived clock rate"
set_parameter_property DERIVED_CLOCK_RATE DEFAULT_VALUE 0
set_parameter_property DERIVED_CLOCK_RATE DISPLAY_NAME "Derived clock rate"
set_parameter_property DERIVED_CLOCK_RATE TYPE LONG
set_parameter_property DERIVED_CLOCK_RATE VISIBLE false
set_parameter_property DERIVED_CLOCK_RATE UNITS None
set_parameter_property DERIVED_CLOCK_RATE DESCRIPTION "Derived clock rate"
set_parameter_property DERIVED_CLOCK_RATE AFFECTS_VALIDATION false
set_parameter_property DERIVED_CLOCK_RATE SYSTEM_INFO_TYPE CLOCK_RATE
set_parameter_property DERIVED_CLOCK_RATE SYSTEM_INFO_ARG clock_in
add_parameter SYNC_DEPTH INTEGER 3 "Must be set to at least 2 but recommended depth is 3 or greater"
set_parameter_property SYNC_DEPTH DEFAULT_VALUE 3
set_parameter_property SYNC_DEPTH DISPLAY_NAME "Synchronizer Depth"
set_parameter_property SYNC_DEPTH TYPE INTEGER
set_parameter_property SYNC_DEPTH UNITS None
set_parameter_property SYNC_DEPTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property SYNC_DEPTH DESCRIPTION "Must be set to at least 2 but recommended depth is 3 or greater"
set_parameter_property SYNC_DEPTH AFFECTS_ELABORATION false
set_parameter_property SYNC_DEPTH HDL_PARAMETER true
add_parameter ADDITIONAL_DEPTH INTEGER 2 "Must be set to at least 2"
set_parameter_property ADDITIONAL_DEPTH DEFAULT_VALUE 2
set_parameter_property ADDITIONAL_DEPTH DISPLAY_NAME "Reset Pipeline Depth"
set_parameter_property ADDITIONAL_DEPTH TYPE INTEGER
set_parameter_property ADDITIONAL_DEPTH UNITS None
set_parameter_property ADDITIONAL_DEPTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property ADDITIONAL_DEPTH DESCRIPTION "Must be set to at least 2"
set_parameter_property ADDITIONAL_DEPTH AFFECTS_ELABORATION false
set_parameter_property ADDITIONAL_DEPTH HDL_PARAMETER true
add_parameter DISABLE_GLOBAL_NETWORK INTEGER 1 "Set this option to prevent the reset output from being promoted to the global network.  This may prevent recovery timing failures for any registers reset by this reset synchronizer."
set_parameter_property DISABLE_GLOBAL_NETWORK DEFAULT_VALUE 1
set_parameter_property DISABLE_GLOBAL_NETWORK DISPLAY_NAME "Inhibit Reset Promotion to Global Network"
set_parameter_property DISABLE_GLOBAL_NETWORK TYPE INTEGER
set_parameter_property DISABLE_GLOBAL_NETWORK UNITS None
set_parameter_property DISABLE_GLOBAL_NETWORK ALLOWED_RANGES -2147483648:2147483647
set_parameter_property DISABLE_GLOBAL_NETWORK DESCRIPTION "Set this option to prevent the reset output from being promoted to the global network.  This may prevent recovery timing failures for any registers reset by this reset synchronizer."
set_parameter_property DISABLE_GLOBAL_NETWORK DISPLAY_HINT BOOLEAN
set_parameter_property DISABLE_GLOBAL_NETWORK AFFECTS_ELABORATION false
set_parameter_property DISABLE_GLOBAL_NETWORK AFFECTS_VALIDATION false
set_parameter_property DISABLE_GLOBAL_NETWORK HDL_PARAMETER true
add_parameter SYNC_BOTH_EDGES INTEGER 0 "Enable to generate a reset that is asserted and deasserted synchronously.  Disable to generate a reset that is assert asynchronously and deasserted synchronously."
set_parameter_property SYNC_BOTH_EDGES DEFAULT_VALUE 0
set_parameter_property SYNC_BOTH_EDGES DISPLAY_NAME "Synchronize reset for both clock edges"
set_parameter_property SYNC_BOTH_EDGES TYPE INTEGER
set_parameter_property SYNC_BOTH_EDGES UNITS None
set_parameter_property SYNC_BOTH_EDGES ALLOWED_RANGES -2147483648:2147483647
set_parameter_property SYNC_BOTH_EDGES DESCRIPTION "Enable to generate a reset that is asserted and deasserted synchronously.  Disable to generate a reset that is assert asynchronously and deasserted synchronously."
set_parameter_property SYNC_BOTH_EDGES DISPLAY_HINT BOOLEAN
set_parameter_property SYNC_BOTH_EDGES AFFECTS_VALIDATION false
set_parameter_property SYNC_BOTH_EDGES HDL_PARAMETER true


# 
# display items
# 


# 
# connection point clock_in
# 
add_interface clock_in clock end
set_interface_property clock_in clockRate 0
set_interface_property clock_in ENABLED true
set_interface_property clock_in EXPORT_OF ""
set_interface_property clock_in PORT_NAME_MAP ""
set_interface_property clock_in CMSIS_SVD_VARIABLES ""
set_interface_property clock_in SVD_ADDRESS_GROUP ""

add_interface_port clock_in clk_in clk Input 1


# 
# connection point reset_in
# 
add_interface reset_in reset end
set_interface_property reset_in associatedClock ""
set_interface_property reset_in synchronousEdges NONE
set_interface_property reset_in ENABLED true
set_interface_property reset_in EXPORT_OF ""
set_interface_property reset_in PORT_NAME_MAP ""
set_interface_property reset_in CMSIS_SVD_VARIABLES ""
set_interface_property reset_in SVD_ADDRESS_GROUP ""

add_interface_port reset_in reset_in reset Input 1


# 
# connection point clock_out
# 
add_interface clock_out clock start
set_interface_property clock_out associatedDirectClock ""
set_interface_property clock_out clockRate 0
set_interface_property clock_out clockRateKnown false
set_interface_property clock_out ENABLED true
set_interface_property clock_out EXPORT_OF ""
set_interface_property clock_out PORT_NAME_MAP ""
set_interface_property clock_out CMSIS_SVD_VARIABLES ""
set_interface_property clock_out SVD_ADDRESS_GROUP ""

add_interface_port clock_out clk_out clk Output 1


# 
# connection point reset_out
# 
add_interface reset_out reset start
set_interface_property reset_out associatedClock clock_out
set_interface_property reset_out associatedDirectReset ""
set_interface_property reset_out associatedResetSinks reset_in
set_interface_property reset_out synchronousEdges DEASSERT
set_interface_property reset_out ENABLED true
set_interface_property reset_out EXPORT_OF ""
set_interface_property reset_out PORT_NAME_MAP ""
set_interface_property reset_out CMSIS_SVD_VARIABLES ""
set_interface_property reset_out SVD_ADDRESS_GROUP ""

add_interface_port reset_out reset_out reset Output 1

