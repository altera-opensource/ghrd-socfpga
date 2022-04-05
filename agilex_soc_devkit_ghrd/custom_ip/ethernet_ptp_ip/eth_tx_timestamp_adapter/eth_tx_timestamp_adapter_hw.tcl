#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2018-2020 Intel Corporation.
#
#****************************************************************************
#
# eth_tx_timestamp_adapter "TX Timestamp Adapter for Intel PSG Ethernet IP" v18.0
#
#****************************************************************************

package require -exact qsys 16.0


#
# module eth_tx_timestamp_adapter
#
set_module_property DESCRIPTION "TX Timestamp Adapter for Intel PSG Ethernet IP"
set_module_property NAME eth_tx_timestamp_adapter
set_module_property VERSION 1.0.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP "Example Designs/Ethernet/Misc"
set_module_property AUTHOR "Intel Corporation"
set_module_property DISPLAY_NAME "TX Timestamp Adapter for Intel PSG Ethernet IP"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


#
# file sets
#
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL eth_tx_timestamp_adapter
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file eth_tx_timestamp_adapter.v VERILOG PATH eth_tx_timestamp_adapter.v TOP_LEVEL_FILE

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL eth_tx_timestamp_adapter
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file eth_tx_timestamp_adapter.v VERILOG PATH eth_tx_timestamp_adapter.v

add_fileset SIM_VHDL SIM_VHDL "" ""
set_fileset_property SIM_VHDL TOP_LEVEL eth_tx_timestamp_adapter
set_fileset_property SIM_VHDL ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VHDL ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file eth_tx_timestamp_adapter.v VERILOG PATH eth_tx_timestamp_adapter.v


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
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset reset Input 1


#
# connection point aso_timestamp_fp
#
add_interface aso_timestamp_fp avalon_streaming start
set_interface_property aso_timestamp_fp associatedClock clock
set_interface_property aso_timestamp_fp associatedReset reset
set_interface_property aso_timestamp_fp dataBitsPerSymbol 104
set_interface_property aso_timestamp_fp errorDescriptor ""
set_interface_property aso_timestamp_fp firstSymbolInHighOrderBits true
set_interface_property aso_timestamp_fp maxChannel 0
#set_interface_property aso_timestamp_fp readyAllowance 0
set_interface_property aso_timestamp_fp readyLatency 0
set_interface_property aso_timestamp_fp ENABLED true
set_interface_property aso_timestamp_fp EXPORT_OF ""
set_interface_property aso_timestamp_fp PORT_NAME_MAP ""
set_interface_property aso_timestamp_fp CMSIS_SVD_VARIABLES ""
set_interface_property aso_timestamp_fp SVD_ADDRESS_GROUP ""

add_interface_port aso_timestamp_fp aso_timestamp_fp data Output 104
add_interface_port aso_timestamp_fp aso_timestamp_fp_ready ready Input 1
add_interface_port aso_timestamp_fp aso_timestamp_fp_valid valid Output 1


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


#
# connection point timestamp
#
add_interface timestamp conduit end
set_interface_property timestamp associatedClock ""
set_interface_property timestamp associatedReset ""
set_interface_property timestamp ENABLED true
set_interface_property timestamp EXPORT_OF ""
set_interface_property timestamp PORT_NAME_MAP ""
set_interface_property timestamp CMSIS_SVD_VARIABLES ""
set_interface_property timestamp SVD_ADDRESS_GROUP ""

add_interface_port timestamp timestamp_fp_valid valid Input 1
add_interface_port timestamp timestamp_fp_data data Input 96
add_interface_port timestamp timestamp_fp_fingerprint fingerprint Input 8

