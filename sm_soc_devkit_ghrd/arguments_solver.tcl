#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2021 Intel Corporation.
#
#****************************************************************************
#
# This file resolves all passed in arguments into GHRD understood parameterizable setting

# Following are list of arguments supported and its valid values
# device_family                     : <FPGA device family>
# device                            : <FPGA device part number>
# qsys_name                         : <name your qsys top>
# project_name                      : <name your quartus project>
# top_name                          : <top RTL module name of Quartus project>
# clk_gate_en                       : enable gated system clock with ninit_done. 1 or 0
# board                             : devkit, mUDV2, mUDV1, char, cypress, hemon, lookout, mcgowan, pyramid
# board_pwrmgt                      : enpirion, linear; Only valid for board="devkit"
# fpga_peripheral_en                : Enable PIO for LEDs, DIPSW and Pushbutton. 1 or 0
# jtag_ocm_en                       : Enable JTAG Masters and OnChipMemory. 1 or 0
# ocm_datawidth                     : 32, 64, 128, 256
# ocm_memsize                       : 262144.0 (Default), 8388608.0 (PCIE OCM Boot)
# hps_emif_en                       : 1 or 0
# hps_en                            : 1 or 0
# sys_initialization                : HPS initialization sequence. HPS_FIRST or FPGA_FIRST
# hps_dap_mode                      : HPS debug split mode. 2(SDM Pins),1(HPS Pins),0(disabled)
# user0_clk_src_select              : 7-PeriphC3 or 1-MainC1 (Select H2F User0 clock source)
# user0_clk_freq                    : Default 500.Specify desired frequency for H2F User0 clock
# user1_clk_src_select              : 7-PeriphC3 or 1-MainC1 (Select H2F User1 clock source)
# user1_clk_freq                    : Default 500. Specify desired frequency for H2F User1 clock
# h2f_width                         : 128, 64, 32 or 0(as disable)
# f2h_width                         : 256 or 0(as disable)
# f2s_data_width                    : 0:Unused, 256-bit"}
# f2s_address_width                 : {40-bit 1TB,39-bit 512GB,38-bit 256GB,37-bit 128GB,36-bit 64GB,35-bit 32GB,34-bit 16GB,33-bit 8GB,32-bit 4GB,31-bit 2GB,30-bit 1GB,29-bit 512 MB,28-bit 256 MB,27-bit 128 MB,26-bit 64 MB,25-bit 32 MB,24-bit 16 MB,23-bit 8 MB,22-bit 4 MB,21-bit 2 MB,20-bit 1 MB}     		
# f2sdram_data_width                : 0:Unused, 256-bit"}
# f2sdram_address_width             :{40-bit 1TB,39-bit 512GB,38-bit 256GB,37-bit 128GB,36-bit 64GB,35-bit 32GB,34-bit 16GB,33-bit 8GB,32-bit 4GB,31-bit 2GB,30-bit 1GB,29-bit 512 MB,28-bit 256 MB,27-bit 128 MB,26-bit 64 MB,25-bit 32 MB,24-bit 16 MB,23-bit 8 MB,22-bit 4 MB,21-bit 2 MB,20-bit 1 MB}
# lwh2f_width                       : 32 or 0(as disable)
# h2f_addr_width                    : 38-256GB, 37-128GB. 36-64GB, 35-32GB, 34-16GB. 33-16GB, 32-8GB, 31-2GB, 30-1GB, 29-512MB, 28-256MB, 27-128MB, 26-64MB, 25-32MB, 24-16MB, 23-8MB, 22-4MB, 21-2MB, 20-1MB
# f2h_addr_width                    : 40-1TB, 39-512GB, 38-256GB, 37-128GB. 36-64GB, 35-32GB, 34-16GB. 33-16GB, 32-8GB, 31-2GB, 30-1GB, 29-512MB, 28-256MB, 27-128MB, 26-64MB, 25-32MB, 24-16MB, 23-8MB, 22-4MB, 21-2MB, 20-1MB
# lwh2f_addr_width                  : 29-512MB, 28-256MB, 27-128MB, 26-64MB, 25-32MB, 24-16MB, 23-8MB, 22-4MB, 21-2MB, 20-1MB, 0(as disable)
# h2f_clk_source                    : 0 (System_100MHz), 1 (user1_clk_src_select)
# f2h_clk_source                    : 0 (System_100MHz), 1(user1_clk_src_select)
# lwh2f_clk_source                  : 0 (System_100MHz), 1 (user1_clk_src_select)
# ocm_clk_source                    : 0 (System_100MHz), 1 (user1_clk_src_select)
# secure_f2h_axi_slave              : 0 (non-secure), 1(secure)
# hps_peri_irq_loopback_en          : 1 or 0
# hps_f2s_irq_en                    : 1 or 0
# daughter_card                     : Daughter card selection, either "none"
# cross_trigger_en                  : 1 or 0
# hps_stm_en                        : 1 or 0
# ftrace_en                         : 1 or 0
# ftrace_output_width               : 16 or 32
# hps_pll_source_export             : 1 or 0
# reset_watchdog_en                 : 1 or 0
# reset_hps_warm_en                 : 1 or 0
# reset_h2f_cold_en                 : 1 or 0
# reset_sdm_watchdog_cfg            : 0, 1 or 2

