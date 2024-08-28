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
        add_component_param "emif_io96b_hps emif_hps
                            IP_FILE_PATH ip/$qsys_name/qsys_top_emif_io96b_hps.ip"

        #if {$hbm_en == 1} {
            add_component emif_hps_noc ip/qsys_top/qsys_top_emif_hps_noc.ip intel_noc_clock_ctrl emif_hps_noc
        #}		
        if {$hps_emif_type == "ddr5"} {
            set_component_param     "emif_hps
                                     EMIF_PROTOCOL      DDR5_COMP
                                     EMIF_TOPOLOGY      1x32"
			
            set_component_sub_param "emif_hps emif_0_ddr5comp
		                        MEM_DIE_DQ_WIDTH					16
								MEM_DIE_DENSITY_GBITS				16
								MEM_SPEEDBIN 						5600B
								MEM_OPERATING_FREQ_MHZ_AUTOSET_EN	0
								MEM_OPERATING_FREQ_MHZ				$hps_emif_mem_clk_freq_mhz
								PHY_REFCLK_FREQ_MHZ_AUTOSET_EN		0
								PHY_REFCLK_FREQ_MHZ					$hps_emif_ref_clk_freq_mhz
                                PHY_AC_PLACEMENT                    BOT
                                CTRL_DM_EN                          1
								
                                ANALOG_PARAM_DERIVATION_PARAM_NAME  {PHY_TERM_X_R_T_DQ_INPUT_OHM PHY_TERM_X_DQ_VREF MEM_ODT_DQ_X_TGT_WR MEM_ODT_DQ_X_IDLE MEM_VREF_DQ_X_VALUE}
                                PHY_TERM_X_R_T_DQ_INPUT_OHM         RT_60_OHM_CAL
                                PHY_TERM_X_DQ_VREF                  75.00
                                MEM_ODT_DQ_X_TGT_WR                 5
								MEM_ODT_DQ_X_IDLE					5
								MEM_VREF_DQ_X_VALUE					75.00
                                "

                                # JEDEC_OVERRIDE_TABLE_PARAM_NAME     {MEM_TRCD_NS MEM_TRP_NS MEM_TRC_NS MEM_TMRD_NS MEM_TDQSS_CYC}
                                # MEM_TRCD_NS                         16.0
                                # MEM_TRP_NS                          16.0
                                # MEM_TRC_NS                          48.0
                                # MEM_TMRR_NS                         14.375
                                # MEM_TMRD_NS                         14.375
                                # MEM_TDQSS_CYC                       0.0

            if {$hps_emif_ecc_en == 1} {
                set_component_sub_param "emif_hps emif_0_ddr5comp
									MEM_CHANNEL_ECC_DQ_WIDTH			8
									PHY_SWIZZLE_MAP						{BYTE_SWIZZLE_CH0=1,0,X,X,2,3,ECC,X;PIN_SWIZZLE_CH0_DQS1=14,12,8,10,15,11,9,13;PIN_SWIZZLE_CH0_DQS0=0,6,2,4,1,7,3,5;PIN_SWIZZLE_CH0_DQS2=22,16,18,20,19,23,17,21;PIN_SWIZZLE_CH0_DQS3=30,24,26,28,31,27,29,25;PIN_SWIZZLE_CH0_ECC=6,4,2,0,3,7,1,5;}
									"
            } else {
                set_component_sub_param "emif_hps emif_0_ddr5comp
									MEM_CHANNEL_ECC_DQ_WIDTH			0
									PHY_SWIZZLE_MAP						{BYTE_SWIZZLE_CH0=1,0,X,X,2,3,X,X;PIN_SWIZZLE_CH0_DQS1=14,12,8,10,15,11,9,13;PIN_SWIZZLE_CH0_DQS0=0,6,2,4,1,7,3,5;PIN_SWIZZLE_CH0_DQS2=22,16,18,20,19,23,17,21;PIN_SWIZZLE_CH0_DQS3=30,24,26,28,31,27,29,25;}
									"
            }
        }

        # ------ Connections --------------------------------- #
        connect "${cpu_instance}.mpfe_iniu_0_axi4noc emif_hps.s0_noc_axi4noc_hps"

        # ------ Ports export -------------------------------- #
        export emif_hps mem_0        		emif_hps_emif_mem_0
        export emif_hps mem_ck_0         	emif_hps_emif_mem_ck_0
        export emif_hps oct_0         		emif_hps_emif_oct_0
        export emif_hps mem_reset_n_0       emif_hps_emif_mem_reset_n
        export emif_hps ref_clk     		emif_hps_emif_ref_clk_0

        # only add emif_hps_noc when hbm is enabled.
        #if {$hbm_en == 1} {
            export emif_hps_noc refclk          emif_hps_noc_refclk
            export emif_hps_noc pll_lock_o      emif_hps_noc_pll_lock_o
        #}
    }
