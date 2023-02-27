#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2022 Intel Corporation.
#
#****************************************************************************
#
# This script construct subsystem of Etile 25GbE 1588 for higher level integration
# The GHRD create_ghrd_qsys.tcl will call each of those subsystem construct script
# automatically based on the corresponding parameter argument defined
#
#****************************************************************************

source ./arguments_solver.tcl
source ./utils.tcl

package require -exact qsys 19.1

reload_ip_catalog
source ./construct_subsys_etile_25gbe_rx_dma.tcl
source ./construct_subsys_etile_25gbe_tx_dma.tcl
source ./construct_subsys_etile_tod.tcl
reload_ip_catalog

set subsys_name subsys_etile_25gbe_1588
create_system $subsys_name

set_project_property DEVICE_FAMILY $device_family
set_project_property DEVICE $device
set_validation_property AUTOMATIC_VALIDATION false

add_component_param "altera_clock_bridge subsys_etile_25gbe_1588_csrclk
                     IP_FILE_PATH ip/$subsys_name/subsys_etile_25gbe_1588_csrclk.ip
                     EXPLICIT_CLOCK_RATE 100000000
                     NUM_CLOCK_OUTPUTS 1
                     "

add_component_param "altera_clock_bridge subsys_etile_25gbe_1588_master_todclk
                     IP_FILE_PATH ip/$subsys_name/subsys_etile_25gbe_1588_master_todclk.ip
                     EXPLICIT_CLOCK_RATE 156250000
                     NUM_CLOCK_OUTPUTS 1
                     "

add_component_param "altera_reset_bridge subsys_etile_25gbe_1588_reset
                     IP_FILE_PATH ip/$subsys_name/subsys_etile_25gbe_1588_reset.ip
                     ACTIVE_LOW_RESET 1
                     SYNCHRONOUS_EDGES both
                     NUM_RESET_OUTPUTS 1
                     USE_RESET_REQUEST 0
                     "

add_component_param "altera_reset_bridge subsys_etile_25gbe_1588_ninitdone_reset
                     IP_FILE_PATH ip/$subsys_name/subsys_etile_25gbe_1588_ninitdone_reset.ip
                     SYNCHRONOUS_EDGES none
                     NUM_RESET_OUTPUTS 1
                     USE_RESET_REQUEST 0
                     "

add_component_param "altera_avalon_mm_bridge subsys_etile_25gbe_1588_csr
                     IP_FILE_PATH ip/$subsys_name/subsys_etile_25gbe_1588_csr.ip
                     DATA_WIDTH 32
                     ADDRESS_WIDTH 32
                     USE_AUTO_ADDRESS_WIDTH 1
                     MAX_BURST_SIZE 1
                     MAX_PENDING_RESPONSES 1
                     "

for {set x 1} {$x<=$hps_etile_1588_count} {incr x} {
   add_instance etile_25gbe_tx_dma_ch${x} subsys_etile_25gbe_tx_dma
   add_instance etile_25gbe_rx_dma_ch${x} subsys_etile_25gbe_rx_dma
   add_instance etile_tod_ch${x} subsys_etile_tod
}

