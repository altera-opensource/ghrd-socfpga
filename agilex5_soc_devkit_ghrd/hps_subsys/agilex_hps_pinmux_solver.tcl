#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2023 Intel Corporation.
#
#****************************************************************************
#
# This file means to solve pinmux enablement of each peripheral to IO48 quadrants
#
#****************************************************************************

# List variables for enabling peripherals of each Io48 quadrant
set hps_sdmmc4b_q1_en 0
set hps_sdmmc4b_q1_sel_en 0
set hps_sdmmc4b_q1_alt_en 0
set hps_sdmmc8b_q1_alt_en 0
set hps_sdmmc12b_q1_alt_en 0
set hps_sdmmc2b_q2_alt_en 0
set hps_sdmmc4b_q2_alt_en 0
set hps_sdmmc4b_q3_en 0
set hps_sdmmc4b_q3_alt_en 0
set hps_sdmmc12b_q3_alt_en 0
set hps_sdmmc_pupd_q2_en 0
set hps_sdmmc_pwr_q2_en 0
set hps_sdmmc_dstrb_q2_en 0
set hps_sdmmc_pupd_q4_en 0
set hps_sdmmc_pwr_q4_en 0
set hps_sdmmc_dstrb_q4_en 0

set hps_usb0_en 0
set hps_usb1_en 0

set hps_emac0_rmii_en 0
set hps_emac0_rgmii_en 0
set hps_emac1_rmii_en 0
set hps_emac1_rgmii_en 0
set hps_emac2_rmii_en 0
set hps_emac2_rgmii_en 0
set hps_emac0_q1_en 0
set hps_emac1_q1_en 0
set hps_emac2_q1_en 0

set hps_spim0_q1_en 0
set hps_spim0_q4_en 0
set hps_spim0_q4_alt_en 0
set hps_spim0_2ss_en 0
set hps_spim1_q1_en 0
set hps_spim1_q2_en 0
set hps_spim1_q3_en 0
set hps_spim1_2ss_en 0

set hps_spis0_q1_en 0
set hps_spis0_q2_en 0
set hps_spis0_q3_en 0
set hps_spis1_q1_en 0
set hps_spis1_q3_en 0
set hps_spis1_q4_en 0

set hps_uart0_q1_en 0
set hps_uart0_q2_en 0
set hps_uart0_q3_en 0
set hps_uart0_fc_en 0
set hps_uart1_q1_en 0
set hps_uart1_q3_en 0
set hps_uart1_q4_en 0
set hps_uart1_fc_en 0

set hps_mdio0_q1_en 0
set hps_mdio0_q3_en 0
set hps_mdio0_q4_en 0
set hps_mdio1_q1_en 0
set hps_mdio1_q4_en 0
set hps_mdio2_q1_en 0
set hps_mdio2_q3_en 0

set hps_i2c0_q1_en 0
set hps_i2c0_q2_en 0
set hps_i2c0_q3_en 0
set hps_i2c1_q1_en 0
set hps_i2c1_q2_en 0
set hps_i2c1_q3_en 0
set hps_i2c1_q4_en 0

set hps_i2c_emac0_q1_en 0
set hps_i2c_emac0_q3_en 0
set hps_i2c_emac0_q4_en 0
set hps_i2c_emac1_q1_en 0
set hps_i2c_emac1_q4_en 0
set hps_i2c_emac2_q1_en 0
set hps_i2c_emac2_q3_en 0
set hps_i2c_emac2_q4_en 0

set hps_i3c0_q1_en 0
set hps_i3c0_q2_en 0
set hps_i3c0_q3_en 0
set hps_i3c0_q4_en 0
set hps_i3c1_q1_en 0
set hps_i3c1_q2_en 0
set hps_i3c1_q3_en 0
set hps_i3c1_q4_en 0

set hps_nand_q12_en 0
set hps_nand_q34_en 0
set hps_nand_16b_en 0

set hps_trace_q12_en 0
set hps_trace_q34_en 0
set hps_trace_8b_en 0
set hps_trace_12b_en 0
set hps_trace_16b_en 0
set hps_trace_alt_en 0

set hps_cm_q 0
set hps_cm_io 0
set hps_cm_alt_en 0

set hps_gpio0_en 0
set hps_gpio0_list ""
set hps_gpio1_en 0
set hps_gpio1_list ""
set hps_pll_out_en 0

