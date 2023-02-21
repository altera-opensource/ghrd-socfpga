#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2022 Intel Corporation.
#
#****************************************************************************
#
# This script construct subsystem of Etile 25GbE 1588 TOD for higher level integration
# The GHRD create_ghrd_qsys.tcl will call each of those subsystem construct script
# automatically based on the corresponding parameter argument defined
#
#****************************************************************************

source ./arguments_solver.tcl
source ./utils.tcl

package require -exact qsys 19.1

set subsys_name subsys_etile_tod
create_system $subsys_name

set_project_property DEVICE_FAMILY $device_family
set_project_property DEVICE $device
set_validation_property AUTOMATIC_VALIDATION false

add_component_param "altera_clock_bridge subsys_etile_tod_csrclk
                     IP_FILE_PATH ip/$subsys_name/subsys_etile_tod_csrclk.ip
                     EXPLICIT_CLOCK_RATE 0
                     NUM_CLOCK_OUTPUTS 1
                    "

add_component_param "altera_reset_bridge subsys_etile_tod_reset
                     IP_FILE_PATH ip/$subsys_name/subsys_etile_tod_reset.ip
                     ACTIVE_LOW_RESET 1
                     SYNCHRONOUS_EDGES both
                     NUM_RESET_OUTPUTS 1
                     USE_RESET_REQUEST 0
                     "

add_component_param "start_tod_sync start_tod_sync_0
                    IP_FILE_PATH ip/$subsys_name/start_tod_sync_0.ip
                    "

add_component_param "altera_clock_bridge subsys_etile_tod_master_clk
                     IP_FILE_PATH ip/$subsys_name/subsys_etile_tod_master_clk.ip
                     EXPLICIT_CLOCK_RATE 156250000
                     NUM_CLOCK_OUTPUTS 1
                     "

add_component_param "altera_reset_bridge subsys_etile_tod_tx_reset
                     IP_FILE_PATH ip/$subsys_name/subsys_etile_tod_tx_reset.ip
                     ACTIVE_LOW_RESET 1
                     SYNCHRONOUS_EDGES both
                     NUM_RESET_OUTPUTS 1
                     USE_RESET_REQUEST 0
                     "

add_component_param "altera_reset_bridge subsys_etile_tod_rx_reset
                     IP_FILE_PATH ip/$subsys_name/subsys_etile_tod_rx_reset.ip
                     ACTIVE_LOW_RESET 1
                     SYNCHRONOUS_EDGES both
                     NUM_RESET_OUTPUTS 1
                     USE_RESET_REQUEST 0
                     "

add_component_param "altera_avalon_mm_bridge subsys_etile_tod_csr
                     IP_FILE_PATH ip/$subsys_name/subsys_etile_tod_csr.ip
                     DATA_WIDTH 32
                     ADDRESS_WIDTH 32
                     USE_AUTO_ADDRESS_WIDTH 1
                     MAX_BURST_SIZE 1
                     MAX_PENDING_RESPONSES 1
                     "

