#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2017-2020 Intel Corporation.
#
#****************************************************************************
#
# etile_hip_adapter "Etile HIP IP conduits adapter" v1.0.1
# RSF 2018.08.28.13:40:51
# Etile Adapter IP for Etile IP adaption with the rest of QSYS components.
#
# request TCL package from ACDS 21.3
#
#****************************************************************************

package require -exact qsys 21.3


#
# module etile_hip_adapter
#
set_module_property DESCRIPTION ""
set_module_property NAME etile_hip_adapter
set_module_property VERSION 1.0.2
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP "Example Designs/Ethernet/Misc"
set_module_property AUTHOR "Intel Corporation"
set_module_property DISPLAY_NAME "Etile HIP IP conduits adapter"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK true
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false
set_module_property LOAD_ELABORATION_LIMIT 0
set_module_property ELABORATION_CALLBACK elaborate


#
# file sets
#
add_fileset synthesis_fileset QUARTUS_SYNTH "" ""
set_fileset_property synthesis_fileset TOP_LEVEL etile_hip_adapter
set_fileset_property synthesis_fileset ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property synthesis_fileset ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file etile_hip_adapter.v VERILOG PATH etile_hip_adapter.v TOP_LEVEL_FILE

add_fileset sim_verilog_fileset SIM_VERILOG "" ""
set_fileset_property sim_verilog_fileset TOP_LEVEL etile_hip_adapter
set_fileset_property sim_verilog_fileset ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property sim_verilog_fileset ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file etile_hip_adapter.v VERILOG PATH etile_hip_adapter.v TOP_LEVEL_FILE

add_fileset sim_vhdl_fileset SIM_VHDL "" ""
set_fileset_property sim_vhdl_fileset TOP_LEVEL etile_hip_adapter
set_fileset_property sim_vhdl_fileset ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property sim_vhdl_fileset ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file etile_hip_adapter.v VERILOG PATH etile_hip_adapter.v TOP_LEVEL_FILE


#
# parameters
#
add_parameter ETH_RECONFIG_ADDRESS_WIDTH INTEGER 19 "Width of the address signal"
set_parameter_property ETH_RECONFIG_ADDRESS_WIDTH DEFAULT_VALUE 19
set_parameter_property ETH_RECONFIG_ADDRESS_WIDTH DISPLAY_NAME "eth_reconfig avalon-MM  Address Width"
set_parameter_property ETH_RECONFIG_ADDRESS_WIDTH UNITS None
set_parameter_property ETH_RECONFIG_ADDRESS_WIDTH ALLOWED_RANGES {19 21}
set_parameter_property ETH_RECONFIG_ADDRESS_WIDTH DESCRIPTION "Width of the address signal"
set_parameter_property ETH_RECONFIG_ADDRESS_WIDTH AFFECTS_GENERATION false
set_parameter_property ETH_RECONFIG_ADDRESS_WIDTH HDL_PARAMETER true
add_parameter READY_LATENCY_SL INTEGER 0 "Readylatency for SL interface"
set_parameter_property READY_LATENCY_SL DEFAULT_VALUE 0
set_parameter_property READY_LATENCY_SL DISPLAY_NAME "Readylatency for SL interface"
set_parameter_property READY_LATENCY_SL UNITS None
set_parameter_property READY_LATENCY_SL ALLOWED_RANGES 0:3
set_parameter_property READY_LATENCY_SL DESCRIPTION "Readylatency for SL interface"
set_parameter_property READY_LATENCY_SL AFFECTS_GENERATION false

add_parameter eth_25gbe_en INTEGER 1 "Enable for Etherent 25gbe"
set_parameter_property eth_25gbe_en DEFAULT_VALUE 1
set_parameter_property eth_25gbe_en DISPLAY_NAME "eth_enable 25gbe"
set_parameter_property eth_25gbe_en UNITS None
set_parameter_property eth_25gbe_en ALLOWED_RANGES {0 1}
set_parameter_property eth_25gbe_en DESCRIPTION "Width of the address signal"
set_parameter_property eth_25gbe_en AFFECTS_GENERATION false
set_parameter_property eth_25gbe_en HDL_PARAMETER false

add_parameter eth_10gbe_en INTEGER 0 "Enable for Etherent 10gbe"
set_parameter_property eth_10gbe_en DEFAULT_VALUE 0
set_parameter_property eth_10gbe_en DISPLAY_NAME "eth_enable 10gbe"
set_parameter_property eth_10gbe_en UNITS None
set_parameter_property eth_10gbe_en ALLOWED_RANGES {0 1}
set_parameter_property eth_10gbe_en DESCRIPTION "Width of the address signal"
set_parameter_property eth_10gbe_en AFFECTS_GENERATION false
set_parameter_property eth_10gbe_en HDL_PARAMETER false

#
# display items
#


#
# connection point reconfig_clock
#
add_interface reconfig_clock clock end
set_interface_property reconfig_clock ENABLED true
set_interface_property reconfig_clock EXPORT_OF ""
set_interface_property reconfig_clock PORT_NAME_MAP ""
set_interface_property reconfig_clock CMSIS_SVD_VARIABLES ""
set_interface_property reconfig_clock SVD_ADDRESS_GROUP ""
set_interface_property reconfig_clock IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port reconfig_clock reconfig_clock clk Input 1


#
# connection point reconfig_reset
#
add_interface reconfig_reset reset end
set_interface_property reconfig_reset associatedClock reconfig_clock
set_interface_property reconfig_reset synchronousEdges DEASSERT
set_interface_property reconfig_reset ENABLED true
set_interface_property reconfig_reset EXPORT_OF ""
set_interface_property reconfig_reset PORT_NAME_MAP ""
set_interface_property reconfig_reset CMSIS_SVD_VARIABLES ""
set_interface_property reconfig_reset SVD_ADDRESS_GROUP ""
set_interface_property reconfig_reset IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port reconfig_reset reconfig_reset reset Input 1


#
# connection point clk_pll_div64
#
add_interface clk_pll_div64 clock start
set_interface_property clk_pll_div64 associatedDirectClock ""
set_interface_property clk_pll_div64 clockRate 402832031
set_interface_property clk_pll_div64 clockRateKnown true
set_interface_property clk_pll_div64 ENABLED true
set_interface_property clk_pll_div64 EXPORT_OF ""
set_interface_property clk_pll_div64 PORT_NAME_MAP ""
set_interface_property clk_pll_div64 CMSIS_SVD_VARIABLES ""
set_interface_property clk_pll_div64 SVD_ADDRESS_GROUP ""
set_interface_property clk_pll_div64 IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port clk_pll_div64 clk_pll_div64 clk Output 1


#
# connection point o_clk_pll_div64
#
add_interface o_clk_pll_div64 conduit end
set_interface_property o_clk_pll_div64 associatedClock ""
set_interface_property o_clk_pll_div64 associatedReset ""
set_interface_property o_clk_pll_div64 ENABLED true
set_interface_property o_clk_pll_div64 EXPORT_OF ""
set_interface_property o_clk_pll_div64 PORT_NAME_MAP ""
set_interface_property o_clk_pll_div64 CMSIS_SVD_VARIABLES ""
set_interface_property o_clk_pll_div64 SVD_ADDRESS_GROUP ""
set_interface_property o_clk_pll_div64 IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port o_clk_pll_div64 o_clk_pll_div64 o_clk_pll_div64 Input 3


#
# connection point clk_pll_div66
#
add_interface clk_pll_div66 clock start
set_interface_property clk_pll_div66 associatedDirectClock ""
set_interface_property clk_pll_div66 ENABLED true
set_interface_property clk_pll_div66 EXPORT_OF ""
set_interface_property clk_pll_div66 PORT_NAME_MAP ""
set_interface_property clk_pll_div66 CMSIS_SVD_VARIABLES ""
set_interface_property clk_pll_div66 SVD_ADDRESS_GROUP ""
set_interface_property clk_pll_div66 IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port clk_pll_div66 clk_pll_div66 clk Output 1


#
# connection point o_clk_pll_div66
#
add_interface o_clk_pll_div66 conduit end
set_interface_property o_clk_pll_div66 associatedClock ""
set_interface_property o_clk_pll_div66 associatedReset ""
set_interface_property o_clk_pll_div66 ENABLED true
set_interface_property o_clk_pll_div66 EXPORT_OF ""
set_interface_property o_clk_pll_div66 PORT_NAME_MAP ""
set_interface_property o_clk_pll_div66 CMSIS_SVD_VARIABLES ""
set_interface_property o_clk_pll_div66 SVD_ADDRESS_GROUP ""
set_interface_property o_clk_pll_div66 IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port o_clk_pll_div66 o_clk_pll_div66 o_clk_pll_div66 Input 3


#
# connection point clk_rec_div64
#
add_interface clk_rec_div64 clock start
set_interface_property clk_rec_div64 associatedDirectClock ""
set_interface_property clk_rec_div64 ENABLED true
set_interface_property clk_rec_div64 EXPORT_OF ""
set_interface_property clk_rec_div64 PORT_NAME_MAP ""
set_interface_property clk_rec_div64 CMSIS_SVD_VARIABLES ""
set_interface_property clk_rec_div64 SVD_ADDRESS_GROUP ""
set_interface_property clk_rec_div64 IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port clk_rec_div64 clk_rec_div64 clk Output 1


#
# connection point o_clk_rec_div64
#
add_interface o_clk_rec_div64 conduit end
set_interface_property o_clk_rec_div64 associatedClock ""
set_interface_property o_clk_rec_div64 associatedReset ""
set_interface_property o_clk_rec_div64 ENABLED true
set_interface_property o_clk_rec_div64 EXPORT_OF ""
set_interface_property o_clk_rec_div64 PORT_NAME_MAP ""
set_interface_property o_clk_rec_div64 CMSIS_SVD_VARIABLES ""
set_interface_property o_clk_rec_div64 SVD_ADDRESS_GROUP ""
set_interface_property o_clk_rec_div64 IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port o_clk_rec_div64 o_clk_rec_div64 o_clk_rec_div64 Input 3


#
# connection point clk_rec_div66
#
add_interface clk_rec_div66 clock start
set_interface_property clk_rec_div66 associatedDirectClock ""
set_interface_property clk_rec_div66 ENABLED true
set_interface_property clk_rec_div66 EXPORT_OF ""
set_interface_property clk_rec_div66 PORT_NAME_MAP ""
set_interface_property clk_rec_div66 CMSIS_SVD_VARIABLES ""
set_interface_property clk_rec_div66 SVD_ADDRESS_GROUP ""
set_interface_property clk_rec_div66 IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port clk_rec_div66 clk_rec_div66 clk Output 1


#
# connection point o_clk_rec_div66
#
add_interface o_clk_rec_div66 conduit end
set_interface_property o_clk_rec_div66 associatedClock ""
set_interface_property o_clk_rec_div66 associatedReset ""
set_interface_property o_clk_rec_div66 ENABLED true
set_interface_property o_clk_rec_div66 EXPORT_OF ""
set_interface_property o_clk_rec_div66 PORT_NAME_MAP ""
set_interface_property o_clk_rec_div66 CMSIS_SVD_VARIABLES ""
set_interface_property o_clk_rec_div66 SVD_ADDRESS_GROUP ""
set_interface_property o_clk_rec_div66 IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port o_clk_rec_div66 o_clk_rec_div66 o_clk_rec_div66 Input 3