if {$hps_etile_1588_25gbe_en == 1} {
add_component_param "alt_ehipc3_fm etile_hip
                     IP_FILE_PATH ip/$subsys_name/etile_hip.ip
                     {core_variant} {3}
                     {number_of_channel} {0}
                     {active_channel} {0}
                     {ENABLE_PTP} {1}
                     {EHIP_LOCATION} {EHIP0/2}
                     {ENABLE_RSFEC} {1}
                     {RSFEC_FIRST_LANE_SEL} {first_lane3}
                     {RSFEC_CLOCKING_MODE} {ehip_common_clk}
                     {ENHANCED_PTP_ACCURACY} {1}
                     {ENABLE_ADME} {1}
                     {ehip_rate_gui_sl_0} {25G}
                     {ehip_mode_gui_sl_0} {MAC+PTP+PCS+RSFEC}
                     {PHY_REFCLK_sl_0} {156.250000}
                     {flow_control_gui_sl_0} {Yes}
                     {rx_bytes_to_remove} {Remove CRC bytes}
                     {source_address_insertion_gui_sl_0} {1}
                     "
} elseif {$hps_etile_1588_10gbe_en == 1} {
add_component_param "alt_ehipc3_fm etile_hip
                     IP_FILE_PATH ip/$subsys_name/etile_hip.ip
                     {core_variant} {3}
                     {number_of_channel} {0}
                     {active_channel} {0}
                     {ENABLE_PTP} {1}
                     {EHIP_LOCATION} {EHIP0/2}
                     {ENHANCED_PTP_ACCURACY} {1}
                     {ENABLE_ADME} {1}
                     {ehip_rate_gui_sl_0} {10G}
                     {ehip_mode_gui_sl_0} {MAC+PTP+PCS}
                     {PHY_REFCLK_sl_0} {156.250000}
                     {flow_control_gui_sl_0} {Yes}
                     {rx_bytes_to_remove} {Remove CRC bytes}
                     {source_address_insertion_gui_sl_0} {1}
                     "
}

add_component_param "etile_hip_adapter etile_hip_adapter_0
                     IP_FILE_PATH ip/$subsys_name/etile_hip_adapter_0.ip
                     eth_25gbe_en $hps_etile_1588_25gbe_en
                     eth_10gbe_en $hps_etile_1588_10gbe_en
                     "

add_component_param "altera_iopll iopll_clk_dma
                     IP_FILE_PATH ip/$subsys_name/iopll_clk_dma.ip
                     gui_location_type {Fabric-Feeding}
                     gui_reference_clock_frequency {156.25}
                     gui_use_coreclk {1}
                     gui_use_locked {1}
                     gui_en_adv_params {1}
                     gui_operation_mode {direct}
                     gui_number_of_clocks {1}
                     gui_clock_name_string0 {outclk0}
                     gui_multiply_factor {84}
                     gui_divide_factor_n {13}
                     gui_divide_factor_c0 {5}
                     gui_duty_cycle0 {50.0}
                     gui_phase_shift0 {0.0}
                     hp_qsys_scripting_mode {1}
                     gui_pll_bandwidth_preset {Medium}
                     "

add_component_param "altera_iopll iopll_etile_ptp_sampling_clk
                     IP_FILE_PATH ip/$subsys_name/iopll_etile_ptp_sampling_clk.ip
                     gui_location_type {I/O Bank}
                     gui_reference_clock_frequency {100.0}
                     gui_use_coreclk {0}
                     gui_use_locked {1}
                     gui_operation_mode {direct}
                     gui_number_of_clocks {1}
                     gui_clock_name_string0 {outclk0}
                     gui_output_clock_frequency0 {114.285714}
                     gui_duty_cycle0 {50.0}
                     gui_output_clock_frequency_ps0 {10000.0}
                     gui_phase_shift0 {0.0}
                     gui_ps_units0 {ps}
                     hp_qsys_scripting_mode {1}
                     "