set hps_jtag_en 0
set hps_io_custom ""

# Initialize IO48 Pinmux assignment for each quadrant
set io48_q1_assignment ""
set io48_q2_assignment ""
set io48_q3_assignment ""
set io48_q4_assignment ""
for {set i 0} {$i < 12} {incr i} {
    lappend io48_q1_assignment NONE
    lappend io48_q2_assignment NONE
    lappend io48_q3_assignment NONE
    lappend io48_q4_assignment NONE
}

source ${prjroot}/hps_subsys/agilex_io48.tcl

# Assigning individual IO48 peripherals
if {$hps_jtag_en == 1} {
set io48_q3_assignment [lreplace $io48_q3_assignment 8 11 JTAG:TCK JTAG:TMS JTAG:TDO JTAG:TDI]
}

#SDMMC Q1
if {$hps_sdmmc4b_q1_en == 1} {
	#puts "[llength $io48_q1_assignment]"
	set io48_q1_assignment [lreplace $io48_q1_assignment 0 2 SDMMC:DATA0 SDMMC:DATA1 SDMMC:CLK]
}
if {$hps_sdmmc4b_q1_sel_en == 1} {
	set io48_q1_assignment [lreplace $io48_q1_assignment 3 3 SDMMC:LVL_SEL]
}
if {$hps_sdmmc4b_q1_alt_en == 1} {
	set io48_q1_assignment [lreplace $io48_q1_assignment 4 4 SDMMC:WRITE_PROTECT]
}
if {$hps_sdmmc8b_q1_alt_en == 1} {
	set io48_q1_assignment [lreplace $io48_q1_assignment 5 7 SDMMC:DATA2 SDMMC:DATA3 SDMMC:CMD]
}
if {$hps_sdmmc12b_q1_alt_en == 1} {
	set io48_q1_assignment [lreplace $io48_q1_assignment 8 11 SDMMC:DATA4 SDMMC:DATA5 SDMMC:DATA6 SDMMC:DATA7]
}

#SDMMC Q2
if {$hps_sdmmc_pupd_q2_en == 1} {
	set io48_q2_assignment [lreplace $io48_q2_assignment 0 0 SDMMC:PU_PD_DATA2]
}
if {$hps_sdmmc_pwr_q2_en == 1} {
	set io48_q2_assignment [lreplace $io48_q2_assignment 1 1 SDMMC:BUS_PWR]   
}
if {$hps_sdmmc_dstrb_q2_en == 1} {
	set io48_q2_assignment [lreplace $io48_q2_assignment 3 3 SDMMC:DATA_STROBE]
}

#SDMMC Q3
if {$hps_sdmmc4b_q3_en == 1} {
	set io48_q3_assignment [lreplace $io48_q3_assignment 0 2 SDMMC:DATA0 SDMMC:DATA1 SDMMC:CCLK]
	set io48_q3_assignment [lreplace $io48_q3_assignment 5 7 SDMMC:DATA2 SDMMC:DATA3 SDMMC:CMD]
}
if {$hps_sdmmc_wp_q3_en == 1} {
		set io48_q3_assignment [lreplace $io48_q3_assignment 4 4 SDMMC:WPROT]
}
if {$hps_sdmmc12b_q3_alt_en == 1} {
	set io48_q3_assignment [lreplace $io48_q3_assignment 8 11 SDMMC:DATA4 SDMMC:DATA5 SDMMC:DATA6 SDMMC:DATA7]  
}

#SDMMC Q4
if {$hps_sdmmc_pupd_q4_en == 1} {
	set io48_q4_assignment [lreplace $io48_q4_assignment 0 0 SDMMC:PU_PD_DATA2]
}
if {$hps_sdmmc_pwr_q4_en == 1} {
	set io48_q4_assignment [lreplace $io48_q4_assignment 1 1 SDMMC:PWR_ENA] 
}
if {$hps_sdmmc_dstrb_q4_en == 1} {
	set io48_q4_assignment [lreplace $io48_q4_assignment 3 3 SDMMC:DATA_STROBE]  
}