#
# connection point sl_clk_tx
#
add_interface sl_clk_tx clock end
set_interface_property sl_clk_tx ENABLED true
set_interface_property sl_clk_tx EXPORT_OF ""
set_interface_property sl_clk_tx PORT_NAME_MAP ""
set_interface_property sl_clk_tx CMSIS_SVD_VARIABLES ""
set_interface_property sl_clk_tx SVD_ADDRESS_GROUP ""
set_interface_property sl_clk_tx IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port sl_clk_tx sl_clk_tx clk Input 1


#
# connection point sl_clk_tx_tod
#
add_interface sl_clk_tx_tod clock end
set_interface_property sl_clk_tx_tod ENABLED true
set_interface_property sl_clk_tx_tod EXPORT_OF ""
set_interface_property sl_clk_tx_tod PORT_NAME_MAP ""
set_interface_property sl_clk_tx_tod CMSIS_SVD_VARIABLES ""
set_interface_property sl_clk_tx_tod SVD_ADDRESS_GROUP ""
set_interface_property sl_clk_tx_tod IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port sl_clk_tx_tod sl_clk_tx_tod clk Input 1


#
# connection point sl_rst_tx
#
add_interface sl_rst_tx reset end
set_interface_property sl_rst_tx associatedClock sl_clk_tx
set_interface_property sl_rst_tx synchronousEdges DEASSERT
set_interface_property sl_rst_tx ENABLED true
set_interface_property sl_rst_tx EXPORT_OF ""
set_interface_property sl_rst_tx PORT_NAME_MAP ""
set_interface_property sl_rst_tx CMSIS_SVD_VARIABLES ""
set_interface_property sl_rst_tx SVD_ADDRESS_GROUP ""
set_interface_property sl_rst_tx IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port sl_rst_tx sl_rst_tx reset Input 1


#
# connection point sl_clk_rx
#
add_interface sl_clk_rx clock end
set_interface_property sl_clk_rx ENABLED true
set_interface_property sl_clk_rx EXPORT_OF ""
set_interface_property sl_clk_rx PORT_NAME_MAP ""
set_interface_property sl_clk_rx CMSIS_SVD_VARIABLES ""
set_interface_property sl_clk_rx SVD_ADDRESS_GROUP ""
set_interface_property sl_clk_rx IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port sl_clk_rx sl_clk_rx clk Input 1


#
# connection point sl_clk_rx_tod
#
add_interface sl_clk_rx_tod clock end
set_interface_property sl_clk_rx_tod ENABLED true
set_interface_property sl_clk_rx_tod EXPORT_OF ""
set_interface_property sl_clk_rx_tod PORT_NAME_MAP ""
set_interface_property sl_clk_rx_tod CMSIS_SVD_VARIABLES ""
set_interface_property sl_clk_rx_tod SVD_ADDRESS_GROUP ""
set_interface_property sl_clk_rx_tod IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port sl_clk_rx_tod sl_clk_rx_tod clk Input 1


#
# connection point clk_ptp_sample
#
add_interface clk_ptp_sample clock end
set_interface_property clk_ptp_sample ENABLED true
set_interface_property clk_ptp_sample EXPORT_OF ""
set_interface_property clk_ptp_sample PORT_NAME_MAP ""
set_interface_property clk_ptp_sample CMSIS_SVD_VARIABLES ""
set_interface_property clk_ptp_sample SVD_ADDRESS_GROUP ""
set_interface_property clk_ptp_sample IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port clk_ptp_sample clk_ptp_sample clk Input 1


#
# connection point sl_rst_rx
#
add_interface sl_rst_rx reset end
set_interface_property sl_rst_rx associatedClock sl_clk_rx
set_interface_property sl_rst_rx synchronousEdges DEASSERT
set_interface_property sl_rst_rx ENABLED true
set_interface_property sl_rst_rx EXPORT_OF ""
set_interface_property sl_rst_rx PORT_NAME_MAP ""
set_interface_property sl_rst_rx CMSIS_SVD_VARIABLES ""
set_interface_property sl_rst_rx SVD_ADDRESS_GROUP ""
set_interface_property sl_rst_rx IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port sl_rst_rx sl_rst_rx reset Input 1


#
# connection point i_reconfig_reset
#
add_interface i_reconfig_reset conduit end
set_interface_property i_reconfig_reset associatedClock reconfig_clock
set_interface_property i_reconfig_reset associatedReset ""
set_interface_property i_reconfig_reset ENABLED true
set_interface_property i_reconfig_reset EXPORT_OF ""
set_interface_property i_reconfig_reset PORT_NAME_MAP ""
set_interface_property i_reconfig_reset CMSIS_SVD_VARIABLES ""
set_interface_property i_reconfig_reset SVD_ADDRESS_GROUP ""
set_interface_property i_reconfig_reset IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port i_reconfig_reset i_reconfig_reset i_reconfig_reset Output 1


#
# connection point i_sl_tx_rst_n
#
add_interface i_sl_tx_rst_n conduit end
set_interface_property i_sl_tx_rst_n associatedClock ""
set_interface_property i_sl_tx_rst_n associatedReset ""
set_interface_property i_sl_tx_rst_n ENABLED true
set_interface_property i_sl_tx_rst_n EXPORT_OF ""
set_interface_property i_sl_tx_rst_n PORT_NAME_MAP ""
set_interface_property i_sl_tx_rst_n CMSIS_SVD_VARIABLES ""
set_interface_property i_sl_tx_rst_n SVD_ADDRESS_GROUP ""
set_interface_property i_sl_tx_rst_n IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port i_sl_tx_rst_n i_sl_tx_rst_n i_sl_tx_rst_n Output 1


#
# connection point i_sl_rx_rst_n
#
add_interface i_sl_rx_rst_n conduit end
set_interface_property i_sl_rx_rst_n associatedClock ""
set_interface_property i_sl_rx_rst_n associatedReset ""
set_interface_property i_sl_rx_rst_n ENABLED true
set_interface_property i_sl_rx_rst_n EXPORT_OF ""
set_interface_property i_sl_rx_rst_n PORT_NAME_MAP ""
set_interface_property i_sl_rx_rst_n CMSIS_SVD_VARIABLES ""
set_interface_property i_sl_rx_rst_n SVD_ADDRESS_GROUP ""
set_interface_property i_sl_rx_rst_n IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port i_sl_rx_rst_n i_sl_rx_rst_n i_sl_rx_rst_n Output 1


#
# connection point sl_csr_rst_n
#
add_interface sl_csr_rst_n reset end
set_interface_property sl_csr_rst_n associatedClock ""
set_interface_property sl_csr_rst_n synchronousEdges NONE
set_interface_property sl_csr_rst_n ENABLED true
set_interface_property sl_csr_rst_n EXPORT_OF ""
set_interface_property sl_csr_rst_n PORT_NAME_MAP ""
set_interface_property sl_csr_rst_n CMSIS_SVD_VARIABLES ""
set_interface_property sl_csr_rst_n SVD_ADDRESS_GROUP ""
set_interface_property sl_csr_rst_n IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port sl_csr_rst_n sl_csr_rst_n reset_n Input 1


#
# connection point i_sl_csr_rst_n
#
add_interface i_sl_csr_rst_n conduit end
set_interface_property i_sl_csr_rst_n associatedClock ""
set_interface_property i_sl_csr_rst_n associatedReset ""
set_interface_property i_sl_csr_rst_n ENABLED true
set_interface_property i_sl_csr_rst_n EXPORT_OF ""
set_interface_property i_sl_csr_rst_n PORT_NAME_MAP ""
set_interface_property i_sl_csr_rst_n CMSIS_SVD_VARIABLES ""
set_interface_property i_sl_csr_rst_n SVD_ADDRESS_GROUP ""
set_interface_property i_sl_csr_rst_n IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port i_sl_csr_rst_n i_sl_csr_rst_n i_sl_csr_rst_n Output 1


#
# connection point i_sl_clk_tx
#
add_interface i_sl_clk_tx conduit end
set_interface_property i_sl_clk_tx associatedClock ""
set_interface_property i_sl_clk_tx associatedReset ""
set_interface_property i_sl_clk_tx ENABLED true
set_interface_property i_sl_clk_tx EXPORT_OF ""
set_interface_property i_sl_clk_tx PORT_NAME_MAP ""
set_interface_property i_sl_clk_tx CMSIS_SVD_VARIABLES ""
set_interface_property i_sl_clk_tx SVD_ADDRESS_GROUP ""
set_interface_property i_sl_clk_tx IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port i_sl_clk_tx i_sl_clk_tx i_sl_clk_tx Output 1


#
# connection point i_sl_clk_tx_tod
#
add_interface i_sl_clk_tx_tod conduit end
set_interface_property i_sl_clk_tx_tod associatedClock ""
set_interface_property i_sl_clk_tx_tod associatedReset ""
set_interface_property i_sl_clk_tx_tod ENABLED true
set_interface_property i_sl_clk_tx_tod EXPORT_OF ""
set_interface_property i_sl_clk_tx_tod PORT_NAME_MAP ""
set_interface_property i_sl_clk_tx_tod CMSIS_SVD_VARIABLES ""
set_interface_property i_sl_clk_tx_tod SVD_ADDRESS_GROUP ""
set_interface_property i_sl_clk_tx_tod IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port i_sl_clk_tx_tod i_sl_clk_tx_tod i_sl_clk_tx_tod Output 1


#
# connection point i_sl_clk_rx
#
add_interface i_sl_clk_rx conduit end
set_interface_property i_sl_clk_rx associatedClock ""
set_interface_property i_sl_clk_rx associatedReset ""
set_interface_property i_sl_clk_rx ENABLED true
set_interface_property i_sl_clk_rx EXPORT_OF ""
set_interface_property i_sl_clk_rx PORT_NAME_MAP ""
set_interface_property i_sl_clk_rx CMSIS_SVD_VARIABLES ""
set_interface_property i_sl_clk_rx SVD_ADDRESS_GROUP ""
set_interface_property i_sl_clk_rx IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port i_sl_clk_rx i_sl_clk_rx i_sl_clk_rx Output 1


#
# connection point i_sl_clk_rx_tod
#
add_interface i_sl_clk_rx_tod conduit end
set_interface_property i_sl_clk_rx_tod associatedClock ""
set_interface_property i_sl_clk_rx_tod associatedReset ""
set_interface_property i_sl_clk_rx_tod ENABLED true
set_interface_property i_sl_clk_rx_tod EXPORT_OF ""
set_interface_property i_sl_clk_rx_tod PORT_NAME_MAP ""
set_interface_property i_sl_clk_rx_tod CMSIS_SVD_VARIABLES ""
set_interface_property i_sl_clk_rx_tod SVD_ADDRESS_GROUP ""
set_interface_property i_sl_clk_rx_tod IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port i_sl_clk_rx_tod i_sl_clk_rx_tod i_sl_clk_rx_tod Output 1


