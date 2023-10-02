// (C) 2001-2022 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other
// software and tools, and its AMPP partner logic functions, and any output
// files from any of the foregoing (including device programming or simulation
// files), and any associated documentation or information are expressly subject
// to the terms and conditions of the Intel Program License Subscription
// Agreement, Intel FPGA IP License Agreement, or other applicable
// license agreement, including, without limitation, that your use is for the
// sole purpose of programming logic devices manufactured by Intel and sold by
// Intel or its authorized distributors.  Please refer to the applicable
// agreement for further details.

`default_nettype none

/* hps_adapter
*/

module hps_adapter #(
    parameter  INIU_AXI4_DATA_WIDTH             = 256,
    parameter  HPS_AXI4_DATA_WIDTH              = 32,
    parameter  INIU_AXI4_ADDR_WIDTH             = 44,
    localparam FIFO_DEPTH_LOG2                  = 5,
    localparam INIU_AXI4_ID_WIDTH               = 7,
    localparam INIU_AXI4_AWUSER_WIDTH           = 11,
    localparam INIU_AXI4_ARUSER_WIDTH           = 11
) (
    input  wire                                 s_axi4_aclk,
    input  wire                                 s_axi4_aresetn,
    input  wire  [INIU_AXI4_ID_WIDTH-1:0]       s_axi4_awid,
    input  wire  [INIU_AXI4_ADDR_WIDTH-1:0]     s_axi4_awaddr,
    input  wire  [7:0]                          s_axi4_awlen,
    input  wire  [2:0]                          s_axi4_awsize,
    input  wire  [1:0]                          s_axi4_awburst,
    input  wire                                 s_axi4_awlock,
    input  wire  [2:0]                          s_axi4_awprot,
    input  wire  [3:0]                          s_axi4_awqos,
    input  wire  [INIU_AXI4_AWUSER_WIDTH-1:0]   s_axi4_awuser,
    input  wire                                 s_axi4_awvalid,
    output logic                                s_axi4_awready,
    input  wire  [HPS_AXI4_DATA_WIDTH-1:0]      s_axi4_wdata,
    input  wire  [(HPS_AXI4_DATA_WIDTH/8)-1:0]  s_axi4_wstrb,
    input  wire                                 s_axi4_wlast,
    input  wire  [(HPS_AXI4_DATA_WIDTH/8)-1:0]  s_axi4_wuser,
    input  wire                                 s_axi4_wvalid,
    output logic                                s_axi4_wready,
    output logic [INIU_AXI4_ID_WIDTH-1:0]       s_axi4_bid,
    output logic [1:0]                          s_axi4_bresp,
    output logic                                s_axi4_bvalid,
    input  wire                                 s_axi4_bready,
    input  wire  [INIU_AXI4_ID_WIDTH-1:0]       s_axi4_arid,
    input  wire  [INIU_AXI4_ADDR_WIDTH-1:0]     s_axi4_araddr,
    input  wire  [7:0]                          s_axi4_arlen,
    input  wire  [2:0]                          s_axi4_arsize,
    input  wire  [1:0]                          s_axi4_arburst,
    input  wire                                 s_axi4_arlock,
    input  wire  [2:0]                          s_axi4_arprot,
    input  wire  [3:0]                          s_axi4_arqos,
    input  wire  [INIU_AXI4_ARUSER_WIDTH-1:0]   s_axi4_aruser,
    input  wire                                 s_axi4_arvalid,
    output logic                                s_axi4_arready,
    output logic [INIU_AXI4_ID_WIDTH-1:0]       s_axi4_rid,
    output logic [HPS_AXI4_DATA_WIDTH-1:0]      s_axi4_rdata,
    output logic [1:0]                          s_axi4_rresp,
    output logic                                s_axi4_rlast,
    output logic [(HPS_AXI4_DATA_WIDTH/8)-1:0]  s_axi4_ruser,
    output logic                                s_axi4_rvalid,
    input  wire                                 s_axi4_rready,
    /* input  wire                                 m_axi4_aclk, */
    /* input  wire                                 m_axi4_aresetn, */
    output logic [INIU_AXI4_ID_WIDTH-1:0]       m_axi4_awid,
    output logic [INIU_AXI4_ADDR_WIDTH-1:0]     m_axi4_awaddr,
    output logic [7:0]                          m_axi4_awlen,
    output logic [2:0]                          m_axi4_awsize,
    output logic [1:0]                          m_axi4_awburst,
    output logic                                m_axi4_awlock,
    output logic [2:0]                          m_axi4_awprot,
    output logic [3:0]                          m_axi4_awqos,
    output logic [INIU_AXI4_AWUSER_WIDTH-1:0]   m_axi4_awuser,
    output logic                                m_axi4_awvalid,
    input  wire                                 m_axi4_awready,
    output logic [INIU_AXI4_DATA_WIDTH-1:0]     m_axi4_wdata,
    output logic [(INIU_AXI4_DATA_WIDTH/8)-1:0] m_axi4_wstrb,
    output logic                                m_axi4_wlast,
    output logic [(INIU_AXI4_DATA_WIDTH/8)-1:0] m_axi4_wuser,
    output logic                                m_axi4_wvalid,
    input  wire                                 m_axi4_wready,
    input  wire  [INIU_AXI4_ID_WIDTH-1:0]       m_axi4_bid,
    input  wire  [1:0]                          m_axi4_bresp,
    input  wire                                 m_axi4_bvalid,
    output logic                                m_axi4_bready,
    output logic [INIU_AXI4_ID_WIDTH-1:0]       m_axi4_arid,
    output logic [INIU_AXI4_ADDR_WIDTH-1:0]     m_axi4_araddr,
    output logic [7:0]                          m_axi4_arlen,
    output logic [2:0]                          m_axi4_arsize,
    output logic [1:0]                          m_axi4_arburst,
    output logic                                m_axi4_arlock,
    output logic [2:0]                          m_axi4_arprot,
    output logic [3:0]                          m_axi4_arqos,
    output logic [INIU_AXI4_ARUSER_WIDTH-1:0]   m_axi4_aruser,
    output logic                                m_axi4_arvalid,
    input  wire                                 m_axi4_arready,
    input  wire  [INIU_AXI4_ID_WIDTH-1:0]       m_axi4_rid,
    input  wire  [INIU_AXI4_DATA_WIDTH-1:0]     m_axi4_rdata,
    input  wire  [1:0]                          m_axi4_rresp,
    input  wire                                 m_axi4_rlast,
    input  wire  [(INIU_AXI4_DATA_WIDTH/8)-1:0] m_axi4_ruser,
    input  wire                                 m_axi4_rvalid,
    output logic                                m_axi4_rready
);

    // useful constants for converting the AXI channel widths
    localparam NUM_SLICES       = (INIU_AXI4_DATA_WIDTH / HPS_AXI4_DATA_WIDTH);
    localparam SLICEID_WIDTH    = $clog2(NUM_SLICES);

    localparam INIU_ALIGN_WIDTH = $clog2(INIU_AXI4_DATA_WIDTH / 8);
    localparam HPS_ALIGN_WIDTH  = $clog2(HPS_AXI4_DATA_WIDTH / 8);

    // Mask for the lower bits of address, to aling to size of the wide
    // interface
    localparam logic [INIU_AXI4_ADDR_WIDTH-1:0] MASK_INIU_ALIGN = {{(INIU_AXI4_ADDR_WIDTH-INIU_ALIGN_WIDTH) {1'b1}},
                                                                   {INIU_ALIGN_WIDTH {1'b0}}};

    // Zeroed slice
    localparam logic [SLICEID_WIDTH-1:0] ZERO_SLICE = {SLICEID_WIDTH {1'b0}};

    // check if widths are compatible
    initial begin
        assert((INIU_AXI4_DATA_WIDTH % HPS_AXI4_DATA_WIDTH) == 0);
        assert((HPS_AXI4_DATA_WIDTH == 32) || (HPS_AXI4_DATA_WIDTH == 64) || (HPS_AXI4_DATA_WIDTH == 128));
    end

    ///////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    // 1) Read channels: AR, R channels

    /////////////////////////////
    // 1.1) main input/output registers
    // register received AR signals
    logic [INIU_AXI4_ID_WIDTH-1:0]       reg_s_axi4_arid;
    logic [INIU_AXI4_ADDR_WIDTH-1:0]     reg_s_axi4_araddr;
    logic [7:0]                          reg_s_axi4_arlen;
    logic [2:0]                          reg_s_axi4_arsize;
    logic [1:0]                          reg_s_axi4_arburst;
    logic                                reg_s_axi4_arlock;
    logic [2:0]                          reg_s_axi4_arprot;
    logic [3:0]                          reg_s_axi4_arqos;
    logic [INIU_AXI4_ARUSER_WIDTH-1:0]   reg_s_axi4_aruser;
    logic                                reg_s_axi4_arvalid;
    logic                                reg_s_axi4_arready;

    // register received R signals
    logic [INIU_AXI4_ID_WIDTH-1:0]       reg_m_axi4_rid;
    logic [INIU_AXI4_DATA_WIDTH-1:0]     reg_m_axi4_rdata;
    logic [1:0]                          reg_m_axi4_rresp;
    logic                                reg_m_axi4_rlast;
    logic [(INIU_AXI4_DATA_WIDTH/8)-1:0] reg_m_axi4_ruser;
    logic                                reg_m_axi4_rvalid;
    logic                                reg_m_axi4_rready;

    // assemble narrow R signals
    logic [INIU_AXI4_ID_WIDTH-1:0]       reg_narrow_axi4_rid;
    logic [HPS_AXI4_DATA_WIDTH-1:0]      reg_narrow_axi4_rdata;
    logic [1:0]                          reg_narrow_axi4_rresp;
    logic                                reg_narrow_axi4_rlast;
    logic [(HPS_AXI4_DATA_WIDTH/8)-1:0]  reg_narrow_axi4_ruser;
    logic                                reg_narrow_axi4_rvalid;
    logic                                reg_narrow_axi4_rready;

    // wide R logic ready to receive new AR
    logic                                r_assemble_arready;

    // slice of the wide rdata where the first narrow wdata occurs
    logic [SLICEID_WIDTH-1:0]            slice_reg_s_axi4_araddr;

    assign slice_reg_s_axi4_araddr = reg_s_axi4_araddr[HPS_ALIGN_WIDTH +: SLICEID_WIDTH];

    /////////////////////////////
    // 1.2) FIFO for passing relevant info from AR to R assembling logic
    // FIFO width:
    localparam AR_TO_R_FIFO_WIDTH = SLICEID_WIDTH + // offset in wide word
                                    8;              // arlen

    // declare FIFO signals
    logic ar_to_r_fifo_ups_ready;
    logic ar_to_r_fifo_ups_valid;
    logic [AR_TO_R_FIFO_WIDTH-1:0] ar_to_r_fifo_ups_data;
    logic [SLICEID_WIDTH-1:0] ar_to_r_fifo_ups_slice;
    logic [7:0] ar_to_r_fifo_ups_arlen;

    logic ar_to_r_fifo_dos_ready;
    logic ar_to_r_fifo_dos_valid;
    logic [AR_TO_R_FIFO_WIDTH-1:0] ar_to_r_fifo_dos_data;
    logic [SLICEID_WIDTH-1:0] ar_to_r_fifo_dos_slice;
    logic [7:0] ar_to_r_fifo_dos_arlen;

    // assign FIFO signals
    assign ar_to_r_fifo_ups_valid = reg_s_axi4_arvalid;
    assign ar_to_r_fifo_ups_slice = slice_reg_s_axi4_araddr;
    assign ar_to_r_fifo_ups_arlen = reg_s_axi4_arlen;
    assign ar_to_r_fifo_ups_data = {ar_to_r_fifo_ups_slice,
                                    ar_to_r_fifo_ups_arlen};

    assign ar_to_r_fifo_dos_ready = r_assemble_arready;
    assign {ar_to_r_fifo_dos_slice,
            ar_to_r_fifo_dos_arlen} = ar_to_r_fifo_dos_data;

    // ar_to_r_fifo instantiation
    hps_adapter_fifo #(
        .WIDTH                    (AR_TO_R_FIFO_WIDTH),
        .LOG2_DEPTH               (FIFO_DEPTH_LOG2),
        .UPSTREAM_READY_LATENCY   (1),
        .DOWNSTREAM_READY_LATENCY (0)
    ) ar_to_r_fifo (
        .aclk             (s_axi4_aclk),
        .aresetn          (s_axi4_aresetn),
        .upstream_ready   (ar_to_r_fifo_ups_ready),
        .upstream_valid   (ar_to_r_fifo_ups_valid),
        .upstream_data    (ar_to_r_fifo_ups_data),
        .downstream_ready (ar_to_r_fifo_dos_ready),
        .downstream_valid (ar_to_r_fifo_dos_valid),
        .downstream_data  (ar_to_r_fifo_dos_data)
    );

    /////////////////////////////
    // 1.3) clock crossing FIFO with adjusted AR commands
    // FIFO width:
    localparam AR_CC_FIFO_WIDTH = INIU_AXI4_ID_WIDTH +    // arid
                                  INIU_AXI4_ADDR_WIDTH +  // araddr
                                  8 +                     // arlen
                                  3 +                     // arsize
                                  2 +                     // arburst
                                  1 +                     // arlock
                                  3 +                     // arprot
                                  4 +                     // arqos
                                  INIU_AXI4_ARUSER_WIDTH; // aruser

    // declare FIFO signals
    logic                                ar_cc_fifo_ups_ready;
    logic                                ar_cc_fifo_ups_valid;
    logic [AR_CC_FIFO_WIDTH-1:0]         ar_cc_fifo_ups_data;
    logic [INIU_AXI4_ID_WIDTH-1:0]       ar_cc_fifo_ups_arid;
    logic [INIU_AXI4_ADDR_WIDTH-1:0]     ar_cc_fifo_ups_araddr;
    logic [7:0]                          ar_cc_fifo_ups_arlen;
    logic [2:0]                          ar_cc_fifo_ups_arsize;
    logic [1:0]                          ar_cc_fifo_ups_arburst;
    logic                                ar_cc_fifo_ups_arlock;
    logic [2:0]                          ar_cc_fifo_ups_arprot;
    logic [3:0]                          ar_cc_fifo_ups_arqos;
    logic [INIU_AXI4_ARUSER_WIDTH-1:0]   ar_cc_fifo_ups_aruser;

    logic                                ar_cc_fifo_dos_ready;
    logic                                ar_cc_fifo_dos_valid;
    logic [AR_CC_FIFO_WIDTH-1:0]         ar_cc_fifo_dos_data;
    logic [INIU_AXI4_ID_WIDTH-1:0]       ar_cc_fifo_dos_arid;
    logic [INIU_AXI4_ADDR_WIDTH-1:0]     ar_cc_fifo_dos_araddr;
    logic [7:0]                          ar_cc_fifo_dos_arlen;
    logic [2:0]                          ar_cc_fifo_dos_arsize;
    logic [1:0]                          ar_cc_fifo_dos_arburst;
    logic                                ar_cc_fifo_dos_arlock;
    logic [2:0]                          ar_cc_fifo_dos_arprot;
    logic [3:0]                          ar_cc_fifo_dos_arqos;
    logic [INIU_AXI4_ARUSER_WIDTH-1:0]   ar_cc_fifo_dos_aruser;

    // logic for adjusting arlen for the wide interface
    logic [7:0] adjusted_arlen;
    logic [8:0] total_arlen_slices;

    always @(*) begin
        // basic calculation: adjusted arlen is the total number of narrow beats + offset,
        // divided by number of slices.
        // As arlen = number of beats - 1, we end up with an adjusted_arlen
        // increased by 1. This is ok if total_arlen_slices does not correspond
        // to an integer number of wide beats, as an additional wide beat is
        // required for the remaining slices after the division. If total_arlen_slices
        // does correspond to an integer number of wide beats, we subtract 1 in
        // the if block below
        total_arlen_slices = reg_s_axi4_arlen + slice_reg_s_axi4_araddr + 1'b1;
        // Division by the number of slices
        adjusted_arlen = total_arlen_slices >> SLICEID_WIDTH;
        // Correct arlen if aligned to wide block
        if (total_arlen_slices[SLICEID_WIDTH-1:0] == ZERO_SLICE) begin
            adjusted_arlen = adjusted_arlen - 1'b1;
        end
    end

    // assign FIFO signals, adjusting AR command as follows:
    // - araddr has the LSB INIU_ALIGN_WIDTH bits zeroed, to be aligned to the
    // INIU width
    // - arlen is adjusted per the logic above
    // - other signals stay the same
    assign ar_cc_fifo_ups_valid   = reg_s_axi4_arvalid;
    assign ar_cc_fifo_ups_arid    = reg_s_axi4_arid;
    assign ar_cc_fifo_ups_araddr  = reg_s_axi4_araddr & MASK_INIU_ALIGN;
    assign ar_cc_fifo_ups_arlen   = adjusted_arlen;
    assign ar_cc_fifo_ups_arsize  = INIU_ALIGN_WIDTH;
    assign ar_cc_fifo_ups_arburst = reg_s_axi4_arburst;
    assign ar_cc_fifo_ups_arlock  = reg_s_axi4_arlock;
    assign ar_cc_fifo_ups_arprot  = reg_s_axi4_arprot;
    assign ar_cc_fifo_ups_arqos   = reg_s_axi4_arqos;
    assign ar_cc_fifo_ups_aruser  = reg_s_axi4_aruser;
    assign ar_cc_fifo_ups_data    = {ar_cc_fifo_ups_arid,
                                     ar_cc_fifo_ups_araddr,
                                     ar_cc_fifo_ups_arlen,
                                     ar_cc_fifo_ups_arsize,
                                     ar_cc_fifo_ups_arburst,
                                     ar_cc_fifo_ups_arlock,
                                     ar_cc_fifo_ups_arprot,
                                     ar_cc_fifo_ups_arqos,
                                     ar_cc_fifo_ups_aruser};

    assign ar_cc_fifo_dos_ready = m_axi4_arready;
    assign {ar_cc_fifo_dos_arid,
            ar_cc_fifo_dos_araddr,
            ar_cc_fifo_dos_arlen,
            ar_cc_fifo_dos_arsize,
            ar_cc_fifo_dos_arburst,
            ar_cc_fifo_dos_arlock,
            ar_cc_fifo_dos_arprot,
            ar_cc_fifo_dos_arqos,
            ar_cc_fifo_dos_aruser} = ar_cc_fifo_dos_data;

    // assign AXI outputs from FIFO signals
    assign m_axi4_arvalid = ar_cc_fifo_dos_valid;
    assign m_axi4_arid    = ar_cc_fifo_dos_arid;
    assign m_axi4_araddr  = ar_cc_fifo_dos_araddr;
    assign m_axi4_arlen   = ar_cc_fifo_dos_arlen;
    assign m_axi4_arsize  = ar_cc_fifo_dos_arsize;
    assign m_axi4_arburst = ar_cc_fifo_dos_arburst;
    assign m_axi4_arlock  = ar_cc_fifo_dos_arlock;
    assign m_axi4_arprot  = ar_cc_fifo_dos_arprot;
    assign m_axi4_arqos   = ar_cc_fifo_dos_arqos;
    assign m_axi4_aruser  = ar_cc_fifo_dos_aruser;

    // FIFO instantiation
    hps_adapter_clock_crossing_fifo #(
        .WIDTH                    (AR_CC_FIFO_WIDTH),
        .LOG2_DEPTH               (FIFO_DEPTH_LOG2),
        .UPSTREAM_READY_LATENCY   (1),
        .DOWNSTREAM_READY_LATENCY (0)
    ) ar_cc_fifo (
        .upstream_clk       (s_axi4_aclk),
        .upstream_aresetn   (s_axi4_aresetn),
        .upstream_ready     (ar_cc_fifo_ups_ready),
        .upstream_valid     (ar_cc_fifo_ups_valid),
        .upstream_data      (ar_cc_fifo_ups_data),
        .downstream_clk     (s_axi4_aclk),
        .downstream_aresetn (s_axi4_aresetn),
        .downstream_ready   (ar_cc_fifo_dos_ready),
        .downstream_valid   (ar_cc_fifo_dos_valid),
        .downstream_data    (ar_cc_fifo_dos_data),
        .upstream_occupancy ()
    );

    /////////////////////////////
    // 1.4) clock crossing FIFO with wide R beat received from INIU
    localparam R_CC_FIFO_WIDTH = INIU_AXI4_ID_WIDTH +       // rid
                                 INIU_AXI4_DATA_WIDTH +     // rdata
                                 2 +                        // rresp
                                 1 +                        // rlast
                                 (INIU_AXI4_DATA_WIDTH/8);  // ruser

    // declare FIFO signals
    logic                                r_cc_fifo_ups_ready;
    logic                                r_cc_fifo_ups_valid;
    logic [R_CC_FIFO_WIDTH-1:0]          r_cc_fifo_ups_data;
    logic [INIU_AXI4_ID_WIDTH-1:0]       r_cc_fifo_ups_rid;
    logic [INIU_AXI4_DATA_WIDTH-1:0]     r_cc_fifo_ups_rdata;
    logic [1:0]                          r_cc_fifo_ups_rresp;
    logic                                r_cc_fifo_ups_rlast;
    logic [(INIU_AXI4_DATA_WIDTH/8)-1:0] r_cc_fifo_ups_ruser;

    logic                                r_cc_fifo_dos_ready;
    logic                                r_cc_fifo_dos_valid;
    logic [R_CC_FIFO_WIDTH-1:0]          r_cc_fifo_dos_data;
    logic [INIU_AXI4_ID_WIDTH-1:0]       r_cc_fifo_dos_rid;
    logic [INIU_AXI4_DATA_WIDTH-1:0]     r_cc_fifo_dos_rdata;
    logic [1:0]                          r_cc_fifo_dos_rresp;
    logic                                r_cc_fifo_dos_rlast;
    logic [(INIU_AXI4_DATA_WIDTH/8)-1:0] r_cc_fifo_dos_ruser;

    // assign FIFO signals
    assign r_cc_fifo_ups_valid = m_axi4_rvalid;
    assign r_cc_fifo_ups_rid   = m_axi4_rid;
    assign r_cc_fifo_ups_rdata = m_axi4_rdata;
    assign r_cc_fifo_ups_rresp = m_axi4_rresp;
    assign r_cc_fifo_ups_rlast = m_axi4_rlast;
    assign r_cc_fifo_ups_ruser = m_axi4_ruser;
    assign r_cc_fifo_ups_data  = {r_cc_fifo_ups_rid,
                                  r_cc_fifo_ups_rdata,
                                  r_cc_fifo_ups_rresp,
                                  r_cc_fifo_ups_rlast,
                                  r_cc_fifo_ups_ruser};

    assign r_cc_fifo_dos_ready = reg_m_axi4_rready;
    assign {r_cc_fifo_dos_rid,
            r_cc_fifo_dos_rdata,
            r_cc_fifo_dos_rresp,
            r_cc_fifo_dos_rlast,
            r_cc_fifo_dos_ruser} = r_cc_fifo_dos_data;

    // assign AXI outputs from FIFO signals
    assign m_axi4_rready = r_cc_fifo_ups_ready;

    // FIFO instantiation
    hps_adapter_clock_crossing_fifo #(
        .WIDTH                    (R_CC_FIFO_WIDTH),
        .LOG2_DEPTH               (FIFO_DEPTH_LOG2),
        .UPSTREAM_READY_LATENCY   (0),
        .DOWNSTREAM_READY_LATENCY (0)
    ) r_cc_fifo (
        .upstream_clk       (s_axi4_aclk),
        .upstream_aresetn   (s_axi4_aresetn),
        .upstream_ready     (r_cc_fifo_ups_ready),
        .upstream_valid     (r_cc_fifo_ups_valid),
        .upstream_data      (r_cc_fifo_ups_data),
        .downstream_clk     (s_axi4_aclk),
        .downstream_aresetn (s_axi4_aresetn),
        .downstream_ready   (r_cc_fifo_dos_ready),
        .downstream_valid   (r_cc_fifo_dos_valid),
        .downstream_data    (r_cc_fifo_dos_data),
        .upstream_occupancy ()
    );

    /////////////////////////////
    // 1.5) FIFO with narrow R beats derived from wide R beats
    localparam R_NARROW_FIFO_WIDTH = INIU_AXI4_ID_WIDTH +      // rid
                                     HPS_AXI4_DATA_WIDTH +     // rdata
                                     2 +                       // rresp
                                     1 +                       // rlast
                                     (HPS_AXI4_DATA_WIDTH/8);  // ruser

    // declare FIFO signals
    logic                                r_narrow_fifo_ups_ready;
    logic                                r_narrow_fifo_ups_valid;
    logic [R_NARROW_FIFO_WIDTH-1:0]      r_narrow_fifo_ups_data;
    logic [INIU_AXI4_ID_WIDTH-1:0]       r_narrow_fifo_ups_rid;
    logic [HPS_AXI4_DATA_WIDTH-1:0]      r_narrow_fifo_ups_rdata;
    logic [1:0]                          r_narrow_fifo_ups_rresp;
    logic                                r_narrow_fifo_ups_rlast;
    logic [(HPS_AXI4_DATA_WIDTH/8)-1:0]  r_narrow_fifo_ups_ruser;

    logic                                r_narrow_fifo_dos_ready;
    logic                                r_narrow_fifo_dos_valid;
    logic [R_NARROW_FIFO_WIDTH-1:0]      r_narrow_fifo_dos_data;
    logic [INIU_AXI4_ID_WIDTH-1:0]       r_narrow_fifo_dos_rid;
    logic [HPS_AXI4_DATA_WIDTH-1:0]      r_narrow_fifo_dos_rdata;
    logic [1:0]                          r_narrow_fifo_dos_rresp;
    logic                                r_narrow_fifo_dos_rlast;
    logic [(HPS_AXI4_DATA_WIDTH/8)-1:0]  r_narrow_fifo_dos_ruser;

    // assign FIFO signals
    assign r_narrow_fifo_ups_valid = reg_narrow_axi4_rvalid;
    assign r_narrow_fifo_ups_rid   = reg_narrow_axi4_rid;
    assign r_narrow_fifo_ups_rdata = reg_narrow_axi4_rdata;
    assign r_narrow_fifo_ups_rresp = reg_narrow_axi4_rresp;
    assign r_narrow_fifo_ups_rlast = reg_narrow_axi4_rlast;
    assign r_narrow_fifo_ups_ruser = reg_narrow_axi4_ruser;
    assign r_narrow_fifo_ups_data  = {r_narrow_fifo_ups_rid,
                                      r_narrow_fifo_ups_rdata,
                                      r_narrow_fifo_ups_rresp,
                                      r_narrow_fifo_ups_rlast,
                                      r_narrow_fifo_ups_ruser};

    assign r_narrow_fifo_dos_ready = s_axi4_rready;
    assign {r_narrow_fifo_dos_rid,
            r_narrow_fifo_dos_rdata,
            r_narrow_fifo_dos_rresp,
            r_narrow_fifo_dos_rlast,
            r_narrow_fifo_dos_ruser} = r_narrow_fifo_dos_data;

    // assign AXI outputs from FIFO signals
    assign s_axi4_rid     = r_narrow_fifo_dos_rid;
    assign s_axi4_rdata   = r_narrow_fifo_dos_rdata;
    assign s_axi4_rresp   = r_narrow_fifo_dos_rresp;
    assign s_axi4_rlast   = r_narrow_fifo_dos_rlast;
    assign s_axi4_ruser   = r_narrow_fifo_dos_ruser;
    assign s_axi4_rvalid  = r_narrow_fifo_dos_valid;

    // r_narrow_fifo instantiation
    hps_adapter_fifo #(
        .WIDTH                    (R_NARROW_FIFO_WIDTH),
        .LOG2_DEPTH               (FIFO_DEPTH_LOG2),
        .UPSTREAM_READY_LATENCY   (2),
        .DOWNSTREAM_READY_LATENCY (0)
    ) r_narrow_fifo (
        .aclk             (s_axi4_aclk),
        .aresetn          (s_axi4_aresetn),
        .upstream_ready   (r_narrow_fifo_ups_ready),
        .upstream_valid   (r_narrow_fifo_ups_valid),
        .upstream_data    (r_narrow_fifo_ups_data),
        .downstream_ready (r_narrow_fifo_dos_ready),
        .downstream_valid (r_narrow_fifo_dos_valid),
        .downstream_data  (r_narrow_fifo_dos_data)
    );

    /////////////////////////////
    // 1.6) sequential logic for AR
    assign s_axi4_arready = reg_s_axi4_arready;

    always @(posedge s_axi4_aclk or negedge s_axi4_aresetn) begin
        if (~s_axi4_aresetn) begin
            reg_s_axi4_arid    <= {INIU_AXI4_ID_WIDTH{1'b0}};
            reg_s_axi4_araddr  <= {INIU_AXI4_ADDR_WIDTH{1'b0}};
            reg_s_axi4_arlen   <= 8'b0;
            reg_s_axi4_arsize  <= 3'b0;
            reg_s_axi4_arburst <= 2'b0;
            reg_s_axi4_arlock  <= 1'b0;
            reg_s_axi4_arprot  <= 3'b0;
            reg_s_axi4_arqos   <= 4'b0;
            reg_s_axi4_aruser  <= {INIU_AXI4_ARUSER_WIDTH{1'b0}};
            reg_s_axi4_arvalid <= 1'b0;
            reg_s_axi4_arready <= 1'b0;
        end else begin
            // only read next cycle if there is room in FIFOs. FIFOs are
            // configured with upstream latency of 1, so any data read into
            // reg_s_axi4 can be passed along in the next cycle unconditionally
            reg_s_axi4_arready <= (ar_to_r_fifo_ups_ready && ar_cc_fifo_ups_ready);

            // register AR command
            if (s_axi4_arready && s_axi4_arvalid) begin
                reg_s_axi4_arvalid <= 1'b1;
                reg_s_axi4_arid    <= s_axi4_arid;
                reg_s_axi4_araddr  <= s_axi4_araddr;
                reg_s_axi4_arlen   <= s_axi4_arlen;
                reg_s_axi4_arsize  <= s_axi4_arsize;
                reg_s_axi4_arburst <= s_axi4_arburst;
                reg_s_axi4_arlock  <= s_axi4_arlock;
                reg_s_axi4_arprot  <= s_axi4_arprot;
                reg_s_axi4_arqos   <= s_axi4_arqos;
                reg_s_axi4_aruser  <= s_axi4_aruser;
            end else begin
                reg_s_axi4_arvalid <= 1'b0;
            end
        end
    end

    /////////////////////////////
    // 1.7) sequential + state transition logic for R
    logic [7:0]               r_assemble_curr_arlen;
    logic [SLICEID_WIDTH-1:0] r_assemble_curr_offset;
    logic [SLICEID_WIDTH-1:0] r_assemble_init_offset;
    logic                     r_assemble_shift_ready;

    logic [7:0]               r_assemble_next_arlen;
    logic [SLICEID_WIDTH-1:0] r_assemble_next_offset;
    logic                     r_assemble_is_last_slice;

    typedef enum {R_INIT, R_WAIT_AR, R_READ_NV, R_SHIFT_NV, R_READ_V, R_SHIFT_V, R_SHIFT_LAST} r_state_t;
    r_state_t r_state, next_r_state;

    // # state transition logic for W
    always @(*) begin
        next_r_state = r_state;
        r_assemble_next_offset = r_assemble_curr_offset;
        r_assemble_next_arlen = r_assemble_curr_arlen;
        r_assemble_is_last_slice = (r_assemble_curr_offset == ~ZERO_SLICE);

        case (r_state)
            R_INIT:
                next_r_state = R_WAIT_AR;
            R_WAIT_AR:
                if (ar_to_r_fifo_dos_valid && r_assemble_arready) begin
                    r_assemble_next_offset = ZERO_SLICE;
                    r_assemble_next_arlen = ar_to_r_fifo_dos_arlen;
                    if (ar_to_r_fifo_dos_slice == ZERO_SLICE) begin
                        next_r_state = R_READ_V;
                    end else begin
                        next_r_state = R_READ_NV;
                    end
                end
            R_READ_NV:
                if (reg_m_axi4_rready && r_cc_fifo_dos_valid) begin
                    r_assemble_next_offset = r_assemble_curr_offset + 1'b1;
                    if (r_assemble_next_offset == r_assemble_init_offset) begin
                        next_r_state = R_SHIFT_V;
                    end else begin
                        next_r_state = R_SHIFT_NV;
                    end
                end
            R_SHIFT_NV:
                if (r_assemble_shift_ready) begin
                    r_assemble_next_offset = r_assemble_curr_offset + 1'b1;
                    if (r_assemble_next_offset == r_assemble_init_offset) begin
                        next_r_state = R_SHIFT_V;
                    end
                end
            R_READ_V:
                if (reg_m_axi4_rready && r_cc_fifo_dos_valid) begin
                    r_assemble_next_offset = r_assemble_curr_offset + 1'b1;
                    if (r_assemble_curr_arlen == 8'b0) begin
                        next_r_state = R_SHIFT_LAST;
                    end else begin
                        r_assemble_next_arlen = r_assemble_curr_arlen - 1'b1;
                        next_r_state = R_SHIFT_V;
                    end
                end
            R_SHIFT_V:
                if (r_assemble_shift_ready) begin
                    r_assemble_next_offset = r_assemble_curr_offset + 1'b1;
                    if (r_assemble_curr_arlen == 8'b0) begin
                        if (r_assemble_is_last_slice) begin
                            next_r_state = R_WAIT_AR;
                        end else begin
                            next_r_state = R_SHIFT_LAST;
                        end
                    end else begin
                        r_assemble_next_arlen = r_assemble_curr_arlen - 1'b1;
                        if (r_assemble_is_last_slice) begin
                            next_r_state = R_READ_V;
                        end
                    end
                end
            R_SHIFT_LAST:
                if (r_assemble_shift_ready) begin
                    r_assemble_next_offset = r_assemble_curr_offset + 1'b1;
                    if (r_assemble_is_last_slice) begin
                        next_r_state = R_WAIT_AR;
                    end
                end
            default:
                next_r_state = R_INIT;
        endcase
    end

    // # sequential logic for R
    always @(posedge s_axi4_aclk or negedge s_axi4_aresetn) begin
        if (~s_axi4_aresetn) begin
            // reset state and readies
            r_state <= R_INIT;

            r_assemble_arready     <= 1'b0;
            r_assemble_curr_arlen  <= 8'b0;
            r_assemble_curr_offset <= ZERO_SLICE;
            r_assemble_init_offset <= ZERO_SLICE;
            r_assemble_shift_ready <= 1'b0;
    
            reg_m_axi4_rid    <= {INIU_AXI4_ID_WIDTH {1'b0}};
            reg_m_axi4_rdata  <= {INIU_AXI4_DATA_WIDTH {1'b0}};
            reg_m_axi4_rresp  <= 2'b0;
            reg_m_axi4_rlast  <= 1'b0;
            reg_m_axi4_ruser  <= {(INIU_AXI4_DATA_WIDTH/8) {1'b0}};
            reg_m_axi4_rvalid <= 1'b0;
            reg_m_axi4_rready <= 1'b0;
    
            reg_narrow_axi4_rid    <= {INIU_AXI4_ID_WIDTH {1'b0}};
            reg_narrow_axi4_rdata  <= {HPS_AXI4_DATA_WIDTH {1'b0}};
            reg_narrow_axi4_rresp  <= 2'b0;
            reg_narrow_axi4_rlast  <= 1'b0;
            reg_narrow_axi4_ruser  <= {(HPS_AXI4_DATA_WIDTH/8) {1'b0}};
            reg_narrow_axi4_rvalid <= 1'b0;
            reg_narrow_axi4_rready <= 1'b0;

        end else begin
            // state
            r_state <= next_r_state;

            // readies from state machine to AR and R inputs
            r_assemble_arready <= (next_r_state == R_WAIT_AR);
            reg_m_axi4_rready <= ((next_r_state == R_READ_NV) || (next_r_state == R_READ_V)) && reg_narrow_axi4_rready;
            r_assemble_shift_ready <= ((next_r_state == R_SHIFT_NV) || (next_r_state == R_SHIFT_V) || (next_r_state == R_SHIFT_LAST)) &&
                                      reg_narrow_axi4_rready;

            // ready from stage with narrow registers to state machine
            reg_narrow_axi4_rready <= r_narrow_fifo_ups_ready;

            // register fields used to track wide W assembly
            r_assemble_curr_arlen <= r_assemble_next_arlen;
            r_assemble_curr_offset <= r_assemble_next_offset;

            // register initial offset of the burst in the wide W data
            if (ar_to_r_fifo_dos_valid && r_assemble_arready) begin
                r_assemble_init_offset <= ar_to_r_fifo_dos_slice;
            end

            // register wide R beat
            if (reg_m_axi4_rready && r_cc_fifo_dos_valid) begin
                reg_m_axi4_rid    <= r_cc_fifo_dos_rid;
                reg_m_axi4_rdata  <= r_cc_fifo_dos_rdata;
                reg_m_axi4_rresp  <= r_cc_fifo_dos_rresp;
                reg_m_axi4_rlast  <= (r_state == R_READ_V) && (r_assemble_curr_arlen == 8'b0);
                reg_m_axi4_ruser  <= r_cc_fifo_dos_ruser;
                reg_m_axi4_rvalid <= (r_state == R_READ_V);
            end else if (r_assemble_shift_ready) begin
                reg_m_axi4_rid    <= reg_m_axi4_rid;
                reg_m_axi4_rdata  <= reg_m_axi4_rdata >> HPS_AXI4_DATA_WIDTH;
                reg_m_axi4_rresp  <= reg_m_axi4_rresp;
                reg_m_axi4_rlast  <= (r_state == R_SHIFT_V) && (r_assemble_curr_arlen == 8'b0);
                reg_m_axi4_ruser  <= reg_m_axi4_ruser >> (HPS_AXI4_DATA_WIDTH/8);
                reg_m_axi4_rvalid <= (r_state == R_SHIFT_V);
            end else begin
                reg_m_axi4_rvalid <= 1'b0;
            end

            // send narrow R beat to output FIFO
            if (reg_narrow_axi4_rvalid) begin
                reg_narrow_axi4_rvalid <= 1'b0;
            end

            // shift new data into narrow R beat
            if (reg_m_axi4_rvalid) begin
                reg_narrow_axi4_rid    <= reg_m_axi4_rid;
                reg_narrow_axi4_rdata  <= reg_m_axi4_rdata[HPS_AXI4_DATA_WIDTH-1:0];
                reg_narrow_axi4_rresp  <= reg_m_axi4_rresp;
                reg_narrow_axi4_rlast  <= reg_m_axi4_rlast;
                reg_narrow_axi4_ruser  <= reg_m_axi4_ruser[(HPS_AXI4_DATA_WIDTH/8)-1:0];
                reg_narrow_axi4_rvalid <= 1'b1;
            end
        end
    end

    ///////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    // 2) Write channels AW, W, B channels

    /////////////////////////////
    // 2.1) main input/output registers
    // register received AW signals
    logic [INIU_AXI4_ID_WIDTH-1:0]       reg_s_axi4_awid;
    logic [INIU_AXI4_ADDR_WIDTH-1:0]     reg_s_axi4_awaddr;
    logic [7:0]                          reg_s_axi4_awlen;
    logic [2:0]                          reg_s_axi4_awsize;
    logic [1:0]                          reg_s_axi4_awburst;
    logic                                reg_s_axi4_awlock;
    logic [2:0]                          reg_s_axi4_awprot;
    logic [3:0]                          reg_s_axi4_awqos;
    logic [INIU_AXI4_AWUSER_WIDTH-1:0]   reg_s_axi4_awuser;
    logic                                reg_s_axi4_awvalid;
    logic                                reg_s_axi4_awready;

    // register received W signals
    logic [HPS_AXI4_DATA_WIDTH-1:0]      reg_s_axi4_wdata;
    logic [(HPS_AXI4_DATA_WIDTH/8)-1:0]  reg_s_axi4_wstrb;
    logic                                reg_s_axi4_wlast;
    logic [(HPS_AXI4_DATA_WIDTH/8)-1:0]  reg_s_axi4_wuser;
    logic                                reg_s_axi4_wvalid;
    logic                                reg_s_axi4_wready;

    // assemble wide W signals
    logic [INIU_AXI4_DATA_WIDTH-1:0]     reg_wide_axi4_wdata;
    logic [(INIU_AXI4_DATA_WIDTH/8)-1:0] reg_wide_axi4_wstrb;
    logic                                reg_wide_axi4_wlast;
    logic [(INIU_AXI4_DATA_WIDTH/8)-1:0] reg_wide_axi4_wuser;
    logic                                reg_wide_axi4_wvalid;
    logic                                reg_wide_axi4_wready;

    // wide W logic ready to receive new AW
    logic                                w_assemble_awready;

    // slice of the wide wdata where the first narrow wdata occurs
    logic [SLICEID_WIDTH-1:0]            slice_reg_s_axi4_awaddr;

    assign slice_reg_s_axi4_awaddr = reg_s_axi4_awaddr[HPS_ALIGN_WIDTH +: SLICEID_WIDTH];

    /////////////////////////////
    // 2.2) FIFO for passing relevant info from AW to W assembling logic
    // FIFO width:
    localparam AW_TO_W_FIFO_WIDTH = SLICEID_WIDTH + // offset in wide word
                                    8;              // awlen

    // declare FIFO signals
    logic aw_to_w_fifo_ups_ready;
    logic aw_to_w_fifo_ups_valid;
    logic [AW_TO_W_FIFO_WIDTH-1:0] aw_to_w_fifo_ups_data;
    logic [SLICEID_WIDTH-1:0] aw_to_w_fifo_ups_slice;
    logic [7:0] aw_to_w_fifo_ups_awlen;

    logic aw_to_w_fifo_dos_ready;
    logic aw_to_w_fifo_dos_valid;
    logic [AW_TO_W_FIFO_WIDTH-1:0] aw_to_w_fifo_dos_data;
    logic [SLICEID_WIDTH-1:0] aw_to_w_fifo_dos_slice;
    logic [7:0] aw_to_w_fifo_dos_awlen;

    // assign FIFO signals
    assign aw_to_w_fifo_ups_valid = reg_s_axi4_awvalid;
    assign aw_to_w_fifo_ups_slice = slice_reg_s_axi4_awaddr;
    assign aw_to_w_fifo_ups_awlen = reg_s_axi4_awlen;
    assign aw_to_w_fifo_ups_data = {aw_to_w_fifo_ups_slice,
                                    aw_to_w_fifo_ups_awlen};

    assign aw_to_w_fifo_dos_ready = w_assemble_awready;
    assign {aw_to_w_fifo_dos_slice,
            aw_to_w_fifo_dos_awlen} = aw_to_w_fifo_dos_data;

    // aw_to_w_fifo instantiation
    hps_adapter_fifo #(
        .WIDTH                    (AW_TO_W_FIFO_WIDTH),
        .LOG2_DEPTH               (FIFO_DEPTH_LOG2),
        .UPSTREAM_READY_LATENCY   (1),
        .DOWNSTREAM_READY_LATENCY (0)
    ) aw_to_w_fifo (
        .aclk             (s_axi4_aclk),
        .aresetn          (s_axi4_aresetn),
        .upstream_ready   (aw_to_w_fifo_ups_ready),
        .upstream_valid   (aw_to_w_fifo_ups_valid),
        .upstream_data    (aw_to_w_fifo_ups_data),
        .downstream_ready (aw_to_w_fifo_dos_ready),
        .downstream_valid (aw_to_w_fifo_dos_valid),
        .downstream_data  (aw_to_w_fifo_dos_data)
    );

    /////////////////////////////
    // 2.3) clock crossing FIFO with adjusted AW commands
    // FIFO width:
    localparam AW_CC_FIFO_WIDTH = INIU_AXI4_ID_WIDTH +    // awid
                                  INIU_AXI4_ADDR_WIDTH +  // awaddr
                                  8 +                     // awlen
                                  3 +                     // awsize
                                  2 +                     // awburst
                                  1 +                     // awlock
                                  3 +                     // awprot
                                  4 +                     // awqos
                                  INIU_AXI4_AWUSER_WIDTH; // awuser

    // declare FIFO signals
    logic                                aw_cc_fifo_ups_ready;
    logic                                aw_cc_fifo_ups_valid;
    logic [AW_CC_FIFO_WIDTH-1:0]         aw_cc_fifo_ups_data;
    logic [INIU_AXI4_ID_WIDTH-1:0]       aw_cc_fifo_ups_awid;
    logic [INIU_AXI4_ADDR_WIDTH-1:0]     aw_cc_fifo_ups_awaddr;
    logic [7:0]                          aw_cc_fifo_ups_awlen;
    logic [2:0]                          aw_cc_fifo_ups_awsize;
    logic [1:0]                          aw_cc_fifo_ups_awburst;
    logic                                aw_cc_fifo_ups_awlock;
    logic [2:0]                          aw_cc_fifo_ups_awprot;
    logic [3:0]                          aw_cc_fifo_ups_awqos;
    logic [INIU_AXI4_AWUSER_WIDTH-1:0]   aw_cc_fifo_ups_awuser;

    logic                                aw_cc_fifo_dos_ready;
    logic                                aw_cc_fifo_dos_valid;
    logic [AW_CC_FIFO_WIDTH-1:0]         aw_cc_fifo_dos_data;
    logic [INIU_AXI4_ID_WIDTH-1:0]       aw_cc_fifo_dos_awid;
    logic [INIU_AXI4_ADDR_WIDTH-1:0]     aw_cc_fifo_dos_awaddr;
    logic [7:0]                          aw_cc_fifo_dos_awlen;
    logic [2:0]                          aw_cc_fifo_dos_awsize;
    logic [1:0]                          aw_cc_fifo_dos_awburst;
    logic                                aw_cc_fifo_dos_awlock;
    logic [2:0]                          aw_cc_fifo_dos_awprot;
    logic [3:0]                          aw_cc_fifo_dos_awqos;
    logic [INIU_AXI4_AWUSER_WIDTH-1:0]   aw_cc_fifo_dos_awuser;

    // logic for adjusting awlen for the wide interface
    logic [7:0] adjusted_awlen;
    logic [8:0] total_awlen_slices;

    always @(*) begin
        // basic calculation: adjusted awlen is the total number of narrow beats + offset,
        // divided by number of slices.
        // As awlen = number of beats - 1, we end up with an adjusted_awlen
        // increased by 1. This is ok if total_awlen_slices does not correspond
        // to an integer number of wide beats, as an additional wide beat is
        // required for the remaining slices after the division. If total_awlen_slices
        // does correspond to an integer number of wide beats, we subtract 1 in
        // the if block below
        total_awlen_slices = reg_s_axi4_awlen + slice_reg_s_axi4_awaddr + 1'b1;
        // Division by the number of slices
        adjusted_awlen = total_awlen_slices >> SLICEID_WIDTH;
        // Correct awlen if aligned to wide block
        if (total_awlen_slices[SLICEID_WIDTH-1:0] == ZERO_SLICE) begin
            adjusted_awlen = adjusted_awlen - 1'b1;
        end
    end

    // assign FIFO signals, adjusting AW command as follows:
    // - awaddr has the LSB INIU_ALIGN_WIDTH bits zeroed, to be aligned to the
    // INIU width
    // - awlen is adjusted per the logic above
    // - other signals stay the same
    assign aw_cc_fifo_ups_valid   = reg_s_axi4_awvalid;
    assign aw_cc_fifo_ups_awid    = reg_s_axi4_awid;
    assign aw_cc_fifo_ups_awaddr  = reg_s_axi4_awaddr & MASK_INIU_ALIGN;
    assign aw_cc_fifo_ups_awlen   = adjusted_awlen;
    assign aw_cc_fifo_ups_awsize  = INIU_ALIGN_WIDTH;
    assign aw_cc_fifo_ups_awburst = reg_s_axi4_awburst;
    assign aw_cc_fifo_ups_awlock  = reg_s_axi4_awlock;
    assign aw_cc_fifo_ups_awprot  = reg_s_axi4_awprot;
    assign aw_cc_fifo_ups_awqos   = reg_s_axi4_awqos;
    assign aw_cc_fifo_ups_awuser  = reg_s_axi4_awuser;
    assign aw_cc_fifo_ups_data    = {aw_cc_fifo_ups_awid,
                                     aw_cc_fifo_ups_awaddr,
                                     aw_cc_fifo_ups_awlen,
                                     aw_cc_fifo_ups_awsize,
                                     aw_cc_fifo_ups_awburst,
                                     aw_cc_fifo_ups_awlock,
                                     aw_cc_fifo_ups_awprot,
                                     aw_cc_fifo_ups_awqos,
                                     aw_cc_fifo_ups_awuser};

    assign aw_cc_fifo_dos_ready = m_axi4_awready;
    assign {aw_cc_fifo_dos_awid,
            aw_cc_fifo_dos_awaddr,
            aw_cc_fifo_dos_awlen,
            aw_cc_fifo_dos_awsize,
            aw_cc_fifo_dos_awburst,
            aw_cc_fifo_dos_awlock,
            aw_cc_fifo_dos_awprot,
            aw_cc_fifo_dos_awqos,
            aw_cc_fifo_dos_awuser} = aw_cc_fifo_dos_data;

    // assign AXI outputs from FIFO signals
    assign m_axi4_awvalid = aw_cc_fifo_dos_valid;
    assign m_axi4_awid    = aw_cc_fifo_dos_awid;
    assign m_axi4_awaddr  = aw_cc_fifo_dos_awaddr;
    assign m_axi4_awlen   = aw_cc_fifo_dos_awlen;
    assign m_axi4_awsize  = aw_cc_fifo_dos_awsize;
    assign m_axi4_awburst = aw_cc_fifo_dos_awburst;
    assign m_axi4_awlock  = aw_cc_fifo_dos_awlock;
    assign m_axi4_awprot  = aw_cc_fifo_dos_awprot;
    assign m_axi4_awqos   = aw_cc_fifo_dos_awqos;
    assign m_axi4_awuser  = aw_cc_fifo_dos_awuser;

    // FIFO instantiation
    hps_adapter_clock_crossing_fifo #(
        .WIDTH                    (AW_CC_FIFO_WIDTH),
        .LOG2_DEPTH               (FIFO_DEPTH_LOG2),
        .UPSTREAM_READY_LATENCY   (1),
        .DOWNSTREAM_READY_LATENCY (0)
    ) aw_cc_fifo (
        .upstream_clk       (s_axi4_aclk),
        .upstream_aresetn   (s_axi4_aresetn),
        .upstream_ready     (aw_cc_fifo_ups_ready),
        .upstream_valid     (aw_cc_fifo_ups_valid),
        .upstream_data      (aw_cc_fifo_ups_data),
        .downstream_clk     (s_axi4_aclk),
        .downstream_aresetn (s_axi4_aresetn),
        .downstream_ready   (aw_cc_fifo_dos_ready),
        .downstream_valid   (aw_cc_fifo_dos_valid),
        .downstream_data    (aw_cc_fifo_dos_data),
        .upstream_occupancy ()
    );

    /////////////////////////////
    // 2.4) clock crossing FIFO with wide W beat assembled from narrow writes
    localparam W_CC_FIFO_WIDTH = INIU_AXI4_DATA_WIDTH +     // wdata
                                 (INIU_AXI4_DATA_WIDTH/8) + // wstrb
                                 1 +                        // wlast
                                 (INIU_AXI4_DATA_WIDTH/8);  // wuser

    // declare FIFO signals
    logic                                w_cc_fifo_ups_ready;
    logic                                w_cc_fifo_ups_valid;
    logic [W_CC_FIFO_WIDTH-1:0]          w_cc_fifo_ups_data;
    logic [INIU_AXI4_DATA_WIDTH-1:0]     w_cc_fifo_ups_wdata;
    logic [(INIU_AXI4_DATA_WIDTH/8)-1:0] w_cc_fifo_ups_wstrb;
    logic                                w_cc_fifo_ups_wlast;
    logic [(INIU_AXI4_DATA_WIDTH/8)-1:0] w_cc_fifo_ups_wuser;

    logic                                w_cc_fifo_dos_ready;
    logic                                w_cc_fifo_dos_valid;
    logic [W_CC_FIFO_WIDTH-1:0]          w_cc_fifo_dos_data;
    logic [INIU_AXI4_DATA_WIDTH-1:0]     w_cc_fifo_dos_wdata;
    logic [(INIU_AXI4_DATA_WIDTH/8)-1:0] w_cc_fifo_dos_wstrb;
    logic                                w_cc_fifo_dos_wlast;
    logic [(INIU_AXI4_DATA_WIDTH/8)-1:0] w_cc_fifo_dos_wuser;

    // assign FIFO signals
    assign w_cc_fifo_ups_valid = reg_wide_axi4_wvalid;
    assign w_cc_fifo_ups_wdata = reg_wide_axi4_wdata;
    assign w_cc_fifo_ups_wstrb = reg_wide_axi4_wstrb;
    assign w_cc_fifo_ups_wlast = reg_wide_axi4_wlast;
    assign w_cc_fifo_ups_wuser = reg_wide_axi4_wuser;
    assign w_cc_fifo_ups_data  = {w_cc_fifo_ups_wdata,
                                  w_cc_fifo_ups_wstrb,
                                  w_cc_fifo_ups_wlast,
                                  w_cc_fifo_ups_wuser};

    assign w_cc_fifo_dos_ready = m_axi4_wready;
    assign {w_cc_fifo_dos_wdata,
            w_cc_fifo_dos_wstrb,
            w_cc_fifo_dos_wlast,
            w_cc_fifo_dos_wuser} = w_cc_fifo_dos_data;

    // assign AXI outputs from FIFO signals
    assign m_axi4_wvalid = w_cc_fifo_dos_valid;
    assign m_axi4_wdata  = w_cc_fifo_dos_wdata;
    assign m_axi4_wstrb  = w_cc_fifo_dos_wstrb;
    assign m_axi4_wlast  = w_cc_fifo_dos_wlast;
    assign m_axi4_wuser  = w_cc_fifo_dos_wuser;

    // FIFO instantiation
    hps_adapter_clock_crossing_fifo #(
        .WIDTH                    (W_CC_FIFO_WIDTH),
        .LOG2_DEPTH               (FIFO_DEPTH_LOG2),
        .UPSTREAM_READY_LATENCY   (2),
        .DOWNSTREAM_READY_LATENCY (0)
    ) w_cc_fifo (
        .upstream_clk       (s_axi4_aclk),
        .upstream_aresetn   (s_axi4_aresetn),
        .upstream_ready     (w_cc_fifo_ups_ready),
        .upstream_valid     (w_cc_fifo_ups_valid),
        .upstream_data      (w_cc_fifo_ups_data),
        .downstream_clk     (s_axi4_aclk),
        .downstream_aresetn (s_axi4_aresetn),
        .downstream_ready   (w_cc_fifo_dos_ready),
        .downstream_valid   (w_cc_fifo_dos_valid),
        .downstream_data    (w_cc_fifo_dos_data),
        .upstream_occupancy ()
    );

    /////////////////////////////
    // 2.5) clock crossing FIFO with reponse to wide commands. as the response has
    // the same size regardless of data width, no adjustments are required
    localparam B_CC_FIFO_WIDTH = INIU_AXI4_ID_WIDTH + // bid
                                 2;                   // bresp

    // FIFO instantiation
    hps_adapter_clock_crossing_fifo #(
        .WIDTH                    (B_CC_FIFO_WIDTH),
        .LOG2_DEPTH               (FIFO_DEPTH_LOG2),
        .UPSTREAM_READY_LATENCY   (0),
        .DOWNSTREAM_READY_LATENCY (0)
    ) b_cc_fifo (
        .upstream_clk       (s_axi4_aclk),
        .upstream_aresetn   (s_axi4_aresetn),
        .upstream_ready     (m_axi4_bready),
        .upstream_valid     (m_axi4_bvalid),
        .upstream_data      ({m_axi4_bid,m_axi4_bresp}),
        .downstream_clk     (s_axi4_aclk),
        .downstream_aresetn (s_axi4_aresetn),
        .downstream_ready   (s_axi4_bready),
        .downstream_valid   (s_axi4_bvalid),
        .downstream_data    ({s_axi4_bid,s_axi4_bresp}),
        .upstream_occupancy ()
    );

    /////////////////////////////
    // 2.6) sequential logic for AW
    assign s_axi4_awready = reg_s_axi4_awready;

    always @(posedge s_axi4_aclk or negedge s_axi4_aresetn) begin
        if (~s_axi4_aresetn) begin
            reg_s_axi4_awid    <= {INIU_AXI4_ID_WIDTH{1'b0}};
            reg_s_axi4_awaddr  <= {INIU_AXI4_ADDR_WIDTH{1'b0}};
            reg_s_axi4_awlen   <= 8'b0;
            reg_s_axi4_awsize  <= 3'b0;
            reg_s_axi4_awburst <= 2'b0;
            reg_s_axi4_awlock  <= 1'b0;
            reg_s_axi4_awprot  <= 3'b0;
            reg_s_axi4_awqos   <= 4'b0;
            reg_s_axi4_awuser  <= {INIU_AXI4_AWUSER_WIDTH{1'b0}};
            reg_s_axi4_awvalid <= 1'b0;
            reg_s_axi4_awready <= 1'b0;
        end else begin
            // only read next cycle if there is room in FIFOs. FIFOs are
            // configured with upstream latency of 1, so any data read into
            // reg_s_axi4 can be passed along in the next cycle unconditionally
            reg_s_axi4_awready <= (aw_to_w_fifo_ups_ready && aw_cc_fifo_ups_ready);

            // register AW command
            if (s_axi4_awready && s_axi4_awvalid) begin
                reg_s_axi4_awvalid <= 1'b1;
                reg_s_axi4_awid    <= s_axi4_awid;
                reg_s_axi4_awaddr  <= s_axi4_awaddr;
                reg_s_axi4_awlen   <= s_axi4_awlen;
                reg_s_axi4_awsize  <= s_axi4_awsize;
                reg_s_axi4_awburst <= s_axi4_awburst;
                reg_s_axi4_awlock  <= s_axi4_awlock;
                reg_s_axi4_awprot  <= s_axi4_awprot;
                reg_s_axi4_awqos   <= s_axi4_awqos;
                reg_s_axi4_awuser  <= s_axi4_awuser;
            end else begin
                reg_s_axi4_awvalid <= 1'b0;
            end
        end
    end

    /////////////////////////////
    // 2.7) sequential + state transition logic for W
    logic [7:0]               w_assemble_curr_awlen;
    logic [SLICEID_WIDTH-1:0] w_assemble_curr_offset;
    logic [SLICEID_WIDTH-1:0] w_assemble_init_offset;
    logic                     w_assemble_shift_ready;
    logic                     w_assemble_slice_valid;

    logic [7:0]               w_assemble_next_awlen;
    logic [SLICEID_WIDTH-1:0] w_assemble_next_offset;
    logic                     w_assemble_is_last_slice;

    typedef enum {W_INIT, W_WAIT_AW, W_SHIFT_FIRST, W_READ, W_SHIFT_LAST} w_state_t;
    w_state_t w_state, next_w_state;

    // # state transition logic for W
    always @(*) begin
        next_w_state = w_state;
        w_assemble_next_offset = w_assemble_curr_offset;
        w_assemble_next_awlen = w_assemble_curr_awlen;
        w_assemble_is_last_slice = (w_assemble_curr_offset == ~ZERO_SLICE);

        case (w_state)
            W_INIT:
                next_w_state = W_WAIT_AW;
            W_WAIT_AW:
                if (aw_to_w_fifo_dos_valid && w_assemble_awready) begin
                    w_assemble_next_offset = ZERO_SLICE;
                    w_assemble_next_awlen = aw_to_w_fifo_dos_awlen;
                    if (aw_to_w_fifo_dos_slice == ZERO_SLICE) begin
                        next_w_state = W_READ;
                    end else begin
                        next_w_state = W_SHIFT_FIRST;
                    end
                end
            W_SHIFT_FIRST:
                if (w_assemble_shift_ready) begin
                    w_assemble_next_offset = w_assemble_curr_offset + 1'b1;
                    if (w_assemble_next_offset == w_assemble_init_offset) begin
                        next_w_state = W_READ;
                    end
                end
            W_READ:
                if (s_axi4_wready && s_axi4_wvalid) begin
                    w_assemble_next_offset = w_assemble_curr_offset + 1'b1;
                    if (w_assemble_curr_awlen == 8'b0) begin
                        if (w_assemble_is_last_slice) begin
                            next_w_state = W_WAIT_AW;
                        end else begin
                            next_w_state = W_SHIFT_LAST;
                        end
                    end else begin
                        w_assemble_next_awlen = w_assemble_curr_awlen - 1'b1;
                    end
                end
            W_SHIFT_LAST:
                if (w_assemble_shift_ready) begin
                    w_assemble_next_offset = w_assemble_curr_offset + 1'b1;
                    if (w_assemble_is_last_slice) begin
                        next_w_state = W_WAIT_AW;
                    end
                end
            default:
                next_w_state = W_INIT;
        endcase
    end

    // # sequential logic for W
    assign s_axi4_wready = reg_s_axi4_wready;

    always @(posedge s_axi4_aclk or negedge s_axi4_aresetn) begin
        if (~s_axi4_aresetn) begin
            // reset state and readies
            w_state <= W_INIT;

            w_assemble_awready     <= 1'b0;
            w_assemble_curr_awlen  <= 8'b0;
            w_assemble_curr_offset <= ZERO_SLICE;
            w_assemble_init_offset <= ZERO_SLICE;
            w_assemble_shift_ready <= 1'b0;
            w_assemble_slice_valid <= 1'b0;

            reg_s_axi4_wdata  <= {HPS_AXI4_DATA_WIDTH {1'b0}};
            reg_s_axi4_wstrb  <= {(HPS_AXI4_DATA_WIDTH/8) {1'b0}};
            reg_s_axi4_wlast  <= 1'b0;
            reg_s_axi4_wuser  <= {(HPS_AXI4_DATA_WIDTH/8) {1'b0}};
            reg_s_axi4_wvalid <= 1'b0;
            reg_s_axi4_wready <= 1'b0;

            reg_wide_axi4_wdata  <= {INIU_AXI4_DATA_WIDTH {1'b0}};
            reg_wide_axi4_wstrb  <= {(INIU_AXI4_DATA_WIDTH/8) {1'b0}};
            reg_wide_axi4_wlast  <= 1'b0;
            reg_wide_axi4_wuser  <= {(INIU_AXI4_DATA_WIDTH/8) {1'b0}};
            reg_wide_axi4_wvalid <= 1'b0;
            reg_wide_axi4_wready <= 1'b0;
        end else begin
            // state
            w_state <= next_w_state;

            // readies from state machine to AW and W inputs
            w_assemble_awready <= (next_w_state == W_WAIT_AW);
            reg_s_axi4_wready <= (next_w_state == W_READ) && reg_wide_axi4_wready;
            w_assemble_shift_ready <= ((next_w_state == W_SHIFT_FIRST) || (next_w_state == W_SHIFT_LAST)) && reg_wide_axi4_wready;

            // ready from stage with wide registers to state machine
            reg_wide_axi4_wready <= w_cc_fifo_ups_ready;

            // register fields used to track wide W assembly
            w_assemble_curr_awlen <= w_assemble_next_awlen;
            w_assemble_curr_offset <= w_assemble_next_offset;

            // register initial offset of the burst in the wide W data
            if (aw_to_w_fifo_dos_valid && w_assemble_awready) begin
                w_assemble_init_offset <= aw_to_w_fifo_dos_slice;
            end

            // register narrow W command
            // read data to be shifted into wide wdata register
            // s_axi4_wready is pipelined from the FIFO configured with
            // upstream latency of 2, so data read with the handshake below can
            // proceed through the reg_s_axi4 -> reg_wide_axi4 pipeline and the
            // FIFO without interruptions
            if (s_axi4_wready && s_axi4_wvalid) begin
                reg_s_axi4_wdata  <= s_axi4_wdata;
                reg_s_axi4_wstrb  <= s_axi4_wstrb;
                reg_s_axi4_wlast  <= s_axi4_wlast;
                reg_s_axi4_wuser  <= s_axi4_wuser;
                reg_s_axi4_wvalid <= w_assemble_is_last_slice;
                // valid to signal that data can be shifted in by wide register
                w_assemble_slice_valid <= 1'b1;
            end else if (w_assemble_shift_ready) begin
                // pass a narrow word of data that won't be written, to just
                // "shift right" the register with the wide W data
                reg_s_axi4_wstrb  <= {(HPS_AXI4_DATA_WIDTH/8) {1'b0}};
                reg_s_axi4_wlast  <= 1'b0;
                reg_s_axi4_wvalid <= w_assemble_is_last_slice;
                // valid to signal that data can be shifted in by wide register
                w_assemble_slice_valid <= 1'b1;
            end else begin
                // invalidate data if only shifting out but not receiving any
                // new data
                w_assemble_slice_valid <= 1'b0;
            end

            // send wide data to clock crossing FIFO
            if (reg_wide_axi4_wvalid) begin
                reg_wide_axi4_wvalid <= 1'b0;
                reg_wide_axi4_wlast <= 1'b0;
            end

            // shift new data into wide W beat
            if (w_assemble_slice_valid) begin
                reg_wide_axi4_wdata  <= {reg_s_axi4_wdata, reg_wide_axi4_wdata[INIU_AXI4_DATA_WIDTH-1:HPS_AXI4_DATA_WIDTH]};
                reg_wide_axi4_wstrb  <= {reg_s_axi4_wstrb, reg_wide_axi4_wstrb[(INIU_AXI4_DATA_WIDTH/8)-1:(HPS_AXI4_DATA_WIDTH/8)]};
                reg_wide_axi4_wlast  <= reg_wide_axi4_wlast || reg_s_axi4_wlast;
                reg_wide_axi4_wuser  <= {reg_s_axi4_wuser, reg_wide_axi4_wuser[(INIU_AXI4_DATA_WIDTH/8)-1:(HPS_AXI4_DATA_WIDTH/8)]};
                reg_wide_axi4_wvalid <= reg_s_axi4_wvalid;
            end
        end
    end

endmodule


/* FIFO for AXI4-like command or write data channels with potentially different upstream and downstream (hardware-side)
   ready latencies. Ready latencies can be specified as 0 (standard AXI handshaking), 1, or 2.
   By AXI like it is meant that the signals are as per AXI, but the transfer handshake permits a delay of 1 or 2 cycles
   between de-assertion of ready and the flow of data. The logic is robust in that it does not require the upstream logic
   to de-assert valid when ready has been de-asserted, and it correctly de-asserts valid to downstream logic in response
   to de-assertion of ready from downstream.
   This version of the module uses the standard scfifo IP which is known to limit fMax on Hyperflex devices and may
   therefore need to switch to a different FIFO IP such as fifo2.
   The FIFO is always implemented in MLABs. LOG2_DEPTH of 5 results in very similar resource utilization to all smaller depths.
*/
module hps_adapter_fifo #(
        parameter WIDTH                    = 32,
        parameter LOG2_DEPTH               = 5,
        parameter UPSTREAM_READY_LATENCY   = 2,
        parameter DOWNSTREAM_READY_LATENCY = 2
    ) (
        input  wire            aclk,
        input  wire            aresetn,
        output wire            upstream_ready,
        input  wire            upstream_valid,
        input  wire[WIDTH-1:0] upstream_data,
        input  wire            downstream_ready,
        output wire            downstream_valid,
        output wire[WIDTH-1:0] downstream_data
    );

    initial begin
        assert (UPSTREAM_READY_LATENCY   >= 0 && UPSTREAM_READY_LATENCY   <= 2);
        assert (DOWNSTREAM_READY_LATENCY >= 0 && DOWNSTREAM_READY_LATENCY <= 2);
    end

    localparam DEPTH = (1 << LOG2_DEPTH) - 1;

    wire empty;
    wire rdreq;
    reg  rdreq_r;
    wire wrreq;
    wire almost_full;
    reg  almost_full_r;
    reg  almost_full_rr;


    reg  downstream_ready_r;

    always @(posedge aclk or negedge aresetn) begin
        if (~aresetn) begin
            downstream_ready_r <= 1'b0;
        end else begin
            downstream_ready_r <= downstream_ready;
        end
    end

    assign rdreq = (~empty) & ((DOWNSTREAM_READY_LATENCY == 2) ? downstream_ready_r : downstream_ready);


    assign wrreq = upstream_valid & ((UPSTREAM_READY_LATENCY == 0) ? ~almost_full
                                    :(UPSTREAM_READY_LATENCY == 1) ? ~almost_full_r
                                    :(UPSTREAM_READY_LATENCY == 2) ? ~almost_full_rr
                                                                   : 1'b0);


    assign downstream_valid = (DOWNSTREAM_READY_LATENCY == 0) ? ~empty : rdreq_r;

    scfifo # (
        .lpm_hint          ("RAM_BLOCK_TYPE=MLAB"),
        .lpm_width         (WIDTH),
        .lpm_widthu        (LOG2_DEPTH),
        .lpm_numwords      (DEPTH),
        .lpm_showahead     ((DOWNSTREAM_READY_LATENCY == 0) ? "ON" : "OFF"),
        .almost_full_value (DEPTH-UPSTREAM_READY_LATENCY),
        .use_eab           ("ON"),                         // always "ON", to enable MLAB implementation
        .overflow_checking ("OFF"),
        .underflow_checking("OFF")
    ) fifo (
        .clock       (aclk),
        .sclr        (~aresetn),
        .aclr        (1'b0),
        .wrreq       (wrreq),
        .data        (upstream_data),
        .rdreq       (rdreq),
        .q           (downstream_data),
        .empty       (empty),
        .almost_empty(),
        .almost_full (almost_full),
        .full        (),
        .usedw       (),
        .eccstatus   ()
    );

    assign upstream_ready = ~almost_full;

    always @(posedge aclk) begin
        rdreq_r        <= rdreq;
        almost_full_r  <= almost_full;
        almost_full_rr <= almost_full_r;
    end

endmodule


/* clock crossing fifo, adapted from the backpressure tester's fifo module
   This module places no expectations on the relationship between clock and reset, leveraging
   the dcfifo reset synchronization option to aviod race conditions and enabling the user of
   the module to use either upstream or downstream reset at will.
   The almost_full condition cannot be directly obtained from a dcfifo, so must be based on rdusedw.
   The dcfifo takes 2 cycles to reflect writes in wrusedw, and there is an internal register
   stage in this module's conversion of wrusedw to wralmostfull. Therefore upstream is backpressured when
   rdusedw >= (2**LOG2_DEPTH) - (UPSTREAM_READY_LATENCY+4)
*/

module hps_adapter_clock_crossing_fifo #(
        parameter WIDTH                    = 32,
        parameter LOG2_DEPTH               = 5,
        parameter UPSTREAM_READY_LATENCY   = 2,
        parameter DOWNSTREAM_READY_LATENCY = 2
    ) (
        input  wire                 upstream_aresetn,
        input  wire                 upstream_clk,
        output wire                 upstream_ready,
        input  wire                 upstream_valid,
        input  wire[WIDTH-1:0]      upstream_data,
        input  wire                 downstream_aresetn,
        input  wire                 downstream_clk,
        input  wire                 downstream_ready,
        output wire                 downstream_valid,
        output wire[WIDTH-1:0]      downstream_data,
        output wire[LOG2_DEPTH-1:0] upstream_occupancy
    );

    localparam DEPTH = (1 << LOG2_DEPTH) - 1;

    initial begin
        assert (UPSTREAM_READY_LATENCY   >= 0 && UPSTREAM_READY_LATENCY   <= 2);
        assert (DOWNSTREAM_READY_LATENCY >= 0 && DOWNSTREAM_READY_LATENCY <= 2);
        assert (DEPTH > (UPSTREAM_READY_LATENCY+4));
    end

    wire                  wrreq;
    wire [LOG2_DEPTH-1:0] wrusedw;
    reg                   wralmost_full;
    reg                   wralmost_full_r;
    reg                   wralmost_full_rr;
    wire                  rdreq;
    wire                  rdempty;
    reg                   rdreq_r;

    reg  downstream_ready_r;
    always @(posedge downstream_clk or negedge downstream_aresetn) begin
        if (~downstream_aresetn) begin
            downstream_ready_r <= 1'b0;
        end else begin
            downstream_ready_r <= downstream_ready;
        end
    end

    assign rdreq = (~rdempty) & ((DOWNSTREAM_READY_LATENCY == 2) ? downstream_ready_r : downstream_ready);

    assign wrreq = upstream_valid & ((UPSTREAM_READY_LATENCY == 0) ? ~wralmost_full
                                    :(UPSTREAM_READY_LATENCY == 1) ? ~wralmost_full_r
                                    :(UPSTREAM_READY_LATENCY == 2) ? ~wralmost_full_rr
                                                                   : 1'b0);

    assign downstream_valid = (DOWNSTREAM_READY_LATENCY == 0) ? ~rdempty : rdreq_r;

    hps_adapter_dcfifo_s # (
        .WIDTH              (WIDTH),
        .LOG_DEPTH          (LOG2_DEPTH),
        .ALMOST_FULL_VALUE  (DEPTH-1 - UPSTREAM_READY_LATENCY - 2),
        .FAMILY             ("Agilex"),
        .SHOW_AHEAD         ((DOWNSTREAM_READY_LATENCY == 0) ? 1 : 0),
        .OVERFLOW_CHECKING  (0),
        .UNDERFLOW_CHECKING (0)
    ) fifo (
        .wrclk           (upstream_clk),
        .wraresetn       (upstream_aresetn),
        .wrreq           (wrreq),
        .data            (upstream_data),
        .wrfull          (),
        .wrempty         (),
        .wr_almost_empty (),
        .wr_almost_full  (),
        .wrusedw         (wrusedw),
        .rdclk           (downstream_clk),
        .rdaresetn       (downstream_aresetn),
        .rdreq           (rdreq),
        .q               (downstream_data),
        .rdfull          (),
        .rdempty         (rdempty),
        .rd_almost_empty (),
        .rd_almost_full  (),
        .rdusedw         ()
    );

    always @(posedge upstream_clk or negedge upstream_aresetn) begin
        if (~upstream_aresetn) begin
            wralmost_full    <= 1'b0;
            wralmost_full_r  <= 1'b0;
            wralmost_full_rr <= 1'b0;
        end else begin
            wralmost_full    <= (wrusedw > (DEPTH-1 - UPSTREAM_READY_LATENCY - 2));
            wralmost_full_r  <= wralmost_full;
            wralmost_full_rr <= wralmost_full_r;
        end
    end

    assign upstream_ready = ~wralmost_full;

    always @(posedge downstream_clk or negedge downstream_aresetn) begin
        if (~downstream_aresetn) begin
            rdreq_r <= 1'b0;
        end else begin
            rdreq_r <= rdreq;
        end
    end

    assign upstream_occupancy = wrusedw;
endmodule

`default_nettype wire