# (C) 2001-2021 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and other
# software and tools, and its AMPP partner logic functions, and any output
# files from any of the foregoing (including device programming or simulation
# files), and any associated documentation or information are expressly subject
# to the terms and conditions of the Intel Program License Subscription
# Agreement, Intel FPGA IP License Agreement, or other applicable
# license agreement, including, without limitation, that your use is for the
# sole purpose of programming logic devices manufactured by Intel and sold by
# Intel or its authorized distributors.  Please refer to the applicable
# agreement for further details.

create_clock -name ETILE_MASTER_TODCLK -period 6.4 [get_ports etile_master_todclk_ref]

proc alt_ehipc3_fm_sl_constraint_net_delay {from_reg to_reg max_net_delay {check_exist 0} {get_pins 1}} {

    # Check for instances
    set inst [get_registers -nowarn ${to_reg}]

    # Check number of instances
    set inst_num [llength [query_collection -report -all $inst]]
    if {$inst_num > 0} {
        # Uncomment line below for debug purpose
        #puts "${inst_num} ${to_reg} instance(s) found"
    } else {
        # Uncomment line below for debug purpose
        #puts "No ${to_reg} instance found"
    }

    if {($check_exist == 0) || ($inst_num > 0)} {
        if { [string equal "quartus_sta" $::TimeQuestInfo(nameofexecutable)] } {
            set_max_delay -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] 200ns
            set_min_delay -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] -200ns
        } else {
            if {$get_pins == 0} {
                set_net_delay -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] -max $max_net_delay
            } else {
                set_net_delay -from [get_pins -compatibility_mode ${from_reg}|q] -to [get_registers ${to_reg}] -max $max_net_delay
            }

            # Relax the fitter effort
            set_max_delay -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] 200ns
            set_min_delay -from [get_registers ${from_reg}] -to [get_registers ${to_reg}] -200ns
        }
    }
}


alt_ehipc3_fm_sl_constraint_net_delay  *|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|*x_ptp_sub_nano|o_tam_adjust_avg[*] \
                                    *|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|*x_tam_adjust_avg_r[*] \
                                    2ns 1

alt_ehipc3_fm_sl_constraint_net_delay  *|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|*x_ptp_sn_wire_delay|o_wd_error[*] \
                                    *|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|*x_tam_adjust* \
                                    2ns 1

alt_ehipc3_fm_sl_constraint_net_delay * *|alt_ehipc3_fm_inst|*|resync_chains[*].synchronizer_nocut|* \
                                   2ns 1


alt_ehipc3_fm_sl_constraint_net_delay *|alt_ehipc3_fm_inst|sl_rsfec_mode[*] * \
                                   2ns 1

alt_ehipc3_fm_sl_constraint_net_delay *|alt_ehipc3_fm_inst|sl_*x_preamble_pass[*] * \
                                   2ns 1

alt_ehipc3_fm_sl_constraint_net_delay * *|alt_ehipc3_fm_0|rx_adapt_dropped_frame_count_sync_inst|rst_sync_0|synchronizer_nocut_inst|dreg* \
                                   2ns 1

alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.*x_tam_capture_cc|in_data_toggle} \
                       {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.*x_tam_capture_cc|in_to_out_synchronizer|din_s1} \
                   2ns 1

alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_RST_CTRL.ehip_*x_reset_sync_sync_reconfig_clk_*|resync_chains[*].synchronizer_nocut|dreg*} \
                                   {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.*x_tam_capture_cc|*} \
                                   2ns 1

alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|ehip_*x_reset_sync} \
                                   {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.*x_tam_capture_cc|*} \
                                   2ns 1

alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.*x_tam_capture_cc|in_data_buffer[*]} \
                                   {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.*x_tam_capture_cc|out_data_buffer[*]} \
                                   2ns 1

alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.*x_tam_capture_cc|out_data_toggle_flopped} \
                                   {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.*x_tam_capture_cc|out_to_in_synchronizer|din_s1} \
                                   2ns 1

#alt_ehipc3_fm_sl_constraint_net_delay *|alt_ehipc3_fm_inst|sl_tx_am_pulse[*] * \
                                   2ns 1

alt_ehipc3_fm_sl_constraint_net_delay * *|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|sl_rsfec_pld_ready \
                                   2ns 1

alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_RST_CTRL.i_sl_reset_controller|tx_ch_rst_inst|tx_aib_reset_out_stage[0]} \
                                   {*|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|*|alt_ehipc3_fm_nphy_elane|*} \
                                   2ns 1

alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_RST_CTRL.i_sl_reset_controller|rx_ch_rst_inst|rx_aib_reset_out_stage[0]} \
                                   {*|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|*|alt_ehipc3_fm_nphy_elane|*} \
                                   2ns 1

alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_RST_CTRL.i_sl_reset_controller|tx_ch_rst_inst|tx_aib_reset_out_stage[0]} \
                                   {*|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|*|alt_ehipc3_fm_nphy_elane_pt*|*} \
                                   2ns 1

alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_RST_CTRL.i_sl_reset_controller|rx_ch_rst_inst|rx_aib_reset_out_stage[0]} \
                                   {*|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|*|alt_ehipc3_fm_nphy_elane_pt*|*} \
                                   2ns 1

alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_RST_CTRL.i_sl_reset_controller|ehip_rst_seqinst|ehip_tx_reset_out_stage} \
                                   {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_RST_CTRL.tx_reset_sync_tx_clk|*} \
                                   2ns 1

alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_RST_CTRL.i_sl_reset_controller|ehip_rst_seqinst|ehip_rx_reset_out_stage} \
                                   {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_RST_CTRL.rx_reset_sync_rx_clk|*} \
                                   2ns 1

alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.load_*x_ui_cc|in_data_toggle} \
                                   {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.load_*x_ui_cc|in_to_out_synchronizer|din_s1} \
                                   2ns 1

alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.load_*x_ui_cc|out_data_toggle_flopped} \
                                   {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.load_*x_ui_cc|out_to_in_synchronizer|din_s1} \
                                   2ns 1

alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.load_*x_ui_cc|in_data_buffer*} \
                                   {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.load_*x_ui_cc|out_data_buffer*} \
                                   2ns 1
###


#
alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|rx_ptp_sn_wire_delay|tam_adjust_avg_icc|in_data_toggle} \
                                   {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|rx_ptp_sn_wire_delay|tam_adjust_avg_icc|in_to_out_synchronizer|din_s1} \
                                   2ns 1

alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|rx_ptp_sn_wire_delay|tam_adjust_avg_icc|out_data_toggle_flopped} \
                                   {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|rx_ptp_sn_wire_delay|tam_adjust_avg_icc|out_to_in_synchronizer|din_s1} \
                                   2ns 1

alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|rx_ptp_sn_wire_delay|tam_adjust_avg_icc|in_data_buffer*} \
                                   {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|rx_ptp_sn_wire_delay|tam_adjust_avg_icc|out_data_buffer*} \
                                   2ns 1
#
alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|rx_tam_capture_sn|sync_rxtam_2ptp_icc|in_data_toggle} \
                                   {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|rx_tam_capture_sn|sync_rxtam_2ptp_icc|in_to_out_synchronizer|din_s1} \
                                   2ns 1

alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|rx_tam_capture_sn|sync_rxtam_2ptp_icc|out_data_toggle_flopped} \
                                   {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|rx_tam_capture_sn|sync_rxtam_2ptp_icc|out_to_in_synchronizer|din_s1} \
                                   2ns 1

alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|rx_tam_capture_sn|sync_rxtam_2ptp_icc|in_data_buffer*} \
                                   {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|rx_tam_capture_sn|sync_rxtam_2ptp_icc|out_data_buffer*} \
                                   2ns 1
#
alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|tx_ptp_sn_wire_delay|tam_adjust_avg_icc|in_data_toggle} \
                                   {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|tx_ptp_sn_wire_delay|tam_adjust_avg_icc|in_to_out_synchronizer|din_s1} \
                                   2ns 1

alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|tx_ptp_sn_wire_delay|tam_adjust_avg_icc|out_data_toggle_flopped} \
                                   {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|tx_ptp_sn_wire_delay|tam_adjust_avg_icc|out_to_in_synchronizer|din_s1} \
                                   2ns 1

alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|tx_ptp_sn_wire_delay|tam_adjust_avg_icc|in_data_buffer*} \
                                   {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|tx_ptp_sn_wire_delay|tam_adjust_avg_icc|out_data_buffer*} \
                                   2ns 1
#
alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|tx_tam_capture_sn|sync_txtam_2ptp_icc|in_data_toggle} \
                                   {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|tx_tam_capture_sn|sync_txtam_2ptp_icc|in_to_out_synchronizer|din_s1} \
                                   2ns 1

alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|tx_tam_capture_sn|sync_txtam_2ptp_icc|out_data_toggle_flopped} \
                                   {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|tx_tam_capture_sn|sync_txtam_2ptp_icc|out_to_in_synchronizer|din_s1} \
                                   2ns 1

alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|tx_tam_capture_sn|sync_txtam_2ptp_icc|in_data_buffer*} \
                                   {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|tx_tam_capture_sn|sync_txtam_2ptp_icc|out_data_buffer*} \
                                   2ns 1
#
alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ts_converter_u_sn|sync_tod_rx_2ptp_icc|in_data_toggle} \
                                   {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ts_converter_u_sn|sync_tod_rx_2ptp_icc|in_to_out_synchronizer|din_s1} \
                                   2ns 1

alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ts_converter_u_sn|sync_tod_rx_2ptp_icc|out_data_toggle_flopped} \
                                   {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ts_converter_u_sn|sync_tod_rx_2ptp_icc|out_to_in_synchronizer|din_s1} \
                                   2ns 1

alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ts_converter_u_sn|sync_tod_rx_2ptp_icc|in_data_buffer*} \
                                   {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ts_converter_u_sn|sync_tod_rx_2ptp_icc|out_data_buffer*} \
                                   2ns 1
#
alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ts_converter_u_sn|sync_tod_tx_2ptp_icc|in_data_toggle} \
                                   {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ts_converter_u_sn|sync_tod_tx_2ptp_icc|in_to_out_synchronizer|din_s1} \
                                   2ns 1

alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ts_converter_u_sn|sync_tod_tx_2ptp_icc|out_data_toggle_flopped} \
                                   {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ts_converter_u_sn|sync_tod_tx_2ptp_icc|out_to_in_synchronizer|din_s1} \
                                   2ns 1

alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ts_converter_u_sn|sync_tod_tx_2ptp_icc|in_data_buffer*} \
                                   {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ts_converter_u_sn|sync_tod_tx_2ptp_icc|out_data_buffer*} \
                                   2ns 1
#
alt_ehipc3_fm_sl_constraint_net_delay *|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|*x_dt_status[*] * \
                                   2ns 1

alt_ehipc3_fm_sl_constraint_net_delay * *|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.ptp_csr_bank_sn|r_rx_error[*] \
                                   2ns 1

#
alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|rx_ptp_sub_nano|tam_adjust_avg_icc|in_data_toggle} \
                                   {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|rx_ptp_sub_nano|tam_adjust_avg_icc|in_to_out_synchronizer|din_s1} \
                                   2ns 1

alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|rx_ptp_sub_nano|tam_adjust_avg_icc|out_data_toggle_flopped} \
                                   {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|rx_ptp_sub_nano|tam_adjust_avg_icc|out_to_in_synchronizer|din_s1} \
                                   2ns 1

alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|rx_ptp_sub_nano|tam_adjust_avg_icc|in_data_buffer*} \
                                   {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|rx_ptp_sub_nano|tam_adjust_avg_icc|out_data_buffer*} \
                                   2ns 1

#
alt_ehipc3_fm_sl_constraint_net_delay *|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|rx_ptp_sub_nano|o_tam_adjust_avg[*] * \
                                   2ns 1

#
alt_ehipc3_fm_sl_constraint_net_delay * *|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.ptp_csr_bank_sn|r_tx_error[*] \
                                   2ns 1

#
alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|tx_ptp_sub_nano|tam_adjust_avg_icc|in_data_toggle} \
                                   {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|tx_ptp_sub_nano|tam_adjust_avg_icc|in_to_out_synchronizer|din_s1} \
                                   2ns 1

alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|tx_ptp_sub_nano|tam_adjust_avg_icc|out_data_toggle_flopped} \
                                   {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|tx_ptp_sub_nano|tam_adjust_avg_icc|out_to_in_synchronizer|din_s1} \
                                   2ns 1

alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|tx_ptp_sub_nano|tam_adjust_avg_icc|in_data_buffer*} \
                                   {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|tx_ptp_sub_nano|tam_adjust_avg_icc|out_data_buffer*} \
                                   2ns 1
#
alt_ehipc3_fm_sl_constraint_net_delay *|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|tx_ptp_sub_nano|o_tam_adjust_avg[*] * \
                                   2ns 1

#


 alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|tx_ptp_sn_wire_delay|sn_clb_pulse|o_roll_over_trig} \
                                    {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|tx_wasync_2ds|async_2ds|resync_chains[*].synchronizer_nocut|din_s1} \
                                    2ns 1


 alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|tx_ptp_sub_nano|o_sn_ready} \
                                    {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|tx_sn_ready_2ds|resync_chains[*].synchronizer_nocut|din_s1} \
                                    2ns 1

 alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|in_tx_roll_over_trig} \
                                    {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|tx_roll_over_phz_2ds|async_2ds|resync_chains[*].synchronizer_nocut|din_s1} \
                                    2ns 1

 alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_opcode_writer_u|ptp_calc_tam_u|tx_tam_valid_p[3]} \
                                    {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|tx_ptp_sub_nano|tam_valid_pulse_catcher_sync_0|resync_chains[*].synchronizer_nocut|din_s1} \
                                    2ns 1

 alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|tx_ptp_sub_nano|roll_over|o_roll_over_valid} \
                                    {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|tx_ptp_sub_nano|roll_over_valid_phz_2ds|resync_chains[*].synchronizer_nocut|din_s1} \
                                    2ns 1

 alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|tx_ptp_sub_nano|latency_tam|o_measure_done} \
                                    {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|tx_ptp_sub_nano|measure_done_2ds|resync_chains[*].synchronizer_nocut|din_s1} \
                                    2ns 1

 alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_opcode_writer_u|ptp_covert_commands_u|o_tx_ptp_ready} \
                                    {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|tx_ptp_ready_2ds|resync_chains[*].synchronizer_nocut|din_s1} \
                                    2ns 1

 alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|tx_ptp_sn_wire_delay|calibrate_n_r} \
                                    {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|tx_calibrate_2ds|resync_chains[*].synchronizer_nocut|din_s1} \
                                    2ns 1

