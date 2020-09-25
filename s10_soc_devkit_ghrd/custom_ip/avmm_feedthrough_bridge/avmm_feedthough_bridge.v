//****************************************************************************
//
// SPDX-License-Identifier: MIT-0
// Copyright(c) 2016-2020 Intel Corporation.
//
//****************************************************************************
//
// This component is a simple AVMM Feedthough Bridge for importing RTL simple AVMM port to QSYS
// Limited support
//
//****************************************************************************

module avmm_feedthough_bridge #(
   parameter ADDRESS_WIDTH = 32,
   parameter DATA_WIDTH = 32
)(
    input               clk,                // clock
    input               reset,              // reset
                        
    input  [ADDRESS_WIDTH-1:0]   s0_addr,          // avalon_slave
    input                        s0_read,          // avalon_slave
    input                        s0_write,         // avalon_slave
    input  [DATA_WIDTH-1:0]      s0_writedata,     // avalon_slave
    output [DATA_WIDTH-1:0]      s0_readdata,      // avalon_slave
//    output                       s0_readdatavalid, // avalon_slave
    output                       s0_waitrequest,   // avalon_slave

    output [ADDRESS_WIDTH-1:0]   m0_addr,          // avalon_master
    output                       m0_read,          // avalon_master
    output                       m0_write,         // avalon_master
    output [DATA_WIDTH-1:0]      m0_writedata,     // avalon_master
    input  [DATA_WIDTH-1:0]      m0_readdata,      // avalon_master
//    input                        m0_readdatavalid, // avalon_master
    input                        m0_waitrequest    // avalon_master
);

assign m0_addr          = s0_addr;
assign m0_read          = s0_read;
assign m0_write         = s0_write;
assign m0_writedata     = s0_writedata;
assign s0_readdata      = m0_readdata;     
//assign s0_readdatavalid = m0_readdatavalid;
assign s0_waitrequest   = m0_waitrequest;

endmodule