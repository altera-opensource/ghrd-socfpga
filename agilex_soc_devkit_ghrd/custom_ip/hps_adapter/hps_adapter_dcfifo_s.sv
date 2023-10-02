// Copyright 2021 Intel Corporation. 
//
// This reference design file is subject licensed to you by the terms and 
// conditions of the applicable License Terms and Conditions for Hardware 
// Reference Designs and/or Design Examples (either as signed by you or 
// found at https://www.altera.com/common/legal/leg-license_agreement.html ).  
//
// As stated in the license, you agree to only use this reference design 
// solely in conjunction with Intel FPGAs or Intel CPLDs.  
//
// THE REFERENCE DESIGN IS PROVIDED "AS IS" WITHOUT ANY EXPRESS OR IMPLIED
// WARRANTY OF ANY KIND INCLUDING WARRANTIES OF MERCHANTABILITY, 
// NONINFRINGEMENT, OR FITNESS FOR A PARTICULAR PURPOSE. Intel does not 
// warrant or assume responsibility for the accuracy or completeness of any
// information, links or other items within the Reference Design and any 
// accompanying materials.
//
// In the event that you do not agree with such terms and conditions, do not
// use the reference design file.
/////////////////////////////////////////////////////////////////////////////

// dcfifo_s is designed as a faster and smaller replacement of dcfifo
//
// This is a MODIFIED form of dcfifo_s that have separate resets for the read
// and write interfaces of the FIFO. The resets are AXI4-compliant active-low,
// asynchronous assertion & synchronous deassertion.
// Separate resets avoid recovery timing issues when the FIFO is operated at
// high frequencies.
//
// Also, setup timing closure of 512b wide instantiations of the FIFO is 
// improved by explicitly duplicating key registers.  
// 
// Notes
// 1. The only dcfifo port not supported by dcfifo_s is "eccstatus".
//    All the other ports are identical to dcfifo.
//
// 2. Both "normal" and "show-ahead" modes are supported. (parameter SHOW_AHEAD)
//
// 3. almost_empty and almost_full thresholds are supported 
//    See parameters ALMOST_EMPTY_VALUE and ALMOST_FULL_VALUE
//
// 4. dcfifo_s is MLAB-based and is able to store up to 31 words.
//
// 5. All MLABs are fully registered in every mode.
//    This is different from dcfifo which has unregistered MLAB in show-ahead mode

module hps_adapter_dcfifo_s
#(
    parameter LOG_DEPTH          = 5,
    parameter WIDTH              = 20,
    parameter ALMOST_FULL_VALUE  = 30,
    parameter ALMOST_EMPTY_VALUE = 2,    
    parameter FAMILY             = "S10", // Agilex, S10, or Other
    parameter SHOW_AHEAD         = 0,     // Show-ahead mode is using a lot of area. Use Normal mode if possible
    parameter OVERFLOW_CHECKING  = 0,     // Overflow checking circuitry is using extra area. Use only if you need it
    parameter UNDERFLOW_CHECKING = 0      // Underflow checking circuitry is using extra area. Use only if you need it    
)
(
    input wrclk,
    input wraresetn,
    input wrreq,
    input [WIDTH-1:0] data,
    output wrempty,
    output wrfull,
    output wr_almost_empty,
    output wr_almost_full,
    output [LOG_DEPTH-1:0] wrusedw,
    
    input rdclk,
    input rdaresetn,
    input rdreq,
    output [WIDTH-1:0] q,
    output rdempty,
    output rdfull,
    output rd_almost_empty,    
    output rd_almost_full,    
    output [LOG_DEPTH-1:0] rdusedw
);
initial begin
    if ((LOG_DEPTH >= 6) || (LOG_DEPTH <= 2))
        $error("Invalid parameter value: LOG_DEPTH = %0d; valid range is 2 < LOG_DEPTH < 6", LOG_DEPTH);

    if (WIDTH <= 0)
        $error("Invalid parameter value: WIDTH = %0d; it must be greater than 0", WIDTH);
        
    if ((ALMOST_FULL_VALUE >= 2 ** LOG_DEPTH) || (ALMOST_FULL_VALUE <= 0))
        $error("Incorrect parameter value: ALMOST_FULL_VALUE = %0d; valid range is 0 < ALMOST_FULL_VALUE < %0d", 
            ALMOST_FULL_VALUE, 2 ** LOG_DEPTH);     

    if ((ALMOST_EMPTY_VALUE >= 2 ** LOG_DEPTH) || (ALMOST_EMPTY_VALUE <= 0))
        $error("Incorrect parameter value: ALMOST_EMPTY_VALUE = %0d; valid range is 0 < ALMOST_EMPTY_VALUE < %0d", 
            ALMOST_EMPTY_VALUE, 2 ** LOG_DEPTH);  

    if ((FAMILY != "Agilex") && (FAMILY != "S10") && (FAMILY != "Other"))
        $error("Incorrect parameter value: FAMILY = %s; must be one of {Agilex, S10, Other}", FAMILY);  