#
# Each argument made available for configuration has a default value in design_config.tcl file
# The value can be passed in through Makefile.
#
#
#****************************************************************************

source ./design_config.tcl


proc check_then_accept { param } {
  if {$param == device_family || device || qsys_name || project_name} {
    puts "-- Accepted paramter \$param = $param"
  } else {
    puts "Warning: Inserted parameter \"$param\" is not supported for this script. "
  }
}


if { ![ info exists device_family ] } {
 set device_family $DEVICE_FAMILY
} else {
 puts "-- Accepted parameter \$device_family = $device_family"
}
    
if { ![ info exists device ] } {
 set device $DEVICE
} else {
 puts "-- Accepted parameter \$device = $device"
}
    
if { ![ info exists qsys_name ] } {
 set qsys_name $QSYS_NAME
} else {
 puts "-- Accepted parameter \$qsys_name = $qsys_name"
}
    
if { ![ info exists project_name ] } {
 set project_name $PROJECT_NAME
} else {
 puts "-- Accepted parameter \$project_name = $project_name"
}

if { ![ info exists top_name ] } {
 set top_name $TOP_NAME
} else {
 puts "-- Accepted parameter \$top_name = $top_name"
}

if { ![ info exists clk_gate_en ] } {
 set clk_gate_en $CLK_GATE_EN
} else {
 puts "-- Accepted parameter \$clk_gate_en = $clk_gate_en"
}

## ----------------
## Board
## ----------------

if { ![ info exists board ] } {
 set board $BOARD
} else {
 puts "-- Accepted parameter \$board = $board"
}

if { ![ info exists board_pwrmgt ] } {
 set board_pwrmgt $BOARD_PWRMGT
} else {
 puts "-- Accepted parameter \$board_pwrmgt = $board_pwrmgt"
}

# Loading Board default configuration settings
set board_config_file "./board/board_${board}_config.tcl"
if {[file exist $board_config_file]} {
    source $board_config_file
} else {
    error "Error: $board_config_file not exist!! Please make sure the board settings files are included in folder ./board/"
}

#qsys generate consume this arguments
if { ![ info exists fpga_peripheral_en ] } {
 set fpga_peripheral_en $FPGA_PERIPHERAL_EN
} else {
 puts "-- Accepted parameter \$fpga_peripheral_en = $fpga_peripheral_en"
}
if { $fpga_peripheral_en == 1} {
    if {[ info exists isPeriph_pins_available ] } {
        if { $isPeriph_pins_available == 0} {
            set fpga_peripheral_en 0
            puts "-- Turn OFF fpga_peripheral_en because \"isPeriph_pins_available\" is disable"
        }
    } else {
        set fpga_peripheral_en 0
        puts "-- Turn OFF fpga_peripheral_en because \"isPeriph_pins_available\" is not available"
    }
}

## ----------------
## OCM
## ----------------

if { ![ info exists jtag_ocm_en ] } {
 set jtag_ocm_en $JTAG_OCM_EN
} else {
 puts "-- Accepted parameter \$jtag_ocm_en = $jtag_ocm_en"
}

if { ![ info exists ocm_datawidth ] } {
 set ocm_datawidth $OCM_DATAWIDTH
} else {
 puts "-- Accepted parameter \$ocm_datawidth = $ocm_datawidth"
}

if { ![ info exists ocm_memsize ] } {
 set ocm_memsize $OCM_MEMSIZE
} else {
 puts "-- Accepted parameter \$ocm_memsize = $ocm_memsize"
}

## ----------------
## HPS
## ----------------

if { ![ info exists hps_emif_en ] } {
 set hps_emif_en $HPS_EMIF_EN
} else {
 puts "-- Accepted parameter \$hps_emif_en = $hps_emif_en"
}

