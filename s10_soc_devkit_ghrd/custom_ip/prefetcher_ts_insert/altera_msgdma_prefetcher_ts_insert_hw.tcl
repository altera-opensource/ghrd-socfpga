#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2018-2020 Intel Corporation.
#
#****************************************************************************
#
# msgdma_prefetcher_ts_insert "Timestamp Insert for Intel PSG MSGDMA Prefetcher" v1.0
# 
#****************************************************************************

package require -exact qsys 16.0


# 
# module msgdma_prefetcher_ts_insert
# 
set_module_property DESCRIPTION ""
set_module_property NAME altera_msgdma_prefetcher_ts_insert
set_module_property VERSION 1.0.0
set_module_property GROUP "Examples/Ethernet/DMA/mSGDMA Sub-core"
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR "Intel Corporation"
set_module_property DISPLAY_NAME "Timestamp Insert for Intel PSG MSGDMA Prefetcher MODIFIED"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL altera_msgdma_prefetcher_ts_insert
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file msgdma_prefetcher_ts_insert.v VERILOG PATH altera_msgdma_prefetcher_ts_insert.v TOP_LEVEL_FILE

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL altera_msgdma_prefetcher_ts_insert
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file msgdma_prefetcher_ts_insert.v VERILOG PATH altera_msgdma_prefetcher_ts_insert.v

add_fileset SIM_VHDL SIM_VHDL "" ""
set_fileset_property SIM_VHDL TOP_LEVEL altera_msgdma_prefetcher_ts_insert
set_fileset_property SIM_VHDL ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VHDL ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file msgdma_prefetcher_ts_insert.v VERILOG PATH altera_msgdma_prefetcher_ts_insert.v


# 
# parameters
# 


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk clk Input 1


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
# connection point snk_response
# 
add_interface snk_response avalon_streaming end
set_interface_property snk_response associatedClock clock
set_interface_property snk_response associatedReset reset
set_interface_property snk_response dataBitsPerSymbol 256
set_interface_property snk_response errorDescriptor ""
set_interface_property snk_response firstSymbolInHighOrderBits true
set_interface_property snk_response maxChannel 0
#set_interface_property snk_response readyAllowance 0
set_interface_property snk_response readyLatency 0
set_interface_property snk_response ENABLED true
set_interface_property snk_response EXPORT_OF ""
set_interface_property snk_response PORT_NAME_MAP ""
set_interface_property snk_response CMSIS_SVD_VARIABLES ""
set_interface_property snk_response SVD_ADDRESS_GROUP ""

add_interface_port snk_response snk_response_valid valid Input 1
add_interface_port snk_response snk_response_ready ready Output 1
add_interface_port snk_response snk_response_data data Input 256


# 
# connection point snk_timestamp
# 
add_interface snk_timestamp avalon_streaming end
set_interface_property snk_timestamp associatedClock clock
set_interface_property snk_timestamp associatedReset reset
set_interface_property snk_timestamp dataBitsPerSymbol 96
set_interface_property snk_timestamp errorDescriptor ""
set_interface_property snk_timestamp firstSymbolInHighOrderBits true
set_interface_property snk_timestamp maxChannel 0
#set_interface_property snk_timestamp readyAllowance 0
set_interface_property snk_timestamp readyLatency 0
set_interface_property snk_timestamp ENABLED true
set_interface_property snk_timestamp EXPORT_OF ""
set_interface_property snk_timestamp PORT_NAME_MAP ""
set_interface_property snk_timestamp CMSIS_SVD_VARIABLES ""
set_interface_property snk_timestamp SVD_ADDRESS_GROUP ""

add_interface_port snk_timestamp snk_timestamp_valid valid Input 1
add_interface_port snk_timestamp snk_timestamp_ready ready Output 1
add_interface_port snk_timestamp snk_timestamp data Input 96


# 
# connection point src_response
# 
add_interface src_response avalon_streaming start
set_interface_property src_response associatedClock clock
set_interface_property src_response associatedReset reset
set_interface_property src_response dataBitsPerSymbol 256
set_interface_property src_response errorDescriptor ""
set_interface_property src_response firstSymbolInHighOrderBits true
set_interface_property src_response maxChannel 0
#set_interface_property src_response readyAllowance 0
set_interface_property src_response readyLatency 0
set_interface_property src_response ENABLED true
set_interface_property src_response EXPORT_OF ""
set_interface_property src_response PORT_NAME_MAP ""
set_interface_property src_response CMSIS_SVD_VARIABLES ""
set_interface_property src_response SVD_ADDRESS_GROUP ""

add_interface_port src_response src_response_data data Output 256
add_interface_port src_response src_response_ready ready Input 1
add_interface_port src_response src_response_valid valid Output 1

