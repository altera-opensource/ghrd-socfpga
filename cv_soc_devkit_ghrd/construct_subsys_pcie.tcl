#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2016-2020 Intel Corporation.
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
    set_instance_parameter_value add_x_f2sdram {MASTER_ADDRESS_WIDTH} {32}
    set_instance_parameter_value add_x_f2sdram {DATA_WIDTH} {256}
    set_instance_parameter_value add_x_f2sdram {SLAVE_ADDRESS_WIDTH} {25}
    set_instance_parameter_value add_x_f2sdram {BURSTCOUNT_WIDTH} {8}
    set_instance_parameter_value add_x_f2sdram {SUB_WINDOW_COUNT} {1}
    set_instance_parameter_value add_x_f2sdram {MASTER_ADDRESS_DEF} {0}
    set_instance_parameter_value add_x_f2sdram {ENABLE_SLAVE_PORT} {0}
    set_instance_parameter_value add_x_f2sdram {MAX_PENDING_READS} {16}

    add_instance alt_xcvr_reconfig_0 alt_xcvr_reconfig
    set_instance_parameter_value alt_xcvr_reconfig_0 {number_of_reconfig_interfaces} {5}
    set_instance_parameter_value alt_xcvr_reconfig_0 {gui_split_sizes} {}
    set_instance_parameter_value alt_xcvr_reconfig_0 {enable_offset} {1}
    set_instance_parameter_value alt_xcvr_reconfig_0 {enable_dcd} {0}
    set_instance_parameter_value alt_xcvr_reconfig_0 {enable_dcd_power_up} {1}
    set_instance_parameter_value alt_xcvr_reconfig_0 {enable_analog} {1}
    set_instance_parameter_value alt_xcvr_reconfig_0 {enable_eyemon} {0}
    set_instance_parameter_value alt_xcvr_reconfig_0 {ber_en} {0}
    set_instance_parameter_value alt_xcvr_reconfig_0 {enable_dfe} {0}
    set_instance_parameter_value alt_xcvr_reconfig_0 {enable_adce} {0}
    set_instance_parameter_value alt_xcvr_reconfig_0 {enable_mif} {0}
    set_instance_parameter_value alt_xcvr_reconfig_0 {gui_enable_pll} {0}
    set_instance_parameter_value alt_xcvr_reconfig_0 {gui_cal_status_port} {0}

    add_instance ccb_h2f altera_avalon_mm_clock_crossing_bridge
    set_instance_parameter_value ccb_h2f {DATA_WIDTH} {64}
    set_instance_parameter_value ccb_h2f {SYMBOL_WIDTH} {8}
    set_instance_parameter_value ccb_h2f {ADDRESS_WIDTH} {29}
    set_instance_parameter_value ccb_h2f {USE_AUTO_ADDRESS_WIDTH} {1}
    set_instance_parameter_value ccb_h2f {ADDRESS_UNITS} {SYMBOLS}
    set_instance_parameter_value ccb_h2f {MAX_BURST_SIZE} {64}
    set_instance_parameter_value ccb_h2f {COMMAND_FIFO_DEPTH} {4}
    set_instance_parameter_value ccb_h2f {RESPONSE_FIFO_DEPTH} {128}
    set_instance_parameter_value ccb_h2f {MASTER_SYNC_DEPTH} {2}
    set_instance_parameter_value ccb_h2f {SLAVE_SYNC_DEPTH} {2}

    add_instance clk clock_source
    set_instance_parameter_value clk {clockFrequency} {50000000.0}
    set_instance_parameter_value clk {clockFrequencyKnown} {1}
    set_instance_parameter_value clk {resetSynchronousEdges} {NONE}

    add_instance coreclk_fanout clock_source
    set_instance_parameter_value coreclk_fanout {clockFrequency} {125000000.0}
    set_instance_parameter_value coreclk_fanout {clockFrequencyKnown} {1}
    set_instance_parameter_value coreclk_fanout {resetSynchronousEdges} {DEASSERT}

    add_instance coreclkout_125 altera_clock_bridge
    set_instance_parameter_value coreclkout_125 {EXPLICIT_CLOCK_RATE} {125000000.0}
    set_instance_parameter_value coreclkout_125 {NUM_CLOCK_OUTPUTS} {1}

    add_instance custom_reset_synchronizer_0 custom_reset_synchronizer
    set_instance_parameter_value custom_reset_synchronizer_0 {INPUT_CLOCK_FREQUENCY} {125000000}
    set_instance_parameter_value custom_reset_synchronizer_0 {INPUT_CLOCK_KNOWN} {1}
    set_instance_parameter_value custom_reset_synchronizer_0 {SYNC_DEPTH} {3}
    set_instance_parameter_value custom_reset_synchronizer_0 {ADDITIONAL_DEPTH} {10}
    set_instance_parameter_value custom_reset_synchronizer_0 {DISABLE_GLOBAL_NETWORK} {1}
    set_instance_parameter_value custom_reset_synchronizer_0 {SYNC_BOTH_EDGES} {0}

    add_instance msgdma_0 altera_msgdma
    set_instance_parameter_value msgdma_0 {MODE} {0}
    if {$devicefamily == "CYCLONEV"} {
    set_instance_parameter_value msgdma_0 {DATA_WIDTH} {64}
    set_instance_parameter_value msgdma_0 {MAX_BURST_COUNT} {64}
    } else {
    #Arria V 
    set_instance_parameter_value msgdma_0 {DATA_WIDTH} {128}
    set_instance_parameter_value msgdma_0 {MAX_BURST_COUNT} {32}
    }
    set_instance_parameter_value msgdma_0 {USE_FIX_ADDRESS_WIDTH} {0}
    set_instance_parameter_value msgdma_0 {FIX_ADDRESS_WIDTH} {32}
    set_instance_parameter_value msgdma_0 {EXPOSE_ST_PORT} {0}
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
    if {$devicefamily == "CYCLONEV"} {
    set_instance_parameter_value pb_2_ocm {DATA_WIDTH} {64}
    set_instance_parameter_value pb_2_ocm {MAX_BURST_SIZE} {64}
    set_instance_parameter_value pb_2_ocm {MAX_PENDING_RESPONSES} {4}
    } else {
    #Arria V 
    set_instance_parameter_value pb_2_ocm {DATA_WIDTH} {128}
    set_instance_parameter_value pb_2_ocm {MAX_BURST_SIZE} {32}
    set_instance_parameter_value pb_2_ocm {MAX_PENDING_RESPONSES} {16}
    }
    set_instance_parameter_value pb_2_ocm {SYMBOL_WIDTH} {8}
    set_instance_parameter_value pb_2_ocm {ADDRESS_WIDTH} {10}
    set_instance_parameter_value pb_2_ocm {USE_AUTO_ADDRESS_WIDTH} {1}
    set_instance_parameter_value pb_2_ocm {ADDRESS_UNITS} {SYMBOLS}
    set_instance_parameter_value pb_2_ocm {LINEWRAPBURSTS} {0}
    set_instance_parameter_value pb_2_ocm {PIPELINE_COMMAND} {1}
    set_instance_parameter_value pb_2_ocm {PIPELINE_RESPONSE} {1}
    set_instance_parameter_value pb_2_ocm {USE_RESPONSE} {0}

    add_instance pb_f2sdram altera_avalon_mm_bridge
    if {$devicefamily == "CYCLONEV"} {
    set_instance_parameter_value pb_f2sdram {DATA_WIDTH} {64}
    set_instance_parameter_value pb_f2sdram {MAX_BURST_SIZE} {64}
    set_instance_parameter_value pb_f2sdram {MAX_PENDING_RESPONSES} {4}
    } else {
    #Arria V 
    set_instance_parameter_value pb_f2sdram {DATA_WIDTH} {128}
    set_instance_parameter_value pb_f2sdram {MAX_BURST_SIZE} {32}
    set_instance_parameter_value pb_f2sdram {MAX_PENDING_RESPONSES} {16}
    }
    set_instance_parameter_value pb_f2sdram {SYMBOL_WIDTH} {8}
    set_instance_parameter_value pb_f2sdram {ADDRESS_WIDTH} {30}
    set_instance_parameter_value pb_f2sdram {USE_AUTO_ADDRESS_WIDTH} {0}
    set_instance_parameter_value pb_f2sdram {ADDRESS_UNITS} {SYMBOLS}
    set_instance_parameter_value pb_f2sdram {LINEWRAPBURSTS} {0}
    set_instance_parameter_value pb_f2sdram {PIPELINE_COMMAND} {1}
    set_instance_parameter_value pb_f2sdram {PIPELINE_RESPONSE} {1}
    set_instance_parameter_value pb_f2sdram {USE_RESPONSE} {0}

    add_instance pb_lwh2f_pcie altera_avalon_mm_bridge
    set_instance_parameter_value pb_lwh2f_pcie {DATA_WIDTH} {32}
    set_instance_parameter_value pb_lwh2f_pcie {SYMBOL_WIDTH} {8}
    set_instance_parameter_value pb_lwh2f_pcie {ADDRESS_WIDTH} {15}
    set_instance_parameter_value pb_lwh2f_pcie {USE_AUTO_ADDRESS_WIDTH} {0}
    set_instance_parameter_value pb_lwh2f_pcie {ADDRESS_UNITS} {SYMBOLS}
    set_instance_parameter_value pb_lwh2f_pcie {MAX_BURST_SIZE} {1}
    set_instance_parameter_value pb_lwh2f_pcie {MAX_PENDING_RESPONSES} {1}
    set_instance_parameter_value pb_lwh2f_pcie {LINEWRAPBURSTS} {0}
    set_instance_parameter_value pb_lwh2f_pcie {PIPELINE_COMMAND} {1}
    set_instance_parameter_value pb_lwh2f_pcie {PIPELINE_RESPONSE} {1}
    set_instance_parameter_value pb_lwh2f_pcie {USE_RESPONSE} {0}

    add_instance pb_msgdma_2_txs altera_avalon_mm_bridge
    if {$devicefamily == "CYCLONEV"} {
    set_instance_parameter_value pb_msgdma_2_txs {DATA_WIDTH} {64}
    set_instance_parameter_value pb_msgdma_2_txs {MAX_BURST_SIZE} {64}
    set_instance_parameter_value pb_msgdma_2_txs {MAX_PENDING_RESPONSES} {4}
    } else {
    #Arria V 
    set_instance_parameter_value pb_msgdma_2_txs {DATA_WIDTH} {128}
    set_instance_parameter_value pb_msgdma_2_txs {MAX_BURST_SIZE} {32}
    set_instance_parameter_value pb_msgdma_2_txs {MAX_PENDING_RESPONSES} {16}
    }
    set_instance_parameter_value pb_msgdma_2_txs {SYMBOL_WIDTH} {8}
    set_instance_parameter_value pb_msgdma_2_txs {ADDRESS_WIDTH} {28}
    set_instance_parameter_value pb_msgdma_2_txs {USE_AUTO_ADDRESS_WIDTH} {1}
    set_instance_parameter_value pb_msgdma_2_txs {ADDRESS_UNITS} {SYMBOLS}
    set_instance_parameter_value pb_msgdma_2_txs {LINEWRAPBURSTS} {0}
    set_instance_parameter_value pb_msgdma_2_txs {PIPELINE_COMMAND} {1}
    set_instance_parameter_value pb_msgdma_2_txs {PIPELINE_RESPONSE} {1}
    set_instance_parameter_value pb_msgdma_2_txs {USE_RESPONSE} {0}

    add_instance pb_rxm_2_msi altera_avalon_mm_bridge
    set_instance_parameter_value pb_rxm_2_msi {DATA_WIDTH} {32}
    set_instance_parameter_value pb_rxm_2_msi {SYMBOL_WIDTH} {8}
    set_instance_parameter_value pb_rxm_2_msi {ADDRESS_WIDTH} {15}
    set_instance_parameter_value pb_rxm_2_msi {USE_AUTO_ADDRESS_WIDTH} {1}
    set_instance_parameter_value pb_rxm_2_msi {ADDRESS_UNITS} {SYMBOLS}
    set_instance_parameter_value pb_rxm_2_msi {MAX_BURST_SIZE} {1}
    set_instance_parameter_value pb_rxm_2_msi {MAX_PENDING_RESPONSES} {2}
    set_instance_parameter_value pb_rxm_2_msi {LINEWRAPBURSTS} {0}
    set_instance_parameter_value pb_rxm_2_msi {PIPELINE_COMMAND} {1}
    set_instance_parameter_value pb_rxm_2_msi {PIPELINE_RESPONSE} {1}
    set_instance_parameter_value pb_rxm_2_msi {USE_RESPONSE} {0}

    if {$devicefamily == "CYCLONEV"} {
    add_instance pcie_hip_avmm altera_pcie_cv_hip_avmm
    set_instance_parameter_value pcie_hip_avmm {pcie_qsys} {1}
    set_instance_parameter_value pcie_hip_avmm {altpcie_avmm_hwtcl} {1}
    set_instance_parameter_value pcie_hip_avmm {lane_mask_hwtcl} {x4}
    set_instance_parameter_value pcie_hip_avmm {gen123_lane_rate_mode_hwtcl} {Gen1 (2.5 Gbps)}
    set_instance_parameter_value pcie_hip_avmm {port_type_hwtcl} {Root port}
    set_instance_parameter_value pcie_hip_avmm {rxbuffer_rxreq_hwtcl} {Balanced}
    set_instance_parameter_value pcie_hip_avmm {pll_refclk_freq_hwtcl} {100 MHz}
    set_instance_parameter_value pcie_hip_avmm {set_pld_clk_x1_625MHz_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {in_cvp_mode_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {NUM_PREFETCH_MASTERS} {1}
    set_instance_parameter_value pcie_hip_avmm {bar0_type_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {bar1_type_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {bar2_type_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {bar3_type_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {bar4_type_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {bar5_type_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_P2A_AVALON_ADDR_B0} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_P2A_AVALON_ADDR_B1} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_P2A_AVALON_ADDR_B2} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_P2A_AVALON_ADDR_B3} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_P2A_AVALON_ADDR_B4} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_P2A_AVALON_ADDR_B5} {0}
    set_instance_parameter_value pcie_hip_avmm {fixed_address_mode} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_P2A_FIXED_AVALON_ADDR_B0} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_P2A_FIXED_AVALON_ADDR_B1} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_P2A_FIXED_AVALON_ADDR_B2} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_P2A_FIXED_AVALON_ADDR_B3} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_P2A_FIXED_AVALON_ADDR_B4} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_P2A_FIXED_AVALON_ADDR_B5} {0}
    set_instance_parameter_value pcie_hip_avmm {vendor_id_hwtcl} {4466}
    set_instance_parameter_value pcie_hip_avmm {device_id_hwtcl} {57344}
    set_instance_parameter_value pcie_hip_avmm {revision_id_hwtcl} {1}
    set_instance_parameter_value pcie_hip_avmm {class_code_hwtcl} {394240}
    set_instance_parameter_value pcie_hip_avmm {subsystem_vendor_id_hwtcl} {4466}
    set_instance_parameter_value pcie_hip_avmm {subsystem_device_id_hwtcl} {57344}
    set_instance_parameter_value pcie_hip_avmm {max_payload_size_hwtcl} {256}
    set_instance_parameter_value pcie_hip_avmm {extend_tag_field_hwtcl} {32}
    set_instance_parameter_value pcie_hip_avmm {completion_timeout_hwtcl} {ABCD}
    set_instance_parameter_value pcie_hip_avmm {enable_completion_timeout_disable_hwtcl} {1}
    set_instance_parameter_value pcie_hip_avmm {use_aer_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {ecrc_check_capable_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {ecrc_gen_capable_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {use_crc_forwarding_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {port_link_number_hwtcl} {1}
    set_instance_parameter_value pcie_hip_avmm {dll_active_report_support_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {surprise_down_error_support_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {slotclkcfg_hwtcl} {1}
    set_instance_parameter_value pcie_hip_avmm {msi_multi_message_capable_hwtcl} {4}
    set_instance_parameter_value pcie_hip_avmm {msi_64bit_addressing_capable_hwtcl} {true}
    set_instance_parameter_value pcie_hip_avmm {msi_masking_capable_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {msi_support_hwtcl} {true}
    set_instance_parameter_value pcie_hip_avmm {enable_function_msix_support_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {msix_table_size_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {msix_table_offset_hwtcl} {0.0}
    set_instance_parameter_value pcie_hip_avmm {msix_table_bir_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {msix_pba_offset_hwtcl} {0.0}
    set_instance_parameter_value pcie_hip_avmm {msix_pba_bir_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {enable_slot_register_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {slot_power_scale_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {slot_power_limit_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {slot_number_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {endpoint_l0_latency_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {endpoint_l1_latency_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {vsec_id_hwtcl} {40960}
    set_instance_parameter_value pcie_hip_avmm {vsec_rev_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {user_id_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {CG_COMMON_CLOCK_MODE} {1}
    set_instance_parameter_value pcie_hip_avmm {avmm_width_hwtcl} {64}
    set_instance_parameter_value pcie_hip_avmm {AVALON_ADDR_WIDTH} {32}
    set_instance_parameter_value pcie_hip_avmm {CB_PCIE_MODE} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_PCIE_RX_LITE} {0}
    set_instance_parameter_value pcie_hip_avmm {AST_LITE} {0}
    set_instance_parameter_value pcie_hip_avmm {CG_RXM_IRQ_NUM} {16}
    set_instance_parameter_value pcie_hip_avmm {bypass_tl} {false}
    set_instance_parameter_value pcie_hip_avmm {CG_IMPL_CRA_AV_SLAVE_PORT} {1}
    set_instance_parameter_value pcie_hip_avmm {CG_ENABLE_ADVANCED_INTERRUPT} {0}
    set_instance_parameter_value pcie_hip_avmm {CG_ENABLE_A2P_INTERRUPT} {0}
    set_instance_parameter_value pcie_hip_avmm {CG_ENABLE_HIP_STATUS} {0}
    set_instance_parameter_value pcie_hip_avmm {CG_ENABLE_HIP_STATUS_EXTENSION} {0}
    set_instance_parameter_value pcie_hip_avmm {TX_S_ADDR_WIDTH} {32}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_IS_FIXED} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_NUM_ENTRIES} {2}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_PASS_THRU_BITS} {27}
    set_instance_parameter_value pcie_hip_avmm {BYPASSS_A2P_TRANSLATION} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_RP_S_ADDR_WIDTH} {32}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_0_HIGH} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_0_LOW} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_1_HIGH} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_1_LOW} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_2_HIGH} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_2_LOW} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_3_HIGH} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_3_LOW} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_4_HIGH} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_4_LOW} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_5_HIGH} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_5_LOW} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_6_HIGH} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_6_LOW} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_7_HIGH} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_7_LOW} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_8_HIGH} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_8_LOW} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_9_HIGH} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_9_LOW} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_10_HIGH} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_10_LOW} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_11_HIGH} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_11_LOW} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_12_HIGH} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_12_LOW} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_13_HIGH} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_13_LOW} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_14_HIGH} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_14_LOW} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_15_HIGH} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_15_LOW} {0}
    set_instance_parameter_value pcie_hip_avmm {AddressPage} {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}
    set_instance_parameter_value pcie_hip_avmm {PCIeAddress63_32} {0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000}
    set_instance_parameter_value pcie_hip_avmm {PCIeAddress31_0} {0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000}
    set_instance_parameter_value pcie_hip_avmm {RXM_DATA_WIDTH} {64}
    set_instance_parameter_value pcie_hip_avmm {RXM_BEN_WIDTH} {8}
    set_instance_parameter_value pcie_hip_avmm {use_rx_st_be_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {use_ast_parity} {0}
    set_instance_parameter_value pcie_hip_avmm {force_hrc} {0}
    set_instance_parameter_value pcie_hip_avmm {force_src} {0}
    set_instance_parameter_value pcie_hip_avmm {bypass_cdc_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {wrong_device_id_hwtcl} {disable}
    set_instance_parameter_value pcie_hip_avmm {data_pack_rx_hwtcl} {disable}
    set_instance_parameter_value pcie_hip_avmm {ltssm_1ms_timeout_hwtcl} {disable}
    set_instance_parameter_value pcie_hip_avmm {ltssm_freqlocked_check_hwtcl} {disable}
    set_instance_parameter_value pcie_hip_avmm {deskew_comma_hwtcl} {skp_eieos_deskw}
    set_instance_parameter_value pcie_hip_avmm {maximum_current_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {disable_snoop_packet_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {enable_l0s_aspm_hwtcl} {true}
    set_instance_parameter_value pcie_hip_avmm {extended_tag_reset_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {interrupt_pin_hwtcl} {inta}
    set_instance_parameter_value pcie_hip_avmm {bridge_port_vga_enable_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {bridge_port_ssid_support_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {ssvid_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {ssid_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {atomic_op_routing_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {atomic_op_completer_32bit_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {atomic_op_completer_64bit_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {cas_completer_128bit_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {ltr_mechanism_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {tph_completer_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {extended_format_field_hwtcl} {true}
    set_instance_parameter_value pcie_hip_avmm {atomic_malformed_hwtcl} {true}
    set_instance_parameter_value pcie_hip_avmm {flr_capability_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {skp_os_gen3_count_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {override_rxbuffer_cred_preset} {0}
    set_instance_parameter_value pcie_hip_avmm {coreclkout_hip_phaseshift_hwtcl} {0 ps}
    set_instance_parameter_value pcie_hip_avmm {pldclk_hip_phase_shift_hwtcl} {0 ps}
    set_instance_parameter_value pcie_hip_avmm {serial_sim_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {hip_reconfig_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {gen3_rxfreqlock_counter_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {expansion_base_address_register_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {io_window_addr_width_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {prefetchable_mem_window_addr_width_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {advanced_default_parameter_override} {0}
    set_instance_parameter_value pcie_hip_avmm {override_tbpartner_driver_setting_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {enable_rx_buffer_checking_advanced_default_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {disable_link_x2_support_advanced_default_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {device_number_advanced_default_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {pipex1_debug_sel_advanced_default_hwtcl} {disable}
    set_instance_parameter_value pcie_hip_avmm {pclk_out_sel_advanced_default_hwtcl} {pclk}
    set_instance_parameter_value pcie_hip_avmm {no_soft_reset_advanced_default_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {d1_support_advanced_default_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {d2_support_advanced_default_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {d0_pme_advanced_default_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {d1_pme_advanced_default_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {d2_pme_advanced_default_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {d3_hot_pme_advanced_default_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {d3_cold_pme_advanced_default_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {low_priority_vc_advanced_default_hwtcl} {single_vc}
    set_instance_parameter_value pcie_hip_avmm {enable_l1_aspm_advanced_default_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {l1_exit_latency_sameclock_advanced_default_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {l1_exit_latency_diffclock_advanced_default_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {hot_plug_support_advanced_default_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {no_command_completed_advanced_default_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {eie_before_nfts_count_advanced_default_hwtcl} {4}
    set_instance_parameter_value pcie_hip_avmm {gen2_diffclock_nfts_count_advanced_default_hwtcl} {255}
    set_instance_parameter_value pcie_hip_avmm {gen2_sameclock_nfts_count_advanced_default_hwtcl} {255}
    set_instance_parameter_value pcie_hip_avmm {deemphasis_enable_advanced_default_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {l0_exit_latency_sameclock_advanced_default_hwtcl} {6}
    set_instance_parameter_value pcie_hip_avmm {l0_exit_latency_diffclock_advanced_default_hwtcl} {6}
    set_instance_parameter_value pcie_hip_avmm {vc0_clk_enable_advanced_default_hwtcl} {true}
    set_instance_parameter_value pcie_hip_avmm {register_pipe_signals_advanced_default_hwtcl} {true}
    set_instance_parameter_value pcie_hip_avmm {tx_cdc_almost_empty_advanced_default_hwtcl} {5}
    set_instance_parameter_value pcie_hip_avmm {rx_l0s_count_idl_advanced_default_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {cdc_dummy_insert_limit_advanced_default_hwtcl} {11}
    set_instance_parameter_value pcie_hip_avmm {ei_delay_powerdown_count_advanced_default_hwtcl} {10}
    set_instance_parameter_value pcie_hip_avmm {skp_os_schedule_count_advanced_default_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {fc_init_timer_advanced_default_hwtcl} {1024}
    set_instance_parameter_value pcie_hip_avmm {l01_entry_latency_advanced_default_hwtcl} {31}
    set_instance_parameter_value pcie_hip_avmm {flow_control_update_count_advanced_default_hwtcl} {30}
    set_instance_parameter_value pcie_hip_avmm {flow_control_timeout_count_advanced_default_hwtcl} {200}
    set_instance_parameter_value pcie_hip_avmm {retry_buffer_last_active_address_advanced_default_hwtcl} {255}
    set_instance_parameter_value pcie_hip_avmm {reserved_debug_advanced_default_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {use_tl_cfg_sync_advanced_default_hwtcl} {1}
    set_instance_parameter_value pcie_hip_avmm {diffclock_nfts_count_advanced_default_hwtcl} {255}
    set_instance_parameter_value pcie_hip_avmm {sameclock_nfts_count_advanced_default_hwtcl} {255}
    set_instance_parameter_value pcie_hip_avmm {l2_async_logic_advanced_default_hwtcl} {disable}
    set_instance_parameter_value pcie_hip_avmm {rx_cdc_almost_full_advanced_default_hwtcl} {12}
    set_instance_parameter_value pcie_hip_avmm {tx_cdc_almost_full_advanced_default_hwtcl} {11}
    set_instance_parameter_value pcie_hip_avmm {indicator_advanced_default_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {rpre_emph_a_val_hwtcl} {11}
    set_instance_parameter_value pcie_hip_avmm {rpre_emph_b_val_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {rpre_emph_c_val_hwtcl} {22}
    set_instance_parameter_value pcie_hip_avmm {rpre_emph_d_val_hwtcl} {12}
    set_instance_parameter_value pcie_hip_avmm {rpre_emph_e_val_hwtcl} {21}
    set_instance_parameter_value pcie_hip_avmm {rvod_sel_a_val_hwtcl} {50}
    set_instance_parameter_value pcie_hip_avmm {rvod_sel_b_val_hwtcl} {34}
    set_instance_parameter_value pcie_hip_avmm {rvod_sel_c_val_hwtcl} {50}
    set_instance_parameter_value pcie_hip_avmm {rvod_sel_d_val_hwtcl} {50}
    set_instance_parameter_value pcie_hip_avmm {rvod_sel_e_val_hwtcl} {9}
    } else {
    #Arria V 
    add_instance pcie_hip_avmm altera_pcie_av_hip_avmm
    set_instance_parameter_value pcie_hip_avmm {pcie_qsys} {1}
    set_instance_parameter_value pcie_hip_avmm {altpcie_avmm_hwtcl} {1}
    set_instance_parameter_value pcie_hip_avmm {lane_mask_hwtcl} {x4}
    set_instance_parameter_value pcie_hip_avmm {gen123_lane_rate_mode_hwtcl} {Gen2 (5.0 Gbps)}
    set_instance_parameter_value pcie_hip_avmm {port_type_hwtcl} {Root port}
    set_instance_parameter_value pcie_hip_avmm {rxbuffer_rxreq_hwtcl} {Balanced}
    set_instance_parameter_value pcie_hip_avmm {pll_refclk_freq_hwtcl} {100 MHz}
    set_instance_parameter_value pcie_hip_avmm {set_pld_clk_x1_625MHz_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {in_cvp_mode_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {NUM_PREFETCH_MASTERS} {1}
    set_instance_parameter_value pcie_hip_avmm {bar0_type_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {bar1_type_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {bar2_type_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {bar3_type_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {bar4_type_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {bar5_type_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_P2A_AVALON_ADDR_B0} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_P2A_AVALON_ADDR_B1} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_P2A_AVALON_ADDR_B2} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_P2A_AVALON_ADDR_B3} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_P2A_AVALON_ADDR_B4} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_P2A_AVALON_ADDR_B5} {0}
    set_instance_parameter_value pcie_hip_avmm {fixed_address_mode} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_P2A_FIXED_AVALON_ADDR_B0} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_P2A_FIXED_AVALON_ADDR_B1} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_P2A_FIXED_AVALON_ADDR_B2} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_P2A_FIXED_AVALON_ADDR_B3} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_P2A_FIXED_AVALON_ADDR_B4} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_P2A_FIXED_AVALON_ADDR_B5} {0}
    set_instance_parameter_value pcie_hip_avmm {vendor_id_hwtcl} {4466}
    set_instance_parameter_value pcie_hip_avmm {device_id_hwtcl} {57344}
    set_instance_parameter_value pcie_hip_avmm {revision_id_hwtcl} {1}
    set_instance_parameter_value pcie_hip_avmm {class_code_hwtcl} {394240}
    set_instance_parameter_value pcie_hip_avmm {subsystem_vendor_id_hwtcl} {4466}
    set_instance_parameter_value pcie_hip_avmm {subsystem_device_id_hwtcl} {57344}
    set_instance_parameter_value pcie_hip_avmm {max_payload_size_hwtcl} {256}
    set_instance_parameter_value pcie_hip_avmm {extend_tag_field_hwtcl} {32}
    set_instance_parameter_value pcie_hip_avmm {completion_timeout_hwtcl} {ABCD}
    set_instance_parameter_value pcie_hip_avmm {enable_completion_timeout_disable_hwtcl} {1}
    set_instance_parameter_value pcie_hip_avmm {use_aer_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {ecrc_check_capable_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {ecrc_gen_capable_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {use_crc_forwarding_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {port_link_number_hwtcl} {1}
    set_instance_parameter_value pcie_hip_avmm {dll_active_report_support_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {surprise_down_error_support_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {slotclkcfg_hwtcl} {1}
    set_instance_parameter_value pcie_hip_avmm {msi_multi_message_capable_hwtcl} {4}
    set_instance_parameter_value pcie_hip_avmm {msi_64bit_addressing_capable_hwtcl} {true}
    set_instance_parameter_value pcie_hip_avmm {msi_masking_capable_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {msi_support_hwtcl} {true}
    set_instance_parameter_value pcie_hip_avmm {enable_function_msix_support_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {msix_table_size_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {msix_table_offset_hwtcl} {0.0}
    set_instance_parameter_value pcie_hip_avmm {msix_table_bir_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {msix_pba_offset_hwtcl} {0.0}
    set_instance_parameter_value pcie_hip_avmm {msix_pba_bir_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {enable_slot_register_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {slot_power_scale_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {slot_power_limit_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {slot_number_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {endpoint_l0_latency_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {endpoint_l1_latency_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {vsec_id_hwtcl} {4466}
    set_instance_parameter_value pcie_hip_avmm {vsec_rev_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {user_id_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {CG_COMMON_CLOCK_MODE} {1}
    set_instance_parameter_value pcie_hip_avmm {avmm_width_hwtcl} {128}
    set_instance_parameter_value pcie_hip_avmm {AVALON_ADDR_WIDTH} {32}
    set_instance_parameter_value pcie_hip_avmm {CB_PCIE_MODE} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_PCIE_RX_LITE} {0}
    set_instance_parameter_value pcie_hip_avmm {AST_LITE} {0}
    set_instance_parameter_value pcie_hip_avmm {CG_RXM_IRQ_NUM} {16}
    set_instance_parameter_value pcie_hip_avmm {bypass_tl} {false}
    set_instance_parameter_value pcie_hip_avmm {CG_IMPL_CRA_AV_SLAVE_PORT} {1}
    set_instance_parameter_value pcie_hip_avmm {CG_ENABLE_ADVANCED_INTERRUPT} {0}
    set_instance_parameter_value pcie_hip_avmm {CG_ENABLE_A2P_INTERRUPT} {0}
    set_instance_parameter_value pcie_hip_avmm {CG_ENABLE_HIP_STATUS} {1}
    set_instance_parameter_value pcie_hip_avmm {CG_ENABLE_HIP_STATUS_EXTENSION} {0}
    set_instance_parameter_value pcie_hip_avmm {TX_S_ADDR_WIDTH} {32}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_IS_FIXED} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_NUM_ENTRIES} {2}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_PASS_THRU_BITS} {27}
    set_instance_parameter_value pcie_hip_avmm {BYPASSS_A2P_TRANSLATION} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_RP_S_ADDR_WIDTH} {32}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_0_HIGH} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_0_LOW} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_1_HIGH} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_1_LOW} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_2_HIGH} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_2_LOW} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_3_HIGH} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_3_LOW} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_4_HIGH} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_4_LOW} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_5_HIGH} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_5_LOW} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_6_HIGH} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_6_LOW} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_7_HIGH} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_7_LOW} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_8_HIGH} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_8_LOW} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_9_HIGH} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_9_LOW} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_10_HIGH} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_10_LOW} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_11_HIGH} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_11_LOW} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_12_HIGH} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_12_LOW} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_13_HIGH} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_13_LOW} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_14_HIGH} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_14_LOW} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_15_HIGH} {0}
    set_instance_parameter_value pcie_hip_avmm {CB_A2P_ADDR_MAP_FIXED_TABLE_15_LOW} {0}
    set_instance_parameter_value pcie_hip_avmm {AddressPage} {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}
    set_instance_parameter_value pcie_hip_avmm {PCIeAddress63_32} {0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000}
    set_instance_parameter_value pcie_hip_avmm {PCIeAddress31_0} {0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000,0x00000000}
    set_instance_parameter_value pcie_hip_avmm {RXM_DATA_WIDTH} {64}
    set_instance_parameter_value pcie_hip_avmm {RXM_BEN_WIDTH} {8}
    set_instance_parameter_value pcie_hip_avmm {use_rx_st_be_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {use_ast_parity} {0}
    set_instance_parameter_value pcie_hip_avmm {force_hrc} {0}
    set_instance_parameter_value pcie_hip_avmm {force_src} {0}
    set_instance_parameter_value pcie_hip_avmm {bypass_cdc_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {wrong_device_id_hwtcl} {disable}
    set_instance_parameter_value pcie_hip_avmm {data_pack_rx_hwtcl} {disable}
    set_instance_parameter_value pcie_hip_avmm {ltssm_1ms_timeout_hwtcl} {disable}
    set_instance_parameter_value pcie_hip_avmm {ltssm_freqlocked_check_hwtcl} {disable}
    set_instance_parameter_value pcie_hip_avmm {deskew_comma_hwtcl} {skp_eieos_deskw}
    set_instance_parameter_value pcie_hip_avmm {maximum_current_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {disable_snoop_packet_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {enable_l0s_aspm_hwtcl} {true}
    set_instance_parameter_value pcie_hip_avmm {extended_tag_reset_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {interrupt_pin_hwtcl} {inta}
    set_instance_parameter_value pcie_hip_avmm {bridge_port_vga_enable_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {bridge_port_ssid_support_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {ssvid_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {ssid_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {atomic_op_routing_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {atomic_op_completer_32bit_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {atomic_op_completer_64bit_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {cas_completer_128bit_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {ltr_mechanism_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {tph_completer_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {extended_format_field_hwtcl} {true}
    set_instance_parameter_value pcie_hip_avmm {atomic_malformed_hwtcl} {true}
    set_instance_parameter_value pcie_hip_avmm {flr_capability_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {skp_os_gen3_count_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {override_rxbuffer_cred_preset} {0}
    set_instance_parameter_value pcie_hip_avmm {coreclkout_hip_phaseshift_hwtcl} {0 ps}
    set_instance_parameter_value pcie_hip_avmm {pldclk_hip_phase_shift_hwtcl} {0 ps}
    set_instance_parameter_value pcie_hip_avmm {serial_sim_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {hip_reconfig_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {gen3_rxfreqlock_counter_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {expansion_base_address_register_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {io_window_addr_width_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {prefetchable_mem_window_addr_width_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {advanced_default_parameter_override} {0}
    set_instance_parameter_value pcie_hip_avmm {override_tbpartner_driver_setting_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {enable_rx_buffer_checking_advanced_default_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {disable_link_x2_support_advanced_default_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {device_number_advanced_default_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {pipex1_debug_sel_advanced_default_hwtcl} {disable}
    set_instance_parameter_value pcie_hip_avmm {pclk_out_sel_advanced_default_hwtcl} {pclk}
    set_instance_parameter_value pcie_hip_avmm {no_soft_reset_advanced_default_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {d1_support_advanced_default_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {d2_support_advanced_default_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {d0_pme_advanced_default_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {d1_pme_advanced_default_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {d2_pme_advanced_default_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {d3_hot_pme_advanced_default_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {d3_cold_pme_advanced_default_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {low_priority_vc_advanced_default_hwtcl} {single_vc}
    set_instance_parameter_value pcie_hip_avmm {enable_l1_aspm_advanced_default_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {l1_exit_latency_sameclock_advanced_default_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {l1_exit_latency_diffclock_advanced_default_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {hot_plug_support_advanced_default_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {no_command_completed_advanced_default_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {eie_before_nfts_count_advanced_default_hwtcl} {4}
    set_instance_parameter_value pcie_hip_avmm {gen2_diffclock_nfts_count_advanced_default_hwtcl} {255}
    set_instance_parameter_value pcie_hip_avmm {gen2_sameclock_nfts_count_advanced_default_hwtcl} {255}
    set_instance_parameter_value pcie_hip_avmm {deemphasis_enable_advanced_default_hwtcl} {false}
    set_instance_parameter_value pcie_hip_avmm {l0_exit_latency_sameclock_advanced_default_hwtcl} {6}
    set_instance_parameter_value pcie_hip_avmm {l0_exit_latency_diffclock_advanced_default_hwtcl} {6}
    set_instance_parameter_value pcie_hip_avmm {vc0_clk_enable_advanced_default_hwtcl} {true}
    set_instance_parameter_value pcie_hip_avmm {register_pipe_signals_advanced_default_hwtcl} {true}
    set_instance_parameter_value pcie_hip_avmm {tx_cdc_almost_empty_advanced_default_hwtcl} {5}
    set_instance_parameter_value pcie_hip_avmm {rx_l0s_count_idl_advanced_default_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {cdc_dummy_insert_limit_advanced_default_hwtcl} {11}
    set_instance_parameter_value pcie_hip_avmm {ei_delay_powerdown_count_advanced_default_hwtcl} {10}
    set_instance_parameter_value pcie_hip_avmm {skp_os_schedule_count_advanced_default_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {fc_init_timer_advanced_default_hwtcl} {1024}
    set_instance_parameter_value pcie_hip_avmm {l01_entry_latency_advanced_default_hwtcl} {31}
    set_instance_parameter_value pcie_hip_avmm {flow_control_update_count_advanced_default_hwtcl} {30}
    set_instance_parameter_value pcie_hip_avmm {flow_control_timeout_count_advanced_default_hwtcl} {200}
    set_instance_parameter_value pcie_hip_avmm {retry_buffer_last_active_address_advanced_default_hwtcl} {255}
    set_instance_parameter_value pcie_hip_avmm {reserved_debug_advanced_default_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {use_tl_cfg_sync_advanced_default_hwtcl} {1}
    set_instance_parameter_value pcie_hip_avmm {diffclock_nfts_count_advanced_default_hwtcl} {255}
    set_instance_parameter_value pcie_hip_avmm {sameclock_nfts_count_advanced_default_hwtcl} {255}
    set_instance_parameter_value pcie_hip_avmm {l2_async_logic_advanced_default_hwtcl} {disable}
    set_instance_parameter_value pcie_hip_avmm {rx_cdc_almost_full_advanced_default_hwtcl} {12}
    set_instance_parameter_value pcie_hip_avmm {tx_cdc_almost_full_advanced_default_hwtcl} {11}
    set_instance_parameter_value pcie_hip_avmm {indicator_advanced_default_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {rpre_emph_a_val_hwtcl} {12}
    set_instance_parameter_value pcie_hip_avmm {rpre_emph_b_val_hwtcl} {0}
    set_instance_parameter_value pcie_hip_avmm {rpre_emph_c_val_hwtcl} {19}
    set_instance_parameter_value pcie_hip_avmm {rpre_emph_d_val_hwtcl} {13}
    set_instance_parameter_value pcie_hip_avmm {rpre_emph_e_val_hwtcl} {21}
    set_instance_parameter_value pcie_hip_avmm {rvod_sel_a_val_hwtcl} {42}
    set_instance_parameter_value pcie_hip_avmm {rvod_sel_b_val_hwtcl} {30}
    set_instance_parameter_value pcie_hip_avmm {rvod_sel_c_val_hwtcl} {43}
    set_instance_parameter_value pcie_hip_avmm {rvod_sel_d_val_hwtcl} {43}
    set_instance_parameter_value pcie_hip_avmm {rvod_sel_e_val_hwtcl} {9}

    add_instance pcie_reconfig_driver_0 altera_pcie_reconfig_driver
    set_instance_parameter_value pcie_reconfig_driver_0 {gen123_lane_rate_mode_hwtcl} {Gen2 (5.0 Gbps)}
    set_instance_parameter_value pcie_reconfig_driver_0 {number_of_reconfig_interfaces} {5}
    set_instance_parameter_value pcie_reconfig_driver_0 {enable_cal_busy_hwtcl} {0} 
    }
    add_instance performance_counter_0 altera_avalon_performance_counter
    set_instance_parameter_value performance_counter_0 {numberOfSections} {1}

    # connections and connection parameters
    add_connection pcie_hip_avmm.RP_Master pb_rxm_2_msi.s0 
    set_connection_parameter_value pcie_hip_avmm.RP_Master/pb_rxm_2_msi.s0 arbitrationPriority {1}
    set_connection_parameter_value pcie_hip_avmm.RP_Master/pb_rxm_2_msi.s0 baseAddress {0xff210000}
    set_connection_parameter_value pcie_hip_avmm.RP_Master/pb_rxm_2_msi.s0 defaultConnection {0}

    add_connection pcie_hip_avmm.RP_Master pb_2_ocm.s0 
    set_connection_parameter_value pcie_hip_avmm.RP_Master/pb_2_ocm.s0 arbitrationPriority {1}
    set_connection_parameter_value pcie_hip_avmm.RP_Master/pb_2_ocm.s0 baseAddress {0x40000000}
    set_connection_parameter_value pcie_hip_avmm.RP_Master/pb_2_ocm.s0 defaultConnection {0}

    add_connection pcie_hip_avmm.RP_Master pb_f2sdram.s0 
    set_connection_parameter_value pcie_hip_avmm.RP_Master/pb_f2sdram.s0 arbitrationPriority {1}
    set_connection_parameter_value pcie_hip_avmm.RP_Master/pb_f2sdram.s0 baseAddress {0x0000}
    set_connection_parameter_value pcie_hip_avmm.RP_Master/pb_f2sdram.s0 defaultConnection {0}

    add_connection pb_lwh2f_pcie.m0 pcie_hip_avmm.Cra 
    set_connection_parameter_value pb_lwh2f_pcie.m0/pcie_hip_avmm.Cra arbitrationPriority {1}
    set_connection_parameter_value pb_lwh2f_pcie.m0/pcie_hip_avmm.Cra baseAddress {0x0000}
    set_connection_parameter_value pb_lwh2f_pcie.m0/pcie_hip_avmm.Cra defaultConnection {0}

    add_connection ccb_h2f.m0 pcie_hip_avmm.Txs 
    set_connection_parameter_value ccb_h2f.m0/pcie_hip_avmm.Txs arbitrationPriority {1}
    set_connection_parameter_value ccb_h2f.m0/pcie_hip_avmm.Txs baseAddress {0x0000}
    set_connection_parameter_value ccb_h2f.m0/pcie_hip_avmm.Txs defaultConnection {0}

    add_connection pb_msgdma_2_txs.m0 pcie_hip_avmm.Txs 
    set_connection_parameter_value pb_msgdma_2_txs.m0/pcie_hip_avmm.Txs arbitrationPriority {1}
    set_connection_parameter_value pb_msgdma_2_txs.m0/pcie_hip_avmm.Txs baseAddress {0x0000}
    set_connection_parameter_value pb_msgdma_2_txs.m0/pcie_hip_avmm.Txs defaultConnection {0}

    add_connection pb_lwh2f_pcie.m0 performance_counter_0.control_slave 
    set_connection_parameter_value pb_lwh2f_pcie.m0/performance_counter_0.control_slave arbitrationPriority {1}
    set_connection_parameter_value pb_lwh2f_pcie.m0/performance_counter_0.control_slave baseAddress {0x40a0}
    set_connection_parameter_value pb_lwh2f_pcie.m0/performance_counter_0.control_slave defaultConnection {0}

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

    add_connection pb_lwh2f_pcie.m0 msi_to_gic_gen_0.vector_slave 
    set_connection_parameter_value pb_lwh2f_pcie.m0/msi_to_gic_gen_0.vector_slave arbitrationPriority {1}
    set_connection_parameter_value pb_lwh2f_pcie.m0/msi_to_gic_gen_0.vector_slave baseAddress {0x4000}
    set_connection_parameter_value pb_lwh2f_pcie.m0/msi_to_gic_gen_0.vector_slave defaultConnection {0}

    add_connection pb_rxm_2_msi.m0 msi_to_gic_gen_0.vector_slave 
    set_connection_parameter_value pb_rxm_2_msi.m0/msi_to_gic_gen_0.vector_slave arbitrationPriority {1}
    set_connection_parameter_value pb_rxm_2_msi.m0/msi_to_gic_gen_0.vector_slave baseAddress {0x4000}
    set_connection_parameter_value pb_rxm_2_msi.m0/msi_to_gic_gen_0.vector_slave defaultConnection {0}

    add_connection pb_f2sdram.m0 add_x_f2sdram.windowed_slave 
    set_connection_parameter_value pb_f2sdram.m0/add_x_f2sdram.windowed_slave arbitrationPriority {1}
    set_connection_parameter_value pb_f2sdram.m0/add_x_f2sdram.windowed_slave baseAddress {0x0000}
    set_connection_parameter_value pb_f2sdram.m0/add_x_f2sdram.windowed_slave defaultConnection {0}

    add_connection msgdma_0.mm_read pb_msgdma_2_txs.s0 
    set_connection_parameter_value msgdma_0.mm_read/pb_msgdma_2_txs.s0 arbitrationPriority {1}
    set_connection_parameter_value msgdma_0.mm_read/pb_msgdma_2_txs.s0 baseAddress {0xd0000000}
    set_connection_parameter_value msgdma_0.mm_read/pb_msgdma_2_txs.s0 defaultConnection {0}

    add_connection msgdma_0.mm_read pb_2_ocm.s0 
    set_connection_parameter_value msgdma_0.mm_read/pb_2_ocm.s0 arbitrationPriority {1}
    set_connection_parameter_value msgdma_0.mm_read/pb_2_ocm.s0 baseAddress {0x40000000}
    set_connection_parameter_value msgdma_0.mm_read/pb_2_ocm.s0 defaultConnection {0}

    add_connection msgdma_0.mm_read pb_f2sdram.s0 
    set_connection_parameter_value msgdma_0.mm_read/pb_f2sdram.s0 arbitrationPriority {1}
    set_connection_parameter_value msgdma_0.mm_read/pb_f2sdram.s0 baseAddress {0x0000}
    set_connection_parameter_value msgdma_0.mm_read/pb_f2sdram.s0 defaultConnection {0}

    add_connection msgdma_0.mm_write pb_2_ocm.s0 
    set_connection_parameter_value msgdma_0.mm_write/pb_2_ocm.s0 arbitrationPriority {1}
    set_connection_parameter_value msgdma_0.mm_write/pb_2_ocm.s0 baseAddress {0x40000000}
    set_connection_parameter_value msgdma_0.mm_write/pb_2_ocm.s0 defaultConnection {0}

    add_connection msgdma_0.mm_write pb_msgdma_2_txs.s0 
    set_connection_parameter_value msgdma_0.mm_write/pb_msgdma_2_txs.s0 arbitrationPriority {1}
    set_connection_parameter_value msgdma_0.mm_write/pb_msgdma_2_txs.s0 baseAddress {0xd0000000}
    set_connection_parameter_value msgdma_0.mm_write/pb_msgdma_2_txs.s0 defaultConnection {0}

    add_connection msgdma_0.mm_write pb_f2sdram.s0 
    set_connection_parameter_value msgdma_0.mm_write/pb_f2sdram.s0 arbitrationPriority {1}
    set_connection_parameter_value msgdma_0.mm_write/pb_f2sdram.s0 baseAddress {0x0000}
    set_connection_parameter_value msgdma_0.mm_write/pb_f2sdram.s0 defaultConnection {0}
    
    if {$devicefamily == "ARRIAV"} {
    add_connection pcie_reconfig_driver_0.reconfig_mgmt alt_xcvr_reconfig_0.reconfig_mgmt 
    set_connection_parameter_value pcie_reconfig_driver_0.reconfig_mgmt/alt_xcvr_reconfig_0.reconfig_mgmt arbitrationPriority {1}
    set_connection_parameter_value pcie_reconfig_driver_0.reconfig_mgmt/alt_xcvr_reconfig_0.reconfig_mgmt baseAddress {0x0000}
    set_connection_parameter_value pcie_reconfig_driver_0.reconfig_mgmt/alt_xcvr_reconfig_0.reconfig_mgmt defaultConnection {0}
    }

    add_connection clk.clk ccb_h2f.s0_clk 

    add_connection clk.clk performance_counter_0.clk 
    
    add_connection clk.clk msi_to_gic_gen_0.clock   
    
    add_connection custom_reset_synchronizer_0.clock_out pb_lwh2f_pcie.clk 

    # add_connection custom_reset_synchronizer_0.clock_out performance_counter_0.clk 
    
    # add_connection custom_reset_synchronizer_0.clock_out msi_to_gic_gen_0.clock   

    add_connection custom_reset_synchronizer_0.clock_out pb_rxm_2_msi.clk 

    add_connection custom_reset_synchronizer_0.clock_out pb_msgdma_2_txs.clk 

    add_connection custom_reset_synchronizer_0.clock_out pb_f2sdram.clk 

    add_connection custom_reset_synchronizer_0.clock_out pb_2_ocm.clk 

    add_connection custom_reset_synchronizer_0.clock_out nreset_status.clk 

    add_connection custom_reset_synchronizer_0.clock_out coreclk_fanout.clk_in 

    add_connection custom_reset_synchronizer_0.clock_out msgdma_0.clock 

    add_connection custom_reset_synchronizer_0.clock_out add_x_f2sdram.clock 

    add_connection custom_reset_synchronizer_0.clock_out coreclkout_125.in_clk 

    add_connection custom_reset_synchronizer_0.clock_out ccb_h2f.m0_clk 

    add_connection custom_reset_synchronizer_0.clock_out alt_xcvr_reconfig_0.mgmt_clk_clk 

    if {$devicefamily == "ARRIAV"} {
    add_connection custom_reset_synchronizer_0.clock_out pcie_reconfig_driver_0.pld_clk 

    add_connection custom_reset_synchronizer_0.clock_out pcie_reconfig_driver_0.reconfig_xcvr_clk 

    add_connection pcie_hip_avmm.hip_currentspeed pcie_reconfig_driver_0.hip_currentspeed 
    set_connection_parameter_value pcie_hip_avmm.hip_currentspeed/pcie_reconfig_driver_0.hip_currentspeed endPort {}
    set_connection_parameter_value pcie_hip_avmm.hip_currentspeed/pcie_reconfig_driver_0.hip_currentspeed endPortLSB {0}
    set_connection_parameter_value pcie_hip_avmm.hip_currentspeed/pcie_reconfig_driver_0.hip_currentspeed startPort {}
    set_connection_parameter_value pcie_hip_avmm.hip_currentspeed/pcie_reconfig_driver_0.hip_currentspeed startPortLSB {0}
    set_connection_parameter_value pcie_hip_avmm.hip_currentspeed/pcie_reconfig_driver_0.hip_currentspeed width {0}

    add_connection pcie_hip_avmm.hip_status pcie_reconfig_driver_0.hip_status_drv 
    set_connection_parameter_value pcie_hip_avmm.hip_status/pcie_reconfig_driver_0.hip_status_drv endPort {}
    set_connection_parameter_value pcie_hip_avmm.hip_status/pcie_reconfig_driver_0.hip_status_drv endPortLSB {0}
    set_connection_parameter_value pcie_hip_avmm.hip_status/pcie_reconfig_driver_0.hip_status_drv startPort {}
    set_connection_parameter_value pcie_hip_avmm.hip_status/pcie_reconfig_driver_0.hip_status_drv startPortLSB {0}
    set_connection_parameter_value pcie_hip_avmm.hip_status/pcie_reconfig_driver_0.hip_status_drv width {0} 
    }

    add_connection pcie_hip_avmm.coreclkout custom_reset_synchronizer_0.clock_in 

    if {$devicefamily == "CYCLONEV"} {  
    add_connection pcie_hip_avmm.reconfig_busy alt_xcvr_reconfig_0.reconfig_busy 
    set_connection_parameter_value pcie_hip_avmm.reconfig_busy/alt_xcvr_reconfig_0.reconfig_busy endPort {}
    set_connection_parameter_value pcie_hip_avmm.reconfig_busy/alt_xcvr_reconfig_0.reconfig_busy endPortLSB {0}
    set_connection_parameter_value pcie_hip_avmm.reconfig_busy/alt_xcvr_reconfig_0.reconfig_busy startPort {}
    set_connection_parameter_value pcie_hip_avmm.reconfig_busy/alt_xcvr_reconfig_0.reconfig_busy startPortLSB {0}
    set_connection_parameter_value pcie_hip_avmm.reconfig_busy/alt_xcvr_reconfig_0.reconfig_busy width {0}

    add_connection alt_xcvr_reconfig_0.reconfig_from_xcvr pcie_hip_avmm.reconfig_from_xcvr 
    set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_from_xcvr/pcie_hip_avmm.reconfig_from_xcvr endPort {}
    set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_from_xcvr/pcie_hip_avmm.reconfig_from_xcvr endPortLSB {0}
    set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_from_xcvr/pcie_hip_avmm.reconfig_from_xcvr startPort {}
    set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_from_xcvr/pcie_hip_avmm.reconfig_from_xcvr startPortLSB {0}
    set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_from_xcvr/pcie_hip_avmm.reconfig_from_xcvr width {0}

    add_connection alt_xcvr_reconfig_0.reconfig_to_xcvr pcie_hip_avmm.reconfig_to_xcvr 
    set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_to_xcvr/pcie_hip_avmm.reconfig_to_xcvr endPort {}
    set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_to_xcvr/pcie_hip_avmm.reconfig_to_xcvr endPortLSB {0}
    set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_to_xcvr/pcie_hip_avmm.reconfig_to_xcvr startPort {}
    set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_to_xcvr/pcie_hip_avmm.reconfig_to_xcvr startPortLSB {0}
    set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_to_xcvr/pcie_hip_avmm.reconfig_to_xcvr width {0}
    } else {
    #Arria V
    add_connection pcie_reconfig_driver_0.reconfig_busy alt_xcvr_reconfig_0.reconfig_busy 
    set_connection_parameter_value pcie_reconfig_driver_0.reconfig_busy/alt_xcvr_reconfig_0.reconfig_busy endPort {}
    set_connection_parameter_value pcie_reconfig_driver_0.reconfig_busy/alt_xcvr_reconfig_0.reconfig_busy endPortLSB {0}
    set_connection_parameter_value pcie_reconfig_driver_0.reconfig_busy/alt_xcvr_reconfig_0.reconfig_busy startPort {}
    set_connection_parameter_value pcie_reconfig_driver_0.reconfig_busy/alt_xcvr_reconfig_0.reconfig_busy startPortLSB {0}
    set_connection_parameter_value pcie_reconfig_driver_0.reconfig_busy/alt_xcvr_reconfig_0.reconfig_busy width {0}

    add_connection pcie_hip_avmm.reconfig_from_xcvr alt_xcvr_reconfig_0.reconfig_from_xcvr 
    set_connection_parameter_value pcie_hip_avmm.reconfig_from_xcvr/alt_xcvr_reconfig_0.reconfig_from_xcvr endPort {}
    set_connection_parameter_value pcie_hip_avmm.reconfig_from_xcvr/alt_xcvr_reconfig_0.reconfig_from_xcvr endPortLSB {0}
    set_connection_parameter_value pcie_hip_avmm.reconfig_from_xcvr/alt_xcvr_reconfig_0.reconfig_from_xcvr startPort {}
    set_connection_parameter_value pcie_hip_avmm.reconfig_from_xcvr/alt_xcvr_reconfig_0.reconfig_from_xcvr startPortLSB {0}
    set_connection_parameter_value pcie_hip_avmm.reconfig_from_xcvr/alt_xcvr_reconfig_0.reconfig_from_xcvr width {0}

    add_connection alt_xcvr_reconfig_0.reconfig_to_xcvr pcie_hip_avmm.reconfig_to_xcvr 
    set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_to_xcvr/pcie_hip_avmm.reconfig_to_xcvr endPort {}
    set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_to_xcvr/pcie_hip_avmm.reconfig_to_xcvr endPortLSB {0}
    set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_to_xcvr/pcie_hip_avmm.reconfig_to_xcvr startPort {}
    set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_to_xcvr/pcie_hip_avmm.reconfig_to_xcvr startPortLSB {0}
    set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_to_xcvr/pcie_hip_avmm.reconfig_to_xcvr width {0}

    add_connection custom_reset_synchronizer_0.reset_out pcie_reconfig_driver_0.reconfig_xcvr_rst   
    }

    add_connection clk.clk_reset custom_reset_synchronizer_0.reset_in 

    add_connection pcie_hip_avmm.nreset_status custom_reset_synchronizer_0.reset_in 
    add_connection custom_reset_synchronizer_0.reset_out coreclk_fanout.clk_in_reset 

    add_connection custom_reset_synchronizer_0.reset_out nreset_status.in_reset 

    add_connection custom_reset_synchronizer_0.reset_out ccb_h2f.m0_reset 

    add_connection custom_reset_synchronizer_0.reset_out alt_xcvr_reconfig_0.mgmt_rst_reset 

    add_connection custom_reset_synchronizer_0.reset_out pb_rxm_2_msi.reset 

    add_connection custom_reset_synchronizer_0.reset_out pb_msgdma_2_txs.reset 

    add_connection custom_reset_synchronizer_0.reset_out pb_lwh2f_pcie.reset 

    add_connection custom_reset_synchronizer_0.reset_out pb_f2sdram.reset 

    add_connection custom_reset_synchronizer_0.reset_out pb_2_ocm.reset 

    add_connection custom_reset_synchronizer_0.reset_out msi_to_gic_gen_0.reset 

    add_connection custom_reset_synchronizer_0.reset_out add_x_f2sdram.reset 

    add_connection custom_reset_synchronizer_0.reset_out performance_counter_0.reset 

    add_connection custom_reset_synchronizer_0.reset_out msgdma_0.reset_n 

    add_connection custom_reset_synchronizer_0.reset_out ccb_h2f.s0_reset 

    # exported interfaces
    add_interface address_span_extender_0_expanded_master avalon master
    set_interface_property address_span_extender_0_expanded_master EXPORT_OF add_x_f2sdram.expanded_master
    if {$devicefamily == "CYCLONEV"} {  
    add_interface alt_xcvr_reconfig_0_reconfig_mgmt avalon slave
    set_interface_property alt_xcvr_reconfig_0_reconfig_mgmt EXPORT_OF alt_xcvr_reconfig_0.reconfig_mgmt
    } else {
    add_interface pcie_av_hip_avmm_0_reconfig_busy conduit end
    set_interface_property pcie_av_hip_avmm_0_reconfig_busy EXPORT_OF pcie_av_hip_avmm_0.reconfig_busy
    }
    add_interface ccb_h2f_s0 avalon slave
    set_interface_property ccb_h2f_s0 EXPORT_OF ccb_h2f.s0
    add_interface clk clock sink
    set_interface_property clk EXPORT_OF clk.clk_in
    add_interface coreclk_fanout_clk clock source
    set_interface_property coreclk_fanout_clk EXPORT_OF coreclk_fanout.clk
    add_interface coreclk_fanout_clk_reset reset source
    set_interface_property coreclk_fanout_clk_reset EXPORT_OF coreclk_fanout.clk_reset
    add_interface coreclkout_out clock source
    set_interface_property coreclkout_out EXPORT_OF coreclkout_125.out_clk
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
    add_interface pcie_hip_avmm_cra_irq interrupt sender
    set_interface_property pcie_hip_avmm_cra_irq EXPORT_OF pcie_hip_avmm.CraIrq
    add_interface pcie_hip_avmm_hip_ctrl conduit end
    set_interface_property pcie_hip_avmm_hip_ctrl EXPORT_OF pcie_hip_avmm.hip_ctrl
    add_interface pcie_hip_avmm_hip_pipe conduit end
    set_interface_property pcie_hip_avmm_hip_pipe EXPORT_OF pcie_hip_avmm.hip_pipe
    add_interface pcie_hip_avmm_hip_serial conduit end
    set_interface_property pcie_hip_avmm_hip_serial EXPORT_OF pcie_hip_avmm.hip_serial
    add_interface pcie_hip_avmm_npor conduit end
    set_interface_property pcie_hip_avmm_npor EXPORT_OF pcie_hip_avmm.npor
    add_interface pcie_hip_avmm_reconfig_clk_locked conduit end
    set_interface_property pcie_hip_avmm_reconfig_clk_locked EXPORT_OF pcie_hip_avmm.reconfig_clk_locked
    add_interface pcie_hip_avmm_refclk clock sink
    set_interface_property pcie_hip_avmm_refclk EXPORT_OF pcie_hip_avmm.refclk
    add_interface reset reset sink
    set_interface_property reset EXPORT_OF clk.clk_in_reset

    # interconnect requirements
    set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {AUTO}
    set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {4}
    set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
    set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
    if {$devicefamily == "CYCLONEV"} {  
    set_interconnect_requirement {mm_interconnect_0|cmd_demux_002.src0/cmd_mux_001.sink2} {qsys_mm.postTransform.pipelineCount} {1}
    set_interconnect_requirement {mm_interconnect_0|cmd_mux_002.src/pb_f2sdram_s0_agent.cp} {qsys_mm.postTransform.pipelineCount} {1}
    set_interconnect_requirement {mm_interconnect_0|msgdma_0_mm_read_agent.cp/router_001.sink} {qsys_mm.postTransform.pipelineCount} {1}
    set_interconnect_requirement {mm_interconnect_0|msgdma_0_mm_read_limiter.cmd_src/cmd_demux_001.sink} {qsys_mm.postTransform.pipelineCount} {1}
    set_interconnect_requirement {mm_interconnect_0|msgdma_0_mm_write_agent.cp/router_002.sink} {qsys_mm.postTransform.pipelineCount} {1}
    set_interconnect_requirement {mm_interconnect_0|pcie_hip_avmm_RP_Master_agent.cp/router.sink} {qsys_mm.postTransform.pipelineCount} {1}
    set_interconnect_requirement {mm_interconnect_0|pcie_hip_avmm_RP_Master_limiter.cmd_src/cmd_demux.sink} {qsys_mm.postTransform.pipelineCount} {1}
    }
    
save_system ${sub_qsys_pcie}.qsys
