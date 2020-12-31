#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2020 Intel Corporation.
#
#****************************************************************************
#
# This script generate all the required IPs for 10GbE 1588 design
# Example command to execute this script file
#   qsys-script --script=construct_ip_alt_mge_10gbe_1588.tcl
#
#****************************************************************************


source ./arguments_solver.tcl
source ./utils.tcl
  
package require -exact qsys 18.1

set subsys_name ip_alt_mge_10gbe_1588
create_system $subsys_name

set_project_property DEVICE_FAMILY $device_family
set_project_property DEVICE $device
set_validation_property AUTOMATIC_VALIDATION false

add_component_param "alt_em10g32 alt_mgbaset_mac
                     IP_FILE_PATH ip/$subsys_name/alt_mgbaset_mac.ip
                     {ANLG_VOLTAGE} {1_0V}
                     {DATAPATH_OPTION} {3}
                     {ENABLE_1G10G_MAC} {4}
                     {ENABLE_PTP_1STEP} {0}
                     {ENABLE_SUPP_ADDR} {1}
                     {ENABLE_TIMESTAMPING} {1}
                     {ENABLE_TXRX_DATAPATH} {1}
                     {ENABLE_UNIDIRECTIONAL} {0}
                     {INSERT_CSR_ADAPTOR} {0}
                     {INSERT_ST_ADAPTOR} {1}
                     {INSERT_XGMII_ADAPTOR} {1}
                     {INSTANTIATE_STATISTICS} {1}
                     {TIME_OF_DAY_FORMAT} {0}
                     {TSTAMP_FP_WIDTH} {8}"

add_component_param "alt_mge_phy alt_mgbaset_phy
                     IP_FILE_PATH ip/$subsys_name/alt_mgbaset_phy.ip
                     {ANALOG_VOLTAGE} {1_0V}
                     {DEFAULT_MODE} {3}
                     {ENABLE_IEEE1588} {1}
                     {EXCLUDE_NATIVE_PHY} {0}
                     {EXT_PHY_MGBASET} {1}
                     {EXT_PHY_NBASET} {0}
                     {REFCLK_FREQ_BASER} {0}
                     {SPEED_VARIANT} {4}
                     XCVR_RCFG_JTAG_ENABLE {0}"

add_component_param "altera_xcvr_reset_control_s10 alt_mge_xcvr_reset_ctrl_channel
                     IP_FILE_PATH ip/$subsys_name/alt_mge_xcvr_reset_ctrl_channel.ip
                     {CHANNELS} {1}
                     {ENABLE_DIGITAL_SEQ} {0}
                     {PLLS} {3}
                     {REDUCED_SIM_TIME} {1}
                     {RX_ENABLE} {1}
                     {RX_MANUAL_RESET} {0}
                     {RX_PER_CHANNEL} {0}
                     {SYS_CLK_IN_MHZ} {125}
                     {TILE_TYPE} {h_tile}
                     {TX_ENABLE} {1}
                     {TX_MANUAL_RESET} {0}
                     {TX_PER_CHANNEL} {0}
                     {TX_PLL_ENABLE} {0}
                     {T_PLL_LOCK_HYST} {0}
                     {T_PLL_POWERDOWN} {1000}
                     {T_RX_ANALOGRESET} {70000}
                     {T_RX_DIGITALRESET} {5000}
                     {T_TX_ANALOGRESET} {70000}
                     {T_TX_DIGITALRESET} {70000}
                     {gui_pll_cal_busy} {0}"

add_component_param "altera_eth_1588_tod alt_mge_1588_tod_10g
                     IP_FILE_PATH ip/$subsys_name/alt_mge_1588_tod_10g.ip
                     {DEFAULT_FNSEC_ADJPERIOD} {13107}
                     {DEFAULT_FNSEC_PERIOD} {13107}
                     {DEFAULT_NSEC_ADJPERIOD} {3}
                     {DEFAULT_NSEC_PERIOD} {3}
                     {OFFSET_JITTER_WANDER_EN} {0}
                     {PERIOD_CLOCK_FREQUENCY} {1}"
                      
add_component_param "altera_eth_1588_tod alt_mge_1588_tod_1g
                     IP_FILE_PATH ip/$subsys_name/alt_mge_1588_tod_1g.ip
                     {DEFAULT_FNSEC_ADJPERIOD} {65535}
                     {DEFAULT_FNSEC_PERIOD} {65535}
                     {DEFAULT_NSEC_ADJPERIOD} {15}
                     {DEFAULT_NSEC_PERIOD} {15}
                     {OFFSET_JITTER_WANDER_EN} {0}
                     {PERIOD_CLOCK_FREQUENCY} {1}"