if {$hps_usb0_en == 1} {
set io48_q1_assignment [lreplace $io48_q1_assignment 0 11 USB0:CLK USB0:STP USB0:DIR USB0:DATA0 USB0:DATA1 USB0:NXT USB0:DATA2 USB0:DATA3 USB0:DATA4 USB0:DATA5 USB0:DATA6 USB0:DATA7]
}
if {$hps_usb1_en == 1} {
set io48_q2_assignment [lreplace $io48_q2_assignment 0 11 USB1:CLK USB1:STP USB1:DIR USB1:DATA0 USB1:DATA1 USB1:NXT USB1:DATA2 USB1:DATA3 USB1:DATA4 USB1:DATA5 USB1:DATA6 USB1:DATA7]
}

if {$hps_emac0_rgmii_en == 1} {
set io48_q2_assignment [lreplace $io48_q2_assignment 0 11 EMAC0:TX_CLK EMAC0:TX_CTL EMAC0:RX_CLK EMAC0:RX_CTL EMAC0:TXD0 EMAC0:TXD1 EMAC0:RXD0 EMAC0:RXD1 EMAC0:TXD2 EMAC0:TXD3 EMAC0:RXD2 EMAC0:RXD3]
} elseif {$hps_emac0_rmii_en == 1} {
set io48_q2_assignment [lreplace $io48_q2_assignment 0 7 EMAC0:TX_CLK EMAC0:TX_CTL EMAC0:RX_CLK EMAC0:RX_CTL EMAC0:TXD0 EMAC0:TXD1 EMAC0:RXD0 EMAC0:RXD1]
}

if {$hps_emac1_rgmii_en == 1} {
set io48_q3_assignment [lreplace $io48_q3_assignment 0 11 EMAC1:TX_CLK EMAC1:TX_CTL EMAC1:RX_CLK EMAC1:RX_CTL EMAC1:TXD0 EMAC1:TXD1 EMAC1:RXD0 EMAC1:RXD1 EMAC1:TXD2 EMAC1:TXD3 EMAC1:RXD2 EMAC1:RXD3]
} elseif {$hps_emac1_rmii_en == 1} {
set io48_q3_assignment [lreplace $io48_q3_assignment 0 7 EMAC1:TX_CLK EMAC1:TX_CTL EMAC1:RX_CLK EMAC1:RX_CTL EMAC1:TXD0 EMAC1:TXD1 EMAC1:RXD0 EMAC1:RXD1]
}

if {$hps_emac2_rgmii_en == 1} {
set io48_q4_assignment [lreplace $io48_q4_assignment 0 11 EMAC2:TX_CLK EMAC2:TX_CTL EMAC2:RX_CLK EMAC2:RX_CTL EMAC2:TXD0 EMAC2:TXD1 EMAC2:RXD0 EMAC2:RXD1 EMAC2:TXD2 EMAC2:TXD3 EMAC2:RXD2 EMAC2:RXD3]
} elseif {$hps_emac2_rmii_en == 1} {
set io48_q4_assignment [lreplace $io48_q4_assignment 0 7 EMAC2:TX_CLK EMAC2:TX_CTL EMAC2:RX_CLK EMAC2:RX_CTL EMAC2:TXD0 EMAC2:TXD1 EMAC2:RXD0 EMAC2:RXD1]
}

if {$hps_emac0_q1_en == 1} {
set io48_q1_assignment [lreplace $io48_q1_assignment 0 1 EMAC0:PPS0 EMAC0:PPSTRIG0]
if {$daughter_card == "tsn_aic0"} {
set io48_q1_assignment [lreplace $io48_q1_assignment 4 5 EMAC2:PPS2 EMAC2:PPSTRIG2]
}
} elseif {$hps_emac1_q1_en == 1} {
set io48_q1_assignment [lreplace $io48_q1_assignment 2 3 EMAC1:PPS1 EMAC1:PPSTRIG1]
} elseif {$hps_emac2_q1_en == 1} {
set io48_q1_assignment [lreplace $io48_q1_assignment 4 5 EMAC2:PPS2 EMAC2:PPSTRIG2]
}