if {$hps_etile_1588_25gbe_en == 1} {
add_component_param "altera_iopll iopll_etile_tod_sync_sampling_25gbe_clk
                     IP_FILE_PATH ip/$subsys_name/iopll_etile_tod_sync_sampling_25gbe_clk.ip
                     gui_location_type {I/O Bank}
                     gui_reference_clock_frequency {156.25}
                     gui_use_coreclk {1}
                     gui_use_locked {1}
                     gui_en_adv_params {1}
                     gui_operation_mode {direct}
                     gui_number_of_clocks {1}
                     gui_clock_name_string0 {outclk0}
                     gui_multiply_factor {64}
                     gui_divide_factor_n {11}
                     gui_divide_factor_c0 {6}
                     gui_duty_cycle0 {50.0}
                     gui_phase_shift0 {0.0}
                     hp_qsys_scripting_mode {1}
                     "
}
if {$hps_etile_1588_10gbe_en == 1} {
add_component_param "altera_iopll iopll_etile_tod_sync_sampling_10gbe_clk
                     IP_FILE_PATH ip/$subsys_name/iopll_etile_tod_sync_sampling_10gbe_clk.ip
                     gui_location_type {I/O Bank}
                     gui_reference_clock_frequency {156.25}
                     gui_use_coreclk {1}
                     gui_use_locked {1}
                     gui_en_adv_params {1}
                     gui_operation_mode {direct}
                     gui_number_of_clocks {1}
                     gui_clock_name_string0 {outclk0}
                     gui_multiply_factor {64}
                     gui_divide_factor_n {9}
                     gui_divide_factor_c0 {7}
                     gui_duty_cycle0 {50.0}
                     gui_phase_shift0 {0.0}
                     hp_qsys_scripting_mode {1}
                     "
}
add_component_param "altera_avalon_pio qsfpdd_status_pio
                     IP_FILE_PATH ip/$subsys_name/qsfpdd_status_pio.ip
                     captureEdge 1
                     direction Input
                     edgeType RISING
                     generateIRQ 1
                     width 2
                     "

add_component_param "altera_avalon_pio qsfpdd_ctrl_pio_0
                     IP_FILE_PATH ip/$subsys_name/qsfpdd_ctrl_pio_0.ip
                     captureEdge 1
                     direction Output
                     edgeType RISING
                     resetValue 0x2
                     bitModifyingOutReg 0x07
                     width 3
                     "

add_component_param "altera_avalon_pio etile_debug_status_pio_0
                     IP_FILE_PATH ip/$subsys_name/etile_debug_status_pio_0.ip
                     captureEdge 1
                     direction Input
                     edgeType RISING
                     generateIRQ 1
                     width 13
                     "

add_component_param "altera_eth_1588_tod etile_master_tod
                     IP_FILE_PATH ip/$subsys_name/etile_master_tod.ip
                     PERIOD_CLOCK_FREQUENCY {1}
                     DEFAULT_NSEC_PERIOD {6}
                     DEFAULT_NSEC_ADJPERIOD {0}
                     DEFAULT_FNSEC_PERIOD {26214}
                     DEFAULT_FNSEC_ADJPERIOD {0}
                     ENABLE_PPS {0}
                     "

add_component_param "eth_tod_load_off etile_master_tod_load_off_96b
                     IP_FILE_PATH ip/$subsys_name/etile_master_tod_load_off_96b.ip
                     CONDUIT_DATA_WIDTH {96}
                     "

add_component_param "eth_tod_load_off etile_master_tod_load_off_64b
                     IP_FILE_PATH ip/$subsys_name/etile_master_tod_load_off_64b.ip
                     CONDUIT_DATA_WIDTH {64}
                     "

add_component_param "altera_clock_bridge subsys_etile_25gbe_1588_dmaclkout
                     IP_FILE_PATH ip/$subsys_name/subsys_etile_25gbe_1588_dmaclkout.ip
                     NUM_CLOCK_OUTPUTS 1
                     "

add_component_param "altera_reset_bridge subsys_etile_25gbe_1588_dmaclkout_reset
                     IP_FILE_PATH ip/$subsys_name/subsys_etile_25gbe_1588_dmaclkout_reset.ip
                     ACTIVE_LOW_RESET 1
                     SYNCHRONOUS_EDGES deassert
                     NUM_RESET_OUTPUTS 1
                     USE_RESET_REQUEST 0
                     "
add_component_param "eth_tod_distributor eth_tod_distributor_0
                     IP_FILE_PATH ip/$subsys_name/eth_tod_distributor_0.ip
                     OUTPUT_PORT_SIZE 4
                     "

