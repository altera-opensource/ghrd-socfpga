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
if {$hps_emif_mem_part == "default_part"} {
   if {$hps_emif_mem_clk_freq_mhz == 800} {
      set selected_tcl 14
      set selected_wtcl 11
   } elseif {$hps_emif_mem_clk_freq_mhz == 1200} {
      if {$board == "DK-SI-AGF014E" } {
         set selected_tcl 20
         set selected_wtcl 16
      } else {
         set selected_tcl 21
         set selected_wtcl 16
      }
   } else {
      puts "\"$hps_emif_mem_clk_freq_mhz\"is not a Not Supported DDR4 MEM CLK FREQ"
      set selected_tcl 0
      set selected_wtcl 0
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
      
        set_component_param     "emif_hps
		                        MEM_TECHNOLOGY_AUTO_BOOL             false
                                MEM_TECHNOLOGY                       MEM_TECHNOLOGY_DDR4
								HPS_EMIF_CONFIG_AUTO_BOOL            false
                                HPS_EMIF_CONFIG                      HPS_EMIF_1x32
								MEM_FORMAT                           MEM_FORMAT_DISCRETE
								MEM_TOPOLOGY                         MEM_TOPOLOGY_FLYBY
								CTRL_ECC_MODE                        CTRL_ECC_MODE_DISABLED
								PHY_AC_PLACEMENT_AUTO_BOOL           true
								PHY_AC_PLACEMENT                     PHY_AC_PLACEMENT_BOT
								MEM_DEVICE_DQ_WIDTH                  16
								MEM_COMPS_PER_RANK                   2
								"
    } elseif {$hps_emif_type == "lpddr4"} {
	    load_component emif_hps
	    
	    set_component_param     "emif_hps
	                            MEM_TECHNOLOGY_AUTO_BOOL             false
	                            MEM_TECHNOLOGY                       MEM_TECHNOLOGY_LPDDR4
	    			    HPS_EMIF_CONFIG_AUTO_BOOL            false
	                            HPS_EMIF_CONFIG                      HPS_EMIF_1x16
	    			    MEM_FORMAT                           MEM_FORMAT_DISCRETE
	    			    MEM_TOPOLOGY                         MEM_TOPOLOGY_FLYBY
	    			    CTRL_ECC_MODE                        CTRL_ECC_MODE_DISABLED
	    			    PHY_AC_PLACEMENT_AUTO_BOOL           true
	    			    PHY_AC_PLACEMENT                     PHY_AC_PLACEMENT_BOT
	    			    MEM_DEVICE_DQ_WIDTH                  16
				    MEM_NUM_RANKS                        1
	    			    MEM_COMPS_PER_RANK                   1
	    			    "
	}


        # ------ Connections --------------------------------- #
        connect "${cpu_instance}.io96b0_ch0_axi emif_hps.s0_axi4"

        # ------ Ports export -------------------------------- #
        export emif_hps emif_mem_0         emif_hps_emif_mem_0 
        export emif_hps emif_oct_0         emif_hps_emif_oct_0
        export emif_hps emif_ref_clk_0     emif_hps_emif_ref_clk_0
}
