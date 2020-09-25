#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2013-2020 Intel Corporation.
#
#****************************************************************************
#
# This script construct top level qsys for the GHRD
# to use this script, 
# example command to execute this script file
#   qsys-script --script=create_ghrd_qsys.tcl
#
# --- alternatively, input arguments could be passed in to select other FPGA variant. 
#     qsys_name    : <name your qsys top>,
#     devicefamily : <FPGA device family>,
#     device       : <FPGA device part number>
# example command to execute this script file
#   qsys-script --script=create_ghrd_qsys.tcl --cmd="set qsys_name soc_system; set devicefamily CYCLONEV; set device 5CSXFC6D6F31C8ES"
#
#****************************************************************************
    
source ./design_config.tcl
    
if { ![ info exists devicefamily ] } {
  set devicefamily "CYCLONEV"
} else {
  puts "-- Accepted parameter \$devicefamily = $devicefamily"
}
    
if { ![ info exists device ] } {
  set device "5CSXFC6D6F31C6"
} else {
  puts "-- Accepted parameter \$device = $device"
}
    
if { ![ info exists qsys_name ] } {
  set qsys_name "soc_system"
} else {
  puts "-- Accepted parameter \$qsys_name = $qsys_name"
}

if { ![ info exists fpga_pcie ] } {
  set fpga_pcie $PCIE_ENABLE
} else {
  puts "-- Accepted parameter \$fpga_pcie = $fpga_pcie"
}

package require -exact qsys 14.1
reload_ip_catalog

if {$fpga_pcie == 1} {
source ./construct_subsys_pcie.tcl
reload_ip_catalog
}

