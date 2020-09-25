#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2020 Intel Corporation.
#
#****************************************************************************
#
# Sample SDC for S10 GHRD. Targeting MGE 10GbE component.
#
#****************************************************************************

# set the number of channels
set NUM_OF_CHANNEL 1
post_message -type info "Number of channel is $NUM_OF_CHANNEL"

create_clock -period "125 MHz" -name {refclk_125m} [get_ports mge_refclk_125m]
create_clock -period "125 MHz" -name {refclk_core} [get_ports mge_refclk_csr]
create_clock -period "644.53125 MHz" -name {refclk_10g} [get_ports mge_refclk_10g]

# derive_pll_clocks -create_base_clocks
derive_clock_uncertainty

# Set the channel prefix & instance for the design to generate the 1G/2.5G/10G clocks
if  {[info exists ch_prefix]} { 
    post_message -type info "Variable ch_prefix already exists."
} else {
    post_message -type info "Creating variable ch_prefix"
    for {set ch_number 0} {$ch_number < $NUM_OF_CHANNEL} {incr ch_number} {
        lappend ch_prefix "alt_mge_10gbe_inst|CHANNEL_GEN[$ch_number].u_channel|phy|alt_mge_phy_inst|"
    }
}


if  {[info exists profile]} { 
    post_message -type info "Variable profile already exists."
} else {
    post_message -type info "Creating variable profile" 
    set profile [list "profile0" \
                      "profile1" \
                      "profile2" \
    ]
}

# Declare Native PHY clocks
foreach ch $ch_prefix {
    foreach speed $profile { 
        post_message -type info "Declaring PHY clock for ${ch}${speed}."
        set tx_clkout "${ch}${speed}|tx_clkout|ch0"
        set rx_clkout "${ch}${speed}|rx_clkout|ch0"
        set tx_pcs_x2_clk "${ch}${speed}|tx_pcs_x2_clk|ch0"
        set rx_pcs_x2_clk "${ch}${speed}|rx_pcs_x2_clk|ch0"
        #declare_clock $tx_clkout
        #declare_clock $rx_clkout
        #declare_clock $tx_pcs_x2_clk
        #declare_clock $rx_pcs_x2_clk
    }
}

#**************************************************************
# Set False Path between profiles
#**************************************************************
# Note: 1G clock (profile0), 2.5G clock (profile1) and 10G clock (profile2) are mutually exclusive.

foreach ch $ch_prefix {
    set profile0_clk "${ch}profile0|*"
    set profile1_clk "${ch}profile1|*"
    set profile2_clk "${ch}profile2|*"
    
    # False path between 1G, 2.5G and 10G clock
    set_clock_groups -physically_exclusive -group [get_clocks $profile0_clk] \
                                           -group [get_clocks $profile1_clk] \
                                           -group [get_clocks $profile2_clk]

    # False path between 10G clock and 1G/2.5G PHY and Low Latency 10G MAC logic (MAC is not using 257 MHz clock)
    set_false_path -from [get_clocks $profile2_clk] \
                   -to   [get_registers {*|alt_mge16_pcs_pma:*|* \
                                       *|alt_em10g32:*|*}]
    set_false_path -from [get_registers {*|alt_mge16_pcs_pma:*|* \
                                       *|alt_em10g32:*|*}] \
                   -to   [get_clocks $profile2_clk]
       
    # False path between 1G/2.5G clock and 10G PHY logic
    set_false_path -from [get_clocks $profile0_clk] \
                   -to   [get_registers *|alt_mge_phy_xgmii_pcs:*|*] -no_synchronizer
    set_false_path -from [get_registers *|alt_mge_phy_xgmii_pcs:*|*] \
                   -to   [get_clocks $profile0_clk] -no_synchronizer
    set_false_path -from [get_clocks $profile1_clk] \
                   -to   [get_registers *|alt_mge_phy_xgmii_pcs:*|*]  -no_synchronizer
    set_false_path -from [get_registers *|alt_mge_phy_xgmii_pcs:*|*] \
                   -to   [get_clocks $profile1_clk] -no_synchronizer

    # False path between 1G clock and 2.5G 1588 logics
    set_false_path -from [get_clocks $profile0_clk] \
                   -to   [get_registers {*|*tod_2p5g:*|* \
                                         *|*tod_sync_*2p5g*|*}]
    set_false_path -from [get_registers {*|*tod_2p5g:*|* \
                                         *|*tod_sync_*2p5g*|*}] \
                   -to   [get_clocks $profile0_clk]

    # False path between 2.5G clock and 1G 1588 logics
    set_false_path -from [get_clocks $profile1_clk] \
                   -to   [get_registers {*|*tod_1g:*|* \
                                         *|*tod_sync_*1g:*|*}]
    set_false_path -from [get_registers {*|*tod_1g:*|* \
                                         *|*tod_sync_*1g:*|*}] \
                   -to   [get_clocks $profile1_clk]

    # False path between 10G clock and 1G/2.5G 1588 logics
    set_false_path -from [get_clocks $profile2_clk] \
                   -to   [get_registers {*|*tod_1g:*|* \
                                         *|*tod_2p5g:*|* \
                                         *|*tod_sync_*1g:*|* \
                                         *|*tod_sync_*2p5g*|*}]
    set_false_path -from [get_registers {*|*tod_1g:*|* \
                                         *|*tod_2p5g:*|* \
                                         *|*tod_sync_*1g:*|* \
                                         *|*tod_sync_*2p5g*|*}] \
                   -to   [get_clocks $profile2_clk]
}

