//****************************************************************************
//
// SPDX-License-Identifier: MIT-0
// Copyright(c) 2022 Intel Corporation.
//
//****************************************************************************
//
// tod_mux.v
// This component is an ToD mux for ETILE 10G / 25G
// sel =0 -> tod10g; sel =1 -> tod25g
//****************************************************************************

module tod_mux(tx_tod_out, rx_tod_out, tx_tod10g, rx_tod10g, tx_tod25g, rx_tod25g, sel);

output [95:0]       tx_tod_out;
output [95:0]       rx_tod_out;
input  [95:0]       tx_tod10g;
input  [95:0]       rx_tod10g;
input  [95:0]       tx_tod25g;
input  [95:0]       rx_tod25g;
input               sel;

assign tx_tod_out =(sel)?tx_tod25g:tx_tod10g;
assign rx_tod_out =(sel)?rx_tod25g:rx_tod10g;

endmodule