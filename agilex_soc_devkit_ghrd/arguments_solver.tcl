#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2021 Intel Corporation.
#
#****************************************************************************
#
# This file resolves all passed in arguments into GHRD understood parameterizable setting

# Following are list of arguments supported and its valid values
# project_name                      : <name your quartus project>
# qsys_name                         : <name your qsys top>
# top_name                          : <top RTL module name of Quartus project>
# device_family                     : <FPGA device family>
# device                            : <FPGA device part number>
# clk_gate_en                       : enable gated system clock with ninit_done. 1 or 0
# board                             : devkit, mUDV2, mUDV1, char, cypress, hemon, lookout, mcgowan, pyramid
# board_pwrmgt                      : enpirion, linear; Only valid for board="devkit"
# board_rev                         : A1 or A0
# daughter_card                     : Daughter card selection, either "none"
# config_scheme                     : "ACTIVE SERIAL X4", "AVST X8", "AVST X16", "AVST X32"
# device_initialization_clock       : "INIT_INTOSC", "OSC_CLK_1_125MHZ", "OSC_CLK_1_100MHZ", "OSC_CLK_1_25MHZ"
# fpga_peripheral_en                : Enable PIO for LEDs, DIPSW and Pushbutton. 1 or 0
# fpga_sgpio_en                     : Enable SGPIO for SGPIO. 1 or 0
# niosv_subsys_en                   : Enable Nios V subsystem. 1 or 0
# jtag_ocm_en                       : Enable JTAG Masters and OnChipMemory. 1 or 0
# ocm_datawidth                     : 32, 64, 128, 256
# ocm_memsize                       : 262144.0 (Default), 8388608.0 (PCIE OCM Boot)
# hps_emif_en                       : 1 or 0
# hps_emif_mem_part                 : default_part or custom or termination_sweep
# hps_emif_type                     : ddr3 or ddr4
# hps_emif_rate                     : RATE_HALF or RATE_QUARTER
# hps_emif_ref_clk_freq_mhz         : <Frequency in MHz>
# hps_emif_mem_clk_freq_mhz         : <Frequency in MHz>
# hps_emif_width                    : 16, 32, 64 (irrespective of ECC)
# hps_emif_ecc_en                   : 1 or 0 
# hps_emif_comp_preset              : "DDR4-3200AA CL22 Component 1CS 8Gb (512Mb x16)"
# hps_emif_mem_format               : MEM_FORMAT_DISCRETE
# hps_emif_tcl                      : <DDR's TCL> 
# hps_emif_wtcl                     : <DDR's WTCL> 
# hps_emif_bank_addr_width          : <DDR's Bank Width> 
# hps_emif_bank_gp_width            : <DDR's Bank Group Width> 
# hps_emif_num_dimms                : <DDR's number of DIMMS> 
# hps_emif_ranks_per_dimm           : <DDR's ranks per DIMM> 
# hps_emif_rtt_wr_enum              : DDR4_RTT_WR_ODT_DISABLED
# hps_emif_drv_str_enum             : DDR4_DRV_STR_RZQ_7
# hps_emif_rtt_nom_enum             : DDR4_RTT_NOM_ODT_DISABLED
# hps_emif_rtt_park                 : "DDR4_RTT_PARK_RZQ_4"
# hps_emif_use_default_odt          : "false"
# hps_emif_r_odt0_1x1               : "off"
# hps_emif_w_odt0_1x1               : "off"
# hps_emif_ac_io_std_enum           : IO_STD_SSTL_12
# hps_emif_ck_io_std_enum           : IO_STD_SSTL_12
# hps_emif_data_io_std_enum         : IO_STD_SSTL_12
# hps_emif_ac_mode_enum             : OUT_OCT_40_CAL
# hps_emif_ck_mode_enum             : OUT_OCT_40_CAL
# hps_emif_data_out_mode_enum       : OUT_OCT_34_CAL
# hps_emif_data_in_mode_enum        : IN_OCT_60_CAL
# hps_emif_ref_clk_io_std_enum      : IO_STD_TRUE_DIFF_SIGNALING
# hps_emif_rzq_io_std_enum          : IO_STD_CMOS_12
# hps_emif_extra_configs            :
# hps_emif_export_seq_avalon_slave  : CAL_DEBUG_EXPORT_MODE_DISABLED or CAL_DEBUG_EXPORT_MODE_EXPORT or CAL_DEBUG_EXPORT_MODE_JTAG
# hps_emif_jtag_uart_en             : true or false
# hps_emif_diag_soft_nios_mode      : SOFT_NIOS_MODE_DISABLED
# hps_emif_diag_hmc_hrc             : "OFF"
# fpga_emif_en                      : 1 or 0
# fpga_emif_width                   : 16, 32, 64 (irrespective of ECC)
# fpga_emif_ecc_en                  : 1 or 0 
# hps_en                            : 1 or 0
# sys_initialization                : HPS initialization sequence. HPS_FIRST or FPGA_FIRST
# hps_dap_mode                      : HPS debug split mode. 2(SDM Pins),1(HPS Pins),0(disabled)
# h2f_user0_clk_en                  : 1 or 0    (When enable, h2f_user0_clk will replace fpga_clk_100 as system_clk)
# h2f_user1_clk_en                  : 1 or 0    (For LWH2F, H2F and F2H Ussage)
# h2f_user1_freq                    : Default 100. Any frequency supported by HPS Clocking
# h2f_width                         : 512, 256, 128, 64, 32 or 0(as disable)
# f2h_width                         : 512, 256, 128 or 0(as disable)
# lwh2f_width                       : 32 or 0(as disable)
# h2f_addr_width                    : 32 or 21
# f2h_addr_width                    : 32 or 21
# lwh2f_addr_width                  : 21
# f2h_clk_source                    : 0 (System_100MHz), 1(h2f_user1_clock)
# h2f_clk_source                    : 0 (System_100MHz), 1 (h2f_user1_clock)
# lwh2f_clk_source                  : 0 (System_100MHz), 1 (h2f_user1_clock)
# ocm_clk_source                    : 0 (System_100MHz), 1 (h2f_user1_clock)
# secure_f2h_axi_slave              : 0 (non-secure), 1(secure)
# h2f_f2h_loopback_en               : 1 or 0 
# h2f_f2h_loopback_cct_en           : 1 or 0
# lwh2f_f2h_loopback_en             : 1 or 0
# gpio_loopback_en                  : 1 or 0
# hps_peri_irq_loopback_en          : 1 or 0
# hps_f2s_irq_en                    : 1 or 0
# cross_trigger_en                  : 1 or 0
# hps_stm_en                        : 1 or 0
# ftrace_en                         : 1 or 0
# ftrace_output_width               : 16 or 32
# hps_pll_source_export             : 1 or 0
# watchdog_rst_en                   : 1 or 0
# watchdog_rst_act                  : 0, 1 or 2
# fpga_pcie                         : 1 or 0
# pcie_gen                          : 3
# pcie_count                        : 4
# pcie_hptxs                        : 1 or 0
# hps_sgmii_emac1_en                : 1 or 0
# hps_sgmii_emac2_en                : 1 or 0
# jop_en                            : 1 or 0
# hps_etile_1588_en                 : 1 or 0
# hps_etile_1588_count              : 1
# hps_etile_1588_25gbe_en           : 1 or 0
# hps_etile_1588_10gbe_en           : 1 or 0

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

