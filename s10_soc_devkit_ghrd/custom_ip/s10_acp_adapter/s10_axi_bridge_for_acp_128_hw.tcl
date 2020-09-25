#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2018-2020 Intel Corporation.
#
#****************************************************************************
# 
# s10_axi_bridge_for_acp_128 "s10_axi_bridge_for_acp_128" v1.0
# RSF 2018.08.28.13:40:51
# Simple ACE-LITE bridge to condition DOMAIN, BAR, SNOOP, CACHE, and PROT ports for ACP operation.
# 
# request TCL package from ACDS 18.1
# 
#****************************************************************************

package require -exact qsys 18.1


# 
# module s10_axi_bridge_for_acp_128
# 
set_module_property DESCRIPTION "Simple ACE-LITE bridge to condition DOMAIN, BAR, SNOOP, CACHE, and PROT ports for ACP operation."
set_module_property NAME s10_axi_bridge_for_acp_128
set_module_property VERSION 19.3.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR "Intel Corporation"
set_module_property DISPLAY_NAME s10_axi_bridge_for_acp_128
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property SUPPORTED_DEVICE_FAMILIES {"Stratix 10"}
set_module_property GROUP "Example Designs/Component"
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property ELABORATION_CALLBACK elaborate
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL s10_axi_bridge_for_acp_128
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file s10_axi_bridge_for_acp_128.v VERILOG PATH s10_axi_bridge_for_acp_128.v TOP_LEVEL_FILE

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL s10_axi_bridge_for_acp_128
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file s10_axi_bridge_for_acp_128.v VERILOG PATH s10_axi_bridge_for_acp_128.v

add_fileset SIM_VHDL SIM_VHDL "" ""
set_fileset_property SIM_VHDL TOP_LEVEL s10_axi_bridge_for_acp_128
set_fileset_property SIM_VHDL ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VHDL ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file s10_axi_bridge_for_acp_128.v VERILOG PATH s10_axi_bridge_for_acp_128.v


# 
# parameters
# 
add_parameter GPIO_EN INTEGER 0 ""
set_parameter_property GPIO_EN DEFAULT_VALUE 0
set_parameter_property GPIO_EN DISPLAY_NAME "GPIO_EN"
set_parameter_property GPIO_EN ALLOWED_RANGES {"1" "0"}
set_parameter_property GPIO_EN DESCRIPTION "GPIO Control of ACE-LITE Ports"
set_parameter_property GPIO_EN HDL_PARAMETER true

add_parameter CSR_EN INTEGER 0 ""
set_parameter_property CSR_EN DEFAULT_VALUE 0
set_parameter_property CSR_EN DISPLAY_NAME "CSR_EN"
set_parameter_property CSR_EN ALLOWED_RANGES {"1" "0"}
set_parameter_property CSR_EN DESCRIPTION "CSR Control of ACE-LITE Ports"
set_parameter_property CSR_EN HDL_PARAMETER true

add_parameter ARDOMAIN_OVERRIDE STD_LOGIC_VECTOR 0x2
set_parameter_property ARDOMAIN_OVERRIDE DEFAULT_VALUE 0x2
set_parameter_property ARDOMAIN_OVERRIDE DISPLAY_NAME "ARDOMAIN_OVERRIDE"
set_parameter_property ARDOMAIN_OVERRIDE DESCRIPTION "ARDOMAIN_OVERRIDE"
set_parameter_property ARDOMAIN_OVERRIDE WIDTH 2
set_parameter_property ARDOMAIN_OVERRIDE HDL_PARAMETER true

add_parameter ARBAR_OVERRIDE STD_LOGIC_VECTOR 0x0
set_parameter_property ARBAR_OVERRIDE DEFAULT_VALUE 0x0
set_parameter_property ARBAR_OVERRIDE DISPLAY_NAME "ARBAR_OVERRIDE"
set_parameter_property ARBAR_OVERRIDE DESCRIPTION "ARBAR_OVERRIDE"
set_parameter_property ARBAR_OVERRIDE WIDTH 2
set_parameter_property ARBAR_OVERRIDE HDL_PARAMETER true

add_parameter ARSNOOP_OVERRIDE STD_LOGIC_VECTOR 0x0
set_parameter_property ARSNOOP_OVERRIDE DEFAULT_VALUE 0x0
set_parameter_property ARSNOOP_OVERRIDE DISPLAY_NAME "ARSNOOP_OVERRIDE"
set_parameter_property ARSNOOP_OVERRIDE DESCRIPTION "ARSNOOP_OVERRIDE"
set_parameter_property ARSNOOP_OVERRIDE WIDTH 4
set_parameter_property ARSNOOP_OVERRIDE HDL_PARAMETER true

