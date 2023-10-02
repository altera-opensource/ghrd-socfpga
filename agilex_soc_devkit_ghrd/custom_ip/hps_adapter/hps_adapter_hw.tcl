# TCL File Generated by Component Editor 23.3
# Fri Aug 11 11:08:11 MYT 2023
# DO NOT MODIFY


# 
# hps_adapter "hps_adapter" v1.0
#  2023.08.11.11:08:11
# 
# 

# 
# request TCL package from ACDS 23.3
# 
package require -exact qsys 23.3


# 
# module hps_adapter
# 
set_module_property DESCRIPTION ""
set_module_property NAME hps_adapter
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property BSP_CPU false
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME hps_adapter
set_module_property DATASHEET_URL false
set_module_property GROUP "HPS_Adapter"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false
set_module_property LOAD_ELABORATION_LIMIT 0
set_module_property PRE_COMP_MODULE_ENABLED false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL hps_adapter
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file hps_adapter.sv SYSTEM_VERILOG PATH "hps_adapter.sv" TOP_LEVEL_FILE
add_fileset_file hps_adapter_dcfifo_s.sv SYSTEM_VERILOG PATH "hps_adapter_dcfifo_s.sv"
add_fileset_file hps_adapter_util.sv SYSTEM_VERILOG PATH "hps_adapter_util.sv"

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL hps_adapter
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file hps_adapter.sv SYSTEM_VERILOG PATH "hps_adapter.sv"
add_fileset_file hps_adapter_dcfifo_s.sv SYSTEM_VERILOG PATH "hps_adapter_dcfifo_s.sv"
add_fileset_file hps_adapter_util.sv SYSTEM_VERILOG PATH "hps_adapter_util.sv"


# 
# documentation links
# 
add_documentation_link "Data Sheet" file:///nfs/site/disks/swuser_work_felixsie/hbm_btm_referencedesign/qii/false
add_documentation_link "Data Sheet" file:///nfs/site/disks/swuser_work_felixsie/hbm_btm_referencedesign/qii/false
add_documentation_link "Data Sheet" file:///nfs/site/disks/swuser_work_felixsie/hbmref/felixghrd_agmf039r47a1e1vr0_23_3_0_48_restored/subs_hbm/false
add_documentation_link "Data Sheet" file:///nfs/site/disks/swuser_work_felixsie/hbmref/felixghrd_agmf039r47a1e1vr0_23_3_0_48_restored/subs_hbm/false


# 
# parameters
# 
add_parameter INIU_AXI4_DATA_WIDTH INTEGER 256
set_parameter_property INIU_AXI4_DATA_WIDTH DEFAULT_VALUE 256
set_parameter_property INIU_AXI4_DATA_WIDTH DISPLAY_NAME INIU_AXI4_DATA_WIDTH
set_parameter_property INIU_AXI4_DATA_WIDTH UNITS None
set_parameter_property INIU_AXI4_DATA_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property INIU_AXI4_DATA_WIDTH AFFECTS_GENERATION false
set_parameter_property INIU_AXI4_DATA_WIDTH HDL_PARAMETER true
set_parameter_property INIU_AXI4_DATA_WIDTH EXPORT true
add_parameter HPS_AXI4_DATA_WIDTH INTEGER 128 ""
set_parameter_property HPS_AXI4_DATA_WIDTH DEFAULT_VALUE 128
set_parameter_property HPS_AXI4_DATA_WIDTH DISPLAY_NAME HPS_AXI4_DATA_WIDTH
set_parameter_property HPS_AXI4_DATA_WIDTH UNITS None
set_parameter_property HPS_AXI4_DATA_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property HPS_AXI4_DATA_WIDTH DESCRIPTION ""
set_parameter_property HPS_AXI4_DATA_WIDTH AFFECTS_GENERATION false
set_parameter_property HPS_AXI4_DATA_WIDTH HDL_PARAMETER true
set_parameter_property HPS_AXI4_DATA_WIDTH EXPORT true
add_parameter INIU_AXI4_ADDR_WIDTH INTEGER 44
set_parameter_property INIU_AXI4_ADDR_WIDTH DEFAULT_VALUE 44
set_parameter_property INIU_AXI4_ADDR_WIDTH DISPLAY_NAME INIU_AXI4_ADDR_WIDTH
set_parameter_property INIU_AXI4_ADDR_WIDTH UNITS None
set_parameter_property INIU_AXI4_ADDR_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property INIU_AXI4_ADDR_WIDTH AFFECTS_GENERATION false
set_parameter_property INIU_AXI4_ADDR_WIDTH HDL_PARAMETER true
set_parameter_property INIU_AXI4_ADDR_WIDTH EXPORT true


