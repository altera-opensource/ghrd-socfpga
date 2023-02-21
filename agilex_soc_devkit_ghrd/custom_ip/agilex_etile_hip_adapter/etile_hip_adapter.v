//****************************************************************************
//
// SPDX-License-Identifier: MIT-0
// Copyright(c) 2001-2022 Intel Corporation.
//
//****************************************************************************
//
// etile_hip_adapter
// This component is an conduit adapther for ETILE HIP IP
//****************************************************************************

module etile_hip_adapter #(
   parameter ETH_RECONFIG_ADDRESS_WIDTH = 19
)(

// eth_reconfig
    input                                     reconfig_clock,                // clock
    input                                     reconfig_reset,                // reset
// Terminted with 0 in Example design.Not used by driver.
/*AVMM Slave for eth_reconfig
    input  [ETH_RECONFIG_ADDRESS_WIDTH-1:0]   eth_reconfig_address,          // avalon_slave
    input                                     eth_reconfig_read,             // avalon_slave
    input                                     eth_reconfig_write,            // avalon_slave
    input  [31:0]                             eth_reconfig_writedata,        // avalon_slave
    output [31:0]                             eth_reconfig_readdata,         // avalon_slave
    output                                    eth_reconfig_readdatavalid,    // avalon_slave
    output                                    eth_reconfig_waitrequest,      // avalon_slave
*/
//Conduits interface for eth_reconfig
    output [21:0]                             i_eth_reconfig_addr,           // conduit
    output                                    i_eth_reconfig_read,           // conduit
    output                                    i_eth_reconfig_write,          // conduit
    output [31:0]                             i_eth_reconfig_writedata,      // conduit
    input  [31:0]                             o_eth_reconfig_readdata,       // conduit
    input                                     o_eth_reconfig_readdata_valid, // conduit
    input                                     o_eth_reconfig_waitrequest,    // conduit
// rsfec reconfig
    //AVMM Slave for rsfec_reconfig
    input  [10:0]                             rsfec_reconfig_address,        // avalon_slave
    input                                     rsfec_reconfig_read,           // avalon_slave
    input                                     rsfec_reconfig_write,          // avalon_slave
    input  [7:0]                              rsfec_reconfig_writedata,      // avalon_slave
    output [7:0]                              rsfec_reconfig_readdata,       // avalon_slave
    output                                    rsfec_reconfig_waitrequest,    // avalon_slave
//Conduits interface for rsfec_reconfig
    output [10:0]                             i_rsfec_reconfig_addr,         // conduit
    output                                    i_rsfec_reconfig_read,         // conduit
    output                                    i_rsfec_reconfig_write,        // conduit
    output [7:0]                              i_rsfec_reconfig_writedata,    // conduit
    input  [7:0]                              o_rsfec_reconfig_readdata,     // conduit
    input                                     o_rsfec_reconfig_waitrequest,  // conduit
// ptp reconfig
// Terminted with 0 in Example design.Not used by driver.
/*AVMM Slave for ptp_reconfig
    input  [ETH_RECONFIG_ADDRESS_WIDTH-1:0]   ptp_reconfig_address,          // avalon_slave
    input                                     ptp_reconfig_read,             // avalon_slave
    input                                     ptp_reconfig_write,            // avalon_slave
    input  [7:0]                              ptp_reconfig_writedata,        // avalon_slave
    output [7:0]                              ptp_reconfig_readdata,         // avalon_slave
    output                                    ptp_reconfig_waitrequest,      // avalon_slave
*/
//Conduits interface for ptp_reconfig
    output [38:0]                             i_ptp_reconfig_address,        // conduit
    output [1:0]                              i_ptp_reconfig_read,           // conduit
    output [1:0]                              i_ptp_reconfig_write,          // conduit
    output [15:0]                             i_ptp_reconfig_writedata,      // conduit
    input  [15:0]                             o_ptp_reconfig_readdata,       // conduit
    input  [1:0]                              o_ptp_reconfig_waitrequest,    // conduit
    output                                    clk_pll_div64,                 // clock
    input  [2:0]                              o_clk_pll_div64,               // conduit
    output                                    clk_pll_div66,                 // clock
    input  [2:0]                              o_clk_pll_div66,               // conduit
    output                                    clk_rec_div64,                 // clock
    input  [2:0]                              o_clk_rec_div64,               // conduit
    output                                    clk_rec_div66,                 // clock
    input  [2:0]                              o_clk_rec_div66,               // conduit
    input                                     sl_rst_rx,
// xcvr reconfig
    //AVMM Slave for xcvr_reconfig
    input  [ETH_RECONFIG_ADDRESS_WIDTH-1:0]   xcvr_reconfig_address,         // avalon_slave
    input                                     xcvr_reconfig_read,            // avalon_slave
    input                                     xcvr_reconfig_write,           // avalon_slave
    input  [7:0]                              xcvr_reconfig_writedata,       // avalon_slave
    output [7:0]                              xcvr_reconfig_readdata,        // avalon_slave
    output                                    xcvr_reconfig_waitrequest,     // avalon_slave
//Conduits interface for xcvr_reconfig
    output [ETH_RECONFIG_ADDRESS_WIDTH-1:0]   i_xcvr_reconfig_address,        // conduit
    output                                    i_xcvr_reconfig_read,           // conduit
    output                                    i_xcvr_reconfig_write,          // conduit
    output [7:0]                              i_xcvr_reconfig_writedata,      // conduit
    input  [7:0]                              o_xcvr_reconfig_readdata,       // conduit
    input                                     o_xcvr_reconfig_waitrequest, // conduit
// sl eth reconfig
    //AVMM Slave for eth_reconfig
    input  [11:0]                             sl_eth_reconfig_address,       // avalon_slave
    input                                     sl_eth_reconfig_read,          // avalon_slave
    input                                     sl_eth_reconfig_write,         // avalon_slave
    input  [31:0]                             sl_eth_reconfig_writedata,     // avalon_slave
    output [31:0]                             sl_eth_reconfig_readdata,      // avalon_slave
    output                                    sl_eth_reconfig_readdatavalid, // avalon_slave
    output                                    sl_eth_reconfig_waitrequest,   // avalon_slave
//Conduits interface for eth_reconfig
    output [ETH_RECONFIG_ADDRESS_WIDTH-1:0]   i_sl_eth_reconfig_addr,           // conduit
    output                                    i_sl_eth_reconfig_read,           // conduit
    output                                    i_sl_eth_reconfig_write,          // conduit
    output [31:0]                             i_sl_eth_reconfig_writedata,      // conduit
    input  [31:0]                             o_sl_eth_reconfig_readdata,       // conduit
    input                                     o_sl_eth_reconfig_readdata_valid, // conduit
    input                                     o_sl_eth_reconfig_waitrequest,    // conduit
// i_sl_stats_snapshot
    output                                    i_sl_stats_snapshot,
// AV ST TX
    output                                    tx_avst_ready,
    input                                     tx_avst_valid,
    input [63:0]                              tx_avst_data,
    input                                     tx_avst_startofpacket,
    input                                     tx_avst_endofpacket,
    input [2:0]                               tx_avst_empty,
    input                                     tx_avst_error,
// AV ST RX
    input                                     rx_avst_ready,
    output                                    rx_avst_valid,
    output [63:0]                             rx_avst_data,
    output                                    rx_avst_startofpacket,
    output                                    rx_avst_endofpacket,
    output [2:0]                              rx_avst_empty,
    output [5:0]                              rx_avst_error,
// NON PCS TX
    input                                     o_sl_tx_ready,
    output                                    i_sl_tx_valid,
    output  [63:0]                            i_sl_tx_data,
    output                                    i_sl_tx_startofpacket,
    output                                    i_sl_tx_endofpacket,
    output  [2:0]                             i_sl_tx_empty,
    output                                    i_sl_tx_error,
    output                                    i_sl_tx_skip_crc,
// NON PCS RX
    input                                     o_sl_rx_valid,
    input   [63:0]                            o_sl_rx_data,
    input                                     o_sl_rx_startofpacket,
    input                                     o_sl_rx_endofpacket,
    input   [2:0]                             o_sl_rx_empty,
    input   [5:0]                             o_sl_rx_error,
    input   [39:0]                            o_sl_rxstatus_data,
    input                                     o_sl_rxstatus_valid,

/*  output  [39:0]                            sl_rxstatus_data,
    output                                    sl_rxstatus_valid,
*/
// SL CLK & RST
    input                                     sl_clk_tx,
    input                                     sl_clk_tx_tod,
    input                                     sl_rst_tx,
    input                                     sl_clk_rx,
    input                                     sl_clk_rx_tod,      // Advance mode only. 390.625MHz
    input                                     clk_ptp_sample,     // Advance mode only. 114.285714MHz

    output                                    i_sl_clk_tx,
    output                                    i_sl_clk_tx_tod,    // Advance mode only. 390.625MHz
    output                                    i_sl_clk_rx,
    output                                    i_sl_clk_rx_tod,    // Advance mode only. 390.625MHz
    output                                    i_clk_ptp_sample,   // Advance mode only. 114.285714MHz
    output                                    i_sl_tx_rst_n,
    output                                    i_sl_rx_rst_n,
// Reconfig resets
//  output                                    i_csr_rst_n,
    input                                     sl_csr_rst_n,
    output                                    i_sl_csr_rst_n,
    output                                    i_reconfig_reset,
// s1_pfc_ports
    output  [7:0]                             i_sl_tx_pfc,
    input   [7:0]                             o_sl_rx_pfc,
    output  [95:0]                            i_sl_ptp_tx_tod,    // Advance mode only. PTP TX TOD
    input   [95:0]                            sl_ptp_tx_tod,      // Advance mode only. PTP TX TOD
    output  [95:0]                            i_sl_ptp_rx_tod,    // Advance mode only. PTP RX TOD
    input   [95:0]                            sl_ptp_rx_tod,      // Advance mode only. PTP RX TOD
// sl_ptp_ports
    output  [7:0]                             i_sl_ptp_fp,
    output                                    i_sl_ptp_ts_req,
    input   [95:0]                            o_sl_ptp_ets,
    input   [7:0]                             o_sl_ptp_ets_fp,
    input                                     o_sl_ptp_ets_valid,
    input   [95:0]                            o_sl_ptp_rx_its,
    input                                     o_sl_rx_ptp_ready,
    input                                     o_sl_tx_ptp_ready,
// timestamp_request
    input                                     tstamp_req_valid,
    input   [7:0]                             tstamp_req_fingerprint,
// tx_timestamp
    output                                    tx_timestamp_fp_valid,
    output  [95:0]                            tx_timestamp_fp_data,
    output  [7:0]                             tx_timestamp_fp_fingerprint,
// rx_timestamp
    output                                    rx_timestamp_valid,
    output  [95:0]                            rx_timestamp_data,
// sl_ptp_1step_ports
    output  [15:0]                            i_sl_ptp_cf_offset,
    output  [15:0]                            i_sl_ptp_csum_offset,
    output  [15:0]                            i_sl_ptp_eb_offset,
    output                                    i_sl_ptp_ins_cf,
    output                                    i_sl_ptp_ins_ets,
    output                                    i_sl_ptp_ts_format,
    output  [15:0]                            i_sl_ptp_ts_offset,
    output  [95:0]                            i_sl_ptp_tx_its,
    output                                    i_sl_ptp_update_eb,
    output                                    i_sl_ptp_zero_csum,
// ehip debug and status
    input                                     o_cdr_lock,
    input                                     o_tx_pll_locked,
    input                                     o_sl_tx_lanes_stable,
    input                                     o_sl_rx_pcs_ready,
    input                                     o_sl_ehip_ready,
    input                                     o_sl_rx_block_lock,
    input                                     o_sl_local_fault_status,
    input                                     o_sl_remote_fault_status,
    input                                     dma_clock,
    input                                     iopll_clk_dma_locked,
    output  [12:0]                            ehip_debug_status,
    output                                    sl_tx_lanes_stable_reset_n,
    output                                    sl_rx_pcs_ready_reset_n,
    output                                    tx_pll_locked_reset_n,
    output                                    clk_dma_lock_reset_n,
    input                                     ptp_sampling_clk_iopll_locked,
    input                                     tod_sync_sampling_25gbe_clk_iopll_locked,
    input                                     tod_sync_sampling_10gbe_clk_iopll_locked
);

