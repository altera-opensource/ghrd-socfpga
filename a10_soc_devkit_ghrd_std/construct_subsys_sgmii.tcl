#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2015-2020 Intel Corporation.
#
#****************************************************************************
#
# This script construct sub system of SGMII for higher level integration
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
    
if { ![ info exists sub_qsys_sgmii ] } {
  set sub_qsys_sgmii subsys_sgmii
} else {
  puts "-- Accepted parameter \$sub_qsys_sgmii = $sub_qsys_sgmii"
}

package require -exact qsys 14.1

create_system $sub_qsys_sgmii

    set_project_property DEVICE_FAMILY $devicefamily
    set_project_property DEVICE $device

    add_instance clk_0 clock_source
    set_instance_parameter_value clk_0 {clockFrequency} {100000000.0}
    set_instance_parameter_value clk_0 {clockFrequencyKnown} {1}
    set_instance_parameter_value clk_0 {resetSynchronousEdges} {NONE}

    add_instance clk_125 clock_source 
    set_instance_parameter_value clk_125 {clockFrequency} {125000000.0}
    set_instance_parameter_value clk_125 {clockFrequencyKnown} {1}
    set_instance_parameter_value clk_125 {resetSynchronousEdges} {NONE}
    
    # add_instance clk_125_bridge altera_clock_bridge
    # set_instance_parameter_value clk_125_bridge {EXPLICIT_CLOCK_RATE} {125000000.0}
    # set_instance_parameter_value clk_125_bridge {NUM_CLOCK_OUTPUTS} {1}

    add_instance gmii_to_sgmii_converter_0 altera_gmii_to_sgmii_converter 

    if {$USE_ATX_PLL == 1} {
    add_instance pll_tse_txclk altera_xcvr_atx_pll_a10 
    set_instance_parameter_value pll_tse_txclk {rcfg_debug} {0}
    set_instance_parameter_value pll_tse_txclk {enable_pll_reconfig} {0}
    set_instance_parameter_value pll_tse_txclk {rcfg_jtag_enable} {0}
    set_instance_parameter_value pll_tse_txclk {set_capability_reg_enable} {0}
    set_instance_parameter_value pll_tse_txclk {set_user_identifier} {0}
    set_instance_parameter_value pll_tse_txclk {set_csr_soft_logic_enable} {0}
    set_instance_parameter_value pll_tse_txclk {rcfg_file_prefix} {altera_xcvr_atx_pll_a10}
    set_instance_parameter_value pll_tse_txclk {rcfg_sv_file_enable} {0}
    set_instance_parameter_value pll_tse_txclk {rcfg_h_file_enable} {0}
    set_instance_parameter_value pll_tse_txclk {rcfg_txt_file_enable} {0}
    set_instance_parameter_value pll_tse_txclk {rcfg_mif_file_enable} {0}
    set_instance_parameter_value pll_tse_txclk {enable_manual_configuration} {0}
    set_instance_parameter_value pll_tse_txclk {generate_docs} {1}
    set_instance_parameter_value pll_tse_txclk {generate_add_hdl_instance_example} {0}
    set_instance_parameter_value pll_tse_txclk {test_mode} {0}
    set_instance_parameter_value pll_tse_txclk {enable_pld_atx_cal_busy_port} {1}
    set_instance_parameter_value pll_tse_txclk {enable_debug_ports_parameters} {0}
    set_instance_parameter_value pll_tse_txclk {support_mode} {user_mode}
    set_instance_parameter_value pll_tse_txclk {message_level} {error}
    set_instance_parameter_value pll_tse_txclk {prot_mode} {Basic}
    set_instance_parameter_value pll_tse_txclk {bw_sel} {medium}
    set_instance_parameter_value pll_tse_txclk {refclk_cnt} {1}
    set_instance_parameter_value pll_tse_txclk {refclk_index} {0}
    set_instance_parameter_value pll_tse_txclk {silicon_rev} {0}
    set_instance_parameter_value pll_tse_txclk {primary_pll_buffer} {GX clock output buffer}
    set_instance_parameter_value pll_tse_txclk {enable_8G_path} {1}
    set_instance_parameter_value pll_tse_txclk {enable_16G_path} {0}
    set_instance_parameter_value pll_tse_txclk {enable_pcie_clk} {0}
    set_instance_parameter_value pll_tse_txclk {enable_cascade_out} {0}
    set_instance_parameter_value pll_tse_txclk {enable_hip_cal_done_port} {0}
    set_instance_parameter_value pll_tse_txclk {set_hip_cal_en} {0}
    set_instance_parameter_value pll_tse_txclk {select_manual_config} {0}
    set_instance_parameter_value pll_tse_txclk {set_output_clock_frequency} {1250.0}
    set_instance_parameter_value pll_tse_txclk {enable_fractional} {0}
    set_instance_parameter_value pll_tse_txclk {set_auto_reference_clock_frequency} {125.0}
    set_instance_parameter_value pll_tse_txclk {set_manual_reference_clock_frequency} {100.0}
    set_instance_parameter_value pll_tse_txclk {set_fref_clock_frequency} {100.0}
    set_instance_parameter_value pll_tse_txclk {set_m_counter} {1}
    set_instance_parameter_value pll_tse_txclk {set_ref_clk_div} {1}
    set_instance_parameter_value pll_tse_txclk {set_l_counter} {2}
    set_instance_parameter_value pll_tse_txclk {set_k_counter} {1}
    set_instance_parameter_value pll_tse_txclk {set_altera_xcvr_atx_pll_a10_calibration_en} {1}
    set_instance_parameter_value pll_tse_txclk {enable_mcgb} {0}
    set_instance_parameter_value pll_tse_txclk {mcgb_div} {1}
    set_instance_parameter_value pll_tse_txclk {enable_hfreq_clk} {0}
    set_instance_parameter_value pll_tse_txclk {enable_mcgb_pcie_clksw} {0}
    set_instance_parameter_value pll_tse_txclk {mcgb_aux_clkin_cnt} {0}
    set_instance_parameter_value pll_tse_txclk {enable_bonding_clks} {0}
    set_instance_parameter_value pll_tse_txclk {enable_fb_comp_bonding} {0}
    set_instance_parameter_value pll_tse_txclk {pma_width} {64}
    set_instance_parameter_value pll_tse_txclk {enable_pld_mcgb_cal_busy_port} {0}
    } elseif {$USE_CMU_PLL == 1} {
    add_instance pll_tse_txclk altera_xcvr_cdr_pll_a10 
    set_instance_parameter_value pll_tse_txclk {rcfg_debug} {0}
    set_instance_parameter_value pll_tse_txclk {enable_pll_reconfig} {0}
    set_instance_parameter_value pll_tse_txclk {rcfg_jtag_enable} {0}
    set_instance_parameter_value pll_tse_txclk {set_capability_reg_enable} {0}
    set_instance_parameter_value pll_tse_txclk {set_user_identifier} {0}
    set_instance_parameter_value pll_tse_txclk {set_csr_soft_logic_enable} {0}
    set_instance_parameter_value pll_tse_txclk {rcfg_file_prefix} {altera_xcvr_cdr_pll_a10}
    set_instance_parameter_value pll_tse_txclk {rcfg_sv_file_enable} {0}
    set_instance_parameter_value pll_tse_txclk {rcfg_h_file_enable} {0}
    set_instance_parameter_value pll_tse_txclk {rcfg_txt_file_enable} {0}
    set_instance_parameter_value pll_tse_txclk {rcfg_mif_file_enable} {0}
    set_instance_parameter_value pll_tse_txclk {cdr_pll_cgb_div} {1}
    set_instance_parameter_value pll_tse_txclk {cdr_pll_is_cascaded_pll} {false}
    set_instance_parameter_value pll_tse_txclk {cdr_pll_initial_settings} {true}
    set_instance_parameter_value pll_tse_txclk {cdr_pll_optimal} {false}
    set_instance_parameter_value pll_tse_txclk {generate_docs} {1}
    set_instance_parameter_value pll_tse_txclk {generate_add_hdl_instance_example} {0}
    set_instance_parameter_value pll_tse_txclk {message_level} {error}
    set_instance_parameter_value pll_tse_txclk {bw_sel} {Medium}
    set_instance_parameter_value pll_tse_txclk {refclk_cnt} {1}
    set_instance_parameter_value pll_tse_txclk {refclk_index} {0}
    set_instance_parameter_value pll_tse_txclk {support_mode} {user_mode}
    set_instance_parameter_value pll_tse_txclk {select_manual_config} {0}
    set_instance_parameter_value pll_tse_txclk {reference_clock_frequency} {125.0}
    set_instance_parameter_value pll_tse_txclk {output_clock_frequency} {1250}
    set_instance_parameter_value pll_tse_txclk {manual_counters} {}
    set_instance_parameter_value pll_tse_txclk {gui_tx_pll_prot_mode} {Basic}
    set_instance_parameter_value pll_tse_txclk {diag_loopback_enable} {false}
    set_instance_parameter_value pll_tse_txclk {refclk_select_mux_powerdown_mode} {powerup}
    set_instance_parameter_value pll_tse_txclk {set_altera_xcvr_cdr_pll_a10_calibration_en} {1}
    } else {
    add_instance pll_tse_txclk altera_xcvr_fpll_a10
    set_instance_parameter_value pll_tse_txclk {rcfg_debug} {0}
    set_instance_parameter_value pll_tse_txclk {enable_pll_reconfig} {0}
    set_instance_parameter_value pll_tse_txclk {rcfg_jtag_enable} {0}
    set_instance_parameter_value pll_tse_txclk {rcfg_separate_avmm_busy} {0}
    set_instance_parameter_value pll_tse_txclk {rcfg_enable_avmm_busy_port} {0}
    set_instance_parameter_value pll_tse_txclk {set_capability_reg_enable} {0}
    set_instance_parameter_value pll_tse_txclk {set_user_identifier} {0}
    set_instance_parameter_value pll_tse_txclk {set_csr_soft_logic_enable} {0}
    set_instance_parameter_value pll_tse_txclk {rcfg_file_prefix} {altera_xcvr_fpll_a10}
    set_instance_parameter_value pll_tse_txclk {rcfg_sv_file_enable} {0}
    set_instance_parameter_value pll_tse_txclk {rcfg_h_file_enable} {0}
    set_instance_parameter_value pll_tse_txclk {rcfg_txt_file_enable} {0}
    set_instance_parameter_value pll_tse_txclk {rcfg_mif_file_enable} {0}
    set_instance_parameter_value pll_tse_txclk {gui_pll_set_hssi_m_counter} {1}
    set_instance_parameter_value pll_tse_txclk {gui_pll_set_hssi_n_counter} {1}
    set_instance_parameter_value pll_tse_txclk {gui_pll_set_hssi_l_counter} {1}
    set_instance_parameter_value pll_tse_txclk {gui_pll_set_hssi_k_counter} {1.0}
    set_instance_parameter_value pll_tse_txclk {gui_fpll_mode} {2}
    set_instance_parameter_value pll_tse_txclk {gui_hssi_prot_mode} {0}
    set_instance_parameter_value pll_tse_txclk {gui_refclk_switch} {0}
    set_instance_parameter_value pll_tse_txclk {gui_refclk1_frequency} {100.0}
    set_instance_parameter_value pll_tse_txclk {gui_switchover_mode} {Automatic Switchover}
    set_instance_parameter_value pll_tse_txclk {gui_switchover_delay} {0}
    set_instance_parameter_value pll_tse_txclk {gui_enable_active_clk} {0}
    set_instance_parameter_value pll_tse_txclk {gui_enable_clk_bad} {0}
    set_instance_parameter_value pll_tse_txclk {generate_docs} {1}
    set_instance_parameter_value pll_tse_txclk {generate_add_hdl_instance_example} {0}
    set_instance_parameter_value pll_tse_txclk {gui_bw_sel} {low}
    set_instance_parameter_value pll_tse_txclk {gui_self_reset_enabled} {0}
    set_instance_parameter_value pll_tse_txclk {silicon_rev} {0}
    set_instance_parameter_value pll_tse_txclk {gui_reference_clock_frequency} {100.0}
    set_instance_parameter_value pll_tse_txclk {gui_desired_refclk_frequency} {125.0}
    set_instance_parameter_value pll_tse_txclk {gui_actual_refclk_frequency} {100.0}
    set_instance_parameter_value pll_tse_txclk {gui_operation_mode} {0}
    set_instance_parameter_value pll_tse_txclk {gui_iqtxrxclk_outclk_index} {0}
    set_instance_parameter_value pll_tse_txclk {gui_refclk_cnt} {1}
    set_instance_parameter_value pll_tse_txclk {gui_refclk_index} {0}
    set_instance_parameter_value pll_tse_txclk {gui_enable_fractional} {0}
    set_instance_parameter_value pll_tse_txclk {gui_enable_manual_hssi_counters} {0}
    set_instance_parameter_value pll_tse_txclk {enable_cascade_in} {0}
    set_instance_parameter_value pll_tse_txclk {gui_enable_pld_cal_busy_port} {1}
    set_instance_parameter_value pll_tse_txclk {gui_enable_hip_cal_done_port} {0}
    set_instance_parameter_value pll_tse_txclk {gui_hip_cal_en} {0}
    set_instance_parameter_value pll_tse_txclk {gui_enable_cascade_out} {0}
    set_instance_parameter_value pll_tse_txclk {gui_cascade_outclk_index} {0}
    set_instance_parameter_value pll_tse_txclk {gui_enable_dps} {0}
    set_instance_parameter_value pll_tse_txclk {gui_enable_manual_config} {0}
    set_instance_parameter_value pll_tse_txclk {gui_hssi_output_clock_frequency} {1250.0}
    set_instance_parameter_value pll_tse_txclk {gui_pll_m_counter} {1}
    set_instance_parameter_value pll_tse_txclk {gui_pll_n_counter} {1}
    set_instance_parameter_value pll_tse_txclk {gui_fractional_x} {32}
    set_instance_parameter_value pll_tse_txclk {gui_pll_dsm_fractional_division} {1.0}
    set_instance_parameter_value pll_tse_txclk {gui_pll_c_counter_0} {1}
    set_instance_parameter_value pll_tse_txclk {gui_pll_c_counter_1} {1}
    set_instance_parameter_value pll_tse_txclk {gui_pll_c_counter_2} {1}
    set_instance_parameter_value pll_tse_txclk {gui_pll_c_counter_3} {1}
    set_instance_parameter_value pll_tse_txclk {gui_number_of_output_clocks} {1}
    set_instance_parameter_value pll_tse_txclk {gui_enable_phase_alignment} {0}
    set_instance_parameter_value pll_tse_txclk {phase_alignment_check_var} {0}
    set_instance_parameter_value pll_tse_txclk {gui_desired_outclk0_frequency} {100.0}
    set_instance_parameter_value pll_tse_txclk {gui_actual_outclk0_frequency} {100.0}
    set_instance_parameter_value pll_tse_txclk {gui_outclk0_phase_shift_unit} {0}
    set_instance_parameter_value pll_tse_txclk {gui_outclk0_desired_phase_shift} {0.0}
    set_instance_parameter_value pll_tse_txclk {gui_outclk0_actual_phase_shift} {0.0}
    set_instance_parameter_value pll_tse_txclk {gui_outclk0_actual_phase_shift_deg} {0.0}
    set_instance_parameter_value pll_tse_txclk {gui_desired_outclk1_frequency} {100.0}
    set_instance_parameter_value pll_tse_txclk {gui_actual_outclk1_frequency} {100.0}
    set_instance_parameter_value pll_tse_txclk {gui_outclk1_phase_shift_unit} {0}
    set_instance_parameter_value pll_tse_txclk {gui_outclk1_desired_phase_shift} {0}
    set_instance_parameter_value pll_tse_txclk {gui_outclk1_actual_phase_shift} {0.0}
    set_instance_parameter_value pll_tse_txclk {gui_outclk1_actual_phase_shift_deg} {0.0}
    set_instance_parameter_value pll_tse_txclk {gui_desired_outclk2_frequency} {100.0}
    set_instance_parameter_value pll_tse_txclk {gui_actual_outclk2_frequency} {100.0}
    set_instance_parameter_value pll_tse_txclk {gui_outclk2_phase_shift_unit} {0}
    set_instance_parameter_value pll_tse_txclk {gui_outclk2_desired_phase_shift} {0}
    set_instance_parameter_value pll_tse_txclk {gui_outclk2_actual_phase_shift} {0 ps}
    set_instance_parameter_value pll_tse_txclk {gui_outclk2_actual_phase_shift_deg} {0 deg}
    set_instance_parameter_value pll_tse_txclk {gui_desired_outclk3_frequency} {100.0}
    set_instance_parameter_value pll_tse_txclk {gui_actual_outclk3_frequency} {100.0}
    set_instance_parameter_value pll_tse_txclk {gui_outclk3_phase_shift_unit} {0}
    set_instance_parameter_value pll_tse_txclk {gui_outclk3_desired_phase_shift} {0}
    set_instance_parameter_value pll_tse_txclk {gui_outclk3_actual_phase_shift} {0.0}
    set_instance_parameter_value pll_tse_txclk {gui_outclk3_actual_phase_shift_deg} {0.0}
    set_instance_parameter_value pll_tse_txclk {gui_desired_hssi_cascade_frequency} {100.0}
    set_instance_parameter_value pll_tse_txclk {set_altera_xcvr_fpll_a10_calibration_en} {1}
    set_instance_parameter_value pll_tse_txclk {support_mode} {user_mode}
    set_instance_parameter_value pll_tse_txclk {enable_mcgb} {0}
    set_instance_parameter_value pll_tse_txclk {mcgb_div} {1}
    set_instance_parameter_value pll_tse_txclk {enable_hfreq_clk} {0}
    set_instance_parameter_value pll_tse_txclk {enable_mcgb_pcie_clksw} {0}
    set_instance_parameter_value pll_tse_txclk {mcgb_aux_clkin_cnt} {0}
    set_instance_parameter_value pll_tse_txclk {enable_bonding_clks} {0}
    set_instance_parameter_value pll_tse_txclk {enable_fb_comp_bonding} {0}
    set_instance_parameter_value pll_tse_txclk {pma_width} {64}
    set_instance_parameter_value pll_tse_txclk {enable_pld_mcgb_cal_busy_port} {0}
    }
    
    add_instance xcvr_reset_control_0 altera_xcvr_reset_control 
    set_instance_parameter_value xcvr_reset_control_0 {CHANNELS} {1}
    set_instance_parameter_value xcvr_reset_control_0 {PLLS} {1}
    set_instance_parameter_value xcvr_reset_control_0 {SYS_CLK_IN_MHZ} {125}
    set_instance_parameter_value xcvr_reset_control_0 {SYNCHRONIZE_RESET} {1}
    set_instance_parameter_value xcvr_reset_control_0 {REDUCED_SIM_TIME} {1}
    set_instance_parameter_value xcvr_reset_control_0 {gui_split_interfaces} {0}
    set_instance_parameter_value xcvr_reset_control_0 {TX_PLL_ENABLE} {1}
    set_instance_parameter_value xcvr_reset_control_0 {T_PLL_POWERDOWN} {1000}
    set_instance_parameter_value xcvr_reset_control_0 {SYNCHRONIZE_PLL_RESET} {0}
    set_instance_parameter_value xcvr_reset_control_0 {TX_ENABLE} {1}
    set_instance_parameter_value xcvr_reset_control_0 {TX_PER_CHANNEL} {0}
    set_instance_parameter_value xcvr_reset_control_0 {gui_tx_auto_reset} {0}
    set_instance_parameter_value xcvr_reset_control_0 {T_TX_ANALOGRESET} {70000}
    set_instance_parameter_value xcvr_reset_control_0 {T_TX_DIGITALRESET} {70000}
    set_instance_parameter_value xcvr_reset_control_0 {T_PLL_LOCK_HYST} {0}
    set_instance_parameter_value xcvr_reset_control_0 {gui_pll_cal_busy} {1}
    set_instance_parameter_value xcvr_reset_control_0 {RX_ENABLE} {1}
    set_instance_parameter_value xcvr_reset_control_0 {RX_PER_CHANNEL} {0}
    set_instance_parameter_value xcvr_reset_control_0 {gui_rx_auto_reset} {0}
    set_instance_parameter_value xcvr_reset_control_0 {T_RX_ANALOGRESET} {70000}
    set_instance_parameter_value xcvr_reset_control_0 {T_RX_DIGITALRESET} {4000}

    # connections and connection parameters
    add_connection clk_125.clk xcvr_reset_control_0.clock 

    add_connection clk_0.clk gmii_to_sgmii_converter_0.clock_in 

    add_connection clk_125.clk pll_tse_txclk.pll_refclk0 

    add_connection clk_125.clk gmii_to_sgmii_converter_0.tse_pcs_ref_clk_clock_connection 

    add_connection clk_125.clk gmii_to_sgmii_converter_0.tse_rx_cdr_refclk 
    
    # add_connection clk_125_bridge.out_clk clk_125.clk_in

    add_connection xcvr_reset_control_0.pll_cal_busy pll_tse_txclk.pll_cal_busy 
    set_connection_parameter_value xcvr_reset_control_0.pll_cal_busy/pll_tse_txclk.pll_cal_busy endPort {}
    set_connection_parameter_value xcvr_reset_control_0.pll_cal_busy/pll_tse_txclk.pll_cal_busy endPortLSB {0}
    set_connection_parameter_value xcvr_reset_control_0.pll_cal_busy/pll_tse_txclk.pll_cal_busy startPort {}
    set_connection_parameter_value xcvr_reset_control_0.pll_cal_busy/pll_tse_txclk.pll_cal_busy startPortLSB {0}
    set_connection_parameter_value xcvr_reset_control_0.pll_cal_busy/pll_tse_txclk.pll_cal_busy width {0}

    add_connection xcvr_reset_control_0.pll_locked pll_tse_txclk.pll_locked 
    set_connection_parameter_value xcvr_reset_control_0.pll_locked/pll_tse_txclk.pll_locked endPort {}
    set_connection_parameter_value xcvr_reset_control_0.pll_locked/pll_tse_txclk.pll_locked endPortLSB {0}
    set_connection_parameter_value xcvr_reset_control_0.pll_locked/pll_tse_txclk.pll_locked startPort {}
    set_connection_parameter_value xcvr_reset_control_0.pll_locked/pll_tse_txclk.pll_locked startPortLSB {0}
    set_connection_parameter_value xcvr_reset_control_0.pll_locked/pll_tse_txclk.pll_locked width {0}

    add_connection xcvr_reset_control_0.pll_powerdown pll_tse_txclk.pll_powerdown 
    set_connection_parameter_value xcvr_reset_control_0.pll_powerdown/pll_tse_txclk.pll_powerdown endPort {}
    set_connection_parameter_value xcvr_reset_control_0.pll_powerdown/pll_tse_txclk.pll_powerdown endPortLSB {0}
    set_connection_parameter_value xcvr_reset_control_0.pll_powerdown/pll_tse_txclk.pll_powerdown startPort {}
    set_connection_parameter_value xcvr_reset_control_0.pll_powerdown/pll_tse_txclk.pll_powerdown startPortLSB {0}
    set_connection_parameter_value xcvr_reset_control_0.pll_powerdown/pll_tse_txclk.pll_powerdown width {0}

    add_connection xcvr_reset_control_0.rx_analogreset gmii_to_sgmii_converter_0.tse_rx_analogreset 
    set_connection_parameter_value xcvr_reset_control_0.rx_analogreset/gmii_to_sgmii_converter_0.tse_rx_analogreset endPort {}
    set_connection_parameter_value xcvr_reset_control_0.rx_analogreset/gmii_to_sgmii_converter_0.tse_rx_analogreset endPortLSB {0}
    set_connection_parameter_value xcvr_reset_control_0.rx_analogreset/gmii_to_sgmii_converter_0.tse_rx_analogreset startPort {}
    set_connection_parameter_value xcvr_reset_control_0.rx_analogreset/gmii_to_sgmii_converter_0.tse_rx_analogreset startPortLSB {0}
    set_connection_parameter_value xcvr_reset_control_0.rx_analogreset/gmii_to_sgmii_converter_0.tse_rx_analogreset width {0}

    add_connection xcvr_reset_control_0.rx_cal_busy gmii_to_sgmii_converter_0.tse_rx_cal_busy 
    set_connection_parameter_value xcvr_reset_control_0.rx_cal_busy/gmii_to_sgmii_converter_0.tse_rx_cal_busy endPort {}
    set_connection_parameter_value xcvr_reset_control_0.rx_cal_busy/gmii_to_sgmii_converter_0.tse_rx_cal_busy endPortLSB {0}
    set_connection_parameter_value xcvr_reset_control_0.rx_cal_busy/gmii_to_sgmii_converter_0.tse_rx_cal_busy startPort {}
    set_connection_parameter_value xcvr_reset_control_0.rx_cal_busy/gmii_to_sgmii_converter_0.tse_rx_cal_busy startPortLSB {0}
    set_connection_parameter_value xcvr_reset_control_0.rx_cal_busy/gmii_to_sgmii_converter_0.tse_rx_cal_busy width {0}

    add_connection xcvr_reset_control_0.rx_digitalreset gmii_to_sgmii_converter_0.tse_rx_digitalreset 
    set_connection_parameter_value xcvr_reset_control_0.rx_digitalreset/gmii_to_sgmii_converter_0.tse_rx_digitalreset endPort {}
    set_connection_parameter_value xcvr_reset_control_0.rx_digitalreset/gmii_to_sgmii_converter_0.tse_rx_digitalreset endPortLSB {0}
    set_connection_parameter_value xcvr_reset_control_0.rx_digitalreset/gmii_to_sgmii_converter_0.tse_rx_digitalreset startPort {}
    set_connection_parameter_value xcvr_reset_control_0.rx_digitalreset/gmii_to_sgmii_converter_0.tse_rx_digitalreset startPortLSB {0}
    set_connection_parameter_value xcvr_reset_control_0.rx_digitalreset/gmii_to_sgmii_converter_0.tse_rx_digitalreset width {0}

    add_connection xcvr_reset_control_0.rx_is_lockedtodata gmii_to_sgmii_converter_0.tse_rx_is_lockedtodata 
    set_connection_parameter_value xcvr_reset_control_0.rx_is_lockedtodata/gmii_to_sgmii_converter_0.tse_rx_is_lockedtodata endPort {}
    set_connection_parameter_value xcvr_reset_control_0.rx_is_lockedtodata/gmii_to_sgmii_converter_0.tse_rx_is_lockedtodata endPortLSB {0}
    set_connection_parameter_value xcvr_reset_control_0.rx_is_lockedtodata/gmii_to_sgmii_converter_0.tse_rx_is_lockedtodata startPort {}
    set_connection_parameter_value xcvr_reset_control_0.rx_is_lockedtodata/gmii_to_sgmii_converter_0.tse_rx_is_lockedtodata startPortLSB {0}
    set_connection_parameter_value xcvr_reset_control_0.rx_is_lockedtodata/gmii_to_sgmii_converter_0.tse_rx_is_lockedtodata width {0}

    add_connection xcvr_reset_control_0.tx_analogreset gmii_to_sgmii_converter_0.tse_tx_analogreset 
    set_connection_parameter_value xcvr_reset_control_0.tx_analogreset/gmii_to_sgmii_converter_0.tse_tx_analogreset endPort {}
    set_connection_parameter_value xcvr_reset_control_0.tx_analogreset/gmii_to_sgmii_converter_0.tse_tx_analogreset endPortLSB {0}
    set_connection_parameter_value xcvr_reset_control_0.tx_analogreset/gmii_to_sgmii_converter_0.tse_tx_analogreset startPort {}
    set_connection_parameter_value xcvr_reset_control_0.tx_analogreset/gmii_to_sgmii_converter_0.tse_tx_analogreset startPortLSB {0}
    set_connection_parameter_value xcvr_reset_control_0.tx_analogreset/gmii_to_sgmii_converter_0.tse_tx_analogreset width {0}

    add_connection xcvr_reset_control_0.tx_cal_busy gmii_to_sgmii_converter_0.tse_tx_cal_busy 
    set_connection_parameter_value xcvr_reset_control_0.tx_cal_busy/gmii_to_sgmii_converter_0.tse_tx_cal_busy endPort {}
    set_connection_parameter_value xcvr_reset_control_0.tx_cal_busy/gmii_to_sgmii_converter_0.tse_tx_cal_busy endPortLSB {0}
    set_connection_parameter_value xcvr_reset_control_0.tx_cal_busy/gmii_to_sgmii_converter_0.tse_tx_cal_busy startPort {}
    set_connection_parameter_value xcvr_reset_control_0.tx_cal_busy/gmii_to_sgmii_converter_0.tse_tx_cal_busy startPortLSB {0}
    set_connection_parameter_value xcvr_reset_control_0.tx_cal_busy/gmii_to_sgmii_converter_0.tse_tx_cal_busy width {0}

    add_connection xcvr_reset_control_0.tx_digitalreset gmii_to_sgmii_converter_0.tse_tx_digitalreset 
    set_connection_parameter_value xcvr_reset_control_0.tx_digitalreset/gmii_to_sgmii_converter_0.tse_tx_digitalreset endPort {}
    set_connection_parameter_value xcvr_reset_control_0.tx_digitalreset/gmii_to_sgmii_converter_0.tse_tx_digitalreset endPortLSB {0}
    set_connection_parameter_value xcvr_reset_control_0.tx_digitalreset/gmii_to_sgmii_converter_0.tse_tx_digitalreset startPort {}
    set_connection_parameter_value xcvr_reset_control_0.tx_digitalreset/gmii_to_sgmii_converter_0.tse_tx_digitalreset startPortLSB {0}
    set_connection_parameter_value xcvr_reset_control_0.tx_digitalreset/gmii_to_sgmii_converter_0.tse_tx_digitalreset width {0}

    add_connection pll_tse_txclk.tx_serial_clk gmii_to_sgmii_converter_0.tse_tx_serial_clk 

    add_connection clk_0.clk_reset clk_125.clk_in_reset 

    add_connection clk_125.clk_reset xcvr_reset_control_0.reset 

    add_connection clk_0.clk_reset gmii_to_sgmii_converter_0.reset_in 

    # exported interfaces
    add_interface clk clock sink
    set_interface_property clk EXPORT_OF clk_0.clk_in
    # add_interface clk_125_bridge clock sink
    # set_interface_property clk_125_bridge EXPORT_OF clk_125_bridge.in_clk
    add_interface clk_125 clock sink
    set_interface_property clk_125 EXPORT_OF clk_125.clk_in
    add_interface emac conduit end
    set_interface_property emac EXPORT_OF gmii_to_sgmii_converter_0.emac
    add_interface emac_gtx_clk clock sink
    set_interface_property emac_gtx_clk EXPORT_OF gmii_to_sgmii_converter_0.emac_gtx_clk
    add_interface emac_rx_clk_in clock source
    set_interface_property emac_rx_clk_in EXPORT_OF gmii_to_sgmii_converter_0.emac_rx_clk_in
    add_interface emac_rx_reset reset sink
    set_interface_property emac_rx_reset EXPORT_OF gmii_to_sgmii_converter_0.emac_rx_reset
    add_interface emac_tx_clk_in clock source
    set_interface_property emac_tx_clk_in EXPORT_OF gmii_to_sgmii_converter_0.emac_tx_clk_in
    add_interface emac_tx_reset reset sink
    set_interface_property emac_tx_reset EXPORT_OF gmii_to_sgmii_converter_0.emac_tx_reset
    add_interface pcs_control_port avalon slave
    set_interface_property pcs_control_port EXPORT_OF gmii_to_sgmii_converter_0.eth_tse_control_port
    add_interface gmii_to_sgmii_adapter_avalon_slave avalon slave
    set_interface_property gmii_to_sgmii_adapter_avalon_slave EXPORT_OF gmii_to_sgmii_converter_0.gmii_to_sgmii_adapter_avalon_slave
    add_interface emac_mdio conduit end
    set_interface_property emac_mdio EXPORT_OF gmii_to_sgmii_converter_0.hps_emac_mdio
    add_interface emac_ptp conduit end
    set_interface_property emac_ptp EXPORT_OF gmii_to_sgmii_converter_0.hps_emac_ptp
    add_interface tse_rx_is_lockedtoref conduit end
    set_interface_property tse_rx_is_lockedtoref EXPORT_OF gmii_to_sgmii_converter_0.tse_rx_is_lockedtoref
    add_interface tse_rx_set_locktodata conduit end
    set_interface_property tse_rx_set_locktodata EXPORT_OF gmii_to_sgmii_converter_0.tse_rx_set_locktodata
    add_interface tse_rx_set_locktoref conduit end
    set_interface_property tse_rx_set_locktoref EXPORT_OF gmii_to_sgmii_converter_0.tse_rx_set_locktoref
    add_interface tse_serdes_control_connection conduit end
    set_interface_property tse_serdes_control_connection EXPORT_OF gmii_to_sgmii_converter_0.tse_serdes_control_connection
    add_interface tse_serial_connection conduit end
    set_interface_property tse_serial_connection EXPORT_OF gmii_to_sgmii_converter_0.tse_serial_connection
    add_interface tse_sgmii_status_connection conduit end
    set_interface_property tse_sgmii_status_connection EXPORT_OF gmii_to_sgmii_converter_0.tse_sgmii_status_connection
    add_interface tse_status_led_connection conduit end
    set_interface_property tse_status_led_connection EXPORT_OF gmii_to_sgmii_converter_0.tse_status_led_connection
    add_interface reset reset sink
    set_interface_property reset EXPORT_OF clk_0.clk_in_reset
    add_interface xcvr_reset_control_0_pll_select conduit end
    set_interface_property xcvr_reset_control_0_pll_select EXPORT_OF xcvr_reset_control_0.pll_select
    add_interface xcvr_reset_control_0_rx_ready conduit end
    set_interface_property xcvr_reset_control_0_rx_ready EXPORT_OF xcvr_reset_control_0.rx_ready
    add_interface xcvr_reset_control_0_tx_ready conduit end
    set_interface_property xcvr_reset_control_0_tx_ready EXPORT_OF xcvr_reset_control_0.tx_ready

    # interconnect requirements
    set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {HANDSHAKE}
    set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}
    set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}

save_system ${sub_qsys_sgmii}.qsys

