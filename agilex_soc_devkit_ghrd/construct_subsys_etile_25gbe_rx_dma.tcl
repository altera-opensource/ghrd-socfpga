#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2022 Intel Corporation.
#
#****************************************************************************
#
# This script construct subsystem of Etile 25GbE 1588 RX DMA for higher level integration
# The GHRD create_ghrd_qsys.tcl will call each of those subsystem construct script
# automatically based on the corresponding parameter argument defined
#
#****************************************************************************

source ./arguments_solver.tcl
source ./utils.tcl
set subsys_name subsys_etile_25gbe_rx_dma

package require -exact qsys 19.1

create_system $subsys_name

set_project_property DEVICE_FAMILY $device_family
set_project_property DEVICE $device
set_validation_property AUTOMATIC_VALIDATION false

add_component_param "altera_clock_bridge rx_dma_clock
                     IP_FILE_PATH ip/$subsys_name/rx_dma_clock.ip
                     NUM_CLOCK_OUTPUTS 1
                     EXPLICIT_CLOCK_RATE 201416016
                     "

add_component_param "altera_clock_bridge rx_dma_etile_clock
                     IP_FILE_PATH ip/$subsys_name/rx_dma_etile_clock.ip
                     NUM_CLOCK_OUTPUTS 1
                     EXPLICIT_CLOCK_RATE 402832031
                     "

add_component_param "altera_reset_bridge rx_dma_reset
                     IP_FILE_PATH ip/$subsys_name/rx_dma_reset.ip
                     ACTIVE_LOW_RESET 1
                     SYNCHRONOUS_EDGES both
                     NUM_RESET_OUTPUTS 1
                     USE_RESET_REQUEST 0
                     "

add_component_param "altera_avalon_mm_bridge rx_dma_csr
                     IP_FILE_PATH ip/$subsys_name/rx_dma_csr.ip
                     DATA_WIDTH 32
                     ADDRESS_WIDTH 32
                     USE_AUTO_ADDRESS_WIDTH 1
                     MAX_BURST_SIZE 1
                     MAX_PENDING_RESPONSES 1
                     "
add_component_param "altera_msgdma_prefetcher rx_dma_prefetcher
                     IP_FILE_PATH ip/$subsys_name/rx_dma_prefetcher.ip
                     DATA_WIDTH {128}
                     ENABLE_READ_BURST {1}
                     ENHANCED_FEATURES {1}
                     FIX_ADDRESS_WIDTH {34}
                     GUI_DESCRIPTOR_FIFO_DEPTH {128}
                     GUI_MAX_READ_BURST_COUNT {4}
                     USE_FIX_ADDRESS_WIDTH {1}
                     GUI_TIMESTAMP_WRITEBACK {1}
                     "

add_component_param "modular_sgdma_dispatcher rx_dma_dispatcher
                     IP_FILE_PATH ip/$subsys_name/rx_dma_dispatcher.ip
                     PREFETCHER_USE_CASE {1}
                     MODE {2}
                     DESCRIPTOR_FIFO_DEPTH {256}
                     ENHANCED_FEATURES {1}
                     "

add_component_param "dma_write_master rx_dma_write_master
                     IP_FILE_PATH ip/$subsys_name/rx_dma_write_master.ip
                     BURST_ENABLE {1}
                     DATA_WIDTH {128}
                     ERROR_ENABLE {1}
                     ERROR_WIDTH {6}
                     FIFO_DEPTH {256}
                     FIFO_SPEED_OPTIMIZATION {1}
                     GUI_BURST_WRAPPING_SUPPORT {1}
                     GUI_MAX_BURST_COUNT {16}
                     LENGTH_WIDTH {14}
                     PACKET_ENABLE {1}
                     TRANSFER_TYPE {Unaligned Accesses}
                     USE_FIX_ADDRESS_WIDTH {1}
                     FIX_ADDRESS_WIDTH {34}
                     WRITE_RESPONSE_ENABLE {1}
                     "