#

 alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|rx_ptp_sn_wire_delay|sn_clb_pulse|o_roll_over_trig} \
                                    {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|rx_wasync_2ds|async_2ds|resync_chains[*].synchronizer_nocut|din_s1} \
                                    2ns 1

 alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|rx_ptp_sub_nano|o_sn_ready} \
                                    {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|rx_sn_ready_2ds|resync_chains[*].synchronizer_nocut|din_s1} \
                                    2ns 1

 alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|in_rx_roll_over_trig} \
                                    {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|rx_roll_over_phz_2ds|async_2ds|resync_chains[*].synchronizer_nocut|din_s1} \
                                    2ns 1

 alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_opcode_writer_u|ptp_calc_tam_u|rx_tam_valid_p[3]} \
                                    {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|rx_ptp_sub_nano|tam_valid_pulse_catcher_sync_0|resync_chains[*].synchronizer_nocut|din_s1} \
                                    2ns 1

 alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|rx_ptp_sub_nano|roll_over|o_roll_over_valid} \
                                    {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|rx_ptp_sub_nano|roll_over_valid_phz_2ds|resync_chains[*].synchronizer_nocut|din_s1} \
                                    2ns 1

 alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|rx_ptp_sub_nano|latency_tam|o_measure_done} \
                                    {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|rx_ptp_sub_nano|measure_done_2ds|resync_chains[*].synchronizer_nocut|din_s1} \
                                    2ns 1

 alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_opcode_writer_u|ptp_covert_commands_u|o_rx_ptp_ready} \
                                    {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|rx_ptp_ready_2ds|resync_chains[*].synchronizer_nocut|din_s1} \
                                    2ns 1

 alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|rx_ptp_sn_wire_delay|calibrate_n_r} \
                                    {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|rx_calibrate_2ds|resync_chains[*].synchronizer_nocut|din_s1} \
                                    2ns 1

 alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|tx_ptp_sn_wire_delay|roll_over|o_roll_over_valid} \
                                    {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|tx_ptp_sn_wire_delay|roll_over_valid_phz_2ds|resync_chains[*].synchronizer_nocut|din_s1} \
                                    2ns 1

 alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|tx_ptp_sn_wire_delay|latency_tam|o_measure_done} \
                                    {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|tx_ptp_sn_wire_delay|measure_done_2ds|resync_chains[*].synchronizer_nocut|din_s1} \
                                    2ns 1

 alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|all_ready} \
                                    {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|tx_all_ready_2ds|resync_chains[*].synchronizer_nocut|din_s1} \
                                    2ns 1

 alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|rx_ptp_sn_wire_delay|roll_over|o_roll_over_valid} \
                                    {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|rx_ptp_sn_wire_delay|roll_over_valid_phz_2ds|resync_chains[*].synchronizer_nocut|din_s1} \
                                    2ns 1

 alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|rx_ptp_sn_wire_delay|latency_tam|o_measure_done} \
                                    {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|rx_ptp_sn_wire_delay|measure_done_2ds|resync_chains[*].synchronizer_nocut|din_s1} \
                                    2ns 1

 alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|all_ready} \
                                    {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|rx_all_ready_2ds|resync_chains[0].synchronizer_nocut|din_s1} \
                                    2ns 1

 alt_ehipc3_fm_sl_constraint_net_delay {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|tx_ptp_sn_wire_delay|calibrate_n_r} \
                                    {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|x_tx_calibrate_2ds|resync_chains[0].synchronizer_nocut|din_s1} \
                                    2ns 1

 set_net_delay -from [get_pins -compatibility_mode {*|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|*|alt_ehipc3_fm_nphy_elan*|g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx|pld_pma_internal_clk2_hioint}] \
              -to [get_keepers {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|tx_async_2ds|async_2ds|resync_chains[*].synchronizer_nocut|din_s1}] \
              -max  2ns

 set_max_delay -from [get_pins -compatibility_mode {*|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|*|alt_ehipc3_fm_nphy_elan*|g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx|pld_pma_internal_clk2_hioint}] \
              -to [get_keepers {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|tx_async_2ds|async_2ds|resync_chains[*].synchronizer_nocut|din_s1}] \
              200ns

 set_min_delay -from [get_pins -compatibility_mode {*|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|*|alt_ehipc3_fm_nphy_elan*|g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx|pld_pma_internal_clk2_hioint}] \
              -to [get_keepers {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|tx_async_2ds|async_2ds|resync_chains[*].synchronizer_nocut|din_s1}] \
              -200ns

 set_net_delay -from [get_pins -compatibility_mode {*|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|*|alt_ehipc3_fm_nphy_elan*|g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx|pld_pma_internal_clk2_hioint}] \
              -to [get_keepers {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|tx_async_phz_2ds|async_2ds|resync_chains[*].synchronizer_nocut|din_s1}] \
              -max  2ns

 set_max_delay -from [get_pins -compatibility_mode {*|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|*|alt_ehipc3_fm_nphy_elan*|g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx|pld_pma_internal_clk2_hioint}] \
              -to [get_keepers {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|tx_async_phz_2ds|async_2ds|resync_chains[*].synchronizer_nocut|din_s1}] \
              200ns

 set_min_delay -from [get_pins -compatibility_mode {*|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|*|alt_ehipc3_fm_nphy_elan*|g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx|pld_pma_internal_clk2_hioint}] \
              -to [get_keepers {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|tx_async_phz_2ds|async_2ds|resync_chains[*].synchronizer_nocut|din_s1}] \
              -200ns

 set_net_delay -from [get_pins -compatibility_mode {*|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|*|alt_ehipc3_fm_nphy_elan*|g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx|pld_pma_internal_clk1_hioint}] \
              -to [get_keepers {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|rx_async_2ds|async_2ds|resync_chains[*].synchronizer_nocut|din_s1}] \
              -max  2ns

 set_max_delay -from [get_pins -compatibility_mode {*|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|*|alt_ehipc3_fm_nphy_elan*|g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx|pld_pma_internal_clk1_hioint}] \
              -to [get_keepers {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|rx_async_2ds|async_2ds|resync_chains[*].synchronizer_nocut|din_s1}] \
              200ns

 set_min_delay -from [get_pins -compatibility_mode {*|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|*|alt_ehipc3_fm_nphy_elan*|g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx|pld_pma_internal_clk1_hioint}] \
              -to [get_keepers {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|rx_async_2ds|async_2ds|resync_chains[*].synchronizer_nocut|din_s1}] \
              -200ns

 set_net_delay -from [get_pins -compatibility_mode {*|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|*|alt_ehipc3_fm_nphy_elan*|g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx|pld_pma_internal_clk1_hioint}] \
              -to [get_keepers {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|rx_async_phz_2ds|async_2ds|resync_chains[*].synchronizer_nocut|din_s1}] \
              -max  2ns

 set_max_delay -from [get_pins -compatibility_mode {*|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|*|alt_ehipc3_fm_nphy_elan*|g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx|pld_pma_internal_clk1_hioint}] \
              -to [get_keepers {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|rx_async_phz_2ds|async_2ds|resync_chains[*].synchronizer_nocut|din_s1}] \
              200ns

 set_min_delay -from [get_pins -compatibility_mode {*|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|*|alt_ehipc3_fm_nphy_elan*|g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx|pld_pma_internal_clk1_hioint}] \
              -to [get_keepers {*|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|rx_async_phz_2ds|async_2ds|resync_chains[*].synchronizer_nocut|din_s1}] \
              -200ns

 if {![string equal "quartus_sta" $::TimeQuestInfo(nameofexecutable)] } {
 set_net_delay -from [get_pins      {*|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|*|alt_ehipc3_fm_nphy_elane_pt*|g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx|pld_pcs_tx_clk_out1_dcm \
                                     *|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|*|alt_ehipc3_fm_nphy_elane_pt*|g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx|pld_pcs_tx_clk_out2_dcm}] \
               -to   [get_registers {*|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|*|alt_ehipc3_fm_nphy_elane_pt*|g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx*__aibadpt__aib_fabric_tx_transfer_clk.reg \
                                     *|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_RST_CTRL.tx_sclk_return_std_sync|resync_chains[*].synchronizer_nocut|din_s1}] \
               -max  2ns
 }
 set_max_delay -from [get_pins -compatibility_mode      {*|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|*|alt_ehipc3_fm_nphy_elane_pt*|g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx|pld_pcs_tx_clk_out1_dcm \
                                     *|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|*|alt_ehipc3_fm_nphy_elane_pt*|g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx|pld_pcs_tx_clk_out2_dcm}] \
               -to   [get_registers {*|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|*|alt_ehipc3_fm_nphy_elane_pt*|g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx*__aibadpt__aib_fabric_tx_transfer_clk.reg \
                                     *|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_RST_CTRL.tx_sclk_return_std_sync|resync_chains[*].synchronizer_nocut|din_s1}] \
               200ns
 set_min_delay -from [get_pins -compatibility_mode      {*|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|*|alt_ehipc3_fm_nphy_elane_pt*|g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx|pld_pcs_tx_clk_out1_dcm \
                                     *|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|*|alt_ehipc3_fm_nphy_elane_pt*|g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx|pld_pcs_tx_clk_out2_dcm}] \
               -to   [get_registers {*|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|*|alt_ehipc3_fm_nphy_elane_pt*|g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx*__aibadpt__aib_fabric_tx_transfer_clk.reg \
                                     *|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_RST_CTRL.tx_sclk_return_std_sync|resync_chains[*].synchronizer_nocut|din_s1}] \
               -200ns

 set_false_path -from *|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|tx_ptp_sn_wire_delay|sn_clb_pulse|o_roll_over_trig \
                -to   *|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|tx_tam_capture_sn|sclk_return_r
 set_false_path -from *|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|rx_ptp_sn_wire_delay|sn_clb_pulse|o_roll_over_trig \
                -to   *|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|rx_tam_capture_sn|sclk_return_r

 set_false_path -from *|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|is_10g -to *

