#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2015-2020 Intel Corporation.
#
#****************************************************************************
#
# This script construct sub system of PCIe for higher level integration
# The GHRD create_ghrd_qsys.tcl will call each of those subsystem construct script
# automatically based on the corresponding parameter argument defined
#
#****************************************************************************

source ./design_config.tcl

if { ![ info exists devicefamily ] } {
  set devicefamily $DEVICE_FAMILY
} else {
  puts "-- Accepted parameter \$devicefamily = $devicefamily"
}
    
if { ![ info exists device ] } {
  set device $FPGA_DEVICE
} else {
  puts "-- Accepted parameter \$device = $device"
}

if { ![ info exists board_rev ] } {
  set board_rev $BOARD_REV
} else {
  puts "-- Accepted parameter \$board_rev = $board_rev"
}

if { ![ info exists pcie_gen ] } {
  set pcie_gen $GEN_ENABLE
} else {
  puts "-- Accepted parameter \$pcie_gen = $pcie_gen"
}

if { ![ info exists pcie_count ] } {
  set pcie_count $PCIE_COUNT
} else {
  puts "-- Accepted parameter \$pcie_count = $pcie_count"
}
    
if { ![ info exists sub_qsys_pcie ] } {
  set sub_qsys_pcie subsys_pcie
} else {
  puts "-- Accepted parameter \$sub_qsys_pcie = $sub_qsys_pcie"
}

package require -exact qsys 14.1