if {$hps_etile_1588_25gbe_en == 1} {
add_component_param "altera_clock_bridge subsys_etile_tod_sync_25gbe_sampling_clk
                     IP_FILE_PATH ip/$subsys_name/subsys_etile_tod_sync_25gbe_sampling_clk.ip
                     EXPLICIT_CLOCK_RATE 151515152
                     NUM_CLOCK_OUTPUTS 1
                     "

add_component_param "altera_clock_bridge subsys_etile_25gbe_tod_tx_period_slave_clk
                     IP_FILE_PATH ip/$subsys_name/subsys_etile_25gbe_tod_tx_period_slave_clk.ip
                     NUM_CLOCK_OUTPUTS 1
                     EXPLICIT_CLOCK_RATE 390625000
                    "

add_component_param "altera_clock_bridge subsys_etile_25gbe_tod_rx_period_slave_clk
                     IP_FILE_PATH ip/$subsys_name/subsys_etile_25gbe_tod_rx_period_slave_clk.ip
                     NUM_CLOCK_OUTPUTS 1
                     EXPLICIT_CLOCK_RATE 390625000
                    "

add_component_param "altera_eth_1588_tod etile_25gbe_tx_slave_tod
                    IP_FILE_PATH ip/$subsys_name/etile_25gbe_tx_slave_tod.ip
                    PERIOD_CLOCK_FREQUENCY {1}
                    DEFAULT_NSEC_PERIOD {2}
                    DEFAULT_NSEC_ADJPERIOD {0}
                    DEFAULT_FNSEC_PERIOD {36700}
                    DEFAULT_FNSEC_ADJPERIOD {0}
                    ENABLE_PPS {0}
                    "

add_component_param "altera_eth_1588_tod etile_25gbe_rx_slave_tod
                    IP_FILE_PATH ip/$subsys_name/etile_25gbe_rx_slave_tod.ip
                    PERIOD_CLOCK_FREQUENCY {1}
                    DEFAULT_NSEC_PERIOD {2}
                    DEFAULT_NSEC_ADJPERIOD {0}
                    DEFAULT_FNSEC_PERIOD {36700}
                    DEFAULT_FNSEC_ADJPERIOD {0}
                    ENABLE_PPS {0}
                    "

add_component_param "altera_eth_1588_tod_synchronizer etile_25gbe_tx_tod_sync
                    IP_FILE_PATH ip/$subsys_name/etile_25gbe_tx_tod_sync.ip
                    TOD_MODE {1}
                    SYNC_MODE {9}
                    SAMPLE_SIZE {64}
                    "

add_component_param "altera_eth_1588_tod_synchronizer etile_25gbe_rx_tod_sync
                    IP_FILE_PATH ip/$subsys_name/etile_25gbe_rx_tod_sync.ip
                    TOD_MODE {1}
                    SYNC_MODE {9}
                    SAMPLE_SIZE {64}
                    "

add_component_param "eth_tod_load_off etile_tx_25gbe_tod_load_off_64b
                    IP_FILE_PATH ip/$subsys_name/etile_tx_25gbe_tod_load_off_64b.ip
                    CONDUIT_DATA_WIDTH {64}
                    "

add_component_param "eth_tod_load_off etile_rx_25gbe_tod_load_off_64b
                    IP_FILE_PATH ip/$subsys_name/etile_rx_25gbe_tod_load_off_64b.ip
                    CONDUIT_DATA_WIDTH {64}
                    "
}

