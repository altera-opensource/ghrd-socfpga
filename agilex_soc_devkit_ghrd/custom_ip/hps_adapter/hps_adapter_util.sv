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

// Utility modules intended for use by the FIFO modules but generally useful

/////////////////////////////// add_a_b_s0_s1 //////////////////////////////////

module hps_adapter_util_add_a_b_s0_s1 #(
    parameter SIZE = 5
)(
    input [SIZE-1:0] a,
    input [SIZE-1:0] b,
    input s0,
    input s1,
    output [SIZE-1:0] out
);
wire [SIZE:0] left;
wire [SIZE:0] right;
wire temp;
    
assign left = {a ^ b, s0};
assign right = {a[SIZE-2:0] & b[SIZE-2:0], s1, s0};
assign {out, temp} = left + right;  

endmodule

/////////////////////////////// binary_to_gray //////////////////////////////////

module hps_adapter_util_binary_to_gray #(
    parameter WIDTH = 5
) (
    input clock,
    input aclr,
    input [WIDTH-1:0] din,
    output reg [WIDTH-1:0] dout
);

always @(posedge clock or posedge aclr) begin
    if (aclr)
        dout <= 0;
    else
        dout <= din ^ (din >> 1);
end

endmodule

/////////////////////////////// gray_to_binary //////////////////////////////////

module hps_adapter_util_gray_to_binary #(
    parameter WIDTH = 5
) (
    input clock,
    input aclr,
    input [WIDTH-1:0] din,
    output reg [WIDTH-1:0] dout
);

wire [WIDTH-1:0] dout_w;

genvar i;
generate
    for (i = 0; i < WIDTH; i=i+1) begin : loop
        assign dout_w[i] = ^(din[WIDTH-1:i]);
    end
endgenerate

always @(posedge clock or posedge aclr) begin
    if (aclr)
        dout <= 0;
    else
        dout <= dout_w;
end

endmodule

/////////////////////////////// generic_mlab_sc ////////////////////////////////

(* altera_attribute = "-name SYNCHRONIZER_IDENTIFICATION OFF" *)
module hps_adapter_util_generic_mlab_sc #(
    parameter WIDTH = 8,
    parameter ADDR_WIDTH = 5,
    parameter FAMILY = "Other" // Agilex, S10, or Other
)(
    input clk,
    input [WIDTH-1:0] din,
    input [ADDR_WIDTH-1:0] waddr,
    input we,
    input re,
    input [ADDR_WIDTH-1:0] raddr,
    output [WIDTH-1:0] dout
);

