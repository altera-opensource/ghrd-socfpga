//****************************************************************************
//
// SPDX-License-Identifier: MIT-0
// Copyright(c) 2001-2022 Intel Corporation.
//
//****************************************************************************
//
// etile_tod
// This component set 1'b1 to the "start_tod_sync" for ETILE TOD SUBSYSTEM
//****************************************************************************

module start_tod_sync(

	output                                    tx_tod_25gbe_start_tod_sync,
	output                                    rx_tod_25gbe_start_tod_sync,
	output                                    tx_tod_10gbe_start_tod_sync,
	output                                    rx_tod_10gbe_start_tod_sync
);

// RX & TX TOD's start_tod_sync
assign tx_tod_25gbe_start_tod_sync = 1'b1;
assign rx_tod_25gbe_start_tod_sync = 1'b1;
assign tx_tod_10gbe_start_tod_sync = 1'b1;
assign rx_tod_10gbe_start_tod_sync = 1'b1;

endmodule
