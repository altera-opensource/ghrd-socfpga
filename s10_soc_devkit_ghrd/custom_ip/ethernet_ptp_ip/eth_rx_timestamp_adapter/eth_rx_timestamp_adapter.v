//****************************************************************************
//
// SPDX-License-Identifier: MIT-0
// Copyright(c) 2018-2020 Intel Corporation.
//
//****************************************************************************
//
// Ethernet RX timestamp adapter IP
// RX Timestamp Adapter for Intel PSG Ethernet IP
//
//****************************************************************************

module eth_rx_timestamp_adapter

(
	input wire		clock,
	input wire		reset,

	//Timestamp input
	input 	        									timestamp_valid,
	input	[95:0]  									timestamp_data,
		
	//Timestamp AVST Output
	output reg											aso_timestamp_valid,
	output reg	[95:0]									aso_timestamp,
	input												aso_timestamp_ready
);

/* 
 * timestamp_fp_valid should be valid for 1 cycle and valid
 * only once during a transmit packet
*/

always@(posedge clock)
begin
	if(reset)
	begin
		aso_timestamp_valid <= 1'b0;
		aso_timestamp <= 96'h0;
	end
	else
	begin
		if(timestamp_valid)
			aso_timestamp <= timestamp_data;
			
		if(timestamp_valid)
			aso_timestamp_valid <= 1'b1;
		else if(aso_timestamp_ready)
			aso_timestamp_valid <= 1'b0;
		
	end
end

endmodule