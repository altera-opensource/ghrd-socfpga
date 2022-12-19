#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2021-2021 Intel Corporation.
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
  
        add_component_param     "altera_emif_fm_hps emif_hps 
  							   IP_FILE_PATH ip/$qsys_name/emif_hps.ip"
  							   
  
        if {$hps_emif_type == "ddr4"} {    
           load_component emif_hps
           #TO BE COMPLETED
           #apply_component_preset  "DDR4-3200U CL18 Component 1CS 16Gb (1Gb x16)"
           apply_component_preset  "DDR4-3200AA CL22 Component 1CS 8Gb (512Mb x16)"
           save_component
      
           set_component_param     "emif_hps 
                                    PROTOCOL_ENUM PROTOCOL_DDR4
                                    PHY_DDR4_RATE_ENUM $hps_emif_rate
                                    MEM_DDR4_FORMAT_ENUM MEM_FORMAT_RDIMM
                                    MEM_DDR4_DQ_WIDTH $total_hps_emif_width
                                    MEM_DDR4_TCL $selected_tcl     
                                    MEM_DDR4_WTCL $selected_wtcl
                                    MEM_DDR4_ROW_ADDR_WIDTH 16
                                    MEM_DDR4_BANK_ADDR_WIDTH 2
                                    MEM_DDR4_BANK_GROUP_WIDTH 2
                                    MEM_DDR4_NUM_OF_DIMMS 1
                                    MEM_DDR4_RANKS_PER_DIMM 1
                                    MEM_DDR4_CK_WIDTH 1
                                    MEM_DDR4_RTT_WR_ENUM DDR4_RTT_WR_ODT_DISABLED
                                    MEM_DDR4_DRV_STR_ENUM DDR4_DRV_STR_RZQ_7
                                    MEM_DDR4_RTT_NOM_ENUM DDR4_RTT_NOM_ODT_DISABLED
                                    MEM_DDR4_RTT_PARK DDR4_RTT_PARK_RZQ_4
                                    MEM_DDR4_USE_DEFAULT_ODT false
                                    MEM_DDR4_R_ODT0_1X1 off
                                    MEM_DDR4_W_ODT0_1X1 off
                                    MEM_DDR4_DM_EN true
                                    MEM_DDR4_READ_DBI true
                                    MEM_DDR4_WRITE_DBI false
                                    PHY_DDR4_CONFIG_ENUM CONFIG_PHY_AND_HARD_CTRL
                                    PHY_DDR4_USER_PING_PONG_EN false
                                    PHY_DDR4_DEFAULT_REF_CLK_FREQ false
                                    PHY_DDR4_USER_REF_CLK_FREQ_MHZ $hps_emif_ref_clk_freq_mhz
                                    CTRL_DDR4_ECC_EN 0
                                    CTRL_DDR4_ECC_AUTO_CORRECTION_EN 0
                                    PHY_DDR4_DEFAULT_IO false
                                    PHY_DDR4_USER_AC_IO_STD_ENUM IO_STD_SSTL_12
                                    PHY_DDR4_USER_CK_IO_STD_ENUM IO_STD_SSTL_12
                                    PHY_DDR4_USER_DATA_IO_STD_ENUM IO_STD_POD_12
                                    PHY_DDR4_USER_AC_MODE_ENUM OUT_OCT_40_CAL
                                    PHY_DDR4_USER_CK_MODE_ENUM OUT_OCT_40_CAL
                                    PHY_DDR4_USER_DATA_OUT_MODE_ENUM OUT_OCT_34_CAL
                                    PHY_DDR4_USER_DATA_IN_MODE_ENUM IN_OCT_60_CAL
                                    PHY_DDR4_USER_PLL_REF_CLK_IO_STD_ENUM IO_STD_TRUE_DIFF_SIGNALING
                                    PHY_DDR4_USER_RZQ_IO_STD_ENUM IO_STD_CMOS_12
                                    PHY_DDR4_MEM_CLK_FREQ_MHZ $hps_emif_mem_clk_freq_mhz
                                    DIAG_DDR4_EXPORT_SEQ_AVALON_SLAVE CAL_DEBUG_EXPORT_MODE_DISABLED
                                    DIAG_ENABLE_JTAG_UART false
                                    DIAG_SOFT_NIOS_MODE SOFT_NIOS_MODE_DISABLED
                                    PHY_DDR4_USER_AC_SLEW_RATE_ENUM SLEW_RATE_FM_MEDIUM
                                    PHY_DDR4_USER_CK_SLEW_RATE_ENUM SLEW_RATE_FM_MEDIUM
                                    MEM_DDR4_SPEEDBIN_ENUM DDR4_SPEEDBIN_2933
                                    MEM_DDR4_TIS_PS 62
                                    MEM_DDR4_TIS_AC_MV 90
                                    MEM_DDR4_TIH_PS 87
                                    MEM_DDR4_TIH_DC_MV 65
                                    MEM_DDR4_VDIVW_TOTAL 130
                                    MEM_DDR4_TDQSQ_UI 0.14
                                    MEM_DDR4_TQH_UI 0.74
                                    MEM_DDR4_TDQSCK_PS 175
                                    MEM_DDR4_TRCD_NS 14.16
                                    MEM_DDR4_TRP_NS 14.16
                                    MEM_DDR4_TRRD_S_CYC 4
                                    MEM_DDR4_TRRD_L_CYC 6
                                    MEM_DDR4_TFAW_NS 21.0
                                    MEM_DDR4_TWTR_S_CYC 3
                                    MEM_DDR4_TWTR_L_CYC 9
                                    DIAG_HMC_HRC OFF
                                    DIAG_EXPORT_PLL_LOCKED 1"
									
#          set_component_param     "emif_hps DIAG_EXTRA_CONFIGS SEQ_DBG_SKIP_STEPS_ADD=6750208,SEQ_GLOBAL_SKIP_STEPS_ADD=8"
        }
  
  
        # ------ Connections --------------------------------- #
        connect "emif_hps.hps_emif ${cpu_instance}.hps_emif"
  
        # ------ Ports export -------------------------------- #
        export emif_hps mem         emif_hps_mem 
        export emif_hps oct         emif_hps_oct 
        export emif_hps pll_ref_clk emif_hps_pll_ref_clk 
     }
  
     