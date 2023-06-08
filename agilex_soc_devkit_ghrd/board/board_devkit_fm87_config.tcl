#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2022 Intel Corporation.
#
#****************************************************************************
#
# This script hosts board requirements and Quartus settings for the Agilex SoC Devkit board.
#
#****************************************************************************

## Indicate the Pins Availablility for boards
#  Set available if there is
#  Peripheral pins (LEDs, DIPSW, Push Button)
set isPeriph_pins_available 1
set isSgpio_pins_available  1
set isPCIE_pins_available 1
set isETILE_pins_available 1

## Set IO Widths
set fpga_led_pio_width 8
set fpga_dipsw_pio_width 8
set fpga_button_pio_width 2

#devkit uses the DDR4 HiLo based on x16 components. By JEDEC spec, DDR4 x16 components doesn't requires emif_hps_mem_mem_bg[1]
set hps_emif_bank_gp_default_width 1

# Quartus settings for miscellaneous
proc config_misc {} {
    #global hps_etile_1588_en
    #if {$hps_etile_1588_en == 0} {
        #HSDES 1507845020. Additional refclk_bti to preserve Etile XCVR
    #    set_location_assignment PIN_AT13 -to refclk_bti
    #    set_instance_assignment -name HSSI_PARAMETER "refclk_divider_use_as_BTI_clock=TRUE" -to refclk_bti
    #    set_instance_assignment -name HSSI_PARAMETER  "refclk_divider_input_freq=156250000" -to refclk_bti
    #} else {
    #    set_global_assignment -name BLOCK_RAM_TO_MLAB_CELL_CONVERSION OFF

    #    set_location_assignment PIN_AK13 -to refclk_bti
    #    set_instance_assignment -name HSSI_PARAMETER "refclk_divider_use_as_BTI_clock=TRUE" -to refclk_bti
    #    set_instance_assignment -name HSSI_PARAMETER  "refclk_divider_input_freq=125000000" -to refclk_bti

    #    set_instance_assignment -name HSSI_PARAMETER "refclk_divider_enable_termination=disable_term" -to etile_clk_ref
    #    set_instance_assignment -name HSSI_PARAMETER "refclk_divider_enable_3p3v=disable_3p3v_tol" -to etile_clk_ref
    #    set_instance_assignment -name HSSI_PARAMETER "refclk_divider_enable_hysteresis=disable_hyst" -to etile_clk_ref
    #    set_instance_assignment -name HSSI_PARAMETER "refclk_divider_powerdown_mode=false" -to etile_clk_ref

    #    set_location_assignment PIN_AK13 -to refclk_bti
    #    set_instance_assignment -name HSSI_PARAMETER "refclk_divider_use_as_BTI_clock=TRUE" -to refclk_bti
    #    set_instance_assignment -name HSSI_PARAMETER "refclk_divider_input_freq=125000000" -to refclk_bti


        ## Logic Lock Region Assignments
        ## =============================
     #   set_instance_assignment -name PLACE_REGION "X330 Y24 X330 Y24" -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|rx_ptp_sn_wire_delay|sn_clb_pulse|o_roll_over_trig
     #   set_instance_assignment -name RESERVE_PLACE_REGION OFF -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|rx_ptp_sn_wire_delay|sn_clb_pulse|o_roll_over_trig
     #   set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|rx_ptp_sn_wire_delay|sn_clb_pulse|o_roll_over_trig
     #   set_instance_assignment -name REGION_NAME o_roll_over_trig_rxw_ch0_0 -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|rx_ptp_sn_wire_delay|sn_clb_pulse|o_roll_over_trig


     #  set_instance_assignment -name PLACE_REGION "X331 Y24 X331 Y24" -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|tx_ptp_sn_wire_delay|sn_clb_pulse|o_roll_over_trig
     #   set_instance_assignment -name RESERVE_PLACE_REGION OFF -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|tx_ptp_sn_wire_delay|sn_clb_pulse|o_roll_over_trig
     #   set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|tx_ptp_sn_wire_delay|sn_clb_pulse|o_roll_over_trig
     #   set_instance_assignment -name REGION_NAME o_roll_over_trig_txw_ch0_0 -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|tx_ptp_sn_wire_delay|sn_clb_pulse|o_roll_over_trig
     #   set_instance_assignment -name PLACE_REGION "X326 Y29 X326 Y29" -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|in_tx_roll_over_trig
     #   set_instance_assignment -name RESERVE_PLACE_REGION OFF -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|in_tx_roll_over_trig
     #   set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|in_tx_roll_over_trig
     #   set_instance_assignment -name REGION_NAME tx_rollover_trig_ch0_0 -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|in_tx_roll_over_trig
     #   set_instance_assignment -name PLACE_REGION "X326 Y28 X326 Y28" -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|in_rx_roll_over_trig
     #   set_instance_assignment -name RESERVE_PLACE_REGION OFF -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|in_rx_roll_over_trig
     #   set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|in_rx_roll_over_trig
     #   set_instance_assignment -name REGION_NAME rx_rollover_trig_ch0_0 -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|in_rx_roll_over_trig
     #   set_instance_assignment -name PLACE_REGION "X326 Y25 X326 Y25" -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|tx_async_2ds|async_2ds|resync_chains[0].synchronizer_nocut|din_s1
     #   set_instance_assignment -name RESERVE_PLACE_REGION OFF -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|tx_async_2ds|async_2ds|resync_chains[0].synchronizer_nocut|din_s1
     #   set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|tx_async_2ds|async_2ds|resync_chains[0].synchronizer_nocut|din_s1
     #   set_instance_assignment -name REGION_NAME tx_rollover_async_ch0_0 -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|tx_async_2ds|async_2ds|resync_chains[0].synchronizer_nocut|din_s1
     #   set_instance_assignment -name PLACE_REGION "X326 Y24 X326 Y24" -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|rx_async_2ds|async_2ds|resync_chains[0].synchronizer_nocut|din_s1
     #   set_instance_assignment -name RESERVE_PLACE_REGION OFF -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|rx_async_2ds|async_2ds|resync_chains[0].synchronizer_nocut|din_s1
     #   set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|rx_async_2ds|async_2ds|resync_chains[0].synchronizer_nocut|din_s1
     #   set_instance_assignment -name REGION_NAME rx_rollover_async_ch0_0 -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|rx_async_2ds|async_2ds|resync_chains[0].synchronizer_nocut|din_s1
     #   set_instance_assignment -name PLACE_REGION "X328 Y26 X328 Y26" -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|tx_async_phz_2ds|async_2ds|resync_chains[0].synchronizer_nocut|din_s1
     #   set_instance_assignment -name RESERVE_PLACE_REGION OFF -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|tx_async_phz_2ds|async_2ds|resync_chains[0].synchronizer_nocut|din_s1
     #   set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|tx_async_phz_2ds|async_2ds|resync_chains[0].synchronizer_nocut|din_s1
     #   set_instance_assignment -name REGION_NAME tx_async_phz_ch0_0 -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|tx_async_phz_2ds|async_2ds|resync_chains[0].synchronizer_nocut|din_s1
     #   set_instance_assignment -name PLACE_REGION "X330 Y26 X330 Y26" -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|tx_roll_over_phz_2ds|async_2ds|resync_chains[0].synchronizer_nocut|din_s1
     #   set_instance_assignment -name RESERVE_PLACE_REGION OFF -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|tx_roll_over_phz_2ds|async_2ds|resync_chains[0].synchronizer_nocut|din_s1
     #   set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|tx_roll_over_phz_2ds|async_2ds|resync_chains[0].synchronizer_nocut|din_s1
     #   set_instance_assignment -name REGION_NAME tx_rollover_phz_ch0_0 -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|tx_roll_over_phz_2ds|async_2ds|resync_chains[0].synchronizer_nocut|din_s1
     #   set_instance_assignment -name PLACE_REGION "X328 Y25 X328 Y25" -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|rx_async_phz_2ds|async_2ds|resync_chains[0].synchronizer_nocut|din_s1
     #   set_instance_assignment -name RESERVE_PLACE_REGION OFF -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|rx_async_phz_2ds|async_2ds|resync_chains[0].synchronizer_nocut|din_s1
     #   set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|rx_async_phz_2ds|async_2ds|resync_chains[0].synchronizer_nocut|din_s1
     #   set_instance_assignment -name REGION_NAME rx_async_phz_ch0_0 -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|rx_async_phz_2ds|async_2ds|resync_chains[0].synchronizer_nocut|din_s1
     #   set_instance_assignment -name PLACE_REGION "X330 Y25 X330 Y25" -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|rx_roll_over_phz_2ds|async_2ds|resync_chains[0].synchronizer_nocut|din_s1
     #   set_instance_assignment -name RESERVE_PLACE_REGION OFF -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|rx_roll_over_phz_2ds|async_2ds|resync_chains[0].synchronizer_nocut|din_s1
     #   set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|rx_roll_over_phz_2ds|async_2ds|resync_chains[0].synchronizer_nocut|din_s1
     #   set_instance_assignment -name REGION_NAME rx_rollover_phz_ch0_0 -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|rx_roll_over_phz_2ds|async_2ds|resync_chains[0].synchronizer_nocut|din_s1

     #   set_instance_assignment -name PARTITION_COLOUR 4294049704 -to ghrd_agilex_top
     #   set_instance_assignment -name PARTITION_COLOUR 4282496767 -to auto_fab_0
     #   set_instance_assignment -name PLACE_REGION "X261 Y5 X331 Y41" -to soc_inst|etile_25gbe_1588|etile_hip
     #   set_instance_assignment -name RESERVE_PLACE_REGION OFF -to soc_inst|etile_25gbe_1588|etile_hip
     #   set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to soc_inst|etile_25gbe_1588|etile_hip
     #   set_instance_assignment -name REGION_NAME etile_hip -to soc_inst|etile_25gbe_1588|etile_hip
     #   set_instance_assignment -name GLOBAL_SIGNAL OFF -to soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|SL_NPHY*.altera_xcvr_native_inst|alt_ehipc3_fm_nphy_elane|g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx

#    }
    #set_global_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON
 #   set_instance_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON -to AK1
 #   set_instance_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON -to AL4
 #   set_instance_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON -to AP1
 #   set_instance_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON -to AR4
 #   set_instance_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON -to AV1
 #   set_instance_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON -to AW4
 #   set_instance_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON -to BB1
 #   set_instance_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON -to BC4
 #   set_instance_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON -to BG4
 #   set_instance_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON -to BK1
 #   set_instance_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON -to BL4
 #   set_instance_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON -to BP1
 #   set_instance_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON -to BR4
 #   set_instance_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON -to BV1
 #   set_instance_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON -to BW4
}

