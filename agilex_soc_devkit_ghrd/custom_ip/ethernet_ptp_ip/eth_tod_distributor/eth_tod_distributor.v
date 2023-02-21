//****************************************************************************
//
// SPDX-License-Identifier: MIT-0
// Copyright(c) 2001-2022 Intel Corporation.
//
//****************************************************************************
//
// eth_tod_distributor
// This component is an ToD distributor IP
//****************************************************************************

module eth_tod_distributor #(parameter OUTPUT_PORT_SIZE) (
    //Wirelevel tx_tod_sync_data and rx_tod_sync_data
    input  [95:0]       tod_in,           // Avalon streaming sink
    output [95:0]       tod_out0 ,         // conduit
    output [95:0]       tod_out1 ,         // conduit
    output [95:0]       tod_out2 ,         // conduit
    output [95:0]       tod_out3 ,         // conduit
    output [95:0]       tod_out4 ,         // conduit
    output [95:0]       tod_out5 ,         // conduit
    output [95:0]       tod_out6 ,         // conduit
    output [95:0]       tod_out7 ,         // conduit
    output [95:0]       tod_out8 ,         // conduit
    output [95:0]       tod_out9 ,         // conduit
    output [95:0]       tod_out10,         // conduit
    output [95:0]       tod_out11,         // conduit
    output [95:0]       tod_out12,         // conduit
    output [95:0]       tod_out13,         // conduit
    output [95:0]       tod_out14,         // conduit
    output [95:0]       tod_out15,         // conduit
    output [95:0]       tod_out16          // conduit
);

assign tod_out0  = tod_in;
assign tod_out1  = tod_in;
assign tod_out2  = tod_in;
assign tod_out3  = tod_in;
assign tod_out4  = tod_in;
assign tod_out5  = tod_in;
assign tod_out6  = tod_in;
assign tod_out7  = tod_in;
assign tod_out8  = tod_in;
assign tod_out9  = tod_in;
assign tod_out10 = tod_in;
assign tod_out11 = tod_in;
assign tod_out12 = tod_in;
assign tod_out13 = tod_in;
assign tod_out14 = tod_in;
assign tod_out15 = tod_in;
assign tod_out16 = tod_in;

endmodule