add_parameter ARCACHE_OVERRIDE STD_LOGIC_VECTOR 0xF
set_parameter_property ARCACHE_OVERRIDE DEFAULT_VALUE 0xF
set_parameter_property ARCACHE_OVERRIDE DISPLAY_NAME "ARCACHE_OVERRIDE"
set_parameter_property ARCACHE_OVERRIDE DESCRIPTION "ARCACHE_OVERRIDE"
set_parameter_property ARCACHE_OVERRIDE WIDTH 4
set_parameter_property ARCACHE_OVERRIDE HDL_PARAMETER true

add_parameter AWDOMAIN_OVERRIDE STD_LOGIC_VECTOR 0x2
set_parameter_property AWDOMAIN_OVERRIDE DEFAULT_VALUE 0x2
set_parameter_property AWDOMAIN_OVERRIDE DISPLAY_NAME "AWDOMAIN_OVERRIDE"
set_parameter_property AWDOMAIN_OVERRIDE DESCRIPTION "AWDOMAIN_OVERRIDE"
set_parameter_property AWDOMAIN_OVERRIDE WIDTH 2
set_parameter_property AWDOMAIN_OVERRIDE HDL_PARAMETER true

add_parameter AWBAR_OVERRIDE STD_LOGIC_VECTOR 0x0
set_parameter_property AWBAR_OVERRIDE DEFAULT_VALUE 0x0
set_parameter_property AWBAR_OVERRIDE DISPLAY_NAME "AWBAR_OVERRIDE"
set_parameter_property AWBAR_OVERRIDE DESCRIPTION "AWBAR_OVERRIDE"
set_parameter_property AWBAR_OVERRIDE WIDTH 2
set_parameter_property AWBAR_OVERRIDE HDL_PARAMETER true

add_parameter AWSNOOP_OVERRIDE STD_LOGIC_VECTOR 0x0
set_parameter_property AWSNOOP_OVERRIDE DEFAULT_VALUE 0x0
set_parameter_property AWSNOOP_OVERRIDE DISPLAY_NAME "AWSNOOP_OVERRIDE"
set_parameter_property AWSNOOP_OVERRIDE DESCRIPTION "AWSNOOP_OVERRIDE"
set_parameter_property AWSNOOP_OVERRIDE WIDTH 3
set_parameter_property AWSNOOP_OVERRIDE HDL_PARAMETER true

add_parameter AWCACHE_OVERRIDE STD_LOGIC_VECTOR 0xF
set_parameter_property AWCACHE_OVERRIDE DEFAULT_VALUE 0xF
set_parameter_property AWCACHE_OVERRIDE DISPLAY_NAME "AWCACHE_OVERRIDE"
set_parameter_property AWCACHE_OVERRIDE DESCRIPTION "AWCACHE_OVERRIDE"
set_parameter_property AWCACHE_OVERRIDE WIDTH 4
set_parameter_property AWCACHE_OVERRIDE HDL_PARAMETER true

add_parameter AxPROT_OVERRIDE STD_LOGIC_VECTOR 0x3
set_parameter_property AxPROT_OVERRIDE DEFAULT_VALUE 0x3
set_parameter_property AxPROT_OVERRIDE DISPLAY_NAME "AxPROT_OVERRIDE"
set_parameter_property AxPROT_OVERRIDE DESCRIPTION "AxPROT_OVERRIDE"
set_parameter_property AxPROT_OVERRIDE WIDTH 3
set_parameter_property AxPROT_OVERRIDE HDL_PARAMETER true

add_parameter ADDR_WIDTH INTEGER 32
set_parameter_property ADDR_WIDTH DEFAULT_VALUE 32
set_parameter_property ADDR_WIDTH DISPLAY_NAME "Address Width"
set_parameter_property ADDR_WIDTH DESCRIPTION "Address Width"
set_parameter_property ADDR_WIDTH HDL_PARAMETER true

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
set_interface_property clock IPXACT_REGISTER_MAP_VARIABLES ""

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
set_interface_property reset IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port reset reset reset Input 1

