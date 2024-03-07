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
			set_component_param	"emif_hps MEM_TECHNOLOGY_AUTO_BOOL 0"
			set_component_param	"emif_hps MEM_TECHNOLOGY MEM_TECHNOLOGY_DDR5"
			set_component_param	"emif_hps HPS_EMIF_CONFIG_AUTO_BOOL 0"
			set_component_param	"emif_hps HPS_EMIF_CONFIG HPS_EMIF_1x32"
			set_component_param	"emif_hps MEM_COMPS_PER_RANK 2"
			set_component_param	"emif_hps PHY_MEMCLK_FREQ_MHZ_AUTO_BOOL 0"
			set_component_param	"emif_hps PHY_MEMCLK_FREQ_MHZ 1600.0"
			set_component_param	"emif_hps MEM_PRESET_ID_AUTO_BOOL 0"
			set_component_param	"emif_hps MEM_PRESET_ID {DDR5-5600B CL46 Component 16Gb (1Gbx16) Freq 1600.0MHz}"
			set_component_param	"emif_hps PHY_AC_PLACEMENT_AUTO_BOOL 0"
			set_component_param	"emif_hps PHY_AC_PLACEMENT PHY_AC_PLACEMENT_BOT"
			set_component_param	"emif_hps PHY_REFCLK_FREQ_MHZ_AUTO_BOOL 0"
			set_component_param	"emif_hps PHY_REFCLK_FREQ_MHZ 100.0"
			set_component_param	"emif_hps GRP_PHY_DATA_AUTO_BOOL 0"
			set_component_param "emif_hps GRP_PHY_DATA_X_R_T_DQ_INPUT_OHM {RTT_PHY_IN_60_CAL}"
			set_component_param "emif_hps GRP_PHY_DATA_X_DQ_VREF 75.0"
			set_component_param "emif_hps GRP_MEM_ODT_DQ_AUTO_BOOL 0"
			set_component_param "emif_hps GRP_MEM_ODT_DQ_X_TGT_WR {MEM_RTT_COMM_OFF}"
			set_component_param "emif_hps GRP_MEM_DQ_VREF_AUTO_BOOL 0"
			set_component_param "emif_hps GRP_MEM_DQ_VREF_X_VALUE 75.0"
			set_component_param "emif_hps GRP_MEM_VREF_CA_AUTO_BOOL 0"
			set_component_param "emif_hps GRP_MEM_VREF_CA_X_CA_VALUE 75.0"
			set_component_param "emif_hps GRP_MEM_VREF_CA_X_CS_VALUE 75.0"
			set_component_param	"emif_hps USER_EXTRA_PARAMETERS BYTE_SWIZZLE_CH0=1,0,X,X,2,3,X,X;PIN_SWIZZLE_CH0_DQS1=14,12,8,10,15,11,9,13;PIN_SWIZZLE_CH0_DQS0=0,6,2,4,1,7,3,5;PIN_SWIZZLE_CH0_DQS2=22,16,18,20,19,23,17,21;PIN_SWIZZLE_CH0_DQS3=30,24,26,28,31,27,29,25;"
			
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