add_component_param "altera_eth_1588_tod alt_mge_1588_tod_2p5g
                     IP_FILE_PATH ip/$subsys_name/alt_mge_1588_tod_2p5g.ip
                     {DEFAULT_FNSEC_ADJPERIOD} {26214}
                     {DEFAULT_FNSEC_PERIOD} {26214}
                     {DEFAULT_NSEC_ADJPERIOD} {6}
                     {DEFAULT_NSEC_PERIOD} {6}
                     {OFFSET_JITTER_WANDER_EN} {0}
                     {PERIOD_CLOCK_FREQUENCY} {1}"
   
add_component_param "altera_eth_1588_tod alt_mge_1588_tod_master
                     IP_FILE_PATH ip/$subsys_name/alt_mge_1588_tod_master.ip
                     {DEFAULT_FNSEC_ADJPERIOD} {0}
                     {DEFAULT_FNSEC_PERIOD} {0}
                     {DEFAULT_NSEC_ADJPERIOD} {8}
                     {DEFAULT_NSEC_PERIOD} {8}
                     {OFFSET_JITTER_WANDER_EN} {0}
                     {PERIOD_CLOCK_FREQUENCY} {1}"
   
add_component_param "altera_eth_1588_tod_synchronizer alt_mge_1588_tod_sync_96b_10g
                     IP_FILE_PATH ip/$subsys_name/alt_mge_1588_tod_sync_96b_10g.ip
                     {PERIOD_FNSEC} {26214}
                     {PERIOD_NSEC} {6}
                     {SAMPLE_SIZE} {64}
                     {SYNC_MODE} {5}
                     {TOD_MODE} {1}"
   
add_component_param "altera_eth_1588_tod_synchronizer alt_mge_1588_tod_sync_96b_1g
                     IP_FILE_PATH ip/$subsys_name/alt_mge_1588_tod_sync_96b_1g.ip
                     {PERIOD_FNSEC} {26214}
                     {PERIOD_NSEC} {6}
                     {SAMPLE_SIZE} {64}
                     {SYNC_MODE} {13}
                     {TOD_MODE} {1}"

add_component_param "altera_eth_1588_tod_synchronizer alt_mge_1588_tod_sync_96b_2p5g
                     IP_FILE_PATH ip/$subsys_name/alt_mge_1588_tod_sync_96b_2p5g.ip
                     {PERIOD_FNSEC} {26214}
                     {PERIOD_NSEC} {6}
                     {SAMPLE_SIZE} {64}
                     {SYNC_MODE} {0}
                     {TOD_MODE} {1}"
   
add_component_param "altera_xcvr_fpll_s10_htile alt_mge_core_pll
                     IP_FILE_PATH ip/$subsys_name/alt_mge_core_pll.ip
                     {base_device} {cr2v0}
                     {enable_manual_configuration} {1}
                     {enable_pld_fpll_cal_busy_port} {1}
                     {message_level} {error}
                     {select_manual_config} {0}
                     {set_auto_reference_clock_frequency} {644.53125}
                     {set_bw_sel} {low}
                     {set_output_clock_frequency} {312.5}
                     {set_power_mode} {1_0V}
                     {set_primary_use} {0}
                     {set_refclk_cnt} {1}
                     {set_refclk_index} {0}
                     {set_x1_core_clock} {1}
                     {set_x2_core_clock} {1}
                     {set_x4_core_clock} {0}
                     {support_mode} {user_mode}"
   
add_component_param "altera_xcvr_atx_pll_s10_htile alt_mge_xcvr_atx_pll_2p5g
                     IP_FILE_PATH ip/$subsys_name/alt_mge_xcvr_atx_pll_2p5g.ip
                     {base_device} {cr2v0}
                     {bw_sel} {medium}
                     {enable_8G_path} {1}
                     {enable_GXT_clock_source} {disabled}
                     {enable_hfreq_clk} {1}
                     {enable_hip_cal_done_port} {0}
                     {enable_manual_configuration} {1}
                     {enable_mcgb} {1}
                     {enable_pld_atx_cal_busy_port} {1}
                     {enable_pld_mcgb_cal_busy_port} {0}
                     {enable_pll_lock} {1}
                     {enable_vco_bypass} {0}
                     {mcgb_div} {1}
                     {message_level} {error}
                     {primary_pll_buffer} {GX clock output buffer}
                     {prot_mode} {Basic}
                     {refclk_cnt} {1}
                     {refclk_index} {0}
                     {set_altera_xcvr_atx_pll_s10_calibration_en} {1}
                     {set_auto_reference_clock_frequency} {125.0}
                     {set_fref_clock_frequency} {156.25}
                     {set_hip_cal_en} {0}
                     {set_output_clock_frequency} {1562.5}
                     {set_ref_clk_div} {1}
                     {support_mode} {user_mode}
                     {usr_analog_voltage} {1_0V}"
   