if {$hps_etile_1588_10gbe_en == 1} {
add_component_param "altera_clock_bridge subsys_etile_tod_sync_10gbe_sampling_clk
                     IP_FILE_PATH ip/$subsys_name/subsys_etile_tod_sync_10gbe_sampling_clk.ip
                     EXPLICIT_CLOCK_RATE 158730159
                     NUM_CLOCK_OUTPUTS 1
                    "

add_component_param "altera_clock_bridge subsys_etile_10gbe_tod_tx_period_slave_clk
                     IP_FILE_PATH ip/$subsys_name/subsys_etile_10gbe_tod_tx_period_slave_clk.ip
                     NUM_CLOCK_OUTPUTS 1
                     EXPLICIT_CLOCK_RATE 156250000
                    "

add_component_param "altera_clock_bridge subsys_etile_10gbe_tod_rx_period_slave_clk
                     IP_FILE_PATH ip/$subsys_name/subsys_etile_10gbe_tod_rx_period_slave_clk.ip
                     NUM_CLOCK_OUTPUTS 1
                     EXPLICIT_CLOCK_RATE 156250000
                    "

add_component_param "altera_eth_1588_tod etile_10gbe_tx_slave_tod
                    IP_FILE_PATH ip/$subsys_name/etile_10gbe_tx_slave_tod.ip
                    PERIOD_CLOCK_FREQUENCY {1}
                    DEFAULT_NSEC_PERIOD {6}
                    DEFAULT_NSEC_ADJPERIOD {0}
                    DEFAULT_FNSEC_PERIOD {26214}
                    DEFAULT_FNSEC_ADJPERIOD {0}
                    ENABLE_PPS {0}
                    "

add_component_param "altera_eth_1588_tod etile_10gbe_rx_slave_tod
                    IP_FILE_PATH ip/$subsys_name/etile_10gbe_rx_slave_tod.ip
                    PERIOD_CLOCK_FREQUENCY {1}
                    DEFAULT_NSEC_PERIOD {6}
                    DEFAULT_NSEC_ADJPERIOD {0}
                    DEFAULT_FNSEC_PERIOD {26214}
                    DEFAULT_FNSEC_ADJPERIOD {0}
                    ENABLE_PPS {0}
                    "

add_component_param "altera_eth_1588_tod_synchronizer etile_10gbe_tx_tod_sync
                    IP_FILE_PATH ip/$subsys_name/etile_10gbe_tx_tod_sync.ip
                    TOD_MODE {1}
                    SYNC_MODE {2}
                    SAMPLE_SIZE {64}
                    "

add_component_param "altera_eth_1588_tod_synchronizer etile_10gbe_rx_tod_sync
                    IP_FILE_PATH ip/$subsys_name/etile_10gbe_rx_tod_sync.ip
                    TOD_MODE {1}
                    SYNC_MODE {2}
                    SAMPLE_SIZE {64}
                    "

add_component_param "eth_tod_load_off etile_tx_10gbe_tod_load_off_64b
                    IP_FILE_PATH ip/$subsys_name/etile_tx_10gbe_tod_load_off_64b.ip
                    CONDUIT_DATA_WIDTH {64}
                    "

add_component_param "eth_tod_load_off etile_rx_10gbe_tod_load_off_64b
                    IP_FILE_PATH ip/$subsys_name/etile_rx_10gbe_tod_load_off_64b.ip
                    CONDUIT_DATA_WIDTH {64}
                    "
}

if {$hps_etile_1588_25gbe_en == 1 && $hps_etile_1588_10gbe_en == 1} {
add_component_param "altera_avalon_pio tod_25g_10g_enable_pio_0
                     IP_FILE_PATH ip/$subsys_name/tod_25g_10g_enable_pio_0.ip
                     captureEdge 1
                     direction Output
                     edgeType RISING
                     resetValue 0x1
                     bitModifyingOutReg 0x07
                     width 1
                     "

add_component_param "altera_address_span_extender address_span_25g10g
                     IP_FILE_PATH ip/$subsys_name/address_span_25g10g.ip
                     DATA_WIDTH 32
                     BYTEENABLE_WIDTH 4
                     MASTER_ADDRESS_WIDTH 8
                     SLAVE_ADDRESS_WIDTH 5
                     SLAVE_ADDRESS_SHIFT 2
                     BURSTCOUNT_WIDTH 1
                     CNTL_ADDRESS_WIDTH 1
                     SUB_WINDOW_COUNT 1
                    "

add_component_param "tod_mux tod_mux_0
                    IP_FILE_PATH ip/$subsys_name/tod_mux_0.ip
                    "
}

#  Signal Connections
connect "subsys_etile_tod_csrclk.out_clk                          subsys_etile_tod_reset.clk
         subsys_etile_tod_csrclk.out_clk                          subsys_etile_tod_csr.clk
         subsys_etile_tod_reset.out_reset                         subsys_etile_tod_csr.reset
        "

