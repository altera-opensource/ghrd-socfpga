#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2020 Intel Corporation.
#
#****************************************************************************
#
# This script hosts Default EMIF IP settings for the Agilex SoC Devkit board.
#
#****************************************************************************

  ## DEVKIT
  # ------ Component configuration --------------------- #

  # note: you may apply preset then modify or directly set intended value of whole component's parameters
  # sample of instantiation could be something like following
     if {$hps_emif_en == 1} {
		add_component_param     "emif_hps_ph2 emif_hps
							   IP_FILE_PATH ip/$qsys_name/${qsys_name}_emif_hps_ph2_0.ip"
        
		add_component emif_hps_noc ip/qsys_top/qsys_top_emif_hps_noc.ip intel_noc_clock_ctrl emif_hps_noc 2.0.0

        if {$hps_emif_type == "ddr5"} {
           load_component emif_hps
           #TO BE COMPLETED
           #apply_component_preset  "DDR4-3200U CL18 Component 1CS 16Gb (1Gb x16)"
		   
			set_component_parameter_value AXI4_USER_DATA_ENABLE {0}
			set_component_parameter_value AXI4_USER_DATA_ENABLE_AUTO_BOOL {1}
			set_component_parameter_value AXI_SIDEBAND_ACCESS_MODE {FABRIC}
			set_component_parameter_value AXI_SIDEBAND_ACCESS_MODE_AUTO_BOOL {1}
			set_component_parameter_value CTRL_ECC_AUTOCORRECT_EN {0}
			set_component_parameter_value CTRL_ECC_AUTOCORRECT_EN_AUTO_BOOL {1}
			set_component_parameter_value CTRL_ECC_MODE {CTRL_ECC_MODE_DISABLED}
			set_component_parameter_value CTRL_ECC_MODE_AUTO_BOOL {1}
			set_component_parameter_value CTRL_PERFORMANCE_PROFILE {CTRL_PERFORMANCE_PROFILE_TEMP1}
			set_component_parameter_value CTRL_PERFORMANCE_PROFILE_AUTO_BOOL {1}
			set_component_parameter_value CTRL_PHY_ONLY_EN {0}
			set_component_parameter_value CTRL_PHY_ONLY_EN_AUTO_BOOL {1}
			set_component_parameter_value CTRL_SCRAMBLER_EN {0}
			set_component_parameter_value DEBUG_TOOLS_EN {0}
			set_component_parameter_value DIAG_EXTRA_PARAMETERS {}
			set_component_parameter_value EX_DESIGN_CORE_CLK_FREQ_MHZ {200}
			set_component_parameter_value EX_DESIGN_CORE_CLK_FREQ_MHZ_AUTO_BOOL {1}
			set_component_parameter_value EX_DESIGN_CORE_REFCLK_FREQ_MHZ {100}
			set_component_parameter_value EX_DESIGN_GEN_BSI {0}
			set_component_parameter_value EX_DESIGN_GEN_CDC {0}
			set_component_parameter_value EX_DESIGN_GEN_SIM {1}
			set_component_parameter_value EX_DESIGN_GEN_SYNTH {1}
			set_component_parameter_value EX_DESIGN_HDL_FORMAT {HDL_FORMAT_VERILOG}
			set_component_parameter_value EX_DESIGN_HYDRA_REMOTE {CONFIG_INTF_MODE_REMOTE_JTAG}
			set_component_parameter_value EX_DESIGN_NOC_REFCLK_FREQ_MHZ {100}
			set_component_parameter_value EX_DESIGN_NOC_REFCLK_FREQ_MHZ_AUTO_BOOL {1}
			set_component_parameter_value FPGA_TOP_AC_AUTO_BOOL {1}
			set_component_parameter_value FPGA_TOP_CLK_AUTO_BOOL {1}
			set_component_parameter_value FPGA_TOP_DATA_AUTO_BOOL {0}
			set_component_parameter_value FPGA_TOP_DFE_AUTO_BOOL {1}
			set_component_parameter_value FPGA_TOP_PHY_AUTO_BOOL {1}
			set_component_parameter_value HMC_ADDR_SWAP {0}
			set_component_parameter_value HPS_EMIF_CONFIG {HPS_EMIF_1x32}
			set_component_parameter_value HPS_EMIF_CONFIG_AUTO_BOOL {0}
			set_component_parameter_value INSTANCE_ID {0}
			set_component_parameter_value INSTANCE_ID_IP0 {0}
			set_component_parameter_value INSTANCE_ID_IP1 {1}
			set_component_parameter_value MEM_CA_VREF_RANGE {MEM_CA_VREF_RANGE_LP4_2}
			set_component_parameter_value MEM_CA_VREF_VALUE {75.0}
			set_component_parameter_value MEM_COMPS_PER_RANK {2}
			set_component_parameter_value MEM_CS_VREF_VALUE {75.0}
			set_component_parameter_value MEM_DEVICE_DQ_WIDTH {16}
			set_component_parameter_value MEM_DFE_TAP_1 {MEM_DFE_TAP_1_LP5_5}
			set_component_parameter_value MEM_DFE_TAP_2 {MEM_DFE_TAP_2_0}
			set_component_parameter_value MEM_DFE_TAP_3 {MEM_DFE_TAP_3_0}
			set_component_parameter_value MEM_DFE_TAP_4 {MEM_DFE_TAP_4_0}
			set_component_parameter_value MEM_DQ_VREF_RANGE {MEM_VREF_RANGE_LP4_2}
			set_component_parameter_value MEM_DQ_VREF_VALUE {75.0}
			set_component_parameter_value MEM_FORMAT {MEM_FORMAT_DISCRETE}
			set_component_parameter_value MEM_NUM_CHANNELS {1}
			set_component_parameter_value MEM_NUM_RANKS {1}
			set_component_parameter_value MEM_ODT_CA {MEM_RTT_CA_DDR5_6}
			set_component_parameter_value MEM_ODT_CA_COMM {MEM_RTT_COMM_OFF}
			set_component_parameter_value MEM_ODT_CA_ENABLE {MEM_RTT_COMM_EN_FALSE}
			set_component_parameter_value MEM_ODT_CK {MEM_RTT_CA_DDR5_6}
			set_component_parameter_value MEM_ODT_CK_ENABLE {MEM_RTT_COMM_EN_FALSE}
			set_component_parameter_value MEM_ODT_CS {MEM_RTT_CA_DDR5_6}
			set_component_parameter_value MEM_ODT_CS_ENABLE {MEM_RTT_COMM_EN_FALSE}
			set_component_parameter_value MEM_ODT_IDLE {MEM_RTT_COMM_OFF}
			set_component_parameter_value MEM_ODT_NON_TGT {MEM_RTT_COMM_OFF}
			set_component_parameter_value MEM_ODT_NON_TGT_RD {MEM_RTT_COMM_OFF}
			set_component_parameter_value MEM_ODT_NON_TGT_WR {MEM_RTT_COMM_OFF}
			set_component_parameter_value MEM_ODT_TGT_WR {MEM_RTT_COMM_OFF}
			set_component_parameter_value MEM_ODT_WCK {MEM_RTT_COMM_OFF}
			set_component_parameter_value MEM_PRESET_FILE_EN {0}
			set_component_parameter_value MEM_PRESET_FILE_QPRS {mem_preset_file_qprs.qprs}
			set_component_parameter_value MEM_PRESET_ID {DDR5-5600B CL46 Component 16Gb (1Gbx16) Freq 1600.0MHz}
			set_component_parameter_value MEM_PRESET_ID_AUTO_BOOL {0}
			set_component_parameter_value MEM_PRESET_ID_FSP0 {}
			set_component_parameter_value MEM_PRESET_ID_FSP0_AUTO_BOOL {1}
			set_component_parameter_value MEM_PRESET_ID_FSP1 {}
			set_component_parameter_value MEM_PRESET_ID_FSP1_AUTO_BOOL {1}
			set_component_parameter_value MEM_PRESET_ID_FSP2 {}
			set_component_parameter_value MEM_PRESET_ID_FSP2_AUTO_BOOL {1}
			set_component_parameter_value MEM_RANKS_SHARE_CLOCKS {0}
			set_component_parameter_value MEM_RON {MEM_DRIVE_STRENGTH_7}
			set_component_parameter_value MEM_TECHNOLOGY {MEM_TECHNOLOGY_DDR5}
			set_component_parameter_value MEM_TECHNOLOGY_AUTO_BOOL {0}
			set_component_parameter_value MEM_TECH_IS_X {0}
			set_component_parameter_value MEM_TOPOLOGY {MEM_TOPOLOGY_FLYBY}
			set_component_parameter_value MEM_TOP_DFE_AUTO_BOOL {1}
			set_component_parameter_value MEM_TOP_TERM_AUTO_BOOL {0}
			set_component_parameter_value MEM_TOP_TERM_CA_AUTO_BOOL {1}
			set_component_parameter_value MEM_TOP_VREF_AUTO_BOOL {0}
			set_component_parameter_value MEM_TOP_VREF_CA_AUTO_BOOL {0}
			set_component_parameter_value MEM_USER_READ_LATENCY_CYC {5}
			set_component_parameter_value MEM_USER_READ_LATENCY_CYC_AUTO_BOOL {1}
			set_component_parameter_value MEM_USER_WRITE_LATENCY_CYC {10}
			set_component_parameter_value MEM_USER_WRITE_LATENCY_CYC_AUTO_BOOL {1}
			set_component_parameter_value PHY_AC_PLACEMENT {PHY_AC_PLACEMENT_BOT}
			set_component_parameter_value PHY_AC_PLACEMENT_AUTO_BOOL {0}
			set_component_parameter_value PHY_ALERT_N_PLACEMENT {PHY_ALERT_N_PLACEMENT_AC2}
			set_component_parameter_value PHY_ASYNC_EN {1}
			set_component_parameter_value PHY_DFE_TAP_1 {PHY_DFE_TAP_1_LP5_0}
			set_component_parameter_value PHY_DFE_TAP_2 {PHY_DFE_TAP_2_3_LP5_0}
			set_component_parameter_value PHY_DFE_TAP_3 {PHY_DFE_TAP_2_3_LP5_0}
			set_component_parameter_value PHY_DFE_TAP_4 {PHY_DFE_TAP_4_LP5_0}
			set_component_parameter_value PHY_DQS_IO_STD_TYPE {PHY_IO_STD_TYPE_DF_POD}
			set_component_parameter_value PHY_DQ_IO_STD_TYPE {PHY_IO_STD_TYPE_POD}
			set_component_parameter_value PHY_DQ_SLEW_RATE {PHY_SLEW_RATE_FASTEST}
			set_component_parameter_value PHY_DQ_VREF {75.0}
			set_component_parameter_value PHY_FSP1_EN {0}
			set_component_parameter_value PHY_FSP2_EN {0}
			set_component_parameter_value PHY_MEMCLK_FREQ_MHZ {1600.0}
			set_component_parameter_value PHY_MEMCLK_FREQ_MHZ_AUTO_BOOL {0}
			set_component_parameter_value PHY_MEMCLK_FSP0_FREQ_MHZ {1600.0}
			set_component_parameter_value PHY_MEMCLK_FSP0_FREQ_MHZ_AUTO_BOOL {1}
			set_component_parameter_value PHY_MEMCLK_FSP1_FREQ_MHZ {1600.0}
			set_component_parameter_value PHY_MEMCLK_FSP1_FREQ_MHZ_AUTO_BOOL {1}
			set_component_parameter_value PHY_MEMCLK_FSP2_FREQ_MHZ {1600.0}
			set_component_parameter_value PHY_MEMCLK_FSP2_FREQ_MHZ_AUTO_BOOL {1}
			set_component_parameter_value PHY_NOC_EN {0}
			set_component_parameter_value PHY_NOC_EN_AUTO_BOOL {1}
			set_component_parameter_value PHY_REFCLK_FREQ_MHZ {100.0}
			set_component_parameter_value PHY_REFCLK_FREQ_MHZ_AUTO_BOOL {0}
			set_component_parameter_value R_S_PHY_AC_OUTPUT_OHM {RTT_PHY_OUT_34_CAL}
			set_component_parameter_value R_S_PHY_CK_OUTPUT_OHM {RTT_PHY_OUT_34_CAL}
			set_component_parameter_value R_S_PHY_DQ_OUTPUT_OHM {RTT_PHY_OUT_34_CAL}
			set_component_parameter_value R_T_PHY_DQ_INPUT_OHM {RTT_PHY_IN_60_CAL}
			set_component_parameter_value R_T_PHY_REFCLK_INPUT_OHM {LVDS_DIFF_TERM_ON}
			set_component_parameter_value SHOW_INTERNAL_SETTINGS {1}
			set_component_parameter_value SHOW_LPDDR4 {0}
			set_component_parameter_value USER_EXTRA_PARAMETERS {BYTE_SWIZZLE_CH0=1,0,X,X,2,3,X,X;PIN_SWIZZLE_CH0_DQS1=14,12,8,10,15,11,9,13;PIN_SWIZZLE_CH0_DQS0=0,6,2,4,1,7,3,5;PIN_SWIZZLE_CH0_DQS2=22,16,18,20,19,23,17,21;PIN_SWIZZLE_CH0_DQS3=30,24,26,28,31,27,29,25;}
			set_component_parameter_value USER_MIN_NUM_AC_LANES {3}
			set_component_project_property HIDE_FROM_IP_CATALOG {false}
        }


        # ------ Connections --------------------------------- #
        connect "${cpu_instance}.mpfe_iniu_0_axi4noc emif_hps.t0_axi4noc"

        # ------ Ports export -------------------------------- #
        export emif_hps emif_mem_0         emif_hps_mem
        export emif_hps emif_oct_0         emif_hps_oct
        export emif_hps emif_ref_clk_0 		emif_hps_ref_clk
		export emif_hps_noc refclk 			emif_hps_noc_refclk
		export emif_hps_noc pll_lock_o		emif_hps_noc_pll_lock_o
     }