add_component_param "altera_xcvr_atx_pll_s10_htile alt_mge_xcvr_atx_pll_10g
                     IP_FILE_PATH ip/$subsys_name/alt_mge_xcvr_atx_pll_10g.ip
                     {base_device} {cr2v0}
                     {bw_sel} {medium}
                     {enable_8G_path} {1}
                     {enable_GXT_clock_source} {disabled}
                     {enable_hfreq_clk} {1}
                     {enable_hip_cal_done_port} {0}
                     {enable_manual_configuration} {1}
                     {enable_mcgb} {1}
                     {enable_pld_atx_cal_busy_port} {1}
                     {enable_pld_mcgb_cal_busy_port} {0}
                     {enable_pll_lock} {1}
                     {enable_vco_bypass} {0}
                     {mcgb_div} {1}
                     {message_level} {error}
                     {primary_pll_buffer} {GX clock output buffer}
                     {prot_mode} {Basic}
                     {refclk_cnt} {1}
                     {refclk_index} {0}
                     {set_altera_xcvr_atx_pll_s10_calibration_en} {1}
                     {set_auto_reference_clock_frequency} {644.53125}
                     {set_fref_clock_frequency} {156.25}
                     {set_hip_cal_en} {0}
                     {set_output_clock_frequency} {5156.25}
                     {set_rcfg_emb_strm_enable} {0}
                     {set_ref_clk_div} {1}
                     {support_mode} {user_mode}
                     {usr_analog_voltage} {1_0V}"
   
add_component_param "altera_xcvr_fpll_s10_htile alt_mge_xcvr_fpll_1g
                     IP_FILE_PATH ip/$subsys_name/alt_mge_xcvr_fpll_1g.ip
                     {base_device} {cr2v0}
                     {enable_hfreq_clk} {1}
                     {enable_manual_configuration} {1}
                     {enable_mcgb} {1}
                     {enable_pld_fpll_cal_busy_port} {1}
                     {message_level} {error}
                     {select_manual_config} {0}
                     {set_auto_reference_clock_frequency} {125.0}
                     {set_bw_sel} {low}
                     {set_output_clock_frequency} {625.0}
                     {set_power_mode} {1_0V}
                     {set_x1_core_clock} {1}
                     {set_x2_core_clock} {0}
                     {set_x4_core_clock} {0}
                     {support_mode} {user_mode}"
   
   
add_component_param "altera_xcvr_fpll_s10_htile pll_sampling_clk
                     IP_FILE_PATH ip/$subsys_name/pll_sampling_clk.ip
                     {enable_hfreq_clk} {0}
                     {enable_manual_configuration} {1}
                     {enable_mcgb} {0}
                     {enable_pld_fpll_cal_busy_port} {1}
                     {message_level} {error}
                     {select_manual_config} {0}
                     {set_altera_xcvr_fpll_s10_calibration_en} {1}
                     {set_auto_reference_clock_frequency} {100.0}
                     {set_bw_sel} {medium}
                     {set_enable_fractional} {0}
                     {set_fref_clock_frequency} {125.0}
                     {set_hip_cal_en} {0}
                     {set_output_clock_frequency} {153.8461538462}
                     {set_power_mode} {1_0V}
                     {set_primary_use} {0}
                     {set_x1_core_clock} {1}
                     {set_x2_core_clock} {0}
                     {set_x4_core_clock} {0}
                     {support_mode} {user_mode}"
   
add_component_param "altera_xcvr_fpll_s10_htile pll_tod_sync_sampling_clock
                     IP_FILE_PATH ip/$subsys_name/pll_tod_sync_sampling_clock.ip
                     {enable_hfreq_clk} {0}
                     {enable_manual_configuration} {1}
                     {enable_mcgb} {0}
                     {enable_pld_fpll_cal_busy_port} {1}
                     {message_level} {error}
                     {select_manual_config} {0}
                     {set_altera_xcvr_fpll_s10_calibration_en} {1}
                     {set_auto_reference_clock_frequency} {100.0}
                     {set_bw_sel} {medium}
                     {set_enable_fractional} {0}
                     {set_fref_clock_frequency} {125.0}
                     {set_hip_cal_en} {0}
                     {set_output_clock_frequency} {80.0}
                     {set_power_mode} {1_0V}
                     {set_primary_use} {0}
                     {set_x1_core_clock} {1}
                     {set_x2_core_clock} {0}
                     {set_x4_core_clock} {0}
                     {support_mode} {user_mode}"

sync_sysinfo_parameters 
    
#save_system ${subsys_name}.qsys