# 
# display items
# 


# 
# connection point altera_axi4_master
# 
add_interface altera_axi4_master axi4 start
set_interface_property altera_axi4_master associatedClock clock_sink
set_interface_property altera_axi4_master associatedReset reset_sink
set_interface_property altera_axi4_master wakeupSignals false
set_interface_property altera_axi4_master uniqueIdSupport false
set_interface_property altera_axi4_master poison false
set_interface_property altera_axi4_master traceSignals false
set_interface_property altera_axi4_master readIssuingCapability 1
set_interface_property altera_axi4_master writeIssuingCapability 1
set_interface_property altera_axi4_master combinedIssuingCapability 1
set_interface_property altera_axi4_master issuesINCRBursts true
set_interface_property altera_axi4_master issuesWRAPBursts true
set_interface_property altera_axi4_master issuesFIXEDBursts true
set_interface_property altera_axi4_master ENABLED true
set_interface_property altera_axi4_master EXPORT_OF ""
set_interface_property altera_axi4_master PORT_NAME_MAP ""
set_interface_property altera_axi4_master CMSIS_SVD_VARIABLES ""
set_interface_property altera_axi4_master SVD_ADDRESS_GROUP ""
set_interface_property altera_axi4_master IPXACT_REGISTER_MAP_VARIABLES ""
set_interface_property altera_axi4_master SV_INTERFACE_TYPE ""
set_interface_property altera_axi4_master SV_INTERFACE_MODPORT_TYPE ""

add_interface_port altera_axi4_master m_axi4_awid awid Output 7
add_interface_port altera_axi4_master m_axi4_awaddr awaddr Output "((INIU_AXI4_ADDR_WIDTH - 1)) - (0) + 1"
add_interface_port altera_axi4_master m_axi4_awlen awlen Output 8
add_interface_port altera_axi4_master m_axi4_awsize awsize Output 3
add_interface_port altera_axi4_master m_axi4_awburst awburst Output 2
add_interface_port altera_axi4_master m_axi4_awlock awlock Output 1
add_interface_port altera_axi4_master m_axi4_awprot awprot Output 3
add_interface_port altera_axi4_master m_axi4_awqos awqos Output 4
add_interface_port altera_axi4_master m_axi4_awuser awuser Output 11
add_interface_port altera_axi4_master m_axi4_awvalid awvalid Output 1
add_interface_port altera_axi4_master m_axi4_awready awready Input 1
add_interface_port altera_axi4_master m_axi4_wdata wdata Output "((INIU_AXI4_DATA_WIDTH - 1)) - (0) + 1"
add_interface_port altera_axi4_master m_axi4_wstrb wstrb Output "(((INIU_AXI4_DATA_WIDTH / 8) - 1)) - (0) + 1"
add_interface_port altera_axi4_master m_axi4_wlast wlast Output 1
add_interface_port altera_axi4_master m_axi4_wuser wuser Output "(((INIU_AXI4_DATA_WIDTH / 8) - 1)) - (0) + 1"
add_interface_port altera_axi4_master m_axi4_wvalid wvalid Output 1
add_interface_port altera_axi4_master m_axi4_wready wready Input 1
add_interface_port altera_axi4_master m_axi4_bid bid Input 7
add_interface_port altera_axi4_master m_axi4_bresp bresp Input 2
add_interface_port altera_axi4_master m_axi4_bvalid bvalid Input 1
add_interface_port altera_axi4_master m_axi4_bready bready Output 1
add_interface_port altera_axi4_master m_axi4_arid arid Output 7
add_interface_port altera_axi4_master m_axi4_araddr araddr Output "((INIU_AXI4_ADDR_WIDTH - 1)) - (0) + 1"
add_interface_port altera_axi4_master m_axi4_arlen arlen Output 8
add_interface_port altera_axi4_master m_axi4_arsize arsize Output 3
add_interface_port altera_axi4_master m_axi4_arburst arburst Output 2
add_interface_port altera_axi4_master m_axi4_arlock arlock Output 1
add_interface_port altera_axi4_master m_axi4_arprot arprot Output 3
add_interface_port altera_axi4_master m_axi4_arqos arqos Output 4
add_interface_port altera_axi4_master m_axi4_aruser aruser Output 11
add_interface_port altera_axi4_master m_axi4_arvalid arvalid Output 1
add_interface_port altera_axi4_master m_axi4_arready arready Input 1
add_interface_port altera_axi4_master m_axi4_rid rid Input 7
add_interface_port altera_axi4_master m_axi4_rdata rdata Input "((INIU_AXI4_DATA_WIDTH - 1)) - (0) + 1"
add_interface_port altera_axi4_master m_axi4_rresp rresp Input 2
add_interface_port altera_axi4_master m_axi4_rlast rlast Input 1
add_interface_port altera_axi4_master m_axi4_ruser ruser Input "(((INIU_AXI4_DATA_WIDTH / 8) - 1)) - (0) + 1"
add_interface_port altera_axi4_master m_axi4_rvalid rvalid Input 1
add_interface_port altera_axi4_master m_axi4_rready rready Output 1