create_system $qsys_name

    set_project_property DEVICE_FAMILY $devicefamily
    set_project_property DEVICE $device
    
    add_instance sysid_qsys altera_avalon_sysid_qsys
    set_instance_parameter_value sysid_qsys {id} {-1395321600}

    add_instance hps_0 altera_hps
    set_instance_parameter_value hps_0 {MEM_VENDOR} {JEDEC}
    set_instance_parameter_value hps_0 {MEM_FORMAT} {DISCRETE}
    set_instance_parameter_value hps_0 {RDIMM_CONFIG} {0000000000000000}
    set_instance_parameter_value hps_0 {LRDIMM_EXTENDED_CONFIG} {0x000000000000000000}
    set_instance_parameter_value hps_0 {DISCRETE_FLY_BY} {1}
    set_instance_parameter_value hps_0 {DEVICE_DEPTH} {1}
    set_instance_parameter_value hps_0 {MEM_MIRROR_ADDRESSING} {0}
    set_instance_parameter_value hps_0 {MEM_CLK_FREQ_MAX} {800.0}
    set_instance_parameter_value hps_0 {MEM_ROW_ADDR_WIDTH} {15}
    set_instance_parameter_value hps_0 {MEM_COL_ADDR_WIDTH} {10}
    set_instance_parameter_value hps_0 {MEM_DQ_WIDTH} {40}
    set_instance_parameter_value hps_0 {MEM_DQ_PER_DQS} {8}
    set_instance_parameter_value hps_0 {MEM_BANKADDR_WIDTH} {3}
    set_instance_parameter_value hps_0 {MEM_IF_DM_PINS_EN} {1}
    set_instance_parameter_value hps_0 {MEM_IF_DQSN_EN} {1}
    set_instance_parameter_value hps_0 {MEM_NUMBER_OF_DIMMS} {1}
    set_instance_parameter_value hps_0 {MEM_NUMBER_OF_RANKS_PER_DIMM} {1}
    set_instance_parameter_value hps_0 {MEM_NUMBER_OF_RANKS_PER_DEVICE} {1}
    set_instance_parameter_value hps_0 {MEM_RANK_MULTIPLICATION_FACTOR} {1}
    set_instance_parameter_value hps_0 {MEM_CK_WIDTH} {1}
    set_instance_parameter_value hps_0 {MEM_CS_WIDTH} {1}
    set_instance_parameter_value hps_0 {MEM_CLK_EN_WIDTH} {1}
    set_instance_parameter_value hps_0 {ALTMEMPHY_COMPATIBLE_MODE} {0}
    set_instance_parameter_value hps_0 {NEXTGEN} {1}
    set_instance_parameter_value hps_0 {MEM_IF_BOARD_BASE_DELAY} {10}
    set_instance_parameter_value hps_0 {MEM_IF_SIM_VALID_WINDOW} {0}
    set_instance_parameter_value hps_0 {MEM_GUARANTEED_WRITE_INIT} {0}
    set_instance_parameter_value hps_0 {MEM_VERBOSE} {1}
    set_instance_parameter_value hps_0 {PINGPONGPHY_EN} {0}
    set_instance_parameter_value hps_0 {DUPLICATE_AC} {0}
    set_instance_parameter_value hps_0 {REFRESH_BURST_VALIDATION} {0}
    set_instance_parameter_value hps_0 {AP_MODE_EN} {00}
    set_instance_parameter_value hps_0 {AP_MODE} {0}
    set_instance_parameter_value hps_0 {MEM_BL} {OTF}
    set_instance_parameter_value hps_0 {MEM_BT} {Sequential}
    set_instance_parameter_value hps_0 {MEM_ASR} {Manual}
    set_instance_parameter_value hps_0 {MEM_SRT} {Normal}
    set_instance_parameter_value hps_0 {MEM_PD} {DLL off}
    set_instance_parameter_value hps_0 {MEM_DRV_STR} {RZQ/6}
    set_instance_parameter_value hps_0 {MEM_DLL_EN} {1}
    set_instance_parameter_value hps_0 {MEM_RTT_NOM} {RZQ/6}
    set_instance_parameter_value hps_0 {MEM_RTT_WR} {Dynamic ODT off}
    set_instance_parameter_value hps_0 {MEM_WTCL} {6}
    set_instance_parameter_value hps_0 {MEM_ATCL} {Disabled}
    set_instance_parameter_value hps_0 {MEM_TCL} {7}
    set_instance_parameter_value hps_0 {MEM_AUTO_LEVELING_MODE} {1}
    set_instance_parameter_value hps_0 {MEM_USER_LEVELING_MODE} {Leveling}
    set_instance_parameter_value hps_0 {MEM_INIT_EN} {0}
    set_instance_parameter_value hps_0 {MEM_INIT_FILE} {}
    set_instance_parameter_value hps_0 {DAT_DATA_WIDTH} {32}
    set_instance_parameter_value hps_0 {TIMING_TIS} {170}
    set_instance_parameter_value hps_0 {TIMING_TIH} {120}
    set_instance_parameter_value hps_0 {TIMING_TDS} {10}
    set_instance_parameter_value hps_0 {TIMING_TDH} {45}
    set_instance_parameter_value hps_0 {TIMING_TDQSQ} {100}
    set_instance_parameter_value hps_0 {TIMING_TQHS} {300}
    set_instance_parameter_value hps_0 {TIMING_TQH} {0.38}
    set_instance_parameter_value hps_0 {TIMING_TDQSCK} {225}
    set_instance_parameter_value hps_0 {TIMING_TDQSCKDS} {450}
    set_instance_parameter_value hps_0 {TIMING_TDQSCKDM} {900}
    set_instance_parameter_value hps_0 {TIMING_TDQSCKDL} {1200}
    set_instance_parameter_value hps_0 {TIMING_TDQSS} {0.27}
    set_instance_parameter_value hps_0 {TIMING_TDQSH} {0.35}
    set_instance_parameter_value hps_0 {TIMING_TQSH} {0.4}
    set_instance_parameter_value hps_0 {TIMING_TDSH} {0.18}
    set_instance_parameter_value hps_0 {TIMING_TDSS} {0.18}
    set_instance_parameter_value hps_0 {MEM_TINIT_US} {500}
    set_instance_parameter_value hps_0 {MEM_TMRD_CK} {4}
    set_instance_parameter_value hps_0 {MEM_TRAS_NS} {35.0}
    set_instance_parameter_value hps_0 {MEM_TRCD_NS} {13.75}
    set_instance_parameter_value hps_0 {MEM_TRP_NS} {13.75}
    set_instance_parameter_value hps_0 {MEM_TREFI_US} {7.8}
    set_instance_parameter_value hps_0 {MEM_TRFC_NS} {260.0}
    set_instance_parameter_value hps_0 {CFG_TCCD_NS} {2.5}
    set_instance_parameter_value hps_0 {MEM_TWR_NS} {15.0}
    set_instance_parameter_value hps_0 {MEM_TWTR} {4}
    set_instance_parameter_value hps_0 {MEM_TFAW_NS} {30.0}
    set_instance_parameter_value hps_0 {MEM_TRRD_NS} {10.0}
    set_instance_parameter_value hps_0 {MEM_TRTP_NS} {10.0}
    set_instance_parameter_value hps_0 {POWER_OF_TWO_BUS} {0}
    set_instance_parameter_value hps_0 {SOPC_COMPAT_RESET} {0}
    set_instance_parameter_value hps_0 {AVL_MAX_SIZE} {4}
    set_instance_parameter_value hps_0 {BYTE_ENABLE} {1}
    set_instance_parameter_value hps_0 {ENABLE_CTRL_AVALON_INTERFACE} {1}
    set_instance_parameter_value hps_0 {CTL_DEEP_POWERDN_EN} {0}
    set_instance_parameter_value hps_0 {CTL_SELF_REFRESH_EN} {0}
    set_instance_parameter_value hps_0 {AUTO_POWERDN_EN} {0}
    set_instance_parameter_value hps_0 {AUTO_PD_CYCLES} {0}
    set_instance_parameter_value hps_0 {CTL_USR_REFRESH_EN} {0}
    set_instance_parameter_value hps_0 {CTL_AUTOPCH_EN} {0}
    set_instance_parameter_value hps_0 {CTL_ZQCAL_EN} {0}
    set_instance_parameter_value hps_0 {ADDR_ORDER} {0}
    set_instance_parameter_value hps_0 {CTL_LOOK_AHEAD_DEPTH} {4}
    set_instance_parameter_value hps_0 {CONTROLLER_LATENCY} {5}
    set_instance_parameter_value hps_0 {CFG_REORDER_DATA} {1}
    set_instance_parameter_value hps_0 {STARVE_LIMIT} {10}
    set_instance_parameter_value hps_0 {CTL_CSR_ENABLED} {0}
    set_instance_parameter_value hps_0 {CTL_CSR_CONNECTION} {INTERNAL_JTAG}
    set_instance_parameter_value hps_0 {CTL_ECC_ENABLED} {0}
    set_instance_parameter_value hps_0 {CTL_HRB_ENABLED} {0}
    set_instance_parameter_value hps_0 {CTL_ECC_AUTO_CORRECTION_ENABLED} {0}
    set_instance_parameter_value hps_0 {MULTICAST_EN} {0}
    set_instance_parameter_value hps_0 {CTL_DYNAMIC_BANK_ALLOCATION} {0}
    set_instance_parameter_value hps_0 {CTL_DYNAMIC_BANK_NUM} {4}
    set_instance_parameter_value hps_0 {DEBUG_MODE} {0}
    set_instance_parameter_value hps_0 {ENABLE_BURST_MERGE} {0}
    set_instance_parameter_value hps_0 {CTL_ENABLE_BURST_INTERRUPT} {1}
    set_instance_parameter_value hps_0 {CTL_ENABLE_BURST_TERMINATE} {1}
    set_instance_parameter_value hps_0 {LOCAL_ID_WIDTH} {8}
    set_instance_parameter_value hps_0 {WRBUFFER_ADDR_WIDTH} {6}
    set_instance_parameter_value hps_0 {MAX_PENDING_WR_CMD} {8}
    set_instance_parameter_value hps_0 {MAX_PENDING_RD_CMD} {16}
    set_instance_parameter_value hps_0 {USE_MM_ADAPTOR} {1}
    set_instance_parameter_value hps_0 {USE_AXI_ADAPTOR} {0}
    set_instance_parameter_value hps_0 {HCX_COMPAT_MODE} {0}
    set_instance_parameter_value hps_0 {CTL_CMD_QUEUE_DEPTH} {8}
    set_instance_parameter_value hps_0 {CTL_CSR_READ_ONLY} {1}
    set_instance_parameter_value hps_0 {CFG_DATA_REORDERING_TYPE} {INTER_BANK}
    set_instance_parameter_value hps_0 {NUM_OF_PORTS} {1}
    set_instance_parameter_value hps_0 {ENABLE_BONDING} {0}
    set_instance_parameter_value hps_0 {ENABLE_USER_ECC} {0}
    set_instance_parameter_value hps_0 {AVL_DATA_WIDTH_PORT} {32 32 32 32 32 32}
    set_instance_parameter_value hps_0 {PRIORITY_PORT} {1 1 1 1 1 1}
    set_instance_parameter_value hps_0 {WEIGHT_PORT} {0 0 0 0 0 0}
    set_instance_parameter_value hps_0 {CPORT_TYPE_PORT} {Bidirectional Bidirectional Bidirectional Bidirectional Bidirectional Bidirectional}
    set_instance_parameter_value hps_0 {ENABLE_EMIT_BFM_MASTER} {0}
    set_instance_parameter_value hps_0 {FORCE_SEQUENCER_TCL_DEBUG_MODE} {0}
    set_instance_parameter_value hps_0 {ENABLE_SEQUENCER_MARGINING_ON_BY_DEFAULT} {0}
    set_instance_parameter_value hps_0 {REF_CLK_FREQ} {25.0}
    set_instance_parameter_value hps_0 {REF_CLK_FREQ_PARAM_VALID} {0}
    set_instance_parameter_value hps_0 {REF_CLK_FREQ_MIN_PARAM} {0.0}
    set_instance_parameter_value hps_0 {REF_CLK_FREQ_MAX_PARAM} {0.0}
    set_instance_parameter_value hps_0 {PLL_DR_CLK_FREQ_PARAM} {0.0}
    set_instance_parameter_value hps_0 {PLL_DR_CLK_FREQ_SIM_STR_PARAM} {}
    set_instance_parameter_value hps_0 {PLL_DR_CLK_PHASE_PS_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_DR_CLK_PHASE_PS_SIM_STR_PARAM} {}
    set_instance_parameter_value hps_0 {PLL_DR_CLK_MULT_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_DR_CLK_DIV_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_MEM_CLK_FREQ_PARAM} {0.0}
    set_instance_parameter_value hps_0 {PLL_MEM_CLK_FREQ_SIM_STR_PARAM} {}
    set_instance_parameter_value hps_0 {PLL_MEM_CLK_PHASE_PS_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_MEM_CLK_PHASE_PS_SIM_STR_PARAM} {}
    set_instance_parameter_value hps_0 {PLL_MEM_CLK_MULT_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_MEM_CLK_DIV_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_AFI_CLK_FREQ_PARAM} {0.0}
    set_instance_parameter_value hps_0 {PLL_AFI_CLK_FREQ_SIM_STR_PARAM} {}
    set_instance_parameter_value hps_0 {PLL_AFI_CLK_PHASE_PS_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_AFI_CLK_PHASE_PS_SIM_STR_PARAM} {}
    set_instance_parameter_value hps_0 {PLL_AFI_CLK_MULT_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_AFI_CLK_DIV_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_WRITE_CLK_FREQ_PARAM} {0.0}
    set_instance_parameter_value hps_0 {PLL_WRITE_CLK_FREQ_SIM_STR_PARAM} {}
    set_instance_parameter_value hps_0 {PLL_WRITE_CLK_PHASE_PS_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_WRITE_CLK_PHASE_PS_SIM_STR_PARAM} {}
    set_instance_parameter_value hps_0 {PLL_WRITE_CLK_MULT_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_WRITE_CLK_DIV_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_ADDR_CMD_CLK_FREQ_PARAM} {0.0}
    set_instance_parameter_value hps_0 {PLL_ADDR_CMD_CLK_FREQ_SIM_STR_PARAM} {}
    set_instance_parameter_value hps_0 {PLL_ADDR_CMD_CLK_PHASE_PS_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_ADDR_CMD_CLK_PHASE_PS_SIM_STR_PARAM} {}
    set_instance_parameter_value hps_0 {PLL_ADDR_CMD_CLK_MULT_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_ADDR_CMD_CLK_DIV_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_AFI_HALF_CLK_FREQ_PARAM} {0.0}
    set_instance_parameter_value hps_0 {PLL_AFI_HALF_CLK_FREQ_SIM_STR_PARAM} {}
    set_instance_parameter_value hps_0 {PLL_AFI_HALF_CLK_PHASE_PS_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_AFI_HALF_CLK_PHASE_PS_SIM_STR_PARAM} {}
    set_instance_parameter_value hps_0 {PLL_AFI_HALF_CLK_MULT_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_AFI_HALF_CLK_DIV_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_NIOS_CLK_FREQ_PARAM} {0.0}
    set_instance_parameter_value hps_0 {PLL_NIOS_CLK_FREQ_SIM_STR_PARAM} {}
    set_instance_parameter_value hps_0 {PLL_NIOS_CLK_PHASE_PS_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_NIOS_CLK_PHASE_PS_SIM_STR_PARAM} {}
    set_instance_parameter_value hps_0 {PLL_NIOS_CLK_MULT_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_NIOS_CLK_DIV_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_CONFIG_CLK_FREQ_PARAM} {0.0}
    set_instance_parameter_value hps_0 {PLL_CONFIG_CLK_FREQ_SIM_STR_PARAM} {}
    set_instance_parameter_value hps_0 {PLL_CONFIG_CLK_PHASE_PS_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_CONFIG_CLK_PHASE_PS_SIM_STR_PARAM} {}
    set_instance_parameter_value hps_0 {PLL_CONFIG_CLK_MULT_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_CONFIG_CLK_DIV_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_P2C_READ_CLK_FREQ_PARAM} {0.0}
    set_instance_parameter_value hps_0 {PLL_P2C_READ_CLK_FREQ_SIM_STR_PARAM} {}
    set_instance_parameter_value hps_0 {PLL_P2C_READ_CLK_PHASE_PS_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_P2C_READ_CLK_PHASE_PS_SIM_STR_PARAM} {}
    set_instance_parameter_value hps_0 {PLL_P2C_READ_CLK_MULT_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_P2C_READ_CLK_DIV_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_C2P_WRITE_CLK_FREQ_PARAM} {0.0}
    set_instance_parameter_value hps_0 {PLL_C2P_WRITE_CLK_FREQ_SIM_STR_PARAM} {}
    set_instance_parameter_value hps_0 {PLL_C2P_WRITE_CLK_PHASE_PS_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_C2P_WRITE_CLK_PHASE_PS_SIM_STR_PARAM} {}
    set_instance_parameter_value hps_0 {PLL_C2P_WRITE_CLK_MULT_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_C2P_WRITE_CLK_DIV_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_HR_CLK_FREQ_PARAM} {0.0}
    set_instance_parameter_value hps_0 {PLL_HR_CLK_FREQ_SIM_STR_PARAM} {}
    set_instance_parameter_value hps_0 {PLL_HR_CLK_PHASE_PS_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_HR_CLK_PHASE_PS_SIM_STR_PARAM} {}
    set_instance_parameter_value hps_0 {PLL_HR_CLK_MULT_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_HR_CLK_DIV_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_AFI_PHY_CLK_FREQ_PARAM} {0.0}
    set_instance_parameter_value hps_0 {PLL_AFI_PHY_CLK_FREQ_SIM_STR_PARAM} {}
    set_instance_parameter_value hps_0 {PLL_AFI_PHY_CLK_PHASE_PS_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_AFI_PHY_CLK_PHASE_PS_SIM_STR_PARAM} {}
    set_instance_parameter_value hps_0 {PLL_AFI_PHY_CLK_MULT_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_AFI_PHY_CLK_DIV_PARAM} {0}
    set_instance_parameter_value hps_0 {PLL_CLK_PARAM_VALID} {0}
    set_instance_parameter_value hps_0 {ENABLE_EXTRA_REPORTING} {0}
    set_instance_parameter_value hps_0 {NUM_EXTRA_REPORT_PATH} {10}
    set_instance_parameter_value hps_0 {ENABLE_ISS_PROBES} {0}
    set_instance_parameter_value hps_0 {CALIB_REG_WIDTH} {8}
    set_instance_parameter_value hps_0 {USE_SEQUENCER_BFM} {0}
    set_instance_parameter_value hps_0 {PLL_SHARING_MODE} {None}
    set_instance_parameter_value hps_0 {NUM_PLL_SHARING_INTERFACES} {1}
    set_instance_parameter_value hps_0 {EXPORT_AFI_HALF_CLK} {0}
    set_instance_parameter_value hps_0 {ABSTRACT_REAL_COMPARE_TEST} {0}
    set_instance_parameter_value hps_0 {INCLUDE_BOARD_DELAY_MODEL} {0}
    set_instance_parameter_value hps_0 {INCLUDE_MULTIRANK_BOARD_DELAY_MODEL} {0}
    set_instance_parameter_value hps_0 {USE_FAKE_PHY} {0}
    set_instance_parameter_value hps_0 {FORCE_MAX_LATENCY_COUNT_WIDTH} {0}
    set_instance_parameter_value hps_0 {ENABLE_NON_DESTRUCTIVE_CALIB} {0}
    set_instance_parameter_value hps_0 {ENABLE_DELAY_CHAIN_WRITE} {0}
    set_instance_parameter_value hps_0 {TRACKING_ERROR_TEST} {0}
    set_instance_parameter_value hps_0 {TRACKING_WATCH_TEST} {0}
    set_instance_parameter_value hps_0 {MARGIN_VARIATION_TEST} {0}
    set_instance_parameter_value hps_0 {AC_ROM_USER_ADD_0} {0_0000_0000_0000}
    set_instance_parameter_value hps_0 {AC_ROM_USER_ADD_1} {0_0000_0000_1000}
    set_instance_parameter_value hps_0 {TREFI} {35100}
    set_instance_parameter_value hps_0 {REFRESH_INTERVAL} {15000}
    set_instance_parameter_value hps_0 {ENABLE_NON_DES_CAL_TEST} {0}
    set_instance_parameter_value hps_0 {TRFC} {350}
    set_instance_parameter_value hps_0 {ENABLE_NON_DES_CAL} {0}
    set_instance_parameter_value hps_0 {EXTRA_SETTINGS} {}
    set_instance_parameter_value hps_0 {MEM_DEVICE} {MISSING_MODEL}
    set_instance_parameter_value hps_0 {FORCE_SYNTHESIS_LANGUAGE} {}
    set_instance_parameter_value hps_0 {FORCED_NUM_WRITE_FR_CYCLE_SHIFTS} {0}
    set_instance_parameter_value hps_0 {SEQUENCER_TYPE} {NIOS}
    set_instance_parameter_value hps_0 {ADVERTIZE_SEQUENCER_SW_BUILD_FILES} {0}
    set_instance_parameter_value hps_0 {FORCED_NON_LDC_ADDR_CMD_MEM_CK_INVERT} {0}
    set_instance_parameter_value hps_0 {PHY_ONLY} {0}
    set_instance_parameter_value hps_0 {SEQ_MODE} {0}
    set_instance_parameter_value hps_0 {ADVANCED_CK_PHASES} {0}
    set_instance_parameter_value hps_0 {COMMAND_PHASE} {0.0}
    set_instance_parameter_value hps_0 {MEM_CK_PHASE} {0.0}
    set_instance_parameter_value hps_0 {P2C_READ_CLOCK_ADD_PHASE} {0.0}
    set_instance_parameter_value hps_0 {C2P_WRITE_CLOCK_ADD_PHASE} {0.0}
    set_instance_parameter_value hps_0 {ACV_PHY_CLK_ADD_FR_PHASE} {0.0}
    set_instance_parameter_value hps_0 {MEM_VOLTAGE} {1.5V DDR3}
    set_instance_parameter_value hps_0 {PLL_LOCATION} {Top_Bottom}
    set_instance_parameter_value hps_0 {SKIP_MEM_INIT} {1}
    set_instance_parameter_value hps_0 {READ_DQ_DQS_CLOCK_SOURCE} {INVERTED_DQS_BUS}
    set_instance_parameter_value hps_0 {DQ_INPUT_REG_USE_CLKN} {0}
    set_instance_parameter_value hps_0 {DQS_DQSN_MODE} {DIFFERENTIAL}
    set_instance_parameter_value hps_0 {AFI_DEBUG_INFO_WIDTH} {32}
    set_instance_parameter_value hps_0 {CALIBRATION_MODE} {Skip}
    set_instance_parameter_value hps_0 {NIOS_ROM_DATA_WIDTH} {32}
    set_instance_parameter_value hps_0 {READ_FIFO_SIZE} {8}
    set_instance_parameter_value hps_0 {PHY_CSR_ENABLED} {0}
    set_instance_parameter_value hps_0 {PHY_CSR_CONNECTION} {INTERNAL_JTAG}
    set_instance_parameter_value hps_0 {USER_DEBUG_LEVEL} {1}
    set_instance_parameter_value hps_0 {TIMING_BOARD_DERATE_METHOD} {AUTO}
    set_instance_parameter_value hps_0 {TIMING_BOARD_CK_CKN_SLEW_RATE} {2.0}
    set_instance_parameter_value hps_0 {TIMING_BOARD_AC_SLEW_RATE} {1.0}
    set_instance_parameter_value hps_0 {TIMING_BOARD_DQS_DQSN_SLEW_RATE} {2.0}
    set_instance_parameter_value hps_0 {TIMING_BOARD_DQ_SLEW_RATE} {1.0}
    set_instance_parameter_value hps_0 {TIMING_BOARD_TIS} {0.0}
    set_instance_parameter_value hps_0 {TIMING_BOARD_TIH} {0.0}
    set_instance_parameter_value hps_0 {TIMING_BOARD_TDS} {0.0}
    set_instance_parameter_value hps_0 {TIMING_BOARD_TDH} {0.0}
    set_instance_parameter_value hps_0 {TIMING_BOARD_ISI_METHOD} {AUTO}
    set_instance_parameter_value hps_0 {TIMING_BOARD_AC_EYE_REDUCTION_SU} {0.0}
    set_instance_parameter_value hps_0 {TIMING_BOARD_AC_EYE_REDUCTION_H} {0.0}
    set_instance_parameter_value hps_0 {TIMING_BOARD_DQ_EYE_REDUCTION} {0.0}
    set_instance_parameter_value hps_0 {TIMING_BOARD_DELTA_DQS_ARRIVAL_TIME} {0.0}
    set_instance_parameter_value hps_0 {TIMING_BOARD_READ_DQ_EYE_REDUCTION} {0.0}
    set_instance_parameter_value hps_0 {TIMING_BOARD_DELTA_READ_DQS_ARRIVAL_TIME} {0.0}
    set_instance_parameter_value hps_0 {PACKAGE_DESKEW} {0}
    set_instance_parameter_value hps_0 {AC_PACKAGE_DESKEW} {0}
    set_instance_parameter_value hps_0 {TIMING_BOARD_MAX_CK_DELAY} {0.6}
    set_instance_parameter_value hps_0 {TIMING_BOARD_MAX_DQS_DELAY} {0.6}
    set_instance_parameter_value hps_0 {TIMING_BOARD_SKEW_CKDQS_DIMM_MIN} {-0.01}
    set_instance_parameter_value hps_0 {TIMING_BOARD_SKEW_CKDQS_DIMM_MAX} {0.01}
    set_instance_parameter_value hps_0 {TIMING_BOARD_SKEW_BETWEEN_DIMMS} {0.05}
    set_instance_parameter_value hps_0 {TIMING_BOARD_SKEW_WITHIN_DQS} {0.02}
    set_instance_parameter_value hps_0 {TIMING_BOARD_SKEW_BETWEEN_DQS} {0.02}
    set_instance_parameter_value hps_0 {TIMING_BOARD_DQ_TO_DQS_SKEW} {0.0}
    set_instance_parameter_value hps_0 {TIMING_BOARD_AC_SKEW} {0.02}
    set_instance_parameter_value hps_0 {TIMING_BOARD_AC_TO_CK_SKEW} {0.0}
    set_instance_parameter_value hps_0 {RATE} {Full}
    set_instance_parameter_value hps_0 {MEM_CLK_FREQ} {400.0}
    set_instance_parameter_value hps_0 {USE_MEM_CLK_FREQ} {0}
    set_instance_parameter_value hps_0 {FORCE_DQS_TRACKING} {AUTO}
    set_instance_parameter_value hps_0 {FORCE_SHADOW_REGS} {AUTO}
    set_instance_parameter_value hps_0 {MRS_MIRROR_PING_PONG_ATSO} {0}
    set_instance_parameter_value hps_0 {PARSE_FRIENDLY_DEVICE_FAMILY_PARAM_VALID} {0}
    set_instance_parameter_value hps_0 {PARSE_FRIENDLY_DEVICE_FAMILY_PARAM} {}
    set_instance_parameter_value hps_0 {DEVICE_FAMILY_PARAM} {}
    set_instance_parameter_value hps_0 {SPEED_GRADE} {7}
    set_instance_parameter_value hps_0 {IS_ES_DEVICE} {0}
    set_instance_parameter_value hps_0 {DISABLE_CHILD_MESSAGING} {0}
    set_instance_parameter_value hps_0 {HARD_EMIF} {1}
    set_instance_parameter_value hps_0 {HHP_HPS} {1}
    set_instance_parameter_value hps_0 {HHP_HPS_VERIFICATION} {0}
    set_instance_parameter_value hps_0 {HHP_HPS_SIMULATION} {0}
    set_instance_parameter_value hps_0 {HPS_PROTOCOL} {DDR3}
    set_instance_parameter_value hps_0 {CUT_NEW_FAMILY_TIMING} {1}
    set_instance_parameter_value hps_0 {ENABLE_EXPORT_SEQ_DEBUG_BRIDGE} {0}
    set_instance_parameter_value hps_0 {CORE_DEBUG_CONNECTION} {EXPORT}
    set_instance_parameter_value hps_0 {ADD_EXTERNAL_SEQ_DEBUG_NIOS} {0}
    set_instance_parameter_value hps_0 {ED_EXPORT_SEQ_DEBUG} {0}
    set_instance_parameter_value hps_0 {ADD_EFFICIENCY_MONITOR} {0}
    set_instance_parameter_value hps_0 {ENABLE_ABS_RAM_MEM_INIT} {0}
    set_instance_parameter_value hps_0 {ABS_RAM_MEM_INIT_FILENAME} {meminit}
    set_instance_parameter_value hps_0 {DLL_SHARING_MODE} {None}
    set_instance_parameter_value hps_0 {NUM_DLL_SHARING_INTERFACES} {1}
    set_instance_parameter_value hps_0 {OCT_SHARING_MODE} {None}
    set_instance_parameter_value hps_0 {NUM_OCT_SHARING_INTERFACES} {1}
    set_instance_parameter_value hps_0 {show_advanced_parameters} {0}
    set_instance_parameter_value hps_0 {configure_advanced_parameters} {0}
    set_instance_parameter_value hps_0 {customize_device_pll_info} {0}
    set_instance_parameter_value hps_0 {device_pll_info_manual} {{320000000 1600000000} {320000000 1000000000} {800000000 400000000 400000000}}
    set_instance_parameter_value hps_0 {show_debug_info_as_warning_msg} {0}
    set_instance_parameter_value hps_0 {show_warning_as_error_msg} {0}
    set_instance_parameter_value hps_0 {eosc1_clk_mhz} {25.0}
    set_instance_parameter_value hps_0 {eosc2_clk_mhz} {25.0}
    set_instance_parameter_value hps_0 {F2SCLK_SDRAMCLK_Enable} {0}
    set_instance_parameter_value hps_0 {F2SCLK_PERIPHCLK_Enable} {0}
    set_instance_parameter_value hps_0 {periph_pll_source} {0}
    set_instance_parameter_value hps_0 {sdmmc_clk_source} {2}
    set_instance_parameter_value hps_0 {nand_clk_source} {2}
    set_instance_parameter_value hps_0 {qspi_clk_source} {1}
    set_instance_parameter_value hps_0 {l4_mp_clk_source} {1}
    set_instance_parameter_value hps_0 {l4_sp_clk_source} {1}
    set_instance_parameter_value hps_0 {use_default_mpu_clk} {1}
    set_instance_parameter_value hps_0 {desired_mpu_clk_mhz} {800.0}
    set_instance_parameter_value hps_0 {l3_mp_clk_div} {1}
    set_instance_parameter_value hps_0 {l3_sp_clk_div} {1}
    set_instance_parameter_value hps_0 {dbctrl_stayosc1} {1}
    set_instance_parameter_value hps_0 {dbg_at_clk_div} {0}
    set_instance_parameter_value hps_0 {dbg_clk_div} {1}
    set_instance_parameter_value hps_0 {dbg_trace_clk_div} {0}
    set_instance_parameter_value hps_0 {desired_l4_mp_clk_mhz} {100.0}
    set_instance_parameter_value hps_0 {desired_l4_sp_clk_mhz} {100.0}
    set_instance_parameter_value hps_0 {desired_cfg_clk_mhz} {123.333333}
    set_instance_parameter_value hps_0 {desired_sdmmc_clk_mhz} {200.0}
    set_instance_parameter_value hps_0 {desired_nand_clk_mhz} {12.5}
    set_instance_parameter_value hps_0 {desired_qspi_clk_mhz} {370.0}
    set_instance_parameter_value hps_0 {desired_emac0_clk_mhz} {250.0}
    set_instance_parameter_value hps_0 {desired_emac1_clk_mhz} {250.0}
    set_instance_parameter_value hps_0 {desired_usb_mp_clk_mhz} {200.0}
    set_instance_parameter_value hps_0 {desired_spi_m_clk_mhz} {200.0}
    set_instance_parameter_value hps_0 {desired_can0_clk_mhz} {100.0}
    set_instance_parameter_value hps_0 {desired_can1_clk_mhz} {100.0}
    set_instance_parameter_value hps_0 {desired_gpio_db_clk_hz} {32000}
    set_instance_parameter_value hps_0 {S2FCLK_USER0CLK_Enable} {0}
    set_instance_parameter_value hps_0 {S2FCLK_USER1CLK_Enable} {0}
    set_instance_parameter_value hps_0 {S2FCLK_USER2CLK_Enable} {0}
    set_instance_parameter_value hps_0 {S2FCLK_USER1CLK_FREQ} {100.0}
    set_instance_parameter_value hps_0 {S2FCLK_USER2CLK_FREQ} {100.0}
    set_instance_parameter_value hps_0 {main_pll_m} {63}
    set_instance_parameter_value hps_0 {main_pll_n} {0}
    set_instance_parameter_value hps_0 {main_pll_c3} {3}
    set_instance_parameter_value hps_0 {main_pll_c4} {3}
    set_instance_parameter_value hps_0 {main_pll_c5} {15}
    set_instance_parameter_value hps_0 {periph_pll_m} {79}
    set_instance_parameter_value hps_0 {periph_pll_n} {1}
    set_instance_parameter_value hps_0 {periph_pll_c0} {3}
    set_instance_parameter_value hps_0 {periph_pll_c1} {3}
    set_instance_parameter_value hps_0 {periph_pll_c2} {1}
    set_instance_parameter_value hps_0 {periph_pll_c3} {19}
    set_instance_parameter_value hps_0 {periph_pll_c4} {4}
    set_instance_parameter_value hps_0 {periph_pll_c5} {9}
    set_instance_parameter_value hps_0 {usb_mp_clk_div} {0}
    set_instance_parameter_value hps_0 {spi_m_clk_div} {0}
    set_instance_parameter_value hps_0 {can0_clk_div} {1}
    set_instance_parameter_value hps_0 {can1_clk_div} {1}
    set_instance_parameter_value hps_0 {gpio_db_clk_div} {6249}
    set_instance_parameter_value hps_0 {l4_mp_clk_div} {1}
    set_instance_parameter_value hps_0 {l4_sp_clk_div} {1}
    set_instance_parameter_value hps_0 {MPU_EVENTS_Enable} {0}
    set_instance_parameter_value hps_0 {GP_Enable} {0}
    set_instance_parameter_value hps_0 {DEBUGAPB_Enable} {0}
    set_instance_parameter_value hps_0 {STM_Enable} {1}
    set_instance_parameter_value hps_0 {CTI_Enable} {0}
    set_instance_parameter_value hps_0 {TPIUFPGA_Enable} {0}
    set_instance_parameter_value hps_0 {BOOTFROMFPGA_Enable} {0}
    set_instance_parameter_value hps_0 {TEST_Enable} {0}
    set_instance_parameter_value hps_0 {HLGPI_Enable} {0}
    set_instance_parameter_value hps_0 {BSEL_EN} {0}
    set_instance_parameter_value hps_0 {BSEL} {1}
    set_instance_parameter_value hps_0 {CSEL_EN} {0}
    set_instance_parameter_value hps_0 {CSEL} {0}
    set_instance_parameter_value hps_0 {F2S_Width} {2}
    set_instance_parameter_value hps_0 {S2F_Width} {2}
    set_instance_parameter_value hps_0 {LWH2F_Enable} {true}
    set_instance_parameter_value hps_0 {F2SDRAM_Type} {Avalon-MM\ Bidirectional}
    set_instance_parameter_value hps_0 {F2SDRAM_Width} {256}
    set_instance_parameter_value hps_0 {BONDING_OUT_ENABLED} {0}
    set_instance_parameter_value hps_0 {S2FCLK_COLDRST_Enable} {0}
    set_instance_parameter_value hps_0 {S2FCLK_PENDINGRST_Enable} {0}
    set_instance_parameter_value hps_0 {F2SCLK_DBGRST_Enable} {1}
    set_instance_parameter_value hps_0 {F2SCLK_WARMRST_Enable} {1}
    set_instance_parameter_value hps_0 {F2SCLK_COLDRST_Enable} {1}
    set_instance_parameter_value hps_0 {DMA_Enable} {No No No No No No No No}
    set_instance_parameter_value hps_0 {F2SINTERRUPT_Enable} {1}
    set_instance_parameter_value hps_0 {S2FINTERRUPT_CAN_Enable} {0}
    set_instance_parameter_value hps_0 {S2FINTERRUPT_CLOCKPERIPHERAL_Enable} {0}
    set_instance_parameter_value hps_0 {S2FINTERRUPT_CTI_Enable} {0}
    set_instance_parameter_value hps_0 {S2FINTERRUPT_DMA_Enable} {0}
    set_instance_parameter_value hps_0 {S2FINTERRUPT_EMAC_Enable} {0}
    set_instance_parameter_value hps_0 {S2FINTERRUPT_FPGAMANAGER_Enable} {0}
    set_instance_parameter_value hps_0 {S2FINTERRUPT_GPIO_Enable} {0}
    set_instance_parameter_value hps_0 {S2FINTERRUPT_I2CEMAC_Enable} {0}
    set_instance_parameter_value hps_0 {S2FINTERRUPT_I2CPERIPHERAL_Enable} {0}
    set_instance_parameter_value hps_0 {S2FINTERRUPT_L4TIMER_Enable} {0}
    set_instance_parameter_value hps_0 {S2FINTERRUPT_NAND_Enable} {0}
    set_instance_parameter_value hps_0 {S2FINTERRUPT_OSCTIMER_Enable} {0}
    set_instance_parameter_value hps_0 {S2FINTERRUPT_QSPI_Enable} {0}
    set_instance_parameter_value hps_0 {S2FINTERRUPT_SDMMC_Enable} {0}
    set_instance_parameter_value hps_0 {S2FINTERRUPT_SPIMASTER_Enable} {0}
    set_instance_parameter_value hps_0 {S2FINTERRUPT_SPISLAVE_Enable} {0}
    set_instance_parameter_value hps_0 {S2FINTERRUPT_UART_Enable} {0}
    set_instance_parameter_value hps_0 {S2FINTERRUPT_USB_Enable} {0}
    set_instance_parameter_value hps_0 {S2FINTERRUPT_WATCHDOG_Enable} {0}
    set_instance_parameter_value hps_0 {EMAC0_PinMuxing} {Unused}
    set_instance_parameter_value hps_0 {EMAC0_Mode} {N/A}
    set_instance_parameter_value hps_0 {EMAC1_PinMuxing} {HPS I/O Set 0}
    set_instance_parameter_value hps_0 {EMAC1_Mode} {RGMII}
    set_instance_parameter_value hps_0 {NAND_PinMuxing} {Unused}
    set_instance_parameter_value hps_0 {NAND_Mode} {N/A}
    set_instance_parameter_value hps_0 {QSPI_PinMuxing} {HPS I/O Set 0}
    set_instance_parameter_value hps_0 {QSPI_Mode} {1 SS}
    set_instance_parameter_value hps_0 {SDIO_PinMuxing} {HPS I/O Set 0}
    set_instance_parameter_value hps_0 {SDIO_Mode} {4-bit Data}
    set_instance_parameter_value hps_0 {USB0_PinMuxing} {Unused}
    set_instance_parameter_value hps_0 {USB0_Mode} {N/A}
    set_instance_parameter_value hps_0 {USB1_PinMuxing} {HPS I/O Set 0}
    set_instance_parameter_value hps_0 {USB1_Mode} {SDR}
    set_instance_parameter_value hps_0 {SPIM0_PinMuxing} {HPS I/O Set 0}
    set_instance_parameter_value hps_0 {SPIM0_Mode} {Single Slave Select}
    set_instance_parameter_value hps_0 {SPIM1_PinMuxing} {Unused}
    set_instance_parameter_value hps_0 {SPIM1_Mode} {N/A}
    set_instance_parameter_value hps_0 {SPIS0_PinMuxing} {Unused}
    set_instance_parameter_value hps_0 {SPIS0_Mode} {N/A}
    set_instance_parameter_value hps_0 {SPIS1_PinMuxing} {Unused}
    set_instance_parameter_value hps_0 {SPIS1_Mode} {N/A}
    set_instance_parameter_value hps_0 {UART0_PinMuxing} {HPS I/O Set 2}
    set_instance_parameter_value hps_0 {UART0_Mode} {No Flow Control}
    set_instance_parameter_value hps_0 {UART1_PinMuxing} {Unused}
    set_instance_parameter_value hps_0 {UART1_Mode} {N/A}
    set_instance_parameter_value hps_0 {I2C0_PinMuxing} {HPS I/O Set 1}
    set_instance_parameter_value hps_0 {I2C0_Mode} {I2C}
    set_instance_parameter_value hps_0 {I2C1_PinMuxing} {Unused}
    set_instance_parameter_value hps_0 {I2C1_Mode} {N/A}
    set_instance_parameter_value hps_0 {I2C2_PinMuxing} {Unused}
    set_instance_parameter_value hps_0 {I2C2_Mode} {N/A}
    set_instance_parameter_value hps_0 {I2C3_PinMuxing} {Unused}
    set_instance_parameter_value hps_0 {I2C3_Mode} {N/A}
    set_instance_parameter_value hps_0 {CAN0_PinMuxing} {HPS I/O Set 0}
    set_instance_parameter_value hps_0 {CAN0_Mode} {CAN}
    set_instance_parameter_value hps_0 {CAN1_PinMuxing} {Unused}
    set_instance_parameter_value hps_0 {CAN1_Mode} {N/A}
    set_instance_parameter_value hps_0 {TRACE_PinMuxing} {HPS I/O Set 0}
    set_instance_parameter_value hps_0 {TRACE_Mode} {HPS}
    set_instance_parameter_value hps_0 {GPIO_Enable} {No No No No No No No No No Yes No No No No No No No No No No No No No No No No No No No No No No No No No Yes No No No No No Yes Yes Yes Yes No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No}
    set_instance_parameter_value hps_0 {LOANIO_Enable} {No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No No}
    set_instance_parameter_value hps_0 {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_EMAC0_MD_CLK} {100}
    set_instance_parameter_value hps_0 {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_EMAC0_GTX_CLK} {100}
    set_instance_parameter_value hps_0 {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_EMAC1_MD_CLK} {100}
    set_instance_parameter_value hps_0 {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_EMAC1_GTX_CLK} {100}
    set_instance_parameter_value hps_0 {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_QSPI_SCLK_OUT} {100}
    set_instance_parameter_value hps_0 {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_SDIO_CCLK} {100}
    set_instance_parameter_value hps_0 {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_SPIM0_SCLK_OUT} {100}
    set_instance_parameter_value hps_0 {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_SPIM1_SCLK_OUT} {100}
    set_instance_parameter_value hps_0 {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_I2C0_CLK} {100}
    set_instance_parameter_value hps_0 {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_I2C1_CLK} {100}
    set_instance_parameter_value hps_0 {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_I2C2_CLK} {100}
    set_instance_parameter_value hps_0 {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_I2C3_CLK} {100}

    add_instance hps_only_master altera_jtag_avalon_master
    set_instance_parameter_value hps_only_master {USE_PLI} {0}
    set_instance_parameter_value hps_only_master {PLI_PORT} {50000}
    set_instance_parameter_value hps_only_master {FAST_VER} {0}
    set_instance_parameter_value hps_only_master {FIFO_DEPTHS} {2}

    add_instance fpga_only_master altera_jtag_avalon_master
    set_instance_parameter_value fpga_only_master {USE_PLI} {0}
    set_instance_parameter_value fpga_only_master {PLI_PORT} {50000}
    set_instance_parameter_value fpga_only_master {FAST_VER} {0}
    set_instance_parameter_value fpga_only_master {FIFO_DEPTHS} {2}
    if {$fpga_pcie == 0} {
    add_instance f2sdram_only_master altera_jtag_avalon_master
    set_instance_parameter_value f2sdram_only_master {USE_PLI} {0}
    set_instance_parameter_value f2sdram_only_master {PLI_PORT} {50000}
    set_instance_parameter_value f2sdram_only_master {FAST_VER} {0}
    set_instance_parameter_value f2sdram_only_master {FIFO_DEPTHS} {2}
    }
    add_instance mm_bridge_0 altera_avalon_mm_bridge
    set_instance_parameter_value mm_bridge_0 {DATA_WIDTH} {32}
    set_instance_parameter_value mm_bridge_0 {SYMBOL_WIDTH} {8}
    set_instance_parameter_value mm_bridge_0 {ADDRESS_WIDTH} {10}
    set_instance_parameter_value mm_bridge_0 {USE_AUTO_ADDRESS_WIDTH} {1}
    set_instance_parameter_value mm_bridge_0 {ADDRESS_UNITS} {SYMBOLS}
    set_instance_parameter_value mm_bridge_0 {MAX_BURST_SIZE} {1}
    set_instance_parameter_value mm_bridge_0 {MAX_PENDING_RESPONSES} {4}
    set_instance_parameter_value mm_bridge_0 {LINEWRAPBURSTS} {0}
    set_instance_parameter_value mm_bridge_0 {PIPELINE_COMMAND} {1}
    set_instance_parameter_value mm_bridge_0 {PIPELINE_RESPONSE} {1}

    add_instance jtag_uart altera_avalon_jtag_uart
    set_instance_parameter_value jtag_uart {allowMultipleConnections} {1}
    set_instance_parameter_value jtag_uart {hubInstanceID} {0}
    set_instance_parameter_value jtag_uart {readBufferDepth} {64}
    set_instance_parameter_value jtag_uart {readIRQThreshold} {8}
    set_instance_parameter_value jtag_uart {simInputCharacterStream} {}
    set_instance_parameter_value jtag_uart {simInteractiveOptions} {INTERACTIVE_ASCII_OUTPUT}
    set_instance_parameter_value jtag_uart {useRegistersForReadBuffer} {0}
    set_instance_parameter_value jtag_uart {useRegistersForWriteBuffer} {0}
    set_instance_parameter_value jtag_uart {useRelativePathForSimFile} {0}
    set_instance_parameter_value jtag_uart {writeBufferDepth} {64}
    set_instance_parameter_value jtag_uart {writeIRQThreshold} {8}

    add_instance button_pio altera_avalon_pio
    set_instance_parameter_value button_pio {bitClearingEdgeCapReg} {1}
    set_instance_parameter_value button_pio {bitModifyingOutReg} {0}
    set_instance_parameter_value button_pio {captureEdge} {1}
    set_instance_parameter_value button_pio {direction} {Input}
    set_instance_parameter_value button_pio {edgeType} {FALLING}
    set_instance_parameter_value button_pio {generateIRQ} {1}
    set_instance_parameter_value button_pio {irqType} {EDGE}
    set_instance_parameter_value button_pio {resetValue} {0.0}
    set_instance_parameter_value button_pio {simDoTestBenchWiring} {0}
    set_instance_parameter_value button_pio {simDrivenValue} {0.0}
    set_instance_parameter_value button_pio {width} {2}

    add_instance dipsw_pio altera_avalon_pio
    set_instance_parameter_value dipsw_pio {bitClearingEdgeCapReg} {1}
    set_instance_parameter_value dipsw_pio {bitModifyingOutReg} {0}
    set_instance_parameter_value dipsw_pio {captureEdge} {1}
    set_instance_parameter_value dipsw_pio {direction} {Input}
    set_instance_parameter_value dipsw_pio {edgeType} {ANY}
    set_instance_parameter_value dipsw_pio {generateIRQ} {1}
    set_instance_parameter_value dipsw_pio {irqType} {EDGE}
    set_instance_parameter_value dipsw_pio {resetValue} {0.0}
    set_instance_parameter_value dipsw_pio {simDoTestBenchWiring} {0}
    set_instance_parameter_value dipsw_pio {simDrivenValue} {0.0}
    set_instance_parameter_value dipsw_pio {width} {4}

    add_instance led_pio altera_avalon_pio
    set_instance_parameter_value led_pio {bitClearingEdgeCapReg} {0}
    set_instance_parameter_value led_pio {bitModifyingOutReg} {1}
    set_instance_parameter_value led_pio {captureEdge} {0}
    set_instance_parameter_value led_pio {direction} {InOut}
    set_instance_parameter_value led_pio {edgeType} {RISING}
    set_instance_parameter_value led_pio {generateIRQ} {0}
    set_instance_parameter_value led_pio {irqType} {LEVEL}
    set_instance_parameter_value led_pio {resetValue} {0.0}
    set_instance_parameter_value led_pio {simDoTestBenchWiring} {0}
    set_instance_parameter_value led_pio {simDrivenValue} {0.0}
    set_instance_parameter_value led_pio {width} {4}

    add_instance onchip_memory2_0 altera_avalon_onchip_memory2
    set_instance_parameter_value onchip_memory2_0 {allowInSystemMemoryContentEditor} {0}
    set_instance_parameter_value onchip_memory2_0 {blockType} {AUTO}
    if {$fpga_pcie == 1} {
    set_instance_parameter_value onchip_memory2_0 {dataWidth} {64}
    set_instance_parameter_value onchip_memory2_0 {memorySize} {262144.0}
    } else {    
    set_instance_parameter_value onchip_memory2_0 {dataWidth} {8}
    set_instance_parameter_value onchip_memory2_0 {memorySize} {65536.0}
    }
    set_instance_parameter_value onchip_memory2_0 {dualPort} {0}
    set_instance_parameter_value onchip_memory2_0 {initMemContent} {1}
    set_instance_parameter_value onchip_memory2_0 {initializationFileName} {onchip_memory2_0}
    set_instance_parameter_value onchip_memory2_0 {instanceID} {NONE}
    set_instance_parameter_value onchip_memory2_0 {readDuringWriteMode} {DONT_CARE}
    set_instance_parameter_value onchip_memory2_0 {simAllowMRAMContentsFile} {0}
    set_instance_parameter_value onchip_memory2_0 {simMemInitOnlyFilename} {0}
    set_instance_parameter_value onchip_memory2_0 {singleClockOperation} {0}
    set_instance_parameter_value onchip_memory2_0 {slave1Latency} {1}
    set_instance_parameter_value onchip_memory2_0 {slave2Latency} {1}
    set_instance_parameter_value onchip_memory2_0 {useNonDefaultInitFile} {0}
    set_instance_parameter_value onchip_memory2_0 {useShallowMemBlocks} {0}
    set_instance_parameter_value onchip_memory2_0 {writable} {1}
    set_instance_parameter_value onchip_memory2_0 {ecc_enabled} {0}
    set_instance_parameter_value onchip_memory2_0 {resetrequest_enabled} {1}

    add_instance ILC interrupt_latency_counter 
    set_instance_parameter_value ILC {INTR_TYPE} {0}
    set_instance_parameter_value ILC {IRQ_PORT_CNT} {3}

    add_instance clk_0 clock_source
    set_instance_parameter_value clk_0 {clockFrequency} {50000000.0}
    set_instance_parameter_value clk_0 {clockFrequencyKnown} {1}
    set_instance_parameter_value clk_0 {resetSynchronousEdges} {NONE}

    add_instance in_system_sources_probes_0 altera_in_system_sources_probes 
    set_instance_parameter_value in_system_sources_probes_0 {gui_use_auto_index} {1}
    set_instance_parameter_value in_system_sources_probes_0 {sld_instance_index} {0}
    set_instance_parameter_value in_system_sources_probes_0 {instance_id} {RST}
    set_instance_parameter_value in_system_sources_probes_0 {probe_width} {0}
    set_instance_parameter_value in_system_sources_probes_0 {source_width} {3}
    set_instance_parameter_value in_system_sources_probes_0 {source_initial_value} {0}
    set_instance_parameter_value in_system_sources_probes_0 {create_source_clock} {1}
    set_instance_parameter_value in_system_sources_probes_0 {create_source_clock_enable} {0}


    if {$fpga_pcie == 1} {  
    add_instance pcie_0 subsys_pcie
    
    add_instance pio_rp_reset altera_avalon_pio
    set_instance_parameter_value pio_rp_reset {bitClearingEdgeCapReg} {0}
    set_instance_parameter_value pio_rp_reset {bitModifyingOutReg} {0}
    set_instance_parameter_value pio_rp_reset {captureEdge} {0}
    set_instance_parameter_value pio_rp_reset {direction} {InOut}
    set_instance_parameter_value pio_rp_reset {edgeType} {RISING}
    set_instance_parameter_value pio_rp_reset {generateIRQ} {0}
    set_instance_parameter_value pio_rp_reset {irqType} {LEVEL}
    set_instance_parameter_value pio_rp_reset {resetValue} {0.0}
    set_instance_parameter_value pio_rp_reset {simDoTestBenchWiring} {0}
    set_instance_parameter_value pio_rp_reset {simDrivenValue} {0.0}
    set_instance_parameter_value pio_rp_reset {width} {1}
    
    add_connection pcie_0.address_span_extender_0_expanded_master hps_0.f2h_sdram0_data 
    set_connection_parameter_value pcie_0.address_span_extender_0_expanded_master/hps_0.f2h_sdram0_data arbitrationPriority {1}
    set_connection_parameter_value pcie_0.address_span_extender_0_expanded_master/hps_0.f2h_sdram0_data baseAddress {0x0000}
    set_connection_parameter_value pcie_0.address_span_extender_0_expanded_master/hps_0.f2h_sdram0_data defaultConnection {0}

    add_connection hps_0.h2f_axi_master pcie_0.ccb_h2f_s0 
    set_connection_parameter_value hps_0.h2f_axi_master/pcie_0.ccb_h2f_s0 arbitrationPriority {1}
    set_connection_parameter_value hps_0.h2f_axi_master/pcie_0.ccb_h2f_s0 baseAddress {0x10000000}
    set_connection_parameter_value hps_0.h2f_axi_master/pcie_0.ccb_h2f_s0 defaultConnection {0}
    
    add_connection mm_bridge_0.m0 pcie_0.pb_lwh2f_pcie_s0 
    set_connection_parameter_value mm_bridge_0.m0/pcie_0.pb_lwh2f_pcie_s0 arbitrationPriority {1}
    set_connection_parameter_value mm_bridge_0.m0/pcie_0.pb_lwh2f_pcie_s0 baseAddress {0x10000}
    set_connection_parameter_value mm_bridge_0.m0/pcie_0.pb_lwh2f_pcie_s0 defaultConnection {0}

    add_connection mm_bridge_0.m0 pio_rp_reset.s1 
    set_connection_parameter_value mm_bridge_0.m0/pio_rp_reset.s1 arbitrationPriority {1}
    set_connection_parameter_value mm_bridge_0.m0/pio_rp_reset.s1 baseAddress {0x00020140}
    set_connection_parameter_value mm_bridge_0.m0/pio_rp_reset.s1 defaultConnection {0}
    
    add_connection pcie_0.pb_2_ocm_m0 onchip_memory2_0.s1 
    set_connection_parameter_value pcie_0.pb_2_ocm_m0/onchip_memory2_0.s1 arbitrationPriority {1}
    set_connection_parameter_value pcie_0.pb_2_ocm_m0/onchip_memory2_0.s1 baseAddress {0x0000}
    set_connection_parameter_value pcie_0.pb_2_ocm_m0/onchip_memory2_0.s1 defaultConnection {0}
    
    add_connection clk_0.clk pio_rp_reset.clk 

    add_connection clk_0.clk pcie_0.clk 

    add_connection hps_0.f2h_irq0 pcie_0.msgdma_0_csr_irq 
    set_connection_parameter_value hps_0.f2h_irq0/pcie_0.msgdma_0_csr_irq irqNumber {4}

    add_connection hps_0.f2h_irq0 pcie_0.msi_to_gic_gen_0_interrupt_sender 
    set_connection_parameter_value hps_0.f2h_irq0/pcie_0.msi_to_gic_gen_0_interrupt_sender irqNumber {5}

    add_connection hps_0.f2h_irq0 pcie_0.pcie_hip_avmm_cra_irq 
    set_connection_parameter_value hps_0.f2h_irq0/pcie_0.pcie_hip_avmm_cra_irq irqNumber {3}
    
    add_connection clk_0.clk_reset pio_rp_reset.reset 
    
    add_connection clk_0.clk_reset pcie_0.reset 

    add_connection pcie_0.nreset_status_out_reset onchip_memory2_0.reset1 
    }
    
    # connections and connection parameters
    add_connection clk_0.clk in_system_sources_probes_0.source_clk 

    if {$fpga_pcie == 0} {
    add_connection fpga_only_master.master onchip_memory2_0.s1 
    set_connection_parameter_value fpga_only_master.master/onchip_memory2_0.s1 arbitrationPriority {1}
    set_connection_parameter_value fpga_only_master.master/onchip_memory2_0.s1 baseAddress {0x0000}
    set_connection_parameter_value fpga_only_master.master/onchip_memory2_0.s1 defaultConnection {0}
    }
    
    add_connection hps_0.h2f_axi_master onchip_memory2_0.s1 
    set_connection_parameter_value hps_0.h2f_axi_master/onchip_memory2_0.s1 arbitrationPriority {1}
    set_connection_parameter_value hps_0.h2f_axi_master/onchip_memory2_0.s1 baseAddress {0x0000}
    set_connection_parameter_value hps_0.h2f_axi_master/onchip_memory2_0.s1 defaultConnection {0}


    add_connection ILC.irq dipsw_pio.irq 
    set_connection_parameter_value ILC.irq/dipsw_pio.irq irqNumber {0}

    add_connection ILC.irq button_pio.irq 
    set_connection_parameter_value ILC.irq/button_pio.irq irqNumber {1}

    add_connection ILC.irq jtag_uart.irq 
    set_connection_parameter_value ILC.irq/jtag_uart.irq irqNumber {2}

    add_connection hps_0.f2h_irq0 dipsw_pio.irq 
    set_connection_parameter_value hps_0.f2h_irq0/dipsw_pio.irq irqNumber {0}

    add_connection hps_0.f2h_irq0 button_pio.irq 
    set_connection_parameter_value hps_0.f2h_irq0/button_pio.irq irqNumber {1}

    add_connection hps_0.f2h_irq0 jtag_uart.irq 
    set_connection_parameter_value hps_0.f2h_irq0/jtag_uart.irq irqNumber {2}

    add_connection clk_0.clk ILC.clk 

    add_connection clk_0.clk fpga_only_master.clk 

    add_connection clk_0.clk jtag_uart.clk 

    add_connection clk_0.clk button_pio.clk 

    add_connection clk_0.clk dipsw_pio.clk 

    add_connection clk_0.clk led_pio.clk 

    add_connection clk_0.clk sysid_qsys.clk 

    add_connection clk_0.clk hps_0.h2f_lw_axi_clock 

    add_connection clk_0.clk hps_0.f2h_axi_clock 

    add_connection mm_bridge_0.m0 ILC.avalon_slave 
    set_connection_parameter_value mm_bridge_0.m0/ILC.avalon_slave arbitrationPriority {1}
    set_connection_parameter_value mm_bridge_0.m0/ILC.avalon_slave baseAddress {0x00030000}
    set_connection_parameter_value mm_bridge_0.m0/ILC.avalon_slave defaultConnection {0}

    add_connection clk_0.clk hps_only_master.clk 

    add_connection hps_only_master.master hps_0.f2h_axi_slave 
    set_connection_parameter_value hps_only_master.master/hps_0.f2h_axi_slave arbitrationPriority {1}
    set_connection_parameter_value hps_only_master.master/hps_0.f2h_axi_slave baseAddress {0x0000}
    set_connection_parameter_value hps_only_master.master/hps_0.f2h_axi_slave defaultConnection {0}

    if {$fpga_pcie == 1} {
    add_connection pcie_0.coreclkout_out onchip_memory2_0.clk1 

    add_connection pcie_0.coreclkout_out hps_0.f2h_sdram0_clock 
    } else {
    add_connection clk_0.clk hps_0.f2h_sdram0_clock 

    add_connection clk_0.clk onchip_memory2_0.clk1 
    }
    
    add_connection clk_0.clk hps_0.h2f_axi_clock 

    add_connection clk_0.clk_reset ILC.reset_n 

    add_connection clk_0.clk_reset fpga_only_master.clk_reset 

    add_connection clk_0.clk_reset jtag_uart.reset 

    add_connection clk_0.clk_reset button_pio.reset 

    add_connection clk_0.clk_reset dipsw_pio.reset 

    add_connection clk_0.clk_reset led_pio.reset 

    add_connection clk_0.clk_reset sysid_qsys.reset 

    add_connection clk_0.clk_reset hps_only_master.clk_reset 

    add_connection clk_0.clk_reset onchip_memory2_0.reset1 

    if {$fpga_pcie == 0} {
    add_connection clk_0.clk f2sdram_only_master.clk 

    add_connection clk_0.clk_reset f2sdram_only_master.clk_reset 

    add_connection f2sdram_only_master.master hps_0.f2h_sdram0_data 
    set_connection_parameter_value f2sdram_only_master.master/hps_0.f2h_sdram0_data arbitrationPriority {1}
    set_connection_parameter_value f2sdram_only_master.master/hps_0.f2h_sdram0_data baseAddress {0x0000}
    set_connection_parameter_value f2sdram_only_master.master/hps_0.f2h_sdram0_data defaultConnection {0}
    }
    
    add_connection clk_0.clk mm_bridge_0.clk 

    add_connection clk_0.clk_reset mm_bridge_0.reset 

    add_connection mm_bridge_0.m0 sysid_qsys.control_slave 
    set_connection_parameter_value mm_bridge_0.m0/sysid_qsys.control_slave arbitrationPriority {1}
    set_connection_parameter_value mm_bridge_0.m0/sysid_qsys.control_slave baseAddress {0x00020008}
    set_connection_parameter_value mm_bridge_0.m0/sysid_qsys.control_slave defaultConnection {0}

    add_connection mm_bridge_0.m0 jtag_uart.avalon_jtag_slave 
    set_connection_parameter_value mm_bridge_0.m0/jtag_uart.avalon_jtag_slave arbitrationPriority {1}
    set_connection_parameter_value mm_bridge_0.m0/jtag_uart.avalon_jtag_slave baseAddress {0x00020000}
    set_connection_parameter_value mm_bridge_0.m0/jtag_uart.avalon_jtag_slave defaultConnection {0}

    add_connection mm_bridge_0.m0 button_pio.s1 
    set_connection_parameter_value mm_bridge_0.m0/button_pio.s1 arbitrationPriority {1}
    set_connection_parameter_value mm_bridge_0.m0/button_pio.s1 baseAddress {0x000200c0}
    set_connection_parameter_value mm_bridge_0.m0/button_pio.s1 defaultConnection {0}

    add_connection mm_bridge_0.m0 dipsw_pio.s1 
    set_connection_parameter_value mm_bridge_0.m0/dipsw_pio.s1 arbitrationPriority {1}
    set_connection_parameter_value mm_bridge_0.m0/dipsw_pio.s1 baseAddress {0x00020080}
    set_connection_parameter_value mm_bridge_0.m0/dipsw_pio.s1 defaultConnection {0}

    add_connection mm_bridge_0.m0 led_pio.s1 
    set_connection_parameter_value mm_bridge_0.m0/led_pio.s1 arbitrationPriority {1}
    set_connection_parameter_value mm_bridge_0.m0/led_pio.s1 baseAddress {0x00020040}
    set_connection_parameter_value mm_bridge_0.m0/led_pio.s1 defaultConnection {0}

    add_connection hps_0.h2f_lw_axi_master mm_bridge_0.s0 
    set_connection_parameter_value hps_0.h2f_lw_axi_master/mm_bridge_0.s0 arbitrationPriority {1}
    if {$fpga_pcie == 1} {
    set_connection_parameter_value hps_0.h2f_lw_axi_master/mm_bridge_0.s0 baseAddress {0x0000}
    } else {
    set_connection_parameter_value hps_0.h2f_lw_axi_master/mm_bridge_0.s0 baseAddress {0x40000}
    }
    set_connection_parameter_value hps_0.h2f_lw_axi_master/mm_bridge_0.s0 defaultConnection {0}
    
    add_connection fpga_only_master.master mm_bridge_0.s0 
    set_connection_parameter_value fpga_only_master.master/mm_bridge_0.s0 arbitrationPriority {1}
    if {$fpga_pcie == 1} {
    set_connection_parameter_value fpga_only_master.master/mm_bridge_0.s0 baseAddress {0x0000}
    } else {
    set_connection_parameter_value fpga_only_master.master/mm_bridge_0.s0 baseAddress {0x40000}
    }
    set_connection_parameter_value fpga_only_master.master/mm_bridge_0.s0 defaultConnection {0}


    # exported interfaces
    add_interface issp_hps_resets conduit end
    set_interface_property issp_hps_resets EXPORT_OF in_system_sources_probes_0.sources

    if {$fpga_pcie == 1} {
    add_interface alt_xcvr_reconfig_0_reconfig_mgmt avalon slave
    set_interface_property alt_xcvr_reconfig_0_reconfig_mgmt EXPORT_OF pcie_0.alt_xcvr_reconfig_0_reconfig_mgmt 
    add_interface coreclk_fanout_clk clock source
    set_interface_property coreclk_fanout_clk EXPORT_OF pcie_0.coreclk_fanout_clk
    add_interface coreclk_fanout_clk_reset reset source
    set_interface_property coreclk_fanout_clk_reset EXPORT_OF pcie_0.coreclk_fanout_clk_reset
    add_interface pcie_hip_avmm_hip_ctrl conduit end
    set_interface_property pcie_hip_avmm_hip_ctrl EXPORT_OF pcie_0.pcie_hip_avmm_hip_ctrl
    add_interface pcie_hip_avmm_hip_pipe conduit end
    set_interface_property pcie_hip_avmm_hip_pipe EXPORT_OF pcie_0.pcie_hip_avmm_hip_pipe
    add_interface pcie_hip_avmm_hip_serial conduit end
    set_interface_property pcie_hip_avmm_hip_serial EXPORT_OF pcie_0.pcie_hip_avmm_hip_serial
    add_interface pcie_hip_avmm_npor conduit end
    set_interface_property pcie_hip_avmm_npor EXPORT_OF pcie_0.pcie_hip_avmm_npor
    add_interface pcie_hip_avmm_reconfig_clk_locked conduit end
    set_interface_property pcie_hip_avmm_reconfig_clk_locked EXPORT_OF pcie_0.pcie_hip_avmm_reconfig_clk_locked
    add_interface pcie_hip_avmm_refclk clock sink
    set_interface_property pcie_hip_avmm_refclk EXPORT_OF pcie_0.pcie_hip_avmm_refclk
    add_interface pio_rp_reset_external_connection conduit end
    set_interface_property pio_rp_reset_external_connection EXPORT_OF pio_rp_reset.external_connection  
    }
    add_interface memory conduit end
    set_interface_property memory EXPORT_OF hps_0.memory
    add_interface clk clock sink
    set_interface_property clk EXPORT_OF clk_0.clk_in
    add_interface reset reset sink
    set_interface_property reset EXPORT_OF clk_0.clk_in_reset
    add_interface hps_0_hps_io conduit end
    set_interface_property hps_0_hps_io EXPORT_OF hps_0.hps_io
    add_interface hps_0_f2h_stm_hw_events conduit end
    set_interface_property hps_0_f2h_stm_hw_events EXPORT_OF hps_0.f2h_stm_hw_events
    add_interface led_pio_external_connection conduit end
    set_interface_property led_pio_external_connection EXPORT_OF led_pio.external_connection
    add_interface dipsw_pio_external_connection conduit end
    set_interface_property dipsw_pio_external_connection EXPORT_OF dipsw_pio.external_connection
    add_interface button_pio_external_connection conduit end
    set_interface_property button_pio_external_connection EXPORT_OF button_pio.external_connection
    add_interface hps_0_h2f_reset reset source
    set_interface_property hps_0_h2f_reset EXPORT_OF hps_0.h2f_reset
    add_interface hps_0_f2h_cold_reset_req reset sink
    set_interface_property hps_0_f2h_cold_reset_req EXPORT_OF hps_0.f2h_cold_reset_req
    add_interface hps_0_f2h_debug_reset_req reset sink
    set_interface_property hps_0_f2h_debug_reset_req EXPORT_OF hps_0.f2h_debug_reset_req
    add_interface hps_0_f2h_warm_reset_req reset sink
    set_interface_property hps_0_f2h_warm_reset_req EXPORT_OF hps_0.f2h_warm_reset_req

    # interconnect requirements
    set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {AUTO}
    set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {4}
    set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
    set_interconnect_requirement {hps_only_master.master} {qsys_mm.security} {SECURE}
    
  save_system ${qsys_name}.qsys