# 
# connection point csr_clock
# 
add_interface csr_clock clock end
set_interface_property csr_clock ENABLED true
set_interface_property csr_clock EXPORT_OF ""
set_interface_property csr_clock PORT_NAME_MAP ""
set_interface_property csr_clock CMSIS_SVD_VARIABLES ""
set_interface_property csr_clock SVD_ADDRESS_GROUP ""
set_interface_property csr_clock IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port csr_clock csr_clk clk Input 1


# 
# connection point csr_reset
# 
add_interface csr_reset reset end
set_interface_property csr_reset associatedClock csr_clock
set_interface_property csr_reset synchronousEdges DEASSERT
set_interface_property csr_reset ENABLED true
set_interface_property csr_reset EXPORT_OF ""
set_interface_property csr_reset PORT_NAME_MAP ""
set_interface_property csr_reset CMSIS_SVD_VARIABLES ""
set_interface_property csr_reset SVD_ADDRESS_GROUP ""
set_interface_property csr_reset IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port csr_reset csr_reset reset Input 1

# 
# connection point csr
# 
add_interface csr avalon end
set_interface_property csr addressGroup 0
set_interface_property csr addressUnits WORDS
set_interface_property csr associatedClock csr_clock
set_interface_property csr associatedReset csr_reset
set_interface_property csr bitsPerSymbol 8
set_interface_property csr bridgedAddressOffset ""
set_interface_property csr bridgesToMaster ""
set_interface_property csr burstOnBurstBoundariesOnly false
set_interface_property csr burstcountUnits WORDS
set_interface_property csr explicitAddressSpan 0
set_interface_property csr holdTime 0
set_interface_property csr linewrapBursts false
set_interface_property csr maximumPendingReadTransactions 0
set_interface_property csr maximumPendingWriteTransactions 0
set_interface_property csr minimumResponseLatency 1
set_interface_property csr readLatency 2
set_interface_property csr readWaitStates 0
set_interface_property csr readWaitTime 0
set_interface_property csr setupTime 0
set_interface_property csr timingUnits Cycles
set_interface_property csr transparentBridge false
set_interface_property csr waitrequestAllowance 0
set_interface_property csr writeWaitTime 0
set_interface_property csr ENABLED true
set_interface_property csr EXPORT_OF ""
set_interface_property csr PORT_NAME_MAP ""
set_interface_property csr CMSIS_SVD_VARIABLES ""
set_interface_property csr SVD_ADDRESS_GROUP ""

add_interface_port csr addr address Input 1
add_interface_port csr read read Input 1
add_interface_port csr write write Input 1
add_interface_port csr writedata writedata Input 32
add_interface_port csr readdata readdata Output 32
set_interface_assignment csr embeddedsw.configuration.isFlash 0
set_interface_assignment csr embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment csr embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment csr embeddedsw.configuration.isPrintableDevice 0

