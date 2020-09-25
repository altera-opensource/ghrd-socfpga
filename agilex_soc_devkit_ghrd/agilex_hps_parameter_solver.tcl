#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2020 Intel Corporation.
#
#****************************************************************************
#
# This file means to solve AGILEX HPS parameters value with each related argument passed in
#
#****************************************************************************

#set s2f_width $h2f_width
if {$h2f_width == 32} {
	set s2f_width 1
} elseif {$h2f_width == 64} {
	set s2f_width 2
} elseif {$h2f_width == 128} {
	set s2f_width 3
} else {
	set s2f_width 0
}

#set f2s_width $f2h_width
if {$f2h_width == 128} {
	set f2s_width 3
} elseif {$f2h_width == 256} {
	set f2s_width 4
} elseif {$f2h_width == 512} {
	set f2s_width 5
} else {
	set f2s_width 0
}

if {$lwh2f_width > 0} {
	set lwh2f_width 1
} else {
	set lwh2f_width 0
}

# S2F IRQ enablement
set s2f_emac0_irq_en 0
set s2f_emac1_irq_en 0
set s2f_emac2_irq_en 0
set s2f_gpio_irq_en 0
set s2f_i2cemac0_irq_en 0
set s2f_i2cemac1_irq_en 0
set s2f_i2cemac2_irq_en 0
set s2f_i2c0_irq_en 0
set s2f_i2c1_irq_en 0
set s2f_nand_irq_en 0
set s2f_sdmmc_irq_en 0
set s2f_spim0_irq_en 0
set s2f_spim1_irq_en 0
set s2f_spis0_irq_en 0
set s2f_spis1_irq_en 0
set s2f_uart0_irq_en 0
set s2f_uart1_irq_en 0
set s2f_usb0_irq_en 0
set s2f_usb1_irq_en 0

if {$hps_peri_irq_loopback_en == 1} {
	if {$hps_emac0_rmii_en == 1 || $hps_emac0_rgmii_en == 1} {
		set s2f_emac0_irq_en 1
	}
	if {$hps_emac1_rmii_en == 1 || $hps_emac1_rgmii_en == 1} {
		set s2f_emac1_irq_en 1
	}
	if {$hps_emac2_rmii_en == 1 || $hps_emac2_rgmii_en == 1} {
		set s2f_emac2_irq_en 1	
	}
	if {$hps_gpio0_en == 1 || $hps_gpio1_en == 1} {
		set s2f_gpio_irq_en 1	
	}
	if {$hps_i2c_emac0_q1_en == 1 || $hps_i2c_emac0_q3_en == 1 || $hps_i2c_emac0_q4_en == 1} {
		set s2f_i2cemac0_irq_en 1	
	}
	if {$hps_i2c_emac1_q1_en == 1 || $hps_i2c_emac1_q4_en == 1} {
		set s2f_i2cemac1_irq_en 1	
	}	
	if {$hps_i2c_emac2_q1_en == 1 || $hps_i2c_emac2_q3_en == 1 || $hps_i2c_emac2_q4_en == 1} {
		set s2f_i2cemac2_irq_en 1	
	}
	if {$hps_i2c0_q1_en == 1 || $hps_i2c0_q2_en == 1 || $hps_i2c0_q3_en == 1} {
		set s2f_i2c0_irq_en 1	
	}
	if {$hps_i2c1_q1_en == 1 || $hps_i2c1_q2_en == 1 || $hps_i2c1_q3_en == 1 || $hps_i2c1_q4_en == 1} {
		set s2f_i2c1_irq_en 1	
	}
	if {$hps_nand_q12_en == 1 || $hps_nand_q34_en == 1} {
		set s2f_nand_irq_en 1	
	}
	if {$hps_sdmmc4b_q1_en == 1 || $hps_sdmmc8b_q1_en == 1 || $hps_sdmmc4b_q4_en == 1 || $hps_sdmmc8b_q4_en == 1} {
		set s2f_sdmmc_irq_en 1	
	}
	if {$hps_spim0_q1_en == 1 || $hps_spim0_q4_en == 1} {
		set s2f_spim0_irq_en 1	
	}
	if {$hps_spim1_q1_en == 1 || $hps_spim1_q2_en == 1 || $hps_spim1_q3_en == 1} {
		set s2f_spim1_irq_en 1	
	}
	if {$hps_spis0_q1_en == 1 || $hps_spis0_q2_en == 1 || $hps_spis0_q3_en == 1} {
		set s2f_spis0_irq_en 1	
	}
	if {$hps_spis1_q1_en == 1 || $hps_spis1_q3_en == 1 || $hps_spis1_q4_en == 1} {
		set s2f_spis1_irq_en 1	
	}
	if {$hps_uart0_q1_en == 1 || $hps_uart0_q2_en == 1 || $hps_uart0_q3_en == 1} {
		set s2f_uart0_irq_en 1	
	}
	if {$hps_uart1_q1_en == 1 || $hps_uart1_q3_en == 1 || $hps_uart1_q4_en == 1} {
		set s2f_uart1_irq_en 1	
	}
	if {$hps_usb0_en == 1} {
		set s2f_usb0_irq_en 1	
	}
	if {$hps_usb1_en == 1} {
		set s2f_usb1_irq_en 1	
	}
}

# Validation of parameter combinations correctness
if {$h2f_f2h_loopback_en == 1} {
	if {$f2h_addr_width > $h2f_addr_width} {
		puts "Error: FPGA-to-SoC Bridge address range is greater than connected SoC-to-FPGA Bridge accessible range"
	}
}

if {$lwh2f_f2h_loopback_en == 1} {
	if {$f2h_addr_width > $lwh2f_addr_width} {
		puts "Error: FPGA-to-SoC Bridge address range is greater than connected SoC-to-FPGA Lightweight Bridge accessible range"
	}
}