if {$hps_etile_1588_25gbe_en == 1} {
connect "subsys_etile_tod_csrclk.out_clk                          etile_25gbe_tx_slave_tod.csr_clock
         subsys_etile_tod_reset.out_reset                         etile_25gbe_tx_slave_tod.csr_reset
         subsys_etile_tod_reset.out_reset                         etile_25gbe_tx_slave_tod.period_clock_reset

         subsys_etile_25gbe_tod_tx_period_slave_clk.out_clk       etile_25gbe_tx_slave_tod.period_clock
         subsys_etile_25gbe_tod_rx_period_slave_clk.out_clk       etile_25gbe_rx_slave_tod.period_clock
         subsys_etile_tod_csrclk.out_clk                          etile_25gbe_rx_slave_tod.csr_clock
         subsys_etile_tod_reset.out_reset                         etile_25gbe_rx_slave_tod.csr_reset
         subsys_etile_tod_reset.out_reset                         etile_25gbe_rx_slave_tod.period_clock_reset

         subsys_etile_25gbe_tod_tx_period_slave_clk.out_clk       subsys_etile_tod_tx_reset.clk
         subsys_etile_25gbe_tod_rx_period_slave_clk.out_clk       subsys_etile_tod_rx_reset.clk
         subsys_etile_tod_tx_reset.out_reset                      etile_25gbe_tx_slave_tod.period_clock_reset

         subsys_etile_tod_rx_reset.out_reset                      etile_25gbe_rx_slave_tod.period_clock_reset
         etile_tx_25gbe_tod_load_off_64b.time_of_day_load         etile_25gbe_tx_slave_tod.time_of_day_64b_load
         etile_rx_25gbe_tod_load_off_64b.time_of_day_load         etile_25gbe_rx_slave_tod.time_of_day_64b_load
         etile_25gbe_tx_tod_sync.tod_slave_data                   etile_25gbe_tx_slave_tod.time_of_day_96b_load
         etile_25gbe_rx_tod_sync.tod_slave_data                   etile_25gbe_rx_slave_tod.time_of_day_96b_load

         subsys_etile_tod_master_clk.out_clk                      etile_25gbe_tx_tod_sync.clk_master
         subsys_etile_tod_reset.out_reset                         etile_25gbe_tx_tod_sync.reset_master
         subsys_etile_tod_reset.out_reset                         etile_25gbe_tx_tod_sync.reset_slave
         subsys_etile_25gbe_tod_tx_period_slave_clk.out_clk       etile_25gbe_tx_tod_sync.clk_slave
         subsys_etile_tod_tx_reset.out_reset                      etile_25gbe_tx_tod_sync.reset_slave
         subsys_etile_tod_sync_25gbe_sampling_clk.out_clk         etile_25gbe_tx_tod_sync.clk_sampling
         start_tod_sync_0.tx_tod_25gbe_start_tod_sync             etile_25gbe_tx_tod_sync.start_tod_sync

         subsys_etile_25gbe_tod_rx_period_slave_clk.out_clk       etile_25gbe_rx_tod_sync.clk_slave
         subsys_etile_tod_master_clk.out_clk                      etile_25gbe_rx_tod_sync.clk_master
         subsys_etile_tod_reset.out_reset                         etile_25gbe_rx_tod_sync.reset_master
         subsys_etile_tod_reset.out_reset                         etile_25gbe_rx_tod_sync.reset_slave
         subsys_etile_tod_rx_reset.out_reset                      etile_25gbe_rx_tod_sync.reset_slave
         subsys_etile_tod_sync_25gbe_sampling_clk.out_clk         etile_25gbe_rx_tod_sync.clk_sampling
         start_tod_sync_0.rx_tod_25gbe_start_tod_sync             etile_25gbe_rx_tod_sync.start_tod_sync
        "
}

