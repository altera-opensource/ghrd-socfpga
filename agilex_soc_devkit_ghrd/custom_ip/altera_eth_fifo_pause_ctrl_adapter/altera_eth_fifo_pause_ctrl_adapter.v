//****************************************************************************
//
// SPDX-License-Identifier: MIT-0
// Copyright(c) 2001-2022 Intel Corporation.
//
//****************************************************************************
//
// altera_eth_fifo_pause_ctrl_adapter
// This module generate pause control signal (pause_ctrl_src_data) to MAC when
// when the eth fifo is almost full and release pause when the eth fifo is
// almost empty.
//****************************************************************************

// altera message_off 10230

module altera_eth_fifo_pause_ctrl_adapter
(
                        //global
                        clk,
                        reset,
                        //Almost full Data Sink
                        data_sink_almost_full,
                        //Almost empty Data Sink
                        data_sink_almost_empty,
                        //LL10GMAC PAUSE Source
                        pause_ctrl_src_data,
                        //Etile HIP PAUSE Source
                        pause_ctrl_etile_src_data,
                        o_sl_rx_pause
                        );

    // =head2 Clock and reset interface
    input                                   clk;
    input                                   reset;

    // =head2 Avalon ST DataIn (Sink) Interface
    input                                   data_sink_almost_full;

    // =head2 Avalon ST DataIn (Sink) Interface
    input                                   data_sink_almost_empty;

    // =head2 Avalon ST DataOut (Source) Interface
    output      [1:0]                       pause_ctrl_src_data;

    // Etile HIP PAUSE Source
    output                                  pause_ctrl_etile_src_data;
    input                                   o_sl_rx_pause;

    reg                                     hold_almost_full;
    reg                                     hold_almost_full_1;
    reg                                     reg_data_sink_almost_full;
    reg                                     reg_data_sink_almost_empty;

    always @ (posedge clk or posedge reset)
        begin
        if(reset == 1'b1)
            begin
            hold_almost_full <= 1'b0;
            reg_data_sink_almost_full <= 1'b0;
            reg_data_sink_almost_empty <= 1'b0;
            hold_almost_full_1 <= 1'b0;
            end
        else
            begin
            if(data_sink_almost_empty == 1'b1)
                begin
                hold_almost_full <= 1'b0;
                end
            else if(data_sink_almost_full == 1'b1)
                begin
                hold_almost_full <=1'b1;
                end
            reg_data_sink_almost_full <= data_sink_almost_full;
            reg_data_sink_almost_empty <= data_sink_almost_empty;
            hold_almost_full_1 <= hold_almost_full;
            end
        end

    assign pause_ctrl_src_data[1] = reg_data_sink_almost_full;
    assign pause_ctrl_src_data[0] = hold_almost_full_1 & reg_data_sink_almost_empty;

    assign pause_ctrl_etile_src_data = hold_almost_full_1;

endmodule