end

generate
if (SHOW_AHEAD == 1)
    hps_adapter_dcfifo_s_showahead #(
        .LOG_DEPTH(LOG_DEPTH),
        .WIDTH(WIDTH),
        .ALMOST_FULL_VALUE(ALMOST_FULL_VALUE),
        .ALMOST_EMPTY_VALUE(ALMOST_EMPTY_VALUE),
        .FAMILY(FAMILY),
        .OVERFLOW_CHECKING(OVERFLOW_CHECKING),
        .UNDERFLOW_CHECKING(UNDERFLOW_CHECKING)
    ) a1 (
        .wrclk(wrclk),
        .wraresetn(wraresetn),
        .wrreq(wrreq),
        .data(data),
        .wrempty(wrempty),
        .wrfull(wrfull),
        .wr_almost_empty(wr_almost_empty),
        .wr_almost_full(wr_almost_full),
        .wrusedw(wrusedw),
        .rdclk(rdclk),
        .rdaresetn(rdaresetn),
        .rdreq(rdreq),
        .q(q),
        .rdempty(rdempty),
        .rdfull(rdfull),
        .rd_almost_empty(rd_almost_empty),
        .rd_almost_full(rd_almost_full),
        .rdusedw(rdusedw)
    );
else
    hps_adapter_dcfifo_s_normal #(
        .LOG_DEPTH(LOG_DEPTH),
        .WIDTH(WIDTH),
        .ALMOST_FULL_VALUE(ALMOST_FULL_VALUE),
        .ALMOST_EMPTY_VALUE(ALMOST_EMPTY_VALUE),
        .FAMILY(FAMILY),
        .OVERFLOW_CHECKING(OVERFLOW_CHECKING),
        .UNDERFLOW_CHECKING(UNDERFLOW_CHECKING)        
    ) a2 (
        .wrclk(wrclk),
        .wraresetn(wraresetn),
        .wrreq(wrreq),
        .data(data),
        .wrempty(wrempty),
        .wrfull(wrfull),
        .wr_almost_empty(wr_almost_empty),
        .wr_almost_full(wr_almost_full),
        .wrusedw(wrusedw),
        .rdclk(rdclk),
        .rdaresetn(rdaresetn),
        .rdreq(rdreq),
        .q(q),
        .rdempty(rdempty),
        .rdfull(rdfull),
        .rd_almost_empty(rd_almost_empty),
        .rd_almost_full(rd_almost_full),
        .rdusedw(rdusedw)
    );
endgenerate
endmodule

////////////////////////// Non-Showahead DC FIFO implementation //////////////////////////

