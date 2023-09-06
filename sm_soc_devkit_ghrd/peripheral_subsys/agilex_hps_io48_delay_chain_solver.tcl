#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2020 Intel Corporation.
#
#****************************************************************************
#
# This file means to solve chain delay assignment to all IO48 pins
#
#****************************************************************************

# Initialize IO48 chain delay assignment based on port properties
set io48_output_pin [list "JTAG:TDO" "SDMMC:CCLK" "USB*:STP" "EMAC*:TX_CLK" "EMAC*:TX_CTL" "EMAC*:TXD0" "EMAC*:TXD1" "EMAC*:TXD2" "EMAC*:TXD3" "MDIO*:MDC" \
                          "SPIM0:CLK" "SPIM0:MOSI" "SPIM0:SS0_N" "SPIS0:MISO" "UART0:TX" "UART0:RTS_N" "NAND:ALE" "NAND:CE_N" "NAND:CLE" "NAND:WE_N" "NAND:RE_N" "NAND:WP_N" \  
                    ]
set io48_input_pin [list "JTAG:TCK" "JTAG:TMS" "JTAG:TDI" "USB*:CLK" "USB*:DIR" "USB*:NXT" "EMAC*:RX_CLK" "EMAC*:RX_CTL" "EMAC*:RXD0" "EMAC*:RXD1" "EMAC*:RXD2" "EMAC*:RXD3" \
                         "SPIM0:MISO" "SPIS0:CLK" "SPIS0:MOSI" "SPIS0:SS0_N" "UART0:RX" "UART0:CTS_N" "NAND:RB" "HPS_OSC_CLK" "TRACE:CLK" "TRACE:D0" "TRACE:D1" "TRACE:D2" "TRACE:D3" \
                         "TRACE:D10" "TRACE:D9" "TRACE:D8" "TRACE:D7" "TRACE:D6" "TRACE:D15" "TRACE:D14" "TRACE:D13" "TRACE:D12" "TRACE:D11" \
                   ]
set io48_bidirect_pin [list "SDMMC:CMD" "SDMMC:D0" "SDMMC:D1" "SDMMC:D2" "SDMMC:D3" "SDMMC:D4" "SDMMC:D5" "SDMMC:D6" "SDMMC:D7" "I2CEMAC*:SDA" "I2CEMAC*:SCL" \
                            "USB*:DATA0" "USB*:DATA1" "USB*:DATA2" "USB*:DATA3" "USB*:DATA4" "USB*:DATA5" "USB*:DATA6" "USB*:DATA7" "I2C*:SDA" "I2C*:SCL" \
                            "MDIO*:MDIO" "NAND:ADQ0" "NAND:ADQ1" "NAND:ADQ2" "NAND:ADQ3" "NAND:ADQ4" "NAND:ADQ5" "NAND:ADQ6" "NAND:ADQ7" "NAND:ADQ8" "NAND:ADQ9" \
                            "NAND:ADQ10" "NAND:ADQ11" "NAND:ADQ12" "NAND:ADQ13" "NAND:ADQ14" "NAND:ADQ15" "GPIO" \
                      ]

set io48_pinmux_assignment [list $io48_q1_assignment $io48_q2_assignment $io48_q3_assignment $io48_q4_assignment]
set count 0
array set output_dly_chain_io48 []
array set input_dly_chain_io48 []
foreach io_quadrant $io48_pinmux_assignment {
    foreach io_pin $io_quadrant {
        if [string match [lindex $io48_output_pin 3] $io_pin] {
        set output_dly_chain_io48($count) 45
        set input_dly_chain_io48($count) 0
        } elseif [string match [lindex $io48_input_pin 3] $io_pin] {
        set output_dly_chain_io48($count) 0
        set input_dly_chain_io48($count) 0
        } elseif [string match [lindex $io48_bidirect_pin 3] $io_pin] {
        set output_dly_chain_io48($count) 0
        set input_dly_chain_io48($count) 0
        } else {
        set output_dly_chain_io48($count) 0
        set input_dly_chain_io48($count) 0
        }
    incr count
    }
}