add_component_param "altera_msgdma_prefetcher_ts_insert rx_dma_ts_insert
                     IP_FILE_PATH ip/$subsys_name/rx_dma_ts_insert.ip
                     "

add_component_param "altera_avalon_dc_fifo rx_dma_ts_fifo
                     IP_FILE_PATH ip/$subsys_name/rx_dma_ts_fifo.ip
                     BACKPRESSURE_DURING_RESET {0}
                     BITS_PER_SYMBOL {96}
                     CHANNEL_WIDTH {0}
                     ENABLE_EXPLICIT_MAXCHANNEL {0}
                     ERROR_WIDTH {0}
                     EXPLICIT_MAXCHANNEL {0}
                     FIFO_DEPTH {2048}
                     RD_SYNC_DEPTH {3}
                     SYMBOLS_PER_BEAT {1}
                     SYNC_RESET {0}
                     USE_IN_FILL_LEVEL {0}
                     USE_OUT_FILL_LEVEL {0}
                     USE_PACKETS {0}
                     USE_SPACE_AVAIL_IF {0}
                     WR_SYNC_DEPTH {3}
                     "

add_component_param "altera_avalon_dc_fifo rx_dma_pkt_dc_fifo
                     IP_FILE_PATH ip/$subsys_name/rx_dma_pkt_dc_fifo.ip
                     BACKPRESSURE_DURING_RESET {1}
                     BITS_PER_SYMBOL {8}
                     CHANNEL_WIDTH {0}
                     ENABLE_EXPLICIT_MAXCHANNEL {0}
                     ERROR_WIDTH {6}
                     EXPLICIT_MAXCHANNEL {0}
                     FIFO_DEPTH {32}
                     RD_SYNC_DEPTH {3}
                     SYMBOLS_PER_BEAT {16}
                     SYNC_RESET {0}
                     USE_IN_FILL_LEVEL {0}
                     USE_OUT_FILL_LEVEL {0}
                     USE_PACKETS {1}
                     USE_SPACE_AVAIL_IF {0}
                     WR_SYNC_DEPTH {3}
                     "

#131072
add_component_param "altera_avalon_sc_fifo rx_dma_pkt_fifo
                     IP_FILE_PATH ip/$subsys_name/rx_dma_pkt_fifo.ip
                     BITS_PER_SYMBOL {8}
                     CHANNEL_WIDTH {0}
                     ERROR_WIDTH {6}
                     FIFO_DEPTH {16384}
                     SYMBOLS_PER_BEAT {16}
                     USE_ALMOST_EMPTY_IF {1}
                     USE_ALMOST_FULL_IF {1}
                     USE_FILL_LEVEL {1}
                     USE_MEMORY_BLOCKS {1}
                     USE_PACKETS {1}
                     USE_STORE_FORWARD {0}
                     "

add_component_param "altera_eth_fifo_pause_ctrl_adapter_hw rx_dma_pause_ctrl
                     IP_FILE_PATH ip/$subsys_name/rx_dma_pause_ctrl.ip
                     ETILE_HIP_PAUSE_EN {1}
                     "

add_component_param "eth_rx_timestamp_adapter rx_dma_timestamp_adapter
                     IP_FILE_PATH ip/$subsys_name/rx_dma_timestamp_adapter.ip
                     "

