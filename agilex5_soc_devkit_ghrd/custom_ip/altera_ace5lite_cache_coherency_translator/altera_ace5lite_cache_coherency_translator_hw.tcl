package require -exact qsys 23.3

# ----------------------------------------------------------------------------------------------------------
# module intel_cache_coherency_translator2
# ----------------------------------------------------------------------------------------------------------
set_module_property DESCRIPTION "The Altera Cache Coherency Translator IP provides the ability to perform translation from AXI-4 interface to ACE-Lite interface, with additional ability of allowing run-time setting of cache-ability options on the ACE5-Lite interface"
set_module_property NAME altera_ace5lite_cache_coherency_translator
set_module_property VERSION 1.0.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR "Intel Corporation"
set_module_property DISPLAY_NAME "Altera ACE5-Lite Cache Coherency Translator"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property SUPPORTED_DEVICE_FAMILIES {"Agilex 5"}
set_module_property GROUP "Processors and Peripherals/Hard Processor Components"
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property ELABORATION_CALLBACK elaborate
set_module_property REPORT_HIERARCHY false

# ----------------------------------------------------------------------------------------------------------
# file sets
# ----------------------------------------------------------------------------------------------------------
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH generate_synth
set_fileset_property QUARTUS_SYNTH TOP_LEVEL altera_ace5lite_cache_coherency_translator

add_fileset SIM_VERILOG SIM_VERILOG generate_sim
set_fileset_property SIM_VERILOG TOP_LEVEL altera_ace5lite_cache_coherency_translator

proc generate_synth {entity_name} {
    generate_fileset $entity_name
}

proc generate_sim {entity_name} {
    generate_fileset $entity_name
}

proc generate_fileset {entity_name} {
    # Added RTL Fileset
    add_fileset_file altera_ace5lite_cache_coherency_translator.sv SYSTEMVERILOG PATH altera_ace5lite_cache_coherency_translator.sv
}

# ----------------------------------------------------------------------------------------------------------
# Parameters
# ----------------------------------------------------------------------------------------------------------
add_parameter F2H_ADDRESS_WIDTH INTEGER 40 ""
set_parameter_property F2H_ADDRESS_WIDTH DISPLAY_NAME "Interface Address Width"
set_parameter_property F2H_ADDRESS_WIDTH DESCRIPTION "Use this setting to select the interface address width. It will configure the AXI/ACE-Lite address space in Platform Designer"
set_parameter_property F2H_ADDRESS_WIDTH ALLOWED_RANGES {"40:40-bit 1TB"\
                                                    "39:39-bit 512GB"\
                                                    "38:38-bit 256GB"\
                                                    "37:37-bit 128GB"\
                                                    "36:36-bit 64GB"\
                                                    "35:35-bit 32GB"\
                                                    "34:34-bit 16GB"\
                                                    "33:33-bit 8GB"\
                                                    "32:32-bit 4GB"\
                                                    "31:31-bit 2GB"\
                                                    "30:30-bit 1GB"\
                                                    "29:29-bit 512 MB"\
                                                    "28:28-bit 256 MB"\
                                                    "27:27-bit 128 MB"\
                                                    "26:26-bit 64 MB"\
                                                    "25:25-bit 32 MB"\
                                                    "24:24-bit 16 MB"\
                                                    "23:23-bit 8 MB"\
                                                    "22:22-bit 4 MB" \
                                                    "21:21-bit 2 MB"\
                                                    "20:20-bit 1 MB"}
set_parameter_property F2H_ADDRESS_WIDTH HDL_PARAMETER true

# ----------------------------------------------------------------------------------------------------------
# module validation
# ----------------------------------------------------------------------------------------------------------
proc validate {} {
    send_message info "Validating module..."
}

# ----------------------------------------------------------------------------------------------------------
# module elaboration
# ----------------------------------------------------------------------------------------------------------