# --------------- Connections and connection parameters ------------------#
if {$hps_etile_1588_25gbe_en == 1} {
connect "iopll_etile_tod_sync_sampling_25gbe_clk.locked     etile_hip_adapter_0.tod_sync_sampling_25gbe_clk_iopll_locked
         subsys_etile_25gbe_1588_master_todclk.out_clk      iopll_etile_tod_sync_sampling_25gbe_clk.refclk
         subsys_etile_25gbe_1588_ninitdone_reset.out_reset  iopll_etile_tod_sync_sampling_25gbe_clk.reset
        "
}
if {$hps_etile_1588_10gbe_en == 1} {
connect "iopll_etile_tod_sync_sampling_10gbe_clk.locked     etile_hip_adapter_0.tod_sync_sampling_10gbe_clk_iopll_locked
         subsys_etile_25gbe_1588_master_todclk.out_clk      iopll_etile_tod_sync_sampling_10gbe_clk.refclk
         subsys_etile_25gbe_1588_ninitdone_reset.out_reset  iopll_etile_tod_sync_sampling_10gbe_clk.reset
        "
}
connect "subsys_etile_25gbe_1588_csrclk.out_clk             subsys_etile_25gbe_1588_reset.clk
         subsys_etile_25gbe_1588_csrclk.out_clk             subsys_etile_25gbe_1588_csr.clk
         subsys_etile_25gbe_1588_reset.out_reset            subsys_etile_25gbe_1588_csr.reset

         subsys_etile_25gbe_1588_csrclk.out_clk             etile_master_tod.csr_clock
         subsys_etile_25gbe_1588_reset.out_reset            etile_master_tod.csr_reset
         subsys_etile_25gbe_1588_master_todclk.out_clk      etile_master_tod.period_clock
         subsys_etile_25gbe_1588_reset.out_reset            etile_master_tod.period_clock_reset

         etile_master_tod.time_of_day_96b                   eth_tod_distributor_0.tod_in

         subsys_etile_25gbe_1588_csrclk.out_clk             iopll_etile_ptp_sampling_clk.refclk
         subsys_etile_25gbe_1588_ninitdone_reset.out_reset  iopll_etile_ptp_sampling_clk.reset
         iopll_etile_ptp_sampling_clk.locked                etile_hip_adapter_0.ptp_sampling_clk_iopll_locked

         subsys_etile_25gbe_1588_csrclk.out_clk             etile_debug_status_pio_0.clk
         subsys_etile_25gbe_1588_reset.out_reset            etile_debug_status_pio_0.reset
         subsys_etile_25gbe_1588_csrclk.out_clk             qsfpdd_status_pio.clk
         subsys_etile_25gbe_1588_reset.out_reset            qsfpdd_status_pio.reset
         subsys_etile_25gbe_1588_csrclk.out_clk             qsfpdd_ctrl_pio_0.clk
         subsys_etile_25gbe_1588_reset.out_reset            qsfpdd_ctrl_pio_0.reset
         "

for {set x 1} {$x<=$hps_etile_1588_count} {incr x} {
connect "iopll_clk_dma.outclk0                              etile_25gbe_tx_dma_ch${x}.dma_clk
         etile_hip_adapter_0.clk_pll_div64                  etile_25gbe_tx_dma_ch${x}.etile_clk
         subsys_etile_25gbe_1588_reset.out_reset            etile_25gbe_tx_dma_ch${x}.reset
         etile_hip_adapter_0.clk_dma_lock_reset             etile_25gbe_tx_dma_ch${x}.reset
         iopll_clk_dma.outclk0                              etile_25gbe_rx_dma_ch${x}.dma_clk
         etile_hip_adapter_0.clk_pll_div64                  etile_25gbe_rx_dma_ch${x}.etile_clk
         subsys_etile_25gbe_1588_reset.out_reset            etile_25gbe_rx_dma_ch${x}.reset
         etile_hip_adapter_0.clk_dma_lock_reset             etile_25gbe_rx_dma_ch${x}.reset

         etile_25gbe_tx_dma_ch${x}.pktout                   etile_hip_adapter_0.sl_tx_avst
         etile_25gbe_tx_dma_ch${x}.timestamp_req            etile_hip_adapter_0.timestamp_request
         etile_hip_adapter_0.tx_timestamp                   etile_25gbe_tx_dma_ch${x}.timestamp

         etile_hip_adapter_0.sl_rx_avst                     etile_25gbe_rx_dma_ch${x}.pktin
         etile_hip_adapter_0.rx_timestamp                   etile_25gbe_rx_dma_ch${x}.timestamp

         etile_25gbe_rx_dma_ch${x}.pause_ctrl_etile         etile_hip.sl_pause_ports
         "
}

