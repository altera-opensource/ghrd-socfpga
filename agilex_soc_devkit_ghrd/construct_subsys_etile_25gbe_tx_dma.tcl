#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2022 Intel Corporation.
#
#****************************************************************************
#
# This script construct subsystem of Etile 25GbE 1588 TX DMA for higher level integration
# The GHRD create_ghrd_qsys.tcl will call each of those subsystem construct script
# automatically based on the corresponding parameter argument defined
#
#****************************************************************************

source ./arguments_solver.tcl
source ./utils.tcl
set subsys_name subsys_etile_25gbe_tx_dma

package require -exact qsys 19.1

create_system $subsys_name

set_project_property DEVICE_FAMILY $device_family
set_project_property DEVICE $device
set_validation_property AUTOMATIC_VALIDATION false

add_component_param "altera_clock_bridge tx_dma_clock
                     IP_FILE_PATH ip/$subsys_name/tx_dma_clock.ip
                     NUM_CLOCK_OUTPUTS 1
                     EXPLICIT_CLOCK_RATE 201416016
                     "

add_component_param "altera_clock_bridge tx_dma_etile_clock
                     IP_FILE_PATH ip/$subsys_name/tx_dma_etile_clock.ip
                     NUM_CLOCK_OUTPUTS 1
                     EXPLICIT_CLOCK_RATE 402832031
                     "

add_component_param "altera_reset_bridge tx_dma_reset
                     IP_FILE_PATH ip/$subsys_name/tx_dma_reset.ip
                     ACTIVE_LOW_RESET 1
                     SYNCHRONOUS_EDGES both
                     NUM_RESET_OUTPUTS 1
                     USE_RESET_REQUEST 0
                     "

add_component_param "altera_avalon_mm_bridge tx_dma_csr
                     IP_FILE_PATH ip/$subsys_name/tx_dma_csr.ip
                     DATA_WIDTH 32
                     ADDRESS_WIDTH 32
                     USE_AUTO_ADDRESS_WIDTH 1
                     MAX_BURST_SIZE 1
                     MAX_PENDING_RESPONSES 1
                     "

add_component_param "altera_msgdma_prefetcher tx_dma_prefetcher
                     IP_FILE_PATH ip/$subsys_name/tx_dma_prefetcher.ip
                     DATA_WIDTH {128}
                     ENABLE_READ_BURST {1}
                     ENHANCED_FEATURES {1}
                     FIX_ADDRESS_WIDTH {34}
                     GUI_DESCRIPTOR_FIFO_DEPTH {128}
                     GUI_MAX_READ_BURST_COUNT {4}
                     USE_FIX_ADDRESS_WIDTH {1}
                     GUI_TIMESTAMP_WRITEBACK {1}
                     "

add_component_param "modular_sgdma_dispatcher tx_dma_dispatcher
                     IP_FILE_PATH ip/$subsys_name/tx_dma_dispatcher.ip
                     PREFETCHER_USE_CASE {1}
                     MODE {1}
                     DESCRIPTOR_FIFO_DEPTH {128}
                     ENHANCED_FEATURES {1}
                     "

add_component_param "dma_read_master tx_dma_read_master
                     IP_FILE_PATH ip/$subsys_name/tx_dma_read_master.ip
                     BURST_ENABLE {1}
                     DATA_WIDTH {128}
                     ERROR_ENABLE {1}
                     ERROR_WIDTH {1}
                     FIFO_DEPTH {256}
                     FIFO_SPEED_OPTIMIZATION {1}
                     GUI_BURST_WRAPPING_SUPPORT {1}
                     GUI_MAX_BURST_COUNT {16}
                     LENGTH_WIDTH {14}
                     PACKET_ENABLE {1}
                     TRANSFER_TYPE {Unaligned Accesses}
                     USE_FIX_ADDRESS_WIDTH {1}
                     FIX_ADDRESS_WIDTH {34}
                     "

add_component_param "altera_msgdma_prefetcher_ts_insert tx_dma_timestamp_insert
                     IP_FILE_PATH ip/$subsys_name/tx_dma_timestamp_insert.ip
                     "

