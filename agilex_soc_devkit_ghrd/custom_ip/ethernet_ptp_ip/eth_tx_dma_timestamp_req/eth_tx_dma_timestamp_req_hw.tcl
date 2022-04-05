#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2018-2020 Intel Corporation.
#
#****************************************************************************
#
# eth_tx_dma_timestamp_req "Timestamp Request for Intel PSG Ethernet IP" v1.0
#
#****************************************************************************

package require -exact qsys 16.0


#
# module eth_tx_dma_timestamp_req
#
set_module_property DESCRIPTION "Timestamp Request for Intel PSG Ethernet IP"
set_module_property NAME eth_tx_dma_timestamp_req
set_module_property VERSION 1.0.0
set_module_property GROUP "Example Designs/Ethernet/Misc"
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR "Intel Corporation"
set_module_property DISPLAY_NAME "Timestamp Request for Intel PSG Ethernet IP"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


#
# file sets
#
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL eth_tx_dma_timestamp_req
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file eth_tx_dma_timestamp_req.v VERILOG PATH eth_tx_dma_timestamp_req.v TOP_LEVEL_FILE

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL eth_tx_dma_timestamp_req
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file eth_tx_dma_timestamp_req.v VERILOG PATH eth_tx_dma_timestamp_req.v

add_fileset SIM_VHDL SIM_VHDL "" ""
set_fileset_property SIM_VHDL TOP_LEVEL eth_tx_dma_timestamp_req
set_fileset_property SIM_VHDL ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VHDL ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file eth_tx_dma_timestamp_req.v VERILOG PATH eth_tx_dma_timestamp_req.v


#
# parameters
#
add_parameter BITSPERSYMBOL INTEGER 8
set_parameter_property BITSPERSYMBOL DEFAULT_VALUE 8
set_parameter_property BITSPERSYMBOL DISPLAY_NAME BITSPERSYMBOL
set_parameter_property BITSPERSYMBOL UNITS None
set_parameter_property BITSPERSYMBOL ALLOWED_RANGES -2147483648:2147483647
set_parameter_property BITSPERSYMBOL HDL_PARAMETER true
add_parameter SYMBOLSPERBEAT INTEGER 8
set_parameter_property SYMBOLSPERBEAT DEFAULT_VALUE 8
set_parameter_property SYMBOLSPERBEAT DISPLAY_NAME SYMBOLSPERBEAT
set_parameter_property SYMBOLSPERBEAT UNITS None
set_parameter_property SYMBOLSPERBEAT ALLOWED_RANGES -2147483648:2147483647
set_parameter_property SYMBOLSPERBEAT HDL_PARAMETER true
add_parameter EMPTY_WIDTH INTEGER 3
set_parameter_property EMPTY_WIDTH DEFAULT_VALUE 3
set_parameter_property EMPTY_WIDTH DISPLAY_NAME EMPTY_WIDTH
set_parameter_property EMPTY_WIDTH UNITS None
set_parameter_property EMPTY_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property EMPTY_WIDTH HDL_PARAMETER true
add_parameter ERROR_WIDTH INTEGER 6
set_parameter_property ERROR_WIDTH DEFAULT_VALUE 6
set_parameter_property ERROR_WIDTH DISPLAY_NAME ERROR_WIDTH
set_parameter_property ERROR_WIDTH UNITS None
set_parameter_property ERROR_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property ERROR_WIDTH HDL_PARAMETER true


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
# connection point pktin
#
add_interface pktin avalon_streaming end
set_interface_property pktin associatedClock clock
set_interface_property pktin associatedReset reset
set_interface_property pktin dataBitsPerSymbol 8
set_interface_property pktin errorDescriptor ""
set_interface_property pktin firstSymbolInHighOrderBits true
set_interface_property pktin maxChannel 0
#set_interface_property pktin readyAllowance 0
set_interface_property pktin readyLatency 0
set_interface_property pktin ENABLED true
set_interface_property pktin EXPORT_OF ""
set_interface_property pktin PORT_NAME_MAP ""
set_interface_property pktin CMSIS_SVD_VARIABLES ""
set_interface_property pktin SVD_ADDRESS_GROUP ""

add_interface_port pktin asi_pktin_valid valid Input 1
add_interface_port pktin asi_pktin_ready ready Output 1
add_interface_port pktin asi_pktin_data data Input "(((BITSPERSYMBOL * SYMBOLSPERBEAT) - 1)) - (0) + 1"
add_interface_port pktin asi_pktin_empty empty Input "((EMPTY_WIDTH - 1)) - (0) + 1"
add_interface_port pktin asi_pktin_error error Input "((ERROR_WIDTH - 1)) - (0) + 1"
add_interface_port pktin asi_pktin_eop endofpacket Input 1
add_interface_port pktin asi_pktin_sop startofpacket Input 1


#
# connection point pktout
#
add_interface pktout avalon_streaming start
set_interface_property pktout associatedClock clock
set_interface_property pktout associatedReset reset
set_interface_property pktout dataBitsPerSymbol 8
set_interface_property pktout errorDescriptor ""
set_interface_property pktout firstSymbolInHighOrderBits true
set_interface_property pktout maxChannel 0
#set_interface_property pktout readyAllowance 0
set_interface_property pktout readyLatency 0
set_interface_property pktout ENABLED true
set_interface_property pktout EXPORT_OF ""
set_interface_property pktout PORT_NAME_MAP ""
set_interface_property pktout CMSIS_SVD_VARIABLES ""
set_interface_property pktout SVD_ADDRESS_GROUP ""

add_interface_port pktout aso_pktout_valid valid Output 1
add_interface_port pktout aso_pktout_ready ready Input 1
add_interface_port pktout aso_pktout_data data Output "(((BITSPERSYMBOL * SYMBOLSPERBEAT) - 1)) - (0) + 1"
add_interface_port pktout aso_pktout_empty empty Output "((EMPTY_WIDTH - 1)) - (0) + 1"
add_interface_port pktout aso_pktout_error error Output "((ERROR_WIDTH - 1)) - (0) + 1"
add_interface_port pktout aso_pktout_eop endofpacket Output 1
add_interface_port pktout aso_pktout_sop startofpacket Output 1


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
# connection point timestamp_request
#
add_interface timestamp_request conduit end
set_interface_property timestamp_request associatedClock ""
set_interface_property timestamp_request associatedReset ""
set_interface_property timestamp_request ENABLED true
set_interface_property timestamp_request EXPORT_OF ""
set_interface_property timestamp_request PORT_NAME_MAP ""
set_interface_property timestamp_request CMSIS_SVD_VARIABLES ""
set_interface_property timestamp_request SVD_ADDRESS_GROUP ""

add_interface_port timestamp_request tstamp_req_valid valid Output 1
add_interface_port timestamp_request tstamp_req_fingerprint fingerprint Output 8


#
# connection point fingerprint
#
add_interface fingerprint avalon_streaming start
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

add_interface_port fingerprint aso_fingerprint_valid valid Output 1
add_interface_port fingerprint aso_fingerprint_ready ready Input 1
add_interface_port fingerprint aso_fingerprint data Output 8