for {set x 1} {$x<=$hps_etile_1588_count} {incr x} {
connect_map "subsys_etile_25gbe_1588_csr.m0                 etile_25gbe_tx_dma_ch${x}.csr [expr {0x00210700 + ($x-1)*0x00000200}]
             subsys_etile_25gbe_1588_csr.m0                 etile_25gbe_rx_dma_ch${x}.csr [expr {0x00210B00 + ($x-1)*0x00000200}]
             subsys_etile_25gbe_1588_csr.m0                 etile_tod_ch${x}.csr          [expr {0x00210300 + ($x-1)*0x00000100}]
             "
}
for {set x 1} {$x<=$hps_etile_1588_count} {incr x} {
connect     "subsys_etile_25gbe_1588_csrclk.out_clk           etile_tod_ch${x}.clk
             subsys_etile_25gbe_1588_reset.out_reset                 etile_tod_ch${x}.reset
             subsys_etile_25gbe_1588_master_todclk.out_clk           etile_tod_ch${x}.master_todclk
             etile_hip_adapter_0.sl_tx_lanes_stable_reset_n          etile_tod_ch${x}.tod_tx_reset
             etile_hip_adapter_0.sl_rx_pcs_ready_reset_n             etile_tod_ch${x}.tod_rx_reset
             etile_tod_ch${x}.tx_slave_time_of_day_96b               etile_hip_adapter_0.sl_ptp_tx_tod
             etile_tod_ch${x}.rx_slave_time_of_day_96b               etile_hip_adapter_0.sl_ptp_rx_tod
            "
}
for {set x 1} {$x<=$hps_etile_1588_count} {incr x} {
if {$hps_etile_1588_25gbe_en == 1} {
connect     "iopll_etile_tod_sync_sampling_25gbe_clk.outclk0         etile_tod_ch${x}.sampling_25gbe_clk
             etile_hip_adapter_0.clk_pll_div66                       etile_tod_ch${x}.tx_25gbe_period_slave_clk
             etile_hip_adapter_0.clk_rec_div66                       etile_tod_ch${x}.rx_25gbe_period_slave_clk
             eth_tod_distributor_0.tod_out0                          etile_tod_ch${x}.tx_25gbe_slave_tod
             eth_tod_distributor_0.tod_out1                          etile_tod_ch${x}.rx_25gbe_slave_tod
             "

}
if {$hps_etile_1588_10gbe_en == 1} {
connect     "iopll_etile_tod_sync_sampling_10gbe_clk.outclk0         etile_tod_ch${x}.sampling_10gbe_clk
             etile_hip_adapter_0.clk_pll_div66                       etile_tod_ch${x}.tx_10gbe_period_slave_clk
             etile_hip_adapter_0.clk_rec_div66                       etile_tod_ch${x}.rx_10gbe_period_slave_clk
             eth_tod_distributor_0.tod_out2                          etile_tod_ch${x}.tx_10gbe_slave_tod
             eth_tod_distributor_0.tod_out3                          etile_tod_ch${x}.rx_10gbe_slave_tod
             "
}
}
connect "subsys_etile_25gbe_1588_master_todclk.out_clk          iopll_clk_dma.refclk
         subsys_etile_25gbe_1588_ninitdone_reset.out_reset      iopll_clk_dma.reset

         iopll_clk_dma.outclk0                                  subsys_etile_25gbe_1588_dmaclkout.in_clk
         iopll_clk_dma.outclk0                                  subsys_etile_25gbe_1588_dmaclkout_reset.clk
         etile_hip_adapter_0.clk_dma_lock_reset                 subsys_etile_25gbe_1588_dmaclkout_reset.in_reset
         "

