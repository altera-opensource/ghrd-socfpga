#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2001-2020 Intel Corporation.
#
#****************************************************************************
#
# TCL File Generated by Component Editor 16.1
# DO NOT MODIFY
#
# altera_eth_fifo_pause_ctrl_adapter_hw "altera_eth_fifo_pause_ctrl_adapter_hw" v1.0
#
# request TCL package from ACDS 16.1
#****************************************************************************

package require -exact qsys 16.1


#
# module altera_eth_fifo_pause_ctrl_adapter_hw
#
set_module_property DESCRIPTION ""
set_module_property NAME altera_eth_fifo_pause_ctrl_adapter_hw
set_module_property VERSION 1.0.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR "Intel Corporation"
set_module_property GROUP "Example Designs/Ethernet/Misc"
set_module_property DISPLAY_NAME altera_eth_fifo_pause_ctrl_adapter_hw
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false
set_module_property ELABORATION_CALLBACK elaborate


#
# file sets
#
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL altera_eth_fifo_pause_ctrl_adapter
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file altera_eth_fifo_pause_ctrl_adapter.v VERILOG PATH "altera_eth_fifo_pause_ctrl_adapter.v" TOP_LEVEL_FILE

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL altera_eth_fifo_pause_ctrl_adapter
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file altera_eth_fifo_pause_ctrl_adapter.v VERILOG PATH "altera_eth_fifo_pause_ctrl_adapter.v" TOP_LEVEL_FILE

add_fileset SIM_VHDL SIM_VHDL "" ""
set_fileset_property SIM_VHDL TOP_LEVEL altera_eth_fifo_pause_ctrl_adapter
set_fileset_property SIM_VHDL ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VHDL ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file altera_eth_fifo_pause_ctrl_adapter.v VERILOG PATH "altera_eth_fifo_pause_ctrl_adapter.v" TOP_LEVEL_FILE


#
# parameters
#
add_parameter ETILE_HIP_PAUSE_EN INTEGER 0 ""
set_parameter_property ETILE_HIP_PAUSE_EN DEFAULT_VALUE 0
set_parameter_property ETILE_HIP_PAUSE_EN DISPLAY_NAME "EtileHIP_PauseEnable"
set_parameter_property ETILE_HIP_PAUSE_EN ALLOWED_RANGES {"1" "0"}
set_parameter_property ETILE_HIP_PAUSE_EN DESCRIPTION "Etile HIP Pause Control Enable"
set_parameter_property ETILE_HIP_PAUSE_EN HDL_PARAMETER false

#
# display items
#


#
# connection point clock
#
add_interface clock clock end
set_interface_property clock clockRate 0
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
# connection point almost_full_sink
#
add_interface almost_full_sink avalon_streaming end
set_interface_property almost_full_sink associatedClock clock
set_interface_property almost_full_sink associatedReset reset
set_interface_property almost_full_sink dataBitsPerSymbol 1
set_interface_property almost_full_sink errorDescriptor ""
set_interface_property almost_full_sink firstSymbolInHighOrderBits true
set_interface_property almost_full_sink maxChannel 0
set_interface_property almost_full_sink readyLatency 0
set_interface_property almost_full_sink ENABLED true
set_interface_property almost_full_sink EXPORT_OF ""
set_interface_property almost_full_sink PORT_NAME_MAP ""
set_interface_property almost_full_sink CMSIS_SVD_VARIABLES ""
set_interface_property almost_full_sink SVD_ADDRESS_GROUP ""

add_interface_port almost_full_sink data_sink_almost_full data Input 1


#
# connection point almost_empty_sink
#
add_interface almost_empty_sink avalon_streaming end
set_interface_property almost_empty_sink associatedClock clock
set_interface_property almost_empty_sink associatedReset reset
set_interface_property almost_empty_sink dataBitsPerSymbol 1
set_interface_property almost_empty_sink errorDescriptor ""
set_interface_property almost_empty_sink firstSymbolInHighOrderBits true
set_interface_property almost_empty_sink maxChannel 0
set_interface_property almost_empty_sink readyLatency 0
set_interface_property almost_empty_sink ENABLED true
set_interface_property almost_empty_sink EXPORT_OF ""
set_interface_property almost_empty_sink PORT_NAME_MAP ""
set_interface_property almost_empty_sink CMSIS_SVD_VARIABLES ""
set_interface_property almost_empty_sink SVD_ADDRESS_GROUP ""

add_interface_port almost_empty_sink data_sink_almost_empty data Input 1


#
# connection point pause_control_source
#
add_interface pause_control_source avalon_streaming start
set_interface_property pause_control_source associatedClock clock
set_interface_property pause_control_source associatedReset reset
set_interface_property pause_control_source dataBitsPerSymbol 2
set_interface_property pause_control_source errorDescriptor ""
set_interface_property pause_control_source firstSymbolInHighOrderBits true
set_interface_property pause_control_source maxChannel 0
set_interface_property pause_control_source readyLatency 0
set_interface_property pause_control_source ENABLED true
set_interface_property pause_control_source EXPORT_OF ""
set_interface_property pause_control_source PORT_NAME_MAP ""
set_interface_property pause_control_source CMSIS_SVD_VARIABLES ""
set_interface_property pause_control_source SVD_ADDRESS_GROUP ""

add_interface_port pause_control_source pause_ctrl_src_data data Output 2


#
# connection point pause_ctrl_etile_src_data
#
add_interface pause_ctrl_etile_src_data conduit end
set_interface_property pause_ctrl_etile_src_data associatedClock ""
set_interface_property pause_ctrl_etile_src_data associatedReset ""
set_interface_property pause_ctrl_etile_src_data ENABLED true
set_interface_property pause_ctrl_etile_src_data EXPORT_OF ""
set_interface_property pause_ctrl_etile_src_data PORT_NAME_MAP ""
set_interface_property pause_ctrl_etile_src_data CMSIS_SVD_VARIABLES ""
set_interface_property pause_ctrl_etile_src_data SVD_ADDRESS_GROUP ""
set_interface_property pause_ctrl_etile_src_data IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port pause_ctrl_etile_src_data pause_ctrl_etile_src_data i_sl_tx_pause Output 1
add_interface_port pause_ctrl_etile_src_data o_sl_rx_pause o_sl_rx_pause Input 1

proc elaborate {} {
    if { [get_parameter_value ETILE_HIP_PAUSE_EN] == 1 } {
        set_interface_property   pause_control_source           ENABLED 0
        set_interface_property   pause_ctrl_etile_src_data      ENABLED 1
    } else {
        set_interface_property   pause_control_source           ENABLED 1
        set_interface_property   pause_ctrl_etile_src_data      ENABLED 0
    }
}