if {$hps_etile_1588_10gbe_en == 1} {
connect "subsys_etile_tod_csrclk.out_clk                          etile_10gbe_tx_slave_tod.csr_clock
         subsys_etile_tod_reset.out_reset                         etile_10gbe_tx_slave_tod.csr_reset
         subsys_etile_tod_reset.out_reset                         etile_10gbe_tx_slave_tod.period_clock_reset

         subsys_etile_tod_csrclk.out_clk                          etile_10gbe_rx_slave_tod.csr_clock
         subsys_etile_tod_reset.out_reset                         etile_10gbe_rx_slave_tod.csr_reset
         subsys_etile_tod_reset.out_reset                         etile_10gbe_rx_slave_tod.period_clock_reset

         subsys_etile_10gbe_tod_tx_period_slave_clk.out_clk       etile_10gbe_tx_slave_tod.period_clock
         subsys_etile_10gbe_tod_rx_period_slave_clk.out_clk       etile_10gbe_rx_slave_tod.period_clock

         subsys_etile_10gbe_tod_tx_period_slave_clk.out_clk       subsys_etile_tod_tx_reset.clk
         subsys_etile_10gbe_tod_rx_period_slave_clk.out_clk       subsys_etile_tod_rx_reset.clk
         subsys_etile_tod_tx_reset.out_reset                      etile_10gbe_tx_slave_tod.period_clock_reset

         subsys_etile_tod_rx_reset.out_reset                      etile_10gbe_rx_slave_tod.period_clock_reset
         etile_tx_10gbe_tod_load_off_64b.time_of_day_load         etile_10gbe_tx_slave_tod.time_of_day_64b_load
         etile_rx_10gbe_tod_load_off_64b.time_of_day_load         etile_10gbe_rx_slave_tod.time_of_day_64b_load
         etile_10gbe_tx_tod_sync.tod_slave_data                   etile_10gbe_tx_slave_tod.time_of_day_96b_load
         etile_10gbe_rx_tod_sync.tod_slave_data                   etile_10gbe_rx_slave_tod.time_of_day_96b_load

         subsys_etile_tod_master_clk.out_clk                      etile_10gbe_tx_tod_sync.clk_master
         subsys_etile_tod_reset.out_reset                         etile_10gbe_tx_tod_sync.reset_master
         subsys_etile_tod_reset.out_reset                         etile_10gbe_tx_tod_sync.reset_slave

         subsys_etile_10gbe_tod_tx_period_slave_clk.out_clk       etile_10gbe_tx_tod_sync.clk_slave
         subsys_etile_tod_tx_reset.out_reset                      etile_10gbe_tx_tod_sync.reset_slave
         subsys_etile_tod_sync_10gbe_sampling_clk.out_clk         etile_10gbe_tx_tod_sync.clk_sampling
         start_tod_sync_0.tx_tod_10gbe_start_tod_sync             etile_10gbe_tx_tod_sync.start_tod_sync

         subsys_etile_10gbe_tod_rx_period_slave_clk.out_clk       etile_10gbe_rx_tod_sync.clk_slave
         subsys_etile_tod_master_clk.out_clk                      etile_10gbe_rx_tod_sync.clk_master
         subsys_etile_tod_reset.out_reset                         etile_10gbe_rx_tod_sync.reset_master
         subsys_etile_tod_reset.out_reset                         etile_10gbe_rx_tod_sync.reset_slave
         subsys_etile_tod_rx_reset.out_reset                      etile_10gbe_rx_tod_sync.reset_slave
         subsys_etile_tod_sync_10gbe_sampling_clk.out_clk         etile_10gbe_rx_tod_sync.clk_sampling
         start_tod_sync_0.rx_tod_10gbe_start_tod_sync             etile_10gbe_rx_tod_sync.start_tod_sync
        "
}

if {$hps_etile_1588_25gbe_en == 1 && $hps_etile_1588_10gbe_en == 1} {
connect "subsys_etile_tod_csrclk.out_clk                          tod_25g_10g_enable_pio_0.clk
         subsys_etile_tod_reset.out_reset                         tod_25g_10g_enable_pio_0.reset
         subsys_etile_tod_csrclk.out_clk                          address_span_25g10g.clock
         subsys_etile_tod_reset.out_reset                         address_span_25g10g.reset
         tod_mux_0.sel                                            tod_25g_10g_enable_pio_0.external_connection
         etile_25gbe_tx_slave_tod.time_of_day_96b		  tod_mux_0.tx_tod25g
         etile_25gbe_rx_slave_tod.time_of_day_96b     		  tod_mux_0.rx_tod25g
         etile_10gbe_tx_slave_tod.time_of_day_96b     		  tod_mux_0.tx_tod10g
         etile_10gbe_rx_slave_tod.time_of_day_96b     		  tod_mux_0.rx_tod10g
        "
}