#set_max_delay -to *|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|tx_tam_capture_sn|sclk_return_r 200ns
#set_max_delay -to *|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|rx_tam_capture_sn|sclk_return_r 200ns
#set_false_path -hold -to *|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|tx_tam_capture_sn|sclk_return_r
#set_false_path -hold -to *|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|rx_tam_capture_sn|sclk_return_r
#if {![string equal "quartus_sta" $::TimeQuestInfo(nameofexecutable)] } {
#set_data_delay -to *|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|tx_tam_capture_sn|sclk_return_r -from * 3.500ns
#set_data_delay -to *|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|rx_tam_capture_sn|sclk_return_r -from * 3.500ns
#} else {
#set_data_delay -to *|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|tx_tam_capture_sn|sclk_return_r -from * 4.500ns
#set_data_delay -to *|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[*].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|rx_tam_capture_sn|sclk_return_r -from * 4.500ns
#}
###
set aib_pld_tx_clk_pin_col  [get_pins -compat -nowarn *|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|*|alt_ehipc3_fm_nphy_elane_pt*|g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx|pld_tx_clk?_dcm]
set aib_pld_tx_clk_pin_col  [add_to_collection $aib_pld_tx_clk_pin_col [get_pins -compat -nowarn *|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|*|alt_ehipc3_fm_nphy_elane_pt*|g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx|pld_tx_clk?_rowclk] ]
set aib_tx_internal_div_reg_col [get_registers -nowarn *|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|*|alt_ehipc3_fm_nphy_elane_pt*|g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx~aib_tx_internal_div.reg]
set aib_fabric_transfer_clk_col [get_registers -nowarn *|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|*|alt_ehipc3_fm_nphy_elane_pt*|g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx~*aib_fabric_tx_transfer_clk.reg]

