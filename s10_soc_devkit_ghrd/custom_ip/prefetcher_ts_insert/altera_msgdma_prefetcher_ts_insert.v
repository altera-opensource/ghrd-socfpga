//****************************************************************************
//
// SPDX-License-Identifier: MIT-0
// Copyright(c) 2018-2020 Intel Corporation.
//
//****************************************************************************
//
// msgdma prefetcher timestamp insert 
// Timestamp Insert for Intel PSG MSGDMA Prefetcher IP
//
//****************************************************************************

module altera_msgdma_prefetcher_ts_insert (
	clk,
	reset,
	
	snk_response_data,
	snk_response_valid,
	snk_response_ready,

	snk_timestamp_valid,
	snk_timestamp_ready,
	snk_timestamp,
	
	src_response_data,
	src_response_valid,
	src_response_ready	
	
);

	input 						clk;
	input 						reset;
  
	input	wire				snk_response_valid;
	output 	wire				snk_response_ready;
	input	wire 	[255:0]		snk_response_data;
	
	input	wire				snk_timestamp_valid;
	output 	wire				snk_timestamp_ready;
	input	wire	[95:0]		snk_timestamp;	

	output	wire 	[255:0]		src_response_data;
	output	wire				src_response_valid;
	input 	wire				src_response_ready;

	
	assign src_response_data[159:0] = snk_response_data[127:0];
	assign src_response_data[255:160] = snk_timestamp[95:0];
	
	assign snk_response_ready = src_response_ready;
	assign snk_timestamp_ready = src_response_ready;
	
	assign src_response_valid = snk_response_valid & snk_timestamp_valid;

endmodule