genvar i;
generate
if (FAMILY == "S10") begin    
    reg [WIDTH-1:0] wdata_hipi;
    always @(posedge clk) wdata_hipi <= din;
        
    for (i=0; i<WIDTH; i=i+1)  begin : ml
        wire wclk_w = clk; // fix strange tristate warning
        wire rclk_w = clk; // fix strange tristate warning
        fourteennm_mlab_cell lrm (
            .clk0(wclk_w),
            .ena0(we),
            .clk1(rclk_w),
            .ena1(re),
                
            /* synthesis translate_off */
            .clr(1'b0),
            .devclrn(1'b1),
            .devpor(1'b1),
            /* synthesis translate_on */           

            .portabyteenamasks(1'b1),
            .portadatain(wdata_hipi[i]),
            .portaaddr(waddr),
            .portbaddr(raddr),
            .portbdataout(dout[i])          
        );

        defparam lrm .mixed_port_feed_through_mode = "dont_care";
        defparam lrm .logical_ram_name = "lrm";
        defparam lrm .logical_ram_depth = 1 << ADDR_WIDTH;
        defparam lrm .logical_ram_width = WIDTH;
        defparam lrm .first_address = 0;
        defparam lrm .last_address = (1 << ADDR_WIDTH)-1;
        defparam lrm .first_bit_number = i;
        defparam lrm .data_width = 1;
        defparam lrm .address_width = ADDR_WIDTH;
        defparam lrm .port_b_data_out_clock = "clock1";
    end
    
end else if (FAMILY == "Agilex") begin    
        
    for (i=0; i<WIDTH; i=i+1)  begin : ml
        wire wclk_w = clk; // fix strange tristate warning
        wire rclk_w = clk; // fix strange tristate warning
        tennm_mlab_cell lrm (
            .clk0(wclk_w),
            .ena0(we),
            .clk1(rclk_w),
            .ena1(re),
                
            /* synthesis translate_off */
            .clr(1'b0),
            .devclrn(1'b1),
            .devpor(1'b1),
            /* synthesis translate_on */       

            .portabyteenamasks(1'b1),
            .portadatain(din[i]),
            .portaaddr(waddr),
            .portbaddr(raddr),
            .portbdataout(dout[i])          
        );

        defparam lrm .mixed_port_feed_through_mode = "dont_care";
        defparam lrm .logical_ram_name = "lrm";
        defparam lrm .logical_ram_depth = 1 << ADDR_WIDTH;
        defparam lrm .logical_ram_width = WIDTH;
        defparam lrm .first_address = 0;
        defparam lrm .last_address = (1 << ADDR_WIDTH)-1;
        defparam lrm .first_bit_number = i;
        defparam lrm .data_width = 1;
        defparam lrm .address_width = ADDR_WIDTH;
        defparam lrm .port_b_data_out_clock = "clock1";
    end
    
    
end else begin

    localparam DEPTH = 1 << ADDR_WIDTH;
    (* ramstyle = "mlab" *) reg [WIDTH-1:0] mem[0:DEPTH-1];

    reg [WIDTH-1:0] dout_r;
    always @(posedge clk) begin
        if (we)
            mem[waddr] <= din;
        if (re)
            dout_r <= mem[raddr];
    end
    assign dout = dout_r;

end
endgenerate    

endmodule

/////////////////////////////// generic_mlab_dc ////////////////////////////////

(* altera_attribute = "-name SYNCHRONIZER_IDENTIFICATION OFF" *)
module hps_adapter_util_generic_mlab_dc #(
    parameter WIDTH = 8,
    parameter ADDR_WIDTH = 5,
    parameter FAMILY = "Other" // Agilex, S10, or Other
)(
    input rclk,
    input wclk,
    input [WIDTH-1:0] din,
    input [ADDR_WIDTH-1:0] waddr,
    input we,
    input re,
    input [ADDR_WIDTH-1:0] raddr,
    output [WIDTH-1:0] dout
);

genvar i;
generate
if (FAMILY == "S10") begin    
    reg [WIDTH-1:0] wdata_hipi;
    always @(posedge wclk) wdata_hipi <= din;
        
    for (i=0; i<WIDTH; i=i+1)  begin : ml
        wire wclk_w = wclk; // fix strange tristate warning
        wire rclk_w = rclk; // fix strange tristate warning
        fourteennm_mlab_cell lrm (
            .clk0(wclk_w),
            .ena0(we),
            .clk1(rclk_w),
            .ena1(re),
                
            /* synthesis translate_off */
            .clr(1'b0),
            .devclrn(1'b1),
            .devpor(1'b1),
            /* synthesis translate_on */       

            .portabyteenamasks(1'b1),
            .portadatain(wdata_hipi[i]),
            .portaaddr(waddr),
            .portbaddr(raddr),
            .portbdataout(dout[i])          
        );

        defparam lrm .mixed_port_feed_through_mode = "dont_care";
        defparam lrm .logical_ram_name = "lrm";
        defparam lrm .logical_ram_depth = 1 << ADDR_WIDTH;
        defparam lrm .logical_ram_width = WIDTH;
        defparam lrm .first_address = 0;
        defparam lrm .last_address = (1 << ADDR_WIDTH)-1;
        defparam lrm .first_bit_number = i;
        defparam lrm .data_width = 1;
        defparam lrm .address_width = ADDR_WIDTH;
        defparam lrm .port_b_data_out_clock = "clock1";
    end
    
end else if (FAMILY == "Agilex") begin    
        
    for (i=0; i<WIDTH; i=i+1)  begin : ml
        wire wclk_w = wclk; // fix strange tristate warning
        wire rclk_w = rclk; // fix strange tristate warning
        tennm_mlab_cell lrm (
            .clk0(wclk_w),
            .ena0(we),
            .clk1(rclk_w),
            .ena1(re),
                
            /* synthesis translate_off */
            .clr(1'b0),
            .devclrn(1'b1),
            .devpor(1'b1),
            /* synthesis translate_on */       

            .portabyteenamasks(1'b1),
            .portadatain(din[i]),
            .portaaddr(waddr),
            .portbaddr(raddr),
            .portbdataout(dout[i])          
        );

        defparam lrm .mixed_port_feed_through_mode = "dont_care";
        defparam lrm .logical_ram_name = "lrm";
        defparam lrm .logical_ram_depth = 1 << ADDR_WIDTH;
        defparam lrm .logical_ram_width = WIDTH;
        defparam lrm .first_address = 0;
        defparam lrm .last_address = (1 << ADDR_WIDTH)-1;
        defparam lrm .first_bit_number = i;
        defparam lrm .data_width = 1;
        defparam lrm .address_width = ADDR_WIDTH;
        defparam lrm .port_b_data_out_clock = "clock1";
    end
    
    
end else begin

    localparam DEPTH = 1 << ADDR_WIDTH;
    (* ramstyle = "mlab" *) reg [WIDTH-1:0] mem[0:DEPTH-1];

    reg [WIDTH-1:0] dout_r;
    always @(posedge wclk) begin
        if (we)
            mem[waddr] <= din;
    end
    always @(posedge rclk) begin
        if (re)
            dout_r <= mem[raddr];
    end
    assign dout = dout_r;

end
endgenerate    

endmodule

/////////////////////////////// synchronizer_ff_r2 ////////////////////////////////

module hps_adapter_util_synchronizer_ff_r2 #(
    parameter WIDTH = 8
)(
    input din_clk,
    input din_aclr,
    input [WIDTH-1:0] din,
    input dout_clk,
    input dout_aclr,
    output [WIDTH-1:0] dout
);

// set of handy SDC constraints
localparam MULTI = "-name SDC_STATEMENT \"set_multicycle_path -to [get_keepers *synchronizer_ff_r2*ff_meta\[*\]] 2\" ";
localparam FPATH = "-name SDC_STATEMENT \"set_false_path -to [get_keepers *synchronizer_ff_r2*ff_meta\[*\]]\" ";
localparam FHOLD = "-name SDC_STATEMENT \"set_false_path -hold -to [get_keepers *synchronizer_ff_r2*ff_meta\[*\]]\" ";

reg [WIDTH-1:0] ff_launch = {WIDTH {1'b0}} /* synthesis preserve dont_replicate */;
always @(posedge din_clk or posedge din_aclr) begin
    if (din_aclr)
        ff_launch <= 0;
    else
        ff_launch <= din;
end

localparam SDC = {MULTI,";",FHOLD};
(* altera_attribute = SDC *)
reg [WIDTH-1:0] ff_meta = {WIDTH {1'b0}} /* synthesis preserve dont_replicate */;
always @(posedge dout_clk or posedge dout_aclr) begin
    if (dout_aclr)    
        ff_meta <= 0;
    else
        ff_meta <= ff_launch;
end

reg [WIDTH-1:0] ff_sync = {WIDTH {1'b0}} /* synthesis preserve dont_replicate */;
always @(posedge dout_clk or posedge dout_aclr) begin
    if (dout_aclr)
        ff_sync <= 0;
    else
        ff_sync <= ff_meta;
end

assign dout = ff_sync;
endmodule