# Quartus settings for SDMIOs
proc config_sdmio {} {
    set_global_assignment -name USE_HPS_COLD_RESET SDM_IO11
    set_global_assignment -name USE_CONF_DONE SDM_IO16
}

# Quartus settings for Power Management
proc config_pwrmgt {} {
    global board_pwrmgt
    if {$board_pwrmgt == "linear"} {
        # Linear tech
        set_global_assignment -name INI_VARS "ASM_ENABLE_ADVANCED_DEVICES=ON;"
        set_global_assignment -name VID_OPERATION_MODE "PMBUS MASTER"
        set_global_assignment -name USE_PWRMGT_SCL SDM_IO0
        set_global_assignment -name USE_PWRMGT_SDA SDM_IO12
        set_global_assignment -name USE_CONF_DONE SDM_IO16
	set_global_assignment -name PWRMGT_BUS_SPEED_MODE "100 KHZ"
        set_global_assignment -name PWRMGT_SLAVE_DEVICE_TYPE LTC3888
	set_global_assignment -name NUMBER_OF_SLAVE_DEVICE 1
        set_global_assignment -name PWRMGT_SLAVE_DEVICE0_ADDRESS 62
        set_global_assignment -name PWRMGT_VOLTAGE_OUTPUT_FORMAT "LINEAR FORMAT"
        set_global_assignment -name PWRMGT_LINEAR_FORMAT_N "-12"
        set_global_assignment -name PWRMGT_TRANSLATED_VOLTAGE_VALUE_UNIT VOLTS
    } else {
        # Enpirion
        set_global_assignment -name INI_VARS "ASM_ENABLE_ADVANCED_DEVICES=ON;"
        set_global_assignment -name VID_OPERATION_MODE "PMBUS MASTER"
        set_global_assignment -name USE_PWRMGT_SCL SDM_IO0
        set_global_assignment -name USE_PWRMGT_SDA SDM_IO12
        set_global_assignment -name PWRMGT_BUS_SPEED_MODE "100 KHZ"
        set_global_assignment -name PWRMGT_PAGE_COMMAND_ENABLE ON
        set_global_assignment -name PWRMGT_SLAVE_DEVICE_TYPE ED8401
        set_global_assignment -name PWRMGT_SLAVE_DEVICE0_ADDRESS 62
        set_global_assignment -name PWRMGT_SLAVE_DEVICE1_ADDRESS 00
        set_global_assignment -name PWRMGT_SLAVE_DEVICE2_ADDRESS 00
        set_global_assignment -name PWRMGT_SLAVE_DEVICE3_ADDRESS 00
        set_global_assignment -name PWRMGT_SLAVE_DEVICE4_ADDRESS 00
        set_global_assignment -name PWRMGT_SLAVE_DEVICE5_ADDRESS 00
        set_global_assignment -name PWRMGT_SLAVE_DEVICE6_ADDRESS 00
        set_global_assignment -name PWRMGT_SLAVE_DEVICE7_ADDRESS 00
        set_global_assignment -name PWRMGT_PAGE_COMMAND_ENABLE OFF
        set_global_assignment -name PWRMGT_VOLTAGE_OUTPUT_FORMAT "LINEAR FORMAT"
        set_global_assignment -name PWRMGT_LINEAR_FORMAT_N "-13"
        set_global_assignment -name PWRMGT_TRANSLATED_VOLTAGE_VALUE_UNIT VOLTS
    }
}