if { ![ info exists board_rev ] } {
 set board_rev $BOARD_REV
} else {
 puts "-- Accepted parameter \$board_rev = $board_rev"
}

if { ![ info exists config_scheme ] } {
 set config_scheme "$CONFIG_SCHEME"
} else {
 puts "-- Accepted parameter \$config_scheme = $config_scheme"
}

if { ![ info exists device_initialization_clock ] } {
 set device_initialization_clock "$DEVICE_INITIALIZATION_CLOCK"
} else {
 puts "-- Accepted parameter \$device_initialization_clock = $device_initialization_clock"
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

#qsys generate consume this arguments
if { ![ info exists fpga_sgpio_en ] } {
 set fpga_sgpio_en $FPGA_SGPIO_EN
} else {
 puts "-- Accepted parameter \$fpga_sgpio_en = $fpga_sgpio_en"
}
if { $fpga_sgpio_en == 1} {
    if {[ info exists isSgpio_pins_available ] } {
        if { $isSgpio_pins_available == 0} {
            set fpga_sgpio_en 0
            puts "-- Turn OFF fpga_sgpio_en because \"isSgpio_pins_available\" is disable"
        }
    } else {
        set fpga_sgpio_en 0
        puts "-- Turn OFF fpga_sgpio_en because \"isSgpio_pins_available\" is not available"
    }
}

if { ![ info exists niosv_subsys_en ] } {
 set niosv_subsys_en $NIOSV_SUBSYS_EN
} else {
 puts "-- Accepted parameter \$niosv_subsys_en = $niosv_subsys_en"
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
## HPS EMIF
## ----------------


if { ![ info exists hps_emif_en ] } {
 set hps_emif_en $HPS_EMIF_EN
} else {
 puts "-- Accepted parameter \$hps_emif_en = $hps_emif_en"
}

if { ![ info exists hps_emif_mem_part ] } {
 set hps_emif_mem_part $HPS_EMIF_MEM_PART
} else {
 puts "-- Accepted parameter \$hps_emif_mem_part = $hps_emif_mem_part"
}

if { ![ info exists hps_emif_type ] } {
 set hps_emif_type $HPS_EMIF_TYPE
} else {
 puts "-- Accepted parameter \$hps_emif_type = $hps_emif_type"
}

if { ![ info exists hps_emif_rate] } {
 set hps_emif_rate $HPS_EMIF_RATE
} else {
 puts "-- Accepted parameter \$hps_emif_rate = $hps_emif_rate"
}

if { ![ info exists hps_emif_ref_clk_freq_mhz] } {
 set hps_emif_ref_clk_freq_mhz $HPS_EMIF_REF_CLK_FREQ_MHZ
} else {
 puts "-- Accepted parameter \$hps_emif_ref_clk_freq_mhz = $hps_emif_ref_clk_freq_mhz"
}

if { ![ info exists hps_emif_mem_clk_freq_mhz] } {
 set hps_emif_mem_clk_freq_mhz $HPS_EMIF_MEM_CLK_FREQ_MHZ
} else {
 puts "-- Accepted parameter \$hps_emif_mem_clk_freq_mhz = $hps_emif_mem_clk_freq_mhz"
}

if { ![ info exists hps_emif_width] } {
 set hps_emif_width $HPS_EMIF_WIDTH
} else {
 puts "-- Accepted parameter \$hps_emif_width = $hps_emif_width"
}

if { ![ info exists hps_emif_ecc_en ] } {
 set hps_emif_ecc_en $HPS_EMIF_ECC_EN
} else {
 puts "-- Accepted parameter \$hps_emif_ecc_en = $hps_emif_ecc_en"
}

if { ![ info exists hps_emif_comp_preset ] } {
 set hps_emif_comp_preset $HPS_EMIF_COMP_PRESET
} else {
 puts "-- Accepted parameter \$hps_emif_comp_preset = $hps_emif_comp_preset"
}

if { ![ info exists hps_emif_mem_format ] } {
 set hps_emif_mem_format $HPS_EMIF_MEM_FORMAT
} else {
 puts "-- Accepted parameter \$hps_emif_mem_format = $hps_emif_mem_format"
}

if { ![ info exists hps_emif_tcl ] } {
 set hps_emif_tcl $HPS_EMIF_TCL
} else {
 puts "-- Accepted parameter \$hps_emif_tcl = $hps_emif_tcl"
}

if { ![ info exists hps_emif_wtcl ] } {
 set hps_emif_wtcl $HPS_EMIF_WTCL
} else {
 puts "-- Accepted parameter \$hps_emif_wtcl = $hps_emif_wtcl"
}

if { ![ info exists hps_emif_bank_gp_width ] } {
 set hps_emif_bank_gp_width $HPS_EMIF_BANK_GP_WIDTH
} else {
 puts "-- Accepted parameter \$hps_emif_bank_gp_width = $hps_emif_bank_gp_width"
}
if {$HPS_EMIF_MEM_PART == "default_part"} {
    set hps_emif_bank_gp_width $hps_emif_bank_gp_default_width
    puts "-- Overriding to board_${board}_config.tcl hps_emif_bank_gp_default_width"
}

if { ![ info exists hps_emif_bank_addr_width ] } {
 set hps_emif_bank_addr_width $HPS_EMIF_BANK_ADDR_WIDTH
} else {
 puts "-- Accepted parameter \$hps_emif_bank_addr_width = $hps_emif_bank_addr_width"
}

if { ![ info exists hps_emif_num_dimms] } {
 set hps_emif_num_dimms $HPS_EMIF_NUM_DIMMS
} else {
 puts "-- Accepted parameter \$hps_emif_num_dimms= $hps_emif_num_dimms"
}

if { ![ info exists hps_emif_ranks_per_dimm ] } {
 set hps_emif_ranks_per_dimm $HPS_EMIF_RANKS_PER_DIMM
} else {
 puts "-- Accepted parameter \$hps_emif_ranks_per_dimm = $hps_emif_ranks_per_dimm"
}

if { ![ info exists hps_emif_rtt_wr_enum ] } {
 set hps_emif_rtt_wr_enum $HPS_EMIF_RTT_WR_ENUM
} else {
 puts "-- Accepted parameter \$hps_emif_rtt_wr_enum = $hps_emif_rtt_wr_enum"
}

if { ![ info exists hps_emif_drv_str_enum ] } {
 set hps_emif_drv_str_enum $HPS_EMIF_DRV_STR_ENUM
} else {
 puts "-- Accepted parameter \$hps_emif_drv_str_enum = $hps_emif_drv_str_enum"
}

if { ![ info exists hps_emif_rtt_nom_enum ] } {
 set hps_emif_rtt_nom_enum $HPS_EMIF_RTT_NOM_ENUM
} else {
 puts "-- Accepted parameter \$hps_emif_rtt_nom_enum = $hps_emif_rtt_nom_enum"
}

if { ![ info exists hps_emif_rtt_park ] } {
 set hps_emif_rtt_park $HPS_EMIF_RTT_PARK
} else {
 puts "-- Accepted parameter \$hps_emif_rtt_park = $hps_emif_rtt_park"
}

if { ![ info exists hps_emif_use_default_odt ] } {
 set hps_emif_use_default_odt $HPS_EMIF_USE_DEFAULT_ODT
} else {
 puts "-- Accepted parameter \$hps_emif_use_default_odt = $hps_emif_use_default_odt"
}

if { ![ info exists hps_emif_r_odt0_1x1 ] } {
 set hps_emif_r_odt0_1x1 $HPS_EMIF_R_ODT0_1X1
} else {
 puts "-- Accepted parameter \$hps_emif_r_odt0_1x1 = $hps_emif_r_odt0_1x1"
}

if { ![ info exists hps_emif_w_odt0_1x1 ] } {
 set hps_emif_w_odt0_1x1 $HPS_EMIF_W_ODT0_1X1
} else {
 puts "-- Accepted parameter \$hps_emif_w_odt0_1x1 = $hps_emif_w_odt0_1x1"
}


if { ![ info exists hps_emif_ac_io_std_enum ] } {
 set hps_emif_ac_io_std_enum $HPS_EMIF_AC_IO_STD_ENUM
} else {
 puts "-- Accepted parameter \$hps_emif_ac_io_std_enum = $hps_emif_ac_io_std_enum"
}

if { ![ info exists hps_emif_ck_io_std_enum ] } {
 set hps_emif_ck_io_std_enum $HPS_EMIF_CK_IO_STD_ENUM
} else {
 puts "-- Accepted parameter \$hps_emif_ck_io_std_enum = $hps_emif_ck_io_std_enum"
}

if { ![ info exists hps_emif_data_io_std_enum ] } {
 set hps_emif_data_io_std_enum $HPS_EMIF_DATA_IO_STD_ENUM
} else {
 puts "-- Accepted parameter \$hps_emif_data_io_std_enum = $hps_emif_data_io_std_enum"
}

if { ![ info exists hps_emif_ac_mode_enum ] } {
 set hps_emif_ac_mode_enum $HPS_EMIF_AC_MODE_ENUM
} else {
 puts "-- Accepted parameter \$hps_emif_ac_mode_enum = $hps_emif_ac_mode_enum"
}

if { ![ info exists hps_emif_ck_mode_enum ] } {
 set hps_emif_ck_mode_enum $HPS_EMIF_CK_MODE_ENUM
} else {
 puts "-- Accepted parameter \$hps_emif_ck_mode_enum = $hps_emif_ck_mode_enum"
}

if { ![ info exists hps_emif_data_out_mode_enum ] } {
 set hps_emif_data_out_mode_enum $HPS_EMIF_DATA_OUT_MODE_ENUM
} else {
 puts "-- Accepted parameter \$hps_emif_data_out_mode_enum = $hps_emif_data_out_mode_enum"
}

if { ![ info exists hps_emif_data_in_mode_enum ] } {
 set hps_emif_data_in_mode_enum $HPS_EMIF_DATA_IN_MODE_ENUM
} else {
 puts "-- Accepted parameter \$hps_emif_data_in_mode_enum = $hps_emif_data_in_mode_enum"
}

if { ![ info exists hps_emif_ref_clk_io_std_enum ] } {
 set hps_emif_ref_clk_io_std_enum $HPS_EMIF_REF_CLK_IO_STD_ENUM
} else {
 puts "-- Accepted parameter \$hps_emif_ref_clk_io_std_enum = $hps_emif_ref_clk_io_std_enum"
}

if { ![ info exists hps_emif_rzq_io_std_enum ] } {
 set hps_emif_rzq_io_std_enum $HPS_EMIF_RZQ_IO_STD_ENUM
} else {
 puts "-- Accepted parameter \$hps_emif_rzq_io_std_enum = $hps_emif_rzq_io_std_enum"
}

if { ![ info exists hps_emif_extra_configs ] } {
 set hps_emif_extra_configs $HPS_EMIF_EXTRA_CONFIGS
} else {
 puts "-- Accepted parameter \$hps_emif_extra_configs = $hps_emif_extra_configs"
}

if { ![ info exists hps_emif_export_seq_avalon_slave ] } {
 set hps_emif_export_seq_avalon_slave $HPS_EMIF_EXPORT_SEQ_AVALON_SLAVE
} else {
 puts "-- Accepted parameter \$hps_emif_export_seq_avalon_slave = $hps_emif_export_seq_avalon_slave"
}

if { ![ info exists hps_emif_jtag_uart_en ] } {
 set hps_emif_jtag_uart_en $HPS_EMIF_JTAG_UART_EN
} else {
 puts "-- Accepted parameter \$hps_emif_jtag_uart_en = $hps_emif_jtag_uart_en"
}

if { ![ info exists hps_emif_diag_soft_nios_mode ] } {
 set hps_emif_diag_soft_nios_mode $HPS_EMIF_DIAG_SOFT_NIOS_MODE
} else {
 puts "-- Accepted parameter \$hps_emif_diag_soft_nios_mode = $hps_emif_diag_soft_nios_mode"
}

## ----------------
## FPGA EMIF
## ----------------

if { ![ info exists fpga_emif_en ] } {
 set fpga_emif_en $FPGA_EMIF_EN
} else {
 puts "-- Accepted parameter \$fpga_emif_en = $fpga_emif_en"
}

if { ![ info exists fpga_emif_width] } {
 set fpga_emif_width $FPGA_EMIF_WIDTH
} else {
 puts "-- Accepted parameter \$fpga_emif_width = $fpga_emif_width"
}

if { ![ info exists fpga_emif_ecc_en ] } {
 set fpga_emif_ecc_en $FPGA_EMIF_ECC_EN
} else {
 puts "-- Accepted parameter \$fpga_emif_ecc_en = $fpga_emif_ecc_en"
}

## ----------------
## HPS
## ----------------

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

if { ![ info exists h2f_user0_clk_en ] } {
 set h2f_user0_clk_en $H2F_USER0_CLK_EN
} else {
 puts "-- Accepted parameter \$h2f_user0_clk_en = $h2f_user0_clk_en"
}

if { ![ info exists h2f_user1_clk_en ] } {
 set h2f_user1_clk_en $H2F_USER1_CLK_EN
} else {
 puts "-- Accepted parameter \$h2f_user1_clk_en = $h2f_user1_clk_en"
}

if { ![ info exists h2f_user1_freq ] } {
 set h2f_user1_freq $H2F_USER1_FREQ
} else {
 puts "-- Accepted parameter \$h2f_user1_freq = $h2f_user1_freq"
}

if { ![ info exists h2f_width ] } {
 set h2f_width $H2F_WIDTH
} else {
 puts "-- Accepted parameter \$h2f_width = $h2f_width"
}

if { ![ info exists h2f_addr_width ] } {
 set h2f_addr_width $H2F_ADDR_WIDTH
} else {
 puts "-- Accepted parameter \$h2f_addr_width = $h2f_addr_width"
}

if { ![ info exists h2f_clk_source ] } {
 set h2f_clk_source $H2F_CLK_SOURCE
} else {
 puts "-- Accepted parameter \$h2f_clk_source = $h2f_clk_source"
}

if { ![ info exists f2h_width ] } {
 set f2h_width $F2H_WIDTH
} else {
 puts "-- Accepted parameter \$f2h_width = $f2h_width"
}

if { ![ info exists f2h_addr_width ] } {
 set f2h_addr_width $F2H_ADDR_WIDTH
} else {
 puts "-- Accepted parameter \$f2h_addr_width = $f2h_addr_width"
}

if { ![ info exists f2h_clk_source ] } {
 set f2h_clk_source $F2H_CLK_SOURCE
} else {
 puts "-- Accepted parameter \$f2h_clk_source = $f2h_clk_source"
}

if { ![ info exists lwh2f_width ] } {
 set lwh2f_width $LWH2F_WIDTH
} else {
 puts "-- Accepted parameter \$lwh2f_width = $lwh2f_width"
}

if { ![ info exists lwh2f_addr_width ] } {
 set lwh2f_addr_width $LWH2F_ADDR_WIDTH
} else {
 puts "-- Accepted parameter \$lwh2f_addr_width = $lwh2f_addr_width"
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

if { ![ info exists h2f_f2h_loopback_en ] } {
 set h2f_f2h_loopback_en $H2F_F2H_LOOPBACK_EN
} else {
 puts "-- Accepted parameter \$h2f_f2h_loopback_en = $h2f_f2h_loopback_en"
}

if { ![ info exists h2f_f2h_loopback_cct_en ] } {
 set h2f_f2h_loopback_cct_en $H2F_F2H_LOOPBACK_CCT_EN
} else {
 puts "-- Accepted parameter \$h2f_f2h_loopback_cct_en = $h2f_f2h_loopback_cct_en"
}

if { ![ info exists lwh2f_f2h_loopback_en ] } {
 set lwh2f_f2h_loopback_en $LWH2F_F2H_LOOPBACK_EN
} else {
 puts "-- Accepted parameter \$lwh2f_f2h_loopback_en = $lwh2f_f2h_loopback_en"
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

if { ![ info exists gpio_loopback_en ] } {
 set gpio_loopback_en $GPIO_LOOPBACK_EN
} else {
 puts "-- Accepted parameter \$gpio_loopback_en = $gpio_loopback_en"
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

if { ![ info exists watchdog_rst_en ] } {
 set watchdog_rst_en $WATCHDOG_RST_EN
} else {
 puts "-- Accepted parameter \$watchdog_rst_en = $watchdog_rst_en"
}

if { ![ info exists watchdog_rst_act ] } {
 set watchdog_rst_act $WATCHDOG_RST_ACT
} else {
 puts "-- Accepted parameter \$watchdog_rst_act = $watchdog_rst_act"
}

## ----------------
## PCIE
## ----------------

if { ![ info exists fpga_pcie ] } {
 set fpga_pcie $PCIE_EN
} else {
 puts "-- Accepted parameter \$fpga_pcie = $fpga_pcie"
}
if { $fpga_pcie == 1} {
    if {[ info exists isPCIE_pins_available ] } {
        if { $isPCIE_pins_available == 0} {
            set fpga_pcie 0
            puts "-- Turn OFF fpga_pcie because \"isPCIE_pins_available\" is disable"
        }
    } else {
        set fpga_pcie 0
        puts "-- Turn OFF fpga_pcie because \"isPCIE_pins_available\" is not available"
    }
}

if { ![ info exists pcie_gen ] } {
 set pcie_gen $GEN_SEL
} else {
 puts "-- Accepted parameter \$pcie_gen = $pcie_gen"
}

if { ![ info exists pcie_count ] } {
 set pcie_count $PCIE_COUNT
} else {
 puts "-- Accepted parameter \$pcie_count = $pcie_count"
}

if { ![ info exists pcie_hptxs ] } {
 set pcie_hptxs $PCIE_HPTXS
} else {
 puts "-- Accepted parameter \$pcie_hptxs = $pcie_hptxs"
}

## ----------------
## Partial Reconfiguration
## ----------------

if { ![ info exists pr_enable ] } {
 set pr_enable $PR_ENABLE
} else {
 puts "-- Accepted parameter \$pr_enable = $pr_enable"
}

if { ![ info exists pr_region_count ] } {
 set pr_region_count $PR_REGION_COUNT
} else {
 puts "-- Accepted parameter \$pr_region_count = $pr_region_count"
}

if { ![ info exists pr_persona ] } {
  set pr_persona $PR_PERSONA
} else {
  puts "-- Accepted parameter \$pr_persona = $pr_persona"
}

if { ![ info exists pr_region_id_switch ] } {
  set pr_region_id_switch 0
} else {
  puts "-- Accepted parameter \$pr_region_id_switch = $pr_region_id_switch"
}   

if { ![ info exists sub_qsys_pr ] } {
  set sub_qsys_pr pr_region
} else {
  puts "-- Accepted parameter \$sub_qsys_pr = $sub_qsys_pr"
}

if { ![ info exists freeze_ack_dly_enable ] } {
  set freeze_ack_dly_enable $FREEZE_ACK_DELAY_ENABLE
} else {
  puts "-- Accepted parameter \$freeze_ack_dly_enable = $freeze_ack_dly_enable"
}

if { ![ info exists pr_ip_enable ] } {
  set pr_ip_enable $PARTIAL_RECONFIGURATION_CORE_IP
} else {
  puts "-- Accepted parameter \$pr_ip_enable = $pr_ip_enable"
}

if { ![ info exists pr_x_origin ] } {
  set pr_x_origin $PR_X_ORIGIN
} else {
  puts "-- Accepted parameter \$pr_x_origin = $pr_x_origin"
}

if { ![ info exists pr_y_origin ] } {
  set pr_y_origin $PR_Y_ORIGIN
} else {
  puts "-- Accepted parameter \$pr_y_origin = $pr_y_origin"
}

if { ![ info exists pr_width ] } {
  set pr_width $PR_WIDTH
} else {
  puts "-- Accepted parameter \$pr_width = $pr_width"
}

if { ![ info exists pr_height ] } {
  set pr_height $PR_HEIGHT
} else {
  puts "-- Accepted parameter \$pr_height = $pr_height"
}

if { ![ info exists pr_region_name ] } {
  set pr_region_name $PR_REGION_NAME
} else {
  puts "-- Accepted parameter \$pr_region_name = $pr_region_name"
}

## ----------------
## SGMII (HPS EMAC + TSE PHY (SGMII))
## ----------------
if { ![ info exists hps_sgmii_emac1_en ] } {
  set hps_sgmii_emac1_en $SGMII_EMAC1_ENABLE
} else {
  puts "-- Accepted parameter \$hps_sgmii_emac1_en = $hps_sgmii_emac1_en"
}

if { ![ info exists hps_sgmii_emac2_en ] } {
  set hps_sgmii_emac2_en $SGMII_EMAC2_ENABLE
} else {
  puts "-- Accepted parameter \$hps_sgmii_emac2_en = $hps_sgmii_emac2_en"
}
# derive argument for operation of script
if {$hps_sgmii_emac1_en == 1 || $hps_sgmii_emac2_en == 1} {
    set hps_sgmii_en 1
    
if {$hps_sgmii_emac1_en == 1} {
  set hps_sgmii_emac_start_node 1
} else {
  set hps_sgmii_emac_start_node 2
}
if {$hps_sgmii_emac2_en == 1} {
  set hps_sgmii_emac_end_node 2
} else {
  set hps_sgmii_emac_end_node 1
}
} else {
    set hps_sgmii_en 0
    set hps_sgmii_emac_start_node 0
    set hps_sgmii_emac_end_node 0
}

## ----------------
## JOP
## ----------------
if { ![ info exists jop_en ] } {
  set jop_en $JOP_EN
} else {
  puts "-- Accepted parameter \$jop_en = $jop_en"
}

## ----------------
## Etile 25GbE
## ----------------

if { ![ info exists hps_etile_1588_en ] } {
 set hps_etile_1588_en $HPS_ETILE_1588_EN
} else {
 puts "-- Accepted parameter \$hps_etile_1588_en = $hps_etile_1588_en"
}

if { $hps_etile_1588_en == 1} {
    if {[ info exists isETILE_pins_available ] } {
        if { $isETILE_pins_available == 0} {
            set hps_etile_1588_en 0
            puts "-- Turn OFF hps_etile_1588_en because \"isETILE_pins_available\" is disable"
        }
    } else {
        set hps_etile_1588_en 0
        puts "-- Turn OFF hps_etile_1588_en because \"isETILE_pins_available\" is not available"
    }
}
if { ![ info exists hps_etile_1588_25gbe_en ] } {
 set hps_etile_1588_25gbe_en $HPS_ETILE_1588_25GBE_EN
} else {
 puts "-- Accepted parameter \$hps_etile_1588_25gbe_en = $hps_etile_1588_25gbe_en"
}

if { ![ info exists hps_etile_1588_10gbe_en ] } {
 set hps_etile_1588_10gbe_en $HPS_ETILE_1588_10GBE_EN
} else {
 puts "-- Accepted parameter \$hps_etile_1588_10gbe_en = $hps_etile_1588_10gbe_en"
}
if { ![ info exists hps_etile_1588_count ] } {
 set hps_etile_1588_count $HPS_ETILE_1588_COUNT
} else {
 puts "-- Accepted parameter \$hps_etile_1588_count = $hps_etile_1588_count"
}

## ----------------
## Parameter Auto Derivation
## ----------------

# Default option
set hps_io_off 0

if {$hps_en == 1} {
puts "Solver INFO: hps ENABLED"
} else {
puts "Solver INFO: NO hps"
}

if {$board == "char"} {
puts "Warning: Overriding Settings for Char BOARD"
set h2f_user0_clk_en 1
set fpga_peripheral_en 0
}

# for cct_adapter
if {$hps_etile_1588_en == 1 || $fpga_pcie == 1 || ($h2f_f2h_loopback_cct_en == 1 && $h2f_f2h_loopback_en == 1)} {
    set cct_en 1
    set cct_control_interface 0
} else {
    set cct_en 0
}

source ./agilex_hps_pinmux_solver.tcl
source ./agilex_hps_parameter_solver.tcl
source ./agilex_hps_io48_delay_chain_solver.tcl

#Parameter Overriding
if { $hps_etile_1588_en == 1 || $fpga_pcie == 1} {
   puts "Overriding f2h_addr_width to 34"
   set f2h_addr_width 34
}
# Was thinking to enable single TCL entry for flow of TOP RTL, qsys, quartus generation. Ideal still pending implementation
# exec quartus_sh --script=create_ghrd_quartus.tcl $top_quartus_arg
# exec qsys-script --script=create_ghrd_qsys.tcl --quartus-project=$project_name.qpf --cmd="$qsys_arg"