#
# connection point rsfec_reconfig
#
add_interface rsfec_reconfig avalon end
set_interface_property rsfec_reconfig addressGroup 0
set_interface_property rsfec_reconfig addressUnits WORDS
set_interface_property rsfec_reconfig associatedClock reconfig_clock
set_interface_property rsfec_reconfig associatedReset reconfig_reset
set_interface_property rsfec_reconfig bitsPerSymbol 8
set_interface_property rsfec_reconfig bridgedAddressOffset 0
set_interface_property rsfec_reconfig bridgesToMaster ""
set_interface_property rsfec_reconfig burstOnBurstBoundariesOnly false
set_interface_property rsfec_reconfig burstcountUnits WORDS
set_interface_property rsfec_reconfig explicitAddressSpan 0
set_interface_property rsfec_reconfig holdTime 0
set_interface_property rsfec_reconfig linewrapBursts false
set_interface_property rsfec_reconfig maximumPendingReadTransactions 0
set_interface_property rsfec_reconfig maximumPendingWriteTransactions 0
set_interface_property rsfec_reconfig minimumResponseLatency 1
set_interface_property rsfec_reconfig readLatency 0
set_interface_property rsfec_reconfig readWaitTime 1
set_interface_property rsfec_reconfig setupTime 0
set_interface_property rsfec_reconfig timingUnits Cycles
set_interface_property rsfec_reconfig transparentBridge false
set_interface_property rsfec_reconfig waitrequestAllowance 0
set_interface_property rsfec_reconfig writeWaitTime 0
set_interface_property rsfec_reconfig ENABLED true
set_interface_property rsfec_reconfig EXPORT_OF ""
set_interface_property rsfec_reconfig PORT_NAME_MAP ""
set_interface_property rsfec_reconfig CMSIS_SVD_VARIABLES ""
set_interface_property rsfec_reconfig SVD_ADDRESS_GROUP ""
set_interface_property rsfec_reconfig IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port rsfec_reconfig rsfec_reconfig_address address Input 11
add_interface_port rsfec_reconfig rsfec_reconfig_read read Input 1
add_interface_port rsfec_reconfig rsfec_reconfig_readdata readdata Output 8
add_interface_port rsfec_reconfig rsfec_reconfig_write write Input 1
add_interface_port rsfec_reconfig rsfec_reconfig_writedata writedata Input 8
add_interface_port rsfec_reconfig rsfec_reconfig_waitrequest waitrequest Output 1
set_interface_assignment rsfec_reconfig embeddedsw.configuration.isFlash 0
set_interface_assignment rsfec_reconfig embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment rsfec_reconfig embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment rsfec_reconfig embeddedsw.configuration.isPrintableDevice 0


#
# connection point i_rsfec_reconfig_addr
#
add_interface i_rsfec_reconfig_addr conduit end
set_interface_property i_rsfec_reconfig_addr associatedClock ""
set_interface_property i_rsfec_reconfig_addr associatedReset ""
set_interface_property i_rsfec_reconfig_addr ENABLED true
set_interface_property i_rsfec_reconfig_addr EXPORT_OF ""
set_interface_property i_rsfec_reconfig_addr PORT_NAME_MAP ""
set_interface_property i_rsfec_reconfig_addr CMSIS_SVD_VARIABLES ""
set_interface_property i_rsfec_reconfig_addr SVD_ADDRESS_GROUP ""
set_interface_property i_rsfec_reconfig_addr IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port i_rsfec_reconfig_addr i_rsfec_reconfig_addr i_rsfec_reconfig_addr Output 11


# connection point i_rsfec_reconfig_write
#
add_interface i_rsfec_reconfig_write conduit end
set_interface_property i_rsfec_reconfig_write associatedClock ""
set_interface_property i_rsfec_reconfig_write associatedReset ""
set_interface_property i_rsfec_reconfig_write ENABLED true
set_interface_property i_rsfec_reconfig_write EXPORT_OF ""
set_interface_property i_rsfec_reconfig_write PORT_NAME_MAP ""
set_interface_property i_rsfec_reconfig_write CMSIS_SVD_VARIABLES ""
set_interface_property i_rsfec_reconfig_write SVD_ADDRESS_GROUP ""
set_interface_property i_rsfec_reconfig_write IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port i_rsfec_reconfig_write i_rsfec_reconfig_write i_rsfec_reconfig_write Output 1


#
# connection point i_rsfec_reconfig_read
#
add_interface i_rsfec_reconfig_read conduit end
set_interface_property i_rsfec_reconfig_read associatedClock ""
set_interface_property i_rsfec_reconfig_read associatedReset ""
set_interface_property i_rsfec_reconfig_read ENABLED true
set_interface_property i_rsfec_reconfig_read EXPORT_OF ""
set_interface_property i_rsfec_reconfig_read PORT_NAME_MAP ""
set_interface_property i_rsfec_reconfig_read CMSIS_SVD_VARIABLES ""
set_interface_property i_rsfec_reconfig_read SVD_ADDRESS_GROUP ""
set_interface_property i_rsfec_reconfig_read IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port i_rsfec_reconfig_read i_rsfec_reconfig_read i_rsfec_reconfig_read Output 1


#
# connection point i_rsfec_reconfig_writedata
#
add_interface i_rsfec_reconfig_writedata conduit end
set_interface_property i_rsfec_reconfig_writedata associatedClock ""
set_interface_property i_rsfec_reconfig_writedata associatedReset ""
set_interface_property i_rsfec_reconfig_writedata ENABLED true
set_interface_property i_rsfec_reconfig_writedata EXPORT_OF ""
set_interface_property i_rsfec_reconfig_writedata PORT_NAME_MAP ""
set_interface_property i_rsfec_reconfig_writedata CMSIS_SVD_VARIABLES ""
set_interface_property i_rsfec_reconfig_writedata SVD_ADDRESS_GROUP ""
set_interface_property i_rsfec_reconfig_writedata IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port i_rsfec_reconfig_writedata i_rsfec_reconfig_writedata i_rsfec_reconfig_writedata Output 8


#
# connection point o_rsfec_reconfig_readdata
#
add_interface o_rsfec_reconfig_readdata conduit end
set_interface_property o_rsfec_reconfig_readdata associatedClock ""
set_interface_property o_rsfec_reconfig_readdata associatedReset ""
set_interface_property o_rsfec_reconfig_readdata ENABLED true
set_interface_property o_rsfec_reconfig_readdata EXPORT_OF ""
set_interface_property o_rsfec_reconfig_readdata PORT_NAME_MAP ""
set_interface_property o_rsfec_reconfig_readdata CMSIS_SVD_VARIABLES ""
set_interface_property o_rsfec_reconfig_readdata SVD_ADDRESS_GROUP ""
set_interface_property o_rsfec_reconfig_readdata IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port o_rsfec_reconfig_readdata o_rsfec_reconfig_readdata o_rsfec_reconfig_readdata Input 8


#
# connection point o_rsfec_reconfig_waitrequest
#
add_interface o_rsfec_reconfig_waitrequest conduit end
set_interface_property o_rsfec_reconfig_waitrequest associatedClock ""
set_interface_property o_rsfec_reconfig_waitrequest associatedReset ""
set_interface_property o_rsfec_reconfig_waitrequest ENABLED true
set_interface_property o_rsfec_reconfig_waitrequest EXPORT_OF ""
set_interface_property o_rsfec_reconfig_waitrequest PORT_NAME_MAP ""
set_interface_property o_rsfec_reconfig_waitrequest CMSIS_SVD_VARIABLES ""
set_interface_property o_rsfec_reconfig_waitrequest SVD_ADDRESS_GROUP ""
set_interface_property o_rsfec_reconfig_waitrequest IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port o_rsfec_reconfig_waitrequest o_rsfec_reconfig_waitrequest o_rsfec_reconfig_waitrequest Input 1


#
# connection point i_ptp_reconfig_address
#
add_interface i_ptp_reconfig_address conduit end
set_interface_property i_ptp_reconfig_address associatedClock ""
set_interface_property i_ptp_reconfig_address associatedReset ""
set_interface_property i_ptp_reconfig_address ENABLED true
set_interface_property i_ptp_reconfig_address EXPORT_OF ""
set_interface_property i_ptp_reconfig_address PORT_NAME_MAP ""
set_interface_property i_ptp_reconfig_address CMSIS_SVD_VARIABLES ""
set_interface_property i_ptp_reconfig_address SVD_ADDRESS_GROUP ""
set_interface_property i_ptp_reconfig_address IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port i_ptp_reconfig_address i_ptp_reconfig_address i_ptp_reconfig_address Output 38


#
# connection point i_ptp_reconfig_write
#
add_interface i_ptp_reconfig_write conduit end
set_interface_property i_ptp_reconfig_write associatedClock ""
set_interface_property i_ptp_reconfig_write associatedReset ""
set_interface_property i_ptp_reconfig_write ENABLED true
set_interface_property i_ptp_reconfig_write EXPORT_OF ""
set_interface_property i_ptp_reconfig_write PORT_NAME_MAP ""
set_interface_property i_ptp_reconfig_write CMSIS_SVD_VARIABLES ""
set_interface_property i_ptp_reconfig_write SVD_ADDRESS_GROUP ""
set_interface_property i_ptp_reconfig_write IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port i_ptp_reconfig_write i_ptp_reconfig_write i_ptp_reconfig_write Output 2


#
# connection point i_ptp_reconfig_read
#
add_interface i_ptp_reconfig_read conduit end
set_interface_property i_ptp_reconfig_read associatedClock ""
set_interface_property i_ptp_reconfig_read associatedReset ""
set_interface_property i_ptp_reconfig_read ENABLED true
set_interface_property i_ptp_reconfig_read EXPORT_OF ""
set_interface_property i_ptp_reconfig_read PORT_NAME_MAP ""
set_interface_property i_ptp_reconfig_read CMSIS_SVD_VARIABLES ""
set_interface_property i_ptp_reconfig_read SVD_ADDRESS_GROUP ""
set_interface_property i_ptp_reconfig_read IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port i_ptp_reconfig_read i_ptp_reconfig_read i_ptp_reconfig_read Output 2


#
# connection point i_ptp_reconfig_writedata
#
add_interface i_ptp_reconfig_writedata conduit end
set_interface_property i_ptp_reconfig_writedata associatedClock ""
set_interface_property i_ptp_reconfig_writedata associatedReset ""
set_interface_property i_ptp_reconfig_writedata ENABLED true
set_interface_property i_ptp_reconfig_writedata EXPORT_OF ""
set_interface_property i_ptp_reconfig_writedata PORT_NAME_MAP ""
set_interface_property i_ptp_reconfig_writedata CMSIS_SVD_VARIABLES ""
set_interface_property i_ptp_reconfig_writedata SVD_ADDRESS_GROUP ""
set_interface_property i_ptp_reconfig_writedata IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port i_ptp_reconfig_writedata i_ptp_reconfig_writedata i_ptp_reconfig_writedata Output 16


#
# connection point o_ptp_reconfig_readdata
#
add_interface o_ptp_reconfig_readdata conduit end
set_interface_property o_ptp_reconfig_readdata associatedClock ""
set_interface_property o_ptp_reconfig_readdata associatedReset ""
set_interface_property o_ptp_reconfig_readdata ENABLED true
set_interface_property o_ptp_reconfig_readdata EXPORT_OF ""
set_interface_property o_ptp_reconfig_readdata PORT_NAME_MAP ""
set_interface_property o_ptp_reconfig_readdata CMSIS_SVD_VARIABLES ""
set_interface_property o_ptp_reconfig_readdata SVD_ADDRESS_GROUP ""
set_interface_property o_ptp_reconfig_readdata IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port o_ptp_reconfig_readdata o_ptp_reconfig_readdata o_ptp_reconfig_readdata Input 16


