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
source ./utils.tcl

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
    add_component_param     "emif_ph2 emif_hps
                             IP_FILE_PATH ip/$qsys_name/emif_hps.ip"
} else {
    add_component_param     "emif_ph2 emif_hps
                             IP_FILE_PATH ip/$qsys_name/emif_hps.ip"
  							   
    if {$hps_emif_type == "ddr4"} {    
        load_component emif_hps
        #TO BE COMPLETED
        #apply_component_preset  "DDR4-3200U CL18 Component 1CS 16Gb (1Gb x16)"
        #apply_component_preset  "DDR4-3200AA CL22 Component 1CS 8Gb (512Mb x16)"
        #save_component
      
#        set_component_param     "emif_hps 
#                                PROTOCOL_ENUM PROTOCOL_DDR4
#                                PHY_DDR4_RATE_ENUM $hps_emif_rate
#                                MEM_DDR4_FORMAT_ENUM MEM_FORMAT_DISCRETE
#                                MEM_DDR4_DQ_WIDTH $total_hps_emif_width
#                                MEM_DDR4_TCL $selected_tcl
#                                MEM_DDR4_WTCL $selected_wtcl
#                                MEM_DDR4_ROW_ADDR_WIDTH 17
#                                MEM_DDR4_BANK_ADDR_WIDTH 2
#                                MEM_DDR4_BANK_GROUP_WIDTH 1
#                                MEM_DDR4_NUM_OF_DIMMS 1
#                                MEM_DDR4_RANKS_PER_DIMM 1
#                                MEM_DDR4_CK_WIDTH 1
#                                MEM_DDR4_RTT_WR_ENUM DDR4_RTT_WR_ODT_DISABLED
#                                MEM_DDR4_DRV_STR_ENUM DDR4_DRV_STR_RZQ_7
#                                MEM_DDR4_RTT_NOM_ENUM DDR4_RTT_NOM_ODT_DISABLED
#                                MEM_DDR4_RTT_PARK DDR4_RTT_PARK_RZQ_4
#                                MEM_DDR4_USE_DEFAULT_ODT false
#                                MEM_DDR4_R_ODT0_1X1 off
#                                MEM_DDR4_W_ODT0_1X1 off
#                                MEM_DDR4_DM_EN true
#                                MEM_DDR4_READ_DBI true
#                                MEM_DDR4_WRITE_DBI false
#                                PHY_DDR4_CONFIG_ENUM CONFIG_PHY_AND_HARD_CTRL
#                                PHY_DDR4_USER_PING_PONG_EN false
#                                PHY_DDR4_DEFAULT_REF_CLK_FREQ false
#                                PHY_DDR4_USER_REF_CLK_FREQ_MHZ $hps_emif_ref_clk_freq_mhz
#                                CTRL_DDR4_ECC_EN $hps_emif_ecc_en
#                                CTRL_DDR4_ECC_AUTO_CORRECTION_EN $hps_emif_ecc_en
#                                PHY_DDR4_DEFAULT_IO false
#                                PHY_DDR4_USER_AC_IO_STD_ENUM IO_STD_SSTL_12
#                                PHY_DDR4_USER_CK_IO_STD_ENUM IO_STD_SSTL_12
#                                PHY_DDR4_USER_DATA_IO_STD_ENUM IO_STD_POD_12
#                                PHY_DDR4_USER_AC_MODE_ENUM OUT_OCT_40_CAL
#                                PHY_DDR4_USER_CK_MODE_ENUM OUT_OCT_40_CAL
#                                PHY_DDR4_USER_DATA_OUT_MODE_ENUM OUT_OCT_34_CAL
#                                PHY_DDR4_USER_DATA_IN_MODE_ENUM IN_OCT_60_CAL
#                                PHY_DDR4_USER_PLL_REF_CLK_IO_STD_ENUM IO_STD_TRUE_DIFF_SIGNALING
#                                PHY_DDR4_USER_RZQ_IO_STD_ENUM IO_STD_CMOS_12
#                                PHY_DDR4_MEM_CLK_FREQ_MHZ $hps_emif_mem_clk_freq_mhz
#                                DIAG_DDR4_EXPORT_SEQ_AVALON_SLAVE CAL_DEBUG_EXPORT_MODE_DISABLED
#                                DIAG_ENABLE_JTAG_UART false
#                                DIAG_HMC_HRC OFF
#                                DIAG_SOFT_NIOS_MODE SOFT_NIOS_MODE_DISABLED"
        }

        # ------ Connections --------------------------------- #
        connect "${cpu_instance}.emif0_ch0_axi emif_hps.s0_axi4"

        # ------ Ports export -------------------------------- #
        export emif_hps mem_0         emif_hps_mem_0 
        export emif_hps oct_0         emif_hps_oct_0
        export emif_hps ref_clk_0     emif_ref_clk_0
}