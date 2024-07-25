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
source $prjroot/utils.tcl

if {$hps_emif_en == 1} {
set total_hps_emif_width $hps_emif_width
if {$hps_emif_ecc_en} {
   incr total_hps_emif_width 8
}
}
if {$fpga_emif_en == 1} {
set total_fpga_emif_width $fpga_emif_width
if {$fpga_emif_ecc_en} {
   incr total_fpga_emif_width 8
}
}

# Derive TCL and WTCL for default DDR4 mode
# if {$hps_emif_mem_part == "default_part"} {
   # if {$hps_emif_mem_clk_freq_mhz == 800} {
      # set selected_tcl 14
      # set selected_wtcl 11
   # } elseif {$hps_emif_mem_clk_freq_mhz == 1200} {
      # if {$board == "DK-SI-AGF014E" } {
         # set selected_tcl 20
         # set selected_wtcl 16
      # } else {
         # set selected_tcl 21
         # set selected_wtcl 16
      # }
   # } else {
      # puts "\"$hps_emif_mem_clk_freq_mhz\"is not a Not Supported DDR4 MEM CLK FREQ"
      # set selected_tcl 0
      # set selected_wtcl 0
   # }
# }
  ## DEVKIT
  # ------ Component configuration --------------------- #
  
  # note: you may apply preset then modify or directly set intended value of whole component's parameters
  # sample of instantiation could be something like following