module hps_adapter_dcfifo_s_normal
#(
    parameter LOG_DEPTH          = 5,
    parameter WIDTH              = 20,
    parameter ALMOST_FULL_VALUE  = 30,
    parameter ALMOST_EMPTY_VALUE = 2,    
    parameter FAMILY             = "S10", // Agilex, S10, or Other
    parameter NUM_WORDS          = 2**LOG_DEPTH - 1,
    parameter MLAB_ALWAYS_READ   = 1,
    parameter OVERFLOW_CHECKING  = 0,     // Overflow checking circuitry is using extra area. Use only if you need it
    parameter UNDERFLOW_CHECKING = 0      // Underflow checking circuitry is using extra area. Use only if you need it        
)
(
    input wrclk,
    input wraresetn,
    input wrreq,
    input [WIDTH-1:0] data,
    output reg wrempty,
    output reg wrfull,
    output reg wr_almost_empty,
    (* altera_attribute = "-name DUPLICATE_REGISTER 4" *) output reg wr_almost_full,
    output [LOG_DEPTH-1:0] wrusedw,
    
    input rdclk,
    input rdaresetn,
    input rdreq,
    output [WIDTH-1:0] q,
    output reg rdempty,
    output reg rdfull,
    output reg rd_almost_empty,    
    output reg rd_almost_full,    
    output [LOG_DEPTH-1:0] rdusedw
);
       
initial begin
    if ((LOG_DEPTH > 5) || (LOG_DEPTH < 3))
        $error("Invalid parameter value: LOG_DEPTH = %0d; valid range is 2 < LOG_DEPTH < 6", LOG_DEPTH);
        
    if ((ALMOST_FULL_VALUE > 2 ** LOG_DEPTH - 1) || (ALMOST_FULL_VALUE < 1))
        $error("Incorrect parameter value: ALMOST_FULL_VALUE = %0d; valid range is 0 < ALMOST_FULL_VALUE < %0d", 
            ALMOST_FULL_VALUE, 2 ** LOG_DEPTH);     

    if ((ALMOST_EMPTY_VALUE > 2 ** LOG_DEPTH - 1) || (ALMOST_EMPTY_VALUE < 1))
        $error("Incorrect parameter value: ALMOST_EMPTY_VALUE = %0d; valid range is 0 < ALMOST_EMPTY_VALUE < %0d", 
            ALMOST_EMPTY_VALUE, 2 ** LOG_DEPTH);  

    if ((NUM_WORDS > 2 ** LOG_DEPTH - 1) || (NUM_WORDS < 1))
        $error("Incorrect parameter value: NUM_WORDS = %0d; valid range is 0 < NUM_WORDS < %0d", 
            NUM_WORDS, 2 ** LOG_DEPTH);  
end

(* altera_attribute = "-name AUTO_CLOCK_ENABLE_RECOGNITION OFF" *) reg [LOG_DEPTH-1:0] write_addr = 0;
(* altera_attribute = "-name AUTO_CLOCK_ENABLE_RECOGNITION OFF" *) reg [LOG_DEPTH-1:0] read_addr = 0;
reg [LOG_DEPTH-1:0] wrcapacity = 0;
reg [LOG_DEPTH-1:0] rdcapacity = 0;

wire [LOG_DEPTH-1:0] wrcapacity_w;
wire [LOG_DEPTH-1:0] rdcapacity_w;

wire [LOG_DEPTH-1:0] rd_write_addr;
wire [LOG_DEPTH-1:0] wr_read_addr;

wire wrreq_safe;
wire rdreq_safe;
assign wrreq_safe = OVERFLOW_CHECKING ? wrreq & ~wrfull : wrreq;
assign rdreq_safe = UNDERFLOW_CHECKING ? rdreq & ~rdempty : rdreq;

initial begin 
    write_addr = 0;
    read_addr = 0;
    wrempty = 1;
    wrfull = 0;
    rdempty = 1;
    rdfull = 0;
    wrcapacity = 0;
    rdcapacity = 0;    
    rd_almost_empty = 1;
    rd_almost_full = 0;
    wr_almost_empty = 1;
    wr_almost_full = 0;
end


// ------------------ Write -------------------------

