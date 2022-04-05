//****************************************************************************
//
// SPDX-License-Identifier: MIT-0
// Copyright(c) 2018-2022 Intel Corporation.
//
//****************************************************************************
//
// Ethernet TX timestamp adapter IP
// TX Timestamp Adapter for Intel PSG Ethernet IP
//
//****************************************************************************

module eth_tx_timestamp_adapter

(
    input wire      clock,
    input wire      reset,

    //Timestamp input
    input                                               timestamp_fp_valid,
    input   [95:0]                                      timestamp_fp_data,
    input   [7:0]                                       timestamp_fp_fingerprint,

    //Timestamp AVST Output
    output reg                                          aso_timestamp_fp_valid,
    output reg  [103:0]                                 aso_timestamp_fp,
    input                                               aso_timestamp_fp_ready
);

/*
 * timestamp_fp_valid should be valid for 1 cycle and valid
 * only once during a transmit packet
*/

always@(posedge clock)
begin
    if(reset)
    begin
        aso_timestamp_fp_valid <= 1'b0;
        aso_timestamp_fp <= 104'h0;
    end
    else
    begin
        if(timestamp_fp_valid)
            aso_timestamp_fp <= {timestamp_fp_fingerprint,timestamp_fp_data};

        if(timestamp_fp_valid)
            aso_timestamp_fp_valid <= 1'b1;
        else if(aso_timestamp_fp_ready)
            aso_timestamp_fp_valid <= 1'b0;

    end
end

endmodule