if {$hps_spim0_q1_en == 1} {
set io48_q1_assignment [lreplace $io48_q1_assignment 4 7 SPIM0:CLK SPIM0:MOSI SPIM0:MISO SPIM0:SS0_N]
  if {$hps_spim0_2ss_en == 1} {
    set io48_q1_assignment [lreplace $io48_q1_assignment 0 0 SPIM0:SS1_N]
  }
} elseif {$hps_spim0_q4_en == 1} {
set io48_q4_assignment [lreplace $io48_q4_assignment 8 11 SPIM0:CLK SPIM0:MOSI SPIM0:MISO SPIM0:SS0_N]
  if {$hps_spim0_2ss_en == 1} {
    #HOW TO DIFFERENTIATE THE 5 7 SINGLE ELEMENT BUT NOT 5 7 REFER TO 5 6 7 (SAME AS SDMMC AND EMAC CASE THAT HAS AN EMPTY BIT IN MIDDLE OF THE LIST)
    set io48_q4_assignment [lreplace $io48_q4_assignment 5 5 SPIM0:SS1_N]
  }
} elseif {$hps_spim0_q4_alt_en == 1} {
set io48_q4_assignment [lreplace $io48_q4_assignment 6 9 SPIM0:MISO SPIM0:SS0_N SPIM0:CLK SPIM0:MOSI SPIM0:MISO SPIM0:SS0_N]
  if {$hps_spim0_2ss_en == 1} {
    set io48_q4_assignment [lreplace $io48_q4_assignment 5 5 SPIM0:SS1_N]
  }
}

if {$hps_spim1_q1_en == 1} {
set io48_q1_assignment [lreplace $io48_q1_assignment 8 11 SPIM1:CLK SPIM1:MOSI SPIM1:MISO SPIM1:SS0_N]
  if {$hps_spim1_2ss_en == 1} {
    set io48_q1_assignment [lreplace $io48_q1_assignment 1 1 SPIM1:SS1_N]
  }
} elseif {$hps_spim1_q2_en == 1} {
set io48_q2_assignment [lreplace $io48_q2_assignment 8 11 SPIM1:CLK SPIM1:MOSI SPIM1:MISO SPIM1:SS0_N]
  if {$hps_spim1_2ss_en == 1} {
    set io48_q2_assignment [lreplace $io48_q2_assignment 7 7 SPIM1:SS1_N]
  }
} elseif {$hps_spim1_q3_en == 1} {
set io48_q3_assignment [lreplace $io48_q3_assignment 0 3 SPIM1:CLK SPIM1:MOSI SPIM1:MISO SPIM1:SS0_N]
  if {$hps_spim1_2ss_en == 1} {
    set io48_q3_assignment [lreplace $io48_q3_assignment 4 4 SPIM1:SS1_N]
  }
}

if {$hps_spis0_q1_en == 1} {
set io48_q1_assignment [lreplace $io48_q1_assignment 0 3 SPIS0:CLK SPIS0:MOSI SPIS0:SS0_N SPIS0:MISO]
} elseif {$hps_spis0_q2_en == 1} {
set io48_q2_assignment [lreplace $io48_q2_assignment 8 11 SPIS0:CLK SPIS0:MOSI SPIS0:SS0_N SPIS0:MISO]
} elseif {$hps_spis0_q3_en == 1} {
set io48_q3_assignment [lreplace $io48_q3_assignment 8 11 SPIS0:CLK SPIS0:MOSI SPIS0:SS0_N SPIS0:MISO]
}

if {$hps_spis1_q1_en == 1} {
set io48_q1_assignment [lreplace $io48_q1_assignment 8 11 SPIS1:CLK SPIS1:MOSI SPIS1:SS0_N SPIS1:MISO]
} elseif {$hps_spis1_q3_en == 1} {
set io48_q3_assignment [lreplace $io48_q3_assignment 4 7 SPIS1:CLK SPIS1:MOSI SPIS1:SS0_N SPIS1:MISO]
} elseif {$hps_spis1_q4_en == 1} {
set io48_q4_assignment [lreplace $io48_q4_assignment 8 11 SPIS1:CLK SPIS1:MOSI SPIS1:SS0_N SPIS1:MISO]
}

if {$hps_uart0_q1_en == 1} {
set io48_q1_assignment [lreplace $io48_q1_assignment 2 3 UART0:TX UART0:RX]
  if {$hps_uart0_fc_en == 1} {
    set io48_q1_assignment [lreplace $io48_q1_assignment 0 1 UART0:CTS_N UART0:RTS_N]
  }
} elseif {$hps_uart0_q2_en == 1} {
set io48_q2_assignment [lreplace $io48_q2_assignment 10 11 UART0:TX UART0:RX]
  if {$hps_uart0_fc_en == 1} {
    set io48_q2_assignment [lreplace $io48_q2_assignment 8 9 UART0:CTS_N UART0:RTS_N]
  }
} elseif {$hps_uart0_q3_en == 1} {
set io48_q3_assignment [lreplace $io48_q3_assignment 2 3 UART0:TX UART0:RX]
  if {$hps_uart0_fc_en == 1} {
    set io48_q3_assignment [lreplace $io48_q3_assignment 0 1 UART0:CTS_N UART0:RTS_N]
  }
}