reg                                           sl_csr_rst_n_int;
reg [1:0]                                     sl_csr_rst_n_sync;
reg [12:0]                                    debug_status_reg;
wire                                          tod_sync_sampling_clk_iopll_locked;

//assign i_clk_ref                            = clk_ref;
assign clk_pll_div64                          = o_clk_pll_div64[1];
assign clk_pll_div66                          = o_clk_pll_div66[0];
assign clk_rec_div64                          = o_clk_rec_div64[1];
assign clk_rec_div66                          = o_clk_rec_div66[0];

//eth_reconfig
assign i_eth_reconfig_addr                    = 19'd0;
assign i_eth_reconfig_read                    = 1'd0;
assign i_eth_reconfig_write                   = 1'd0;
assign i_eth_reconfig_writedata               = 32'd0;

//rsfec_reconfig
assign i_rsfec_reconfig_addr                  = rsfec_reconfig_address;
assign i_rsfec_reconfig_read                  = rsfec_reconfig_read;
assign i_rsfec_reconfig_write                 = rsfec_reconfig_write;
assign i_rsfec_reconfig_writedata             = rsfec_reconfig_writedata;
assign rsfec_reconfig_readdata                = o_rsfec_reconfig_readdata;
assign rsfec_reconfig_waitrequest             = o_rsfec_reconfig_waitrequest;