connect "subsys_etile_25gbe_1588_csrclk.out_clk         etile_hip_adapter_0.reconfig_clock
         subsys_etile_25gbe_1588_reset.out_reset        etile_hip_adapter_0.reconfig_reset
         subsys_etile_25gbe_1588_reset.out_reset        etile_hip.i_csr_rst_n
         subsys_etile_25gbe_1588_csrclk.out_clk         etile_hip.i_reconfig_clk
         subsys_etile_25gbe_1588_reset.out_reset        etile_hip.i_reconfig_reset
         etile_hip_adapter_0.o_clk_pll_div64            etile_hip.o_clk_pll_div64
         etile_hip_adapter_0.o_clk_pll_div66            etile_hip.o_clk_pll_div66
         etile_hip_adapter_0.o_clk_rec_div64            etile_hip.o_clk_rec_div64
         etile_hip_adapter_0.o_clk_rec_div66            etile_hip.o_clk_rec_div66

         etile_hip_adapter_0.clk_pll_div64              etile_hip_adapter_0.sl_clk_tx
         etile_hip_adapter_0.clk_pll_div66              etile_hip_adapter_0.sl_clk_tx_tod
         etile_hip_adapter_0.clk_pll_div64              etile_hip_adapter_0.sl_clk_rx
         etile_hip_adapter_0.clk_rec_div66              etile_hip_adapter_0.sl_clk_rx_tod
         iopll_etile_ptp_sampling_clk.outclk0           etile_hip_adapter_0.clk_ptp_sample
         subsys_etile_25gbe_1588_reset.out_reset        etile_hip_adapter_0.sl_rst_tx
         subsys_etile_25gbe_1588_reset.out_reset        etile_hip_adapter_0.sl_rst_rx
         subsys_etile_25gbe_1588_reset.out_reset        etile_hip_adapter_0.sl_csr_rst_n

         etile_hip_adapter_0.i_sl_tx_rst_n              etile_hip.i_sl_tx_rst_n
         etile_hip_adapter_0.i_sl_rx_rst_n              etile_hip.i_sl_rx_rst_n
         etile_hip_adapter_0.i_sl_csr_rst_n             etile_hip.i_sl_csr_rst_n
         etile_hip_adapter_0.i_sl_clk_tx                etile_hip.i_sl_clk_tx
         etile_hip_adapter_0.i_sl_clk_tx_tod            etile_hip.i_sl_clk_tx_tod
         etile_hip_adapter_0.i_sl_clk_rx                etile_hip.i_sl_clk_rx
         etile_hip_adapter_0.i_sl_clk_rx_tod            etile_hip.i_sl_clk_rx_tod
         etile_hip_adapter_0.ptp_tod_ports_1p5ns_tx     etile_hip.ptp_tod_ports_1p5ns_tx
         etile_hip_adapter_0.ptp_tod_ports_1p5ns_rx     etile_hip.ptp_tod_ports_1p5ns_rx
         etile_hip_adapter_0.sl_ptp_ports_1p5ns         etile_hip.sl_ptp_ports_1p5ns

         etile_hip_adapter_0.i_ptp_reconfig_address             etile_hip.i_ptp_reconfig_address
         etile_hip_adapter_0.i_ptp_reconfig_write               etile_hip.i_ptp_reconfig_write
         etile_hip_adapter_0.i_ptp_reconfig_read                etile_hip.i_ptp_reconfig_read
         etile_hip_adapter_0.i_ptp_reconfig_writedata           etile_hip.i_ptp_reconfig_writedata
         etile_hip_adapter_0.o_ptp_reconfig_readdata            etile_hip.o_ptp_reconfig_readdata
         etile_hip_adapter_0.o_ptp_reconfig_waitrequest         etile_hip.o_ptp_reconfig_waitrequest

         etile_hip_adapter_0.i_xcvr_reconfig_address            etile_hip.i_xcvr_reconfig_address
         etile_hip_adapter_0.i_xcvr_reconfig_write              etile_hip.i_xcvr_reconfig_write
         etile_hip_adapter_0.i_xcvr_reconfig_read               etile_hip.i_xcvr_reconfig_read
         etile_hip_adapter_0.i_xcvr_reconfig_writedata          etile_hip.i_xcvr_reconfig_writedata
         etile_hip_adapter_0.o_xcvr_reconfig_readdata           etile_hip.o_xcvr_reconfig_readdata
         etile_hip_adapter_0.o_xcvr_reconfig_waitrequest        etile_hip.o_xcvr_reconfig_waitrequest

         etile_hip_adapter_0.i_sl_eth_reconfig_addr             etile_hip.i_sl_eth_reconfig_addr
         etile_hip_adapter_0.i_sl_eth_reconfig_read             etile_hip.i_sl_eth_reconfig_read
         etile_hip_adapter_0.i_sl_eth_reconfig_write            etile_hip.i_sl_eth_reconfig_write
         etile_hip_adapter_0.o_sl_eth_reconfig_readdata         etile_hip.o_sl_eth_reconfig_readdata
         etile_hip_adapter_0.o_sl_eth_reconfig_readdata_valid   etile_hip.o_sl_eth_reconfig_readdata_valid
         etile_hip_adapter_0.i_sl_eth_reconfig_writedata        etile_hip.i_sl_eth_reconfig_writedata
         etile_hip_adapter_0.o_sl_eth_reconfig_waitrequest      etile_hip.o_sl_eth_reconfig_waitrequest

         etile_hip_adapter_0.i_sl_stats_snapshot                etile_hip.i_sl_stats_snapshot

         etile_hip_adapter_0.sl_nonpcs_ports                    etile_hip.sl_nonpcs_ports
         etile_hip_adapter_0.sl_pfc_ports                       etile_hip.sl_pfc_ports

         etile_master_tod_load_off_64b.time_of_day_load         etile_master_tod.time_of_day_64b_load
         etile_master_tod_load_off_96b.time_of_day_load         etile_master_tod.time_of_day_96b_load

         etile_hip.sl_ptp_1step_ports                           etile_hip_adapter_0.sl_ptp_1step_ports

         etile_hip.sl_ptp_ports                                 etile_hip_adapter_0.sl_ptp_ports

         etile_hip_adapter_0.o_cdr_lock                         etile_hip.o_cdr_lock
         etile_hip_adapter_0.o_tx_pll_locked                    etile_hip.o_tx_pll_locked
         etile_hip_adapter_0.o_sl_tx_lanes_stable               etile_hip.o_sl_tx_lanes_stable
         etile_hip_adapter_0.o_sl_rx_pcs_ready                  etile_hip.o_sl_rx_pcs_ready
         etile_hip_adapter_0.o_sl_ehip_ready                    etile_hip.o_sl_ehip_ready
         etile_hip_adapter_0.o_sl_rx_block_lock                 etile_hip.o_sl_rx_block_lock
         etile_hip_adapter_0.o_sl_local_fault_status            etile_hip.o_sl_local_fault_status
         etile_hip_adapter_0.o_sl_remote_fault_status           etile_hip.o_sl_remote_fault_status
         iopll_clk_dma.outclk0                                  etile_hip_adapter_0.dma_clock
         etile_hip_adapter_0.iopll_clk_dma_locked               iopll_clk_dma.locked

         etile_hip_adapter_0.ehip_debug_status                  etile_debug_status_pio_0.external_connection
         "