# 
# connection point m0
# 
add_interface m0 acelite start
set_interface_property m0 associatedClock clock
set_interface_property m0 associatedReset reset
set_interface_property m0 readIssuingCapability 8
set_interface_property m0 writeIssuingCapability 8
set_interface_property m0 combinedIssuingCapability 16
set_interface_property m0 issuesINCRBursts true
set_interface_property m0 issuesWRAPBursts true
set_interface_property m0 issuesFIXEDBursts true
set_interface_property m0 ENABLED true
set_interface_property m0 EXPORT_OF ""
set_interface_property m0 PORT_NAME_MAP ""
set_interface_property m0 CMSIS_SVD_VARIABLES ""
set_interface_property m0 SVD_ADDRESS_GROUP ""
set_interface_property m0 IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port m0 axm_m0_araddr araddr Output -1
add_interface_port m0 axm_m0_arburst arburst Output 2
add_interface_port m0 axm_m0_arcache arcache Output 4
add_interface_port m0 axm_m0_arid arid Output 4
add_interface_port m0 axm_m0_arlen arlen Output 8
add_interface_port m0 axm_m0_arlock arlock Output 1
add_interface_port m0 axm_m0_arprot arprot Output 3
add_interface_port m0 axm_m0_arqos arqos Output 4
add_interface_port m0 axm_m0_arready arready Input 1
add_interface_port m0 axm_m0_arsize arsize Output 3
add_interface_port m0 axm_m0_arvalid arvalid Output 1
add_interface_port m0 axm_m0_arsnoop arsnoop Output 4
add_interface_port m0 axm_m0_ardomain ardomain Output 2
add_interface_port m0 axm_m0_arbar arbar Output 2
#add_interface_port m0 axm_m0_aruser aruser Output 8
add_interface_port m0 axm_m0_awaddr awaddr Output -1
add_interface_port m0 axm_m0_awburst awburst Output 2
add_interface_port m0 axm_m0_awcache awcache Output 4
add_interface_port m0 axm_m0_awid awid Output 4
add_interface_port m0 axm_m0_awlen awlen Output 8
add_interface_port m0 axm_m0_awlock awlock Output 1
add_interface_port m0 axm_m0_awprot awprot Output 3
add_interface_port m0 axm_m0_awready awready Input 1
add_interface_port m0 axm_m0_awsize awsize Output 3
add_interface_port m0 axm_m0_awvalid awvalid Output 1
add_interface_port m0 axm_m0_awqos awqos Output 4
add_interface_port m0 axm_m0_bid bid Input 4
add_interface_port m0 axm_m0_bready bready Output 1
add_interface_port m0 axm_m0_bresp bresp Input 2
add_interface_port m0 axm_m0_bvalid bvalid Input 1
add_interface_port m0 axm_m0_rdata rdata Input 128
add_interface_port m0 axm_m0_rid rid Input 4
add_interface_port m0 axm_m0_rlast rlast Input 1
add_interface_port m0 axm_m0_rready rready Output 1
add_interface_port m0 axm_m0_rresp rresp Input 2
add_interface_port m0 axm_m0_rvalid rvalid Input 1
add_interface_port m0 axm_m0_wdata wdata Output 128
add_interface_port m0 axm_m0_wlast wlast Output 1
add_interface_port m0 axm_m0_wready wready Input 1
add_interface_port m0 axm_m0_wstrb wstrb Output 16
add_interface_port m0 axm_m0_wvalid wvalid Output 1
add_interface_port m0 axm_m0_awsnoop awsnoop Output 3
add_interface_port m0 axm_m0_awdomain awdomain Output 2
add_interface_port m0 axm_m0_awbar awbar Output 2
#add_interface_port m0 axm_m0_awuser awuser Output 8
#add_interface_port m0 axm_m0_wuser wuser Output 1
#add_interface_port m0 axm_m0_awregion awregion Output 4
#add_interface_port m0 axm_m0_buser buser Input 1
#add_interface_port m0 axm_m0_awunique awunique Output 1
#add_interface_port m0 axm_m0_ruser ruser Input 1
#add_interface_port m0 axm_m0_arregion arregion Output 4



# 
# connection point s0
# 
add_interface s0 axi4 end
set_interface_property s0 associatedClock clock
set_interface_property s0 associatedReset reset
set_interface_property s0 readAcceptanceCapability 8
set_interface_property s0 writeAcceptanceCapability 8
set_interface_property s0 combinedAcceptanceCapability 16
set_interface_property s0 readDataReorderingDepth 8
set_interface_property s0 bridgesToMaster m0
set_interface_property s0 ENABLED true
set_interface_property s0 EXPORT_OF ""
set_interface_property s0 PORT_NAME_MAP ""
set_interface_property s0 CMSIS_SVD_VARIABLES ""
set_interface_property s0 SVD_ADDRESS_GROUP ""
set_interface_property s0 IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port s0 axs_s0_araddr araddr Input -1
add_interface_port s0 axs_s0_arburst arburst Input 2
add_interface_port s0 axs_s0_arcache arcache Input 4
add_interface_port s0 axs_s0_arid arid Input 4
add_interface_port s0 axs_s0_arlen arlen Input 8
add_interface_port s0 axs_s0_arlock arlock Input 1
add_interface_port s0 axs_s0_arprot arprot Input 3
add_interface_port s0 axs_s0_arready arready Output 1
add_interface_port s0 axs_s0_arsize arsize Input 3
add_interface_port s0 axs_s0_arvalid arvalid Input 1
add_interface_port s0 axs_s0_awaddr awaddr Input -1
add_interface_port s0 axs_s0_awburst awburst Input 2
add_interface_port s0 axs_s0_awcache awcache Input 4
add_interface_port s0 axs_s0_awid awid Input 4
add_interface_port s0 axs_s0_awlen awlen Input 8
add_interface_port s0 axs_s0_awlock awlock Input 1
add_interface_port s0 axs_s0_awprot awprot Input 3
add_interface_port s0 axs_s0_awready awready Output 1
add_interface_port s0 axs_s0_awsize awsize Input 3
add_interface_port s0 axs_s0_awvalid awvalid Input 1
add_interface_port s0 axs_s0_bid bid Output 4
add_interface_port s0 axs_s0_bready bready Input 1
add_interface_port s0 axs_s0_bresp bresp Output 2
add_interface_port s0 axs_s0_bvalid bvalid Output 1
add_interface_port s0 axs_s0_rdata rdata Output 128
add_interface_port s0 axs_s0_rid rid Output 4
add_interface_port s0 axs_s0_rlast rlast Output 1
add_interface_port s0 axs_s0_rready rready Input 1
add_interface_port s0 axs_s0_rresp rresp Output 2
add_interface_port s0 axs_s0_rvalid rvalid Output 1
add_interface_port s0 axs_s0_wdata wdata Input 128
add_interface_port s0 axs_s0_wlast wlast Input 1
add_interface_port s0 axs_s0_wready wready Output 1
add_interface_port s0 axs_s0_wstrb wstrb Input 16
add_interface_port s0 axs_s0_wvalid wvalid Input 1


