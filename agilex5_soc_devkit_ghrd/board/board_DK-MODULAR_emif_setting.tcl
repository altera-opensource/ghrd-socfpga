#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2024 Intel Corporation.
#
#**********************************************************************************
#
# This script hosts Default EMIF IP settings for the Agilex 5 Modular Devkit board.
#
#**********************************************************************************
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

  ## DEVKIT
  # ------ Component configuration --------------------- #
  
  # note: you may apply preset then modify or directly set intended value of whole component's parameters
  # sample of instantiation could be something like following
if {$hps_emif_mem_part == "custom"} {
    add_component_param     "emif_hps_ph2 emif_hps
                             IP_FILE_PATH ip/$qsys_name/emif_hps.ip"
} else {
    add_component_param     "emif_hps_ph2 emif_hps
                             IP_FILE_PATH ip/$qsys_name/emif_hps.ip"
  							   
    if {$hps_emif_type == "ddr4"} {    
        load_component emif_hps
        #apply_component_preset  "DDR4-3200U CL18 Component 1CS 16Gb (1Gb x16)"
        #apply_component_preset  "DDR4-3200AA CL22 Component 1CS 8Gb (512Mb x16)"
        #save_component
      
        set_component_param     "emif_hps
		                        MEM_TECHNOLOGY_AUTO_BOOL             false
                                MEM_TECHNOLOGY                       MEM_TECHNOLOGY_DDR4
								HPS_EMIF_CONFIG_AUTO_BOOL            false
                                HPS_EMIF_CONFIG                      HPS_EMIF_1x32
								MEM_FORMAT                           MEM_FORMAT_DISCRETE
								MEM_TOPOLOGY                         MEM_TOPOLOGY_FLYBY
								CTRL_ECC_MODE                        CTRL_ECC_MODE_DISABLED
								PHY_AC_PLACEMENT_AUTO_BOOL           false
								PHY_AC_PLACEMENT                     PHY_AC_PLACEMENT_BOT
								MEM_DEVICE_DQ_WIDTH                  16
								MEM_COMPS_PER_RANK                   2
								PHY_REFCLK_FREQ_MHZ_AUTO_BOOL		 false
								PHY_MEMCLK_FREQ_MHZ_AUTO_BOOL		 false
								PHY_MEMCLK_FREQ_MHZ 				 $hps_emif_mem_clk_freq_mhz
								PHY_REFCLK_FREQ_MHZ 				 $hps_emif_ref_clk_freq_mhz
								"
        set_component_param "emif_hps USER_EXTRA_PARAMETERS BYTE_SWIZZLE_CH0=0,X,X,X,1,2,3,X;PIN_SWIZZLE_CH0_DQS3=26,30,28,24,25,27,29,31;PIN_SWIZZLE_CH0_DQS2=16,20,22,18,23,21,19,17;PIN_SWIZZLE_CH0_DQS1=14,11,12,8,10,9,13,15;PIN_SWIZZLE_CH0_DQS0=2,0,6,4,7,5,3,1; "
		if {$hps_emif_mem_clk_freq_mhz == 800.0} {
			set_component_param     "emif_hps
									MEM_PRESET_FILE_EN   		True
									MEM_PRESET_ID_AUTO_BOOL   	False
									MEM_PRESET_FILE_QPRS   		${prjroot}/board/preset_files/ddr4/DDR4-1600L_800MHz_CL12_alloff_component_1CS_DDP_32Gb_2Gx16.qprs
									MEM_PRESET_ID   			DDR4-1600L_800MHz_CL12_alloff_component_1CS_DDP_32Gb_2Gx16
									"			
		}
		if {$hps_emif_mem_clk_freq_mhz == 933.0} {
			set_component_param     "emif_hps
									MEM_PRESET_FILE_EN   		True
									MEM_PRESET_ID_AUTO_BOOL   	False
									MEM_PRESET_FILE_QPRS   		${prjroot}/board/preset_files/ddr4/DDR4-1866M_933MHz_CL13_alloff_component_1CS_DDP_32Gb_2Gx16.qprs
									MEM_PRESET_ID   			DDR4-1866M_933MHz_CL13_alloff_component_1CS_DDP_32Gb_2Gx16
									"
		}
		if {$hps_emif_mem_clk_freq_mhz == 1066.0} {
			set_component_param     "emif_hps
									MEM_PRESET_FILE_EN   		True
									MEM_PRESET_ID_AUTO_BOOL   	False
									MEM_PRESET_FILE_QPRS   		${prjroot}/board/preset_files/ddr4/DDR4-2133R_1066MHz_CL16_alloff_component_1CS_DDP_32Gb_2Gx16.qprs
									MEM_PRESET_ID   			DDR4-2133R_1066MHz_CL16_alloff_component_1CS_DDP_32Gb_2Gx16
									"
			
		}
	}

        # ------ Connections --------------------------------- #
        connect "${cpu_instance}.io96b0_ch0_axi emif_hps.s0_axi4"

        # ------ Ports export -------------------------------- #
        export emif_hps emif_mem_0         emif_hps_emif_mem_0 
        export emif_hps emif_oct_0         emif_hps_emif_oct_0
        export emif_hps emif_ref_clk_0     emif_hps_emif_ref_clk_0
}