if {$hps_uart1_q1_en == 1} {
set io48_q1_assignment [lreplace $io48_q1_assignment 6 7 UART1:TX UART1:RX]
  if {$hps_uart1_fc_en == 1} {
    set io48_q1_assignment [lreplace $io48_q1_assignment 4 5 UART1:CTS_N UART1:RTS_N]
  }
} elseif {$hps_uart1_q3_en == 1} {
set io48_q3_assignment [lreplace $io48_q3_assignment 6 7 UART1:TX UART1:RX]
  if {$hps_uart1_fc_en == 1} {
    set io48_q3_assignment [lreplace $io48_q3_assignment 4 5 UART1:CTS_N UART1:RTS_N]
  }
} elseif {$hps_uart1_q4_en == 1} {
set io48_q4_assignment [lreplace $io48_q4_assignment 2 3 UART1:TX UART1:RX]
  if {$hps_uart1_fc_en == 1} {
    set io48_q4_assignment [lreplace $io48_q4_assignment 4 5 UART1:CTS_N UART1:RTS_N]
  }
}

if {$hps_mdio0_q1_en == 1} {
set io48_q1_assignment [lreplace $io48_q1_assignment 10 11 MDIO0:MDIO MDIO0:MDC]
} elseif {$hps_mdio0_q3_en == 1} {
set io48_q3_assignment [lreplace $io48_q3_assignment 10 11 MDIO0:MDIO MDIO0:MDC]
}  elseif {$hps_mdio0_q4_en == 1} {
set io48_q4_assignment [lreplace $io48_q4_assignment 10 11 MDIO0:MDIO MDIO0:MDC]
} 

if {$hps_mdio1_q1_en == 1} {
set io48_q1_assignment [lreplace $io48_q1_assignment 8 9 MDIO1:MDIO MDIO1:MDC]
} elseif {$hps_mdio1_q4_en == 1} {
set io48_q4_assignment [lreplace $io48_q4_assignment 6 7 MDIO1:MDIO MDIO1:MDC]
} 

if {$hps_mdio2_q1_en == 1} {
set io48_q1_assignment [lreplace $io48_q1_assignment 6 7 MDIO2:MDIO MDIO2:MDC]
} elseif {$hps_mdio2_q3_en == 1} {
set io48_q3_assignment [lreplace $io48_q3_assignment 8 9 MDIO2:MDIO MDIO2:MDC]
} 

if {$hps_i2c0_q1_en == 1} {
set io48_q1_assignment [lreplace $io48_q1_assignment 4 5 I2C0:SDA I2C0:SCL]
} elseif {$hps_i2c0_q2_en == 1} {
set io48_q2_assignment [lreplace $io48_q2_assignment 10 11 I2C0:SDA I2C0:SCL]
} elseif {$hps_i2c0_q3_en == 1} {
set io48_q3_assignment [lreplace $io48_q3_assignment 2 3 I2C0:SDA I2C0:SCL]
} 

if {$hps_i2c1_q1_en == 1} {
set io48_q1_assignment [lreplace $io48_q1_assignment 2 3 I2C1:SDA I2C1:SCL]
} elseif {$hps_i2c1_q2_en == 1} {
set io48_q2_assignment [lreplace $io48_q2_assignment 8 9 I2C1:SDA I2C1:SCL]
} elseif {$hps_i2c1_q3_en == 1} {
set io48_q3_assignment [lreplace $io48_q3_assignment 6 7 I2C1:SDA I2C1:SCL]
} elseif {$hps_i2c1_q4_en == 1} {
set io48_q4_assignment [lreplace $io48_q4_assignment 0 1 I2C1:SDA I2C1:SCL]
} 

if {$hps_i2c_emac0_q1_en == 1} {
set io48_q1_assignment [lreplace $io48_q1_assignment 10 11 I2C_EMAC0:SDA I2C_EMAC0:SCL]
} elseif {$hps_i2c_emac0_q3_en == 1} {
set io48_q3_assignment [lreplace $io48_q3_assignment 10 11 I2C_EMAC0:SDA I2C_EMAC0:SCL]
} elseif {$hps_i2c_emac0_q4_en == 1} {
set io48_q4_assignment [lreplace $io48_q4_assignment 10 11 I2C_EMAC0:SDA I2C_EMAC0:SCL]
} 