# Pseudo-static signals
set_false_path -from [get_registers *|u_rcfg|mode_selected*] -to [get_registers *]

#**************************************************************
# Set False Path for alt_mge_reset_synchronizer
#**************************************************************
set reset_sync_aclr_counter 0
set reset_sync_clrn_counter 0
set reset_sync_aclr_collection [get_pins -compatibility_mode -nocase -nowarn *alt_mge_reset_synchronizer:*|alt_mge_reset_synchronizer_int_chain*|aclr]
set reset_sync_clrn_collection [get_pins -compatibility_mode -nocase -nowarn *alt_mge_reset_synchronizer:*|alt_mge_reset_synchronizer_int_chain*|clrn]

foreach_in_collection reset_sync_aclr_pin $reset_sync_aclr_collection {
    set reset_sync_aclr_counter [expr $reset_sync_aclr_counter + 1]
}

foreach_in_collection reset_sync_clrn_pin $reset_sync_clrn_collection {
    set reset_sync_clrn_counter [expr $reset_sync_clrn_counter + 1]
}

if {$reset_sync_aclr_counter > 0} {
    set_false_path -to [get_pins -compatibility_mode -nocase *alt_mge_reset_synchronizer:*|alt_mge_reset_synchronizer_int_chain*|aclr]
}

if {$reset_sync_clrn_counter > 0} {
    set_false_path -to [get_pins -compatibility_mode -nocase *alt_mge_reset_synchronizer:*|alt_mge_reset_synchronizer_int_chain*|clrn]
}

# FPGA IO port constraints
set_false_path -from * -to [get_ports {sfpa_txdisable}]
set_false_path -from * -to [get_ports {sfpa_ratesel[*]}]
set_false_path -from [get_ports {sfpa_los}] -to *
set_false_path -from [get_ports {sfpa_txfault}] -to *
set_false_path -from [get_ports {sfpa_mod0_prstn}] -to *

set_false_path -from * -to [get_ports {sfpa_i2c_sda}] 
set_false_path -from * -to [get_ports {sfpa_i2c_scl}] 
set_false_path -from [get_ports {sfpa_i2c_sda}] -to *
set_false_path -from [get_ports {sfpa_i2c_scl}] -to *
# # Constraint I2C clk at fast mode: 400Kbs
# create_generated_clock -name sfp_i2c_scl -source [get_pins {*|s10_hps|*|fpga_interfaces|peripheral_i2c0|scl_oe}] -divide_by 250 [get_ports {sfpa_i2c_scl}]

#KKS#  set_false_path -from {*|mge_chan_xcvr_rst_ctrl|altera_xcvr_reset_control_s10_inst|g_tx.g_tx[0].g_tx.counter_tx_digitalreset|r_reset} -to {*|mac_rst_csr_inst|tx_rst_n_sync_reg[0]}
#KKS#  set_false_path -from {*|mge_chan_xcvr_rst_ctrl|altera_xcvr_reset_control_s10_inst|g_rx.g_rx[0].g_rx.counter_rx_digitalreset|r_reset} -to {*|mac_rst_csr_inst|rx_rst_n_sync_reg[0]}

#KKS#  set_false_path -from {*|mge_rcfg_inst|mge_rcfg_fsm_i|status[*]} -to {*|altera_avalon_pio_inst|d1_data_in[*]}
#KKS#  set_false_path -from {*|mge_rcfg_inst|mge_rcfg_fsm_i|status[*]} -to {*|altera_avalon_pio_inst|readdata[*]}

# PIO False Path
set_false_path -from * -to {*|mge_10gbe_debug_status_pio|altera_avalon_pio_inst|d1_data_in[*]}
set_false_path -from * -to {*|mge_10gbe_debug_status_pio|altera_avalon_pio_inst|readdata[*]}
set_false_path -from * -to {*|mge_10gbe_status_pio|altera_avalon_pio_inst|d1_data_in[*]}
set_false_path -from * -to {*|mge_10gbe_status_pio|altera_avalon_pio_inst|readdata[*]}
set_false_path -from * -to {*|mge_10gbe_mac_link_status_pio|altera_avalon_pio_inst|d1_data_in*}
set_false_path -from * -to {*|mge_10gbe_mac_link_status_pio|altera_avalon_pio_inst|readdata*}
set_false_path -from * -to {*|mge_10gbe_tod_start_sync_ctrl_pio|altera_avalon_pio_inst|d1_data_in}
set_false_path -from * -to {*|mge_10gbe_tod_start_sync_ctrl_pio|altera_avalon_pio_inst|readdata[*]}

set_false_path -from {soc_inst|*axi_bridge_for_acp_128_inst|csr_*} -to {soc_inst|s10_hps|altera_stratix10_hps_inst|*}