hps_adapter_util_add_a_b_s0_s1 #(LOG_DEPTH) wr_adder(
    .a(write_addr),
    .b(~wr_read_addr),
    .s0(wrreq_safe),
    .s1(1'b1),
    .out(wrcapacity_w)
);

always @(posedge wrclk or negedge wraresetn) begin

    if (~wraresetn) begin
        write_addr <= 0;
        wrcapacity <= 0;
        wrempty <= 1;
        wrfull <= 0;
        wr_almost_full <= 0;
        wr_almost_empty <= 1;
    end else begin
        write_addr <= write_addr + wrreq_safe;
        wrcapacity <= wrcapacity_w;
        wrempty <= (wrcapacity == 0) && (wrreq == 0);
        wrfull <= (wrcapacity == NUM_WORDS) || (wrcapacity == NUM_WORDS - 1) && (wrreq == 1);
        
        wr_almost_empty <=
            (wrcapacity < (ALMOST_EMPTY_VALUE-1)) || 
            (wrcapacity == (ALMOST_EMPTY_VALUE-1)) && (wrreq == 0);
        
        wr_almost_full <= 
            (wrcapacity >= ALMOST_FULL_VALUE) ||
            (wrcapacity == ALMOST_FULL_VALUE - 1) && (wrreq == 1);    
    end
end

assign wrusedw = wrcapacity;

// ------------------ Read -------------------------

hps_adapter_util_add_a_b_s0_s1 #(LOG_DEPTH) rd_adder(
    .a(rd_write_addr),
    .b(~read_addr),
    .s0(1'b0),
    .s1(~rdreq_safe),
    .out(rdcapacity_w)
);

always @(posedge rdclk or negedge rdaresetn) begin
    if (~rdaresetn) begin
        read_addr <= 0;
        rdcapacity <= 0;
        rdempty <= 1;
        rdfull <= 0;    
        rd_almost_empty <= 1;
        rd_almost_full <= 0;
    end else begin
        read_addr <= read_addr + rdreq_safe;
        rdcapacity <= rdcapacity_w;
        rdempty <= (rdcapacity == 0) || (rdcapacity == 1) && (rdreq == 1);
        rdfull <= (rdcapacity == NUM_WORDS) && (rdreq == 0);    
        rd_almost_empty <= 
            (rdcapacity < ALMOST_EMPTY_VALUE) || 
            (rdcapacity == ALMOST_EMPTY_VALUE) && (rdreq == 1);
            
        rd_almost_full <= 
            (rdcapacity > ALMOST_FULL_VALUE) ||
            (rdcapacity == ALMOST_FULL_VALUE) && (rdreq == 0);                
    end
end

assign rdusedw = rdcapacity;

// ---------------- Synchronizers --------------------

wire [LOG_DEPTH-1:0] gray_read_addr;
wire [LOG_DEPTH-1:0] wr_gray_read_addr;
wire [LOG_DEPTH-1:0] gray_write_addr;
wire [LOG_DEPTH-1:0] rd_gray_write_addr;

hps_adapter_util_binary_to_gray #(.WIDTH(LOG_DEPTH)) rd_b2g (.clock(rdclk), .aclr(~rdaresetn), .din(read_addr), .dout(gray_read_addr));
hps_adapter_util_synchronizer_ff_r2 #(.WIDTH(LOG_DEPTH)) rd2wr (.din_clk(rdclk),  .din_aclr(~rdaresetn),  .din(gray_read_addr), 
                                                                            .dout_clk(wrclk), .dout_aclr(~wraresetn), .dout(wr_gray_read_addr));
hps_adapter_util_gray_to_binary #(.WIDTH(LOG_DEPTH)) rd_g2b (.clock(wrclk), .aclr(~wraresetn), .din(wr_gray_read_addr), .dout(wr_read_addr));