# 
# connection point gpio
# 
add_interface gpio conduit end
set_interface_property gpio associatedClock ""
set_interface_property gpio associatedReset ""
set_interface_property gpio ENABLED true
set_interface_property gpio EXPORT_OF ""
set_interface_property gpio PORT_NAME_MAP ""
set_interface_property gpio CMSIS_SVD_VARIABLES ""
set_interface_property gpio SVD_ADDRESS_GROUP ""

add_interface_port gpio gp_input gp_in Output 32
add_interface_port gpio gp_output gp_out Input 32

proc elaborate {} {
    set_port_property axm_m0_araddr WIDTH_EXPR [get_parameter_value ADDR_WIDTH]
    set_port_property axm_m0_awaddr WIDTH_EXPR [get_parameter_value ADDR_WIDTH]
    set_port_property axs_s0_araddr WIDTH_EXPR [get_parameter_value ADDR_WIDTH]
    set_port_property axs_s0_awaddr WIDTH_EXPR [get_parameter_value ADDR_WIDTH]
    
    if { [get_parameter_value GPIO_EN] == 0 } {
        set_interface_property   gpio   ENABLED 0
        set_parameter_property   CSR_EN    ENABLED 1
        set_parameter_property   ARDOMAIN_OVERRIDE    ENABLED 1
        set_parameter_property   ARBAR_OVERRIDE       ENABLED 1
        set_parameter_property   ARSNOOP_OVERRIDE     ENABLED 1
        set_parameter_property   ARCACHE_OVERRIDE     ENABLED 1
        set_parameter_property   AWDOMAIN_OVERRIDE    ENABLED 1
        set_parameter_property   AWBAR_OVERRIDE       ENABLED 1
        set_parameter_property   AWSNOOP_OVERRIDE     ENABLED 1
        set_parameter_property   AWCACHE_OVERRIDE     ENABLED 1
        set_parameter_property   AxPROT_OVERRIDE      ENABLED 1
    } else {
        set_interface_property   gpio   ENABLED 1
        set_parameter_property   CSR_EN               ENABLED 0
        set_parameter_property   ARDOMAIN_OVERRIDE    ENABLED 0
        set_parameter_property   ARBAR_OVERRIDE       ENABLED 0
        set_parameter_property   ARSNOOP_OVERRIDE     ENABLED 0
        set_parameter_property   ARCACHE_OVERRIDE     ENABLED 0
        set_parameter_property   AWDOMAIN_OVERRIDE    ENABLED 0
        set_parameter_property   AWBAR_OVERRIDE       ENABLED 0
        set_parameter_property   AWSNOOP_OVERRIDE     ENABLED 0
        set_parameter_property   AWCACHE_OVERRIDE     ENABLED 0
        set_parameter_property   AxPROT_OVERRIDE      ENABLED 0
    }    
    
    if { [get_parameter_value CSR_EN] == 0 } {
        set_parameter_property   GPIO_EN     ENABLED 1
        set_interface_property   csr_clock   ENABLED 0
        set_interface_property   csr_reset   ENABLED 0
        set_interface_property   csr         ENABLED 0
    } else {
        set_parameter_property   GPIO_EN     ENABLED 0
        set_interface_property   csr_clock   ENABLED 1
        set_interface_property   csr_reset   ENABLED 1
        set_interface_property   csr         ENABLED 1
    } 
}