connect "rx_dma_clock.out_clk           rx_dma_reset.clk
         rx_dma_clock.out_clk           rx_dma_csr.clk
         rx_dma_clock.out_clk           rx_dma_prefetcher.Clock
         rx_dma_clock.out_clk           rx_dma_dispatcher.clock
         rx_dma_clock.out_clk           rx_dma_write_master.Clock
         rx_dma_clock.out_clk           rx_dma_ts_insert.clock
         rx_dma_etile_clock.out_clk     rx_dma_ts_fifo.in_clk
         rx_dma_clock.out_clk           rx_dma_ts_fifo.out_clk

         rx_dma_etile_clock.out_clk     rx_dma_pkt_dc_fifo.in_clk
         rx_dma_clock.out_clk           rx_dma_pkt_dc_fifo.out_clk

         rx_dma_etile_clock.out_clk     rx_dma_pkt_fifo.clk
         rx_dma_etile_clock.out_clk     rx_dma_pause_ctrl.clock
         rx_dma_etile_clock.out_clk     rx_dma_timestamp_adapter.clock

         rx_dma_reset.out_reset         rx_dma_csr.reset
         rx_dma_reset.out_reset         rx_dma_prefetcher.Clock_reset
         rx_dma_reset.out_reset         rx_dma_dispatcher.clock_reset
         rx_dma_reset.out_reset         rx_dma_write_master.Clock_reset
         rx_dma_reset.out_reset         rx_dma_ts_insert.reset
         rx_dma_reset.out_reset         rx_dma_ts_fifo.in_clk_reset
         rx_dma_reset.out_reset         rx_dma_ts_fifo.out_clk_reset

         rx_dma_reset.out_reset         rx_dma_pkt_dc_fifo.in_clk_reset
         rx_dma_reset.out_reset         rx_dma_pkt_dc_fifo.out_clk_reset

         rx_dma_reset.out_reset         rx_dma_pkt_fifo.clk_reset
         rx_dma_reset.out_reset         rx_dma_pause_ctrl.reset
         rx_dma_reset.out_reset         rx_dma_timestamp_adapter.reset
         "

connect_map "rx_dma_csr.m0       rx_dma_prefetcher.Csr   0x0
             rx_dma_csr.m0       rx_dma_dispatcher.CSR   0x20
             rx_dma_csr.m0       rx_dma_pkt_fifo.csr     0x40
             "

connect "rx_dma_prefetcher.Descriptor_Write_Dispatcher_Source  rx_dma_dispatcher.Descriptor_Sink
         rx_dma_ts_insert.src_response                         rx_dma_prefetcher.Response_Sink
         rx_dma_dispatcher.Response_Source                     rx_dma_ts_insert.snk_response
         rx_dma_dispatcher.Write_Command_Source                rx_dma_write_master.Command_Sink
         rx_dma_write_master.Response_Source                   rx_dma_dispatcher.Write_Response_Sink
         rx_dma_ts_fifo.out                                    rx_dma_ts_insert.snk_timestamp
         rx_dma_pkt_fifo.almost_full                           rx_dma_pause_ctrl.almost_full_sink
         rx_dma_pkt_fifo.almost_empty                          rx_dma_pause_ctrl.almost_empty_sink
         rx_dma_timestamp_adapter.src_timestamp                rx_dma_ts_fifo.in
         rx_dma_pkt_fifo.out                                   rx_dma_pkt_dc_fifo.in
         rx_dma_pkt_dc_fifo.out                                rx_dma_write_master.Data_Sink
         "

# exported interfaces
export rx_dma_clock              in_clk                        dma_clk
export rx_dma_etile_clock        in_clk                        etile_clk
export rx_dma_reset              in_reset                      reset
export rx_dma_csr                s0                            csr
export rx_dma_prefetcher         Descriptor_Read_Master        prefetcher_read_master
export rx_dma_prefetcher         Descriptor_Write_Master       prefetcher_write_master
export rx_dma_prefetcher         Csr_Irq                       irq
export rx_dma_write_master       Data_Write_Master             write_master
export rx_dma_pkt_fifo           in                            pktin
export rx_dma_pause_ctrl         pause_ctrl_etile_src_data     pause_ctrl_etile
export rx_dma_timestamp_adapter  timestamp                     timestamp

# interconnect requirements
set_domain_assignment {$system} {qsys_mm.clockCrossingAdapter} {AUTO}
set_domain_assignment {$system} {qsys_mm.maxAdditionalLatency} {4}
set_domain_assignment {$system} {qsys_mm.enableEccProtection} {FALSE}
set_domain_assignment {$system} {qsys_mm.insertDefaultSlave} {FALSE}
set_domain_assignment {$system} {qsys_mm.burstAdapterImplementation} {PER_BURST_TYPE_CONVERTER}

sync_sysinfo_parameters

save_system ${subsys_name}.qsys
