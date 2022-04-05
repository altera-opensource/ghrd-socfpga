//****************************************************************************
//
// SPDX-License-Identifier: MIT-0
// Copyright(c) 2018-2022 Intel Corporation.
//
//****************************************************************************
//
// Ethernet TX DMA timestamp request IP
// Timestamp Request for Intel PSG Ethernet IP
//
//****************************************************************************

module eth_tx_dma_timestamp_req
#(
    parameter BITSPERSYMBOL = 8,
    parameter SYMBOLSPERBEAT = 8,
    parameter EMPTY_WIDTH = 3,
    parameter ERROR_WIDTH = 6
)
(
    input wire      clock,
    input wire      reset,

     //Avalon ST DataIn (Sink) Interface
    input                                               asi_pktin_sop,
    input                                               asi_pktin_eop,
    input                                               asi_pktin_valid,
    output                                              asi_pktin_ready,
    input   [(BITSPERSYMBOL * SYMBOLSPERBEAT)-1:0]      asi_pktin_data,
    input   [EMPTY_WIDTH-1 : 0]                         asi_pktin_empty,
    input   [ERROR_WIDTH-1:0]                           asi_pktin_error,

    //Avalon ST DataOut (Source) Interface
    output                                              aso_pktout_sop,
    output                                              aso_pktout_eop,
    output                                              aso_pktout_valid,
    input                                               aso_pktout_ready,
    output  [(BITSPERSYMBOL * SYMBOLSPERBEAT)-1:0]      aso_pktout_data,
    output  [(EMPTY_WIDTH)-1 : 0]                       aso_pktout_empty,
    output  [(ERROR_WIDTH)-1:0]                         aso_pktout_error,

    //Timestamp Req interface
    output                                              tstamp_req_valid,
    output [7:0]                                        tstamp_req_fingerprint,

    //Fingerprint AVST Output
    output                                              aso_fingerprint_valid,
    output [7:0]                                        aso_fingerprint,
    input                                               aso_fingerprint_ready
);

    // we just need to filter out rx timstamps if there is no valid
    // packet.  The mac itself wont do this, but if by chance we are
    // filtering rx packets, we need to filter the ts as well.
    // for rx packets the ts comes with sop and ready of the pkt data

    assign aso_pktout_sop       = asi_pktin_sop;
    assign aso_pktout_eop       = asi_pktin_eop;
    assign aso_pktout_valid     = asi_pktin_valid;
    assign asi_pktin_ready      = aso_pktout_ready;
    assign aso_pktout_data      = asi_pktin_data;
    assign aso_pktout_empty     = asi_pktin_empty;
    assign aso_pktout_error     = asi_pktin_error;

    // Timestamp Req
    //using 8 bits for the fingerprint
    reg [7:0]   fingerprint;
    reg [7:0]   fingerprint_r;
    reg         aso_fingerprint_valid_r;

//  assign tstamp_req_valid = aso_pktout_ready & aso_pktout_valid & aso_pktout_sop;
    assign tstamp_req_valid = 1'b1;
    assign tstamp_req_fingerprint = fingerprint;

    wire feedback;
    assign feedback = (fingerprint[3] ^ (fingerprint[4] ^ (fingerprint[5] ^ fingerprint[7])));

    always@(posedge clock)
    begin
        if(reset)
        begin
            fingerprint     <= 8'ha5;
            fingerprint_r   <= 8'ha5;
        end
        else
        begin
            if(aso_pktout_ready == 1'b1 & aso_pktout_valid == 1'b1 & aso_pktout_sop == 1'b1)
            begin
                fingerprint <= {fingerprint[6:0],feedback};
                fingerprint_r <= fingerprint;
            end
        end
    end

    assign aso_fingerprint = fingerprint_r;
    assign aso_fingerprint_valid = aso_fingerprint_valid_r;

    always@(posedge clock)
    begin
        if(reset)
            aso_fingerprint_valid_r <= 1'b0;
        else
        begin
            if(aso_pktout_ready == 1'b1 & aso_pktout_valid == 1'b1 & aso_pktout_sop == 1'b1)
                aso_fingerprint_valid_r <= 1'b1;
            else if (aso_fingerprint_ready)
                aso_fingerprint_valid_r <= 1'b0;
            end
    end

endmodule
