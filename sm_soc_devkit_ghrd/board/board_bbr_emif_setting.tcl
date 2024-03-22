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

# Derive channel and width from hps_emif_topology
set mystring $hps_emif_topology
set pattern {[0-9]+}

# Find and print each number individually
set start 0
while {[regexp $pattern [string range $mystring $start end] match]} {
    set number $match
if {$number <=5} {
    set hps_emif_channel $number
} else {
	set hps_emif_width $number
}
    set start [expr {[string first $match $mystring] + [string length $match]}]
}

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
  							   
	if {$hps_emif_type == "lpddr5"} {
	    # load_component emif_hps
	    
	    set_component_param     "emif_hps
	                            MEM_TECHNOLOGY_AUTO_BOOL             false
	                            MEM_TECHNOLOGY                       MEM_TECHNOLOGY_LPDDR5
								HPS_EMIF_CONFIG_AUTO_BOOL            false
	                            HPS_EMIF_CONFIG                      HPS_EMIF_$hps_emif_topology
								MEM_FORMAT                           MEM_FORMAT_DISCRETE
								MEM_TOPOLOGY                         MEM_TOPOLOGY_FLYBY
								PHY_FSP1_EN                          false
								CTRL_ECC_MODE_AUTO_BOOL              true
								CTRL_ECC_MODE                        CTRL_ECC_MODE_DISABLED
								PHY_AC_PLACEMENT_AUTO_BOOL           true
								PHY_AC_PLACEMENT                     PHY_AC_PLACEMENT_BOT
								MEM_NUM_CHANNELS                     $hps_emif_channel
								MEM_DEVICE_DQ_WIDTH                  16
								MEM_NUM_RANKS                        1
								MEM_COMPS_PER_RANK                   1
								PHY_MEMCLK_FSP0_FREQ_MHZ_AUTO_BOOL   false
								PHY_MEMCLK_FSP0_FREQ_MHZ             $hps_emif_mem_clk_freq_mhz
								PHY_REFCLK_FREQ_MHZ_AUTO_BOOL        false
								PHY_REFCLK_FREQ_MHZ                  $hps_emif_ref_clk_freq_mhz
								"
	
		if { $hps_emif_mem_clk_freq_mhz== 800.0 } {
			if { $hps_emif_channel == 1} {
			set_component_param "emif_hps
								MEM_PRESET_FILE_EN_FSP0              true
								MEM_PRESET_ID_FSP0_AUTO_BOOL         false
								MEM_PRESET_FILE_QPRS_FSP0            ${prjroot}/board/preset_files/lpddr5/LPDDR5-1600_CL5_Component_Single-Channel-1R-1CPR-16Gb_(16GbTotal)_x16_WCK_800MHz.qprs
								MEM_PRESET_ID_FSP0                   LPDDR5-1600_CL5_Component_Single-Channel-1R-1CPR-16Gb_(16GbTotal)_x16_WCK_800MHz
								"
			} elseif { $hps_emif_channel == 2} {
			set_component_param "emif_hps
								MEM_PRESET_FILE_EN_FSP0              true
								MEM_PRESET_ID_FSP0_AUTO_BOOL         false
								MEM_PRESET_FILE_QPRS_FSP0            ${prjroot}/board/preset_files/lpddr5/LPDDR5-1600_CL5_Component_Dual-Channel-1R-1CPR-16Gb(32GbTotal)_x16_WCK_800MHz.qprs
								MEM_PRESET_ID_FSP0                   LPDDR5-1600_CL5_Component_Dual-Channel-1R-1CPR-16Gb(32GbTotal)_x16_WCK_800MHz
								"
			}
		} elseif { $hps_emif_mem_clk_freq_mhz== 1066.0 } {
			if { $hps_emif_channel == 1} {
			set_component_param "emif_hps
								MEM_PRESET_FILE_EN_FSP0              true
								MEM_PRESET_ID_FSP0_AUTO_BOOL         false
								MEM_PRESET_FILE_QPRS_FSP0            ${prjroot}/board/preset_files/lpddr5/LPDDR5-2133_CL6_Component_Single-Channel-1R-1CPR-16Gb_(16GbTotal)_x16_WCK_1066MHz.qprs
								MEM_PRESET_ID_FSP0                   LPDDR5-2133_CL6_Component_Single-Channel-1R-1CPR-16Gb_(16GbTotal)_x16_WCK_1066MHz
								"
			} elseif { $hps_emif_channel == 2} {
			set_component_param "emif_hps
								MEM_PRESET_FILE_EN_FSP0              true
								MEM_PRESET_ID_FSP0_AUTO_BOOL         false
								MEM_PRESET_FILE_QPRS_FSP0            ${prjroot}/board/preset_files/lpddr5/LPDDR5-2133_CL6_Component_Dual-Channel-1R-1CPR-16Gb_(32GbTotal)_x16_WCK_1066MHz.qprs
								MEM_PRESET_ID_FSP0                   LPDDR5-2133_CL6_Component_Dual-Channel-1R-1CPR-16Gb_(32GbTotal)_x16_WCK_1066MHz
								"
			}
		} elseif { $hps_emif_mem_clk_freq_mhz== 1200.0 } {
			if { $hps_emif_channel == 1} {
			set_component_param "emif_hps
								MEM_PRESET_FILE_EN_FSP0              true
								MEM_PRESET_ID_FSP0_AUTO_BOOL         false
								MEM_PRESET_FILE_QPRS_FSP0            ${prjroot}/board/preset_files/lpddr5/LPDDR5-2750_CL8_Component_Single-Channel-1R-1CPR-16Gb_(16GbTotal)_x16_WCK_1200MHz.qprs
								MEM_PRESET_ID_FSP0                   LPDDR5-2750_CL8_Component_Single-Channel-1R-1CPR-16Gb_(16GbTotal)_x16_WCK_1200MHz
								"
			} elseif { $hps_emif_channel == 2} {
			set_component_param "emif_hps
								MEM_PRESET_FILE_EN_FSP0              true
								MEM_PRESET_ID_FSP0_AUTO_BOOL         false
								MEM_PRESET_FILE_QPRS_FSP0            ${prjroot}/board/preset_files/lpddr5/LPDDR5-2750_CL8_Component_Dual-Channel-1R-1CPR-16Gb_(32GbTotal)_x16_WCK_1200MHz.qprs
								MEM_PRESET_ID_FSP0                   LPDDR5-2750_CL8_Component_Dual-Channel-1R-1CPR-16Gb_(32GbTotal)_x16_WCK_1200MHz
								"
			}
		} elseif { $hps_emif_mem_clk_freq_mhz== 933.0 } {
			if { $hps_emif_channel == 1} {
			set_component_param "emif_hps
								MEM_PRESET_FILE_EN_FSP0              true
								MEM_PRESET_ID_FSP0_AUTO_BOOL         false
								MEM_PRESET_FILE_QPRS_FSP0            ${prjroot}/board/preset_files/lpddr5/LPDDR5-2133_CL6_Component_Single-Channel-1R-1CPR-16Gb_(16GbTotal)_x16_WCK_933MHz.qprs
								MEM_PRESET_ID_FSP0                   LPDDR5-2133_CL6_Component_Single-Channel-1R-1CPR-16Gb_(16GbTotal)_x16_WCK_933MHz
								"
			} elseif { $hps_emif_channel == 2} {
			set_component_param "emif_hps
								MEM_PRESET_FILE_EN_FSP0              true
								MEM_PRESET_ID_FSP0_AUTO_BOOL         false
								MEM_PRESET_FILE_QPRS_FSP0            ${prjroot}/board/preset_files/lpddr5/LPDDR5-2133_CL6_Component_Dual-Channel-1R-1CPR-16Gb_(32GbTotal)_x16_WCK_933MHz.qprs
								MEM_PRESET_ID_FSP0                   LPDDR5-2133_CL6_Component_Dual-Channel-1R-1CPR-16Gb_(32GbTotal)_x16_WCK_933MHz
								"
			}
		}

	}

	if {$hps_emif_channel == 1} {
		# ------ Connections --------------------------------- #
		connect "${cpu_instance}.io96b0_ch0_axi emif_hps.s0_axi4"

		# ------ Ports export -------------------------------- #
		export emif_hps emif_mem_0         emif_hps_emif_mem_0 
		export emif_hps emif_oct_0         emif_hps_emif_oct_0
		export emif_hps emif_ref_clk_0     emif_hps_emif_ref_clk_0
	} elseif {($hps_emif_channel == 2) && ($hps_emif_topology == "2x16")} {
		# ------ Connections 2ch singleIO96B ------------------ #
		connect "${cpu_instance}.io96b0_ch0_axi emif_hps.s0_axi4"
		connect "${cpu_instance}.io96b0_ch1_axi emif_hps.s1_axi4"

		# ------ Ports export -------------------------------- #
		export emif_hps emif_mem_0         emif_hps_emif_mem_0 
		export emif_hps emif_mem_1         emif_hps_emif_mem_1
		export emif_hps emif_oct_0         emif_hps_emif_oct_0
		export emif_hps emif_oct_1         emif_hps_emif_oct_1
		export emif_hps emif_ref_clk_0     emif_hps_emif_ref_clk_0
	}
}