add_component_param "altera_avalon_dc_fifo tx_dma_ts_fifo
                     IP_FILE_PATH ip/$subsys_name/tx_dma_ts_fifo.ip
                     BACKPRESSURE_DURING_RESET {0}
                     BITS_PER_SYMBOL {104}
                     CHANNEL_WIDTH {0}
                     ENABLE_EXPLICIT_MAXCHANNEL {0}
                     ERROR_WIDTH {0}
                     EXPLICIT_MAXCHANNEL {0}
                     FIFO_DEPTH {256}
                     RD_SYNC_DEPTH {3}
                     SYMBOLS_PER_BEAT {1}
                     SYNC_RESET {0}
                     USE_IN_FILL_LEVEL {0}
                     USE_OUT_FILL_LEVEL {0}
                     USE_PACKETS {0}
                     USE_SPACE_AVAIL_IF {0}
                     WR_SYNC_DEPTH {3}
                     "

add_component_param "altera_avalon_dc_fifo tx_dma_tx_dc_fifo
                     IP_FILE_PATH ip/$subsys_name/tx_dma_tx_dc_fifo.ip
                     BACKPRESSURE_DURING_RESET {1}
                     BITS_PER_SYMBOL {8}
                     CHANNEL_WIDTH {0}
                     ENABLE_EXPLICIT_MAXCHANNEL {0}
                     ERROR_WIDTH {1}
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

add_component_param "altera_avalon_sc_fifo tx_dma_tx_fifo
                     IP_FILE_PATH ip/$subsys_name/tx_dma_tx_fifo.ip
                     BITS_PER_SYMBOL {8}
                     CHANNEL_WIDTH {0}
                     ERROR_WIDTH {1}
                     FIFO_DEPTH {4096}
                     SYMBOLS_PER_BEAT {8}
                     USE_FILL_LEVEL {1}
                     USE_MEMORY_BLOCKS {1}
                     USE_PACKETS {1}
                     USE_STORE_FORWARD {1}
                     "

add_component_param "altera_avalon_dc_fifo tx_dma_fingerprint_fifo
                     IP_FILE_PATH ip/$subsys_name/tx_dma_fingerprint_fifo.ip
                     BACKPRESSURE_DURING_RESET {0}
                     BITS_PER_SYMBOL {8}
                     CHANNEL_WIDTH {0}
                     ENABLE_EXPLICIT_MAXCHANNEL {0}
                     ERROR_WIDTH {0}
                     EXPLICIT_MAXCHANNEL {0}
                     FIFO_DEPTH {256}
                     RD_SYNC_DEPTH {3}
                     SYMBOLS_PER_BEAT {1}
                     SYNC_RESET {0}
                     USE_IN_FILL_LEVEL {0}
                     USE_OUT_FILL_LEVEL {0}
                     USE_PACKETS {0}
                     USE_SPACE_AVAIL_IF {0}
                     WR_SYNC_DEPTH {3}
                     "

add_component_param "eth_ts_fingerprint_compare tx_dma_fingerprint_compare
                     IP_FILE_PATH ip/$subsys_name/tx_dma_fingerprint_compare.ip
                     "

add_component_param "eth_tx_dma_timestamp_req tx_dma_timestamp_req
                     IP_FILE_PATH ip/$subsys_name/tx_dma_timestamp_req.ip
                     BITSPERSYMBOL {8}
                     EMPTY_WIDTH {3}
                     ERROR_WIDTH {1}
                     SYMBOLSPERBEAT {8}
                     "

add_component_param "eth_tx_timestamp_adapter tx_dma_timestamp_adapter
                     IP_FILE_PATH ip/$subsys_name/tx_dma_timestamp_adapter.ip
                     "