if {$hps_emif_mem_part == "custom"} {
    add_component_param     "emif_hps_ph2 emif_hps
                             IP_FILE_PATH ip/$qsys_name/emif_hps.ip"
} else {
    add_component_param     "emif_io96b_hps emif_hps
                             IP_FILE_PATH ip/$qsys_name/emif_io96b_hps.ip"
	load_component emif_hps
	set_component_param     "emif_hps
		                     EMIF_PROTOCOL             				DDR4_COMP
                             EMIF_TOPOLOGY                       	1x32
							"
    if {$hps_emif_type == "ddr4"} {  
		load_component emif_hps
		if {$hps_emif_mem_clk_freq_mhz == 800} {
		set_component_sub_module_parameter_value emif_0_ddr4comp JEDEC_OVERRIDE_TABLE_PARAM_NAME {MEM_TRAS_NS MEM_TCCD_L_NS MEM_TCCD_S_NS MEM_TRRD_L_NS MEM_TFAW_NS MEM_TWTR_L_NS MEM_TWTR_S_NS MEM_TMRD_NS MEM_TCKSRE_NS MEM_TCKSRX_NS MEM_TCKE_NS MEM_TMPRR_NS MEM_TDSH_NS MEM_TDSS_NS MEM_TIH_NS MEM_TIS_NS MEM_TQSH_NS MEM_TWLH_NS MEM_TWLS_NS MEM_TRFC_DLR_NS MEM_TRRD_DLR_NS MEM_TFAW_DLR_NS MEM_TCCD_DLR_NS MEM_TXP_NS MEM_TXS_DLL_NS MEM_TCPDED_NS MEM_TMOD_NS MEM_TZQCS_NS}
		
		load_system_inside_package
		load_component emif_0_ddr4comp    
        set_component_param     "emif_0_ddr4comp
		                        MEM_DIE_DQ_WIDTH					8
								MEM_DIE_DENSITY_GBITS				16
								MEM_SPEEDBIN 						1600L
								MEM_OPERATING_FREQ_MHZ_AUTOSET_EN	0
								MEM_OPERATING_FREQ_MHZ				$hps_emif_mem_clk_freq_mhz
								PHY_REFCLK_FREQ_MHZ_AUTOSET_EN		0
								PHY_REFCLK_FREQ_MHZ					$hps_emif_ref_clk_freq_mhz.0
								MEM_TRAS_NS                         35.0
								MEM_TCCD_L_NS                       5.0
								MEM_TCCD_S_NS                       4.0
								MEM_TRRD_L_NS                       6.0
								MEM_TFAW_NS                         35.0
								MEM_TWTR_L_NS                       6.0
								MEM_TWTR_S_NS                       2.0
								MEM_TMRD_NS                         8.0
								MEM_TCKSRE_NS                       8.0
								MEM_TCKSRX_NS                       8.0
								MEM_TCKE_NS                         4.0
								MEM_TMPRR_NS                        1.0
								MEM_TDSH_NS                         0.18
								MEM_TDSS_NS                         0.18
								MEM_TIH_NS                          140000.0
								MEM_TIS_NS                          115000.0
								MEM_TQSH_NS                         0.4
								MEM_TWLH_NS                         0.13
								MEM_TWLS_NS                         0.13
								MEM_TRFC_DLR_NS                     190.0
								MEM_TRRD_DLR_NS                     4.0
								MEM_TFAW_DLR_NS                     20.0
								MEM_TCCD_DLR_NS                     5.0
								MEM_TXP_NS                          5.0
								MEM_TXS_DLL_NS                      597.0
								MEM_TCPDED_NS                       4.0
								MEM_TMOD_NS                         24.0
								MEM_TZQCS_NS                        128.0
											
								"
	}
	
	if {$hps_emif_mem_clk_freq_mhz == 933.333} {
	set_component_sub_module_parameter_value emif_0_ddr4comp JEDEC_OVERRIDE_TABLE_PARAM_NAME {MEM_TCKESR_CYC MEM_TMRD_NS MEM_TWTR_S_NS MEM_TCKSRE_NS MEM_TCKSRX_NS MEM_TCKE_NS MEM_TMPRR_NS MEM_TDSH_NS MEM_TDSS_NS MEM_TQSH_NS MEM_TWLH_NS MEM_TWLS_NS MEM_TRFC_DLR_NS MEM_TRRD_DLR_NS MEM_TFAW_DLR_NS MEM_TCCD_DLR_NS MEM_TXP_NS MEM_TXS_DLL_NS MEM_TCPDED_NS MEM_TMOD_NS MEM_TZQCS_NS}
	
		load_system_inside_package
		load_component emif_0_ddr4comp    
        set_component_param     "emif_0_ddr4comp
		                        MEM_DIE_DQ_WIDTH					8
								MEM_DIE_DENSITY_GBITS				16
								MEM_SPEEDBIN 						1866M
								MEM_OPERATING_FREQ_MHZ_AUTOSET_EN	0
								MEM_OPERATING_FREQ_MHZ				$hps_emif_mem_clk_freq_mhz
								PHY_REFCLK_FREQ_MHZ_AUTOSET_EN		0
								PHY_REFCLK_ADVANCED_SELECT_EN		1
								PHY_REFCLK_FREQ_MHZ					$hps_emif_ref_clk_freq_mhz
								MEM_TCKESR_CYC                      6.0
								MEM_TMRD_NS                         8.0
								MEM_TWTR_S_NS                       3.216
								MEM_TCKSRE_NS                       10.72
								MEM_TCKSRX_NS                       10.72
								MEM_TCKE_NS                         5.36
								MEM_TMPRR_NS                        1.0
								MEM_TDSH_NS                         0.18
								MEM_TDSS_NS                         0.18
								MEM_TQSH_NS                         0.4
								MEM_TWLH_NS                         0.13
								MEM_TWLS_NS                         0.13
								MEM_TRFC_DLR_NS                     190.0
								MEM_TRRD_DLR_NS                     4.0
								MEM_TFAW_DLR_NS                     17.152
								MEM_TCCD_DLR_NS                     4.288
								MEM_TXP_NS                          6.432
								MEM_TXS_DLL_NS                      597.0
								MEM_TCPDED_NS                       4.0
								MEM_TMOD_NS                         24.0
								MEM_TZQCS_NS                        128.0
											
								"
	}
									
	if {$hps_emif_ecc_en == 1} {
			set_component_param     "emif_0_ddr4comp
									MEM_CHANNEL_ECC_DQ_WIDTH			8
									PHY_SWIZZLE_MAP						BYTE_SWIZZLE_CH0=2,X,X,X,3,0,1,ECC;PIN_SWIZZLE_CH0_DQS0=7,6,5,4,3,2,1,0;PIN_SWIZZLE_CH0_DQS1=15,8,14,9,13,10,12,11;PIN_SWIZZLE_CH0_DQS2=23,22,21,20,16,17,18,19;PIN_SWIZZLE_CH0_DQS3=31,30,29,28,27,26,25,24;PIN_SWIZZLE_CH0_ECC=0,7,6,5,4,1,2,3;
									"
			
		} else {
			set_component_param     "emif_0_ddr4comp
									MEM_CHANNEL_ECC_DQ_WIDTH			0
									PHY_SWIZZLE_MAP						BYTE_SWIZZLE_CH0=3,X,X,X,0,2,1,X;PIN_SWIZZLE_CH0_DQS0=7,1,2,3,4,5,6,0;PIN_SWIZZLE_CH0_DQS1=15,14,13,12,11,10,9,8;PIN_SWIZZLE_CH0_DQS2=20,21,22,23,16,17,18,19;PIN_SWIZZLE_CH0_DQS3=31,24,25,26,27,28,29,30;
									"
		}
		load_component emif_0_ddr4comp  
		
		save_component
		save_system_inside_package
		save_component		   

	}

        # ------ Connections --------------------------------- #
		if {($hps_emif_channel == 1)} {
        connect "${cpu_instance}.io96b0_to_hps emif_hps.io96b0_to_hps"
		
		# } elseif {($hps_emif_channel == 2) && ($emif_topology == 2)} {
		
		# } elseif {(($hps_emif_channel == 2) && ($emif_topology == 3)) || (($hps_emif_channel == 2) && ($emif_topology == 4))} {
		
		}

        # ------ Ports export -------------------------------- #
        export emif_hps mem_0        		emif_hps_emif_mem_0 
		export emif_hps mem_ck_0         	emif_hps_emif_mem_ck_0
        export emif_hps oct_0         		emif_hps_emif_oct_0
		export emif_hps mem_reset_n         emif_hps_emif_mem_reset_n
        export emif_hps ref_clk     		emif_hps_emif_ref_clk_0
}
