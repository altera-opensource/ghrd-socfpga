#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2018-2020 Intel Corporation.
#
#****************************************************************************
#
# eth_ts_fingerprint_compare "Timestamp Fingerprint Comparator for Timestamp Filtering" v1.0
#
#****************************************************************************

package require -exact qsys 16.0


#
# module eth_ts_fingerprint_compare
#
set_module_property DESCRIPTION ""
set_module_property NAME eth_ts_fingerprint_compare
set_module_property VERSION 1.0.0
set_module_property GROUP "Example Designs/Ethernet/Misc"
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR "Intel Corporation"
set_module_property DISPLAY_NAME "Timestamp Fingerprint Comparator for Timestamp Filtering"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


#
# file sets
#
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL eth_ts_fingerprint_compare
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file eth_ts_fingerprint_compare.v VERILOG PATH eth_ts_fingerprint_compare.v TOP_LEVEL_FILE

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL eth_ts_fingerprint_compare
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file eth_ts_fingerprint_compare.v VERILOG PATH eth_ts_fingerprint_compare.v

add_fileset SIM_VHDL SIM_VHDL "" ""
set_fileset_property SIM_VHDL TOP_LEVEL eth_ts_fingerprint_compare
set_fileset_property SIM_VHDL ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VHDL ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file eth_ts_fingerprint_compare.v VERILOG PATH eth_ts_fingerprint_compare.v


#
# parameters
#


#
# display items
#


#
# connection point reset
#
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges BOTH
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset reset Input 1


#
# connection point fingerprint
#
add_interface fingerprint avalon_streaming end
set_interface_property fingerprint associatedClock clock
set_interface_property fingerprint associatedReset reset
set_interface_property fingerprint dataBitsPerSymbol 8
set_interface_property fingerprint errorDescriptor ""
set_interface_property fingerprint firstSymbolInHighOrderBits true
set_interface_property fingerprint maxChannel 0
#set_interface_property fingerprint readyAllowance 0
set_interface_property fingerprint readyLatency 0
set_interface_property fingerprint ENABLED true
set_interface_property fingerprint EXPORT_OF ""
set_interface_property fingerprint PORT_NAME_MAP ""
set_interface_property fingerprint CMSIS_SVD_VARIABLES ""
set_interface_property fingerprint SVD_ADDRESS_GROUP ""

add_interface_port fingerprint asi_fingerprint_valid valid Input 1
add_interface_port fingerprint asi_fingerprint_ready ready Output 1
add_interface_port fingerprint asi_fingerprint data Input 8


#
# connection point timestamp_fp
#
add_interface timestamp_fp avalon_streaming end
set_interface_property timestamp_fp associatedClock clock
set_interface_property timestamp_fp associatedReset reset
set_interface_property timestamp_fp dataBitsPerSymbol 104
set_interface_property timestamp_fp errorDescriptor ""
set_interface_property timestamp_fp firstSymbolInHighOrderBits true
set_interface_property timestamp_fp maxChannel 0
#set_interface_property timestamp_fp readyAllowance 0
set_interface_property timestamp_fp readyLatency 0
set_interface_property timestamp_fp ENABLED true
set_interface_property timestamp_fp EXPORT_OF ""
set_interface_property timestamp_fp PORT_NAME_MAP ""
set_interface_property timestamp_fp CMSIS_SVD_VARIABLES ""
set_interface_property timestamp_fp SVD_ADDRESS_GROUP ""

add_interface_port timestamp_fp asi_timestamp_fp_valid valid Input 1
add_interface_port timestamp_fp asi_timestamp_fp_ready ready Output 1
add_interface_port timestamp_fp asi_timestamp_fp data Input 104


#
# connection point timestamp
#
add_interface timestamp avalon_streaming start
set_interface_property timestamp associatedClock clock
set_interface_property timestamp associatedReset reset
set_interface_property timestamp dataBitsPerSymbol 96
set_interface_property timestamp errorDescriptor ""
set_interface_property timestamp firstSymbolInHighOrderBits true
set_interface_property timestamp maxChannel 0
#set_interface_property timestamp readyAllowance 0
set_interface_property timestamp readyLatency 0
set_interface_property timestamp ENABLED true
set_interface_property timestamp EXPORT_OF ""
set_interface_property timestamp PORT_NAME_MAP ""
set_interface_property timestamp CMSIS_SVD_VARIABLES ""
set_interface_property timestamp SVD_ADDRESS_GROUP ""

add_interface_port timestamp aso_timestamp_valid valid Output 1
add_interface_port timestamp aso_timestamp_ready ready Input 1
add_interface_port timestamp aso_timestamp data Output 96


#
# connection point clock
#
add_interface clock clock end
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clock clk Input 1

