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

#set h2f_width $h2f_width
#if {$h2f_width == 32} {
#	set s2f_width 1
#} elseif {$h2f_width == 64} {
#	set s2f_width 2
#} elseif {$h2f_width == 128} {
#	set s2f_width 3
#} else {
#	set s2f_width 0
#}

#set f2s_width $f2h_width
#if {$f2h_width > 0} {
#	set f2s_width 3
#} else {
#	set f2s_width 0
#}

#set lwh2f_width $lwh2f_width
#if {$lwh2f_width > 0} {
#	set lwh2f_width 1
#} else {
#	set lwh2f_width 0
#}

# H2F IRQ enablement
set h2f_emac0_irq_en 0
set h2f_emac1_irq_en 0
set h2f_emac2_irq_en 0
set h2f_gpio_irq_en 0
set h2f_i2cemac0_irq_en 0
set h2f_i2cemac1_irq_en 0
set h2f_i2cemac2_irq_en 0
set h2f_i2c0_irq_en 0
set h2f_i2c1_irq_en 0
set h2f_i3c0_irq_en 0
set h2f_i3c1_irq_en 0
set h2f_nand_irq_en 0
set h2f_sdmmc_irq_en 0
set h2f_spim0_irq_en 0
set h2f_spim1_irq_en 0
set h2f_spis0_irq_en 0
set h2f_spis1_irq_en 0
set h2f_uart0_irq_en 0
set h2f_uart1_irq_en 0
set h2f_usb0_irq_en 0
set h2f_usb1_irq_en 0


# Validation of parameter combinations correctness
#if {$h2f_f2h_loopback_en == 1} {
#	if {$f2h_addr_width > $h2f_addr_width} {
#		puts "Error: FPGA-to-SoC Bridge address range is greater than connected SoC-to-FPGA Bridge accessible range"
#	}
#}
#
#if {$lwh2f_f2h_loopback_en == 1} {
#	if {$f2h_addr_width > $lwh2f_addr_width} {
#		puts "Error: FPGA-to-SoC Bridge address range is greater than connected SoC-to-FPGA Lightweight Bridge accessible range"
#	}
#}

