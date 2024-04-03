#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2020 Intel Corporation.
#
#****************************************************************************
#
# This file contains AGILEX HPS EMIF configuration and export of signals/ports
# This file will be source by GHRD construct_hps.tcl
#
# For EMIF configuration targetting specified board, please refer to file ./board/board_<$board>_emif_setting.tcl
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

add_component_param     "emif_ph2 emif_hps
                        IP_FILE_PATH ip/$qsys_name/emif_hps.ip"

# ------ Connections --------------------------------- #
connect "${cpu_instance}.emif0_ch0_axi emif_hps.s0_axi4"
   
# ------ Ports export -------------------------------- #
export emif_hps mem_0         emif_hps_mem_0 
export emif_hps oct_0         emif_hps_oct_0
#export emif_hps pll_ref_clk emif_hps_pll_ref_clk 

connect "sub_clk.out_clk                emif_hps.ref_clk_0
         sub_clk.out_clk                emif_hps.usr_async_clk_0
		 sub_clk.out_clk                emif_hps.s0_axil_clk
		 sub_rst_in.out_reset           emif_hps.core_init_n_0
		 sub_rst_in.out_reset           emif_hps.s0_axil_rst_n
		 "

#if {$hps_emif_mem_part == "custom"} {
#   # To be modify
#   if {$hps_emif_en == 1} {
#      add_component_param     "altera_emif_fm_hps emif_hps
#                           IP_FILE_PATH ip/$qsys_name/emif_hps.ip"
#   
#      load_component emif_hps
#      apply_component_preset  "$hps_emif_comp_preset"
#      save_component
#      
#      set_component_param     "emif_hps 
#                               PROTOCOL_ENUM PROTOCOL_DDR4
#                               PHY_DDR4_RATE_ENUM $hps_emif_rate
#                               MEM_DDR4_FORMAT_ENUM $hps_emif_mem_format
#                               MEM_DDR4_DQ_WIDTH $total_hps_emif_width
#                               MEM_DDR4_TCL $hps_emif_tcl
#                               MEM_DDR4_WTCL $hps_emif_wtcl
#                               MEM_DDR4_BANK_ADDR_WIDTH $hps_emif_bank_addr_width
#                               MEM_DDR4_BANK_GROUP_WIDTH $hps_emif_bank_gp_width
#                               MEM_DDR4_NUM_OF_DIMMS $hps_emif_num_dimms
#                               MEM_DDR4_RANKS_PER_DIMM $hps_emif_ranks_per_dimm
#                               MEM_DDR4_CK_WIDTH 1
#                               MEM_DDR4_RTT_WR_ENUM DDR4_RTT_WR_ODT_DISABLED
#                               MEM_DDR4_DRV_STR_ENUM DDR4_DRV_STR_RZQ_7
#                               MEM_DDR4_RTT_NOM_ENUM DDR4_RTT_NOM_ODT_DISABLED
#                               MEM_DDR4_RTT_PARK DDR4_RTT_PARK_RZQ_4
#                               MEM_DDR4_USE_DEFAULT_ODT false
#                               MEM_DDR4_R_ODT0_1X1 off
#                               MEM_DDR4_W_ODT0_1X1 off
#                               MEM_DDR4_DM_EN true
#                               MEM_DDR4_READ_DBI true
#                               MEM_DDR4_WRITE_DBI false
#                               PHY_DDR4_CONFIG_ENUM CONFIG_PHY_AND_HARD_CTRL
#                               PHY_DDR4_USER_PING_PONG_EN false
#                               PHY_DDR4_DEFAULT_REF_CLK_FREQ false
#                               PHY_DDR4_USER_REF_CLK_FREQ_MHZ $hps_emif_ref_clk_freq_mhz
#                               CTRL_DDR4_ECC_EN $hps_emif_ecc_en
#                               CTRL_DDR4_ECC_AUTO_CORRECTION_EN $hps_emif_ecc_en
#                               PHY_DDR4_DEFAULT_IO false
#                               PHY_DDR4_USER_AC_IO_STD_ENUM IO_STD_SSTL_12
#                               PHY_DDR4_USER_CK_IO_STD_ENUM IO_STD_SSTL_12
#                               PHY_DDR4_USER_DATA_IO_STD_ENUM IO_STD_POD_12
#                               PHY_DDR4_USER_AC_MODE_ENUM OUT_OCT_40_CAL
#                               PHY_DDR4_USER_CK_MODE_ENUM OUT_OCT_40_CAL
#                               PHY_DDR4_USER_DATA_OUT_MODE_ENUM OUT_OCT_34_CAL
#                               PHY_DDR4_USER_DATA_IN_MODE_ENUM IN_OCT_60_CAL
#                               PHY_DDR4_USER_PLL_REF_CLK_IO_STD_ENUM IO_STD_TRUE_DIFF_SIGNALING
#                               PHY_DDR4_USER_RZQ_IO_STD_ENUM IO_STD_CMOS_12
#                               PHY_DDR4_MEM_CLK_FREQ_MHZ $hps_emif_mem_clk_freq_mhz
#                               DIAG_DDR4_EXPORT_SEQ_AVALON_SLAVE $hps_emif_export_seq_avalon_slave
#                               DIAG_ENABLE_JTAG_UART $hps_emif_jtag_uart_en
#                               DIAG_SOFT_NIOS_MODE SOFT_NIOS_MODE_DISABLED
#                               "
#                               DIAG_EXTRA_CONFIGS $hps_emif_extra_configs
#
#      # ------ Connections --------------------------------- #
#      connect "emif_hps.hps_emif ${cpu_instance}.hps_emif"
#   
#      # ------ Ports export -------------------------------- #
#      export emif_hps mem         emif_hps_mem 
#      export emif_hps oct         emif_hps_oct 
#      export emif_hps pll_ref_clk emif_hps_pll_ref_clk 
#   }
#} elseif {$hps_emif_mem_part == "termination_sweep"} {
#   # To be modify
#   if {$hps_emif_en == 1} {
#      # ------ Sodimm configuration --------------------- #
#      add_component_param     "altera_emif_fm_hps emif_hps
#                           IP_FILE_PATH ip/$qsys_name/emif_hps.ip"
#   
#      load_component emif_hps
#      apply_component_preset  "$hps_emif_comp_preset"
#      save_component
#      
#      set_component_param     "emif_hps 
#                               PROTOCOL_ENUM PROTOCOL_DDR4
#                               PHY_DDR4_RATE_ENUM $hps_emif_rate
#                               MEM_DDR4_FORMAT_ENUM $hps_emif_mem_format
#                               MEM_DDR4_DQ_WIDTH $total_hps_emif_width
#                               MEM_DDR4_TCL $hps_emif_tcl
#                               MEM_DDR4_WTCL $hps_emif_wtcl
#                               MEM_DDR4_BANK_ADDR_WIDTH $hps_emif_bank_addr_width
#                               MEM_DDR4_BANK_GROUP_WIDTH $hps_emif_bank_gp_width
#                               MEM_DDR4_NUM_OF_DIMMS $hps_emif_num_dimms
#                               MEM_DDR4_RANKS_PER_DIMM $hps_emif_ranks_per_dimm
#                               MEM_DDR4_CK_WIDTH 1
#                               MEM_DDR4_RTT_WR_ENUM $hps_emif_rtt_wr_enum
#                               MEM_DDR4_DRV_STR_ENUM $hps_emif_drv_str_enum
#                               MEM_DDR4_RTT_NOM_ENUM $hps_emif_rtt_nom_enum
#                               MEM_DDR4_RTT_PARK $hps_emif_rtt_park
#                               MEM_DDR4_USE_DEFAULT_ODT $hps_emif_use_default_odt
#                               MEM_DDR4_R_ODT0_1X1 $hps_emif_r_odt0_1x1
#                               MEM_DDR4_W_ODT0_1X1 $hps_emif_w_odt0_1x1
#                               MEM_DDR4_DM_EN true
#                               MEM_DDR4_READ_DBI true
#                               MEM_DDR4_WRITE_DBI false
#                               PHY_DDR4_CONFIG_ENUM CONFIG_PHY_AND_HARD_CTRL
#                               PHY_DDR4_USER_PING_PONG_EN false
#                               PHY_DDR4_USER_REF_CLK_FREQ_MHZ $hps_emif_ref_clk_freq_mhz
#                               PHY_DDR4_DEFAULT_REF_CLK_FREQ false
#                               CTRL_DDR4_ECC_EN $hps_emif_ecc_en
#                               CTRL_DDR4_ECC_AUTO_CORRECTION_EN $hps_emif_ecc_en
#                               PHY_DDR4_DEFAULT_IO false
#                               PHY_DDR4_USER_AC_IO_STD_ENUM $hps_emif_ac_io_std_enum
#                               PHY_DDR4_USER_CK_IO_STD_ENUM $hps_emif_ck_io_std_enum
#                               PHY_DDR4_USER_DATA_IO_STD_ENUM $hps_emif_data_io_std_enum
#                               PHY_DDR4_USER_AC_MODE_ENUM $hps_emif_ac_mode_enum
#                               PHY_DDR4_USER_CK_MODE_ENUM $hps_emif_ck_mode_enum
#                               PHY_DDR4_USER_DATA_OUT_MODE_ENUM $hps_emif_data_out_mode_enum
#                               PHY_DDR4_USER_DATA_IN_MODE_ENUM $hps_emif_data_in_mode_enum
#                               PHY_DDR4_USER_PLL_REF_CLK_IO_STD_ENUM $hps_emif_ref_clk_io_std_enum
#                               PHY_DDR4_USER_RZQ_IO_STD_ENUM $hps_emif_rzq_io_std_enum
#                               PHY_DDR4_MEM_CLK_FREQ_MHZ $hps_emif_mem_clk_freq_mhz
#                               DIAG_DDR4_EXPORT_SEQ_AVALON_SLAVE $hps_emif_export_seq_avalon_slave
#                               DIAG_ENABLE_JTAG_UART $hps_emif_jtag_uart_en
#                               DIAG_SOFT_NIOS_MODE $hps_emif_diag_soft_nios_mode
#                               "
#                               DIAG_EXTRA_CONFIGS $hps_emif_extra_configs
#
#      # ------ Connections --------------------------------- #
#      connect "emif_hps.hps_emif ${cpu_instance}.hps_emif"
#   
#      # ------ Ports export -------------------------------- #
#      export emif_hps mem         emif_hps_mem 
#      export emif_hps oct         emif_hps_oct 
#      export emif_hps pll_ref_clk emif_hps_pll_ref_clk 
#   }
#} elseif {$hps_emif_mem_part == "default_part" } {
#    set board_emif_config_file "./board/board_${board}_emif_setting.tcl"
#    if {[file exist $board_emif_config_file]} {
#        source $board_emif_config_file
#    } else {
#        error "$board_emif_config_file not exist!! Please make sure the board settings files are included in folder ./board/"
#    }
#} else {
#   puts "UNKNOWN HPS EMIF MEM PART, $hps_emif_mem_part"
#}
#