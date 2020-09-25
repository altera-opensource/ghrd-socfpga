//****************************************************************************
//
// SPDX-License-Identifier: MIT-0
// Copyright(c) 2016-2020 Intel Corporation.
//
//****************************************************************************
//
// reset_sync_block
// Custom Reset Synchronizer
//
//****************************************************************************

module reset_sync_block (
  clk_in,
  reset_in,
  clk_out,
  reset_out
);

  parameter SYNC_DEPTH = 3;               // needs to be at least two but on new FPGAs should be at least 3
  parameter ADDITIONAL_DEPTH = 2;         // needs to be at least two stages, increase this if recovery errors occur even with DISABLE_GLOBAL_NETWORK is set to 1
  parameter DISABLE_GLOBAL_NETWORK = 1;   // set to 1 to prevent synchronized reset from getting promoted to global network, enable this if recovery errors occur from FFs hooked up to reset_out
  parameter SYNC_BOTH_EDGES = 0;          // set to 1 synchronize the reset_in to both edges, set to 0 to allow reset_out to deassert asynchronously and assert synchronously
  
  input clk_in;
  input reset_in;
  output wire clk_out;
  output wire reset_out;

  (* preserve *) reg [SYNC_DEPTH-1 : 0] synchronizer_reg;
  
generate
  if (DISABLE_GLOBAL_NETWORK == 1)  // output_pipeline_reg[0] tends to have a lot of fanout so setting this to 1 will prevent it from getting routed on a global network
  begin
    (* altera_attribute = "-name GLOBAL_SIGNAL OFF" *)  reg [ADDITIONAL_DEPTH-1 : 0] output_pipeline_reg;
  end
  else
  begin
    reg [ADDITIONAL_DEPTH-1 : 0] output_pipeline_reg;
  end
endgenerate

generate 
  if (SYNC_BOTH_EDGES == 0)  // use reset_in as an asynchronous clear for reset_out but sychronize reset_out to the rising clock edge
  begin

    // shifting the 0 from the MSB down to the LSB, this will make keeping things off the global network much easier
    always @ (posedge clk_in or posedge reset_in)
    begin
      if (reset_in == 1'b1)
      begin
        synchronizer_reg <= {SYNC_DEPTH {1'b1}};
      end
      else
      begin
        synchronizer_reg[SYNC_DEPTH-1] <= 1'b0;
        synchronizer_reg[SYNC_DEPTH-2:0] <= synchronizer_reg[SYNC_DEPTH-1:1];  // right shift by 1
      end
    end


    // using the LSB output of the synchronizer as the asynchronous reset of the output pipeline
    always @ (posedge clk_in or posedge reset_in)
    begin
      if (reset_in == 1'b1)
      begin
        output_pipeline_reg <= {ADDITIONAL_DEPTH {1'b1}};
      end
      else
      begin
        output_pipeline_reg[ADDITIONAL_DEPTH-1] <= synchronizer_reg[0];   // feeding the synchronizer output into this pipeline's MSB
        output_pipeline_reg[ADDITIONAL_DEPTH-2:0] <= output_pipeline_reg[ADDITIONAL_DEPTH-1:1];  // right shift by 1
        
      end
    end
    
  end
  else  // just synchronize and pipeline reset_in and feed it back out as reset_out
  begin

// using an asynchronously reset synchronizer below, should use the standard synchronizer instead of the code below so that only the input path gets cut instead of all the stages of the synchronizer  
/*
    always @ (posedge clk_in)
    begin
      synchronizer_reg[SYNC_DEPTH-1] <= reset_in;
      synchronizer_reg[SYNC_DEPTH-2:0] <= synchronizer_reg[SYNC_DEPTH-1:1];  // right shift by 1
    end
*/

    always @ (posedge clk_in or posedge reset_in)
    begin
      if (reset_in == 1'b1)
      begin
        synchronizer_reg <= {SYNC_DEPTH {1'b1}};
      end
      else
      begin
        synchronizer_reg[SYNC_DEPTH-1] <= 1'b0;
        synchronizer_reg[SYNC_DEPTH-2:0] <= synchronizer_reg[SYNC_DEPTH-1:1];  // right shift by 1
      end
    end
    
    
    always @ (posedge clk_in)
    begin
      output_pipeline_reg[ADDITIONAL_DEPTH-1] <= synchronizer_reg[0];   // feeding the synchronizer output into this pipeline's MSB
      output_pipeline_reg[ADDITIONAL_DEPTH-2:0] <= output_pipeline_reg[ADDITIONAL_DEPTH-1:1];  // right shift by 1
    end
    
  end
endgenerate
  
  assign reset_out = output_pipeline_reg[0];
  assign clk_out = clk_in;   // this is to make it easier to export a clock and reset to the level above it

endmodule