## ---------------------------------------------------------------------------------------------------------------------------------
## 29/Aug/2019 : slim35 : HSD#1409425013 : HSD#1507377856 :
## ---------------------------------------------------------------------------------------------------------------------------------
## Add in false_path recommended by Native PHY to PTP SDC to resolve the unexpected timed hold path warning introduced from Native PHY SDC.
## ---------------------------------------------------------------------------------------------------------------------------------
set aib_pld_tx_clk_pin_col  [get_pins -compat -nowarn *|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|*|alt_ehipc3_fm_nphy_elane_pt*|g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx|pld_tx_clk?_dcm]
set aib_pld_tx_clk_pin_col  [add_to_collection $aib_pld_tx_clk_pin_col [get_pins -compat -nowarn *|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|*|alt_ehipc3_fm_nphy_elane_pt*|g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx|pld_tx_clk?_rowclk] ]
set aib_tx_internal_div_reg_col [get_registers -nowarn *|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|*|alt_ehipc3_fm_nphy_elane_pt*|g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx~aib_tx_internal_div.reg]
set aib_fabric_transfer_clk_col [get_registers -nowarn *|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|*|alt_ehipc3_fm_nphy_elane_pt*|g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx~*aib_fabric_tx_transfer_clk.reg]

if { [get_collection_size $aib_fabric_transfer_clk_col] > 0 } {
    if { [get_collection_size $aib_tx_internal_div_reg_col] > 0 } {
        set_false_path -from $aib_tx_internal_div_reg_col -to $aib_fabric_transfer_clk_col
    }

    if { [get_collection_size $aib_pld_tx_clk_pin_col] > 0 } {
        set_false_path -through $aib_pld_tx_clk_pin_col -to $aib_fabric_transfer_clk_col
    }
}
## ---------------------------------------------------------------------------------------------------------------------------------

