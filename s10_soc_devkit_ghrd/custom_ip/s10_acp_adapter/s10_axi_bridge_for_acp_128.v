//****************************************************************************
//
// SPDX-License-Identifier: MIT-0
// Copyright(c) 2018-2020 Intel Corporation.
//
//****************************************************************************
//
// This component is a simple ACE-LITE pass through bridge with 128-bit data path
// and 32-bit address bus.  The intent of this component is to simply condition
// the DOMAIN, BAR, SNOOP, CACHE, and PROT ports to drive an
// acceptable pattern into the HPS F2S bridge for accesses that are targeting
// the ACP port of the Cortex A9 cluster.
//
//****************************************************************************//

`timescale 1 ps / 1 ps
module s10_axi_bridge_for_acp_128 #(
		parameter GPIO_EN = 0,
		parameter CSR_EN = 0,
		parameter ARDOMAIN_OVERRIDE = 2'h2,
		parameter ARBAR_OVERRIDE = 2'h0,
		parameter ARSNOOP_OVERRIDE = 4'h0,
		parameter ARCACHE_OVERRIDE = 4'hF,
		parameter AWDOMAIN_OVERRIDE = 2'h2,
		parameter AWBAR_OVERRIDE = 2'h0,
		parameter AWSNOOP_OVERRIDE = 3'h0,
		parameter AWCACHE_OVERRIDE = 4'hF,
		parameter AxPROT_OVERRIDE = 3'h3,
		parameter ADDR_WIDTH = 32
)(
		input  wire         clk,            // clock.clk
		input  wire         reset,          // reset.reset
		input  wire         csr_clk,            // csr_clock.csr_clk
		input  wire         csr_reset,          // csr_reset.csr_reset

		input               addr,               // avalon_slave
		input               read,               // avalon_slave
		input               write,              // avalon_slave
		input [31:0]        writedata,          // avalon_slave
		output reg  [31:0]  readdata,           // avalon_slave
		
		output wire [ADDR_WIDTH -1 :0]  axm_m0_araddr,  //    m0.araddr
		output wire [1:0]   axm_m0_arbar,   //      .arbar
		output wire [1:0]   axm_m0_arburst, //      .arburst
		output wire [3:0]   axm_m0_arcache, //      .arcache
		output wire [1:0]   axm_m0_ardomain,//      .ardomain
		output wire [3:0]   axm_m0_arid,    //      .arid
		output wire [7:0]   axm_m0_arlen,   //      .arlen
		output wire         axm_m0_arlock,  //      .arlock
		output wire [2:0]   axm_m0_arprot,  //      .arprot
		output wire [3:0]   axm_m0_arqos,   //      .arqos
		input  wire         axm_m0_arready, //      .arready
		output wire [2:0]   axm_m0_arsize,  //      .arsize
		output wire [3:0]   axm_m0_arsnoop, //      .arsnoop
//		output wire [7:0]   axm_m0_aruser,  //      .aruser
		output wire         axm_m0_arvalid, //      .arvalid
		output wire [ADDR_WIDTH -1 :0]  axm_m0_awaddr,  //      .awaddr
		output wire [1:0]   axm_m0_awbar,    //     .awbar
		output wire [1:0]   axm_m0_awburst, //      .awburst
		output wire [3:0]   axm_m0_awcache, //      .awcache
		output wire [1:0]   axm_m0_awdomain, //     .awdomain
		output wire [3:0]   axm_m0_awid,    //      .awid
		output wire [7:0]   axm_m0_awlen,   //      .awlen
		output wire         axm_m0_awlock,  //      .awlock
		output wire [2:0]   axm_m0_awprot,  //      .awprot
		output wire [3:0]   axm_m0_awqos,   //      .awqos
		input  wire         axm_m0_awready, //      .awready
		output wire [2:0]   axm_m0_awsize,  //      .awsize
		output wire [2:0]   axm_m0_awsnoop,  //     .awsnoop
//		output wire [7:0]   axm_m0_awuser,  //      .awuser
		output wire         axm_m0_awvalid, //      .awvalid
		input  wire [3:0]   axm_m0_bid,     //      .bid
		output wire         axm_m0_bready,  //      .bready
		input  wire [1:0]   axm_m0_bresp,   //      .bresp
		input  wire         axm_m0_bvalid,  //      .bvalid
		input  wire [127:0] axm_m0_rdata,   //      .rdata
		input  wire [3:0]   axm_m0_rid,     //      .rid
		input  wire         axm_m0_rlast,   //      .rlast
		output wire         axm_m0_rready,  //      .rready
		input  wire [1:0]   axm_m0_rresp,   //      .rresp
		input  wire         axm_m0_rvalid,  //      .rvalid
		output wire [127:0] axm_m0_wdata,   //      .wdata
		output wire         axm_m0_wlast,   //      .wlast
		input  wire         axm_m0_wready,  //      .wready
		output wire [15:0]  axm_m0_wstrb,   //      .wstrb
		output wire         axm_m0_wvalid,  //      .wvalid
//      //Extra ACE-LITE signals
//      output wire         axm_m0_wuser,
//      output wire [3:0]   axm_m0_awregion,
//      input  wire         axm_m0_buser,
//      output wire         axm_m0_awunique,
//      input  wire         axm_m0_ruser,
//      output wire [3:0]   axm_m0_arregion,

		
		input  wire [ADDR_WIDTH -1:0]  axs_s0_araddr,  //    s0.araddr
		input  wire [1:0]   axs_s0_arburst, //      .arburst
		input  wire [3:0]   axs_s0_arcache, //      .arcache
		input  wire [3:0]   axs_s0_arid,    //      .arid
		input  wire [7:0]   axs_s0_arlen,   //      .arlen
		input  wire         axs_s0_arlock,  //      .arlock
		input  wire [2:0]   axs_s0_arprot,  //      .arprot
		output wire         axs_s0_arready, //      .arready
		input  wire [2:0]   axs_s0_arsize,  //      .arsize
		input  wire         axs_s0_arvalid, //      .arvalid
		input  wire [ADDR_WIDTH -1:0]  axs_s0_awaddr,  //      .awaddr
		input  wire [1:0]   axs_s0_awburst, //      .awburst
		input  wire [3:0]   axs_s0_awcache, //      .awcache
		input  wire [3:0]   axs_s0_awid,    //      .awid
		input  wire [7:0]   axs_s0_awlen,   //      .awlen
		input  wire         axs_s0_awlock,  //      .awlock
		input  wire [2:0]   axs_s0_awprot,  //      .awprot
		output wire         axs_s0_awready, //      .awready
		input  wire [2:0]   axs_s0_awsize,  //      .awsize
		input  wire         axs_s0_awvalid, //      .awvalid
		output wire [3:0]   axs_s0_bid,     //      .bid
		input  wire         axs_s0_bready,  //      .bready
		output wire [1:0]   axs_s0_bresp,   //      .bresp
		output wire         axs_s0_bvalid,  //      .bvalid
		output wire [127:0] axs_s0_rdata,   //      .rdata
		output wire [3:0]   axs_s0_rid,     //      .rid
		output wire         axs_s0_rlast,   //      .rlast
		input  wire         axs_s0_rready,  //      .rready
		output wire [1:0]   axs_s0_rresp,   //      .rresp
		output wire         axs_s0_rvalid,  //      .rvalid
		input  wire [127:0] axs_s0_wdata,   //      .wdata
		input  wire         axs_s0_wlast,   //      .wlast
		output wire         axs_s0_wready,  //      .wready
		input  wire [15:0]  axs_s0_wstrb,   //      .wstrb
		input  wire         axs_s0_wvalid,  //      .wvalid
      
      input  wire [31:0]  gp_output,      //  gpio.gp_output
      output wire [31:0]  gp_input        //      .gp_input
	);

reg [1:0]  csr_ardomain;
reg [1:0]  csr_arbar;
reg [3:0]  csr_arsnoop;
reg [3:0]  csr_arcache;
reg [1:0]  csr_awdomain;
reg [1:0]  csr_awbar;
reg [2:0]  csr_awsnoop;
reg [3:0]  csr_awcache;
reg [2:0]  csr_axprot;

// for unused ACE-LITE signals
//   assign axm_m0_wuser = 1'b0;
//   assign axm_m0_awregion = 4'b0;
//   assign axm_m0_awunique = 1'b0;
//   assign axm_m0_arregion = 4'b0;
   
   assign gp_input = gp_output;
   
	assign axm_m0_araddr = axs_s0_araddr;
	assign axm_m0_arburst = axs_s0_arburst;
//	assign axm_m0_arcache = axs_s0_arcache;
	assign axm_m0_arid = axs_s0_arid[3:0];
	assign axm_m0_arlen = axs_s0_arlen;
	assign axm_m0_arlock = axs_s0_arlock;
//	assign axm_m0_arprot = axs_s0_arprot;
	assign axm_m0_arsize = axs_s0_arsize;
	assign axm_m0_arvalid = axs_s0_arvalid;
	assign axm_m0_arqos = 4'b0000;
//	assign axm_m0_arsnoop = 4'b0000;
//	assign axm_m0_ardomain = 2'b11;
//	assign axm_m0_arbar = 2'b00;
	assign axm_m0_awaddr = axs_s0_awaddr;
	assign axm_m0_awburst = axs_s0_awburst;
//	assign axm_m0_awcache = 4'b0111;
	assign axm_m0_awid = axs_s0_awid[3:0];
	assign axm_m0_awlen = axs_s0_awlen;
	assign axm_m0_awlock = axs_s0_awlock;
	assign axm_m0_awqos = 4'b0000;
//	assign axm_m0_awprot = 3'b011;
//	assign axm_m0_awdomain = 2'b10;
//	assign axm_m0_awbar = 2'b00;
//	assign axm_m0_awsnoop = 3'b000;
	assign axm_m0_awsize = axs_s0_awsize;
	assign axm_m0_awvalid = axs_s0_awvalid;
	assign axm_m0_bready = axs_s0_bready;
	assign axm_m0_rready = axs_s0_rready;
	assign axm_m0_wdata = axs_s0_wdata;
	assign axm_m0_wlast = axs_s0_wlast;
	assign axm_m0_wstrb = axs_s0_wstrb;
	assign axm_m0_wvalid = axs_s0_wvalid;
	assign axs_s0_arready = axm_m0_arready;
	assign axs_s0_awready = axm_m0_awready;
	assign axs_s0_bid = axm_m0_bid[3:0];
	assign axs_s0_bresp = axm_m0_bresp;
	assign axs_s0_bvalid = axm_m0_bvalid;
	assign axs_s0_rdata = axm_m0_rdata;
	assign axs_s0_rid = axm_m0_rid[3:0];
	assign axs_s0_rlast = axm_m0_rlast;
	assign axs_s0_rresp = axm_m0_rresp;
	assign axs_s0_rvalid = axm_m0_rvalid;
	assign axs_s0_wready = axm_m0_wready;
 
generate
   if (GPIO_EN == 1) begin
      assign axm_m0_ardomain     =  gp_output[1:0];  
      assign axm_m0_arbar        =  gp_output[3:2];   
      assign axm_m0_arsnoop      =  gp_output[7:4];    
      assign axm_m0_arcache      =  gp_output[11:8];
      assign axm_m0_awdomain     =  gp_output[13:12];  
      assign axm_m0_awbar        =  gp_output[15:14];   
      assign axm_m0_awsnoop      =  gp_output[18:16];
      assign axm_m0_awcache      =  gp_output[22:19];
      // axprot[1] => 1'b0 -> secure; 1'b1 -> non-secure;
      assign axm_m0_awprot	      =  gp_output[31:29];
      assign axm_m0_arprot	      =  gp_output[31:29];
   end else if (CSR_EN == 1) begin
      assign axm_m0_ardomain     =  csr_ardomain;
      assign axm_m0_arbar        =  csr_arbar;
      assign axm_m0_arsnoop      =  csr_arsnoop;
      assign axm_m0_arcache      =  csr_arcache;
      assign axm_m0_awdomain     =  csr_awdomain;
      assign axm_m0_awbar        =  csr_awbar;
      assign axm_m0_awsnoop      =  csr_awsnoop;
      assign axm_m0_awcache      =  csr_awcache;
      // axprot[1] => 1'b0 -> secure; 1'b1 -> non-secure;
      assign axm_m0_awprot       =  csr_axprot;
      assign axm_m0_arprot       =  csr_axprot;
   end else begin
      assign axm_m0_ardomain     = ARDOMAIN_OVERRIDE;
      assign axm_m0_arbar        = ARBAR_OVERRIDE;
      assign axm_m0_arsnoop      = ARSNOOP_OVERRIDE;
      assign axm_m0_arcache      = ARCACHE_OVERRIDE;
      assign axm_m0_awdomain     = AWDOMAIN_OVERRIDE;
      assign axm_m0_awbar        = AWBAR_OVERRIDE;
      assign axm_m0_awsnoop      = AWSNOOP_OVERRIDE;
      assign axm_m0_awcache      = AWCACHE_OVERRIDE;
      assign axm_m0_awprot       = AxPROT_OVERRIDE;
      assign axm_m0_arprot       = AxPROT_OVERRIDE;
   end
   
   if (CSR_EN == 1) begin
      always @(posedge csr_clk or posedge csr_reset) begin
         if (csr_reset == 1) begin
            csr_ardomain   <= ARDOMAIN_OVERRIDE;
            csr_arbar      <= ARBAR_OVERRIDE;
            csr_arsnoop    <= ARSNOOP_OVERRIDE;
            csr_arcache    <= ARCACHE_OVERRIDE;
            csr_awdomain   <= AWDOMAIN_OVERRIDE;
            csr_awbar      <= AWBAR_OVERRIDE;
            csr_awsnoop    <= AWSNOOP_OVERRIDE;
            csr_awcache    <= AWCACHE_OVERRIDE;
            csr_axprot     <= AxPROT_OVERRIDE;
         end else begin
            if (write == 1) begin
               if (addr == 0) begin
                  csr_ardomain   <= writedata[1:0];  
                  csr_arbar      <= writedata[3:2];   
                  csr_arsnoop    <= writedata[7:4];   
                  csr_arcache    <= writedata[11:8];
                  csr_awdomain   <= writedata[13:12]; 
                  csr_awbar      <= writedata[15:14]; 
                  csr_awsnoop    <= writedata[18:16];
                  csr_awcache    <= writedata[22:19];
                  csr_axprot     <= writedata[31:29];
               end
            end
            
            if (read == 1) begin
               if (addr == 0) begin
                  readdata[1:0]    <= csr_ardomain;
                  readdata[3:2]    <= csr_arbar;
                  readdata[7:4]    <= csr_arsnoop;
                  readdata[11:8]   <= csr_arcache;
                  readdata[13:12]  <= csr_awdomain;
                  readdata[15:14]  <= csr_awbar;
                  readdata[18:16]  <= csr_awsnoop;
                  readdata[22:19]  <= csr_awcache;
                  readdata[28:23]  <= 6'b0;
                  readdata[31:29]  <= csr_axprot;
               end
            end 
         end
      end
   end
endgenerate


endmodule