#
# connection point o_ptp_reconfig_waitrequest
#
add_interface o_ptp_reconfig_waitrequest conduit end
set_interface_property o_ptp_reconfig_waitrequest associatedClock ""
set_interface_property o_ptp_reconfig_waitrequest associatedReset ""
set_interface_property o_ptp_reconfig_waitrequest ENABLED true
set_interface_property o_ptp_reconfig_waitrequest EXPORT_OF ""
set_interface_property o_ptp_reconfig_waitrequest PORT_NAME_MAP ""
set_interface_property o_ptp_reconfig_waitrequest CMSIS_SVD_VARIABLES ""
set_interface_property o_ptp_reconfig_waitrequest SVD_ADDRESS_GROUP ""
set_interface_property o_ptp_reconfig_waitrequest IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port o_ptp_reconfig_waitrequest o_ptp_reconfig_waitrequest o_ptp_reconfig_waitrequest Input 2


#
# connection point xcvr_reconfig
#
add_interface xcvr_reconfig avalon end
set_interface_property xcvr_reconfig addressGroup 0
set_interface_property xcvr_reconfig addressUnits WORDS
set_interface_property xcvr_reconfig associatedClock reconfig_clock
set_interface_property xcvr_reconfig associatedReset reconfig_reset
set_interface_property xcvr_reconfig bitsPerSymbol 8
set_interface_property xcvr_reconfig bridgedAddressOffset 0
set_interface_property xcvr_reconfig bridgesToMaster ""
set_interface_property xcvr_reconfig burstOnBurstBoundariesOnly false
set_interface_property xcvr_reconfig burstcountUnits WORDS
set_interface_property xcvr_reconfig explicitAddressSpan 0
set_interface_property xcvr_reconfig holdTime 0
set_interface_property xcvr_reconfig linewrapBursts false
set_interface_property xcvr_reconfig maximumPendingReadTransactions 0
set_interface_property xcvr_reconfig maximumPendingWriteTransactions 0
set_interface_property xcvr_reconfig minimumResponseLatency 1
set_interface_property xcvr_reconfig readLatency 0
set_interface_property xcvr_reconfig readWaitTime 1
set_interface_property xcvr_reconfig setupTime 0
set_interface_property xcvr_reconfig timingUnits Cycles
set_interface_property xcvr_reconfig transparentBridge false
set_interface_property xcvr_reconfig waitrequestAllowance 0
set_interface_property xcvr_reconfig writeWaitTime 0
set_interface_property xcvr_reconfig ENABLED true
set_interface_property xcvr_reconfig EXPORT_OF ""
set_interface_property xcvr_reconfig PORT_NAME_MAP ""
set_interface_property xcvr_reconfig CMSIS_SVD_VARIABLES ""
set_interface_property xcvr_reconfig SVD_ADDRESS_GROUP ""
set_interface_property xcvr_reconfig IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port xcvr_reconfig xcvr_reconfig_address address Input 19
add_interface_port xcvr_reconfig xcvr_reconfig_read read Input 1
add_interface_port xcvr_reconfig xcvr_reconfig_readdata readdata Output 8
add_interface_port xcvr_reconfig xcvr_reconfig_write write Input 1
add_interface_port xcvr_reconfig xcvr_reconfig_writedata writedata Input 8
add_interface_port xcvr_reconfig xcvr_reconfig_waitrequest waitrequest Output 1
set_interface_assignment xcvr_reconfig embeddedsw.configuration.isFlash 0
set_interface_assignment xcvr_reconfig embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment xcvr_reconfig embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment xcvr_reconfig embeddedsw.configuration.isPrintableDevice 0


#
# connection point i_xcvr_reconfig_address
#
add_interface i_xcvr_reconfig_address conduit end
set_interface_property i_xcvr_reconfig_address associatedClock ""
set_interface_property i_xcvr_reconfig_address associatedReset ""
set_interface_property i_xcvr_reconfig_address ENABLED true
set_interface_property i_xcvr_reconfig_address EXPORT_OF ""
set_interface_property i_xcvr_reconfig_address PORT_NAME_MAP ""
set_interface_property i_xcvr_reconfig_address CMSIS_SVD_VARIABLES ""
set_interface_property i_xcvr_reconfig_address SVD_ADDRESS_GROUP ""
set_interface_property i_xcvr_reconfig_address IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port i_xcvr_reconfig_address i_xcvr_reconfig_address i_xcvr_reconfig_address Output 19


#
# connection point i_xcvr_reconfig_write
#
add_interface i_xcvr_reconfig_write conduit end
set_interface_property i_xcvr_reconfig_write associatedClock ""
set_interface_property i_xcvr_reconfig_write associatedReset ""
set_interface_property i_xcvr_reconfig_write ENABLED true
set_interface_property i_xcvr_reconfig_write EXPORT_OF ""
set_interface_property i_xcvr_reconfig_write PORT_NAME_MAP ""
set_interface_property i_xcvr_reconfig_write CMSIS_SVD_VARIABLES ""
set_interface_property i_xcvr_reconfig_write SVD_ADDRESS_GROUP ""
set_interface_property i_xcvr_reconfig_write IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port i_xcvr_reconfig_write i_xcvr_reconfig_write i_xcvr_reconfig_write Output 1


#
# connection point i_xcvr_reconfig_read
#
add_interface i_xcvr_reconfig_read conduit end
set_interface_property i_xcvr_reconfig_read associatedClock ""
set_interface_property i_xcvr_reconfig_read associatedReset ""
set_interface_property i_xcvr_reconfig_read ENABLED true
set_interface_property i_xcvr_reconfig_read EXPORT_OF ""
set_interface_property i_xcvr_reconfig_read PORT_NAME_MAP ""
set_interface_property i_xcvr_reconfig_read CMSIS_SVD_VARIABLES ""
set_interface_property i_xcvr_reconfig_read SVD_ADDRESS_GROUP ""
set_interface_property i_xcvr_reconfig_read IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port i_xcvr_reconfig_read i_xcvr_reconfig_read i_xcvr_reconfig_read Output 1


#
# connection point i_xcvr_reconfig_writedata
#
add_interface i_xcvr_reconfig_writedata conduit end
set_interface_property i_xcvr_reconfig_writedata associatedClock ""
set_interface_property i_xcvr_reconfig_writedata associatedReset ""
set_interface_property i_xcvr_reconfig_writedata ENABLED true
set_interface_property i_xcvr_reconfig_writedata EXPORT_OF ""
set_interface_property i_xcvr_reconfig_writedata PORT_NAME_MAP ""
set_interface_property i_xcvr_reconfig_writedata CMSIS_SVD_VARIABLES ""
set_interface_property i_xcvr_reconfig_writedata SVD_ADDRESS_GROUP ""
set_interface_property i_xcvr_reconfig_writedata IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port i_xcvr_reconfig_writedata i_xcvr_reconfig_writedata i_xcvr_reconfig_writedata Output 8


#
# connection point o_xcvr_reconfig_readdata
#
add_interface o_xcvr_reconfig_readdata conduit end
set_interface_property o_xcvr_reconfig_readdata associatedClock ""
set_interface_property o_xcvr_reconfig_readdata associatedReset ""
set_interface_property o_xcvr_reconfig_readdata ENABLED true
set_interface_property o_xcvr_reconfig_readdata EXPORT_OF ""
set_interface_property o_xcvr_reconfig_readdata PORT_NAME_MAP ""
set_interface_property o_xcvr_reconfig_readdata CMSIS_SVD_VARIABLES ""
set_interface_property o_xcvr_reconfig_readdata SVD_ADDRESS_GROUP ""
set_interface_property o_xcvr_reconfig_readdata IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port o_xcvr_reconfig_readdata o_xcvr_reconfig_readdata o_xcvr_reconfig_readdata Input 8


#
# connection point o_xcvr_reconfig_waitrequest
#
add_interface o_xcvr_reconfig_waitrequest conduit end
set_interface_property o_xcvr_reconfig_waitrequest associatedClock ""
set_interface_property o_xcvr_reconfig_waitrequest associatedReset ""
set_interface_property o_xcvr_reconfig_waitrequest ENABLED true
set_interface_property o_xcvr_reconfig_waitrequest EXPORT_OF ""
set_interface_property o_xcvr_reconfig_waitrequest PORT_NAME_MAP ""
set_interface_property o_xcvr_reconfig_waitrequest CMSIS_SVD_VARIABLES ""
set_interface_property o_xcvr_reconfig_waitrequest SVD_ADDRESS_GROUP ""
set_interface_property o_xcvr_reconfig_waitrequest IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port o_xcvr_reconfig_waitrequest o_xcvr_reconfig_waitrequest o_xcvr_reconfig_waitrequest Input 1


#
# connection point i_eth_reconfig_addr
#
add_interface i_eth_reconfig_addr conduit end
set_interface_property i_eth_reconfig_addr associatedClock ""
set_interface_property i_eth_reconfig_addr associatedReset ""
set_interface_property i_eth_reconfig_addr ENABLED true
set_interface_property i_eth_reconfig_addr EXPORT_OF ""
set_interface_property i_eth_reconfig_addr PORT_NAME_MAP ""
set_interface_property i_eth_reconfig_addr CMSIS_SVD_VARIABLES ""
set_interface_property i_eth_reconfig_addr SVD_ADDRESS_GROUP ""
set_interface_property i_eth_reconfig_addr IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port i_eth_reconfig_addr i_eth_reconfig_addr i_eth_reconfig_addr Output 21


#
# connection point i_eth_reconfig_write
#
add_interface i_eth_reconfig_write conduit end
set_interface_property i_eth_reconfig_write associatedClock ""
set_interface_property i_eth_reconfig_write associatedReset ""
set_interface_property i_eth_reconfig_write ENABLED true
set_interface_property i_eth_reconfig_write EXPORT_OF ""
set_interface_property i_eth_reconfig_write PORT_NAME_MAP ""
set_interface_property i_eth_reconfig_write CMSIS_SVD_VARIABLES ""
set_interface_property i_eth_reconfig_write SVD_ADDRESS_GROUP ""
set_interface_property i_eth_reconfig_write IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port i_eth_reconfig_write i_eth_reconfig_write i_eth_reconfig_write Output 1


#
# connection point i_eth_reconfig_read
#
add_interface i_eth_reconfig_read conduit end
set_interface_property i_eth_reconfig_read associatedClock ""
set_interface_property i_eth_reconfig_read associatedReset ""
set_interface_property i_eth_reconfig_read ENABLED true
set_interface_property i_eth_reconfig_read EXPORT_OF ""
set_interface_property i_eth_reconfig_read PORT_NAME_MAP ""
set_interface_property i_eth_reconfig_read CMSIS_SVD_VARIABLES ""
set_interface_property i_eth_reconfig_read SVD_ADDRESS_GROUP ""
set_interface_property i_eth_reconfig_read IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port i_eth_reconfig_read i_eth_reconfig_read i_eth_reconfig_read Output 1


