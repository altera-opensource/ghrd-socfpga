#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2018-2020 Intel Corporation.
#
#****************************************************************************
#
# eth_rx_timestamp_adapter "RX Timestamp Adapter for Intel PSG Ethernet IP" v18.0
# RX Timestamp Adapter for Intel PSG Ethernet IP
# 
#****************************************************************************

package require -exact qsys 16.0


# 
# module eth_rx_timestamp_adapter
# 
set_module_property DESCRIPTION "RX Timestamp Adapter for Intel PSG Ethernet IP"
set_module_property NAME eth_rx_timestamp_adapter
set_module_property VERSION 1.0.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP "Example Designs/Ethernet/Misc"
set_module_property AUTHOR "Intel Corporation"
set_module_property DISPLAY_NAME "RX Timestamp Adapter for Intel PSG Ethernet IP"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL eth_rx_timestamp_adapter
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file eth_rx_timestamp_adapter.v VERILOG PATH eth_rx_timestamp_adapter.v TOP_LEVEL_FILE

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL eth_rx_timestamp_adapter
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file eth_rx_timestamp_adapter.v VERILOG PATH eth_rx_timestamp_adapter.v

add_fileset SIM_VHDL SIM_VHDL "" ""
set_fileset_property SIM_VHDL TOP_LEVEL eth_rx_timestamp_adapter
set_fileset_property SIM_VHDL ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VHDL ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file eth_rx_timestamp_adapter.v VERILOG PATH eth_rx_timestamp_adapter.v


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
# connection point src_timestamp
# 
add_interface src_timestamp avalon_streaming start
set_interface_property src_timestamp associatedClock clock
set_interface_property src_timestamp associatedReset reset
set_interface_property src_timestamp dataBitsPerSymbol 96
set_interface_property src_timestamp errorDescriptor ""
set_interface_property src_timestamp firstSymbolInHighOrderBits true
set_interface_property src_timestamp maxChannel 0
#set_interface_property src_timestamp readyAllowance 0
set_interface_property src_timestamp readyLatency 0
set_interface_property src_timestamp ENABLED true
set_interface_property src_timestamp EXPORT_OF ""
set_interface_property src_timestamp PORT_NAME_MAP ""
set_interface_property src_timestamp CMSIS_SVD_VARIABLES ""
set_interface_property src_timestamp SVD_ADDRESS_GROUP ""

add_interface_port src_timestamp aso_timestamp_valid valid Output 1
add_interface_port src_timestamp aso_timestamp_ready ready Input 1
add_interface_port src_timestamp aso_timestamp data Output 96


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

add_interface_port timestamp timestamp_valid valid Input 1
add_interface_port timestamp timestamp_data data Input 96