//ptp_reconfig
assign i_ptp_reconfig_address                 = 38'd0;
assign i_ptp_reconfig_read                    = 2'd0;
assign i_ptp_reconfig_write                   = 2'd0;
assign i_ptp_reconfig_writedata               = 16'd0;

//xcvr_reconfig
assign i_xcvr_reconfig_address                = xcvr_reconfig_address;
assign i_xcvr_reconfig_read                   = xcvr_reconfig_read;
assign i_xcvr_reconfig_write                  = xcvr_reconfig_write;
assign i_xcvr_reconfig_writedata              = xcvr_reconfig_writedata;
assign xcvr_reconfig_readdata                 = o_xcvr_reconfig_readdata;
assign xcvr_reconfig_waitrequest              = o_xcvr_reconfig_waitrequest;

//eth_reconfig
assign i_sl_eth_reconfig_addr                 = {7'd0,sl_eth_reconfig_address};
assign i_sl_eth_reconfig_read                 = sl_eth_reconfig_read;
assign i_sl_eth_reconfig_write                = sl_eth_reconfig_write;
assign i_sl_eth_reconfig_writedata            = sl_eth_reconfig_writedata;
assign sl_eth_reconfig_readdata               = o_sl_eth_reconfig_readdata;
assign sl_eth_reconfig_readdatavalid          = o_sl_eth_reconfig_readdata_valid;
assign sl_eth_reconfig_waitrequest            = o_sl_eth_reconfig_waitrequest;

//i_sl_stats_snapshot
assign i_sl_stats_snapshot                    = 1'b0;

//AV ST TX
assign tx_avst_ready                          = o_sl_tx_ready;
assign i_sl_tx_valid                          = tx_avst_valid;
assign i_sl_tx_data                           = tx_avst_data;
assign i_sl_tx_startofpacket                  = tx_avst_startofpacket;
assign i_sl_tx_endofpacket                    = tx_avst_endofpacket;
assign i_sl_tx_empty                          = tx_avst_empty;
assign i_sl_tx_error                          = tx_avst_error;
assign i_sl_tx_skip_crc                       = 1'b0;

//AV ST RX
//assign                                      = rx_avst_ready;
assign rx_avst_valid                          = o_sl_rx_valid;
assign rx_avst_data                           = o_sl_rx_data;
assign rx_avst_startofpacket                  = o_sl_rx_startofpacket;
assign rx_avst_endofpacket                    = o_sl_rx_endofpacket;
assign rx_avst_empty                          = o_sl_rx_empty;
assign rx_avst_error                          = o_sl_rx_error;

// SL CLK & RST
assign i_sl_clk_tx                            = sl_clk_tx;
assign i_sl_tx_rst_n                          = 1'b1;               // Software control through regiseter if needed
assign i_sl_clk_tx_tod                        = sl_clk_tx_tod;      // Advance mode only.
assign i_sl_clk_rx                            = sl_clk_rx;
//assign i_sl_rx_rst_n                          = sl_rst_rx;
assign i_sl_rx_rst_n                          = 1'b1;               // Software control through regiseter if needed
assign i_sl_clk_rx_tod                        = sl_clk_rx_tod;      // Advance mode only.
assign i_clk_ptp_sample                       = clk_ptp_sample;    // Advance mode only.

// Etile CSR Reset
// - sl_csr_rst_n -> user reset + ninit_done
// - PLL lockeds
always @(posedge reconfig_clock or negedge sl_csr_rst_n)
begin
    if (sl_csr_rst_n == 1'b0) begin
        sl_csr_rst_n_sync                    <= 2'b0;
        sl_csr_rst_n_int                     <= 1'b0;
    end else begin
        //sl_csr_rst_n_sync[0]                 <= o_tx_pll_locked & ptp_sampling_clk_iopll_locked & tod_sync_sampling_clk_iopll_locked;
        sl_csr_rst_n_sync[0]                 <= o_tx_pll_locked & ptp_sampling_clk_iopll_locked & tod_sync_sampling_25gbe_clk_iopll_locked & tod_sync_sampling_10gbe_clk_iopll_locked;
        sl_csr_rst_n_sync[1]                 <= sl_csr_rst_n_sync[0];
        sl_csr_rst_n_int                     <= sl_csr_rst_n_sync[1];
    end
end

assign i_sl_csr_rst_n                        = sl_csr_rst_n_int;
assign i_reconfig_reset                      = reconfig_reset;
assign i_sl_tx_pfc                           = 8'h0;
assign i_sl_ptp_tx_tod                       = sl_ptp_tx_tod;   //Advance mode only.
assign i_sl_ptp_rx_tod                       = sl_ptp_rx_tod;   //Advance mode only.
assign i_sl_ptp_fp                           = tstamp_req_fingerprint;
assign i_sl_ptp_ts_req                       = tstamp_req_valid;
assign tx_timestamp_fp_valid                 = o_sl_ptp_ets_valid;
assign tx_timestamp_fp_data                  = o_sl_ptp_ets;
assign tx_timestamp_fp_fingerprint           = o_sl_ptp_ets_fp;
assign rx_timestamp_valid                    = o_sl_rx_startofpacket & o_sl_rx_valid;
assign rx_timestamp_data                     = o_sl_ptp_rx_its;
assign i_sl_ptp_cf_offset                    = 16'd0;
assign i_sl_ptp_csum_offset                  = 16'd0;
assign i_sl_ptp_eb_offset                    = 16'd0;
assign i_sl_ptp_ins_cf                       = 1'd0;
assign i_sl_ptp_ins_ets                      = 1'd0;
assign i_sl_ptp_ts_format                    = 1'd0;
assign i_sl_ptp_ts_offset                    = 16'd0;
assign i_sl_ptp_tx_its                       = 96'd0;
assign i_sl_ptp_update_eb                    = 1'd0;
assign i_sl_ptp_zero_csum                    = 1'd0;

assign tod_sync_sampling_clk_iopll_locked    = tod_sync_sampling_25gbe_clk_iopll_locked & tod_sync_sampling_10gbe_clk_iopll_locked;
always @(posedge reconfig_clock)
begin
    debug_status_reg                        <= {ptp_sampling_clk_iopll_locked, tod_sync_sampling_clk_iopll_locked,
                                                o_sl_rx_ptp_ready, o_sl_tx_ptp_ready, o_cdr_lock,
                                                o_tx_pll_locked, o_sl_tx_lanes_stable, o_sl_rx_pcs_ready,
                                                o_sl_ehip_ready, o_sl_rx_block_lock, o_sl_local_fault_status,
                                                o_sl_remote_fault_status, iopll_clk_dma_locked};
end

assign ehip_debug_status                     = debug_status_reg;
// direct o_sl_tx_lanes_stable to sl_tx_lanes_stable_reset_n for TOD reset ussage.
assign sl_tx_lanes_stable_reset_n            = o_sl_tx_lanes_stable;
// direct o_sl_rx_pcs_ready to sl_rx_pcs_ready_reset_n for TOD reset ussage.
assign sl_rx_pcs_ready_reset_n               = o_sl_rx_pcs_ready;
//TX PLL LOCK as reset for user to use
reg[5:0]    tx_pll_lock_reset_reg;

always @(posedge o_clk_pll_div64[1] or negedge o_tx_pll_locked)
begin
    if (o_tx_pll_locked == 1'b0) begin
        tx_pll_lock_reset_reg   <= 6'd0;
    end else begin
        tx_pll_lock_reset_reg   <= {tx_pll_lock_reset_reg[4:0],1'b1};
    end
end
assign tx_pll_locked_reset_n = tx_pll_lock_reset_reg[5];

//DMA Clock as reset for user to use
reg[5:0]    clk_dma_lock_reset_reg;
always @(posedge dma_clock or negedge iopll_clk_dma_locked)
begin
    if (iopll_clk_dma_locked == 1'b0) begin
        clk_dma_lock_reset_reg   <= 6'd0;
    end else begin
        clk_dma_lock_reset_reg   <= {clk_dma_lock_reset_reg[4:0],1'b1};
    end
end
assign clk_dma_lock_reset_n = clk_dma_lock_reset_reg[5];

endmodule
