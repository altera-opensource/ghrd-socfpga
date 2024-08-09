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
# initialization_first                : HPS initialization sequence. HPS_FIRST or FPGA_FIRST
# hps_dap_mode                      : HPS debug split mode. 2(SDM Pins),1(HPS Pins),0(disabled)
# user0_clk_src_select              : 7-PeriphC3 or 1-MainC1 (Select H2F User0 clock source)
# user0_clk_freq                    : Default 500.Specify desired frequency for H2F User0 clock
# user1_clk_src_select              : 7-PeriphC3 or 1-MainC1 (Select H2F User1 clock source)
# user1_clk_freq                    : Default 500. Specify desired frequency for H2F User1 clock
# h2f_width                         : 128, 64, 32 or 0(as disable)
# f2h_width                         : 256 or 0(as disable)
# f2s_data_width                    : 0:Unused, 256-bit"}
# f2s_address_width                 : {40-bit 1TB,39-bit 512GB,38-bit 256GB,37-bit 128GB,36-bit 64GB,35-bit 32GB,34-bit 16GB,33-bit 8GB,32-bit 4GB,31-bit 2GB,30-bit 1GB,29-bit 512 MB,28-bit 256 MB,27-bit 128 MB,26-bit 64 MB,25-bit 32 MB,24-bit 16 MB,23-bit 8 MB,22-bit 4 MB,21-bit 2 MB,20-bit 1 MB}     		
# f2sdram_width                : 0:Unused, 256-bit"}
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

source ${prjroot}/design_config.tcl 

# proc check_then_accept { param } {
  # if {$param == device_family || device || qsys_name || project_name} {
    # puts "-- Accepted paramter \$param = $param"
  # } else {
    # puts "Warning: Inserted parameter \"$param\" is not supported for this script. "
  # }
# }


# if { ![ info exists device_family ] } {
 # set device_family $DEVICE_FAMILY
# } else {
 # puts "-- Accepted parameter \$device_family = $device_family"
# }
    
# if { ![ info exists device ] } {
 # set device $DEVICE
# } else {
 # puts "-- Accepted parameter \$device = $device"
# }
    
# if { ![ info exists qsys_name ] } {
 # set qsys_name $QSYS_NAME
# } else {
 # puts "-- Accepted parameter \$qsys_name = $qsys_name"
# }
    
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
set board_config_file ${prjroot}/board/board_${board}_config.tcl
puts "\[GHRD:info\] \$board_config_file: $board_config_file"

if {[file exist $board_config_file]} {
    source $board_config_file
} else {
    error "Error: $board_config_file not exist!! Please make sure the board settings files are included in folder ./boards/"
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

if { ![ info exists mem_preset_file_en ] } {
 set mem_preset_file_en $MEM_PRESET_FILE_EN
} else {
 puts "-- Accepted parameter \$emif_topology = $mem_preset_file_en"
}
if { ![ info exists mem_preset_file_qprs ] } {
 set mem_preset_file_qprs $MEM_PRESET_FILE_QPRS
} else {
 puts "-- Accepted parameter \$emif_topology = $mem_preset_file_qprs"
}
if { ![ info exists mem_preset_id ] } {
 set mem_preset_id $MEM_PRESET_ID
} else {
 puts "-- Accepted parameter \$emif_topology = $mem_preset_id"
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

if { ![ info exists hps_en ] } {
 set hps_en $HPS_EN
} else {
 puts "-- Accepted parameter \$hps_en = $hps_en"
}

if { ![ info exists initialization_first ] } {
 set initialization_first $SYS_INITIALIZATION
} else {
 puts "-- Accepted parameter \$initialization_first = $initialization_first"
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

if { ![ info exists f2sdram_width ] } {
 set f2sdram_width $F2SDRAM_DATA_WIDTH
} else {
 puts "-- Accepted parameter \$f2sdram_width = $f2sdram_width"
}

if { ![ info exists f2sdram_addr_width ] } {
 set f2sdram_addr_width $F2SDRAM_ADDR_WIDTH
} else {
 puts "-- Accepted parameter \$f2sdram_addr_width = $f2sdram_addr_width"
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

if { ![ info exists hps_f2h_irq_en ] } {
 set hps_f2h_irq_en $HPS_F2H_IRQ_EN
} else {
 puts "-- Accepted parameter \$hps_f2h_irq_en = $hps_f2h_irq_en"
}

if { ![ info exists hps_clk_source ] } {
 set hps_clk_source $HPS_CLK_SOURCE
} else {
 puts "-- Accepted parameter \$hps_clk_source = $hps_clk_source"
}

if { ![ info exists pwr_mpu_l3_cache_size ] } {
 puts "-- Accepted parameter \$pwr_mpu_l3_cache_size = $pwr_mpu_l3_cache_size"
}

if { ![ info exists pwr_a55_core0_1_on ] } {
 puts "-- Accepted parameter \$pwr_a55_core0_1_on = $pwr_a55_core0_1_on"
}

if { ![ info exists pwr_a76_core2_on ] } {
 puts "-- Accepted parameter \$pwr_a76_core2_on = $pwr_a76_core2_on"
}

if { ![ info exists pwr_a76_core3_on ] } {
 puts "-- Accepted parameter \$pwr_a76_core3_on = $pwr_a76_core3_on"
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

# cct_adapter shall be enabled automatically when $f2s_address_width>0.

source $prjroot/hps_subsys/agilex_hps_pinmux_solver.tcl
source $prjroot/hps_subsys/agilex_hps_parameter_solver.tcl
source $prjroot/hps_subsys/agilex_hps_io48_delay_chain_solver.tcl


