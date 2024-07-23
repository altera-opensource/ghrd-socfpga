// (C) 2001-2024 Intel Corporation. All rights reserved.
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


// Wrappers for other families can be found in altera_pll.v (pre Arria 10) and twentynm_iopll.v

`timescale 1ps/1ps
module iopll_comp_altera_iopll_1931_sftvcwy 
(
    // interface refclk
    input wire refclk,
    // interface locked
    output wire locked,
    // interface reset
    input wire rst,
    // interface outclk0
    output wire outclk_0
);

wire [1:0] extclk_out_wire;
wire refclk1;
wire fbclk;
assign fbclk = 1'b0;
wire fboutclk;
wire zdbfbclk;
wire [1:0] loaden;
wire phase_done;
wire [29:0] reconfig_to_pll;
assign reconfig_to_pll = 64'b0;
wire scanclk;
assign scanclk = 1'b0;
wire [7:0] phout;
wire [2:0] num_phase_shifts;
assign num_phase_shifts = 3'b0;
wire permit_cal;
wire fblvds_out;
wire [4:0] cntsel;
assign cntsel = 5'b0;
wire [1:0] clkbad;
wire [1:0] lvds_clk;
wire [6:0] outclk;

wire [6:0] unused_wires_high;
assign unused_wires_high = outclk[6:1];
assign outclk_0 = outclk[0];
wire phase_en;
assign phase_en = 1'b0;
wire extswitch;
wire cascade_out;
wire dll_output;
wire activeclk;
wire adjpllin;
wire updn;
assign updn = 1'b0;
wire [10:0] reconfig_from_pll;
wire phout_periph;


wire feedback_clk;
wire fb_clkin;
wire fb_out_clk;
wire fboutclk_wire;
wire locked_wire;
wire [10:0] reconfig_from_pll_wire;
wire gnd /* synthesis keep*/;

// ==========================================================================================
// Instantiate tennm_ph2_iopll!
// ==========================================================================================
tennm_ph2_iopll #(
    .bandwidth_mode("BANDWIDTH_MODE_AUTO"),
    .base_address(11'd0),
    .cascade_mode("CASCADE_MODE_STANDALONE"),
    .clk_switch_auto_en("FALSE"),
    .clk_switch_manual_en("FALSE"),
    .compensation_clk_source("COMPENSATION_CLK_SOURCE_OUTCLK0"),
    .compensation_mode("COMPENSATION_MODE_NORMAL"),
    .fb_clk_delay(0),
    .fb_clk_fractional_div_den(1),
    .fb_clk_fractional_div_num(1),
    .fb_clk_fractional_div_value(1),
    .fb_clk_m_div(19),
    .out_clk_0_c_div(19),
    .out_clk_0_core_en("TRUE"),
    .out_clk_0_delay(0),
    .out_clk_0_dutycycle_den(38),
    .out_clk_0_dutycycle_num(19),
    .out_clk_0_dutycycle_percent(50),
    .out_clk_0_freq(36'd125000000),
    .out_clk_0_phase_ps(0),
    .out_clk_0_phase_shifts(0),
    .out_clk_1_c_div(1),
    .out_clk_1_core_en("FALSE"),
    .out_clk_1_delay(0),
    .out_clk_1_dutycycle_den(4),
    .out_clk_1_dutycycle_num(2),
    .out_clk_1_dutycycle_percent(50),
    .out_clk_1_freq(36'd2375000000),
    .out_clk_1_phase_ps(0),
    .out_clk_1_phase_shifts(0),
    .out_clk_2_c_div(1),
    .out_clk_2_core_en("FALSE"),
    .out_clk_2_delay(0),
    .out_clk_2_dutycycle_den(4),
    .out_clk_2_dutycycle_num(2),
    .out_clk_2_dutycycle_percent(50),
    .out_clk_2_freq(36'd2375000000),
    .out_clk_2_phase_ps(0),
    .out_clk_2_phase_shifts(0),
    .out_clk_3_c_div(1),
    .out_clk_3_core_en("FALSE"),
    .out_clk_3_delay(0),
    .out_clk_3_dutycycle_den(4),
    .out_clk_3_dutycycle_num(2),
    .out_clk_3_dutycycle_percent(50),
    .out_clk_3_freq(36'd2375000000),
    .out_clk_3_phase_ps(0),
    .out_clk_3_phase_shifts(0),
    .out_clk_4_c_div(1),
    .out_clk_4_core_en("FALSE"),
    .out_clk_4_delay(0),
    .out_clk_4_dutycycle_den(4),
    .out_clk_4_dutycycle_num(2),
    .out_clk_4_dutycycle_percent(50),
    .out_clk_4_freq(36'd2375000000),
    .out_clk_4_phase_ps(0),
    .out_clk_4_phase_shifts(0),
    .out_clk_5_c_div(1),
    .out_clk_5_core_en("FALSE"),
    .out_clk_5_delay(0),
    .out_clk_5_dutycycle_den(4),
    .out_clk_5_dutycycle_num(2),
    .out_clk_5_dutycycle_percent(50),
    .out_clk_5_freq(36'd2375000000),
    .out_clk_5_phase_ps(0),
    .out_clk_5_phase_shifts(0),
    .out_clk_6_c_div(1),
    .out_clk_6_core_en("FALSE"),
    .out_clk_6_delay(0),
    .out_clk_6_dutycycle_den(4),
    .out_clk_6_dutycycle_num(2),
    .out_clk_6_dutycycle_percent(50),
    .out_clk_6_freq(36'd2375000000),
    .out_clk_6_phase_ps(0),
    .out_clk_6_phase_shifts(0),
    .out_clk_cascading_source("OUT_CLK_CASCADING_SOURCE_UNUSED"),
    .out_clk_external_0_source("OUT_CLK_EXTERNAL_0_SOURCE_UNUSED"),
    .out_clk_external_1_source("OUT_CLK_EXTERNAL_1_SOURCE_UNUSED"),
    .out_clk_periph_0_delay(0),
    .out_clk_periph_0_en("FALSE"),
    .out_clk_periph_1_delay(0),
    .out_clk_periph_1_en("FALSE"),
    .pfd_clk_freq(32'd125000000),
    .protocol_mode("PROTOCOL_MODE_BASIC"),
    .ref_clk_0_freq(32'd125000000),
    .ref_clk_1_freq(32'd0),
    .ref_clk_delay(0),
    .ref_clk_n_div(1),
    .self_reset_en("FALSE"),
    .set_dutycycle("SET_DUTYCYCLE_FRACTION"),
    .set_fractional("SET_FRACTIONAL_FRACTION"),
    .set_freq("SET_FREQ_DIVISION_VERIFY"),
    .set_phase("SET_PHASE_NUM_SHIFTS_VERIFY"),
    .vco_clk_freq(36'd2375000000)
) tennm_ph2_iopll (
    .cal_bus_address(),
    .cal_bus_clk(),
    .cal_bus_read(),
    .cal_bus_readdata(),
    .cal_bus_rst_n(),
    .cal_bus_write(),
    .cal_bus_writedata(),
    .core_avl_address(),
    .core_avl_clk(),
    .core_avl_read(),
    .core_avl_readdata(),
    .core_avl_write(),
    .core_avl_writedata(),
    .dps_cnt_sel(),
    .dps_num_phase_shifts(),
    .dps_phase_done(),
    .dps_phase_en(),
    .dps_up_dn(),
    .fb_clk_in(feedback_clk),
    .fb_clk_in_lvds(),
    .fb_clk_out(feedback_clk),
    .lock(locked_wire),
    .out_clk(outclk),
    .out_clk_cascade(cascade_out),
    .out_clk_external0(fboutclk_wire),
    .out_clk_external1(extclk_out_wire[1]),
    .out_clk_periph0(),
    .out_clk_periph1(),
    .permit_cal(1'b1),
    .ref_clk_active(activeclk),
    .ref_clk_bad(clkbad),
    .ref_clk_switch_n(),
    .ref_clk0(refclk),
    .ref_clk1(),
    .reset(rst),
    .vco_clk(phout),
    .vco_clk_periph()
);

assign extclk_out_wire[0] = fboutclk_wire;

assign fboutclk = fboutclk_wire;
assign locked = locked_wire;


// ==================================================================================
// Create clock buffers for fbclk,  fboutclk and zdbfbclk if necessary.
// ==================================================================================
assign zdbfbclk = 0;

endmodule