if {$hps_i2c_emac1_q1_en == 1} {
set io48_q1_assignment [lreplace $io48_q1_assignment 8 9 I2C_EMAC1:SDA I2C_EMAC1:SCL]
} elseif {$hps_i2c_emac1_q4_en == 1} {
set io48_q4_assignment [lreplace $io48_q4_assignment 6 7 I2C_EMAC1:SDA I2C_EMAC1:SCL]
} 

if {$hps_i2c_emac2_q1_en == 1} {
set io48_q1_assignment [lreplace $io48_q1_assignment 6 7 I2C_EMAC2:SDA I2C_EMAC2:SCL]
} elseif {$hps_i2c_emac2_q3_en == 1} {
set io48_q3_assignment [lreplace $io48_q3_assignment 8 9 I2C_EMAC2:SDA I2C_EMAC2:SCL]
} elseif {$hps_i2c_emac2_q4_en == 1} {
set io48_q4_assignment [lreplace $io48_q4_assignment 8 9 I2C_EMAC2:SDA I2C_EMAC2:SCL]
} 

if {$hps_i3c0_q1_en == 1} {
set io48_q1_assignment [lreplace $io48_q1_assignment 10 11 I3C0:SDA I3C0:SCL]
} elseif {$hps_i3c0_q2_en == 1} {
set io48_q2_assignment [lreplace $io48_q2_assignment 6 7 I3C0:SDA I3C0:SCL]
} elseif {$hps_i3c0_q3_en == 1} {
set io48_q3_assignment [lreplace $io48_q3_assignment 6 7 I3C0:SDA I3C0:SCL]
} elseif {$hps_i3c0_q4_en == 1} {
set io48_q4_assignment [lreplace $io48_q3_assignment 4 5 I3C0:SDA I3C0:SCL]
}

if {$hps_i3c1_q1_en == 1} {
set io48_q1_assignment [lreplace $io48_q1_assignment 8 9 I3C1:SDA I3C1:SCL]
} elseif {$hps_i3c1_q2_en == 1} {
set io48_q2_assignment [lreplace $io48_q2_assignment 4 5 I3C1:SDA I3C1:SCL]
} elseif {$hps_i3c1_q3_en == 1} {
set io48_q3_assignment [lreplace $io48_q3_assignment 4 5 I3C1:SDA I3C1:SCL]
} elseif {$hps_i3c1_q4_en == 1} {
set io48_q4_assignment [lreplace $io48_q3_assignment 2 3 I3C1:SDA I3C1:SCL]
}

if {$hps_nand_q12_en == 1} {
set io48_q1_assignment [lreplace $io48_q1_assignment 0 11 NAND:DATA0 NAND:DATA1 NAND:WE_N NAND:RE_N NAND:WP_N NAND:DATA2 NAND:DATA3 NAND:CLE NAND:DATA4 NAND:DATA5 NAND:DATA6 NAND:DATA7]
set io48_q2_assignment [lreplace $io48_q2_assignment 0 3 NAND:ALE NAND:RB_N NAND:CE_N NAND:DQS]
  if {$hps_nand_16b_en == 1} {
    set io48_q2_assignment [lreplace $io48_q2_assignment 0 11 NAND:ALE NAND:RB_N NAND:CE_N NAND:DQS NAND:DATA8 NAND:DATA9 NAND:DATA10 NAND:DATA11 NAND:DATA12 NAND:DATA13 NAND:DATA14 NAND:DATA15]
  }
} elseif {$hps_nand_q34_en == 1} {
set io48_q3_assignment [lreplace $io48_q3_assignment 0 11 NAND:ADQ0 NAND:ADQ1 NAND:WE_N NAND:RE_N NAND:WP_N NAND:ADQ2 NAND:ADQ3 NAND:CLE NAND:ADQ4 NAND:ADQ5 NAND:ADQ6 NAND:ADQ7]
set io48_q4_assignment [lreplace $io48_q4_assignment 0 3 NAND:ALE NAND:RB_N NAND:CE_N NAND:DQS]
  if {$hps_nand_16b_en == 1} {
    set io48_q4_assignment [lreplace $io48_q4_assignment 0 11 NAND:ALE NAND:RB_N NAND:CE_N NAND:DQS NAND:DATA8 NAND:DATA9 NAND:DATA10 NAND:DATA11 NAND:DATA12 NAND:DATA13 NAND:DATA14 NAND:DATA15]
  }
} 