if {$hps_etile_1588_25gbe_en == 1 && $hps_etile_1588_10gbe_en == 1} {
connect_map "subsys_etile_tod_csr.m0                       address_span_25g10g.windowed_slave  0x00
             subsys_etile_tod_csr.m0                       address_span_25g10g.cntl            0x80
             subsys_etile_tod_csr.m0                       tod_25g_10g_enable_pio_0.s1         0xC0
             "

connect_map "address_span_25g10g.expanded_master           etile_25gbe_tx_slave_tod.csr        0x00
             address_span_25g10g.expanded_master           etile_25gbe_rx_slave_tod.csr        0x40
             address_span_25g10g.expanded_master           etile_10gbe_tx_slave_tod.csr        0x80
             address_span_25g10g.expanded_master           etile_10gbe_rx_slave_tod.csr        0xC0
            "

} elseif {$hps_etile_1588_25gbe_en == 1} {
connect_map "subsys_etile_tod_csr.m0                       etile_25gbe_tx_slave_tod.csr        0x00
             subsys_etile_tod_csr.m0                       etile_25gbe_rx_slave_tod.csr        0x40
             "

} elseif {$hps_etile_1588_10gbe_en == 1} {
connect_map "subsys_etile_tod_csr.m0                       etile_10gbe_tx_slave_tod.csr        0x00
             subsys_etile_tod_csr.m0                       etile_10gbe_rx_slave_tod.csr        0x40
             "
}

#Exported Interfaces

export subsys_etile_tod_csrclk                        in_clk                  clk
export subsys_etile_tod_reset                         in_reset                reset
export subsys_etile_tod_csr                           s0                      csr
export subsys_etile_tod_master_clk                    in_clk                  master_todclk
export subsys_etile_tod_tx_reset                      in_reset                tod_tx_reset
export subsys_etile_tod_rx_reset                      in_reset                tod_rx_reset

if {$hps_etile_1588_25gbe_en == 1 && $hps_etile_1588_10gbe_en == 1} {
export tod_mux_0                                      tx_tod_out              tx_slave_time_of_day_96b
export tod_mux_0                                      rx_tod_out              rx_slave_time_of_day_96b
} elseif {$hps_etile_1588_25gbe_en == 1} {
export etile_25gbe_tx_slave_tod                       time_of_day_96b         tx_slave_time_of_day_96b
export etile_25gbe_rx_slave_tod                       time_of_day_96b         rx_slave_time_of_day_96b
} elseif {$hps_etile_1588_10gbe_en == 1} {
export etile_10gbe_tx_slave_tod                       time_of_day_96b         tx_slave_time_of_day_96b
export etile_10gbe_rx_slave_tod                       time_of_day_96b         rx_slave_time_of_day_96b
}

if {$hps_etile_1588_25gbe_en == 1} {
export subsys_etile_tod_sync_25gbe_sampling_clk       in_clk                  sampling_25gbe_clk
export subsys_etile_25gbe_tod_tx_period_slave_clk     in_clk                  tx_25gbe_period_slave_clk
export subsys_etile_25gbe_tod_rx_period_slave_clk     in_clk                  rx_25gbe_period_slave_clk
export etile_25gbe_tx_tod_sync                        tod_master_data         tx_25gbe_slave_tod
export etile_25gbe_rx_tod_sync                        tod_master_data         rx_25gbe_slave_tod
}

if {$hps_etile_1588_10gbe_en == 1} {
export subsys_etile_tod_sync_10gbe_sampling_clk       in_clk                  sampling_10gbe_clk
export subsys_etile_10gbe_tod_rx_period_slave_clk     in_clk                  rx_10gbe_period_slave_clk
export subsys_etile_10gbe_tod_tx_period_slave_clk     in_clk                  tx_10gbe_period_slave_clk
export etile_10gbe_tx_tod_sync                        tod_master_data         tx_10gbe_slave_tod
export etile_10gbe_rx_tod_sync                        tod_master_data         rx_10gbe_slave_tod
}

sync_sysinfo_parameters

save_system ${subsys_name}.qsys