#
# connection point i_eth_reconfig_writedata
#
add_interface i_eth_reconfig_writedata conduit end
set_interface_property i_eth_reconfig_writedata associatedClock ""
set_interface_property i_eth_reconfig_writedata associatedReset ""
set_interface_property i_eth_reconfig_writedata ENABLED true
set_interface_property i_eth_reconfig_writedata EXPORT_OF ""
set_interface_property i_eth_reconfig_writedata PORT_NAME_MAP ""
set_interface_property i_eth_reconfig_writedata CMSIS_SVD_VARIABLES ""
set_interface_property i_eth_reconfig_writedata SVD_ADDRESS_GROUP ""
set_interface_property i_eth_reconfig_writedata IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port i_eth_reconfig_writedata i_eth_reconfig_writedata i_eth_reconfig_writedata Output 32


#
# connection point o_eth_reconfig_readdata
#
add_interface o_eth_reconfig_readdata conduit end
set_interface_property o_eth_reconfig_readdata associatedClock ""
set_interface_property o_eth_reconfig_readdata associatedReset ""
set_interface_property o_eth_reconfig_readdata ENABLED true
set_interface_property o_eth_reconfig_readdata EXPORT_OF ""
set_interface_property o_eth_reconfig_readdata PORT_NAME_MAP ""
set_interface_property o_eth_reconfig_readdata CMSIS_SVD_VARIABLES ""
set_interface_property o_eth_reconfig_readdata SVD_ADDRESS_GROUP ""
set_interface_property o_eth_reconfig_readdata IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port o_eth_reconfig_readdata o_eth_reconfig_readdata o_eth_reconfig_readdata Input 32


#
# connection point o_eth_reconfig_readdata_valid
#
add_interface o_eth_reconfig_readdata_valid conduit end
set_interface_property o_eth_reconfig_readdata_valid associatedClock ""
set_interface_property o_eth_reconfig_readdata_valid associatedReset ""
set_interface_property o_eth_reconfig_readdata_valid ENABLED true
set_interface_property o_eth_reconfig_readdata_valid EXPORT_OF ""
set_interface_property o_eth_reconfig_readdata_valid PORT_NAME_MAP ""
set_interface_property o_eth_reconfig_readdata_valid CMSIS_SVD_VARIABLES ""
set_interface_property o_eth_reconfig_readdata_valid SVD_ADDRESS_GROUP ""
set_interface_property o_eth_reconfig_readdata_valid IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port o_eth_reconfig_readdata_valid o_eth_reconfig_readdata_valid o_eth_reconfig_readdata_valid Input 1


#
# connection point o_eth_reconfig_waitrequest
#
add_interface o_eth_reconfig_waitrequest conduit end
set_interface_property o_eth_reconfig_waitrequest associatedClock ""
set_interface_property o_eth_reconfig_waitrequest associatedReset ""
set_interface_property o_eth_reconfig_waitrequest ENABLED true
set_interface_property o_eth_reconfig_waitrequest EXPORT_OF ""
set_interface_property o_eth_reconfig_waitrequest PORT_NAME_MAP ""
set_interface_property o_eth_reconfig_waitrequest CMSIS_SVD_VARIABLES ""
set_interface_property o_eth_reconfig_waitrequest SVD_ADDRESS_GROUP ""
set_interface_property o_eth_reconfig_waitrequest IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port o_eth_reconfig_waitrequest o_eth_reconfig_waitrequest o_eth_reconfig_waitrequest Input 1


#
# connection point sl_eth_reconfig
#
add_interface sl_eth_reconfig avalon end
set_interface_property sl_eth_reconfig addressGroup 0
set_interface_property sl_eth_reconfig addressUnits WORDS
set_interface_property sl_eth_reconfig associatedClock reconfig_clock
set_interface_property sl_eth_reconfig associatedReset reconfig_reset
set_interface_property sl_eth_reconfig bitsPerSymbol 8
set_interface_property sl_eth_reconfig bridgedAddressOffset 0
set_interface_property sl_eth_reconfig bridgesToMaster ""
set_interface_property sl_eth_reconfig burstOnBurstBoundariesOnly false
set_interface_property sl_eth_reconfig burstcountUnits WORDS
set_interface_property sl_eth_reconfig explicitAddressSpan 0
set_interface_property sl_eth_reconfig holdTime 0
set_interface_property sl_eth_reconfig linewrapBursts false
set_interface_property sl_eth_reconfig maximumPendingReadTransactions 1
set_interface_property sl_eth_reconfig maximumPendingWriteTransactions 0
set_interface_property sl_eth_reconfig minimumResponseLatency 1
set_interface_property sl_eth_reconfig readLatency 0
set_interface_property sl_eth_reconfig readWaitTime 1
set_interface_property sl_eth_reconfig setupTime 0
set_interface_property sl_eth_reconfig timingUnits Cycles
set_interface_property sl_eth_reconfig transparentBridge false
set_interface_property sl_eth_reconfig waitrequestAllowance 0
set_interface_property sl_eth_reconfig writeWaitTime 0
set_interface_property sl_eth_reconfig ENABLED true
set_interface_property sl_eth_reconfig EXPORT_OF ""
set_interface_property sl_eth_reconfig PORT_NAME_MAP ""
set_interface_property sl_eth_reconfig CMSIS_SVD_VARIABLES ""
set_interface_property sl_eth_reconfig SVD_ADDRESS_GROUP ""
set_interface_property sl_eth_reconfig IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port sl_eth_reconfig sl_eth_reconfig_address address Input 12
add_interface_port sl_eth_reconfig sl_eth_reconfig_read read Input 1
add_interface_port sl_eth_reconfig sl_eth_reconfig_readdata readdata Output 32
add_interface_port sl_eth_reconfig sl_eth_reconfig_readdatavalid readdatavalid Output 1
add_interface_port sl_eth_reconfig sl_eth_reconfig_write write Input 1
add_interface_port sl_eth_reconfig sl_eth_reconfig_writedata writedata Input 32
add_interface_port sl_eth_reconfig sl_eth_reconfig_waitrequest waitrequest Output 1
set_interface_assignment sl_eth_reconfig embeddedsw.configuration.isFlash 0
set_interface_assignment sl_eth_reconfig embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment sl_eth_reconfig embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment sl_eth_reconfig embeddedsw.configuration.isPrintableDevice 0


#
# connection point i_sl_eth_reconfig_addr
#
add_interface i_sl_eth_reconfig_addr conduit end
set_interface_property i_sl_eth_reconfig_addr associatedClock ""
set_interface_property i_sl_eth_reconfig_addr associatedReset ""
set_interface_property i_sl_eth_reconfig_addr ENABLED true
set_interface_property i_sl_eth_reconfig_addr EXPORT_OF ""
set_interface_property i_sl_eth_reconfig_addr PORT_NAME_MAP ""
set_interface_property i_sl_eth_reconfig_addr CMSIS_SVD_VARIABLES ""
set_interface_property i_sl_eth_reconfig_addr SVD_ADDRESS_GROUP ""
set_interface_property i_sl_eth_reconfig_addr IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port i_sl_eth_reconfig_addr i_sl_eth_reconfig_addr i_sl_eth_reconfig_addr Output 19


#
# connection point i_sl_eth_reconfig_read
#
add_interface i_sl_eth_reconfig_read conduit end
set_interface_property i_sl_eth_reconfig_read associatedClock ""
set_interface_property i_sl_eth_reconfig_read associatedReset ""
set_interface_property i_sl_eth_reconfig_read ENABLED true
set_interface_property i_sl_eth_reconfig_read EXPORT_OF ""
set_interface_property i_sl_eth_reconfig_read PORT_NAME_MAP ""
set_interface_property i_sl_eth_reconfig_read CMSIS_SVD_VARIABLES ""
set_interface_property i_sl_eth_reconfig_read SVD_ADDRESS_GROUP ""
set_interface_property i_sl_eth_reconfig_read IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port i_sl_eth_reconfig_read i_sl_eth_reconfig_read i_sl_eth_reconfig_read Output 1


#
# connection point i_sl_eth_reconfig_write
#
add_interface i_sl_eth_reconfig_write conduit end
set_interface_property i_sl_eth_reconfig_write associatedClock ""
set_interface_property i_sl_eth_reconfig_write associatedReset ""
set_interface_property i_sl_eth_reconfig_write ENABLED true
set_interface_property i_sl_eth_reconfig_write EXPORT_OF ""
set_interface_property i_sl_eth_reconfig_write PORT_NAME_MAP ""
set_interface_property i_sl_eth_reconfig_write CMSIS_SVD_VARIABLES ""
set_interface_property i_sl_eth_reconfig_write SVD_ADDRESS_GROUP ""
set_interface_property i_sl_eth_reconfig_write IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port i_sl_eth_reconfig_write i_sl_eth_reconfig_write i_sl_eth_reconfig_write Output 1


#
# connection point o_sl_eth_reconfig_readdata
#
add_interface o_sl_eth_reconfig_readdata conduit end
set_interface_property o_sl_eth_reconfig_readdata associatedClock ""
set_interface_property o_sl_eth_reconfig_readdata associatedReset ""
set_interface_property o_sl_eth_reconfig_readdata ENABLED true
set_interface_property o_sl_eth_reconfig_readdata EXPORT_OF ""
set_interface_property o_sl_eth_reconfig_readdata PORT_NAME_MAP ""
set_interface_property o_sl_eth_reconfig_readdata CMSIS_SVD_VARIABLES ""
set_interface_property o_sl_eth_reconfig_readdata SVD_ADDRESS_GROUP ""
set_interface_property o_sl_eth_reconfig_readdata IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port o_sl_eth_reconfig_readdata o_sl_eth_reconfig_readdata o_sl_eth_reconfig_readdata Input 32


#
# connection point o_sl_eth_reconfig_readdata_valid
#
add_interface o_sl_eth_reconfig_readdata_valid conduit end
set_interface_property o_sl_eth_reconfig_readdata_valid associatedClock ""
set_interface_property o_sl_eth_reconfig_readdata_valid associatedReset ""
set_interface_property o_sl_eth_reconfig_readdata_valid ENABLED true
set_interface_property o_sl_eth_reconfig_readdata_valid EXPORT_OF ""
set_interface_property o_sl_eth_reconfig_readdata_valid PORT_NAME_MAP ""
set_interface_property o_sl_eth_reconfig_readdata_valid CMSIS_SVD_VARIABLES ""
set_interface_property o_sl_eth_reconfig_readdata_valid SVD_ADDRESS_GROUP ""
set_interface_property o_sl_eth_reconfig_readdata_valid IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port o_sl_eth_reconfig_readdata_valid o_sl_eth_reconfig_readdata_valid o_sl_eth_reconfig_readdata_valid Input 1


#
# connection point i_sl_eth_reconfig_writedata
#
add_interface i_sl_eth_reconfig_writedata conduit end
set_interface_property i_sl_eth_reconfig_writedata associatedClock ""
set_interface_property i_sl_eth_reconfig_writedata associatedReset ""
set_interface_property i_sl_eth_reconfig_writedata ENABLED true
set_interface_property i_sl_eth_reconfig_writedata EXPORT_OF ""
set_interface_property i_sl_eth_reconfig_writedata PORT_NAME_MAP ""
set_interface_property i_sl_eth_reconfig_writedata CMSIS_SVD_VARIABLES ""
set_interface_property i_sl_eth_reconfig_writedata SVD_ADDRESS_GROUP ""
set_interface_property i_sl_eth_reconfig_writedata IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port i_sl_eth_reconfig_writedata i_sl_eth_reconfig_writedata i_sl_eth_reconfig_writedata Output 32


