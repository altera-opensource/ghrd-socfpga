//****************************************************************************
//
// SPDX-License-Identifier: MIT-0
// Copyright(c) 2001-2022 Intel Corporation.
//
//****************************************************************************
//
// eth_tod_load_off.v
// This module terminate the TOD Load input with 0
//****************************************************************************


`timescale 1ns / 1ns
module eth_tod_load_off #(
        parameter CONDUIT_DATA_WIDTH = 96
    ) (
    //time_of_day_load
    output  [CONDUIT_DATA_WIDTH-1:0]   time_of_day_load_data,
    output                             time_of_day_load_valid
);

   assign   time_of_day_load_data  = {CONDUIT_DATA_WIDTH{1'b0}};
   assign   time_of_day_load_valid = 1'd0;


endmodule