if { ![ info exists hps_en ] } {
 set hps_en $HPS_EN
} else {
 puts "-- Accepted parameter \$hps_en = $hps_en"
}

if { ![ info exists sys_initialization ] } {
 set sys_initialization $SYS_INITIALIZATION
} else {
 puts "-- Accepted parameter \$sys_initialization = $sys_initialization"
}

if { ![ info exists hps_dap_mode ] } {
 set hps_dap_mode $HPS_DAP_MODE
} else {
 puts "-- Accepted parameter \$hps_dap_mode = $hps_dap_mode"
}

if { ![ info exists user0_clk_src_select ] } {
 set user0_clk_src_select $USER0_CLK_SRC_SELECT
} else {
 puts "-- Accepted parameter \$user0_clk_src_select = $user0_clk_src_select"
}

if { ![ info exists user0_clk_freq ] } {
 set user0_clk_freq $USER0_CLK_FREQ
} else {
 puts "-- Accepted parameter \$user0_clk_freq = $user0_clk_freq"
}

if { ![ info exists user1_clk_src_select ] } {
 set user1_clk_src_select $USER1_CLK_SRC_SELECT
} else {
 puts "-- Accepted parameter \$user1_clk_src_select = $user1_clk_src_select"
}

if { ![ info exists user1_clk_freq ] } {
 set user1_clk_freq $USER1_CLK_FREQ
} else {
 puts "-- Accepted parameter \$user1_clk_freq = $user1_clk_freq"
}

if { ![ info exists h2f_width ] } {
 set h2f_width $H2F_WIDTH
} else {
 puts "-- Accepted parameter \$h2f_width = $h2f_width"
}

if { ![ info exists f2s_data_width ] } {
 set f2s_data_width $F2S_DATA_WIDTH
} else {
 puts "-- Accepted parameter \$f2s_data_width = $f2s_data_width"
}

if { ![ info exists f2s_address_width ] } {
 set f2s_address_width $F2S_ADDRESS_WIDTH
} else {
 puts "-- Accepted parameter \$f2s_address_width = $f2s_address_width"
}

if { ![ info exists f2sdram_data_width ] } {
 set f2sdram_data_width $F2SDRAM_DATA_WIDTH
} else {
 puts "-- Accepted parameter \$f2sdram_data_width = $f2sdram_data_width"
}

if { ![ info exists f2sdram_address_width ] } {
 set f2sdram_address_width $F2SDRAM_ADDRESS_WIDTH
} else {
 puts "-- Accepted parameter \$f2sdram_address_width = $f2sdram_address_width"
}

if { ![ info exists f2h_width ] } {
 set f2h_width $F2H_WIDTH
} else {
 puts "-- Accepted parameter \$f2h_width = $f2h_width"
}

if { ![ info exists lwh2f_width ] } {
 set lwh2f_width $LWH2F_WIDTH
} else {
 puts "-- Accepted parameter \$lwh2f_width = $lwh2f_width"
}

if { ![ info exists h2f_addr_width ] } {
 set h2f_addr_width $H2F_ADDR_WIDTH
} else {
 puts "-- Accepted parameter \$h2f_addr_width = $h2f_addr_width"
}

if { ![ info exists f2h_addr_width ] } {
 set f2h_addr_width $F2H_ADDR_WIDTH
} else {
 puts "-- Accepted parameter \$f2h_addr_width = $f2h_addr_width"
}

if { ![ info exists lwh2f_addr_width ] } {
 set lwh2f_addr_width $LWH2F_ADDR_WIDTH
} else {
 puts "-- Accepted parameter \$lwh2f_addr_width = $lwh2f_addr_width"
}

if { ![ info exists h2f_clk_source ] } {
 set h2f_clk_source $H2F_CLK_SOURCE
} else {
 puts "-- Accepted parameter \$h2f_clk_source = $h2f_clk_source"
}

if { ![ info exists f2h_clk_source ] } {
 set f2h_clk_source $F2H_CLK_SOURCE
} else {
 puts "-- Accepted parameter \$f2h_clk_source = $f2h_clk_source"
}

if { ![ info exists lwh2f_clk_source ] } {
 set lwh2f_clk_source $LWH2F_CLK_SOURCE
} else {
 puts "-- Accepted parameter \$lwh2f_clk_source = $lwh2f_clk_source"
}

if { ![ info exists ocm_clk_source ] } {
 set ocm_clk_source $OCM_CLK_SOURCE
} else {
 puts "-- Accepted parameter \$ocm_clk_source = $ocm_clk_source"
}

