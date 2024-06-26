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
								PHY_AC_PLACEMENT_AUTO_BOOL           false
								PHY_AC_PLACEMENT                     PHY_AC_PLACEMENT_BOT
								MEM_DEVICE_DQ_WIDTH                  16
								MEM_COMPS_PER_RANK                   2
								PHY_REFCLK_FREQ_MHZ_AUTO_BOOL		 false
								PHY_MEMCLK_FREQ_MHZ_AUTO_BOOL		 false
								PHY_MEMCLK_FREQ_MHZ 				 $hps_emif_mem_clk_freq_mhz
								PHY_REFCLK_FREQ_MHZ 				 $hps_emif_ref_clk_freq_mhz
								"
        
		if {$hps_emif_ecc_en == 1} {
			set_component_param     "emif_hps
									CTRL_ECC_MODE_AUTO_BOOL				 0
									CTRL_ECC_MODE                        CTRL_ECC_MODE_SIDE_BAND
									"
			set_component_param "emif_hps USER_EXTRA_PARAMETERS BYTE_SWIZZLE_CH0=0,X,X,X,1,2,3,ECC;PIN_SWIZZLE_CH0_DQS0=0,2,6,4,1,3,5,7;PIN_SWIZZLE_CH0_DQS1=12,15,8,11,14,10,13,9;PIN_SWIZZLE_CH0_DQS2=20,16,18,22,23,17,19,21;PIN_SWIZZLE_CH0_DQS3=26,30,28,24,25,27,31,29;PIN_SWIZZLE_CH0_ECC=2,6,0,4,5,3,7,1; "
		} else {
			set_component_param     "emif_hps
									CTRL_ECC_MODE                        CTRL_ECC_MODE_DISABLED
									"
			set_component_param "emif_hps USER_EXTRA_PARAMETERS BYTE_SWIZZLE_CH0=0,X,X,X,1,2,3,X;PIN_SWIZZLE_CH0_DQS0=0,2,6,4,1,3,5,7;PIN_SWIZZLE_CH0_DQS1=12,15,8,11,14,10,13,9;PIN_SWIZZLE_CH0_DQS2=20,16,18,22,23,17,19,21;PIN_SWIZZLE_CH0_DQS3=26,30,28,24,25,27,31,29; "
		}
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
