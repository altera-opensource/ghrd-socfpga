#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2023 Intel Corporation.
#
#****************************************************************************
#
# This script construct Peripherals subsystem for higher level integration later.
# The Makefile in $prjroot folder will pass in variable needed by this TCL as defined
# in the subsystem Makefile automatically. User will have the ability to modify the 
# defined variable dynamically during (MAKE) target flow of generate_from_tcl.
#
#****************************************************************************
set currentdir [pwd]
set foldername [file tail $currentdir]
puts "\[GHRD:info\] Directory name: $foldername"

puts "\[GHRD:info\] \$prjroot = ${prjroot} "
source ${prjroot}/arguments_solver.tcl
source ${prjroot}/utils.tcl

if {$board == "cvr"} {
	    source $prjroot/board/board_cvr_config.tcl
	} else {
	    source $prjroot/board/board_DK-A5E065BB32AES1_config.tcl
	}

set subsys_name $foldername

package require -exact qsys 23.4

# create the system "fpga_rgmii_subsys"
proc do_create_fpga_rgmii_subsys {} {
        global subsys_name
        global device
	global device_family
	
	# create the system
	#comment_off- create_system fpga_rgmii_subsys
	create_system $subsys_name
	#comment_off- set_project_property BOARD {default}
	#comment_off- set_project_property DEVICE {A5ED065BB32AE5SR0}
	set_project_property DEVICE $device
	#comment_off- set_project_property DEVICE_FAMILY {Agilex 5}
	set_project_property DEVICE_FAMILY $device_family
	#comment_off- set_project_property HIDE_FROM_IP_CATALOG {false}
	#comment_off- set_use_testbench_naming_pattern 0 {}

	# add HDL parameters

	# add the components
	#comment_off- add_component clock_in ip/fpga_rgmii_subsys/clock_in.ip altera_clock_bridge altera_clock_bridge_inst 19.2.0
	add_component clock_in ip/$subsys_name/clock_in.ip altera_clock_bridge altera_clock_bridge_inst 
	load_component clock_in
	set_component_parameter_value EXPLICIT_CLOCK_RATE {100000000.0}
	set_component_parameter_value NUM_CLOCK_OUTPUTS {1}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation clock_in
	remove_instantiation_interfaces_and_ports
	add_instantiation_interface in_clk clock INPUT
	set_instantiation_interface_parameter_value in_clk clockRate {0}
	set_instantiation_interface_parameter_value in_clk externallyDriven {false}
	set_instantiation_interface_parameter_value in_clk ptfSchematicName {}
	add_instantiation_interface_port in_clk in_clk clk 1 STD_LOGIC Input
	add_instantiation_interface out_clk clock OUTPUT
	set_instantiation_interface_parameter_value out_clk associatedDirectClock {in_clk}
	set_instantiation_interface_parameter_value out_clk clockRate {100000000}
	set_instantiation_interface_parameter_value out_clk clockRateKnown {true}
	set_instantiation_interface_parameter_value out_clk externallyDriven {false}
	set_instantiation_interface_parameter_value out_clk ptfSchematicName {}
	set_instantiation_interface_sysinfo_parameter_value out_clk clock_rate {100000000}
	add_instantiation_interface_port out_clk out_clk clk 1 STD_LOGIC Output
	save_instantiation
	#comment_off- add_component intel_gmii_to_rgmii_converter_0 ip/fpga_rgmii_subsys/intel_gmii_to_rgmii_converter_0.ip intel_gmii_to_rgmii_converter intel_gmii_to_rgmii_converter_inst 1.1.0
	add_component intel_gmii_to_rgmii_converter_0 ip/$subsys_name/intel_gmii_to_rgmii_converter_0.ip intel_gmii_to_rgmii_converter intel_gmii_to_rgmii_converter_inst 
	load_component intel_gmii_to_rgmii_converter_0
	set_component_parameter_value ADVANCED_MODE {0}
	set_component_parameter_value RX_PIPELINE_DEPTH {5}
	set_component_parameter_value TX_PIPELINE_DEPTH {2}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation intel_gmii_to_rgmii_converter_0
	remove_instantiation_interfaces_and_ports
	add_instantiation_interface hps_gmii conduit INPUT
	set_instantiation_interface_parameter_value hps_gmii associatedClock {}
	set_instantiation_interface_parameter_value hps_gmii associatedReset {}
	set_instantiation_interface_parameter_value hps_gmii prSafe {false}
	add_instantiation_interface_port hps_gmii hps_gmii_mac_tx_clk_o mac_tx_clk_o 1 STD_LOGIC Input
	add_instantiation_interface_port hps_gmii hps_gmii_mac_rst_tx_n mac_rst_tx_n 1 STD_LOGIC Input
	add_instantiation_interface_port hps_gmii hps_gmii_mac_rst_rx_n mac_rst_rx_n 1 STD_LOGIC Input
	add_instantiation_interface_port hps_gmii hps_gmii_mac_txd_o mac_txd_o 8 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port hps_gmii hps_gmii_mac_txen mac_txen 1 STD_LOGIC Input
	add_instantiation_interface_port hps_gmii hps_gmii_mac_txer mac_txer 1 STD_LOGIC Input
	add_instantiation_interface_port hps_gmii hps_gmii_mac_speed mac_speed 3 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port hps_gmii hps_gmii_mac_tx_clk_i mac_tx_clk_i 1 STD_LOGIC Output
	add_instantiation_interface_port hps_gmii hps_gmii_mac_rx_clk mac_rx_clk 1 STD_LOGIC Output
	add_instantiation_interface_port hps_gmii hps_gmii_mac_rxdv mac_rxdv 1 STD_LOGIC Output
	add_instantiation_interface_port hps_gmii hps_gmii_mac_rxer mac_rxer 1 STD_LOGIC Output
	add_instantiation_interface_port hps_gmii hps_gmii_mac_rxd mac_rxd 8 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port hps_gmii hps_gmii_mac_col mac_col 1 STD_LOGIC Output
	add_instantiation_interface_port hps_gmii hps_gmii_mac_crs mac_crs 1 STD_LOGIC Output
	add_instantiation_interface phy_rgmii conduit INPUT
	set_instantiation_interface_parameter_value phy_rgmii associatedClock {}
	set_instantiation_interface_parameter_value phy_rgmii associatedReset {}
	set_instantiation_interface_parameter_value phy_rgmii prSafe {false}
	add_instantiation_interface_port phy_rgmii phy_rgmii_rgmii_rx_clk rgmii_rx_clk 1 STD_LOGIC Input
	add_instantiation_interface_port phy_rgmii phy_rgmii_rgmii_rxd rgmii_rxd 4 STD_LOGIC_VECTOR Input
	add_instantiation_interface_port phy_rgmii phy_rgmii_rgmii_rx_ctl rgmii_rx_ctl 1 STD_LOGIC Input
	add_instantiation_interface_port phy_rgmii phy_rgmii_rgmii_tx_clk rgmii_tx_clk 1 STD_LOGIC Output
	add_instantiation_interface_port phy_rgmii phy_rgmii_rgmii_txd rgmii_txd 4 STD_LOGIC_VECTOR Output
	add_instantiation_interface_port phy_rgmii phy_rgmii_rgmii_tx_ctl rgmii_tx_ctl 1 STD_LOGIC Output
	add_instantiation_interface pll_250m_tx_clock clock INPUT
	set_instantiation_interface_parameter_value pll_250m_tx_clock clockRate {0}
	set_instantiation_interface_parameter_value pll_250m_tx_clock externallyDriven {false}
	set_instantiation_interface_parameter_value pll_250m_tx_clock ptfSchematicName {}
	add_instantiation_interface_port pll_250m_tx_clock pll_250m_tx_clock_clk clk 1 STD_LOGIC Input
	add_instantiation_interface pll_125m_tx_clock clock INPUT
	set_instantiation_interface_parameter_value pll_125m_tx_clock clockRate {0}
	set_instantiation_interface_parameter_value pll_125m_tx_clock externallyDriven {false}
	set_instantiation_interface_parameter_value pll_125m_tx_clock ptfSchematicName {}
	add_instantiation_interface_port pll_125m_tx_clock pll_125m_tx_clock_clk clk 1 STD_LOGIC Input
	add_instantiation_interface pll_25m_clock clock INPUT
	set_instantiation_interface_parameter_value pll_25m_clock clockRate {0}
	set_instantiation_interface_parameter_value pll_25m_clock externallyDriven {false}
	set_instantiation_interface_parameter_value pll_25m_clock ptfSchematicName {}
	add_instantiation_interface_port pll_25m_clock pll_25m_clock_clk clk 1 STD_LOGIC Input
	add_instantiation_interface pll_2_5m_clock clock INPUT
	set_instantiation_interface_parameter_value pll_2_5m_clock clockRate {0}
	set_instantiation_interface_parameter_value pll_2_5m_clock externallyDriven {false}
	set_instantiation_interface_parameter_value pll_2_5m_clock ptfSchematicName {}
	add_instantiation_interface_port pll_2_5m_clock pll_2_5m_clock_clk clk 1 STD_LOGIC Input
	add_instantiation_interface locked_pll_250m_tx conduit INPUT
	set_instantiation_interface_parameter_value locked_pll_250m_tx associatedClock {}
	set_instantiation_interface_parameter_value locked_pll_250m_tx associatedReset {}
	set_instantiation_interface_parameter_value locked_pll_250m_tx prSafe {false}
	add_instantiation_interface_port locked_pll_250m_tx locked_pll_250m_tx_export export 1 STD_LOGIC Input
	add_instantiation_interface peri_reset reset INPUT
	set_instantiation_interface_parameter_value peri_reset associatedClock {}
	set_instantiation_interface_parameter_value peri_reset synchronousEdges {NONE}
	add_instantiation_interface_port peri_reset peri_reset_reset reset 1 STD_LOGIC Input
	add_instantiation_interface peri_clock clock INPUT
	set_instantiation_interface_parameter_value peri_clock clockRate {0}
	set_instantiation_interface_parameter_value peri_clock externallyDriven {false}
	set_instantiation_interface_parameter_value peri_clock ptfSchematicName {}
	add_instantiation_interface_port peri_clock peri_clock_clk clk 1 STD_LOGIC Input
	save_instantiation
	#comment_off- add_component iopll_0 ip/fpga_rgmii_subsys/iopll_0.ip altera_iopll iopll_0 19.3.1
	add_component iopll_0 ip/$subsys_name/iopll_0.ip altera_iopll iopll_0 
	load_component iopll_0
	set_component_parameter_value gui_active_clk {0}
	set_component_parameter_value gui_c_cnt_in_src0 {c_m_cnt_in_src_ph_mux_clk}
	set_component_parameter_value gui_c_cnt_in_src1 {c_m_cnt_in_src_ph_mux_clk}
	set_component_parameter_value gui_c_cnt_in_src2 {c_m_cnt_in_src_ph_mux_clk}
	set_component_parameter_value gui_c_cnt_in_src3 {c_m_cnt_in_src_ph_mux_clk}
	set_component_parameter_value gui_c_cnt_in_src4 {c_m_cnt_in_src_ph_mux_clk}
	set_component_parameter_value gui_c_cnt_in_src5 {c_m_cnt_in_src_ph_mux_clk}
	set_component_parameter_value gui_c_cnt_in_src6 {c_m_cnt_in_src_ph_mux_clk}
	set_component_parameter_value gui_c_cnt_in_src7 {c_m_cnt_in_src_ph_mux_clk}
	set_component_parameter_value gui_c_cnt_in_src8 {c_m_cnt_in_src_ph_mux_clk}
	set_component_parameter_value gui_cal_code_hex_file {iossm.hex}
	set_component_parameter_value gui_cal_converge {0}
	set_component_parameter_value gui_cal_error {cal_clean}
	set_component_parameter_value gui_cascade_counter0 {0}
	set_component_parameter_value gui_cascade_counter1 {0}
	set_component_parameter_value gui_cascade_counter10 {0}
	set_component_parameter_value gui_cascade_counter11 {0}
	set_component_parameter_value gui_cascade_counter12 {0}
	set_component_parameter_value gui_cascade_counter13 {0}
	set_component_parameter_value gui_cascade_counter14 {0}
	set_component_parameter_value gui_cascade_counter15 {0}
	set_component_parameter_value gui_cascade_counter16 {0}
	set_component_parameter_value gui_cascade_counter17 {0}
	set_component_parameter_value gui_cascade_counter2 {0}
	set_component_parameter_value gui_cascade_counter3 {0}
	set_component_parameter_value gui_cascade_counter4 {0}
	set_component_parameter_value gui_cascade_counter5 {0}
	set_component_parameter_value gui_cascade_counter6 {0}
	set_component_parameter_value gui_cascade_counter7 {0}
	set_component_parameter_value gui_cascade_counter8 {0}
	set_component_parameter_value gui_cascade_counter9 {0}
	set_component_parameter_value gui_cascade_outclk_index {5}
	set_component_parameter_value gui_clk_bad {0}
	set_component_parameter_value gui_clock_name_global {0}
	set_component_parameter_value gui_clock_name_string0 {outclk0}
	set_component_parameter_value gui_clock_name_string1 {outclk1}
	set_component_parameter_value gui_clock_name_string10 {outclk10}
	set_component_parameter_value gui_clock_name_string11 {outclk11}
	set_component_parameter_value gui_clock_name_string12 {outclk12}
	set_component_parameter_value gui_clock_name_string13 {outclk13}
	set_component_parameter_value gui_clock_name_string14 {outclk14}
	set_component_parameter_value gui_clock_name_string15 {outclk15}
	set_component_parameter_value gui_clock_name_string16 {outclk16}
	set_component_parameter_value gui_clock_name_string17 {outclk17}
	set_component_parameter_value gui_clock_name_string2 {outclk2}
	set_component_parameter_value gui_clock_name_string3 {outclk3}
	set_component_parameter_value gui_clock_name_string4 {outclk4}
	set_component_parameter_value gui_clock_name_string5 {outclk5}
	set_component_parameter_value gui_clock_name_string6 {outclk6}
	set_component_parameter_value gui_clock_name_string7 {outclk7}
	set_component_parameter_value gui_clock_name_string8 {outclk8}
	set_component_parameter_value gui_clock_name_string9 {outclk9}
	set_component_parameter_value gui_clock_to_compensate {0}
	set_component_parameter_value gui_debug_mode {0}
	set_component_parameter_value gui_divide_factor_c0 {6}
	set_component_parameter_value gui_divide_factor_c1 {6}
	set_component_parameter_value gui_divide_factor_c10 {6}
	set_component_parameter_value gui_divide_factor_c11 {6}
	set_component_parameter_value gui_divide_factor_c12 {6}
	set_component_parameter_value gui_divide_factor_c13 {6}
	set_component_parameter_value gui_divide_factor_c14 {6}
	set_component_parameter_value gui_divide_factor_c15 {6}
	set_component_parameter_value gui_divide_factor_c16 {6}
	set_component_parameter_value gui_divide_factor_c17 {6}
	set_component_parameter_value gui_divide_factor_c2 {6}
	set_component_parameter_value gui_divide_factor_c3 {6}
	set_component_parameter_value gui_divide_factor_c4 {6}
	set_component_parameter_value gui_divide_factor_c5 {6}
	set_component_parameter_value gui_divide_factor_c6 {6}
	set_component_parameter_value gui_divide_factor_c7 {6}
	set_component_parameter_value gui_divide_factor_c8 {6}
	set_component_parameter_value gui_divide_factor_c9 {6}
	set_component_parameter_value gui_divide_factor_n {1}
	set_component_parameter_value gui_dps_cntr {C0}
	set_component_parameter_value gui_dps_dir {Positive}
	set_component_parameter_value gui_dps_num {1}
	set_component_parameter_value gui_dsm_out_sel {1st_order}
	set_component_parameter_value gui_duty_cycle0 {50.0}
	set_component_parameter_value gui_duty_cycle1 {50.0}
	set_component_parameter_value gui_duty_cycle10 {50.0}
	set_component_parameter_value gui_duty_cycle11 {50.0}
	set_component_parameter_value gui_duty_cycle12 {50.0}
	set_component_parameter_value gui_duty_cycle13 {50.0}
	set_component_parameter_value gui_duty_cycle14 {50.0}
	set_component_parameter_value gui_duty_cycle15 {50.0}
	set_component_parameter_value gui_duty_cycle16 {50.0}
	set_component_parameter_value gui_duty_cycle17 {50.0}
	set_component_parameter_value gui_duty_cycle2 {50.0}
	set_component_parameter_value gui_duty_cycle3 {50.0}
	set_component_parameter_value gui_duty_cycle4 {50.0}
	set_component_parameter_value gui_duty_cycle5 {50.0}
	set_component_parameter_value gui_duty_cycle6 {50.0}
	set_component_parameter_value gui_duty_cycle7 {50.0}
	set_component_parameter_value gui_duty_cycle8 {50.0}
	set_component_parameter_value gui_duty_cycle9 {50.0}
	set_component_parameter_value gui_en_adv_params {0}
	set_component_parameter_value gui_en_dps_ports {0}
	set_component_parameter_value gui_en_extclkout_ports {0}
	set_component_parameter_value gui_en_iossm_reconf {0}
	set_component_parameter_value gui_en_lvds_ports {Disabled}
	set_component_parameter_value gui_en_periphery_ports {0}
	set_component_parameter_value gui_en_phout_ports {0}
	set_component_parameter_value gui_en_reconf {0}
	set_component_parameter_value gui_enable_cascade_in {0}
	set_component_parameter_value gui_enable_cascade_out {0}
	set_component_parameter_value gui_enable_mif_dps {0}
	set_component_parameter_value gui_enable_output_counter_cascading {0}
	set_component_parameter_value gui_enable_permit_cal {0}
	set_component_parameter_value gui_enable_upstream_out_clk {0}
	set_component_parameter_value gui_existing_mif_file_path {~/pll.mif}
	set_component_parameter_value gui_extclkout_0_source {C0}
	set_component_parameter_value gui_extclkout_1_source {C0}
	set_component_parameter_value gui_extclkout_source {C0}
	set_component_parameter_value gui_feedback_clock {Global Clock}
	set_component_parameter_value gui_fix_vco_frequency {0}
	set_component_parameter_value gui_fixed_vco_frequency {600.0}
	set_component_parameter_value gui_fixed_vco_frequency_ps {1667.0}
	set_component_parameter_value gui_frac_multiply_factor {1.0}
	set_component_parameter_value gui_fractional_cout {32}
	set_component_parameter_value gui_include_iossm {0}
	set_component_parameter_value gui_location_type {I/O Bank}
	set_component_parameter_value gui_lock_setting {Low Lock Time}
	set_component_parameter_value gui_mif_config_name {unnamed}
	set_component_parameter_value gui_mif_gen_options {Generate New MIF File}
	set_component_parameter_value gui_multiply_factor {6}
	set_component_parameter_value gui_new_mif_file_path {~/pll.mif}
	set_component_parameter_value gui_number_of_clocks {4}
	set_component_parameter_value gui_operation_mode {direct}
	set_component_parameter_value gui_output_clock_frequency0 {250.0}
	set_component_parameter_value gui_output_clock_frequency1 {125.0}
	set_component_parameter_value gui_output_clock_frequency10 {100.0}
	set_component_parameter_value gui_output_clock_frequency11 {100.0}
	set_component_parameter_value gui_output_clock_frequency12 {100.0}
	set_component_parameter_value gui_output_clock_frequency13 {100.0}
	set_component_parameter_value gui_output_clock_frequency14 {100.0}
	set_component_parameter_value gui_output_clock_frequency15 {100.0}
	set_component_parameter_value gui_output_clock_frequency16 {100.0}
	set_component_parameter_value gui_output_clock_frequency17 {100.0}
	set_component_parameter_value gui_output_clock_frequency2 {25.0}
	set_component_parameter_value gui_output_clock_frequency3 {2.5}
	set_component_parameter_value gui_output_clock_frequency4 {100.0}
	set_component_parameter_value gui_output_clock_frequency5 {100.0}
	set_component_parameter_value gui_output_clock_frequency6 {100.0}
	set_component_parameter_value gui_output_clock_frequency7 {100.0}
	set_component_parameter_value gui_output_clock_frequency8 {100.0}
	set_component_parameter_value gui_output_clock_frequency9 {100.0}
	set_component_parameter_value gui_output_clock_frequency_ps0 {4000.0}
	set_component_parameter_value gui_output_clock_frequency_ps1 {8000.0}
	set_component_parameter_value gui_output_clock_frequency_ps10 {10000.0}
	set_component_parameter_value gui_output_clock_frequency_ps11 {10000.0}
	set_component_parameter_value gui_output_clock_frequency_ps12 {10000.0}
	set_component_parameter_value gui_output_clock_frequency_ps13 {10000.0}
	set_component_parameter_value gui_output_clock_frequency_ps14 {10000.0}
	set_component_parameter_value gui_output_clock_frequency_ps15 {10000.0}
	set_component_parameter_value gui_output_clock_frequency_ps16 {10000.0}
	set_component_parameter_value gui_output_clock_frequency_ps17 {10000.0}
	set_component_parameter_value gui_output_clock_frequency_ps2 {40000.0}
	set_component_parameter_value gui_output_clock_frequency_ps3 {400000.0}
	set_component_parameter_value gui_output_clock_frequency_ps4 {10000.0}
	set_component_parameter_value gui_output_clock_frequency_ps5 {10000.0}
	set_component_parameter_value gui_output_clock_frequency_ps6 {10000.0}
	set_component_parameter_value gui_output_clock_frequency_ps7 {10000.0}
	set_component_parameter_value gui_output_clock_frequency_ps8 {10000.0}
	set_component_parameter_value gui_output_clock_frequency_ps9 {10000.0}
	set_component_parameter_value gui_parameter_table_hex_file {seq_params_sim.hex}
	set_component_parameter_value gui_phase_shift0 {0.0}
	set_component_parameter_value gui_phase_shift1 {0.0}
	set_component_parameter_value gui_phase_shift10 {0.0}
	set_component_parameter_value gui_phase_shift11 {0.0}
	set_component_parameter_value gui_phase_shift12 {0.0}
	set_component_parameter_value gui_phase_shift13 {0.0}
	set_component_parameter_value gui_phase_shift14 {0.0}
	set_component_parameter_value gui_phase_shift15 {0.0}
	set_component_parameter_value gui_phase_shift16 {0.0}
	set_component_parameter_value gui_phase_shift17 {0.0}
	set_component_parameter_value gui_phase_shift2 {0.0}
	set_component_parameter_value gui_phase_shift3 {0.0}
	set_component_parameter_value gui_phase_shift4 {0.0}
	set_component_parameter_value gui_phase_shift5 {0.0}
	set_component_parameter_value gui_phase_shift6 {0.0}
	set_component_parameter_value gui_phase_shift7 {0.0}
	set_component_parameter_value gui_phase_shift8 {0.0}
	set_component_parameter_value gui_phase_shift9 {0.0}
	set_component_parameter_value gui_phase_shift_deg0 {0.0}
	set_component_parameter_value gui_phase_shift_deg1 {0.0}
	set_component_parameter_value gui_phase_shift_deg10 {0.0}
	set_component_parameter_value gui_phase_shift_deg11 {0.0}
	set_component_parameter_value gui_phase_shift_deg12 {0.0}
	set_component_parameter_value gui_phase_shift_deg13 {0.0}
	set_component_parameter_value gui_phase_shift_deg14 {0.0}
	set_component_parameter_value gui_phase_shift_deg15 {0.0}
	set_component_parameter_value gui_phase_shift_deg16 {0.0}
	set_component_parameter_value gui_phase_shift_deg17 {0.0}
	set_component_parameter_value gui_phase_shift_deg2 {0.0}
	set_component_parameter_value gui_phase_shift_deg3 {0.0}
	set_component_parameter_value gui_phase_shift_deg4 {0.0}
	set_component_parameter_value gui_phase_shift_deg5 {0.0}
	set_component_parameter_value gui_phase_shift_deg6 {0.0}
	set_component_parameter_value gui_phase_shift_deg7 {0.0}
	set_component_parameter_value gui_phase_shift_deg8 {0.0}
	set_component_parameter_value gui_phase_shift_deg9 {0.0}
	set_component_parameter_value gui_phout_division {1}
	set_component_parameter_value gui_pll_auto_reset {0}
	set_component_parameter_value gui_pll_bandwidth_preset {Low}
	set_component_parameter_value gui_pll_cal_done {0}
	set_component_parameter_value gui_pll_cascading_mode {adjpllin}
	set_component_parameter_value gui_pll_freqcal_en {1}
	set_component_parameter_value gui_pll_freqcal_req_flag {1}
	set_component_parameter_value gui_pll_m_cnt_in_src {c_m_cnt_in_src_ph_mux_clk}
	set_component_parameter_value gui_pll_mode {Integer-N PLL}
	set_component_parameter_value gui_pll_tclk_mux_en {0}
	set_component_parameter_value gui_pll_tclk_sel {pll_tclk_m_src}
	set_component_parameter_value gui_pll_type {S10_Simple}
	set_component_parameter_value gui_pll_vco_freq_band_0 {pll_freq_clk0_band18}
	set_component_parameter_value gui_pll_vco_freq_band_1 {pll_freq_clk1_band18}
	set_component_parameter_value gui_prot_mode {UNUSED}
	set_component_parameter_value gui_ps_units0 {ps}
	set_component_parameter_value gui_ps_units1 {ps}
	set_component_parameter_value gui_ps_units10 {ps}
	set_component_parameter_value gui_ps_units11 {ps}
	set_component_parameter_value gui_ps_units12 {ps}
	set_component_parameter_value gui_ps_units13 {ps}
	set_component_parameter_value gui_ps_units14 {ps}
	set_component_parameter_value gui_ps_units15 {ps}
	set_component_parameter_value gui_ps_units16 {ps}
	set_component_parameter_value gui_ps_units17 {ps}
	set_component_parameter_value gui_ps_units2 {ps}
	set_component_parameter_value gui_ps_units3 {ps}
	set_component_parameter_value gui_ps_units4 {ps}
	set_component_parameter_value gui_ps_units5 {ps}
	set_component_parameter_value gui_ps_units6 {ps}
	set_component_parameter_value gui_ps_units7 {ps}
	set_component_parameter_value gui_ps_units8 {ps}
	set_component_parameter_value gui_ps_units9 {ps}
	set_component_parameter_value gui_refclk1_frequency {100.0}
	set_component_parameter_value gui_refclk_might_change {0}
	set_component_parameter_value gui_refclk_switch {0}
	set_component_parameter_value gui_reference_clock_frequency {100.0}
	set_component_parameter_value gui_reference_clock_frequency_ps {10000.0}
	set_component_parameter_value gui_simulation_type {0}
	set_component_parameter_value gui_skip_sdc_generation {0}
	set_component_parameter_value gui_switchover_delay {0}
	set_component_parameter_value gui_switchover_mode {Automatic Switchover}
	set_component_parameter_value gui_use_NDFB_modes {0}
	set_component_parameter_value gui_use_coreclk {0}
	set_component_parameter_value gui_use_locked {1}
	set_component_parameter_value gui_use_logical {0}
	set_component_parameter_value gui_user_base_address {0}
	set_component_parameter_value gui_usr_device_speed_grade {1}
	set_component_parameter_value gui_vco_frequency {600.0}
	set_component_parameter_value hp_qsys_scripting_mode {0}
	set_component_parameter_value system_info_device_iobank_rev {}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation iopll_0
	remove_instantiation_interfaces_and_ports
	set_instantiation_assignment_value embeddedsw.dts.compatible {altr,pll}
	set_instantiation_assignment_value embeddedsw.dts.group {clock}
	set_instantiation_assignment_value embeddedsw.dts.vendor {altr}
	add_instantiation_interface refclk clock INPUT
	set_instantiation_interface_parameter_value refclk clockRate {100000000}
	set_instantiation_interface_parameter_value refclk externallyDriven {false}
	set_instantiation_interface_parameter_value refclk ptfSchematicName {}
	set_instantiation_interface_assignment_value refclk ui.blockdiagram.direction {input}
	add_instantiation_interface_port refclk refclk clk 1 STD_LOGIC Input
	add_instantiation_interface locked conduit INPUT
	set_instantiation_interface_parameter_value locked associatedClock {}
	set_instantiation_interface_parameter_value locked associatedReset {}
	set_instantiation_interface_parameter_value locked prSafe {false}
	set_instantiation_interface_assignment_value locked ui.blockdiagram.direction {output}
	add_instantiation_interface_port locked locked export 1 STD_LOGIC Output
	add_instantiation_interface reset reset INPUT
	set_instantiation_interface_parameter_value reset associatedClock {}
	set_instantiation_interface_parameter_value reset synchronousEdges {NONE}
	set_instantiation_interface_assignment_value reset ui.blockdiagram.direction {input}
	add_instantiation_interface_port reset rst reset 1 STD_LOGIC Input
	add_instantiation_interface outclk0 clock OUTPUT
	set_instantiation_interface_parameter_value outclk0 associatedDirectClock {}
	set_instantiation_interface_parameter_value outclk0 clockRate {250000000}
	set_instantiation_interface_parameter_value outclk0 clockRateKnown {true}
	set_instantiation_interface_parameter_value outclk0 externallyDriven {false}
	set_instantiation_interface_parameter_value outclk0 ptfSchematicName {}
	set_instantiation_interface_assignment_value outclk0 ui.blockdiagram.direction {output}
	set_instantiation_interface_sysinfo_parameter_value outclk0 clock_rate {250000000}
	add_instantiation_interface_port outclk0 outclk_0 clk 1 STD_LOGIC Output
	add_instantiation_interface outclk1 clock OUTPUT
	set_instantiation_interface_parameter_value outclk1 associatedDirectClock {}
	set_instantiation_interface_parameter_value outclk1 clockRate {125000000}
	set_instantiation_interface_parameter_value outclk1 clockRateKnown {true}
	set_instantiation_interface_parameter_value outclk1 externallyDriven {false}
	set_instantiation_interface_parameter_value outclk1 ptfSchematicName {}
	set_instantiation_interface_assignment_value outclk1 ui.blockdiagram.direction {output}
	set_instantiation_interface_sysinfo_parameter_value outclk1 clock_rate {125000000}
	add_instantiation_interface_port outclk1 outclk_1 clk 1 STD_LOGIC Output
	add_instantiation_interface outclk2 clock OUTPUT
	set_instantiation_interface_parameter_value outclk2 associatedDirectClock {}
	set_instantiation_interface_parameter_value outclk2 clockRate {25000000}
	set_instantiation_interface_parameter_value outclk2 clockRateKnown {true}
	set_instantiation_interface_parameter_value outclk2 externallyDriven {false}
	set_instantiation_interface_parameter_value outclk2 ptfSchematicName {}
	set_instantiation_interface_assignment_value outclk2 ui.blockdiagram.direction {output}
	set_instantiation_interface_sysinfo_parameter_value outclk2 clock_rate {25000000}
	add_instantiation_interface_port outclk2 outclk_2 clk 1 STD_LOGIC Output
	add_instantiation_interface outclk3 clock OUTPUT
	set_instantiation_interface_parameter_value outclk3 associatedDirectClock {}
	set_instantiation_interface_parameter_value outclk3 clockRate {2500000}
	set_instantiation_interface_parameter_value outclk3 clockRateKnown {true}
	set_instantiation_interface_parameter_value outclk3 externallyDriven {false}
	set_instantiation_interface_parameter_value outclk3 ptfSchematicName {}
	set_instantiation_interface_assignment_value outclk3 ui.blockdiagram.direction {output}
	set_instantiation_interface_sysinfo_parameter_value outclk3 clock_rate {2500000}
	add_instantiation_interface_port outclk3 outclk_3 clk 1 STD_LOGIC Output
	save_instantiation
	#comment_off- add_component reset_in ip/fpga_rgmii_subsys/reset_in.ip altera_reset_bridge altera_reset_bridge_inst 19.2.0
	add_component reset_in ip/$subsys_name/reset_in.ip altera_reset_bridge altera_reset_bridge_inst 
	load_component reset_in
	set_component_parameter_value ACTIVE_LOW_RESET {0}
	set_component_parameter_value NUM_RESET_OUTPUTS {1}
	set_component_parameter_value SYNCHRONOUS_EDGES {deassert}
	set_component_parameter_value SYNC_RESET {0}
	set_component_parameter_value USE_RESET_REQUEST {0}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation reset_in
	remove_instantiation_interfaces_and_ports
	add_instantiation_interface clk clock INPUT
	set_instantiation_interface_parameter_value clk clockRate {0}
	set_instantiation_interface_parameter_value clk externallyDriven {false}
	set_instantiation_interface_parameter_value clk ptfSchematicName {}
	add_instantiation_interface_port clk clk clk 1 STD_LOGIC Input
	add_instantiation_interface in_reset reset INPUT
	set_instantiation_interface_parameter_value in_reset associatedClock {clk}
	set_instantiation_interface_parameter_value in_reset synchronousEdges {DEASSERT}
	add_instantiation_interface_port in_reset in_reset reset 1 STD_LOGIC Input
	add_instantiation_interface out_reset reset OUTPUT
	set_instantiation_interface_parameter_value out_reset associatedClock {clk}
	set_instantiation_interface_parameter_value out_reset associatedDirectReset {in_reset}
	set_instantiation_interface_parameter_value out_reset associatedResetSinks {in_reset}
	set_instantiation_interface_parameter_value out_reset synchronousEdges {DEASSERT}
	add_instantiation_interface_port out_reset out_reset reset 1 STD_LOGIC Output
	save_instantiation

	# add wirelevel expressions

	# preserve ports for debug

	# add the connections
	add_connection clock_in.out_clk/intel_gmii_to_rgmii_converter_0.peri_clock
	set_connection_parameter_value clock_in.out_clk/intel_gmii_to_rgmii_converter_0.peri_clock clockDomainSysInfo {-1}
	set_connection_parameter_value clock_in.out_clk/intel_gmii_to_rgmii_converter_0.peri_clock clockRateSysInfo {100000000.0}
	set_connection_parameter_value clock_in.out_clk/intel_gmii_to_rgmii_converter_0.peri_clock clockResetSysInfo {}
	set_connection_parameter_value clock_in.out_clk/intel_gmii_to_rgmii_converter_0.peri_clock resetDomainSysInfo {-1}
	add_connection clock_in.out_clk/iopll_0.refclk
	set_connection_parameter_value clock_in.out_clk/iopll_0.refclk clockDomainSysInfo {-1}
	set_connection_parameter_value clock_in.out_clk/iopll_0.refclk clockRateSysInfo {100000000.0}
	set_connection_parameter_value clock_in.out_clk/iopll_0.refclk clockResetSysInfo {}
	set_connection_parameter_value clock_in.out_clk/iopll_0.refclk resetDomainSysInfo {-1}
	add_connection clock_in.out_clk/reset_in.clk
	set_connection_parameter_value clock_in.out_clk/reset_in.clk clockDomainSysInfo {-1}
	set_connection_parameter_value clock_in.out_clk/reset_in.clk clockRateSysInfo {100000000.0}
	set_connection_parameter_value clock_in.out_clk/reset_in.clk clockResetSysInfo {}
	set_connection_parameter_value clock_in.out_clk/reset_in.clk resetDomainSysInfo {-1}
	add_connection iopll_0.locked/intel_gmii_to_rgmii_converter_0.locked_pll_250m_tx
	set_connection_parameter_value iopll_0.locked/intel_gmii_to_rgmii_converter_0.locked_pll_250m_tx endPort {}
	set_connection_parameter_value iopll_0.locked/intel_gmii_to_rgmii_converter_0.locked_pll_250m_tx endPortLSB {0}
	set_connection_parameter_value iopll_0.locked/intel_gmii_to_rgmii_converter_0.locked_pll_250m_tx startPort {}
	set_connection_parameter_value iopll_0.locked/intel_gmii_to_rgmii_converter_0.locked_pll_250m_tx startPortLSB {0}
	set_connection_parameter_value iopll_0.locked/intel_gmii_to_rgmii_converter_0.locked_pll_250m_tx width {0}
	add_connection iopll_0.outclk0/intel_gmii_to_rgmii_converter_0.pll_250m_tx_clock
	set_connection_parameter_value iopll_0.outclk0/intel_gmii_to_rgmii_converter_0.pll_250m_tx_clock clockDomainSysInfo {-1}
	set_connection_parameter_value iopll_0.outclk0/intel_gmii_to_rgmii_converter_0.pll_250m_tx_clock clockRateSysInfo {250000000.0}
	set_connection_parameter_value iopll_0.outclk0/intel_gmii_to_rgmii_converter_0.pll_250m_tx_clock clockResetSysInfo {}
	set_connection_parameter_value iopll_0.outclk0/intel_gmii_to_rgmii_converter_0.pll_250m_tx_clock resetDomainSysInfo {-1}
	add_connection iopll_0.outclk1/intel_gmii_to_rgmii_converter_0.pll_125m_tx_clock
	set_connection_parameter_value iopll_0.outclk1/intel_gmii_to_rgmii_converter_0.pll_125m_tx_clock clockDomainSysInfo {-1}
	set_connection_parameter_value iopll_0.outclk1/intel_gmii_to_rgmii_converter_0.pll_125m_tx_clock clockRateSysInfo {125000000.0}
	set_connection_parameter_value iopll_0.outclk1/intel_gmii_to_rgmii_converter_0.pll_125m_tx_clock clockResetSysInfo {}
	set_connection_parameter_value iopll_0.outclk1/intel_gmii_to_rgmii_converter_0.pll_125m_tx_clock resetDomainSysInfo {-1}
	add_connection iopll_0.outclk2/intel_gmii_to_rgmii_converter_0.pll_25m_clock
	set_connection_parameter_value iopll_0.outclk2/intel_gmii_to_rgmii_converter_0.pll_25m_clock clockDomainSysInfo {-1}
	set_connection_parameter_value iopll_0.outclk2/intel_gmii_to_rgmii_converter_0.pll_25m_clock clockRateSysInfo {25000000.0}
	set_connection_parameter_value iopll_0.outclk2/intel_gmii_to_rgmii_converter_0.pll_25m_clock clockResetSysInfo {}
	set_connection_parameter_value iopll_0.outclk2/intel_gmii_to_rgmii_converter_0.pll_25m_clock resetDomainSysInfo {-1}
	add_connection iopll_0.outclk3/intel_gmii_to_rgmii_converter_0.pll_2_5m_clock
	set_connection_parameter_value iopll_0.outclk3/intel_gmii_to_rgmii_converter_0.pll_2_5m_clock clockDomainSysInfo {-1}
	set_connection_parameter_value iopll_0.outclk3/intel_gmii_to_rgmii_converter_0.pll_2_5m_clock clockRateSysInfo {2500000.0}
	set_connection_parameter_value iopll_0.outclk3/intel_gmii_to_rgmii_converter_0.pll_2_5m_clock clockResetSysInfo {}
	set_connection_parameter_value iopll_0.outclk3/intel_gmii_to_rgmii_converter_0.pll_2_5m_clock resetDomainSysInfo {-1}
	add_connection reset_in.out_reset/intel_gmii_to_rgmii_converter_0.peri_reset
	set_connection_parameter_value reset_in.out_reset/intel_gmii_to_rgmii_converter_0.peri_reset clockDomainSysInfo {-1}
	set_connection_parameter_value reset_in.out_reset/intel_gmii_to_rgmii_converter_0.peri_reset clockResetSysInfo {}
	set_connection_parameter_value reset_in.out_reset/intel_gmii_to_rgmii_converter_0.peri_reset resetDomainSysInfo {-1}
	add_connection reset_in.out_reset/iopll_0.reset
	set_connection_parameter_value reset_in.out_reset/iopll_0.reset clockDomainSysInfo {-1}
	set_connection_parameter_value reset_in.out_reset/iopll_0.reset clockResetSysInfo {}
	set_connection_parameter_value reset_in.out_reset/iopll_0.reset resetDomainSysInfo {-1}

	# add the exports
	set_interface_property clk EXPORT_OF clock_in.in_clk
	set_interface_property hps_gmii EXPORT_OF intel_gmii_to_rgmii_converter_0.hps_gmii
	set_interface_property phy_rgmii EXPORT_OF intel_gmii_to_rgmii_converter_0.phy_rgmii
	set_interface_property reset EXPORT_OF reset_in.in_reset

	# set values for exposed HDL parameters

	# set the the module properties
	set_module_property BONUS_DATA {<?xml version="1.0" encoding="UTF-8"?>
<bonusData>
 <element __value="clock_in">
  <datum __value="_sortIndex" value="0" type="int" />
 </element>
 <element __value="intel_gmii_to_rgmii_converter_0">
  <datum __value="_sortIndex" value="1" type="int" />
 </element>
 <element __value="iopll_0">
  <datum __value="_sortIndex" value="2" type="int" />
 </element>
 <element __value="reset_in">
  <datum __value="_sortIndex" value="3" type="int" />
 </element>
</bonusData>
}
	set_module_property FILE {qsys_top.qsys}
	set_module_property GENERATION_ID {0x00000000}
	set_module_property NAME {fpga_rgmii_subsys}

	# save the system
	sync_sysinfo_parameters
	#comment_off- save_system fpga_rgmii_subsys
	save_system $subsys_name
}

proc do_set_exported_interface_sysinfo_parameters {} {
	load_system qsys_top.qsys
	set_exported_interface_sysinfo_parameter_value clk clock_domain {1}
	set_exported_interface_sysinfo_parameter_value clk clock_rate {100000000}
	set_exported_interface_sysinfo_parameter_value clk reset_domain {1}
	save_system qsys_top.qsys
}

# create all the systems, from bottom up
do_create_fpga_rgmii_subsys

# set system info parameters on exported interface, from bottom up
#comment_off- do_set_exported_interface_sysinfo_parameters