set_false_path -from {soc_inst|*axi_bridge_for_acp_inst|csr_*} -to {soc_inst|agilex_hps|intel_agilex_hps_inst|*}
set_false_path -from * -to {*|etile_debug_status_pio_0|altera_avalon_pio_inst|readdata[*]}

set_false_path -from {*|etile_25gbe_1588|rst_controller_*|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out} -to {*|etile_25gbe_1588|etile_25gbe_*x_dma_ch*|rst_controller*|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain[1]}

set_false_path -from * -to {*|etile_25gbe_1588|*|debug_status_reg[*]}

set_false_path -from {*|etile_25gbe_1588|*|etile_hip_adapter_inst|clk_dma_lock_reset_reg[*]} -to {*|altera_reset_synchronizer_int_chain[1]}

# False path between IO PLL Lock and ETILE reset synchronizer
set_false_path -from {*|etile_25gbe_1588|iopll_clk_dma|*|tennm_pll~pll_e_reg__nff} -to {*|etile_hip_adapter_inst|clk_dma_lock_reset_reg[*]}

# FPGA IO port constraints
set_false_path -from [get_ports {qsfpdd_modprsn}] -to *
set_false_path -from [get_ports {qsfpdd_intn}] -to *
set_false_path -from * -to [get_ports {qsfpdd_resetn}]
set_false_path -from * -to [get_ports {qsfpdd_modseln}]
set_false_path -from * -to [get_ports {qsfpdd_initmode}]

set_false_path -from * -to [get_ports {qsfpdd_i2c_sda}]
set_false_path -from * -to [get_ports {qsfpdd_i2c_scl}]
set_false_path -from [get_ports {qsfpdd_i2c_sda}] -to *
set_false_path -from [get_ports {qsfpdd_i2c_scl}] -to *
# # Constraint I2C clk at fast mode: 400Kbs
# create_generated_clock -name qsfpdd_i2c_scl -source [get_pins {*|fpga_interfaces|peripheral_i2c0|scl_oe}] -divide_by 250 [get_ports {qsfpdd_i2c_scl}]