if {$hps_trace_q12_en == 1} {
set io48_q2_assignment [lreplace $io48_q2_assignment 7 11 TRACE:CLK TRACE:D0 TRACE:D1 TRACE:D2 TRACE:D3]
  if {$hps_trace_alt_en == 1} {
    if {$hps_trace_8b_en == 1} { 
      set io48_q1_assignment [lreplace $io48_q1_assignment 3 6 TRACE:D7 TRACE:D6 TRACE:D5 TRACE:D4]
    } elseif {$hps_trace_12b_en == 1} { 
      set io48_q1_assignment [lreplace $io48_q1_assignment 11 11 TRACE:D11]
      set io48_q1_assignment [lreplace $io48_q1_assignment 0 6 TRACE:D10 TRACE:D9 TRACE:D8 TRACE:D7 TRACE:D6 TRACE:D5 TRACE:D4]
    } elseif {$hps_trace_16b_en == 1} {
      set io48_q1_assignment [lreplace $io48_q1_assignment 7 11 TRACE:D15 TRACE:D14 TRACE:D13 TRACE:D12 TRACE:D11]
      set io48_q1_assignment [lreplace $io48_q1_assignment 0 6 TRACE:D10 TRACE:D9 TRACE:D8 TRACE:D7 TRACE:D6 TRACE:D5 TRACE:D4]
    }
  } else {
    if {$hps_trace_8b_en == 1} { 
      set io48_q2_assignment [lreplace $io48_q2_assignment 3 6 TRACE:D7 TRACE:D6 TRACE:D5 TRACE:D4]
    } elseif {$hps_trace_12b_en == 1} { 
      set io48_q1_assignment [lreplace $io48_q1_assignment 11 11 TRACE:D11]
      set io48_q2_assignment [lreplace $io48_q2_assignment 0 6 TRACE:D10 TRACE:D9 TRACE:D8 TRACE:D7 TRACE:D6 TRACE:D5 TRACE:D4]
    } elseif {$hps_trace_16b_en == 1} {
      set io48_q1_assignment [lreplace $io48_q1_assignment 7 11 TRACE:D15 TRACE:D14 TRACE:D13 TRACE:D12 TRACE:D11]
      set io48_q2_assignment [lreplace $io48_q2_assignment 0 6 TRACE:D10 TRACE:D9 TRACE:D8 TRACE:D7 TRACE:D6 TRACE:D5 TRACE:D4]
    }
  }
} elseif {$hps_trace_q34_en == 1} {
set io48_q4_assignment [lreplace $io48_q4_assignment 7 11 TRACE:CLK TRACE:D0 TRACE:D1 TRACE:D2 TRACE:D3]
  if {$hps_trace_alt_en == 1} {
    if {$hps_trace_8b_en == 1} { 
      set io48_q3_assignment [lreplace $io48_q3_assignment 3 6 TRACE:D7 TRACE:D6 TRACE:D5 TRACE:D4]
    } elseif {$hps_trace_12b_en == 1} { 
      set io48_q3_assignment [lreplace $io48_q3_assignment 11 11 TRACE:D11]
      set io48_q3_assignment [lreplace $io48_q3_assignment 0 6 TRACE:D10 TRACE:D9 TRACE:D8 TRACE:D7 TRACE:D6 TRACE:D5 TRACE:D4]
    } elseif {$hps_trace_16b_en == 1} {
      set io48_q3_assignment [lreplace $io48_q3_assignment 7 11 TRACE:D15 TRACE:D14 TRACE:D13 TRACE:D12 TRACE:D11]
      set io48_q3_assignment [lreplace $io48_q3_assignment 0 6 TRACE:D10 TRACE:D9 TRACE:D8 TRACE:D7 TRACE:D6 TRACE:D5 TRACE:D4]
    }
  } else {
    if {$hps_trace_8b_en == 1} { 
      set io48_q4_assignment [lreplace $io48_q4_assignment 3 6 TRACE:D7 TRACE:D6 TRACE:D5 TRACE:D4]
    } elseif {$hps_trace_12b_en == 1} { 
      set io48_q3_assignment [lreplace $io48_q3_assignment 11 11 TRACE:D11]
      set io48_q4_assignment [lreplace $io48_q4_assignment 0 6 TRACE:D10 TRACE:D9 TRACE:D8 TRACE:D7 TRACE:D6 TRACE:D5 TRACE:D4]
    } elseif {$hps_trace_16b_en == 1} {
      set io48_q3_assignment [lreplace $io48_q3_assignment 7 11 TRACE:D15 TRACE:D14 TRACE:D13 TRACE:D12 TRACE:D11]
      set io48_q4_assignment [lreplace $io48_q4_assignment 0 6 TRACE:D10 TRACE:D9 TRACE:D8 TRACE:D7 TRACE:D6 TRACE:D5 TRACE:D4]
    }
  }
}