#
# connection point o_sl_eth_reconfig_waitrequest
#
add_interface o_sl_eth_reconfig_waitrequest conduit end
set_interface_property o_sl_eth_reconfig_waitrequest associatedClock ""
set_interface_property o_sl_eth_reconfig_waitrequest associatedReset ""
set_interface_property o_sl_eth_reconfig_waitrequest ENABLED true
set_interface_property o_sl_eth_reconfig_waitrequest EXPORT_OF ""
set_interface_property o_sl_eth_reconfig_waitrequest PORT_NAME_MAP ""
set_interface_property o_sl_eth_reconfig_waitrequest CMSIS_SVD_VARIABLES ""
set_interface_property o_sl_eth_reconfig_waitrequest SVD_ADDRESS_GROUP ""
set_interface_property o_sl_eth_reconfig_waitrequest IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port o_sl_eth_reconfig_waitrequest o_sl_eth_reconfig_waitrequest o_sl_eth_reconfig_waitrequest Input 1


#
# connection point i_sl_stats_snapshot
#
add_interface i_sl_stats_snapshot conduit end
set_interface_property i_sl_stats_snapshot associatedClock ""
set_interface_property i_sl_stats_snapshot associatedReset ""
set_interface_property i_sl_stats_snapshot ENABLED true
set_interface_property i_sl_stats_snapshot EXPORT_OF ""
set_interface_property i_sl_stats_snapshot PORT_NAME_MAP ""
set_interface_property i_sl_stats_snapshot CMSIS_SVD_VARIABLES ""
set_interface_property i_sl_stats_snapshot SVD_ADDRESS_GROUP ""
set_interface_property i_sl_stats_snapshot IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port i_sl_stats_snapshot i_sl_stats_snapshot i_sl_stats_snapshot Output 1


#
# connection point sl_tx_avst
#
add_interface sl_tx_avst avalon_streaming end
set_interface_property sl_tx_avst associatedClock sl_clk_tx
set_interface_property sl_tx_avst associatedReset sl_rst_tx
set_interface_property sl_tx_avst dataBitsPerSymbol 8
set_interface_property sl_tx_avst errorDescriptor ""
set_interface_property sl_tx_avst firstSymbolInHighOrderBits true
set_interface_property sl_tx_avst maxChannel 0
set_interface_property sl_tx_avst readyAllowance 0
set_interface_property sl_tx_avst readyLatency 0
set_interface_property sl_tx_avst ENABLED true
set_interface_property sl_tx_avst EXPORT_OF true
set_interface_property sl_tx_avst PORT_NAME_MAP ""
set_interface_property sl_tx_avst CMSIS_SVD_VARIABLES ""
set_interface_property sl_tx_avst SVD_ADDRESS_GROUP ""
set_interface_property sl_tx_avst IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port sl_tx_avst tx_avst_ready ready Output 1
add_interface_port sl_tx_avst tx_avst_valid valid Input 1
add_interface_port sl_tx_avst tx_avst_data data Input 64
add_interface_port sl_tx_avst tx_avst_startofpacket startofpacket Input 1
add_interface_port sl_tx_avst tx_avst_endofpacket endofpacket Input 1
add_interface_port sl_tx_avst tx_avst_empty empty Input 3
add_interface_port sl_tx_avst tx_avst_error error Input 1


#
# connection point sl_rx_avst
#
add_interface sl_rx_avst avalon_streaming start
set_interface_property sl_rx_avst associatedClock sl_clk_rx
set_interface_property sl_rx_avst associatedReset sl_rst_rx
set_interface_property sl_rx_avst dataBitsPerSymbol 8
set_interface_property sl_rx_avst errorDescriptor ""
set_interface_property sl_rx_avst firstSymbolInHighOrderBits true
set_interface_property sl_rx_avst maxChannel 0
set_interface_property sl_rx_avst readyAllowance 0
set_interface_property sl_rx_avst readyLatency 0
set_interface_property sl_rx_avst ENABLED true
set_interface_property sl_rx_avst EXPORT_OF true
set_interface_property sl_rx_avst PORT_NAME_MAP ""
set_interface_property sl_rx_avst CMSIS_SVD_VARIABLES ""
set_interface_property sl_rx_avst SVD_ADDRESS_GROUP ""
set_interface_property sl_rx_avst IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port sl_rx_avst rx_avst_ready ready Input 1
add_interface_port sl_rx_avst rx_avst_valid valid Output 1
add_interface_port sl_rx_avst rx_avst_data data Output 64
add_interface_port sl_rx_avst rx_avst_startofpacket startofpacket Output 1
add_interface_port sl_rx_avst rx_avst_endofpacket endofpacket Output 1
add_interface_port sl_rx_avst rx_avst_empty empty Output 3
add_interface_port sl_rx_avst rx_avst_error error Output 6


#
# connection point sl_nonpcs_ports
#
add_interface sl_nonpcs_ports conduit end
set_interface_property sl_nonpcs_ports associatedClock ""
set_interface_property sl_nonpcs_ports associatedReset ""
set_interface_property sl_nonpcs_ports ENABLED true
set_interface_property sl_nonpcs_ports EXPORT_OF ""
set_interface_property sl_nonpcs_ports PORT_NAME_MAP ""
set_interface_property sl_nonpcs_ports CMSIS_SVD_VARIABLES ""
set_interface_property sl_nonpcs_ports SVD_ADDRESS_GROUP ""
set_interface_property sl_nonpcs_ports IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port sl_nonpcs_ports i_sl_tx_data i_sl_tx_data Output 64
add_interface_port sl_nonpcs_ports i_sl_tx_empty i_sl_tx_empty Output 3
add_interface_port sl_nonpcs_ports i_sl_tx_endofpacket i_sl_tx_endofpacket Output 1
add_interface_port sl_nonpcs_ports i_sl_tx_error i_sl_tx_error Output 1
add_interface_port sl_nonpcs_ports i_sl_tx_skip_crc i_sl_tx_skip_crc Output 1
add_interface_port sl_nonpcs_ports i_sl_tx_startofpacket i_sl_tx_startofpacket Output 1
add_interface_port sl_nonpcs_ports i_sl_tx_valid i_sl_tx_valid Output 1
add_interface_port sl_nonpcs_ports o_sl_rx_data o_sl_rx_data Input 64
add_interface_port sl_nonpcs_ports o_sl_rx_empty o_sl_rx_empty Input 3
add_interface_port sl_nonpcs_ports o_sl_rx_endofpacket o_sl_rx_endofpacket Input 1
add_interface_port sl_nonpcs_ports o_sl_rx_error o_sl_rx_error Input 6
add_interface_port sl_nonpcs_ports o_sl_rx_startofpacket o_sl_rx_startofpacket Input 1
add_interface_port sl_nonpcs_ports o_sl_rx_valid o_sl_rx_valid Input 1
add_interface_port sl_nonpcs_ports o_sl_rxstatus_data o_sl_rxstatus_data Input 40
add_interface_port sl_nonpcs_ports o_sl_rxstatus_valid o_sl_rxstatus_valid Input 1
add_interface_port sl_nonpcs_ports o_sl_tx_ready o_sl_tx_ready Input 1


#
# connection point sl_pfc_ports
#
add_interface sl_pfc_ports conduit end
set_interface_property sl_pfc_ports associatedClock ""
set_interface_property sl_pfc_ports associatedReset ""
set_interface_property sl_pfc_ports ENABLED true
set_interface_property sl_pfc_ports EXPORT_OF ""
set_interface_property sl_pfc_ports PORT_NAME_MAP ""
set_interface_property sl_pfc_ports CMSIS_SVD_VARIABLES ""
set_interface_property sl_pfc_ports SVD_ADDRESS_GROUP ""
set_interface_property sl_pfc_ports IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port sl_pfc_ports i_sl_tx_pfc i_sl_tx_pfc Output 8
add_interface_port sl_pfc_ports o_sl_rx_pfc o_sl_rx_pfc Input 8


#
# connection point ptp_tod_ports_1p5ns
#
add_interface ptp_tod_ports_1p5ns_tx avalon_streaming source
set_interface_property ptp_tod_ports_1p5ns_tx associatedClock ""
set_interface_property ptp_tod_ports_1p5ns_tx associatedReset ""
set_interface_property ptp_tod_ports_1p5ns_tx ENABLED true
set_interface_property ptp_tod_ports_1p5ns_tx EXPORT_OF ""
set_interface_property ptp_tod_ports_1p5ns_tx PORT_NAME_MAP ""
set_interface_property ptp_tod_ports_1p5ns_tx CMSIS_SVD_VARIABLES ""
set_interface_property ptp_tod_ports_1p5ns_tx SVD_ADDRESS_GROUP ""
set_interface_property ptp_tod_ports_1p5ns_tx IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port ptp_tod_ports_1p5ns_tx i_sl_ptp_tx_tod data Output 96

add_interface ptp_tod_ports_1p5ns_rx avalon_streaming source
set_interface_property ptp_tod_ports_1p5ns_rx associatedClock ""
set_interface_property ptp_tod_ports_1p5ns_rx associatedReset ""
set_interface_property ptp_tod_ports_1p5ns_rx ENABLED true
set_interface_property ptp_tod_ports_1p5ns_rx EXPORT_OF ""
set_interface_property ptp_tod_ports_1p5ns_rx PORT_NAME_MAP ""
set_interface_property ptp_tod_ports_1p5ns_rx CMSIS_SVD_VARIABLES ""
set_interface_property ptp_tod_ports_1p5ns_rx SVD_ADDRESS_GROUP ""

add_interface_port ptp_tod_ports_1p5ns_rx i_sl_ptp_rx_tod data Output 96


#
# connection point sl_ptp_ports_1p5ns
#
add_interface sl_ptp_ports_1p5ns conduit end
set_interface_property sl_ptp_ports_1p5ns associatedClock ""
set_interface_property sl_ptp_ports_1p5ns associatedReset ""
set_interface_property sl_ptp_ports_1p5ns ENABLED true
set_interface_property sl_ptp_ports_1p5ns EXPORT_OF ""
set_interface_property sl_ptp_ports_1p5ns PORT_NAME_MAP ""
set_interface_property sl_ptp_ports_1p5ns CMSIS_SVD_VARIABLES ""
set_interface_property sl_ptp_ports_1p5ns SVD_ADDRESS_GROUP ""
set_interface_property sl_ptp_ports_1p5ns IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port sl_ptp_ports_1p5ns i_clk_ptp_sample i_clk_ptp_sample Output 1


#
# connection point sl_ptp_tx_tod
#
add_interface sl_ptp_tx_tod avalon_streaming sink 
set_interface_property sl_ptp_tx_tod associatedClock ""
set_interface_property sl_ptp_tx_tod associatedReset ""
set_interface_property sl_ptp_tx_tod ENABLED true
set_interface_property sl_ptp_tx_tod EXPORT_OF ""
set_interface_property sl_ptp_tx_tod PORT_NAME_MAP ""
set_interface_property sl_ptp_tx_tod CMSIS_SVD_VARIABLES ""
set_interface_property sl_ptp_tx_tod SVD_ADDRESS_GROUP ""
set_interface_property sl_ptp_tx_tod IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port sl_ptp_tx_tod sl_ptp_tx_tod data Input 96