# 
# connection point altera_axi4_slave
# 
add_interface altera_axi4_slave axi4 end
set_interface_property altera_axi4_slave associatedClock clock_sink
set_interface_property altera_axi4_slave associatedReset reset_sink
set_interface_property altera_axi4_slave wakeupSignals false
set_interface_property altera_axi4_slave uniqueIdSupport false
set_interface_property altera_axi4_slave poison false
set_interface_property altera_axi4_slave traceSignals false
set_interface_property altera_axi4_slave readAcceptanceCapability 1
set_interface_property altera_axi4_slave writeAcceptanceCapability 1
set_interface_property altera_axi4_slave combinedAcceptanceCapability 1
set_interface_property altera_axi4_slave readDataReorderingDepth 1
set_interface_property altera_axi4_slave bridgesToMaster ""
set_interface_property altera_axi4_slave dfhFeatureGuid 0
set_interface_property altera_axi4_slave dfhGroupId 0
set_interface_property altera_axi4_slave dfhParameterId ""
set_interface_property altera_axi4_slave dfhParameterName ""
set_interface_property altera_axi4_slave dfhParameterVersion ""
set_interface_property altera_axi4_slave dfhParameterData ""
set_interface_property altera_axi4_slave dfhParameterDataLength ""
set_interface_property altera_axi4_slave dfhFeatureMajorVersion 0
set_interface_property altera_axi4_slave dfhFeatureMinorVersion 0
set_interface_property altera_axi4_slave dfhFeatureId 35
set_interface_property altera_axi4_slave ENABLED true
set_interface_property altera_axi4_slave EXPORT_OF ""
set_interface_property altera_axi4_slave PORT_NAME_MAP ""
set_interface_property altera_axi4_slave CMSIS_SVD_VARIABLES ""
set_interface_property altera_axi4_slave SVD_ADDRESS_GROUP ""
set_interface_property altera_axi4_slave IPXACT_REGISTER_MAP_VARIABLES ""
set_interface_property altera_axi4_slave SV_INTERFACE_TYPE ""
set_interface_property altera_axi4_slave SV_INTERFACE_MODPORT_TYPE ""