connect "tx_dma_clock.out_clk           tx_dma_reset.clk
         tx_dma_clock.out_clk           tx_dma_csr.clk
         tx_dma_clock.out_clk           tx_dma_prefetcher.Clock
         tx_dma_clock.out_clk           tx_dma_dispatcher.clock
         tx_dma_clock.out_clk           tx_dma_read_master.Clock
         tx_dma_clock.out_clk           tx_dma_timestamp_insert.clock
         tx_dma_etile_clock.out_clk     tx_dma_ts_fifo.in_clk
         tx_dma_clock.out_clk           tx_dma_ts_fifo.out_clk

         tx_dma_clock.out_clk           tx_dma_tx_dc_fifo.in_clk
         tx_dma_etile_clock.out_clk     tx_dma_tx_dc_fifo.out_clk

         tx_dma_etile_clock.out_clk     tx_dma_tx_fifo.clk
         tx_dma_etile_clock.out_clk     tx_dma_timestamp_req.clock
         tx_dma_etile_clock.out_clk     tx_dma_timestamp_adapter.clock

         tx_dma_etile_clock.out_clk     tx_dma_fingerprint_fifo.in_clk
         tx_dma_clock.out_clk           tx_dma_fingerprint_fifo.out_clk
         tx_dma_clock.out_clk           tx_dma_fingerprint_compare.clock

         tx_dma_reset.out_reset         tx_dma_csr.reset
         tx_dma_reset.out_reset         tx_dma_prefetcher.Clock_reset
         tx_dma_reset.out_reset         tx_dma_dispatcher.clock_reset
         tx_dma_reset.out_reset         tx_dma_read_master.Clock_reset
         tx_dma_reset.out_reset         tx_dma_timestamp_insert.reset
         tx_dma_reset.out_reset         tx_dma_ts_fifo.in_clk_reset
         tx_dma_reset.out_reset         tx_dma_ts_fifo.out_clk_reset
         tx_dma_reset.out_reset         tx_dma_tx_dc_fifo.in_clk_reset
         tx_dma_reset.out_reset         tx_dma_tx_dc_fifo.out_clk_reset
         tx_dma_reset.out_reset         tx_dma_tx_fifo.clk_reset
         tx_dma_reset.out_reset         tx_dma_fingerprint_fifo.in_clk_reset
         tx_dma_reset.out_reset         tx_dma_fingerprint_fifo.out_clk_reset
         tx_dma_reset.out_reset         tx_dma_fingerprint_compare.reset
         tx_dma_reset.out_reset         tx_dma_timestamp_req.reset
         tx_dma_reset.out_reset         tx_dma_timestamp_adapter.reset
         "

connect_map "tx_dma_csr.m0       tx_dma_prefetcher.Csr   0x0
             tx_dma_csr.m0       tx_dma_dispatcher.CSR   0x20
             tx_dma_csr.m0       tx_dma_tx_fifo.csr      0x40
             "

connect "tx_dma_prefetcher.Descriptor_Write_Dispatcher_Source   tx_dma_dispatcher.Descriptor_Sink
         tx_dma_timestamp_insert.src_response                   tx_dma_prefetcher.Response_Sink
         tx_dma_dispatcher.Response_Source                      tx_dma_timestamp_insert.snk_response
         tx_dma_dispatcher.Read_Command_Source                  tx_dma_read_master.Command_Sink
         tx_dma_read_master.Data_Source                         tx_dma_tx_dc_fifo.in
         tx_dma_tx_dc_fifo.out                                  tx_dma_tx_fifo.in
         tx_dma_read_master.Response_Source                     tx_dma_dispatcher.Read_Response_Sink
         tx_dma_ts_fifo.out                                     tx_dma_fingerprint_compare.timestamp_fp
         tx_dma_tx_fifo.out                                     tx_dma_timestamp_req.pktin
         tx_dma_fingerprint_fifo.out                            tx_dma_fingerprint_compare.fingerprint
         tx_dma_fingerprint_compare.timestamp                   tx_dma_timestamp_insert.snk_timestamp
         tx_dma_timestamp_req.fingerprint                       tx_dma_fingerprint_fifo.in
         tx_dma_timestamp_adapter.aso_timestamp_fp              tx_dma_ts_fifo.in
         "


# exported interfaces
export tx_dma_clock               in_clk                        dma_clk
export tx_dma_etile_clock         in_clk                        etile_clk
export tx_dma_reset               in_reset                      reset
export tx_dma_csr                 s0                            csr
export tx_dma_prefetcher          Descriptor_Read_Master        prefetcher_read_master
export tx_dma_prefetcher          Descriptor_Write_Master       prefetcher_write_master
export tx_dma_prefetcher          Csr_Irq                       irq
export tx_dma_read_master         Data_Read_Master              read_master
export tx_dma_timestamp_req       pktout                        pktout
export tx_dma_timestamp_req       timestamp_request             timestamp_req
export tx_dma_timestamp_adapter   timestamp                     timestamp

# interconnect requirements
set_domain_assignment {$system} {qsys_mm.clockCrossingAdapter} {AUTO}
set_domain_assignment {$system} {qsys_mm.maxAdditionalLatency} {4}
set_domain_assignment {$system} {qsys_mm.enableEccProtection} {FALSE}
set_domain_assignment {$system} {qsys_mm.insertDefaultSlave} {FALSE}
set_domain_assignment {$system} {qsys_mm.burstAdapterImplementation} {PER_BURST_TYPE_CONVERTER}

sync_sysinfo_parameters

save_system ${subsys_name}.qsys