if {$hps_etile_1588_25gbe_en == 1} {
connect_map "subsys_etile_25gbe_1588_csr.m0      etile_hip.rsfec_reconfig     0x0022_1000
            "
}
connect_map "subsys_etile_25gbe_1588_csr.m0      etile_hip_adapter_0.xcvr_reconfig      0x0018_0000
             subsys_etile_25gbe_1588_csr.m0      etile_hip_adapter_0.sl_eth_reconfig    0x0020_C000

             subsys_etile_25gbe_1588_csr.m0      etile_debug_status_pio_0.s1            0x0022_0000
             subsys_etile_25gbe_1588_csr.m0      qsfpdd_status_pio.s1                   0x0022_0010
             subsys_etile_25gbe_1588_csr.m0      qsfpdd_ctrl_pio_0.s1                   0x0022_0020
             subsys_etile_25gbe_1588_csr.m0      etile_master_tod.csr                   0x0022_0040
             "

#export signals
export etile_debug_status_pio_0             irq                         debug_status_pio_irq
export qsfpdd_status_pio                    irq                         qsfpdd_status_pio_irq

export etile_hip                            i_clk_ref                   clk_ref
export etile_hip                            serial_p                    serial_p
export etile_hip                            serial_n                    serial_n

# --------------------    Exported Interfaces     -----------------------#
export subsys_etile_25gbe_1588_csrclk           in_clk                  clk
export subsys_etile_25gbe_1588_master_todclk    in_clk                  master_todclk
export subsys_etile_25gbe_1588_reset            in_reset                reset
export subsys_etile_25gbe_1588_csr              s0                      csr
export subsys_etile_25gbe_1588_dmaclkout        out_clk                 dma_clkout
export subsys_etile_25gbe_1588_dmaclkout_reset  out_reset               dma_clkout_reset
export subsys_etile_25gbe_1588_ninitdone_reset  in_reset                ninit_done