hps_adapter_util_binary_to_gray #(.WIDTH(LOG_DEPTH)) wr_b2g (.clock(wrclk), .aclr(~wraresetn), .din(write_addr), .dout(gray_write_addr));
hps_adapter_util_synchronizer_ff_r2 #(.WIDTH(LOG_DEPTH)) wr2rd (.din_clk(wrclk),  .din_aclr(~wraresetn),  .din(gray_write_addr), 
                                                                            .dout_clk(rdclk), .dout_aclr(~rdaresetn), .dout(rd_gray_write_addr));
hps_adapter_util_gray_to_binary #(.WIDTH(LOG_DEPTH)) wr_g2b (.clock(rdclk), .aclr(~rdaresetn), .din(rd_gray_write_addr), .dout(rd_write_addr));

// ------------------ MLAB ---------------------------

hps_adapter_util_generic_mlab_dc #(.WIDTH(WIDTH), .ADDR_WIDTH(LOG_DEPTH), .FAMILY(FAMILY)) mlab_inst (
    .rclk(rdclk),
    .wclk(wrclk),
    .din(data),
    .waddr(write_addr),
    .we(1'b1),
    .re(MLAB_ALWAYS_READ ? 1'b1 : rdreq_safe),
    .raddr(read_addr),
    .dout(q)
);

endmodule

///////////////////////////// Showahead DC FIFO implementation //////////////////////////

// The showahead variant of the FIFO is implemented as a wrapper around the non-showahead module

module hps_adapter_dcfifo_s_showahead
#(
    parameter LOG_DEPTH          = 5,
    parameter WIDTH              = 20,
    parameter ALMOST_FULL_VALUE  = 30,
    parameter ALMOST_EMPTY_VALUE = 2,    
    parameter FAMILY             = "S10", // Agilex, S10, or Other
    parameter OVERFLOW_CHECKING  = 0,     // Overflow checking circuitry is using extra area. Use only if you need it
    parameter UNDERFLOW_CHECKING = 0      // Underflow checking circuitry is using extra area. Use only if you need it            
)
(
    input wrclk,
    input wraresetn,
    input wrreq,
    input [WIDTH-1:0] data,
    output wrempty,
    output wrfull,
    output wr_almost_empty,
    output wr_almost_full,
    output [LOG_DEPTH-1:0] wrusedw,
    
    input rdclk,
    input rdaresetn,
    input rdreq,
    output reg [WIDTH-1:0] q,
    output reg rdempty,
    output rdfull,
    output reg rd_almost_empty,    
    output reg rd_almost_full,    
    output reg [LOG_DEPTH-1:0] rdusedw
);

initial begin
    if ((LOG_DEPTH > 5) || (LOG_DEPTH < 3))
        $error("Invalid parameter value: LOG_DEPTH = %0d; valid range is 2 < LOG_DEPTH < 6", LOG_DEPTH);
        
    if ((ALMOST_FULL_VALUE > 2 ** LOG_DEPTH - 1) || (ALMOST_FULL_VALUE < 1))
        $error("Incorrect parameter value: ALMOST_FULL_VALUE = %0d; valid range is 0 < ALMOST_FULL_VALUE < %0d", 
            ALMOST_FULL_VALUE, 2 ** LOG_DEPTH);     

    if ((ALMOST_EMPTY_VALUE > 2 ** LOG_DEPTH - 1) || (ALMOST_EMPTY_VALUE < 1))
        $error("Incorrect parameter value: ALMOST_EMPTY_VALUE = %0d; valid range is 0 < ALMOST_EMPTY_VALUE < %0d", 
            ALMOST_EMPTY_VALUE, 2 ** LOG_DEPTH);     
end

//wire wrreq_safe;
wire rdreq_safe;
//assign wrreq_safe = OVERFLOW_CHECKING ? wrreq & ~wrfull : wrreq;
assign rdreq_safe = UNDERFLOW_CHECKING ? rdreq & ~rdempty : rdreq;

wire [WIDTH-1:0] w_q;