set_false_path -from [get_keepers -no_duplicates {*|etile_25gbe_1588|iopll_etile_tod_sync_sampling_clk|altera_iopll_inst|tennm_pll~pll_e_reg__nff}] -to [get_keepers -no_duplicates {*|etile_hip_adapter_0|etile_hip_adapter_inst|sl_csr_rst_n_sync[0]}]
set_false_path -from [get_keepers -no_duplicates {*|etile_25gbe_1588|iopll_etile_ptp_sampling_clk|altera_iopll_inst|tennm_pll~pll_e_reg__nff}] -to [get_keepers -no_duplicates {*|etile_hip_adapter_0|etile_hip_adapter_inst|sl_csr_rst_n_sync[0]}]
set_false_path -from [get_keepers -no_duplicates {fpga_reset_n_debounced}] -to [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|rst_controller*|alt_rst_sync*|altera_reset_synchronizer_int_chain[1]}]
set_false_path -from [get_keepers -no_duplicates {fpga_reset_n_debounced}] -to [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_hip_adapter*|sl_csr_rst_n_sync[*]}]
set_false_path -from [get_keepers -no_duplicates {fpga_reset_n_debounced}] -to [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_hip_adapter*|sl_csr_rst_n_int}]
#set_clock_groups -asynchronous -group [get_clocks {soc_inst|etile_25gbe_1588|iopll_etile_ptp_sampling_clk|altera_iopll_inst_outclk0}] -group [get_clocks {soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|alt_ehipc3_fm_hard_inst|SL_PTP_NPHY_CHPLL.nphy_ptp0|alt_ehipc3_fm_nphy_elane_ptp|tx_clkout|ch0}]
set_false_path -from [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_RST_CTRL.i_sl_reset_controller|tx_lanes_stable}] -to [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|rst_controller_007|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain[1]}]
set_false_path -from [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_RST_CTRL.i_sl_reset_controller|rx_eth_ready}] -to [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|rst_controller_006|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain[1]}]
set_false_path -from [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_25gbe_rx_dma_ch1|rx_dma_write_master|dma_write_master_inst|the_st_to_master_fifo|auto_generated|dpfifo|FIFOram|altera_syncram_impl1|ram_block2a*~reg1}] -to [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_25gbe_rx_dma_ch1|rx_dma_write_master|dma_write_master_inst|the_st_to_master_fifo|auto_generated|dpfifo|FIFOram|altera_syncram_impl1|ram_block2a*~reg1}]
set_false_path -from [get_keepers -no_duplicates {soc_inst|rst_controller_002|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out}] -to [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_25gbe_rx_dma_ch1|rst_controller_001|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain[1]}]
set_false_path -from [get_keepers -no_duplicates {soc_inst|rst_controller_002|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out}] -to [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_25gbe_tx_dma_ch1|rst_controller_001|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain[1]}]
set_false_path -from [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_RST_CTRL.i_sl_reset_controller|tx_lanes_stable}] -to [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|rst_controller_004|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain[1]}]
set_false_path -from [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_RST_CTRL.i_sl_reset_controller|rx_eth_ready}] -to [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|rst_controller_003|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain[1]}]
set_false_path -from [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_RST_CTRL.i_sl_reset_controller|rx_eth_ready}] -to [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|rst_controller_005|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain[1]}]
set_false_path -from [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_RST_CTRL.i_sl_reset_controller|tx_lanes_stable}] -to [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|rst_controller_006|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain[1]}]
set_false_path -from [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|iopll_etile_tod_sync_sampling_10gbe_clk|altera_iopll_inst|tennm_pll~pll_e_reg__nff}] -to [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_hip_adapter_0|etile_hip_adapter_inst|sl_csr_rst_n_sync[0]}]
set_false_path -from [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|iopll_etile_tod_sync_sampling_25gbe_clk|altera_iopll_inst|tennm_pll~pll_e_reg__nff}] -to [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_hip_adapter_0|etile_hip_adapter_inst|sl_csr_rst_n_sync[0]}]
set_false_path -from [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_tod_ch1|tod_25g_10g_enable_pio_0|altera_avalon_pio_inst|data_out~DUPLICATE}] -to [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|tx_tam_capture_sn|tx_tam_l[*]}]
set_false_path -from [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_tod_ch1|tod_25g_10g_enable_pio_0|altera_avalon_pio_inst|data_out~DUPLICATE}] -to [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|ptp_ts_converter_u_sn|sync_tod_tx_2ptp_icc|in_data_buffer[*]}]
set_false_path -from [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_tod_ch1|tod_25g_10g_enable_pio_0|altera_avalon_pio_inst|data_out}] -to [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|tx_tam_capture_sn|tx_tam_l[*]}]
set_false_path -from [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_tod_ch1|tod_25g_10g_enable_pio_0|altera_avalon_pio_inst|data_out}] -to [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|ptp_ts_converter_u_sn|sync_tod_tx_2ptp_icc|in_data_buffer[*]}]
set_false_path -from [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_tod_ch1|tod_25g_10g_enable_pio_0|altera_avalon_pio_inst|data_out~DUPLICATE}] -to [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|rx_tam_capture_sn|rx_tam[*]}]
set_false_path -from [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_tod_ch1|tod_25g_10g_enable_pio_0|altera_avalon_pio_inst|data_out~DUPLICATE}] -to [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|ptp_ts_converter_u_sn|sync_tod_rx_2ptp_icc|in_data_buffer[*]}]
set_false_path -from [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_tod_ch1|tod_25g_10g_enable_pio_0|altera_avalon_pio_inst|data_out}] -to [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|ptp_ref_ts_capture_u_sn|rx_tam_capture_sn|rx_tam[*]}]
set_false_path -from [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_tod_ch1|tod_25g_10g_enable_pio_0|altera_avalon_pio_inst|data_out}] -to [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_PTP.soft_ptp_sn|ptp_ts_converter_u_sn|sync_tod_rx_2ptp_icc|in_data_buffer[*]}]
set_false_path -from [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_RST_CTRL.i_sl_reset_controller|rx_eth_ready}] -to [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|rst_controller_004|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain[1]}]
set_false_path -from [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_hip|alt_ehipc3_fm_inst|SL_SOFT.SL_SOFT_I[0].sl_soft|SL_RST_CTRL.i_sl_reset_controller|tx_lanes_stable}] -to [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|rst_controller_005|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain[1]}]
set_false_path -from [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_25gbe_tx_dma_ch1|tx_dma_tx_fifo|altera_avalon_sc_fifo_inst|gen_blk9.gen_blk10_else.altera_syncram_component|auto_generated|altera_syncram_impl1|ram_block2a68~reg0}] -to [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_25gbe_tx_dma_ch1|tx_dma_tx_fifo|altera_avalon_sc_fifo_inst|out_payload[68]~DUPLICATE}]
set_false_path -from [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_25gbe_tx_dma_ch1|tx_dma_tx_fifo|altera_avalon_sc_fifo_inst|gen_blk9.gen_blk10_else.altera_syncram_component|auto_generated|altera_syncram_impl1|ram_block2a68~reg0}] -to [get_keepers -no_duplicates {soc_inst|etile_25gbe_1588|etile_25gbe_tx_dma_ch1|tx_dma_tx_fifo|altera_avalon_sc_fifo_inst|out_payload[68]}]