#
# connection point sl_ptp_rx_tod
#
add_interface sl_ptp_rx_tod avalon_streaming sink
set_interface_property sl_ptp_rx_tod associatedClock ""
set_interface_property sl_ptp_rx_tod associatedReset ""
set_interface_property sl_ptp_rx_tod ENABLED true
set_interface_property sl_ptp_rx_tod EXPORT_OF ""
set_interface_property sl_ptp_rx_tod PORT_NAME_MAP ""
set_interface_property sl_ptp_rx_tod CMSIS_SVD_VARIABLES ""
set_interface_property sl_ptp_rx_tod SVD_ADDRESS_GROUP ""
set_interface_property sl_ptp_rx_tod IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port sl_ptp_rx_tod sl_ptp_rx_tod data Input 96


#
# connection point sl_ptp_ports
#
add_interface sl_ptp_ports conduit end
set_interface_property sl_ptp_ports associatedClock ""
set_interface_property sl_ptp_ports associatedReset ""
set_interface_property sl_ptp_ports ENABLED true
set_interface_property sl_ptp_ports EXPORT_OF ""
set_interface_property sl_ptp_ports PORT_NAME_MAP ""
set_interface_property sl_ptp_ports CMSIS_SVD_VARIABLES ""
set_interface_property sl_ptp_ports SVD_ADDRESS_GROUP ""
set_interface_property sl_ptp_ports IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port sl_ptp_ports i_sl_ptp_fp i_sl_ptp_fp Output 8
add_interface_port sl_ptp_ports i_sl_ptp_ts_req i_sl_ptp_ts_req Output 1
add_interface_port sl_ptp_ports o_sl_ptp_ets o_sl_ptp_ets Input 96
add_interface_port sl_ptp_ports o_sl_ptp_ets_fp o_sl_ptp_ets_fp Input 8
add_interface_port sl_ptp_ports o_sl_ptp_ets_valid o_sl_ptp_ets_valid Input 1
add_interface_port sl_ptp_ports o_sl_ptp_rx_its o_sl_ptp_rx_its Input 96
add_interface_port sl_ptp_ports o_sl_rx_ptp_ready o_sl_rx_ptp_ready Input 1
add_interface_port sl_ptp_ports o_sl_tx_ptp_ready o_sl_tx_ptp_ready Input 1


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
set_interface_property timestamp_request IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port timestamp_request tstamp_req_valid valid Input 1
add_interface_port timestamp_request tstamp_req_fingerprint fingerprint Input 8


#
# connection point tx_timestamp
#
add_interface tx_timestamp conduit end
set_interface_property tx_timestamp associatedClock ""
set_interface_property tx_timestamp associatedReset ""
set_interface_property tx_timestamp ENABLED true
set_interface_property tx_timestamp EXPORT_OF ""
set_interface_property tx_timestamp PORT_NAME_MAP ""
set_interface_property tx_timestamp CMSIS_SVD_VARIABLES ""
set_interface_property tx_timestamp SVD_ADDRESS_GROUP ""
set_interface_property tx_timestamp IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port tx_timestamp tx_timestamp_fp_valid valid Output 1
add_interface_port tx_timestamp tx_timestamp_fp_data data Output 96
add_interface_port tx_timestamp tx_timestamp_fp_fingerprint fingerprint Output 8


#
# connection point rx_timestamp
#
add_interface rx_timestamp conduit end
set_interface_property rx_timestamp associatedClock ""
set_interface_property rx_timestamp associatedReset ""
set_interface_property rx_timestamp ENABLED true
set_interface_property rx_timestamp EXPORT_OF ""
set_interface_property rx_timestamp PORT_NAME_MAP ""
set_interface_property rx_timestamp CMSIS_SVD_VARIABLES ""
set_interface_property rx_timestamp SVD_ADDRESS_GROUP ""
set_interface_property rx_timestamp IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port rx_timestamp rx_timestamp_valid valid Output 1
add_interface_port rx_timestamp rx_timestamp_data data Output 96


#
# connection point sl_ptp_1step_ports
#
add_interface sl_ptp_1step_ports conduit end
set_interface_property sl_ptp_1step_ports associatedClock ""
set_interface_property sl_ptp_1step_ports associatedReset ""
set_interface_property sl_ptp_1step_ports ENABLED true
set_interface_property sl_ptp_1step_ports EXPORT_OF ""
set_interface_property sl_ptp_1step_ports PORT_NAME_MAP ""
set_interface_property sl_ptp_1step_ports CMSIS_SVD_VARIABLES ""
set_interface_property sl_ptp_1step_ports SVD_ADDRESS_GROUP ""
set_interface_property sl_ptp_1step_ports IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port sl_ptp_1step_ports i_sl_ptp_cf_offset i_sl_ptp_cf_offset Output 16
add_interface_port sl_ptp_1step_ports i_sl_ptp_csum_offset i_sl_ptp_csum_offset Output 16
add_interface_port sl_ptp_1step_ports i_sl_ptp_eb_offset i_sl_ptp_eb_offset Output 16
add_interface_port sl_ptp_1step_ports i_sl_ptp_ins_cf i_sl_ptp_ins_cf Output 1
add_interface_port sl_ptp_1step_ports i_sl_ptp_ins_ets i_sl_ptp_ins_ets Output 1
add_interface_port sl_ptp_1step_ports i_sl_ptp_ts_format i_sl_ptp_ts_format Output 1
add_interface_port sl_ptp_1step_ports i_sl_ptp_ts_offset i_sl_ptp_ts_offset Output 16
add_interface_port sl_ptp_1step_ports i_sl_ptp_tx_its i_sl_ptp_tx_its Output 96
add_interface_port sl_ptp_1step_ports i_sl_ptp_update_eb i_sl_ptp_update_eb Output 1
add_interface_port sl_ptp_1step_ports i_sl_ptp_zero_csum i_sl_ptp_zero_csum Output 1


#
# connection point o_cdr_lock
#
add_interface o_cdr_lock conduit end
set_interface_property o_cdr_lock associatedClock ""
set_interface_property o_cdr_lock associatedReset ""
set_interface_property o_cdr_lock ENABLED true
set_interface_property o_cdr_lock EXPORT_OF ""
set_interface_property o_cdr_lock PORT_NAME_MAP ""
set_interface_property o_cdr_lock CMSIS_SVD_VARIABLES ""
set_interface_property o_cdr_lock SVD_ADDRESS_GROUP ""
set_interface_property o_cdr_lock IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port o_cdr_lock o_cdr_lock o_cdr_lock Input 1


#
# connection point o_tx_pll_locked
#
add_interface o_tx_pll_locked conduit end
set_interface_property o_tx_pll_locked associatedClock ""
set_interface_property o_tx_pll_locked associatedReset ""
set_interface_property o_tx_pll_locked ENABLED true
set_interface_property o_tx_pll_locked EXPORT_OF ""
set_interface_property o_tx_pll_locked PORT_NAME_MAP ""
set_interface_property o_tx_pll_locked CMSIS_SVD_VARIABLES ""
set_interface_property o_tx_pll_locked SVD_ADDRESS_GROUP ""
set_interface_property o_tx_pll_locked IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port o_tx_pll_locked o_tx_pll_locked o_tx_pll_locked Input 1


#
# connection point o_sl_tx_lanes_stable
#
add_interface o_sl_tx_lanes_stable conduit end
set_interface_property o_sl_tx_lanes_stable associatedClock ""
set_interface_property o_sl_tx_lanes_stable associatedReset ""
set_interface_property o_sl_tx_lanes_stable ENABLED true
set_interface_property o_sl_tx_lanes_stable EXPORT_OF ""
set_interface_property o_sl_tx_lanes_stable PORT_NAME_MAP ""
set_interface_property o_sl_tx_lanes_stable CMSIS_SVD_VARIABLES ""
set_interface_property o_sl_tx_lanes_stable SVD_ADDRESS_GROUP ""
set_interface_property o_sl_tx_lanes_stable IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port o_sl_tx_lanes_stable o_sl_tx_lanes_stable o_sl_tx_lanes_stable Input 1


#
# connection point sl_tx_lanes_stable_reset_n
#
add_interface sl_tx_lanes_stable_reset_n reset start
set_interface_property sl_tx_lanes_stable_reset_n associatedClock ""
set_interface_property sl_tx_lanes_stable_reset_n associatedDirectReset ""
set_interface_property sl_tx_lanes_stable_reset_n associatedResetSinks ""
set_interface_property sl_tx_lanes_stable_reset_n synchronousEdges NONE
set_interface_property sl_tx_lanes_stable_reset_n ENABLED true
set_interface_property sl_tx_lanes_stable_reset_n EXPORT_OF ""
set_interface_property sl_tx_lanes_stable_reset_n PORT_NAME_MAP ""
set_interface_property sl_tx_lanes_stable_reset_n CMSIS_SVD_VARIABLES ""
set_interface_property sl_tx_lanes_stable_reset_n SVD_ADDRESS_GROUP ""
set_interface_property sl_tx_lanes_stable_reset_n IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port sl_tx_lanes_stable_reset_n sl_tx_lanes_stable_reset_n reset_n Output 1


#
# connection point sl_rx_pcs_ready_reset_n
#
add_interface sl_rx_pcs_ready_reset_n reset start
set_interface_property sl_rx_pcs_ready_reset_n associatedClock ""
set_interface_property sl_rx_pcs_ready_reset_n associatedDirectReset ""
set_interface_property sl_rx_pcs_ready_reset_n associatedResetSinks ""
set_interface_property sl_rx_pcs_ready_reset_n synchronousEdges NONE
set_interface_property sl_rx_pcs_ready_reset_n ENABLED true
set_interface_property sl_rx_pcs_ready_reset_n EXPORT_OF ""
set_interface_property sl_rx_pcs_ready_reset_n PORT_NAME_MAP ""
set_interface_property sl_rx_pcs_ready_reset_n CMSIS_SVD_VARIABLES ""
set_interface_property sl_rx_pcs_ready_reset_n SVD_ADDRESS_GROUP ""
set_interface_property sl_rx_pcs_ready_reset_n IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port sl_rx_pcs_ready_reset_n sl_rx_pcs_ready_reset_n reset_n Output 1


#
# connection point o_sl_rx_pcs_ready
#
add_interface o_sl_rx_pcs_ready conduit end
set_interface_property o_sl_rx_pcs_ready associatedClock ""
set_interface_property o_sl_rx_pcs_ready associatedReset ""
set_interface_property o_sl_rx_pcs_ready ENABLED true
set_interface_property o_sl_rx_pcs_ready EXPORT_OF ""
set_interface_property o_sl_rx_pcs_ready PORT_NAME_MAP ""
set_interface_property o_sl_rx_pcs_ready CMSIS_SVD_VARIABLES ""
set_interface_property o_sl_rx_pcs_ready SVD_ADDRESS_GROUP ""
set_interface_property o_sl_rx_pcs_ready IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port o_sl_rx_pcs_ready o_sl_rx_pcs_ready o_sl_rx_pcs_ready Input 1


