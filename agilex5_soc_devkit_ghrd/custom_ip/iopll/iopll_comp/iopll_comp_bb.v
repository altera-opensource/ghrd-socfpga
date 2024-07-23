module iopll_comp (
		input  wire  refclk,   //  refclk.clk,    The reference clock source that drives the I/O PLL.
		output wire  locked,   //  locked.export, The IOPLL IP core drives this port high when the PLL acquires lock. The port remains high as long as the I/O PLL is locked. The I/O PLL asserts the locked port when the phases and frequencies of the reference clock and feedback clock are the same or within the lock circuit tolerance. When the difference between the two clock signals exceeds the lock circuit tolerance, the I/O PLL loses lock.
		input  wire  rst,      //   reset.reset,  The asynchronous reset port for the output clocks. Drive this port high to reset all output clocks to the value of 0.
		output wire  outclk_0  // outclk0.clk,    Output clock Channel 0 from I/O PLL.
	);
endmodule