export qsfpdd_status_pio    external_connection     qsfpdd_status_pio
export qsfpdd_ctrl_pio_0    external_connection     qsfpdd_ctrl_pio_0

for {set x 1} {$x<=$hps_etile_1588_count} {incr x} {
export etile_25gbe_tx_dma_ch${x}            prefetcher_read_master      tx_dma_ch${x}_prefetcher_read_master
export etile_25gbe_tx_dma_ch${x}            prefetcher_write_master     tx_dma_ch${x}_prefetcher_write_master
export etile_25gbe_tx_dma_ch${x}            read_master                 tx_dma_ch${x}_read_master
export etile_25gbe_rx_dma_ch${x}            prefetcher_read_master      rx_dma_ch${x}_prefetcher_read_master
export etile_25gbe_rx_dma_ch${x}            prefetcher_write_master     rx_dma_ch${x}_prefetcher_write_master
export etile_25gbe_rx_dma_ch${x}            write_master                rx_dma_ch${x}_write_master

export etile_25gbe_tx_dma_ch${x}            irq                         tx_dma_ch${x}_irq
export etile_25gbe_rx_dma_ch${x}            irq                         rx_dma_ch${x}_irq
}

# interconnect requirements
set_domain_assignment {$system} {qsys_mm.clockCrossingAdapter} {AUTO}
set_domain_assignment {$system} {qsys_mm.maxAdditionalLatency} {1}
set_domain_assignment {$system} {qsys_mm.enableEccProtection} {FALSE}
set_domain_assignment {$system} {qsys_mm.insertDefaultSlave} {FALSE}

sync_sysinfo_parameters

save_system ${subsys_name}.qsys