if {$hps_cm_q == 1} {
set io48_q1_assignment [lreplace $io48_q1_assignment [expr $hps_cm_io-1] [expr $hps_cm_io-1] HCLK:HPS_OSC_CLK]
} elseif {$hps_cm_q == 2} {
set io48_q2_assignment [lreplace $io48_q2_assignment [expr $hps_cm_io-1] [expr $hps_cm_io-1] HCLK:HPS_OSC_CLK]
} elseif {$hps_cm_q == 3} {
set io48_q3_assignment [lreplace $io48_q3_assignment [expr $hps_cm_io-1] [expr $hps_cm_io-1] HCLK:HPS_OSC_CLK]
} elseif {$hps_cm_q == 4} {
set io48_q4_assignment [lreplace $io48_q4_assignment [expr $hps_cm_io-1] [expr $hps_cm_io-1] HCLK:HPS_OSC_CLK]
} elseif {$hps_cm_alt_en == 1} {
set io48_q3_assignment [lreplace $io48_q3_assignment 0 3 CM:PLL_CLK0 CM:PLL_CLK1 CM:PLL_CLK2 CM:PLL_CLK3]
}

if {$hps_gpio0_en == 1} {
  foreach io_num [split $hps_gpio0_list] {
    if {$io_num < 12} {
	  set io48_q1_assignment [lreplace $io48_q1_assignment $io_num $io_num GPIO0:IO${io_num}]
      #set io48_q1_assignment [lreplace $io48_q1_assignment $io_num $io_num GPIO0]
    } else {
      set io48_q2_assignment [lreplace $io48_q2_assignment [expr $io_num-12] [expr $io_num-12] GPIO0:IO${io_num}]
      #set io48_q2_assignment [lreplace $io48_q2_assignment [expr $io_num-12] [expr $io_num-12] GPIO0]
    }
  }
}

if {$hps_gpio1_en == 1} {
  foreach io_num [split $hps_gpio1_list] {
    if {$io_num < 12} {
      set io48_q3_assignment [lreplace $io48_q3_assignment $io_num $io_num GPIO1:IO${io_num}]
      #set io48_q3_assignment [lreplace $io48_q3_assignment $io_num $io_num GPIO1]
    } else {
      set io48_q4_assignment [lreplace $io48_q4_assignment [expr $io_num-12] [expr $io_num-12] GPIO1:IO${io_num}]
      #set io48_q4_assignment [lreplace $io48_q4_assignment [expr $io_num-12] [expr $io_num-12] GPIO1]
    }
  }
}

if {$hps_io_custom != ""} {
  foreach {io_num value} $hps_io_custom {
    if {$io_num < 12} {
      set io48_q1_assignment [lreplace $io48_q1_assignment $io_num $io_num $value]
    } elseif {$io_num <24} {
      set io48_q2_assignment [lreplace $io48_q2_assignment [expr $io_num-12] [expr $io_num-12] $value]
    } elseif {$io_num <36} {
      set io48_q3_assignment [lreplace $io48_q3_assignment [expr $io_num-24] [expr $io_num-24] $value]
    } elseif {$io_num <48} {
      set io48_q4_assignment [lreplace $io48_q4_assignment [expr $io_num-36] [expr $io_num-36] $value]
    }
  }
}

#puts "[llength $io48_q1_assignment]"
puts "\[GHRD:info\] Sorted IO48 assignment:\n$io48_q1_assignment\n$io48_q2_assignment\n$io48_q3_assignment\n$io48_q4_assignment\n"