create_system $sub_qsys_pcie

    set_project_property DEVICE_FAMILY $devicefamily
    set_project_property DEVICE $device

    add_instance add_x_f2sdram altera_address_span_extender
    if {$board_rev == "A"} {
    set_instance_parameter_value add_x_f2sdram {DATA_WIDTH} {64}
    set_instance_parameter_value add_x_f2sdram {SLAVE_ADDRESS_WIDTH} {27}   
    } else {
        set_instance_parameter_value add_x_f2sdram {DATA_WIDTH} {128}
        set_instance_parameter_value add_x_f2sdram {SLAVE_ADDRESS_WIDTH} {26}
        }
    set_instance_parameter_value add_x_f2sdram {BURSTCOUNT_WIDTH} {6}
    set_instance_parameter_value add_x_f2sdram {MASTER_ADDRESS_WIDTH} {32}
    set_instance_parameter_value add_x_f2sdram {SUB_WINDOW_COUNT} {1}
    set_instance_parameter_value add_x_f2sdram {MASTER_ADDRESS_DEF} {0}
    set_instance_parameter_value add_x_f2sdram {ENABLE_SLAVE_PORT} {0}
    set_instance_parameter_value add_x_f2sdram {MAX_PENDING_READS} {16}

    if {$board_rev == "A"} {
    add_instance ccb_f2sdram altera_avalon_mm_clock_crossing_bridge
    set_instance_parameter_value ccb_f2sdram {DATA_WIDTH} {128}
    set_instance_parameter_value ccb_f2sdram {SYMBOL_WIDTH} {8}
    set_instance_parameter_value ccb_f2sdram {ADDRESS_WIDTH} {30}
    set_instance_parameter_value ccb_f2sdram {USE_AUTO_ADDRESS_WIDTH} {0}
    set_instance_parameter_value ccb_f2sdram {ADDRESS_UNITS} {SYMBOLS}
    set_instance_parameter_value ccb_f2sdram {MAX_BURST_SIZE} {32}
    set_instance_parameter_value ccb_f2sdram {COMMAND_FIFO_DEPTH} {4}
    set_instance_parameter_value ccb_f2sdram {RESPONSE_FIFO_DEPTH} {128}
    set_instance_parameter_value ccb_f2sdram {MASTER_SYNC_DEPTH} {2}
    set_instance_parameter_value ccb_f2sdram {SLAVE_SYNC_DEPTH} {2}
    }
    
    add_instance ccb_h2f altera_avalon_mm_clock_crossing_bridge
    set_instance_parameter_value ccb_h2f {DATA_WIDTH} {128}
    set_instance_parameter_value ccb_h2f {MAX_BURST_SIZE} {32}
    set_instance_parameter_value ccb_h2f {SYMBOL_WIDTH} {8}
    set_instance_parameter_value ccb_h2f {ADDRESS_WIDTH} {29}
    set_instance_parameter_value ccb_h2f {USE_AUTO_ADDRESS_WIDTH} {1}
    set_instance_parameter_value ccb_h2f {ADDRESS_UNITS} {SYMBOLS}
    set_instance_parameter_value ccb_h2f {COMMAND_FIFO_DEPTH} {4}
    set_instance_parameter_value ccb_h2f {RESPONSE_FIFO_DEPTH} {128}
    set_instance_parameter_value ccb_h2f {MASTER_SYNC_DEPTH} {2}
    set_instance_parameter_value ccb_h2f {SLAVE_SYNC_DEPTH} {2}

    add_instance clk_100 clock_source
    set_instance_parameter_value clk_100 {clockFrequency} {100000000.0}
    set_instance_parameter_value clk_100 {clockFrequencyKnown} {1}
    set_instance_parameter_value clk_100 {resetSynchronousEdges} {DEASSERT}

    if {$pcie_gen == 3 || $pcie_count == 8} {
    add_instance clk_125 altera_clock_bridge
    set_instance_parameter_value clk_125 {EXPLICIT_CLOCK_RATE} {125000000.0}
    set_instance_parameter_value clk_125 {NUM_CLOCK_OUTPUTS} {1}    
    }
    
    if {$board_rev == "A"} {
    add_instance clk_200 altera_clock_bridge
    set_instance_parameter_value clk_200 {EXPLICIT_CLOCK_RATE} {200000000.0}
    set_instance_parameter_value clk_200 {NUM_CLOCK_OUTPUTS} {1}
    }
    
    add_instance coreclk_fanout clock_source
    set_instance_parameter_value coreclk_fanout {clockFrequency} {125000000.0}
    set_instance_parameter_value coreclk_fanout {clockFrequencyKnown} {1}
    set_instance_parameter_value coreclk_fanout {resetSynchronousEdges} {DEASSERT}

    add_instance coreclk_out altera_clock_bridge
    if {$pcie_gen == 3 || $pcie_count == 8} {
    set_instance_parameter_value coreclk_out {EXPLICIT_CLOCK_RATE} {250000000.0}
    } else {
    set_instance_parameter_value coreclk_out {EXPLICIT_CLOCK_RATE} {125000000.0}
    }
    set_instance_parameter_value coreclk_out {NUM_CLOCK_OUTPUTS} {1}

    add_instance msgdma_0 altera_msgdma
    set_instance_parameter_value msgdma_0 {MODE} {0}
    if {$pcie_gen == 3 || $pcie_count == 8} {
    set_instance_parameter_value msgdma_0 {DATA_WIDTH} {256}
    set_instance_parameter_value msgdma_0 {MAX_BURST_COUNT} {16}
    } else {
    set_instance_parameter_value msgdma_0 {DATA_WIDTH} {128}
    set_instance_parameter_value msgdma_0 {MAX_BURST_COUNT} {32}
    }
    set_instance_parameter_value msgdma_0 {USE_FIX_ADDRESS_WIDTH} {0}
    set_instance_parameter_value msgdma_0 {FIX_ADDRESS_WIDTH} {32}
    set_instance_parameter_value msgdma_0 {DATA_FIFO_DEPTH} {256}
    set_instance_parameter_value msgdma_0 {DESCRIPTOR_FIFO_DEPTH} {8}
    set_instance_parameter_value msgdma_0 {RESPONSE_PORT} {2}
    set_instance_parameter_value msgdma_0 {MAX_BYTE} {524288}
    set_instance_parameter_value msgdma_0 {TRANSFER_TYPE} {Full Word Accesses Only}
    set_instance_parameter_value msgdma_0 {BURST_ENABLE} {1}
    set_instance_parameter_value msgdma_0 {BURST_WRAPPING_SUPPORT} {0}
    set_instance_parameter_value msgdma_0 {ENHANCED_FEATURES} {0}
    set_instance_parameter_value msgdma_0 {STRIDE_ENABLE} {0}
    set_instance_parameter_value msgdma_0 {MAX_STRIDE} {1}
    set_instance_parameter_value msgdma_0 {PROGRAMMABLE_BURST_ENABLE} {0}
    set_instance_parameter_value msgdma_0 {PACKET_ENABLE} {0}
    set_instance_parameter_value msgdma_0 {ERROR_ENABLE} {0}
    set_instance_parameter_value msgdma_0 {ERROR_WIDTH} {8}
    set_instance_parameter_value msgdma_0 {CHANNEL_ENABLE} {0}
    set_instance_parameter_value msgdma_0 {CHANNEL_WIDTH} {8}
    set_instance_parameter_value msgdma_0 {PREFETCHER_ENABLE} {0}
    set_instance_parameter_value msgdma_0 {PREFETCHER_READ_BURST_ENABLE} {0}
    set_instance_parameter_value msgdma_0 {PREFETCHER_DATA_WIDTH} {32}
    set_instance_parameter_value msgdma_0 {PREFETCHER_MAX_READ_BURST_COUNT} {2}

    add_instance msi_to_gic_gen_0 altera_msi_to_gic_gen
    set_instance_parameter_value msi_to_gic_gen_0 {MSG_DATA_WORD} {32}
    set_instance_parameter_value msi_to_gic_gen_0 {DATA_ENTRY_DEPTH} {4}
    set_instance_parameter_value msi_to_gic_gen_0 {MEMORY_TYPE} {RAM_BLOCK_TYPE=MLAB}

    add_instance nreset_status altera_reset_bridge
    set_instance_parameter_value nreset_status {ACTIVE_LOW_RESET} {1}
    set_instance_parameter_value nreset_status {SYNCHRONOUS_EDGES} {deassert}
    set_instance_parameter_value nreset_status {NUM_RESET_OUTPUTS} {1}
    set_instance_parameter_value nreset_status {USE_RESET_REQUEST} {0}

    add_instance pb_2_ocm altera_avalon_mm_bridge
    set_instance_parameter_value pb_2_ocm {DATA_WIDTH} {128}
    set_instance_parameter_value pb_2_ocm {MAX_BURST_SIZE} {32}
    set_instance_parameter_value pb_2_ocm {SYMBOL_WIDTH} {8}
    set_instance_parameter_value pb_2_ocm {ADDRESS_WIDTH} {18}
    set_instance_parameter_value pb_2_ocm {USE_AUTO_ADDRESS_WIDTH} {0}
    set_instance_parameter_value pb_2_ocm {ADDRESS_UNITS} {SYMBOLS}
    set_instance_parameter_value pb_2_ocm {MAX_PENDING_RESPONSES} {16}
    set_instance_parameter_value pb_2_ocm {LINEWRAPBURSTS} {0}
    set_instance_parameter_value pb_2_ocm {PIPELINE_COMMAND} {1}
    set_instance_parameter_value pb_2_ocm {PIPELINE_RESPONSE} {1}
    set_instance_parameter_value pb_2_ocm {USE_RESPONSE} {0}

    add_instance pb_lwh2f_pcie altera_avalon_mm_bridge
    set_instance_parameter_value pb_lwh2f_pcie {DATA_WIDTH} {32}
    set_instance_parameter_value pb_lwh2f_pcie {SYMBOL_WIDTH} {8}
    set_instance_parameter_value pb_lwh2f_pcie {ADDRESS_WIDTH} {10}
    set_instance_parameter_value pb_lwh2f_pcie {USE_AUTO_ADDRESS_WIDTH} {1}
    set_instance_parameter_value pb_lwh2f_pcie {ADDRESS_UNITS} {SYMBOLS}
    set_instance_parameter_value pb_lwh2f_pcie {MAX_BURST_SIZE} {1}
    set_instance_parameter_value pb_lwh2f_pcie {MAX_PENDING_RESPONSES} {1}
    set_instance_parameter_value pb_lwh2f_pcie {LINEWRAPBURSTS} {0}
    set_instance_parameter_value pb_lwh2f_pcie {PIPELINE_COMMAND} {1}
    set_instance_parameter_value pb_lwh2f_pcie {PIPELINE_RESPONSE} {1}
    set_instance_parameter_value pb_lwh2f_pcie {USE_RESPONSE} {0}

    add_instance pb_msgdma_2_txs altera_avalon_mm_bridge
    set_instance_parameter_value pb_msgdma_2_txs {DATA_WIDTH} {128}
    set_instance_parameter_value pb_msgdma_2_txs {MAX_BURST_SIZE} {32}
    set_instance_parameter_value pb_msgdma_2_txs {SYMBOL_WIDTH} {8}
    set_instance_parameter_value pb_msgdma_2_txs {ADDRESS_WIDTH} {29}
    set_instance_parameter_value pb_msgdma_2_txs {USE_AUTO_ADDRESS_WIDTH} {1}
    set_instance_parameter_value pb_msgdma_2_txs {ADDRESS_UNITS} {SYMBOLS}
    set_instance_parameter_value pb_msgdma_2_txs {MAX_PENDING_RESPONSES} {16}
    set_instance_parameter_value pb_msgdma_2_txs {LINEWRAPBURSTS} {0}
    set_instance_parameter_value pb_msgdma_2_txs {PIPELINE_COMMAND} {1}
    set_instance_parameter_value pb_msgdma_2_txs {PIPELINE_RESPONSE} {1}
    set_instance_parameter_value pb_msgdma_2_txs {USE_RESPONSE} {0}

    add_instance pb_rxm_2_msi altera_avalon_mm_bridge
    set_instance_parameter_value pb_rxm_2_msi {DATA_WIDTH} {32}
    set_instance_parameter_value pb_rxm_2_msi {SYMBOL_WIDTH} {8}
    set_instance_parameter_value pb_rxm_2_msi {ADDRESS_WIDTH} {7}
    set_instance_parameter_value pb_rxm_2_msi {USE_AUTO_ADDRESS_WIDTH} {1}
    set_instance_parameter_value pb_rxm_2_msi {ADDRESS_UNITS} {SYMBOLS}
    set_instance_parameter_value pb_rxm_2_msi {MAX_BURST_SIZE} {1}
    set_instance_parameter_value pb_rxm_2_msi {MAX_PENDING_RESPONSES} {2}
    set_instance_parameter_value pb_rxm_2_msi {LINEWRAPBURSTS} {0}
    set_instance_parameter_value pb_rxm_2_msi {PIPELINE_COMMAND} {1}
    set_instance_parameter_value pb_rxm_2_msi {PIPELINE_RESPONSE} {1}
    set_instance_parameter_value pb_rxm_2_msi {USE_RESPONSE} {0}

    add_instance pcie_a10_hip_avmm altera_pcie_a10_hip
    set_instance_parameter_value pcie_a10_hip_avmm {interface_type_hwtcl} {Avalon-MM}
    if {$pcie_gen == 3} {
        set_instance_parameter_value pcie_a10_hip_avmm {wrala_hwtcl} {2}
    } else {
        if {$pcie_count == 8} {
        set_instance_parameter_value pcie_a10_hip_avmm {wrala_hwtcl} {7}
        } else {
        set_instance_parameter_value pcie_a10_hip_avmm {wrala_hwtcl} {8}
        }
    }
    set_instance_parameter_value pcie_a10_hip_avmm {force_tag_checking_on_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {avmm_addr_width_hwtcl} {32}
    set_instance_parameter_value pcie_a10_hip_avmm {cb_pcie_mode_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {cb_pcie_rx_lite_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {cg_impl_cra_av_slave_port_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {cg_enable_advanced_interrupt_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {cg_enable_a2p_interrupt_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {enable_hip_status_for_avmm_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {internal_controller_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {enable_rxm_burst_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {extended_tag_support_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {user_txs_addr_width_hwtcl} {28}
    set_instance_parameter_value pcie_a10_hip_avmm {cg_a2p_addr_map_num_entries_hwtcl} {2}
    set_instance_parameter_value pcie_a10_hip_avmm {cg_a2p_addr_map_pass_thru_bits_hwtcl} {27}
    set_instance_parameter_value pcie_a10_hip_avmm {port_type_hwtcl} {Root port}
    set_instance_parameter_value pcie_a10_hip_avmm {pcie_spec_version_hwtcl} {3.0}
    set_instance_parameter_value pcie_a10_hip_avmm {rx_buffer_credit_alloc_hwtcl} {Balanced}
    set_instance_parameter_value pcie_a10_hip_avmm {rx_cred_ctl_param_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pll_refclk_freq_hwtcl} {100 MHz}
    set_instance_parameter_value pcie_a10_hip_avmm {enable_avst_reset_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {use_rx_st_be_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {use_ast_parity_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {multiple_packets_per_cycle_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {cvp_enable_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {use_tx_cons_cred_sel_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {cseb_config_bypass_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {cseb_autonomous_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {speed_change_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {hip_reconfig_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {xcvr_reconfig_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {export_fpll_output_to_top_level_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {export_phy_input_to_top_level_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {enable_lmi_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {adme_enable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {enable_devkit_conduit_hwtcl} {0}
    # set_instance_parameter_value pcie_a10_hip_avmm {select_design_example_hwtcl} {DMA}
    set_instance_parameter_value pcie_a10_hip_avmm {enable_example_design_qii_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {enable_example_design_sim_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {enable_example_design_synth_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {enable_example_design_tb_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {apps_type_hwtcl} {0}
    # set_instance_parameter_value pcie_a10_hip_avmm {select_design_example_rtl_lang_hwtcl} {Verilog}
    # set_instance_parameter_value pcie_a10_hip_avmm {targeted_devkit_hwtcl} {Arria 10 FPGA Development Kit}
    set_instance_parameter_value pcie_a10_hip_avmm {bar0_type_hwtcl} {64-bit prefetchable memory}
    set_instance_parameter_value pcie_a10_hip_avmm {bar0_address_width_hwtcl} {28}
    set_instance_parameter_value pcie_a10_hip_avmm {bar1_type_hwtcl} {Disabled}
    set_instance_parameter_value pcie_a10_hip_avmm {bar1_address_width_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {bar2_type_hwtcl} {Disabled}
    set_instance_parameter_value pcie_a10_hip_avmm {bar2_address_width_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {bar3_type_hwtcl} {Disabled}
    set_instance_parameter_value pcie_a10_hip_avmm {bar3_address_width_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {bar4_type_hwtcl} {Disabled}
    set_instance_parameter_value pcie_a10_hip_avmm {bar4_address_width_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {bar5_type_hwtcl} {Disabled}
    set_instance_parameter_value pcie_a10_hip_avmm {bar5_address_width_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {expansion_base_address_register_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {io_window_addr_width_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {prefetchable_mem_window_addr_width_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {vendor_id_hwtcl} {4466}
    set_instance_parameter_value pcie_a10_hip_avmm {device_id_hwtcl} {57344}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_vf_device_id_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {revision_id_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {class_code_hwtcl} {394240}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_subclass_code_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {subsystem_vendor_id_hwtcl} {4466}
    set_instance_parameter_value pcie_a10_hip_avmm {subsystem_device_id_hwtcl} {57344}
    set_instance_parameter_value pcie_a10_hip_avmm {maximum_payload_size_hwtcl} {256}
    set_instance_parameter_value pcie_a10_hip_avmm {extended_tag_field_hwtcl} {32}
    set_instance_parameter_value pcie_a10_hip_avmm {completion_timeout_hwtcl} {ABCD}
    set_instance_parameter_value pcie_a10_hip_avmm {completion_timeout_disable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {advance_error_reporting_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {ecrc_check_capable_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {ecrc_gen_capable_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {use_crc_forwarding_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {track_rxfc_cplbuf_ovf_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {port_link_number_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {dll_active_report_support_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {surprise_down_error_support_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {slot_clock_cfg_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {msi_multi_message_capable_hwtcl} {4}
    set_instance_parameter_value pcie_a10_hip_avmm {vsec_id_hwtcl} {4466}
    set_instance_parameter_value pcie_a10_hip_avmm {vsec_cap_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {user_id_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {enable_function_msix_support_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {msix_table_size_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {msix_table_offset_hwtcl} {0.0}
    set_instance_parameter_value pcie_a10_hip_avmm {msix_table_bir_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {msix_pba_offset_hwtcl} {0.0}
    set_instance_parameter_value pcie_a10_hip_avmm {msix_pba_bir_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {enable_slot_register_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {slot_power_scale_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {slot_power_limit_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {slot_number_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {endpoint_l0_latency_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {endpoint_l1_latency_hwtcl} {0}
    if {$pcie_gen == 3} {
    #solution for gen2 link speed when the pcie ip is configured to gen3 variant from qsys
    set_instance_parameter_value pcie_a10_hip_avmm {deemphasis_enable_hwtcl} {1}
    } else {
    set_instance_parameter_value pcie_a10_hip_avmm {deemphasis_enable_hwtcl} {0}
    }
    set_instance_parameter_value pcie_a10_hip_avmm {gen3_coeff_1_hwtcl} {8}
    set_instance_parameter_value pcie_a10_hip_avmm {bfm_drive_interface_clk_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {bfm_drive_interface_npor_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {bfm_drive_interface_pipe_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {bfm_drive_interface_control_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {serial_sim_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {enable_pipe32_phyip_ser_driver_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {cseb_extend_pci_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {cseb_extend_pcie_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {reserved_debug_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {sriov2_en} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {enable_custom_features_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_extra_bar_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_extra_bar_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {devhide_support_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {device_embedded_ep_support_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {total_pf_count_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_vf_count_user_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_vf_count_user_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_vf_count_user_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_vf_count_user_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {system_page_sizes_supported_hwtcl} {1363}
    set_instance_parameter_value pcie_a10_hip_avmm {sr_iov_support_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {ari_support_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {flr_capability_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf_tph_support_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_tph_int_mode_support_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_tph_dev_specific_mode_support_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_tph_st_table_location_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_tph_st_table_size_hwtcl} {63}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_tph_int_mode_support_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_tph_dev_specific_mode_support_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_tph_st_table_location_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_tph_st_table_size_hwtcl} {63}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_tph_int_mode_support_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_tph_dev_specific_mode_support_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_tph_st_table_location_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_tph_st_table_size_hwtcl} {63}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_tph_int_mode_support_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_tph_dev_specific_mode_support_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_tph_st_table_location_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_tph_st_table_size_hwtcl} {63}
    set_instance_parameter_value pcie_a10_hip_avmm {vf_tph_support_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_vf_tph_int_mode_support_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_vf_tph_dev_specific_mode_support_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_vf_tph_st_table_location_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_vf_tph_st_table_size_hwtcl} {63}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_vf_tph_int_mode_support_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_vf_tph_dev_specific_mode_support_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_vf_tph_st_table_location_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_vf_tph_st_table_size_hwtcl} {63}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_vf_tph_int_mode_support_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_vf_tph_dev_specific_mode_support_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_vf_tph_st_table_location_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_vf_tph_st_table_size_hwtcl} {63}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_vf_tph_int_mode_support_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_vf_tph_dev_specific_mode_support_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_vf_tph_st_table_location_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_vf_tph_st_table_size_hwtcl} {63}
    set_instance_parameter_value pcie_a10_hip_avmm {pf_ats_support_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_ats_invalidate_queue_depth_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_ats_invalidate_queue_depth_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_ats_invalidate_queue_depth_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_ats_invalidate_queue_depth_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {vf_ats_support_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_bar0_present_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_bar1_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_bar2_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_bar3_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_bar4_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_bar5_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_bar0_type_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_bar2_type_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_bar4_type_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_bar0_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_bar1_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_bar2_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_bar3_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_bar4_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_bar5_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_bar0_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_bar1_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_bar2_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_bar3_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_bar4_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_bar5_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_vf_bar0_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_vf_bar1_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_vf_bar2_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_vf_bar3_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_vf_bar4_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_vf_bar5_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_vf_bar0_type_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_vf_bar2_type_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_vf_bar4_type_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_vf_bar0_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_vf_bar1_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_vf_bar2_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_vf_bar3_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_vf_bar4_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_vf_bar5_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_vf_bar0_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_vf_bar1_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_vf_bar2_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_vf_bar3_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_vf_bar4_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_vf_bar5_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_bar0_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_bar1_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_bar2_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_bar3_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_bar4_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_bar5_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_bar0_type_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_bar2_type_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_bar4_type_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_bar0_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_bar1_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_bar2_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_bar3_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_bar4_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_bar5_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_bar0_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_bar1_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_bar2_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_bar3_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_bar4_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_bar5_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_vf_bar0_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_vf_bar1_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_vf_bar2_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_vf_bar3_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_vf_bar4_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_vf_bar5_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_vf_bar0_type_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_vf_bar2_type_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_vf_bar4_type_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_vf_bar0_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_vf_bar1_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_vf_bar2_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_vf_bar3_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_vf_bar4_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_vf_bar5_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_vf_bar0_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_vf_bar1_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_vf_bar2_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_vf_bar3_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_vf_bar4_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_vf_bar5_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_bar0_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_bar1_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_bar2_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_bar3_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_bar4_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_bar5_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_bar0_type_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_bar2_type_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_bar4_type_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_bar0_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_bar1_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_bar2_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_bar3_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_bar4_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_bar5_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_bar0_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_bar1_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_bar2_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_bar3_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_bar4_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_bar5_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_vf_bar0_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_vf_bar1_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_vf_bar2_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_vf_bar3_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_vf_bar4_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_vf_bar5_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_vf_bar0_type_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_vf_bar2_type_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_vf_bar4_type_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_vf_bar0_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_vf_bar1_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_vf_bar2_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_vf_bar3_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_vf_bar4_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_vf_bar5_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_vf_bar0_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_vf_bar1_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_vf_bar2_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_vf_bar3_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_vf_bar4_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_vf_bar5_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_bar0_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_bar1_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_bar2_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_bar3_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_bar4_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_bar5_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_bar0_type_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_bar2_type_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_bar4_type_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_bar0_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_bar1_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_bar2_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_bar3_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_bar4_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_bar5_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_bar0_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_bar1_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_bar2_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_bar3_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_bar4_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_bar5_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_vf_bar0_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_vf_bar1_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_vf_bar2_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_vf_bar3_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_vf_bar4_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_vf_bar5_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_vf_bar0_type_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_vf_bar2_type_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_vf_bar4_type_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_vf_bar0_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_vf_bar1_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_vf_bar2_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_vf_bar3_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_vf_bar4_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_vf_bar5_prefetchable_hwtcl} {1}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_vf_bar0_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_vf_bar1_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_vf_bar2_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_vf_bar3_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_vf_bar4_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_vf_bar5_size_hwtcl} {12}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_vendor_id_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_device_id_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_vf_device_id_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_revision_id_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_class_code_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_subclass_code_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_subsystem_vendor_id_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_subsystem_device_id_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_vendor_id_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_device_id_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_vf_device_id_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_revision_id_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_class_code_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_subclass_code_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_subsystem_vendor_id_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_subsystem_device_id_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_vendor_id_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_device_id_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_vf_device_id_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_revision_id_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_class_code_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_subclass_code_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_subsystem_vendor_id_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_subsystem_device_id_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf_msi_support_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_msi_multi_message_capable_hwtcl} {4}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_msi_multi_message_capable_hwtcl} {4}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_msi_multi_message_capable_hwtcl} {4}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_msi_multi_message_capable_hwtcl} {4}
    set_instance_parameter_value pcie_a10_hip_avmm {pf_enable_function_msix_support_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {vf_msix_cap_present_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_msix_table_size_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_msix_table_offset_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_msix_table_bir_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_msix_pba_offset_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_msix_pba_bir_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_msix_table_size_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_msix_table_offset_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_msix_table_bir_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_msix_pba_offset_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_msix_pba_bir_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_msix_table_size_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_msix_table_offset_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_msix_table_bir_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_msix_pba_offset_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_msix_pba_bir_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_msix_table_size_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_msix_table_offset_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_msix_table_bir_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_msix_pba_offset_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_msix_pba_bir_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_vf_msix_tbl_size_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_vf_msix_tbl_offset_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_vf_msix_tbl_bir_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_vf_msix_pba_offset_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_vf_msix_pba_bir_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_vf_msix_tbl_size_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_vf_msix_tbl_offset_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_vf_msix_tbl_bir_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_vf_msix_pba_offset_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_vf_msix_pba_bir_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_vf_msix_tbl_size_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_vf_msix_tbl_offset_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_vf_msix_tbl_bir_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_vf_msix_pba_offset_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_vf_msix_pba_bir_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_vf_msix_tbl_size_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_vf_msix_tbl_offset_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_vf_msix_tbl_bir_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_vf_msix_pba_offset_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_vf_msix_pba_bir_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_interrupt_pin_hwtcl} {inta}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_interrupt_pin_hwtcl} {inta}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_interrupt_pin_hwtcl} {inta}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_interrupt_pin_hwtcl} {inta}
    set_instance_parameter_value pcie_a10_hip_avmm {pf0_intr_line_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf1_intr_line_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf2_intr_line_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {pf3_intr_line_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {link2csr_width_hwtcl} {16}
    set_instance_parameter_value pcie_a10_hip_avmm {test_cseb_switch_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {message_level} {error}
    set_instance_parameter_value pcie_a10_hip_avmm {rx_polinv_soft_logic_enable} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {tlp_inspector_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {tlp_inspector_use_signal_probe_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {tlp_inspector_use_thin_rx_master} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {tlp_insp_trg_dw0_hwtcl} {2049}
    set_instance_parameter_value pcie_a10_hip_avmm {tlp_insp_trg_dw1_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {tlp_insp_trg_dw2_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {enable_ast_trs_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {ast_trs_num_desc_hwtcl} {16}
    set_instance_parameter_value pcie_a10_hip_avmm {ast_trs_txdata_width_hwtcl} {256}
    set_instance_parameter_value pcie_a10_hip_avmm {ast_trs_txdesc_width_hwtcl} {256}
    set_instance_parameter_value pcie_a10_hip_avmm {ast_trs_txstatus_width_hwtcl} {256}
    set_instance_parameter_value pcie_a10_hip_avmm {ast_trs_rxdata_width_hwtcl} {256}
    set_instance_parameter_value pcie_a10_hip_avmm {ast_trs_rxdesc_width_hwtcl} {256}
    set_instance_parameter_value pcie_a10_hip_avmm {ast_trs_txmty_width_hwtcl} {32}
    set_instance_parameter_value pcie_a10_hip_avmm {ast_trs_rxmty_width_hwtcl} {32}
    set_instance_parameter_value pcie_a10_hip_avmm {dma_use_scfifo_ext_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {use_dynamic_design_example_hwtcl} {0}
    set_instance_parameter_value pcie_a10_hip_avmm {use_rpbfm_pro} {0}

    add_instance performance_counter_0 altera_avalon_performance_counter
    set_instance_parameter_value performance_counter_0 {numberOfSections} {1}

    # connections and connection parameters
    add_connection pb_lwh2f_pcie.m0 performance_counter_0.control_slave 
    set_connection_parameter_value pb_lwh2f_pcie.m0/performance_counter_0.control_slave arbitrationPriority {1}
    set_connection_parameter_value pb_lwh2f_pcie.m0/performance_counter_0.control_slave baseAddress {0x40a0}
    set_connection_parameter_value pb_lwh2f_pcie.m0/performance_counter_0.control_slave defaultConnection {0}

    add_connection pb_lwh2f_pcie.m0 pcie_a10_hip_avmm.cra 
    set_connection_parameter_value pb_lwh2f_pcie.m0/pcie_a10_hip_avmm.cra arbitrationPriority {1}
    set_connection_parameter_value pb_lwh2f_pcie.m0/pcie_a10_hip_avmm.cra baseAddress {0x0000}
    set_connection_parameter_value pb_lwh2f_pcie.m0/pcie_a10_hip_avmm.cra defaultConnection {0}

    add_connection pb_lwh2f_pcie.m0 msgdma_0.csr 
    set_connection_parameter_value pb_lwh2f_pcie.m0/msgdma_0.csr arbitrationPriority {1}
    set_connection_parameter_value pb_lwh2f_pcie.m0/msgdma_0.csr baseAddress {0x40c0}
    set_connection_parameter_value pb_lwh2f_pcie.m0/msgdma_0.csr defaultConnection {0}

    add_connection pb_lwh2f_pcie.m0 msi_to_gic_gen_0.csr 
    set_connection_parameter_value pb_lwh2f_pcie.m0/msi_to_gic_gen_0.csr arbitrationPriority {1}
    set_connection_parameter_value pb_lwh2f_pcie.m0/msi_to_gic_gen_0.csr baseAddress {0x4080}
    set_connection_parameter_value pb_lwh2f_pcie.m0/msi_to_gic_gen_0.csr defaultConnection {0}

    add_connection pb_lwh2f_pcie.m0 msgdma_0.descriptor_slave 
    set_connection_parameter_value pb_lwh2f_pcie.m0/msgdma_0.descriptor_slave arbitrationPriority {1}
    set_connection_parameter_value pb_lwh2f_pcie.m0/msgdma_0.descriptor_slave baseAddress {0x40e0}
    set_connection_parameter_value pb_lwh2f_pcie.m0/msgdma_0.descriptor_slave defaultConnection {0}

    add_connection ccb_h2f.m0 pcie_a10_hip_avmm.txs 
    set_connection_parameter_value ccb_h2f.m0/pcie_a10_hip_avmm.txs arbitrationPriority {1}
    set_connection_parameter_value ccb_h2f.m0/pcie_a10_hip_avmm.txs baseAddress {0x0000}
    set_connection_parameter_value ccb_h2f.m0/pcie_a10_hip_avmm.txs defaultConnection {0}

    add_connection pb_msgdma_2_txs.m0 pcie_a10_hip_avmm.txs 
    set_connection_parameter_value pb_msgdma_2_txs.m0/pcie_a10_hip_avmm.txs arbitrationPriority {1}
    set_connection_parameter_value pb_msgdma_2_txs.m0/pcie_a10_hip_avmm.txs baseAddress {0x0000}
    set_connection_parameter_value pb_msgdma_2_txs.m0/pcie_a10_hip_avmm.txs defaultConnection {0}

    add_connection pb_lwh2f_pcie.m0 msi_to_gic_gen_0.vector_slave 
    set_connection_parameter_value pb_lwh2f_pcie.m0/msi_to_gic_gen_0.vector_slave arbitrationPriority {1}
    set_connection_parameter_value pb_lwh2f_pcie.m0/msi_to_gic_gen_0.vector_slave baseAddress {0x4000}
    set_connection_parameter_value pb_lwh2f_pcie.m0/msi_to_gic_gen_0.vector_slave defaultConnection {0}

    add_connection pb_rxm_2_msi.m0 msi_to_gic_gen_0.vector_slave 
    set_connection_parameter_value pb_rxm_2_msi.m0/msi_to_gic_gen_0.vector_slave arbitrationPriority {1}
    set_connection_parameter_value pb_rxm_2_msi.m0/msi_to_gic_gen_0.vector_slave baseAddress {0x4000}
    set_connection_parameter_value pb_rxm_2_msi.m0/msi_to_gic_gen_0.vector_slave defaultConnection {0}

    if {$board_rev == "A"} {
    add_connection ccb_f2sdram.m0 add_x_f2sdram.windowed_slave 
    set_connection_parameter_value ccb_f2sdram.m0/add_x_f2sdram.windowed_slave arbitrationPriority {1}
    set_connection_parameter_value ccb_f2sdram.m0/add_x_f2sdram.windowed_slave baseAddress {0x0000}
    set_connection_parameter_value ccb_f2sdram.m0/add_x_f2sdram.windowed_slave defaultConnection {0}
    
    add_connection msgdma_0.mm_read ccb_f2sdram.s0 
    set_connection_parameter_value msgdma_0.mm_read/ccb_f2sdram.s0 arbitrationPriority {1}
    set_connection_parameter_value msgdma_0.mm_read/ccb_f2sdram.s0 baseAddress {0x0000}
    set_connection_parameter_value msgdma_0.mm_read/ccb_f2sdram.s0 defaultConnection {0}

    add_connection msgdma_0.mm_write ccb_f2sdram.s0 
    set_connection_parameter_value msgdma_0.mm_write/ccb_f2sdram.s0 arbitrationPriority {1}
    set_connection_parameter_value msgdma_0.mm_write/ccb_f2sdram.s0 baseAddress {0x0000}
    set_connection_parameter_value msgdma_0.mm_write/ccb_f2sdram.s0 defaultConnection {0}
    
    add_connection pcie_a10_hip_avmm.rxm_bar0 ccb_f2sdram.s0 
    set_connection_parameter_value pcie_a10_hip_avmm.rxm_bar0/ccb_f2sdram.s0 arbitrationPriority {1}
    set_connection_parameter_value pcie_a10_hip_avmm.rxm_bar0/ccb_f2sdram.s0 baseAddress {0x0000}
    set_connection_parameter_value pcie_a10_hip_avmm.rxm_bar0/ccb_f2sdram.s0 defaultConnection {0}  
    
    add_connection pcie_a10_hip_avmm.coreclkout_hip ccb_f2sdram.s0_clk 

    add_connection clk_200.out_clk add_x_f2sdram.clock 

    add_connection clk_200.out_clk ccb_f2sdram.m0_clk 

    add_connection pcie_a10_hip_avmm.app_nreset_status ccb_f2sdram.m0_reset 

    add_connection pcie_a10_hip_avmm.app_nreset_status ccb_f2sdram.s0_reset 
    
    add_connection clk_100.clk_reset ccb_f2sdram.m0_reset   
   
    add_connection clk_100.clk_reset ccb_f2sdram.s0_reset 
    
    } else {
    add_connection msgdma_0.mm_read add_x_f2sdram.windowed_slave 
    set_connection_parameter_value msgdma_0.mm_read/add_x_f2sdram.windowed_slave arbitrationPriority {1}
    set_connection_parameter_value msgdma_0.mm_read/add_x_f2sdram.windowed_slave baseAddress {0x0000}
    set_connection_parameter_value msgdma_0.mm_read/add_x_f2sdram.windowed_slave defaultConnection {0}

    add_connection msgdma_0.mm_write add_x_f2sdram.windowed_slave 
    set_connection_parameter_value msgdma_0.mm_write/add_x_f2sdram.windowed_slave arbitrationPriority {1}
    set_connection_parameter_value msgdma_0.mm_write/add_x_f2sdram.windowed_slave baseAddress {0x0000}
    set_connection_parameter_value msgdma_0.mm_write/add_x_f2sdram.windowed_slave defaultConnection {0}

    add_connection pcie_a10_hip_avmm.rxm_bar0 add_x_f2sdram.windowed_slave 
    set_connection_parameter_value pcie_a10_hip_avmm.rxm_bar0/add_x_f2sdram.windowed_slave arbitrationPriority {1}
    set_connection_parameter_value pcie_a10_hip_avmm.rxm_bar0/add_x_f2sdram.windowed_slave baseAddress {0x0000}
    set_connection_parameter_value pcie_a10_hip_avmm.rxm_bar0/add_x_f2sdram.windowed_slave defaultConnection {0}
    
    add_connection pcie_a10_hip_avmm.coreclkout_hip add_x_f2sdram.clock 
    
    }
    
    add_connection msgdma_0.mm_read pb_msgdma_2_txs.s0 
    set_connection_parameter_value msgdma_0.mm_read/pb_msgdma_2_txs.s0 arbitrationPriority {1}
    set_connection_parameter_value msgdma_0.mm_read/pb_msgdma_2_txs.s0 baseAddress {0xd0000000}
    set_connection_parameter_value msgdma_0.mm_read/pb_msgdma_2_txs.s0 defaultConnection {0}

    add_connection msgdma_0.mm_read pb_2_ocm.s0 
    set_connection_parameter_value msgdma_0.mm_read/pb_2_ocm.s0 arbitrationPriority {1}
    set_connection_parameter_value msgdma_0.mm_read/pb_2_ocm.s0 baseAddress {0x40000000}
    set_connection_parameter_value msgdma_0.mm_read/pb_2_ocm.s0 defaultConnection {0}

    add_connection msgdma_0.mm_write pb_2_ocm.s0 
    set_connection_parameter_value msgdma_0.mm_write/pb_2_ocm.s0 arbitrationPriority {1}
    set_connection_parameter_value msgdma_0.mm_write/pb_2_ocm.s0 baseAddress {0x40000000}
    set_connection_parameter_value msgdma_0.mm_write/pb_2_ocm.s0 defaultConnection {0}

    add_connection msgdma_0.mm_write pb_msgdma_2_txs.s0 
    set_connection_parameter_value msgdma_0.mm_write/pb_msgdma_2_txs.s0 arbitrationPriority {1}
    set_connection_parameter_value msgdma_0.mm_write/pb_msgdma_2_txs.s0 baseAddress {0xd0000000}
    set_connection_parameter_value msgdma_0.mm_write/pb_msgdma_2_txs.s0 defaultConnection {0}   

    add_connection pcie_a10_hip_avmm.rxm_bar0 pb_rxm_2_msi.s0 
    set_connection_parameter_value pcie_a10_hip_avmm.rxm_bar0/pb_rxm_2_msi.s0 arbitrationPriority {1}
    set_connection_parameter_value pcie_a10_hip_avmm.rxm_bar0/pb_rxm_2_msi.s0 baseAddress {0xff210000}
    set_connection_parameter_value pcie_a10_hip_avmm.rxm_bar0/pb_rxm_2_msi.s0 defaultConnection {0}

    add_connection pcie_a10_hip_avmm.rxm_bar0 pb_2_ocm.s0 
    set_connection_parameter_value pcie_a10_hip_avmm.rxm_bar0/pb_2_ocm.s0 arbitrationPriority {1}
    set_connection_parameter_value pcie_a10_hip_avmm.rxm_bar0/pb_2_ocm.s0 baseAddress {0x40000000}
    set_connection_parameter_value pcie_a10_hip_avmm.rxm_bar0/pb_2_ocm.s0 defaultConnection {0}

   if {$pcie_gen == 3  || $pcie_count == 8} {
    add_connection clk_125.out_clk ccb_h2f.s0_clk 
    
    add_connection clk_125.out_clk msgdma_0.clock 

    #temporary feed to clk_100 due to dts generation issue

    # add_connection clk_125.out_clk performance_counter_0.clk 

    # add_connection clk_125.out_clk msi_to_gic_gen_0.clock  

    add_connection clk_100.clk performance_counter_0.clk 

    add_connection clk_100.clk msi_to_gic_gen_0.clock  
    } else {
    add_connection clk_100.clk ccb_h2f.s0_clk
    
    add_connection pcie_a10_hip_avmm.coreclkout_hip msgdma_0.clock

    #temporary feed to clk_100 due to dts generation issue
    
    # add_connection pcie_a10_hip_avmm.coreclkout_hip performance_counter_0.clk 

    # add_connection pcie_a10_hip_avmm.coreclkout_hip msi_to_gic_gen_0.clock 
        
    add_connection clk_100.clk performance_counter_0.clk 

    add_connection clk_100.clk msi_to_gic_gen_0.clock  
    }
    
    add_connection pcie_a10_hip_avmm.coreclkout_hip nreset_status.clk 

    add_connection pcie_a10_hip_avmm.coreclkout_hip pb_lwh2f_pcie.clk   

    add_connection pcie_a10_hip_avmm.coreclkout_hip pb_rxm_2_msi.clk 

    add_connection pcie_a10_hip_avmm.coreclkout_hip pb_msgdma_2_txs.clk 

    add_connection pcie_a10_hip_avmm.coreclkout_hip pb_2_ocm.clk 

    add_connection pcie_a10_hip_avmm.coreclkout_hip coreclk_fanout.clk_in 

    add_connection pcie_a10_hip_avmm.coreclkout_hip coreclk_out.in_clk 

    add_connection pcie_a10_hip_avmm.coreclkout_hip ccb_h2f.m0_clk 

    add_connection pcie_a10_hip_avmm.app_nreset_status coreclk_fanout.clk_in_reset 

    add_connection pcie_a10_hip_avmm.app_nreset_status nreset_status.in_reset 

    add_connection pcie_a10_hip_avmm.app_nreset_status pb_rxm_2_msi.reset 

    add_connection pcie_a10_hip_avmm.app_nreset_status pb_lwh2f_pcie.reset 

    add_connection pcie_a10_hip_avmm.app_nreset_status pb_msgdma_2_txs.reset 

    add_connection pcie_a10_hip_avmm.app_nreset_status pb_2_ocm.reset 

    add_connection pcie_a10_hip_avmm.app_nreset_status add_x_f2sdram.reset 

    add_connection pcie_a10_hip_avmm.app_nreset_status performance_counter_0.reset 

    add_connection pcie_a10_hip_avmm.app_nreset_status msi_to_gic_gen_0.reset 

    add_connection pcie_a10_hip_avmm.app_nreset_status msgdma_0.reset_n 

    add_connection pcie_a10_hip_avmm.app_nreset_status ccb_h2f.s0_reset 
    
    add_connection pcie_a10_hip_avmm.app_nreset_status ccb_h2f.m0_reset 
    
    add_connection clk_100.clk_reset pb_msgdma_2_txs.reset

    add_connection clk_100.clk_reset ccb_h2f.m0_reset 

    add_connection clk_100.clk_reset add_x_f2sdram.reset 

    add_connection clk_100.clk_reset msi_to_gic_gen_0.reset 

    add_connection clk_100.clk_reset performance_counter_0.reset 

    add_connection clk_100.clk_reset pb_rxm_2_msi.reset 

    add_connection clk_100.clk_reset pb_lwh2f_pcie.reset 

    add_connection clk_100.clk_reset pb_2_ocm.reset 

    add_connection clk_100.clk_reset msgdma_0.reset_n 

    add_connection clk_100.clk_reset ccb_h2f.s0_reset 

    # exported interfaces
    if {$pcie_gen == 3 || $pcie_count == 8} {
    add_interface clk_125_in_clk clock sink
    set_interface_property clk_125_in_clk EXPORT_OF clk_125.in_clk
    }
    add_interface address_span_extender_0_expanded_master avalon master
    set_interface_property address_span_extender_0_expanded_master EXPORT_OF add_x_f2sdram.expanded_master
    add_interface ccb_h2f_s0 avalon slave
    set_interface_property ccb_h2f_s0 EXPORT_OF ccb_h2f.s0
    add_interface clk clock sink
    set_interface_property clk EXPORT_OF clk_100.clk_in
    if {$board_rev == "A"} {   
    add_interface clk_200_in_clk clock sink
    set_interface_property clk_200_in_clk EXPORT_OF clk_200.in_clk
    }
    add_interface coreclk_fanout_clk clock source
    set_interface_property coreclk_fanout_clk EXPORT_OF coreclk_fanout.clk
    add_interface coreclk_fanout_clk_reset reset source
    set_interface_property coreclk_fanout_clk_reset EXPORT_OF coreclk_fanout.clk_reset
    add_interface coreclkout_out clock source
    set_interface_property coreclkout_out EXPORT_OF coreclk_out.out_clk
    add_interface msgdma_0_csr_irq interrupt sender
    set_interface_property msgdma_0_csr_irq EXPORT_OF msgdma_0.csr_irq
    add_interface msi_to_gic_gen_0_interrupt_sender interrupt sender
    set_interface_property msi_to_gic_gen_0_interrupt_sender EXPORT_OF msi_to_gic_gen_0.interrupt_sender
    add_interface nreset_status_out_reset reset source
    set_interface_property nreset_status_out_reset EXPORT_OF nreset_status.out_reset
    add_interface pb_2_ocm_m0 avalon master
    set_interface_property pb_2_ocm_m0 EXPORT_OF pb_2_ocm.m0
    add_interface pb_lwh2f_pcie_s0 avalon slave
    set_interface_property pb_lwh2f_pcie_s0 EXPORT_OF pb_lwh2f_pcie.s0
    add_interface pcie_a10_hip_avmm_cra_irq interrupt sender
    set_interface_property pcie_a10_hip_avmm_cra_irq EXPORT_OF pcie_a10_hip_avmm.cra_irq
    add_interface pcie_a10_hip_avmm_currentspeed conduit end
    set_interface_property pcie_a10_hip_avmm_currentspeed EXPORT_OF pcie_a10_hip_avmm.currentspeed
    add_interface pcie_a10_hip_avmm_hip_ctrl conduit end
    set_interface_property pcie_a10_hip_avmm_hip_ctrl EXPORT_OF pcie_a10_hip_avmm.hip_ctrl
    add_interface pcie_a10_hip_avmm_hip_pipe conduit end
    set_interface_property pcie_a10_hip_avmm_hip_pipe EXPORT_OF pcie_a10_hip_avmm.hip_pipe
    add_interface pcie_a10_hip_avmm_hip_serial conduit end
    set_interface_property pcie_a10_hip_avmm_hip_serial EXPORT_OF pcie_a10_hip_avmm.hip_serial
    add_interface pcie_a10_hip_avmm_hip_status conduit end
    set_interface_property pcie_a10_hip_avmm_hip_status EXPORT_OF pcie_a10_hip_avmm.hip_status
    add_interface pcie_a10_hip_avmm_npor conduit end
    set_interface_property pcie_a10_hip_avmm_npor EXPORT_OF pcie_a10_hip_avmm.npor
    add_interface pcie_a10_hip_avmm_refclk clock sink
    set_interface_property pcie_a10_hip_avmm_refclk EXPORT_OF pcie_a10_hip_avmm.refclk
    add_interface pcie_a10_hip_avmm_rxm_irq interrupt receiver
    set_interface_property pcie_a10_hip_avmm_rxm_irq EXPORT_OF pcie_a10_hip_avmm.rxm_irq
    add_interface reset reset sink
    set_interface_property reset EXPORT_OF clk_100.clk_in_reset

    # interconnect requirements
    set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {AUTO}
    set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}
    set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
    set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
    if {$pcie_gen == 3 || $pcie_count == 8} {
    set_interconnect_requirement {mm_interconnect_2|async_fifo_005.out/cmd_mux_002.sink1} {qsys_mm.postTransform.pipelineCount} {1}
    set_interconnect_requirement {mm_interconnect_2|cmd_mux_002.src/add_x_f2sdram_windowed_slave_agent.cp} {qsys_mm.postTransform.pipelineCount} {1}
    set_interconnect_requirement {mm_interconnect_2|router_002.src/pcie_a10_hip_avmm_rxm_bar0_limiter.cmd_sink} {qsys_mm.postTransform.pipelineCount} {1}
    }   
save_system ${sub_qsys_pcie}.qsys