#
# connection point o_sl_ehip_ready
#
add_interface o_sl_ehip_ready conduit end
set_interface_property o_sl_ehip_ready associatedClock ""
set_interface_property o_sl_ehip_ready associatedReset ""
set_interface_property o_sl_ehip_ready ENABLED true
set_interface_property o_sl_ehip_ready EXPORT_OF ""
set_interface_property o_sl_ehip_ready PORT_NAME_MAP ""
set_interface_property o_sl_ehip_ready CMSIS_SVD_VARIABLES ""
set_interface_property o_sl_ehip_ready SVD_ADDRESS_GROUP ""
set_interface_property o_sl_ehip_ready IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port o_sl_ehip_ready o_sl_ehip_ready o_sl_ehip_ready Input 1


#
# connection point o_sl_rx_block_lock
#
add_interface o_sl_rx_block_lock conduit end
set_interface_property o_sl_rx_block_lock associatedClock ""
set_interface_property o_sl_rx_block_lock associatedReset ""
set_interface_property o_sl_rx_block_lock ENABLED true
set_interface_property o_sl_rx_block_lock EXPORT_OF ""
set_interface_property o_sl_rx_block_lock PORT_NAME_MAP ""
set_interface_property o_sl_rx_block_lock CMSIS_SVD_VARIABLES ""
set_interface_property o_sl_rx_block_lock SVD_ADDRESS_GROUP ""
set_interface_property o_sl_rx_block_lock IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port o_sl_rx_block_lock o_sl_rx_block_lock o_sl_rx_block_lock Input 1


#
# connection point o_sl_local_fault_status
#
add_interface o_sl_local_fault_status conduit end
set_interface_property o_sl_local_fault_status associatedClock ""
set_interface_property o_sl_local_fault_status associatedReset ""
set_interface_property o_sl_local_fault_status ENABLED true
set_interface_property o_sl_local_fault_status EXPORT_OF ""
set_interface_property o_sl_local_fault_status PORT_NAME_MAP ""
set_interface_property o_sl_local_fault_status CMSIS_SVD_VARIABLES ""
set_interface_property o_sl_local_fault_status SVD_ADDRESS_GROUP ""
set_interface_property o_sl_local_fault_status IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port o_sl_local_fault_status o_sl_local_fault_status o_sl_local_fault_status Input 1


#
# connection point o_sl_remote_fault_status
#
add_interface o_sl_remote_fault_status conduit end
set_interface_property o_sl_remote_fault_status associatedClock ""
set_interface_property o_sl_remote_fault_status associatedReset ""
set_interface_property o_sl_remote_fault_status ENABLED true
set_interface_property o_sl_remote_fault_status EXPORT_OF ""
set_interface_property o_sl_remote_fault_status PORT_NAME_MAP ""
set_interface_property o_sl_remote_fault_status CMSIS_SVD_VARIABLES ""
set_interface_property o_sl_remote_fault_status SVD_ADDRESS_GROUP ""
set_interface_property o_sl_remote_fault_status IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port o_sl_remote_fault_status o_sl_remote_fault_status o_sl_remote_fault_status Input 1


#
# connection point iopll_clk_dma_locked
#
add_interface iopll_clk_dma_locked conduit end
set_interface_property iopll_clk_dma_locked associatedClock ""
set_interface_property iopll_clk_dma_locked associatedReset ""
set_interface_property iopll_clk_dma_locked ENABLED true
set_interface_property iopll_clk_dma_locked EXPORT_OF ""
set_interface_property iopll_clk_dma_locked PORT_NAME_MAP ""
set_interface_property iopll_clk_dma_locked CMSIS_SVD_VARIABLES ""
set_interface_property iopll_clk_dma_locked SVD_ADDRESS_GROUP ""
set_interface_property iopll_clk_dma_locked IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port iopll_clk_dma_locked iopll_clk_dma_locked export Input 1


#
# connection point ehip_debug_status
#
add_interface ehip_debug_status conduit end
set_interface_property ehip_debug_status associatedClock ""
set_interface_property ehip_debug_status associatedReset ""
set_interface_property ehip_debug_status ENABLED true
set_interface_property ehip_debug_status EXPORT_OF ""
set_interface_property ehip_debug_status PORT_NAME_MAP ""
set_interface_property ehip_debug_status CMSIS_SVD_VARIABLES ""
set_interface_property ehip_debug_status SVD_ADDRESS_GROUP ""
set_interface_property ehip_debug_status IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port ehip_debug_status ehip_debug_status export Output 13


#
# connection point tx_pll_locked_reset
#
add_interface tx_pll_locked_reset reset start
set_interface_property tx_pll_locked_reset associatedClock clk_pll_div64
set_interface_property tx_pll_locked_reset associatedDirectReset ""
set_interface_property tx_pll_locked_reset associatedResetSinks ""
set_interface_property tx_pll_locked_reset synchronousEdges DEASSERT
set_interface_property tx_pll_locked_reset ENABLED true
set_interface_property tx_pll_locked_reset EXPORT_OF ""
set_interface_property tx_pll_locked_reset PORT_NAME_MAP ""
set_interface_property tx_pll_locked_reset CMSIS_SVD_VARIABLES ""
set_interface_property tx_pll_locked_reset SVD_ADDRESS_GROUP ""
set_interface_property tx_pll_locked_reset IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port tx_pll_locked_reset tx_pll_locked_reset_n reset_n Output 1

#
# connection point dma_clock
#
add_interface dma_clock clock end
set_interface_property dma_clock ENABLED true
set_interface_property dma_clock EXPORT_OF ""
set_interface_property dma_clock PORT_NAME_MAP ""
set_interface_property dma_clock CMSIS_SVD_VARIABLES ""
set_interface_property dma_clock SVD_ADDRESS_GROUP ""
set_interface_property dma_clock IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port dma_clock dma_clock clk Input 1

#
# connection point clk_dma_lock_reset
#
add_interface clk_dma_lock_reset reset start
set_interface_property clk_dma_lock_reset associatedClock dma_clock
set_interface_property clk_dma_lock_reset associatedDirectReset ""
set_interface_property clk_dma_lock_reset associatedResetSinks ""
set_interface_property clk_dma_lock_reset synchronousEdges DEASSERT
set_interface_property clk_dma_lock_reset ENABLED true
set_interface_property clk_dma_lock_reset EXPORT_OF ""
set_interface_property clk_dma_lock_reset PORT_NAME_MAP ""
set_interface_property clk_dma_lock_reset CMSIS_SVD_VARIABLES ""
set_interface_property clk_dma_lock_reset SVD_ADDRESS_GROUP ""
set_interface_property clk_dma_lock_reset IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port clk_dma_lock_reset clk_dma_lock_reset_n reset_n Output 1


#
# connection point ptp_sampling_clk_iopll_locked
#
add_interface ptp_sampling_clk_iopll_locked conduit end
set_interface_property ptp_sampling_clk_iopll_locked associatedClock ""
set_interface_property ptp_sampling_clk_iopll_locked associatedReset ""
set_interface_property ptp_sampling_clk_iopll_locked ENABLED true
set_interface_property ptp_sampling_clk_iopll_locked EXPORT_OF ""
set_interface_property ptp_sampling_clk_iopll_locked PORT_NAME_MAP ""
set_interface_property ptp_sampling_clk_iopll_locked CMSIS_SVD_VARIABLES ""
set_interface_property ptp_sampling_clk_iopll_locked SVD_ADDRESS_GROUP ""
set_interface_property ptp_sampling_clk_iopll_locked IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port ptp_sampling_clk_iopll_locked ptp_sampling_clk_iopll_locked export Input 1


#
# connection point tod_sync_sampling_25gbe_clk_iopll_locked
#
add_interface tod_sync_sampling_25gbe_clk_iopll_locked conduit end
set_interface_property tod_sync_sampling_25gbe_clk_iopll_locked associatedClock ""
set_interface_property tod_sync_sampling_25gbe_clk_iopll_locked associatedReset ""
set_interface_property tod_sync_sampling_25gbe_clk_iopll_locked ENABLED true
set_interface_property tod_sync_sampling_25gbe_clk_iopll_locked EXPORT_OF ""
set_interface_property tod_sync_sampling_25gbe_clk_iopll_locked PORT_NAME_MAP ""
set_interface_property tod_sync_sampling_25gbe_clk_iopll_locked CMSIS_SVD_VARIABLES ""
set_interface_property tod_sync_sampling_25gbe_clk_iopll_locked SVD_ADDRESS_GROUP ""
set_interface_property tod_sync_sampling_25gbe_clk_iopll_locked IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port tod_sync_sampling_25gbe_clk_iopll_locked tod_sync_sampling_25gbe_clk_iopll_locked export Input 1

#
# connection point tod_sync_sampling_10gbe_clk_iopll_locked
#
add_interface tod_sync_sampling_10gbe_clk_iopll_locked conduit end
set_interface_property tod_sync_sampling_10gbe_clk_iopll_locked associatedClock ""
set_interface_property tod_sync_sampling_10gbe_clk_iopll_locked associatedReset ""
set_interface_property tod_sync_sampling_10gbe_clk_iopll_locked ENABLED true
set_interface_property tod_sync_sampling_10gbe_clk_iopll_locked EXPORT_OF ""
set_interface_property tod_sync_sampling_10gbe_clk_iopll_locked PORT_NAME_MAP ""
set_interface_property tod_sync_sampling_10gbe_clk_iopll_locked CMSIS_SVD_VARIABLES ""
set_interface_property tod_sync_sampling_10gbe_clk_iopll_locked SVD_ADDRESS_GROUP ""
set_interface_property tod_sync_sampling_10gbe_clk_iopll_locked IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port tod_sync_sampling_10gbe_clk_iopll_locked tod_sync_sampling_10gbe_clk_iopll_locked export Input 1


proc elaborate {} {
   set eth_25g_en [get_parameter_value eth_25gbe_en]
   set eth_10g_en [get_parameter_value eth_10gbe_en]
   
   if {$eth_25g_en == 0} {
      set_port_property tod_sync_sampling_25gbe_clk_iopll_locked termination true
      set_port_property tod_sync_sampling_25gbe_clk_iopll_locked termination_value 1
   } else {
      set_port_property tod_sync_sampling_25gbe_clk_iopll_locked termination false
   }

  if {$eth_10g_en == 0} {
      set_port_property tod_sync_sampling_10gbe_clk_iopll_locked termination true
      set_port_property tod_sync_sampling_10gbe_clk_iopll_locked termination_value 1
   } else {
      set_port_property tod_sync_sampling_10gbe_clk_iopll_locked termination false
   }
   
   if {$eth_25g_en == 1 || $eth_10g_en == 1} {
      set_port_property i_eth_reconfig_addr termination true
      set_port_property i_eth_reconfig_read termination true
      set_port_property o_eth_reconfig_readdata termination true
      set_port_property o_eth_reconfig_readdata termination_value 0
      set_port_property i_eth_reconfig_write termination true
      set_port_property i_eth_reconfig_writedata termination true
      set_port_property o_eth_reconfig_waitrequest termination true
      set_port_property o_eth_reconfig_waitrequest termination_value 0
   } 
}
