//****************************************************************************
//
// SPDX-License-Identifier: MIT-0
// Copyright(c) 2018-2022 Intel Corporation.
//
//****************************************************************************
//
// Ethernet timestamp fingerprint compare IP
// Timestamp Fingerprint Comparator for Timestamp Filtering
//
//****************************************************************************

module eth_ts_fingerprint_compare
(
    input wire      clock,
    input wire      reset,

    //Fingerprint AVST Input
    input                                               asi_fingerprint_valid,
    input [7:0]                                         asi_fingerprint,
    output reg                                          asi_fingerprint_ready,

    //Timestamp AVST Input
    input                                               asi_timestamp_fp_valid,
    input [103:0]                                       asi_timestamp_fp,
    output reg                                          asi_timestamp_fp_ready,

    //Timestamp AVST Output
    output reg                                          aso_timestamp_valid,
    output [95:0]                                       aso_timestamp,
    input                                               aso_timestamp_ready
);

assign aso_timestamp = asi_timestamp_fp[95:0];

localparam [1:0]    IDLE        = 2'b00;
localparam [1:0]    VALID       = 2'b01;
localparam [1:0]    ASO_OUT     = 2'b10;
localparam [1:0]    POP         = 2'b11;

reg [3:0] state, next_state;
reg match;

always @(posedge clock)
begin
    if (reset)
        state <= IDLE;
    else
        state <= next_state;
end

always @*
begin
    case (state)
        IDLE: begin
            if (asi_fingerprint_valid & asi_timestamp_fp_valid)
                next_state <= VALID;
            else
                next_state <= IDLE;
        end
        VALID: begin
            if (match)
                next_state <= ASO_OUT;
            else
                next_state <= POP;
        end
        ASO_OUT: begin
            if (aso_timestamp_ready)
                next_state <= POP;
            else
                next_state <= ASO_OUT;
        end
        POP: begin
            next_state <= IDLE;
        end
    endcase
end

always @(posedge clock)
begin
    if (reset)
    begin
        asi_timestamp_fp_ready <= 1'b0;
        asi_fingerprint_ready <= 1'b0;
    end
    else
    begin
        if (next_state == POP)
            asi_timestamp_fp_ready <= 1'b1;
        else
            asi_timestamp_fp_ready <= 1'b0;

        if (next_state == POP)
            asi_fingerprint_ready <= match;
        else
            asi_fingerprint_ready <= 1'b0;
    end
end

//aso valid
always @(posedge clock)
begin
    if (reset)
        aso_timestamp_valid <= 1'b0;
    else
        if ((state == ASO_OUT) & !aso_timestamp_ready)
            aso_timestamp_valid <= 1'b1;
        else
            aso_timestamp_valid <= 1'b0;
end


always @(posedge clock)
begin
    if (reset)
        match <= 1'b0;
    else
        if (asi_fingerprint == asi_timestamp_fp[103:96])
            match <= 1'b1;
        else
            match <= 1'b0;
end
endmodule