if { ![ info exists secure_f2h_axi_slave ] } {
 set secure_f2h_axi_slave $SECURE_F2H_AXI_SLAVE
} else {
 puts "-- Accepted parameter \$secure_f2h_axi_slave = $secure_f2h_axi_slave"
}

if { ![ info exists hps_peri_irq_loopback_en ] } {
 set hps_peri_irq_loopback_en $HPS_PERI_IRQ_LOOPBACK_EN
} else {
 puts "-- Accepted parameter \$hps_peri_irq_loopback_en = $hps_peri_irq_loopback_en"
}

if { ![ info exists hps_f2s_irq_en ] } {
 set hps_f2s_irq_en $HPS_F2S_IRQ_EN
} else {
 puts "-- Accepted parameter \$hps_f2s_irq_en = $hps_f2s_irq_en"
}

if { ![ info exists daughter_card ] } {
 set daughter_card $DAUGHTER_CARD
} else {
 puts "-- Accepted parameter \$daughter_card = $daughter_card"
 if {$hps_en == 0 && $daughter_card != "none"} {
   set hps_en 1
   puts "Solver INFO: Since \$daughter_card has selected, \$hps-en is enabled by default"
 }
}

if { ![ info exists cross_trigger_en ] } {
 set cross_trigger_en $CROSS_TRIGGER_EN
} else {
 puts "-- Accepted parameter \$cross_trigger_en = $cross_trigger_en"
}

if { ![ info exists hps_stm_en ] } {
 set hps_stm_en $HPS_STM_EN
} else {
 puts "-- Accepted parameter \$hps_stm_en = $hps_stm_en"
}

if { ![ info exists ftrace_en ] } {
 set ftrace_en $FTRACE_EN
} else {
 puts "-- Accepted parameter \$ftrace_en = $ftrace_en"
}

if { ![ info exists ftrace_output_width ] } {
 set ftrace_output_width $FTRACE_OUTPUT_WIDTH
} else {
 puts "-- Accepted parameter \$ftrace_output_width = $ftrace_output_width"
}

if { ![ info exists hps_pll_source_export ] } {
 set hps_pll_source_export $HPS_PLL_SOURCE_EXPORT
} else {
 puts "-- Accepted parameter \$hps_pll_source_export = $hps_pll_source_export"
}

if { ![ info exists reset_watchdog_en ] } {
 set reset_watchdog_en $RESET_WATCHDOG_EN
} else {
 puts "-- Accepted parameter \$reset_watchdog_en = $reset_watchdog_en"
}

if { ![ info exists reset_hps_warm_en ] } {
 set reset_hps_warm_en $RESET_HPS_WARM_EN
} else {
 puts "-- Accepted parameter \$reset_hps_warm_en = $reset_hps_warm_en"
}

if { ![ info exists reset_h2f_cold_en ] } {
 set reset_h2f_cold_en $RESET_H2F_COLD_EN
} else {
 puts "-- Accepted parameter \$reset_h2f_cold_en = $reset_h2f_cold_en"
}

if { ![ info exists reset_sdm_watchdog_cfg ] } {
 set reset_sdm_watchdog_cfg $RESET_SDM_WATCHDOG_CFG
} else {
 puts "-- Accepted parameter \$reset_sdm_watchdog_cfg = $reset_sdm_watchdog_cfg"
}

# ----------------
# Parameter Auto Derivation
# ----------------

# Default option
set hps_io_off 0

if {$hps_en == 1} {
puts "Solver INFO: hps ENABLED"
} else {
puts "Solver INFO: NO hps"
}

if {$board == "char"} {
puts "Warning: Overriding Settings for Char BOARD"
set user0_clk_src_select 1
set fpga_peripheral_en 0
}

# for cct_adapter
if {$f2s_address_width > 32 && $f2sdram_data_width > 0} {
    set cct_en 1
    set cct_control_interface 2
} else {
    set cct_en 0
}

source ./agilex_hps_pinmux_solver.tcl
source ./agilex_hps_parameter_solver.tcl
source ./agilex_hps_io48_delay_chain_solver.tcl

# Was thinking to enable single TCL entry for flow of TOP RTL, qsys, quartus generation. Ideal still pending implementation
# exec quartus_sh --script=create_ghrd_quartus.tcl $top_quartus_arg
# exec qsys-script --script=create_ghrd_qsys.tcl --quartus-project=$project_name.qpf --cmd="$qsys_arg"