proc elaborate {} {
    #send_message info "F2H_ADDRESS_WIDTH = [get_parameter_value F2H_ADDRESS_WIDTH]"
    set F2H_ADDRESS_WIDTH [get_parameter_value F2H_ADDRESS_WIDTH]
    set F2H_DATA_WIDTH 256

    #
    # connection point axi_clock
    #
    add_interface clock clock end
    set_interface_property clock ENABLED true
    add_interface_port clock axi_clock clk Input 1


    #
    # connection point core_reset
    #
    add_interface reset reset end
    set_interface_property reset associatedClock ""
    set_interface_property reset synchronousEdges NONE
    set_interface_property reset ENABLED true
    add_interface_port reset axi_reset reset Input 1

    add_interface m0 ace5lite start
    set_interface_property m0 associatedClock "clock"
    set_interface_property m0 associatedReset "reset"
    set_interface_property m0 atomicTransactions true
    set_interface_property m0 cacheStashTransactions true
    add_interface_port m0 ace5_fpga2hps_awid awid Output 5

    add_interface_port m0 ace5_fpga2hps_awid awid output 5
    add_interface_port m0 ace5_fpga2hps_awaddr awaddr output $F2H_ADDRESS_WIDTH
    add_interface_port m0 ace5_fpga2hps_awdomain awdomain output 2
    add_interface_port m0 ace5_fpga2hps_awsnoop awsnoop output 4
    #add_interface_port m0 ace5_fpga2hps_awbar awbar output 2
    add_interface_port m0 ace5_fpga2hps_awlen awlen output 8
    add_interface_port m0 ace5_fpga2hps_awsize awsize output 3
    add_interface_port m0 ace5_fpga2hps_arsize arsize output 3
    add_interface_port m0 ace5_fpga2hps_awburst awburst output 2
    add_interface_port m0 ace5_fpga2hps_awlock awlock output 1
    add_interface_port m0 ace5_fpga2hps_awcache awcache output 4
    add_interface_port m0 ace5_fpga2hps_awprot awprot output 3
    add_interface_port m0 ace5_fpga2hps_awqos awqos output 4
    add_interface_port m0 ace5_fpga2hps_awvalid awvalid output 1
    add_interface_port m0 ace5_fpga2hps_awready awready input 1
    add_interface_port m0 ace5_fpga2hps_wdata wdata output $F2H_DATA_WIDTH
    add_interface_port m0 ace5_fpga2hps_wstrb wstrb output [expr {$F2H_DATA_WIDTH/8}]
    add_interface_port m0 ace5_fpga2hps_wlast wlast output 1
    add_interface_port m0 ace5_fpga2hps_wvalid wvalid output 1
    add_interface_port m0 ace5_fpga2hps_wready wready input 1
    add_interface_port m0 ace5_fpga2hps_awstashnid awstashnid output 11
    add_interface_port m0 ace5_fpga2hps_awstashniden awstashniden output 1
    add_interface_port m0 ace5_fpga2hps_awstashlpid awstashlpid output 5
    add_interface_port m0 ace5_fpga2hps_awstashlpiden awstashlpiden output 1
    add_interface_port m0 ace5_fpga2hps_awatop awatop output 6
    add_interface_port m0 ace5_fpga2hps_bid bid input 5
    add_interface_port m0 ace5_fpga2hps_bresp bresp input 2
    add_interface_port m0 ace5_fpga2hps_bvalid bvalid input 1
    add_interface_port m0 ace5_fpga2hps_bready bready output 1
    add_interface_port m0 ace5_fpga2hps_arid arid output 5
    add_interface_port m0 ace5_fpga2hps_araddr araddr output $F2H_ADDRESS_WIDTH
    add_interface_port m0 ace5_fpga2hps_ardomain ardomain output 2
    add_interface_port m0 ace5_fpga2hps_arsnoop arsnoop output 4
    #add_interface_port m0 ace5_fpga2hps_arbar arbar output 2
    add_interface_port m0 ace5_fpga2hps_arlen arlen output 8
    add_interface_port m0 ace5_fpga2hps_arburst arburst output 2
    add_interface_port m0 ace5_fpga2hps_arlock arlock output 1
    add_interface_port m0 ace5_fpga2hps_arcache arcache output 4
    add_interface_port m0 ace5_fpga2hps_arprot arprot output 3
    add_interface_port m0 ace5_fpga2hps_arqos arqos output 4
    add_interface_port m0 ace5_fpga2hps_arvalid arvalid output 1
    add_interface_port m0 ace5_fpga2hps_arready arready input 1
    add_interface_port m0 ace5_fpga2hps_rid rid input 5
    add_interface_port m0 ace5_fpga2hps_rdata rdata input $F2H_DATA_WIDTH
    add_interface_port m0 ace5_fpga2hps_rresp rresp input 2
    add_interface_port m0 ace5_fpga2hps_rlast rlast input 1
    add_interface_port m0 ace5_fpga2hps_rvalid rvalid input 1
    add_interface_port m0 ace5_fpga2hps_rready rready output 1
    add_interface_port m0 ace5_fpga2hps_aruser aruser output 8
    add_interface_port m0 ace5_fpga2hps_awuser awuser output 8
    add_interface_port m0 ace5_fpga2hps_arregion arregion output 4
    add_interface_port m0 ace5_fpga2hps_awregion awregion output 4
    add_interface_port m0 ace5_fpga2hps_wuser wuser output 8
    add_interface_port m0 ace5_fpga2hps_buser buser input 8
    add_interface_port m0 ace5_fpga2hps_ruser ruser input 8

    add_interface s0 axi4 end
    set_interface_property s0 associatedClock "clock"
    set_interface_property s0 associatedReset "reset"

    add_interface_port s0 axi4_fpga2hps_awid awid input 5
    add_interface_port s0 axi4_fpga2hps_awaddr awaddr input $F2H_ADDRESS_WIDTH
    add_interface_port s0 axi4_fpga2hps_awlen awlen input 8
    add_interface_port s0 axi4_fpga2hps_awsize awsize input 3
    add_interface_port s0 axi4_fpga2hps_arsize arsize input 3
    add_interface_port s0 axi4_fpga2hps_awburst awburst input 2
    add_interface_port s0 axi4_fpga2hps_awlock awlock input 1
    add_interface_port s0 axi4_fpga2hps_awcache awcache input 4
    add_interface_port s0 axi4_fpga2hps_awprot awprot input 3
    add_interface_port s0 axi4_fpga2hps_awqos awqos input 4
    add_interface_port s0 axi4_fpga2hps_awvalid awvalid input 1
    add_interface_port s0 axi4_fpga2hps_awready awready output 1
    add_interface_port s0 axi4_fpga2hps_wdata wdata input $F2H_DATA_WIDTH
    add_interface_port s0 axi4_fpga2hps_wstrb wstrb input [expr {$F2H_DATA_WIDTH/8}]
    add_interface_port s0 axi4_fpga2hps_wlast wlast input 1
    add_interface_port s0 axi4_fpga2hps_wvalid wvalid input 1
    add_interface_port s0 axi4_fpga2hps_wready wready output 1
    add_interface_port s0 axi4_fpga2hps_bid bid output 5
    add_interface_port s0 axi4_fpga2hps_bresp bresp output 2
    add_interface_port s0 axi4_fpga2hps_bvalid bvalid output 1
    add_interface_port s0 axi4_fpga2hps_bready bready input 1
    add_interface_port s0 axi4_fpga2hps_arid arid input 5
    add_interface_port s0 axi4_fpga2hps_araddr araddr input $F2H_ADDRESS_WIDTH
    add_interface_port s0 axi4_fpga2hps_arlen arlen input 8
    add_interface_port s0 axi4_fpga2hps_arburst arburst input 2
    add_interface_port s0 axi4_fpga2hps_arlock arlock input 1
    add_interface_port s0 axi4_fpga2hps_arcache arcache input 4
    add_interface_port s0 axi4_fpga2hps_arprot arprot input 3
    add_interface_port s0 axi4_fpga2hps_arqos arqos input 4
    add_interface_port s0 axi4_fpga2hps_arvalid arvalid input 1
    add_interface_port s0 axi4_fpga2hps_arready arready output 1
    add_interface_port s0 axi4_fpga2hps_rid rid output 5
    add_interface_port s0 axi4_fpga2hps_rdata rdata output $F2H_DATA_WIDTH
    add_interface_port s0 axi4_fpga2hps_rresp rresp output 2
    add_interface_port s0 axi4_fpga2hps_rlast rlast output 1
    add_interface_port s0 axi4_fpga2hps_rvalid rvalid output 1
    add_interface_port s0 axi4_fpga2hps_rready rready input 1
    add_interface_port s0 axi4_fpga2hps_aruser aruser input 8
    add_interface_port s0 axi4_fpga2hps_awuser awuser input 8
    add_interface_port s0 axi4_fpga2hps_arregion arregion input 4
    add_interface_port s0 axi4_fpga2hps_awregion awregion input 4
    add_interface_port s0 axi4_fpga2hps_wuser wuser input 8
    add_interface_port s0 axi4_fpga2hps_buser buser output 8
    add_interface_port s0 axi4_fpga2hps_ruser ruser output 8

}