wire w_empty;
wire w_full;
wire w_almost_empty;
wire w_almost_full;    

wire [LOG_DEPTH-1:0] w_usedw;

reg read_fifo;
reg read_fifo_r; // 1 means that there is a value at fifo output

reg [WIDTH-1:0] r_q2;
reg r_q2_ready;

hps_adapter_dcfifo_s_normal #(
    .LOG_DEPTH(LOG_DEPTH), 
    .WIDTH(WIDTH), 
    .ALMOST_FULL_VALUE(ALMOST_FULL_VALUE), 
    .ALMOST_EMPTY_VALUE(ALMOST_EMPTY_VALUE),
    .NUM_WORDS(2**LOG_DEPTH - 4),
    .MLAB_ALWAYS_READ(0),
    .FAMILY(FAMILY),
    .OVERFLOW_CHECKING(OVERFLOW_CHECKING)
) fifo_inst(
    .wrclk(wrclk),
    .wraresetn(wraresetn),
    .wrreq(wrreq),
    .data(data),
    .wrempty(wrempty),
    .wrfull(wrfull),
    .wr_almost_empty(wr_almost_empty),
    .wr_almost_full(wr_almost_full),
    .wrusedw(wrusedw),
    
    .rdclk(rdclk),
    .rdaresetn(rdaresetn),
    .rdreq(read_fifo),
    .q(w_q),
    .rdempty(w_empty),
    .rdfull(rdfull),
    .rdusedw(w_usedw)    
);

wire next_empty;

assign next_empty = (w_usedw == 0) || (w_usedw == 1) && (read_fifo == 1);

reg tmp;

always @(posedge rdclk or negedge rdaresetn) begin

    if (~rdaresetn) begin
        rdempty <= 1;
        read_fifo <= 0;
        read_fifo_r <= 0;        
        r_q2_ready <= 0;
        rdusedw <= 0;
        rd_almost_full <= 0;
        rd_almost_empty <= 1;
        // No need to reset output data registers
        //q <= 0;
        //r_q2 <= 0;
    end else begin

        if (rdreq_safe || rdempty) begin
            if (r_q2_ready)
                q <= r_q2;
            else
                q <= w_q;
        end
        
        if (rdreq_safe || rdempty) begin
            rdempty <= !(r_q2_ready || read_fifo_r); 
        end
        
        if (r_q2_ready) begin
            if (rdreq_safe || rdempty)
                r_q2 <= w_q;
        end else begin
            r_q2 <= w_q;
        end

        if (r_q2_ready) begin
            if (rdreq_safe || rdempty)
                r_q2_ready <= read_fifo_r;
        end else begin
            if (rdreq_safe || rdempty)
                r_q2_ready <= 0;
            else
                r_q2_ready <= read_fifo_r;
        end
                    
        read_fifo_r <= read_fifo || read_fifo_r && !(rdreq_safe || rdempty || !r_q2_ready);
        
        read_fifo <= !next_empty && (
            rdreq_safe && (!rdempty + r_q2_ready + read_fifo + read_fifo_r < 4) || 
           !rdreq_safe && (!rdempty + r_q2_ready + read_fifo + read_fifo_r < 3)
        ); 
        
        //usedw <= w_usedw + read_fifo_r + r_q2_ready + wrreq + (!empty & !rdreq);
        {rdusedw, tmp} <= {w_usedw, !rdempty & !rdreq_safe} + {
            read_fifo_r & r_q2_ready, 
            read_fifo_r ^ r_q2_ready, 
            !rdempty & !rdreq_safe};
                
        rd_almost_empty <=
            (rdusedw < ALMOST_EMPTY_VALUE) || 
            (rdusedw == ALMOST_EMPTY_VALUE) && (rdreq == 1);
            
        rd_almost_full <= 
            (rdusedw > ALMOST_FULL_VALUE) ||
            (rdusedw == ALMOST_FULL_VALUE) && (rdreq == 0);    

    end
end
endmodule