add_interface_port altera_axi4_slave s_axi4_awid awid Input 7
add_interface_port altera_axi4_slave s_axi4_awaddr awaddr Input "((INIU_AXI4_ADDR_WIDTH - 1)) - (0) + 1"
add_interface_port altera_axi4_slave s_axi4_awlen awlen Input 8
add_interface_port altera_axi4_slave s_axi4_awsize awsize Input 3
add_interface_port altera_axi4_slave s_axi4_awburst awburst Input 2
add_interface_port altera_axi4_slave s_axi4_awlock awlock Input 1
add_interface_port altera_axi4_slave s_axi4_awprot awprot Input 3
add_interface_port altera_axi4_slave s_axi4_awqos awqos Input 4
add_interface_port altera_axi4_slave s_axi4_awuser awuser Input 11
add_interface_port altera_axi4_slave s_axi4_awvalid awvalid Input 1
add_interface_port altera_axi4_slave s_axi4_awready awready Output 1
add_interface_port altera_axi4_slave s_axi4_wdata wdata Input 128
add_interface_port altera_axi4_slave s_axi4_wstrb wstrb Input 16
add_interface_port altera_axi4_slave s_axi4_wlast wlast Input 1
add_interface_port altera_axi4_slave s_axi4_wuser wuser Input "(((HPS_AXI4_DATA_WIDTH / 8) - 1)) - (0) + 1"
add_interface_port altera_axi4_slave s_axi4_wvalid wvalid Input 1
add_interface_port altera_axi4_slave s_axi4_wready wready Output 1
add_interface_port altera_axi4_slave s_axi4_bid bid Output 7
add_interface_port altera_axi4_slave s_axi4_bresp bresp Output 2
add_interface_port altera_axi4_slave s_axi4_bvalid bvalid Output 1
add_interface_port altera_axi4_slave s_axi4_bready bready Input 1
add_interface_port altera_axi4_slave s_axi4_arid arid Input 7
add_interface_port altera_axi4_slave s_axi4_araddr araddr Input "((INIU_AXI4_ADDR_WIDTH - 1)) - (0) + 1"
add_interface_port altera_axi4_slave s_axi4_arlen arlen Input 8
add_interface_port altera_axi4_slave s_axi4_arsize arsize Input 3
add_interface_port altera_axi4_slave s_axi4_arburst arburst Input 2
add_interface_port altera_axi4_slave s_axi4_arlock arlock Input 1
add_interface_port altera_axi4_slave s_axi4_arprot arprot Input 3
add_interface_port altera_axi4_slave s_axi4_arqos arqos Input 4
add_interface_port altera_axi4_slave s_axi4_aruser aruser Input 11
add_interface_port altera_axi4_slave s_axi4_arvalid arvalid Input 1
add_interface_port altera_axi4_slave s_axi4_arready arready Output 1
add_interface_port altera_axi4_slave s_axi4_rid rid Output 7
add_interface_port altera_axi4_slave s_axi4_rdata rdata Output 128
add_interface_port altera_axi4_slave s_axi4_rresp rresp Output 2
add_interface_port altera_axi4_slave s_axi4_rlast rlast Output 1
add_interface_port altera_axi4_slave s_axi4_ruser ruser Output "(((HPS_AXI4_DATA_WIDTH / 8) - 1)) - (0) + 1"
add_interface_port altera_axi4_slave s_axi4_rvalid rvalid Output 1
add_interface_port altera_axi4_slave s_axi4_rready rready Input 1


# 
# connection point clock_sink
# 
add_interface clock_sink clock end
set_interface_property clock_sink ENABLED true
set_interface_property clock_sink EXPORT_OF ""
set_interface_property clock_sink PORT_NAME_MAP ""
set_interface_property clock_sink CMSIS_SVD_VARIABLES ""
set_interface_property clock_sink SVD_ADDRESS_GROUP ""
set_interface_property clock_sink IPXACT_REGISTER_MAP_VARIABLES ""
set_interface_property clock_sink SV_INTERFACE_TYPE ""
set_interface_property clock_sink SV_INTERFACE_MODPORT_TYPE ""

add_interface_port clock_sink s_axi4_aclk clk Input 1


# 
# connection point reset_sink
# 
add_interface reset_sink reset end
set_interface_property reset_sink associatedClock clock_sink
set_interface_property reset_sink synchronousEdges DEASSERT
set_interface_property reset_sink ENABLED true
set_interface_property reset_sink EXPORT_OF ""
set_interface_property reset_sink PORT_NAME_MAP ""
set_interface_property reset_sink CMSIS_SVD_VARIABLES ""
set_interface_property reset_sink SVD_ADDRESS_GROUP ""
set_interface_property reset_sink IPXACT_REGISTER_MAP_VARIABLES ""
set_interface_property reset_sink SV_INTERFACE_TYPE ""
set_interface_property reset_sink SV_INTERFACE_MODPORT_TYPE ""

add_interface_port reset_sink s_axi4_aresetn reset_n Input 1

