#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2014-2020 Intel Corporation.
#
#****************************************************************************
#
# This script construct top level qsys for the GHRD
# to use this script, 
# example command to execute this script file
#   qsys-script --script=create_ghrd_qsys.tcl
#
# --- alternatively, input arguments could be passed in to select other FPGA variant. 
#     qsys_name        : <name your qsys top>,
#     devicefamily     : <FPGA device family>,
#     device           : <FPGA device part number>
#     hps_sdram        : <FBGA code of memory device>
#     boot_device      : <selection of boot source, either SDMMC, QSPI, NAND, or FPGA>
#     hps_sdram_ecc    : 1 or 0
#     hps_sgmii        : 1 or 0
#     sgmii_count      : 1 or 2
#     fast_trace       : 1 or 0
#     fpga_pcie        : 1 or 0
#     early_io_release : 1 or 0
#     pcie_gen         : 1, 2 or 3
#     pcie_count       : 4 or 8
#     board_rev        : <selection of development board revision, either A or B>
#     bsel             : override boot select
#           "0:RESERVED" 
#           "1:FPGA" 
#           "2:NAND Flash (1.8v)" 
#           "3:NAND Flash (3.0v)" 
#           "4:SD/MMC External Transceiver (1.8v)" 
#           "5:SD/MMC Internal Transceiver (3.0v)" 
#           "6:Quad SPI Flash (1.8v)" 
#           "7:Quad SPI Flash (3.0v)"
#     qsys_pro         : 1 or 0
#     spim0_en         : 1 or 0
#
# example command to execute this script file
#   qsys-script --script=create_ghrd_qsys.tcl --cmd="set qsys_name soc_system; set devicefamily "Arria 10"; set device 10AS066N3F40E2SG"
#
#****************************************************************************
source ./design_config.tcl
    
if { ![ info exists devicefamily ] } {
  set devicefamily $DEVICE_FAMILY
} else {
  puts "-- Accepted parameter \$devicefamily = $devicefamily"
}
    
if { ![ info exists device ] } {
  set device $FPGA_DEVICE
} else {
  puts "-- Accepted parameter \$device = $device"
}
    
if { ![ info exists qsys_name ] } {
  set qsys_name $QSYS_NAME
} else {
  puts "-- Accepted parameter \$qsys_name = $qsys_name"
}

if { ![ info exists hps_sdram ] } {
  set hps_sdram $HPS_SDRAM_DEVICE
} else {
  puts "-- Accepted parameter \$hps_sdram = $hps_sdram"
}

if { ![ info exists hps_sdram_ecc ] } {
  set hps_sdram_ecc $HPS_SDRAM_ECC_ENABLE
} else {
  puts "-- Accepted parameter \$hps_sdram_ecc = $hps_sdram_ecc"
}

if { ![ info exists hps_sgmii ] } {
  set hps_sgmii $SGMII_ENABLE
} else {
  puts "-- Accepted parameter \$hps_sgmii = $hps_sgmii"
}

if { ![ info exists sgmii_count ] } {
  set sgmii_count $SGMII_COUNT
} else {
  puts "-- Accepted parameter \$sgmii_count = $sgmii_count"
}

if { ![ info exists fpga_dp ] } {
  set fpga_dp $DISP_PORT_ENABLE
} else {
  puts "-- Accepted parameter \$fpga_dp = $fpga_dp"
}

if { ![ info exists frame_buffer ] } {
  set frame_buffer $ADD_FRAME_BUFFER
} else {
  puts "-- Accepted parameter \$frame_buffer = $frame_buffer"
}

if { ![ info exists fpga_pcie ] } {
  set fpga_pcie $PCIE_ENABLE
} else {
  puts "-- Accepted parameter \$fpga_pcie = $fpga_pcie"
}

if { ![ info exists pcie_gen ] } {
  set pcie_gen $GEN_ENABLE
} else {
  puts "-- Accepted parameter \$pcie_gen = $pcie_gen"
}

if { ![ info exists pcie_count ] } {
  set pcie_count $PCIE_COUNT
} else {
  puts "-- Accepted parameter \$pcie_count = $pcie_count"
}

if { ![ info exists boot_device ] } {
  set boot_device $BOOT_SOURCE
} else {
  puts "-- Accepted parameter \$boot_device = $boot_device"
}

if { ![ info exists fast_trace ] } {
  set fast_trace $FTRACE_ENABLE
} else {
  puts "-- Accepted parameter \$fast_trace = $fast_trace"
}

if { ![ info exists board_rev ] } {
  set board_rev $BOARD_REV
} else {
  puts "-- Accepted parameter \$board_rev = $board_rev"
}

if { ![ info exists early_io_release ] } {
  set early_io_release $EARLY_IO_RELEASE
} else {
  puts "-- Accepted parameter \$early_io_release = $early_io_release"
}

if { ![ info exists qsys_pro ] } {
  set qsys_pro $QSYS_PRO_ENABLE
} else {
  puts "-- Accepted parameter \$qsys_pro = $qsys_pro"
}

if { ![ info exists pr_enable ] } {
  set pr_enable $PARTIAL_RECONFIGURATION
} else {
  puts "-- Accepted parameter \$pr_enable = $pr_enable"
}

if { ![ info exists freeze_ack_dly_enable ] } {
  set freeze_ack_dly_enable $FREEZE_ACK_DELAY_ENABLE
} else {
  puts "-- Accepted parameter \$freeze_ack_dly_enable = $freeze_ack_dly_enable"
}

if { ![ info exists bsel ] } {
  set bsel $BSEL
} else {
  set BSEL_EN 1
  puts "-- Accepted parameter \$bsel = $bsel"
}

#
# verify bsel override against boot device
#
if {$BSEL_EN == 1} {
  #
  # If bsel is not reservered or fpga,
  # then only allow overriding of voltage to
  # to same boot_device.
  #
  if {$bsel != 0 && $bsel != 1} {
    if {$boot_device == "SDMMC"} {
      if {$bsel != 4 && $bsel != 5} {
        puts stderr "BOOT_DEVICE is $boot_device\n"
        puts stderr "Only valid values for bsel are 0, 1, 4, and 5\n"
        exit 1;
      }
    } elseif {$boot_device == "QSPI"} {
      if {$bsel != 6 && $bsel != 7} {
        puts stderr "BOOT_DEVICE is $boot_device\n"
        puts "Only valid overrides are 0, 1, 6, and 7\n"
        exit 1;
      }
    } elseif {$boot_device == "NAND"} {
      if {$bsel != 2 && $bsel != 3} {
        puts stderr "BOOT_DEVICE is $boot_device\n"
        puts stderr "Only valid overrides are 0, 1, 2, and 3\n"
        exit 1;
      }
    }
  }
}

if { ![ info exists spim0_en ] } {
    set spim0_en $SPIM0_EN
} else {
    puts "-- Accepted parameter \$spim0_en = $spim0_en"
}

# Internal parameter derivation
if {$hps_sdram_ecc == 1} {
   set hps_sdram_width 40 
} else {
   set hps_sdram_width 32
}

if {$boot_device == "SDMMC"} {
if {$board_rev == "A" } {
set dedicated_io_assignment "SDMMC:D0 SDMMC:CMD SDMMC:CCLK SDMMC:D1 SDMMC:D2 SDMMC:D3 NONE NONE SDMMC:D4 SDMMC:D5 SDMMC:D6 SDMMC:D7 NONE NONE"
} else {
set dedicated_io_assignment "SDMMC:D0 SDMMC:CMD SDMMC:CCLK SDMMC:D1 SDMMC:D2 SDMMC:D3 NONE NONE SDMMC:D4 SDMMC:D5 SDMMC:D6 SDMMC:D7 UART1:TX UART1:RX"
}
set boot_code 0
} elseif {$boot_device == "QSPI"} {
if {$board_rev == "A" } {
set dedicated_io_assignment "QSPI:CLK QSPI:IO0 QSPI:SS0 QSPI:IO1 QSPI:IO2_WPN QSPI:IO3_HOLD NONE NONE NONE NONE NONE NONE NONE NONE"
} else {
set dedicated_io_assignment "QSPI:CLK QSPI:IO0 QSPI:SS0 QSPI:IO1 QSPI:IO2_WPN QSPI:IO3_HOLD NONE NONE NONE NONE NONE NONE UART1:TX UART1:RX"
}
set boot_code 1
} elseif {$boot_device == "NAND"} {
set dedicated_io_assignment "NAND:ADQ0 NAND:ADQ1 NAND:WE_N NAND:RE_N NAND:ADQ2 NAND:ADQ3 NAND:CLE NAND:ALE NAND:RB NAND:CE_N NAND:ADQ4 NAND:ADQ5 NAND:ADQ6 NAND:ADQ7"
set boot_code 2
} else {
set dedicated_io_assignment "NONE NONE NONE NONE NONE NONE NONE NONE NONE NONE NONE NONE NONE NONE"
set boot_code 3
}

if {$hps_sdram == "D9RGX"} {
set hps_ddr 0
} elseif {$hps_sdram == "D9PZN"} {
set hps_ddr 1
} elseif {$hps_sdram == "D9RPL"} {
set hps_ddr 2
}

if {$fast_trace == 1 } {
set early_trace 0
} elseif {$hps_sgmii == 1 && $board_rev == "A"} {
set early_trace 0
} else {
set early_trace 1
}

if {$hps_sgmii == 1 && $board_rev == "A"} {
set hps_i2c_fpga_if 1
} else {
set hps_i2c_fpga_if 0
}

if {$early_trace == 1} {
set etrace_data_assignment "TRACE:D0 TRACE:D1 TRACE:D2 TRACE:D3"
set etrace_clk_assignment "TRACE:CLK"
} else {
set etrace_data_assignment "unused unused unused unused"
set etrace_clk_assignment "unused"
}

set io48_q1_assignment "USB0:CLK USB0:STP USB0:DIR USB0:DATA0 USB0:DATA1 USB0:NXT USB0:DATA2 USB0:DATA3 USB0:DATA4 USB0:DATA5 USB0:DATA6 USB0:DATA7"
set io48_q2_assignment "EMAC0:TX_CLK EMAC0:TX_CTL EMAC0:RX_CLK EMAC0:RX_CTL EMAC0:TXD0 EMAC0:TXD1 EMAC0:RXD0 EMAC0:RXD1 EMAC0:TXD2 EMAC0:TXD3 EMAC0:RXD2 EMAC0:RXD3"
if {$board_rev == "A" || $boot_device == "NAND"} {
set io48_q3_assignment "SPIM1:CLK SPIM1:MOSI SPIM1:MISO SPIM1:SS0_N SPIM1:SS1_N GPIO UART1:TX UART1:RX NONE NONE MDIO0:MDIO MDIO0:MDC"
} else {
set io48_q3_assignment "SPIM1:CLK SPIM1:MOSI SPIM1:MISO SPIM1:SS0_N SPIM1:SS1_N GPIO NONE NONE NONE NONE MDIO0:MDIO MDIO0:MDC"
}
if {$hps_sgmii == 1 && $board_rev == "A"} {
set io48_q4_assignment "unused unused unused $etrace_clk_assignment unused unused unused unused $etrace_data_assignment"
} else {
set io48_q4_assignment "I2C1:SDA I2C1:SCL GPIO $etrace_clk_assignment GPIO GPIO NONE NONE $etrace_data_assignment"
}

set variant_id [expr [expr $early_io_release<<14] + [expr $PCIE_ENABLE<<13] + [expr $CROSS_TRIGGER_ENABLE<<12] + [expr [expr $early_trace]<<11] + [expr $fast_trace<<10] + [expr $fpga_dp<<9] + [expr $hps_sgmii<<8] + [expr $boot_code<<4] + [expr $hps_sdram_ecc<<3] + $hps_ddr]
puts "VARIANT: [format %8.4x $variant_id]"

set SYSID [expr 0x${board_rev}0080000 + $variant_id]
puts "SYSID  : [format %8.8x $SYSID]"

package require -exact qsys 14.1
reload_ip_catalog

if {$hps_sgmii == 1} {
#set sub_qsys_sgmii $sgmii_sub_system_name
source ./construct_subsys_sgmii.tcl 
reload_ip_catalog
}

if {$fpga_dp == 1} {
#set sub_qsys_dp $displayport_sub_system_name 
source ./construct_subsys_dp.tcl
reload_ip_catalog
}

if {$fpga_pcie == 1} {
source ./construct_subsys_pcie.tcl
reload_ip_catalog
}

if {$pr_enable == 1 && $fpga_dp == 0} {
source ./construct_subsys_pr_region.tcl
reload_ip_catalog
}

create_system $qsys_name

set_project_property DEVICE_FAMILY $devicefamily
set_project_property DEVICE $device

add_instance clk_0 clock_source
set_instance_parameter_value clk_0 {clockFrequency} {100000000.0}
set_instance_parameter_value clk_0 {clockFrequencyKnown} {1}
set_instance_parameter_value clk_0 {resetSynchronousEdges} {DEASSERT}    

if {$fpga_dp == 1} {
add_instance clock_bridge_0 altera_clock_bridge
set_instance_parameter_value clock_bridge_0 {EXPLICIT_CLOCK_RATE} {74250000.0}
set_instance_parameter_value clock_bridge_0 {NUM_CLOCK_OUTPUTS} {1}
}

add_instance reset_bridge_0 altera_reset_bridge
set_instance_parameter_value reset_bridge_0 {ACTIVE_LOW_RESET} {0}
set_instance_parameter_value reset_bridge_0 {SYNCHRONOUS_EDGES} {deassert}
set_instance_parameter_value reset_bridge_0 {NUM_RESET_OUTPUTS} {1}
set_instance_parameter_value reset_bridge_0 {USE_RESET_REQUEST} {0}

if {$board_rev == "A" || $pcie_gen == 3 || $pcie_count == 8} {
if {$fpga_pcie == 1} {
add_instance iopll_0 altera_iopll
set_instance_parameter_value iopll_0 {gui_device_speed_grade} {1}
set_instance_parameter_value iopll_0 {gui_en_reconf} {0}
set_instance_parameter_value iopll_0 {gui_en_dps_ports} {0}
set_instance_parameter_value iopll_0 {gui_pll_mode} {Integer-N PLL}
    if {$board_rev == "A"} {
    set_instance_parameter_value iopll_0 {gui_reference_clock_frequency} {125.0}
    } else {
    set_instance_parameter_value iopll_0 {gui_reference_clock_frequency} {250.0}
    }
set_instance_parameter_value iopll_0 {gui_fractional_cout} {32}
set_instance_parameter_value iopll_0 {gui_dsm_out_sel} {1st_order}
set_instance_parameter_value iopll_0 {gui_use_locked} {1}
set_instance_parameter_value iopll_0 {gui_en_adv_params} {0}
set_instance_parameter_value iopll_0 {gui_pll_bandwidth_preset} {Low}
set_instance_parameter_value iopll_0 {gui_lock_setting} {Low Lock Time}
set_instance_parameter_value iopll_0 {gui_pll_auto_reset} {0}
set_instance_parameter_value iopll_0 {gui_en_lvds_ports} {Disabled}
set_instance_parameter_value iopll_0 {gui_operation_mode} {direct}
set_instance_parameter_value iopll_0 {gui_feedback_clock} {Global Clock}
set_instance_parameter_value iopll_0 {gui_clock_to_compensate} {0}
set_instance_parameter_value iopll_0 {gui_use_NDFB_modes} {0}
set_instance_parameter_value iopll_0 {gui_refclk_switch} {0}
set_instance_parameter_value iopll_0 {gui_refclk1_frequency} {100.0}
set_instance_parameter_value iopll_0 {gui_en_phout_ports} {0}
set_instance_parameter_value iopll_0 {gui_phout_division} {1}
set_instance_parameter_value iopll_0 {gui_en_extclkout_ports} {0}
set_instance_parameter_value iopll_0 {gui_number_of_clocks} {2}
set_instance_parameter_value iopll_0 {gui_multiply_factor} {6}
set_instance_parameter_value iopll_0 {gui_divide_factor_n} {1}
set_instance_parameter_value iopll_0 {gui_frac_multiply_factor} {1.0}
set_instance_parameter_value iopll_0 {gui_fix_vco_frequency} {0}
set_instance_parameter_value iopll_0 {gui_fixed_vco_frequency} {600.0}
set_instance_parameter_value iopll_0 {gui_vco_frequency} {600.0}
set_instance_parameter_value iopll_0 {gui_enable_output_counter_cascading} {0}
set_instance_parameter_value iopll_0 {gui_mif_gen_options} {Generate New MIF File}
set_instance_parameter_value iopll_0 {gui_new_mif_file_path} {~/pll.mif}
set_instance_parameter_value iopll_0 {gui_existing_mif_file_path} {~/pll.mif}
set_instance_parameter_value iopll_0 {gui_mif_config_name} {unnamed}
set_instance_parameter_value iopll_0 {gui_active_clk} {0}
set_instance_parameter_value iopll_0 {gui_clk_bad} {0}
set_instance_parameter_value iopll_0 {gui_switchover_mode} {Automatic Switchover}
set_instance_parameter_value iopll_0 {gui_switchover_delay} {0}
set_instance_parameter_value iopll_0 {gui_enable_cascade_out} {0}
set_instance_parameter_value iopll_0 {gui_cascade_outclk_index} {0}
set_instance_parameter_value iopll_0 {gui_enable_cascade_in} {0}
set_instance_parameter_value iopll_0 {gui_pll_cascading_mode} {adjpllin}
set_instance_parameter_value iopll_0 {gui_enable_mif_dps} {0}
set_instance_parameter_value iopll_0 {gui_dps_cntr} {C0}
set_instance_parameter_value iopll_0 {gui_dps_num} {1}
set_instance_parameter_value iopll_0 {gui_dps_dir} {Positive}
set_instance_parameter_value iopll_0 {gui_extclkout_0_source} {C0}
set_instance_parameter_value iopll_0 {gui_extclkout_1_source} {C0}
set_instance_parameter_value iopll_0 {gui_clock_name_global} {0}
set_instance_parameter_value iopll_0 {gui_clock_name_string0} {outclk0}
set_instance_parameter_value iopll_0 {gui_clock_name_string1} {outclk1}
set_instance_parameter_value iopll_0 {gui_divide_factor_c0} {6}
set_instance_parameter_value iopll_0 {gui_divide_factor_c1} {6}
set_instance_parameter_value iopll_0 {gui_cascade_counter0} {0}
set_instance_parameter_value iopll_0 {gui_cascade_counter1} {0}
set_instance_parameter_value iopll_0 {gui_output_clock_frequency0} {180.0}
set_instance_parameter_value iopll_0 {gui_output_clock_frequency1} {125.0}
set_instance_parameter_value iopll_0 {gui_ps_units0} {ps}
set_instance_parameter_value iopll_0 {gui_ps_units1} {ps}
set_instance_parameter_value iopll_0 {gui_phase_shift0} {0.0}
set_instance_parameter_value iopll_0 {gui_phase_shift1} {0.0}
set_instance_parameter_value iopll_0 {gui_phase_shift_deg0} {0.0}
set_instance_parameter_value iopll_0 {gui_phase_shift_deg1} {0.0}
set_instance_parameter_value iopll_0 {gui_actual_phase_shift0} {0.0}
set_instance_parameter_value iopll_0 {gui_actual_phase_shift1} {0.0}
set_instance_parameter_value iopll_0 {gui_actual_phase_shift_deg0} {0.0}
set_instance_parameter_value iopll_0 {gui_actual_phase_shift_deg1} {0.0}
set_instance_parameter_value iopll_0 {gui_duty_cycle0} {50.0}
set_instance_parameter_value iopll_0 {gui_duty_cycle1} {50.0}
set_instance_parameter_value iopll_0 {gui_actual_duty_cycle0} {50.0}
set_instance_parameter_value iopll_0 {gui_actual_duty_cycle1} {50.0}
}
}

add_instance arria10_hps_0 altera_arria10_hps 
set_instance_parameter_value arria10_hps_0 {MPU_EVENTS_Enable} {0}
set_instance_parameter_value arria10_hps_0 {GP_Enable} {0}
set_instance_parameter_value arria10_hps_0 {DEBUG_APB_Enable} {0}
set_instance_parameter_value arria10_hps_0 {STM_Enable} {1}
set_instance_parameter_value arria10_hps_0 {CTI_Enable} {0}
set_instance_parameter_value arria10_hps_0 {BOOT_FROM_FPGA_Enable} {0}
set_instance_parameter_value arria10_hps_0 {JTAG_Enable} {0}
set_instance_parameter_value arria10_hps_0 {TEST_Enable} {0}
set_instance_parameter_value arria10_hps_0 {BSEL_EN} {0}
set_instance_parameter_value arria10_hps_0 {BSEL} {1}
set_instance_parameter_value arria10_hps_0 {F2S_Width} {6}
set_instance_parameter_value arria10_hps_0 {S2F_Width} {4}
set_instance_parameter_value arria10_hps_0 {LWH2F_Enable} {2}
set_instance_parameter_value arria10_hps_0 {RUN_INTERNAL_BUILD_CHECKS} {0}
if {$board_rev == "A"}  {
set_instance_parameter_value arria10_hps_0 {F2SDRAM_PORT_CONFIG} {5}
set_instance_parameter_value arria10_hps_0 {F2SDRAM0_ENABLED} {0}
set_instance_parameter_value arria10_hps_0 {F2SDRAM1_ENABLED} {1}
set_instance_parameter_value arria10_hps_0 {F2SDRAM2_ENABLED} {0}
} else {
set_instance_parameter_value arria10_hps_0 {F2SDRAM_PORT_CONFIG} {6}
set_instance_parameter_value arria10_hps_0 {F2SDRAM0_ENABLED} {1}
set_instance_parameter_value arria10_hps_0 {F2SDRAM1_ENABLED} {0}
set_instance_parameter_value arria10_hps_0 {F2SDRAM2_ENABLED} {1}
}
set_instance_parameter_value arria10_hps_0 {F2SDRAM_READY_LATENCY} {1}
set_instance_parameter_value arria10_hps_0 {F2SDRAM_ADDRESS_WIDTH} {32}
set_instance_parameter_value arria10_hps_0 {DMA_Enable} {No No No No No No No No}
set_instance_parameter_value arria10_hps_0 {SECURITY_MODULE_Enable} {0}
set_instance_parameter_value arria10_hps_0 {EMAC0_SWITCH_Enable} {0}
set_instance_parameter_value arria10_hps_0 {EMAC1_SWITCH_Enable} {0}
set_instance_parameter_value arria10_hps_0 {EMAC2_SWITCH_Enable} {0}
set_instance_parameter_value arria10_hps_0 {F2SINTERRUPT_Enable} {1}
set_instance_parameter_value arria10_hps_0 {S2FINTERRUPT_CLOCKPERIPHERAL_Enable} {0}
set_instance_parameter_value arria10_hps_0 {S2FINTERRUPT_CTI_Enable} {0}
set_instance_parameter_value arria10_hps_0 {S2FINTERRUPT_DMA_Enable} {0}
set_instance_parameter_value arria10_hps_0 {S2FINTERRUPT_EMAC0_Enable} {0}
set_instance_parameter_value arria10_hps_0 {S2FINTERRUPT_EMAC1_Enable} {0}
set_instance_parameter_value arria10_hps_0 {S2FINTERRUPT_EMAC2_Enable} {0}
set_instance_parameter_value arria10_hps_0 {S2FINTERRUPT_FPGAMANAGER_Enable} {0}
set_instance_parameter_value arria10_hps_0 {S2FINTERRUPT_GPIO_Enable} {0}
set_instance_parameter_value arria10_hps_0 {S2FINTERRUPT_HMC_Enable} {0}
set_instance_parameter_value arria10_hps_0 {S2FINTERRUPT_I2CEMAC0_Enable} {0}
set_instance_parameter_value arria10_hps_0 {S2FINTERRUPT_I2CEMAC1_Enable} {0}
set_instance_parameter_value arria10_hps_0 {S2FINTERRUPT_I2CEMAC2_Enable} {0}
set_instance_parameter_value arria10_hps_0 {S2FINTERRUPT_I2C0_Enable} {0}
set_instance_parameter_value arria10_hps_0 {S2FINTERRUPT_I2C1_Enable} {0}
set_instance_parameter_value arria10_hps_0 {S2FINTERRUPT_L4TIMER_Enable} {0}
set_instance_parameter_value arria10_hps_0 {S2FINTERRUPT_NAND_Enable} {0}
set_instance_parameter_value arria10_hps_0 {S2FINTERRUPT_QSPI_Enable} {0}
set_instance_parameter_value arria10_hps_0 {S2FINTERRUPT_SYSTIMER_Enable} {0}
set_instance_parameter_value arria10_hps_0 {S2FINTERRUPT_SDMMC_Enable} {0}
set_instance_parameter_value arria10_hps_0 {S2FINTERRUPT_SPIM0_Enable} {0}
set_instance_parameter_value arria10_hps_0 {S2FINTERRUPT_SPIM1_Enable} {0}
set_instance_parameter_value arria10_hps_0 {S2FINTERRUPT_SPIS0_Enable} {0}
set_instance_parameter_value arria10_hps_0 {S2FINTERRUPT_SPIS1_Enable} {0}
set_instance_parameter_value arria10_hps_0 {S2FINTERRUPT_SYSTEMMANAGER_Enable} {0}
set_instance_parameter_value arria10_hps_0 {S2FINTERRUPT_UART0_Enable} {0}
set_instance_parameter_value arria10_hps_0 {S2FINTERRUPT_UART1_Enable} {0}
set_instance_parameter_value arria10_hps_0 {S2FINTERRUPT_USB0_Enable} {0}
set_instance_parameter_value arria10_hps_0 {S2FINTERRUPT_USB1_Enable} {0}
set_instance_parameter_value arria10_hps_0 {S2FINTERRUPT_WATCHDOG_Enable} {0}
set_instance_parameter_value arria10_hps_0 {eosc1_clk_mhz} {25.0}
set_instance_parameter_value arria10_hps_0 {F2H_FREE_CLK_Enable} {0}
set_instance_parameter_value arria10_hps_0 {F2H_FREE_CLK_FREQ} {200}
set_instance_parameter_value arria10_hps_0 {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_EMAC0_MD_CLK} {2.5}
set_instance_parameter_value arria10_hps_0 {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_EMAC0_GTX_CLK} {100}
set_instance_parameter_value arria10_hps_0 {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_EMAC1_MD_CLK} {2.5}
set_instance_parameter_value arria10_hps_0 {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_EMAC1_GTX_CLK} {125}
set_instance_parameter_value arria10_hps_0 {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_EMAC2_MD_CLK} {2.5}
set_instance_parameter_value arria10_hps_0 {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_EMAC2_GTX_CLK} {125}
set_instance_parameter_value arria10_hps_0 {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_QSPI_SCLK_OUT} {100}
set_instance_parameter_value arria10_hps_0 {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_SDMMC_CCLK} {100}
set_instance_parameter_value arria10_hps_0 {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_SPIM0_SCLK_OUT} {100}
set_instance_parameter_value arria10_hps_0 {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_SPIM1_SCLK_OUT} {100}
set_instance_parameter_value arria10_hps_0 {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_I2C0_CLK} {100}
set_instance_parameter_value arria10_hps_0 {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_I2C1_CLK} {100}
set_instance_parameter_value arria10_hps_0 {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_I2CEMAC0_CLK} {100}
set_instance_parameter_value arria10_hps_0 {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_I2CEMAC1_CLK} {100}
set_instance_parameter_value arria10_hps_0 {FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_I2CEMAC2_CLK} {100}
set_instance_parameter_value arria10_hps_0 {MPU_CLK_VCCL} {1}
set_instance_parameter_value arria10_hps_0 {USE_DEFAULT_MPU_CLK} {0}
set_instance_parameter_value arria10_hps_0 {CUSTOM_MPU_CLK} {1020}
set_instance_parameter_value arria10_hps_0 {H2F_USER0_CLK_Enable} {0}
set_instance_parameter_value arria10_hps_0 {H2F_USER0_CLK_FREQ} {400}
set_instance_parameter_value arria10_hps_0 {H2F_USER1_CLK_Enable} {0}
set_instance_parameter_value arria10_hps_0 {H2F_USER1_CLK_FREQ} {400}
set_instance_parameter_value arria10_hps_0 {HMC_PLL_REF_CLK} {800}
set_instance_parameter_value arria10_hps_0 {EMAC_PTP_REF_CLK} {100}
set_instance_parameter_value arria10_hps_0 {SDMMC_REF_CLK} {200}
set_instance_parameter_value arria10_hps_0 {GPIO_REF_CLK} {4}
set_instance_parameter_value arria10_hps_0 {L3_MAIN_FREE_CLK} {200}
set_instance_parameter_value arria10_hps_0 {L4_SYS_FREE_CLK} {1}
set_instance_parameter_value arria10_hps_0 {NOCDIV_L4MAINCLK} {0}
set_instance_parameter_value arria10_hps_0 {NOCDIV_L4MPCLK} {0}
set_instance_parameter_value arria10_hps_0 {NOCDIV_L4SPCLK} {2}
set_instance_parameter_value arria10_hps_0 {NOCDIV_CS_ATCLK} {0}
set_instance_parameter_value arria10_hps_0 {NOCDIV_CS_PDBGCLK} {1}
set_instance_parameter_value arria10_hps_0 {NOCDIV_CS_TRACECLK} {1}
set_instance_parameter_value arria10_hps_0 {HPS_DIV_GPIO_FREQ} {125}
set_instance_parameter_value arria10_hps_0 {EMAC0_CLK} {250}
set_instance_parameter_value arria10_hps_0 {EMAC1_CLK} {250}
set_instance_parameter_value arria10_hps_0 {EMAC2_CLK} {250}
set_instance_parameter_value arria10_hps_0 {DISABLE_PERI_PLL} {0}
set_instance_parameter_value arria10_hps_0 {OVERIDE_PERI_PLL} {0}
set_instance_parameter_value arria10_hps_0 {PERI_PLL_MANUAL_VCO_FREQ} {2000}
set_instance_parameter_value arria10_hps_0 {CLK_MAIN_PLL_SOURCE2} {0}
set_instance_parameter_value arria10_hps_0 {CLK_PERI_PLL_SOURCE2} {0}
set_instance_parameter_value arria10_hps_0 {CLK_MPU_SOURCE} {0}
set_instance_parameter_value arria10_hps_0 {CLK_MPU_CNT} {0}
set_instance_parameter_value arria10_hps_0 {CLK_NOC_SOURCE} {0}
set_instance_parameter_value arria10_hps_0 {CLK_NOC_CNT} {0}
set_instance_parameter_value arria10_hps_0 {CLK_S2F_USER0_SOURCE} {0}
set_instance_parameter_value arria10_hps_0 {CLK_S2F_USER1_SOURCE} {0}
set_instance_parameter_value arria10_hps_0 {CLK_HMC_PLL_SOURCE} {0}
set_instance_parameter_value arria10_hps_0 {CLK_EMAC_PTP_SOURCE} {1}
set_instance_parameter_value arria10_hps_0 {CLK_GPIO_SOURCE} {1}
set_instance_parameter_value arria10_hps_0 {CLK_SDMMC_SOURCE} {1}
set_instance_parameter_value arria10_hps_0 {CLK_EMACA_SOURCE} {1}
set_instance_parameter_value arria10_hps_0 {CLK_EMACB_SOURCE} {1}
set_instance_parameter_value arria10_hps_0 {MAINPLLGRP_PERIPH_REF_CNT} {2048}
set_instance_parameter_value arria10_hps_0 {H2F_PENDING_RST_Enable} {0}
set_instance_parameter_value arria10_hps_0 {H2F_COLD_RST_Enable} {0}
set_instance_parameter_value arria10_hps_0 {F2H_DBG_RST_Enable} {1}
set_instance_parameter_value arria10_hps_0 {F2H_WARM_RST_Enable} {1}
set_instance_parameter_value arria10_hps_0 {F2H_COLD_RST_Enable} {1}
if {$hps_sdram == "D9RPL" || $hps_sdram == "D9PZN" || $hps_sdram == "D9RGX"} {
set_instance_parameter_value arria10_hps_0 {EMIF_CONDUIT_Enable} {1}
} else {
set_instance_parameter_value arria10_hps_0 {EMIF_CONDUIT_Enable} {0}
}
set_instance_parameter_value arria10_hps_0 {EMAC0_PinMuxing} {IO}
set_instance_parameter_value arria10_hps_0 {EMAC0_Mode} {RGMII_with_MDIO}
if {$hps_sgmii == 1} {
set_instance_parameter_value arria10_hps_0 {EMAC1_PinMuxing} {FPGA}
set_instance_parameter_value arria10_hps_0 {EMAC1_Mode} {RGMII_with_MDIO}
} else {    
set_instance_parameter_value arria10_hps_0 {EMAC1_PinMuxing} {Unused}
set_instance_parameter_value arria10_hps_0 {EMAC1_Mode} {N/A}
}
if {$hps_sgmii == 1 && $sgmii_count == 2} {
set_instance_parameter_value arria10_hps_0 {EMAC2_PinMuxing} {FPGA}
set_instance_parameter_value arria10_hps_0 {EMAC2_Mode} {RGMII_with_MDIO}
} else {
set_instance_parameter_value arria10_hps_0 {EMAC2_PinMuxing} {Unused}
set_instance_parameter_value arria10_hps_0 {EMAC2_Mode} {N/A}
}
if {$boot_device == "NAND"} {
set_instance_parameter_value arria10_hps_0 {NAND_PinMuxing} {IO}
set_instance_parameter_value arria10_hps_0 {NAND_Mode} {8-bit}
} else {
set_instance_parameter_value arria10_hps_0 {NAND_PinMuxing} {Unused}
set_instance_parameter_value arria10_hps_0 {NAND_Mode} {N/A}
}
if {$boot_device == "QSPI"} {
set_instance_parameter_value arria10_hps_0 {QSPI_PinMuxing} {IO}
set_instance_parameter_value arria10_hps_0 {QSPI_Mode} {1ss}
} else {
set_instance_parameter_value arria10_hps_0 {QSPI_PinMuxing} {Unused}
set_instance_parameter_value arria10_hps_0 {QSPI_Mode} {N/A}
}
if {$boot_device == "SDMMC"} {
set_instance_parameter_value arria10_hps_0 {SDMMC_PinMuxing} {IO}
set_instance_parameter_value arria10_hps_0 {SDMMC_Mode} {8-bit}
} else {
set_instance_parameter_value arria10_hps_0 {SDMMC_PinMuxing} {Unused}
set_instance_parameter_value arria10_hps_0 {SDMMC_Mode} {N/A}
}
set_instance_parameter_value arria10_hps_0 {USB0_PinMuxing} {IO}
set_instance_parameter_value arria10_hps_0 {USB0_Mode} {default}
set_instance_parameter_value arria10_hps_0 {USB1_PinMuxing} {Unused}
set_instance_parameter_value arria10_hps_0 {USB1_Mode} {N/A}
if {$spim0_en == 1} {
set_instance_parameter_value arria10_hps_0 {SPIM0_PinMuxing} {FPGA}
set_instance_parameter_value arria10_hps_0 {SPIM0_Mode} {Single_slave_selects}
} else {
set_instance_parameter_value arria10_hps_0 {SPIM0_PinMuxing} {Unused}
set_instance_parameter_value arria10_hps_0 {SPIM0_Mode} {N/A}
}
set_instance_parameter_value arria10_hps_0 {SPIM1_PinMuxing} {IO}
set_instance_parameter_value arria10_hps_0 {SPIM1_Mode} {Dual_slave_selects}
set_instance_parameter_value arria10_hps_0 {SPIS0_PinMuxing} {Unused}
set_instance_parameter_value arria10_hps_0 {SPIS0_Mode} {N/A}
set_instance_parameter_value arria10_hps_0 {SPIS1_PinMuxing} {Unused}
set_instance_parameter_value arria10_hps_0 {SPIS1_Mode} {N/A}
set_instance_parameter_value arria10_hps_0 {UART0_PinMuxing} {Unused}
set_instance_parameter_value arria10_hps_0 {UART0_Mode} {N/A}
set_instance_parameter_value arria10_hps_0 {UART1_PinMuxing} {IO}
set_instance_parameter_value arria10_hps_0 {UART1_Mode} {No_flow_control}
set_instance_parameter_value arria10_hps_0 {I2C0_PinMuxing} {Unused}
set_instance_parameter_value arria10_hps_0 {I2C0_Mode} {N/A}
if {$hps_i2c_fpga_if == 1} {
# re-route I2C1 from FPGA to IO48
set_instance_parameter_value arria10_hps_0 {I2C1_PinMuxing} {FPGA}
} else {
set_instance_parameter_value arria10_hps_0 {I2C1_PinMuxing} {IO}
}
set_instance_parameter_value arria10_hps_0 {I2C1_Mode} {default}
set_instance_parameter_value arria10_hps_0 {I2CEMAC0_PinMuxing} {Unused}
set_instance_parameter_value arria10_hps_0 {I2CEMAC0_Mode} {N/A}
set_instance_parameter_value arria10_hps_0 {I2CEMAC1_PinMuxing} {Unused}
set_instance_parameter_value arria10_hps_0 {I2CEMAC1_Mode} {N/A}
set_instance_parameter_value arria10_hps_0 {I2CEMAC2_PinMuxing} {Unused}
set_instance_parameter_value arria10_hps_0 {I2CEMAC2_Mode} {N/A}
if {$fast_trace == 1} {
set_instance_parameter_value arria10_hps_0 {TRACE_PinMuxing} {FPGA}
set_instance_parameter_value arria10_hps_0 {TRACE_Mode} {default}
} elseif {$early_trace == 1} {
set_instance_parameter_value arria10_hps_0 {TRACE_PinMuxing} {IO}
set_instance_parameter_value arria10_hps_0 {TRACE_Mode} {default}
} else {
set_instance_parameter_value arria10_hps_0 {TRACE_PinMuxing} {Unused}
set_instance_parameter_value arria10_hps_0 {TRACE_Mode} {default}
}
set_instance_parameter_value arria10_hps_0 {CM_PinMuxing} {Unused}
set_instance_parameter_value arria10_hps_0 {CM_Mode} {N/A}
set_instance_parameter_value arria10_hps_0 {PLL_CLK0} {Unused}
set_instance_parameter_value arria10_hps_0 {PLL_CLK1} {Unused}
set_instance_parameter_value arria10_hps_0 {PLL_CLK2} {Unused}
set_instance_parameter_value arria10_hps_0 {PLL_CLK3} {Unused}
set_instance_parameter_value arria10_hps_0 {PLL_CLK4} {Unused}
set_instance_parameter_value arria10_hps_0 {HPS_IO_Enable} "$dedicated_io_assignment $io48_q1_assignment $io48_q2_assignment $io48_q3_assignment $io48_q4_assignment"

if {$BSEL_EN == 1} {
set_instance_parameter_value arria10_hps_0 {BSEL_EN} 1
set_instance_parameter_value arria10_hps_0 {BSEL} $bsel
}
if {$hps_sdram == "D9RPL"} {
# dual rank DDR3 -1866
add_instance emif_a10_hps_0 altera_emif_a10_hps
set_instance_parameter_value emif_a10_hps_0 {PROTOCOL_ENUM} {PROTOCOL_DDR3}
set_instance_parameter_value emif_a10_hps_0 {IS_ED_SLAVE} {0}
set_instance_parameter_value emif_a10_hps_0 {INTERNAL_TESTING_MODE} {0}
set_instance_parameter_value emif_a10_hps_0 {PLL_ADD_EXTRA_CLKS} {0}
set_instance_parameter_value emif_a10_hps_0 {PLL_USER_NUM_OF_EXTRA_CLKS} {0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_0} {0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_1} {0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_2} {0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_3} {0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_4} {0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_DESIRED_FREQ_MHZ_GUI_5} {100.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_5} {100.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_5} {0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_DESIRED_PHASE_GUI_5} {0.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_ACTUAL_PHASE_PS_GUI_5} {0.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_ACTUAL_PHASE_DEG_GUI_5} {0.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_DESIRED_DUTY_CYCLE_GUI_5} {50.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_GUI_5} {50.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_DESIRED_FREQ_MHZ_GUI_6} {100.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_6} {100.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_6} {0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_DESIRED_PHASE_GUI_6} {0.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_ACTUAL_PHASE_PS_GUI_6} {0.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_ACTUAL_PHASE_DEG_GUI_6} {0.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_DESIRED_DUTY_CYCLE_GUI_6} {50.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_GUI_6} {50.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_DESIRED_FREQ_MHZ_GUI_7} {100.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_7} {100.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_7} {0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_DESIRED_PHASE_GUI_7} {0.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_ACTUAL_PHASE_PS_GUI_7} {0.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_ACTUAL_PHASE_DEG_GUI_7} {0.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_DESIRED_DUTY_CYCLE_GUI_7} {50.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_GUI_7} {50.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_DESIRED_FREQ_MHZ_GUI_8} {100.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_8} {100.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_8} {0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_DESIRED_PHASE_GUI_8} {0.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_ACTUAL_PHASE_PS_GUI_8} {0.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_ACTUAL_PHASE_DEG_GUI_8} {0.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_DESIRED_DUTY_CYCLE_GUI_8} {50.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_GUI_8} {50.0}

set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_CONFIG_ENUM} {CONFIG_PHY_AND_HARD_CTRL}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_USER_PING_PONG_EN} {0}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_MEM_CLK_FREQ_MHZ} {800.0}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_DEFAULT_REF_CLK_FREQ} {0}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_USER_REF_CLK_FREQ_MHZ} {133.333}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_REF_CLK_JITTER_PS} {10.0}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_RATE_ENUM} {RATE_HALF}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_CORE_CLKS_SHARING_ENUM} {CORE_CLKS_SHARING_DISABLED}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_IO_VOLTAGE} {1.5}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_DEFAULT_IO} {0}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_CAL_ADDR0} {0}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_CAL_ADDR1} {8}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_CAL_ENABLE_NON_DES} {1}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_USER_AC_IO_STD_ENUM} {IO_STD_SSTL_15_C1}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_USER_AC_MODE_ENUM} {CURRENT_ST_12}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_USER_AC_SLEW_RATE_ENUM} {SLEW_RATE_FAST}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_USER_CK_IO_STD_ENUM} {IO_STD_SSTL_15_C1}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_USER_CK_MODE_ENUM} {CURRENT_ST_12}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_USER_CK_SLEW_RATE_ENUM} {SLEW_RATE_FAST}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_USER_DATA_IO_STD_ENUM} {IO_STD_SSTL_15}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_USER_DATA_OUT_MODE_ENUM} {OUT_OCT_34_CAL}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_USER_DATA_IN_MODE_ENUM} {IN_OCT_120_CAL}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_USER_PLL_REF_CLK_IO_STD_ENUM} {IO_STD_LVDS}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_USER_RZQ_IO_STD_ENUM} {IO_STD_CMOS_15}
if {$early_io_release == 1} {
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_HPS_ENABLE_EARLY_RELEASE} {1}
}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_FORMAT_ENUM} {MEM_FORMAT_UDIMM}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_DQ_WIDTH} $hps_sdram_width
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_DQ_PER_DQS} {8}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_DISCRETE_CS_WIDTH} {1}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_NUM_OF_DIMMS} {1}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_RANKS_PER_DIMM} {2}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_CKE_PER_DIMM} {1}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_CK_WIDTH} {1}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_ROW_ADDR_WIDTH} {15}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_COL_ADDR_WIDTH} {10}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_BANK_ADDR_WIDTH} {3}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_DM_EN} {1}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_MIRROR_ADDRESSING_EN} {1}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_RDIMM_CONFIG} {0000000000000000}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_LRDIMM_EXTENDED_CONFIG} {000000000000000000}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_ALERT_N_PLACEMENT_ENUM} {DDR3_ALERT_N_PLACEMENT_AC_LANES}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_ALERT_N_DQS_GROUP} {0}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_BL_ENUM} {DDR3_BL_BL8}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_BT_ENUM} {DDR3_BT_SEQUENTIAL}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_ASR_ENUM} {DDR3_ASR_MANUAL}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_SRT_ENUM} {DDR3_SRT_NORMAL}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_PD_ENUM} {DDR3_PD_OFF}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_DRV_STR_ENUM} {DDR3_DRV_STR_RZQ_7}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_DLL_EN} {1}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_RTT_NOM_ENUM} {DDR3_RTT_NOM_ODT_DISABLED}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_RTT_WR_ENUM} {DDR3_RTT_WR_RZQ_4}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_WTCL} {8}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_ATCL_ENUM} {DDR3_ATCL_DISABLED}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TCL} {11}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_USE_DEFAULT_ODT} {1}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_R_ODTN_1X1} {Rank\ 0}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_R_ODT0_1X1} {off}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_W_ODTN_1X1} {Rank\ 0}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_W_ODT0_1X1} {on}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_R_ODTN_2X2} {Rank\ 0 Rank\ 1}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_R_ODT0_2X2} {off off}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_R_ODT1_2X2} {off off}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_W_ODTN_2X2} {Rank\ 0 Rank\ 1}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_W_ODT0_2X2} {on off}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_W_ODT1_2X2} {off on}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_R_ODTN_4X2} {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_R_ODT0_4X2} {off off on on}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_R_ODT1_4X2} {on on off off}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_W_ODTN_4X2} {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_W_ODT0_4X2} {off off on on}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_W_ODT1_4X2} {on on off off}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_R_ODTN_4X4} {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_R_ODT0_4X4} {off off off off}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_R_ODT1_4X4} {off off on on}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_R_ODT2_4X4} {off off off off}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_R_ODT3_4X4} {on on off off}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_W_ODTN_4X4} {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_W_ODT0_4X4} {on on off off}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_W_ODT1_4X4} {off off on on}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_W_ODT2_4X4} {off off on on}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_W_ODT3_4X4} {on on off off}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_SPEEDBIN_ENUM} {DDR3_SPEEDBIN_1866}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TIS_PS} {65}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TIS_AC_MV} {135}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TIH_PS} {100}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TIH_DC_MV} {100}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TDS_PS} {68}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TDS_AC_MV} {135}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TDH_PS} {70}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TDH_DC_MV} {100}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TDQSQ_PS} {85}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TQH_CYC} {0.38}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TDQSCK_PS} {195}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TDQSS_CYC} {0.27}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TQSH_CYC} {0.4}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TDSH_CYC} {0.18}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TWLS_PS} {140.0}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TWLH_PS} {140.0}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TDSS_CYC} {0.18}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TINIT_US} {500}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TMRD_CK_CYC} {4}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TRAS_NS} {34.0}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TRCD_NS} {13.91}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TRP_NS} {13.91}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TREFI_US} {7.8}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TRFC_NS} {350.0}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TWR_NS} {15.0}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TWTR_CYC} {6}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TFAW_NS} {30.0}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TRRD_CYC} {4}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TRTP_CYC} {6}

set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_USE_DEFAULT_SLEW_RATES} {1}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_USE_DEFAULT_ISI_VALUES} {1}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_USER_CK_SLEW_RATE} {4.0}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_USER_AC_SLEW_RATE} {2.0}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_USER_RCLK_SLEW_RATE} {5.0}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_USER_WCLK_SLEW_RATE} {4.0}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_USER_RDATA_SLEW_RATE} {2.5}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_USER_WDATA_SLEW_RATE} {2.0}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_USER_AC_ISI_NS} {0.0}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_USER_RCLK_ISI_NS} {0.0}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_USER_WCLK_ISI_NS} {0.0}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_USER_RDATA_ISI_NS} {0.0}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_USER_WDATA_ISI_NS} {0.0}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_IS_SKEW_WITHIN_DQS_DESKEWED} {0}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_BRD_SKEW_WITHIN_DQS_NS} {0.02}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_PKG_BRD_SKEW_WITHIN_DQS_NS} {0.02}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_IS_SKEW_WITHIN_AC_DESKEWED} {1}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_BRD_SKEW_WITHIN_AC_NS} {0.02}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_PKG_BRD_SKEW_WITHIN_AC_NS} {0.02}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_DQS_TO_CK_SKEW_NS} {0.02}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_SKEW_BETWEEN_DIMMS_NS} {0.05}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_SKEW_BETWEEN_DQS_NS} {0.02}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_AC_TO_CK_SKEW_NS} {0.0}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_MAX_CK_DELAY_NS} {0.6}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_MAX_DQS_DELAY_NS} {0.6}

set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_AVL_PROTOCOL_ENUM} {CTRL_AVL_PROTOCOL_ST}
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_SELF_REFRESH_EN} {0}
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_AUTO_POWER_DOWN_EN} {0}
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_AUTO_POWER_DOWN_CYCS} {32}
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_USER_REFRESH_EN} {0}
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_USER_PRIORITY_EN} {0}
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_AUTO_PRECHARGE_EN} {0}
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_ADDR_ORDER_ENUM} {DDR3_CTRL_ADDR_ORDER_CS_R_B_C}
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_ECC_EN} $hps_sdram_ecc
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_ECC_AUTO_CORRECTION_EN} $hps_sdram_ecc
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_REORDER_EN} {1}
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_STARVE_LIMIT} {10}
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_MMR_EN} $hps_sdram_ecc
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_RD_TO_WR_SAME_CHIP_DELTA_CYCS} {0}
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_WR_TO_RD_SAME_CHIP_DELTA_CYCS} {0}
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_RD_TO_RD_DIFF_CHIP_DELTA_CYCS} {0}
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_RD_TO_WR_DIFF_CHIP_DELTA_CYCS} {0}
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_WR_TO_WR_DIFF_CHIP_DELTA_CYCS} {0}
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_WR_TO_RD_DIFF_CHIP_DELTA_CYCS} {0}

set_instance_parameter_value emif_a10_hps_0 {DIAG_DDR3_SIM_CAL_MODE_ENUM} {SIM_CAL_MODE_SKIP}
set_instance_parameter_value emif_a10_hps_0 {DIAG_DDR3_EXPORT_SEQ_AVALON_SLAVE} {CAL_DEBUG_EXPORT_MODE_DISABLED}
set_instance_parameter_value emif_a10_hps_0 {DIAG_DDR3_EXPORT_SEQ_AVALON_MASTER} {0}
set_instance_parameter_value emif_a10_hps_0 {DIAG_DDR3_EX_DESIGN_NUM_OF_SLAVES} {1}
set_instance_parameter_value emif_a10_hps_0 {DIAG_DDR3_INTERFACE_ID} {0}
set_instance_parameter_value emif_a10_hps_0 {DIAG_DDR3_EFFICIENCY_MONITOR} {EFFMON_MODE_DISABLED}
set_instance_parameter_value emif_a10_hps_0 {DIAG_DDR3_USE_TG_AVL_2} {0}
set_instance_parameter_value emif_a10_hps_0 {DIAG_DDR3_TG_DATA_PATTERN_LENGTH} {8}
set_instance_parameter_value emif_a10_hps_0 {DIAG_DDR3_TG_BE_PATTERN_LENGTH} {8}
set_instance_parameter_value emif_a10_hps_0 {DIAG_DDR3_CA_LEVEL_EN} {0}

} elseif {$hps_sdram == "D9PZN"} { 
# single rank DDR3 -2133
add_instance emif_a10_hps_0 altera_emif_a10_hps
set_instance_parameter_value emif_a10_hps_0 {PROTOCOL_ENUM} {PROTOCOL_DDR3}
set_instance_parameter_value emif_a10_hps_0 {IS_ED_SLAVE} {0}
set_instance_parameter_value emif_a10_hps_0 {INTERNAL_TESTING_MODE} {0}
set_instance_parameter_value emif_a10_hps_0 {PLL_ADD_EXTRA_CLKS} {0}
set_instance_parameter_value emif_a10_hps_0 {PLL_USER_NUM_OF_EXTRA_CLKS} {0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_0} {0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_1} {0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_2} {0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_3} {0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_4} {0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_DESIRED_FREQ_MHZ_GUI_5} {100.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_5} {100.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_5} {0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_DESIRED_PHASE_GUI_5} {0.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_ACTUAL_PHASE_PS_GUI_5} {0.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_ACTUAL_PHASE_DEG_GUI_5} {0.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_DESIRED_DUTY_CYCLE_GUI_5} {50.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_GUI_5} {50.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_DESIRED_FREQ_MHZ_GUI_6} {100.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_6} {100.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_6} {0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_DESIRED_PHASE_GUI_6} {0.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_ACTUAL_PHASE_PS_GUI_6} {0.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_ACTUAL_PHASE_DEG_GUI_6} {0.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_DESIRED_DUTY_CYCLE_GUI_6} {50.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_GUI_6} {50.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_DESIRED_FREQ_MHZ_GUI_7} {100.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_7} {100.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_7} {0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_DESIRED_PHASE_GUI_7} {0.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_ACTUAL_PHASE_PS_GUI_7} {0.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_ACTUAL_PHASE_DEG_GUI_7} {0.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_DESIRED_DUTY_CYCLE_GUI_7} {50.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_GUI_7} {50.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_DESIRED_FREQ_MHZ_GUI_8} {100.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_8} {100.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_8} {0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_DESIRED_PHASE_GUI_8} {0.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_ACTUAL_PHASE_PS_GUI_8} {0.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_ACTUAL_PHASE_DEG_GUI_8} {0.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_DESIRED_DUTY_CYCLE_GUI_8} {50.0}
set_instance_parameter_value emif_a10_hps_0 {PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_GUI_8} {50.0}

set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_CONFIG_ENUM} {CONFIG_PHY_AND_HARD_CTRL}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_USER_PING_PONG_EN} {0}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_MEM_CLK_FREQ_MHZ} {1066.667}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_DEFAULT_REF_CLK_FREQ} {0}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_USER_REF_CLK_FREQ_MHZ} {133.333}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_REF_CLK_JITTER_PS} {10.0}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_RATE_ENUM} {RATE_HALF}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_CORE_CLKS_SHARING_ENUM} {CORE_CLKS_SHARING_DISABLED}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_IO_VOLTAGE} {1.5}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_DEFAULT_IO} {0}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_CAL_ADDR0} {0}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_CAL_ADDR1} {8}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_CAL_ENABLE_NON_DES} {1}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_USER_AC_IO_STD_ENUM} {IO_STD_SSTL_15_C1}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_USER_AC_MODE_ENUM} {CURRENT_ST_12}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_USER_AC_SLEW_RATE_ENUM} {SLEW_RATE_FAST}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_USER_CK_IO_STD_ENUM} {IO_STD_SSTL_15_C1}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_USER_CK_MODE_ENUM} {CURRENT_ST_12}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_USER_CK_SLEW_RATE_ENUM} {SLEW_RATE_FAST}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_USER_DATA_IO_STD_ENUM} {IO_STD_SSTL_15}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_USER_DATA_OUT_MODE_ENUM} {OUT_OCT_34_CAL}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_USER_DATA_IN_MODE_ENUM} {IN_OCT_120_CAL}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_USER_PLL_REF_CLK_IO_STD_ENUM} {IO_STD_LVDS}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_USER_RZQ_IO_STD_ENUM} {IO_STD_CMOS_15}
if {$early_io_release == 1} {
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR3_HPS_ENABLE_EARLY_RELEASE} {1}
}

set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_FORMAT_ENUM} {MEM_FORMAT_UDIMM}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_DQ_WIDTH} $hps_sdram_width
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_DQ_PER_DQS} {8}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_DISCRETE_CS_WIDTH} {1}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_NUM_OF_DIMMS} {1}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_RANKS_PER_DIMM} {1}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_CKE_PER_DIMM} {1}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_CK_WIDTH} {1}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_ROW_ADDR_WIDTH} {15}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_COL_ADDR_WIDTH} {10}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_BANK_ADDR_WIDTH} {3}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_DM_EN} {1}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_MIRROR_ADDRESSING_EN} {1}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_RDIMM_CONFIG} {0}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_LRDIMM_EXTENDED_CONFIG} {0x0}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_ALERT_N_PLACEMENT_ENUM} {DDR3_ALERT_N_PLACEMENT_AC_LANES}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_ALERT_N_DQS_GROUP} {0}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_BL_ENUM} {DDR3_BL_BL8}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_BT_ENUM} {DDR3_BT_SEQUENTIAL}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_ASR_ENUM} {DDR3_ASR_MANUAL}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_SRT_ENUM} {DDR3_SRT_NORMAL}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_PD_ENUM} {DDR3_PD_OFF}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_DRV_STR_ENUM} {DDR3_DRV_STR_RZQ_7}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_DLL_EN} {1}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_RTT_NOM_ENUM} {DDR3_RTT_NOM_ODT_DISABLED}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_RTT_WR_ENUM} {DDR3_RTT_WR_RZQ_4}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_WTCL} {10}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_ATCL_ENUM} {DDR3_ATCL_DISABLED}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TCL} {14}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_USE_DEFAULT_ODT} {1}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_R_ODTN_1X1} {Rank\ 0}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_R_ODT0_1X1} {off}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_W_ODTN_1X1} {Rank\ 0}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_W_ODT0_1X1} {on}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_R_ODTN_2X2} {Rank\ 0 Rank\ 1}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_R_ODT0_2X2} {off off}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_R_ODT1_2X2} {off off}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_W_ODTN_2X2} {Rank\ 0 Rank\ 1}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_W_ODT0_2X2} {on off}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_W_ODT1_2X2} {off on}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_R_ODTN_4X2} {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_R_ODT0_4X2} {off off on on}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_R_ODT1_4X2} {on on off off}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_W_ODTN_4X2} {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_W_ODT0_4X2} {off off on on}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_W_ODT1_4X2} {on on off off}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_R_ODTN_4X4} {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_R_ODT0_4X4} {off off off off}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_R_ODT1_4X4} {off off on on}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_R_ODT2_4X4} {off off off off}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_R_ODT3_4X4} {on on off off}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_W_ODTN_4X4} {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_W_ODT0_4X4} {on on off off}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_W_ODT1_4X4} {off off on on}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_W_ODT2_4X4} {off off on on}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_W_ODT3_4X4} {on on off off}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_SPEEDBIN_ENUM} {DDR3_SPEEDBIN_2133}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TIS_PS} {60}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TIS_AC_MV} {135}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TIH_PS} {95}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TIH_DC_MV} {100}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TDS_PS} {53}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TDS_AC_MV} {135}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TDH_PS} {55}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TDH_DC_MV} {100}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TDQSQ_PS} {75}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TQH_CYC} {0.38}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TDQSCK_PS} {180}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TDQSS_CYC} {0.27}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TQSH_CYC} {0.4}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TDSH_CYC} {0.18}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TWLS_PS} {125.0}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TWLH_PS} {125.0}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TDSS_CYC} {0.18}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TINIT_US} {500}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TMRD_CK_CYC} {4}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TRAS_NS} {33.0}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TRCD_NS} {13.13}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TRP_NS} {13.13}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TREFI_US} {7.8}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TRFC_NS} {260.0}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TWR_NS} {15.0}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TWTR_CYC} {8}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TFAW_NS} {35.0}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TRRD_CYC} {6}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR3_TRTP_CYC} {8}

set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_USE_DEFAULT_SLEW_RATES} {1}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_USE_DEFAULT_ISI_VALUES} {1}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_USER_CK_SLEW_RATE} {4.0}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_USER_AC_SLEW_RATE} {2.0}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_USER_RCLK_SLEW_RATE} {5.0}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_USER_WCLK_SLEW_RATE} {4.0}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_USER_RDATA_SLEW_RATE} {2.5}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_USER_WDATA_SLEW_RATE} {2.0}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_USER_AC_ISI_NS} {0.0}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_USER_RCLK_ISI_NS} {0.0}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_USER_WCLK_ISI_NS} {0.0}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_USER_RDATA_ISI_NS} {0.0}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_USER_WDATA_ISI_NS} {0.0}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_IS_SKEW_WITHIN_DQS_DESKEWED} {0}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_BRD_SKEW_WITHIN_DQS_NS} {0.02}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_PKG_BRD_SKEW_WITHIN_DQS_NS} {0.02}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_IS_SKEW_WITHIN_AC_DESKEWED} {1}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_BRD_SKEW_WITHIN_AC_NS} {0.02}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_PKG_BRD_SKEW_WITHIN_AC_NS} {0.02}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_DQS_TO_CK_SKEW_NS} {0.02}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_SKEW_BETWEEN_DIMMS_NS} {0.05}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_SKEW_BETWEEN_DQS_NS} {0.02}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_AC_TO_CK_SKEW_NS} {0.0}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_MAX_CK_DELAY_NS} {0.6}
set_instance_parameter_value emif_a10_hps_0 {BOARD_DDR3_MAX_DQS_DELAY_NS} {0.6}

set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_AVL_PROTOCOL_ENUM} {CTRL_AVL_PROTOCOL_ST}
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_SELF_REFRESH_EN} {0}
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_AUTO_POWER_DOWN_EN} {0}
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_AUTO_POWER_DOWN_CYCS} {32}
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_USER_REFRESH_EN} {0}
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_USER_PRIORITY_EN} {0}
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_AUTO_PRECHARGE_EN} {0}
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_ADDR_ORDER_ENUM} {DDR3_CTRL_ADDR_ORDER_CS_R_B_C}
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_ECC_EN} $hps_sdram_ecc
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_ECC_AUTO_CORRECTION_EN} $hps_sdram_ecc
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_REORDER_EN} {1}
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_STARVE_LIMIT} {10}
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_MMR_EN} $hps_sdram_ecc
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_RD_TO_WR_SAME_CHIP_DELTA_CYCS} {0}
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_WR_TO_RD_SAME_CHIP_DELTA_CYCS} {0}
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_RD_TO_RD_DIFF_CHIP_DELTA_CYCS} {0}
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_RD_TO_WR_DIFF_CHIP_DELTA_CYCS} {0}
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_WR_TO_WR_DIFF_CHIP_DELTA_CYCS} {0}
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR3_WR_TO_RD_DIFF_CHIP_DELTA_CYCS} {0}

set_instance_parameter_value emif_a10_hps_0 {DIAG_DDR3_SIM_CAL_MODE_ENUM} {SIM_CAL_MODE_SKIP}
set_instance_parameter_value emif_a10_hps_0 {DIAG_DDR3_EXPORT_SEQ_AVALON_SLAVE} {CAL_DEBUG_EXPORT_MODE_DISABLED}
set_instance_parameter_value emif_a10_hps_0 {DIAG_DDR3_EXPORT_SEQ_AVALON_MASTER} {0}
set_instance_parameter_value emif_a10_hps_0 {DIAG_DDR3_EX_DESIGN_NUM_OF_SLAVES} {1}
set_instance_parameter_value emif_a10_hps_0 {DIAG_DDR3_INTERFACE_ID} {0}
set_instance_parameter_value emif_a10_hps_0 {DIAG_DDR3_EFFICIENCY_MONITOR} {EFFMON_MODE_DISABLED}
set_instance_parameter_value emif_a10_hps_0 {DIAG_DDR3_USE_TG_AVL_2} {0}
set_instance_parameter_value emif_a10_hps_0 {DIAG_DDR3_TG_DATA_PATTERN_LENGTH} {8}
set_instance_parameter_value emif_a10_hps_0 {DIAG_DDR3_TG_BE_PATTERN_LENGTH} {8}
set_instance_parameter_value emif_a10_hps_0 {DIAG_DDR3_CA_LEVEL_EN} {0}

} elseif {$hps_sdram == "D9RGX"} {
# DDR4 single rank -2133
add_instance emif_a10_hps_0 altera_emif_a10_hps
set_validation_property AUTOMATIC_VALIDATION false
#set_instance_parameter_value emif_a10_hps_0 {SHORT_QSYS_INTERFACE_NAMES} {1}
set_instance_parameter_value emif_a10_hps_0 {PROTOCOL_ENUM} {PROTOCOL_DDR4}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR4_RATE_ENUM} {RATE_HALF}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_FORMAT_ENUM} {MEM_FORMAT_UDIMM}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_DQ_WIDTH} $hps_sdram_width
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_TCL} {20}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_WTCL} {18}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_ALERT_N_PLACEMENT_ENUM} {DDR4_ALERT_N_PLACEMENT_DATA_LANES}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_ALERT_N_DQS_GROUP} {3}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_ALERT_PAR_EN} {1}
set_instance_parameter_value emif_a10_hps_0 {DIAG_DDR4_SKIP_CA_LEVEL} {1}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_NUM_OF_DIMMS} {1}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_RANKS_PER_DIMM} {1}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_CK_WIDTH} {1}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_READ_PREAMBLE} {2}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_WRITE_PREAMBLE} {1}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_RTT_WR_ENUM} {DDR4_RTT_WR_ODT_DISABLED}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_DRV_STR_ENUM} {DDR4_DRV_STR_RZQ_7}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_RTT_NOM_ENUM} {DDR4_RTT_NOM_RZQ_6}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_DM_EN} {1}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_READ_DBI} {1}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_WRITE_DBI} {0}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR4_CONFIG_ENUM} {CONFIG_PHY_AND_HARD_CTRL}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR4_USER_REF_CLK_FREQ_MHZ} {133.333}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR4_DEFAULT_REF_CLK_FREQ} {0}
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR4_ECC_EN} $hps_sdram_ecc
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR4_ECC_AUTO_CORRECTION_EN} $hps_sdram_ecc
set_instance_parameter_value emif_a10_hps_0 {CTRL_DDR4_MMR_EN} $hps_sdram_ecc
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR4_DEFAULT_IO} {0}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR4_USER_AC_IO_STD_ENUM} {IO_STD_SSTL_12}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR4_USER_CK_IO_STD_ENUM} {IO_STD_SSTL_12}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR4_USER_DATA_IO_STD_ENUM} {IO_STD_POD_12}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR4_USER_AC_MODE_ENUM} {OUT_OCT_40_CAL}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR4_USER_CK_MODE_ENUM} {OUT_OCT_40_CAL}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR4_USER_DATA_OUT_MODE_ENUM} {OUT_OCT_34_CAL}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR4_USER_DATA_IN_MODE_ENUM} {IN_OCT_60_CAL}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR4_USER_PLL_REF_CLK_IO_STD_ENUM} {IO_STD_LVDS}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR4_USER_RZQ_IO_STD_ENUM} {IO_STD_CMOS_12}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR4_MEM_CLK_FREQ_MHZ} {1066.667}
if {$early_io_release == 1} {
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR4_HPS_ENABLE_EARLY_RELEASE} {1}
}

set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_SPEEDBIN_ENUM} {DDR4_SPEEDBIN_2666}
set_instance_parameter_value emif_a10_hps_0 {PHY_DDR4_IO_VOLTAGE} {1.2}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_DISCRETE_CS_WIDTH} {1}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_DQ_PER_DQS} {8}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_BANK_ADDR_WIDTH} {2}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_BANK_GROUP_WIDTH} {1}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_COL_ADDR_WIDTH} {10}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_ROW_ADDR_WIDTH} {15}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_TIH_PS} {95}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_TIH_DC_MV} {75}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_TIS_PS} {60}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_TIS_AC_MV} {100}
### 3 settings for 15.1 and beyond
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_TDIVW_TOTAL_UI} {0.2}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_TDQSQ_UI} {0.16}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_TQH_UI} {0.76}
### 3 setting for 15.0
# set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_TDIVW_DJ_CYC} {0.1}
# set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_TDQSQ_PS} {66}
# set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_TQH_CYC} {0.38}
#---------------------------
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_VDIVW_TOTAL} {136}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_TQSH_CYC} {0.38}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_TDQSCK_PS} {165}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_TDQSS_CYC} {0.27}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_TDSH_CYC} {0.18}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_TDSS_CYC} {0.18}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_TWLS_PS} {108.0}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_TWLH_PS} {108.0}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_TINIT_US} {500}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_TMRD_CK_CYC} {8}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_TRAS_NS} {32.0}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_TRCD_NS} {14.25}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_TRP_NS} {14.25}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_TREFI_US} {7.8}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_TRFC_NS} {260.0}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_TWR_NS} {15.0}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_TWTR_L_CYC} {10}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_TWTR_S_CYC} {4}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_TFAW_NS} {30.0}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_TRRD_L_CYC} {8}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_TRRD_S_CYC} {7}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_TCCD_L_CYC} {6}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_TCCD_S_CYC} {4}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_RDIMM_CONFIG} {0}
set_instance_parameter_value emif_a10_hps_0 {MEM_DDR4_LRDIMM_EXTENDED_CONFIG} {0x0}

set_validation_property AUTOMATIC_VALIDATION true

} else {
# No valid SDRAM device selected
}

if {$fast_trace == 1} {
add_instance trace_wrapper_0 altera_trace_wrapper 
set_instance_parameter_value trace_wrapper_0 {IN_DWIDTH} {32}
set_instance_parameter_value trace_wrapper_0 {NUM_PIPELINE_REG} {1}
}

add_instance hps_m altera_jtag_avalon_master
set_instance_parameter_value hps_m {USE_PLI} {0}
set_instance_parameter_value hps_m {PLI_PORT} {50000}
set_instance_parameter_value hps_m {FAST_VER} {0}
set_instance_parameter_value hps_m {FIFO_DEPTHS} {2}

if {$fpga_pcie == 0} {
add_instance f2sdram_m altera_jtag_avalon_master 
set_instance_parameter_value f2sdram_m {USE_PLI} {0}
set_instance_parameter_value f2sdram_m {PLI_PORT} {50000}
set_instance_parameter_value f2sdram_m {FAST_VER} {0}
set_instance_parameter_value f2sdram_m {FIFO_DEPTHS} {2}
}

if {$board_rev != "A"} {
add_instance f2sdram_m1 altera_jtag_avalon_master 
set_instance_parameter_value f2sdram_m1 {USE_PLI} {0}
set_instance_parameter_value f2sdram_m1 {PLI_PORT} {50000}
set_instance_parameter_value f2sdram_m1 {FAST_VER} {0}
set_instance_parameter_value f2sdram_m1 {FIFO_DEPTHS} {2}
}

add_instance fpga_m altera_jtag_avalon_master
set_instance_parameter_value fpga_m {USE_PLI} {0}
set_instance_parameter_value fpga_m {PLI_PORT} {50000}
set_instance_parameter_value fpga_m {FAST_VER} {0}
set_instance_parameter_value fpga_m {FIFO_DEPTHS} {2}

add_instance onchip_memory2_0 altera_avalon_onchip_memory2
set_instance_parameter_value onchip_memory2_0 {allowInSystemMemoryContentEditor} {0}
set_instance_parameter_value onchip_memory2_0 {blockType} {AUTO}
if {$fpga_pcie == 1} {
   if {$board_rev == "A" || $pcie_gen == 3 || $pcie_count == 8} {
   set_instance_parameter_value onchip_memory2_0 {dataWidth} {256}
   } else {
   set_instance_parameter_value onchip_memory2_0 {dataWidth} {128}
   }
} else {
set_instance_parameter_value onchip_memory2_0 {dataWidth} $OCM_WIDTH
}
set_instance_parameter_value onchip_memory2_0 {dualPort} {0}
set_instance_parameter_value onchip_memory2_0 {initMemContent} {1}
set_instance_parameter_value onchip_memory2_0 {initializationFileName} {onchip_mem.hex}
set_instance_parameter_value onchip_memory2_0 {instanceID} {NONE}
set_instance_parameter_value onchip_memory2_0 {memorySize} {262144.0}
set_instance_parameter_value onchip_memory2_0 {readDuringWriteMode} {DONT_CARE}
set_instance_parameter_value onchip_memory2_0 {simAllowMRAMContentsFile} {0}
set_instance_parameter_value onchip_memory2_0 {simMemInitOnlyFilename} {0}
set_instance_parameter_value onchip_memory2_0 {singleClockOperation} {1}
set_instance_parameter_value onchip_memory2_0 {slave1Latency} {1}
set_instance_parameter_value onchip_memory2_0 {slave2Latency} {1}
set_instance_parameter_value onchip_memory2_0 {useNonDefaultInitFile} {0}
set_instance_parameter_value onchip_memory2_0 {copyInitFile} {0}
set_instance_parameter_value onchip_memory2_0 {useShallowMemBlocks} {0}
set_instance_parameter_value onchip_memory2_0 {writable} {1}
set_instance_parameter_value onchip_memory2_0 {ecc_enabled} {0}
set_instance_parameter_value onchip_memory2_0 {resetrequest_enabled} {1}

add_instance pb_lwh2f altera_avalon_mm_bridge
set_instance_parameter_value pb_lwh2f {DATA_WIDTH} {32}
set_instance_parameter_value pb_lwh2f {SYMBOL_WIDTH} {8}
set_instance_parameter_value pb_lwh2f {ADDRESS_WIDTH} {20}
set_instance_parameter_value pb_lwh2f {USE_AUTO_ADDRESS_WIDTH} {1}
set_instance_parameter_value pb_lwh2f {ADDRESS_UNITS} {SYMBOLS}
set_instance_parameter_value pb_lwh2f {MAX_BURST_SIZE} {1}
set_instance_parameter_value pb_lwh2f {MAX_PENDING_RESPONSES} {1}
set_instance_parameter_value pb_lwh2f {LINEWRAPBURSTS} {0}
set_instance_parameter_value pb_lwh2f {PIPELINE_COMMAND} {1}
set_instance_parameter_value pb_lwh2f {PIPELINE_RESPONSE} {1}

add_instance sysid_qsys_0 altera_avalon_sysid_qsys
set_instance_parameter_value sysid_qsys_0 {id} $SYSID

if {$pr_enable == 1} {

add_instance frz_ctrl_0 altera_freeze_controller  
set_instance_parameter_value frz_ctrl_0 {ENABLE_CSR} {1}
if {$fpga_dp == 1} {
set_instance_parameter_value frz_ctrl_0 {NUM_INTF_BRIDGE} {3}
} else {
set_instance_parameter_value frz_ctrl_0 {NUM_INTF_BRIDGE} {1}
}

if {$fpga_dp == 0} {
add_instance pr_region_0 pr_region

add_instance freeze_bridge_0 altera_freeze_bridge  
set_instance_parameter_value freeze_bridge_0 {Interface_Type} {Avalon-MM Slave}
set_instance_parameter_value freeze_bridge_0 {slv_bridge_signal_Enable} {Yes No Yes Yes Yes Yes Yes Yes Yes Yes Yes No No No}
set_instance_parameter_value freeze_bridge_0 {SLV_BRIDGE_ADDR_WIDTH} {10}
set_instance_parameter_value freeze_bridge_0 {SLV_BRIDGE_SYMBOL_WIDTH} {8}
set_instance_parameter_value freeze_bridge_0 {SLV_BRIDGE_BYTEEN_WIDTH} {4}
set_instance_parameter_value freeze_bridge_0 {SLV_BRIDGE_BURSTCOUNT_WIDTH} {1}
set_instance_parameter_value freeze_bridge_0 {SLV_BRIDGE_BURST_LINEWRAP} {0}
set_instance_parameter_value freeze_bridge_0 {SLV_BRIDGE_BURST_BNDR_ONLY} {1}
set_instance_parameter_value freeze_bridge_0 {SLV_BRIDGE_MAX_PENDING_READS} {1}
set_instance_parameter_value freeze_bridge_0 {SLV_BRIDGE_MAX_PENDING_WRITES} {0}
set_instance_parameter_value freeze_bridge_0 {SLV_BRIDGE_FIX_READ_LATENCY} {0}
set_instance_parameter_value freeze_bridge_0 {SLV_BRIDGE_READ_WAIT_TIME} {1}
set_instance_parameter_value freeze_bridge_0 {SLV_BRIDGE_WRITE_WAIT_TIME} {0}
set_instance_parameter_value freeze_bridge_0 {SLV_BRIDGE_ADDRESS_UNITS} {SYMBOLS}
set_instance_parameter_value freeze_bridge_0 {mst_bridge_signal_Enable} {Yes Yes Yes Yes Yes Yes Yes Yes Yes Yes Yes}
set_instance_parameter_value freeze_bridge_0 {MST_BRIDGE_ADDR_WIDTH} {32}
set_instance_parameter_value freeze_bridge_0 {MST_BRIDGE_SYMBOL_WIDTH} {8}
set_instance_parameter_value freeze_bridge_0 {MST_BRIDGE_BYTEEN_WIDTH} {4}
set_instance_parameter_value freeze_bridge_0 {MST_BRIDGE_BURSTCOUNT_WIDTH} {3}
set_instance_parameter_value freeze_bridge_0 {MST_BRIDGE_BURST_LINEWRAP} {1}
set_instance_parameter_value freeze_bridge_0 {MST_BRIDGE_BURST_BNDR_ONLY} {1}
set_instance_parameter_value freeze_bridge_0 {MST_BRIDGE_MAX_PENDING_READS} {1}
set_instance_parameter_value freeze_bridge_0 {MST_BRIDGE_MAX_PENDING_WRITES} {0}
set_instance_parameter_value freeze_bridge_0 {MST_BRIDGE_FIX_READ_LATENCY} {0}
set_instance_parameter_value freeze_bridge_0 {MST_BRIDGE_READ_WAIT_TIME} {1}
set_instance_parameter_value freeze_bridge_0 {MST_BRIDGE_WRITE_WAIT_TIME} {0}
set_instance_parameter_value freeze_bridge_0 {MST_BRIDGE_ADDRESS_UNITS} {SYMBOLS}
}

if {$freeze_ack_dly_enable == 1} {
add_instance stop_ack_pio altera_avalon_pio
set_instance_parameter_value stop_ack_pio {bitClearingEdgeCapReg} {0}
set_instance_parameter_value stop_ack_pio {bitModifyingOutReg} {0}
set_instance_parameter_value stop_ack_pio {captureEdge} {0}
set_instance_parameter_value stop_ack_pio {direction} {Output}
set_instance_parameter_value stop_ack_pio {edgeType} {RISING}
set_instance_parameter_value stop_ack_pio {generateIRQ} {0}
set_instance_parameter_value stop_ack_pio {irqType} {LEVEL}
set_instance_parameter_value stop_ack_pio {resetValue} {0.0}
set_instance_parameter_value stop_ack_pio {simDoTestBenchWiring} {0}
set_instance_parameter_value stop_ack_pio {simDrivenValue} {0.0}
set_instance_parameter_value stop_ack_pio {width} {32}

add_instance start_ack_pio altera_avalon_pio
set_instance_parameter_value start_ack_pio {bitClearingEdgeCapReg} {0}
set_instance_parameter_value start_ack_pio {bitModifyingOutReg} {0}
set_instance_parameter_value start_ack_pio {captureEdge} {0}
set_instance_parameter_value start_ack_pio {direction} {Output}
set_instance_parameter_value start_ack_pio {edgeType} {RISING}
set_instance_parameter_value start_ack_pio {generateIRQ} {0}
set_instance_parameter_value start_ack_pio {irqType} {LEVEL}
set_instance_parameter_value start_ack_pio {resetValue} {0.0}
set_instance_parameter_value start_ack_pio {simDoTestBenchWiring} {0}
set_instance_parameter_value start_ack_pio {simDrivenValue} {0.0}
set_instance_parameter_value start_ack_pio {width} {32}

add_instance frz_ack_pio altera_avalon_pio
set_instance_parameter_value frz_ack_pio {bitClearingEdgeCapReg} {0}
set_instance_parameter_value frz_ack_pio {bitModifyingOutReg} {0}
set_instance_parameter_value frz_ack_pio {captureEdge} {0}
set_instance_parameter_value frz_ack_pio {direction} {Output}
set_instance_parameter_value frz_ack_pio {edgeType} {RISING}
set_instance_parameter_value frz_ack_pio {generateIRQ} {0}
set_instance_parameter_value frz_ack_pio {irqType} {LEVEL}
set_instance_parameter_value frz_ack_pio {resetValue} {0.0}
set_instance_parameter_value frz_ack_pio {simDoTestBenchWiring} {0}
set_instance_parameter_value frz_ack_pio {simDrivenValue} {0.0}
set_instance_parameter_value frz_ack_pio {width} {32}
}
}

add_instance led_pio altera_avalon_pio
set_instance_parameter_value led_pio {bitClearingEdgeCapReg} {0}
set_instance_parameter_value led_pio {bitModifyingOutReg} {0}
set_instance_parameter_value led_pio {captureEdge} {0}
set_instance_parameter_value led_pio {direction} {InOut}
set_instance_parameter_value led_pio {edgeType} {RISING}
set_instance_parameter_value led_pio {generateIRQ} {0}
set_instance_parameter_value led_pio {irqType} {LEVEL}
set_instance_parameter_value led_pio {resetValue} {0.0}
set_instance_parameter_value led_pio {simDoTestBenchWiring} {0}
set_instance_parameter_value led_pio {simDrivenValue} {0.0}
set_instance_parameter_value led_pio {width} {4}

add_instance button_pio altera_avalon_pio
set_instance_parameter_value button_pio {bitClearingEdgeCapReg} {1}
set_instance_parameter_value button_pio {bitModifyingOutReg} {0}
set_instance_parameter_value button_pio {captureEdge} {1}
set_instance_parameter_value button_pio {direction} {Input}
set_instance_parameter_value button_pio {edgeType} {FALLING}
set_instance_parameter_value button_pio {generateIRQ} {1}
set_instance_parameter_value button_pio {irqType} {EDGE}
set_instance_parameter_value button_pio {resetValue} {0.0}
set_instance_parameter_value button_pio {simDoTestBenchWiring} {0}
set_instance_parameter_value button_pio {simDrivenValue} {0.0}
set_instance_parameter_value button_pio {width} {4}

add_instance dipsw_pio altera_avalon_pio 
set_instance_parameter_value dipsw_pio {bitClearingEdgeCapReg} {1}
set_instance_parameter_value dipsw_pio {bitModifyingOutReg} {0}
set_instance_parameter_value dipsw_pio {captureEdge} {1}
set_instance_parameter_value dipsw_pio {direction} {Input}
set_instance_parameter_value dipsw_pio {edgeType} {ANY}
set_instance_parameter_value dipsw_pio {generateIRQ} {1}
set_instance_parameter_value dipsw_pio {irqType} {EDGE}
set_instance_parameter_value dipsw_pio {resetValue} {0.0}
set_instance_parameter_value dipsw_pio {simDoTestBenchWiring} {0}
set_instance_parameter_value dipsw_pio {simDrivenValue} {0.0}
set_instance_parameter_value dipsw_pio {width} {4}

add_instance ILC interrupt_latency_counter 
set_instance_parameter_value ILC {INTR_TYPE} {0}
if {$pr_enable == 1} {
set_instance_parameter_value ILC {IRQ_PORT_CNT} {3}
} else {
set_instance_parameter_value ILC {IRQ_PORT_CNT} {2}
}

if {$hps_i2c_fpga_if == 1} {
add_instance i2c1_sda_buff altera_gpio
set_instance_parameter_value i2c1_sda_buff {PIN_TYPE_GUI} {Bidir}
set_instance_parameter_value i2c1_sda_buff {SIZE} {1}
set_instance_parameter_value i2c1_sda_buff {gui_enable_migratable_port_names} {0}
set_instance_parameter_value i2c1_sda_buff {gui_diff_buff} {0}
set_instance_parameter_value i2c1_sda_buff {gui_pseudo_diff} {1}
set_instance_parameter_value i2c1_sda_buff {gui_bus_hold} {0}
set_instance_parameter_value i2c1_sda_buff {gui_open_drain} {1}
set_instance_parameter_value i2c1_sda_buff {gui_use_oe} {0}
set_instance_parameter_value i2c1_sda_buff {gui_enable_termination_ports} {0}
set_instance_parameter_value i2c1_sda_buff {gui_io_reg_mode} {none}
set_instance_parameter_value i2c1_sda_buff {gui_sreset_mode} {None}
set_instance_parameter_value i2c1_sda_buff {gui_areset_mode} {None}
set_instance_parameter_value i2c1_sda_buff {gui_enable_cke} {0}
set_instance_parameter_value i2c1_sda_buff {gui_hr_logic} {0}
set_instance_parameter_value i2c1_sda_buff {gui_separate_io_clks} {0}

add_instance i2c1_scl_buff altera_gpio
set_instance_parameter_value i2c1_scl_buff {PIN_TYPE_GUI} {Bidir}
set_instance_parameter_value i2c1_scl_buff {SIZE} {1}
set_instance_parameter_value i2c1_scl_buff {gui_enable_migratable_port_names} {0}
set_instance_parameter_value i2c1_scl_buff {gui_diff_buff} {0}
set_instance_parameter_value i2c1_scl_buff {gui_pseudo_diff} {1}
set_instance_parameter_value i2c1_scl_buff {gui_bus_hold} {0}
set_instance_parameter_value i2c1_scl_buff {gui_open_drain} {1}
set_instance_parameter_value i2c1_scl_buff {gui_use_oe} {0}
set_instance_parameter_value i2c1_scl_buff {gui_enable_termination_ports} {0}
set_instance_parameter_value i2c1_scl_buff {gui_io_reg_mode} {none}
set_instance_parameter_value i2c1_scl_buff {gui_sreset_mode} {None}
set_instance_parameter_value i2c1_scl_buff {gui_areset_mode} {None}
set_instance_parameter_value i2c1_scl_buff {gui_enable_cke} {0}
set_instance_parameter_value i2c1_scl_buff {gui_hr_logic} {0}
set_instance_parameter_value i2c1_scl_buff {gui_separate_io_clks} {0}
}

if {$hps_sgmii == 1} {
for {set x 1} {$x<=$sgmii_count} {incr x} {
add_instance sgmii_$x subsys_sgmii
### If we want to support user specific subsystem name then subsystem name needed while sourcing the construct_*, and matching
#add_instance sgmii_$x $sgmii_sub_system_name
}
if {$sgmii_count > 1} {
add_instance clock_bridge_enet altera_clock_bridge 
set_instance_parameter_value clock_bridge_enet {EXPLICIT_CLOCK_RATE} {125000000.0}
set_instance_parameter_value clock_bridge_enet {NUM_CLOCK_OUTPUTS} {1}
}
}

if {$fpga_dp == 1} {
add_instance display_port subsys_dp
### If we want to support user specific subsystem name then subsystem name needed while sourcing the construct_*, and matching
#add_instance display_port $displayport_sub_system_name
}

if {$fpga_pcie == 1} {
add_instance pcie_0 subsys_pcie
}

add_instance issp_0 altera_in_system_sources_probes 
set_instance_parameter_value issp_0 {gui_use_auto_index} {1}
set_instance_parameter_value issp_0 {sld_instance_index} {0}
set_instance_parameter_value issp_0 {instance_id} {RST}
set_instance_parameter_value issp_0 {probe_width} {0}
set_instance_parameter_value issp_0 {source_width} {3}
set_instance_parameter_value issp_0 {source_initial_value} {0}
set_instance_parameter_value issp_0 {create_source_clock} {1}
set_instance_parameter_value issp_0 {create_source_clock_enable} {0}



########################################################### 
# connections and connection parameters                   #
###########################################################
if {$hps_sgmii == 1} {
for {set x 1} {$x<=$sgmii_count} {incr x} {
add_connection clk_0.clk sgmii_${x}.clk 
add_connection clk_0.clk_reset sgmii_${x}.reset 
add_connection arria10_hps_0.h2f_reset sgmii_${x}.reset 

add_connection arria10_hps_0.emac${x} sgmii_${x}.emac 
set_connection_parameter_value arria10_hps_0.emac${x}/sgmii_${x}.emac endPort {}
set_connection_parameter_value arria10_hps_0.emac${x}/sgmii_${x}.emac endPortLSB {0}
set_connection_parameter_value arria10_hps_0.emac${x}/sgmii_${x}.emac startPort {}
set_connection_parameter_value arria10_hps_0.emac${x}/sgmii_${x}.emac startPortLSB {0}
set_connection_parameter_value arria10_hps_0.emac${x}/sgmii_${x}.emac width {0}

add_connection sgmii_${x}.emac_tx_clk_in arria10_hps_0.emac${x}_tx_clk_in 
add_connection sgmii_${x}.emac_rx_clk_in arria10_hps_0.emac${x}_rx_clk_in 
add_connection arria10_hps_0.emac${x}_gtx_clk sgmii_${x}.emac_gtx_clk 
add_connection arria10_hps_0.emac${x}_rx_reset sgmii_${x}.emac_rx_reset 
add_connection arria10_hps_0.emac${x}_tx_reset sgmii_${x}.emac_tx_reset 

add_connection pb_lwh2f.m0 sgmii_${x}.gmii_to_sgmii_adapter_avalon_slave 
set_connection_parameter_value pb_lwh2f.m0/sgmii_${x}.gmii_to_sgmii_adapter_avalon_slave arbitrationPriority {1}
set_connection_parameter_value pb_lwh2f.m0/sgmii_${x}.gmii_to_sgmii_adapter_avalon_slave baseAddress [expr [expr $x* 0x0200] + 0x40]
set_connection_parameter_value pb_lwh2f.m0/sgmii_${x}.gmii_to_sgmii_adapter_avalon_slave defaultConnection {0}

add_connection pb_lwh2f.m0 sgmii_${x}.pcs_control_port 
set_connection_parameter_value pb_lwh2f.m0/sgmii_${x}.pcs_control_port arbitrationPriority {1}
set_connection_parameter_value pb_lwh2f.m0/sgmii_${x}.pcs_control_port baseAddress [expr $x* 0x0200]
set_connection_parameter_value pb_lwh2f.m0/sgmii_${x}.pcs_control_port defaultConnection {0}
}
}

if {$fpga_dp == 1} {
if {$frame_buffer == 1} {
add_connection display_port.alt_vip_cl_vfb_0_mem_master_rd arria10_hps_0.f2h_axi_slave avalon
set_connection_parameter_value display_port.alt_vip_cl_vfb_0_mem_master_rd/arria10_hps_0.f2h_axi_slave arbitrationPriority {1}
set_connection_parameter_value display_port.alt_vip_cl_vfb_0_mem_master_rd/arria10_hps_0.f2h_axi_slave baseAddress {0x0000}
set_connection_parameter_value display_port.alt_vip_cl_vfb_0_mem_master_rd/arria10_hps_0.f2h_axi_slave defaultConnection {0}

add_connection pb_lwh2f.m0 display_port.alt_vip_cl_vfb_0_control avalon
set_connection_parameter_value pb_lwh2f.m0/display_port.alt_vip_cl_vfb_0_control arbitrationPriority {1}
set_connection_parameter_value pb_lwh2f.m0/display_port.alt_vip_cl_vfb_0_control baseAddress {0x0280}
set_connection_parameter_value pb_lwh2f.m0/display_port.alt_vip_cl_vfb_0_control defaultConnection {0}

add_connection arria10_hps_0.f2h_irq0 display_port.alt_vip_cl_vfb_0_control_interrupt interrupt
set_connection_parameter_value arria10_hps_0.f2h_irq0/display_port.alt_vip_cl_vfb_0_control_interrupt irqNumber {6}
}

add_connection clk_0.clk display_port.clk_100 

add_connection clock_bridge_0.out_clk display_port.clk_vip 

add_connection clk_0.clk_reset display_port.resetn 

add_connection arria10_hps_0.h2f_reset display_port.resetn 

}

if {$fpga_pcie == 1} {
add_connection pcie_0.pb_2_ocm_m0 onchip_memory2_0.s1 
set_connection_parameter_value pcie_0.pb_2_ocm_m0/onchip_memory2_0.s1 arbitrationPriority {1}
set_connection_parameter_value pcie_0.pb_2_ocm_m0/onchip_memory2_0.s1 baseAddress {0x0000}
set_connection_parameter_value pcie_0.pb_2_ocm_m0/onchip_memory2_0.s1 defaultConnection {0}

add_connection pb_lwh2f.m0 pcie_0.pb_lwh2f_pcie_s0 
set_connection_parameter_value pb_lwh2f.m0/pcie_0.pb_lwh2f_pcie_s0 arbitrationPriority {1}
set_connection_parameter_value pb_lwh2f.m0/pcie_0.pb_lwh2f_pcie_s0 baseAddress {0x00010000}
set_connection_parameter_value pb_lwh2f.m0/pcie_0.pb_lwh2f_pcie_s0 defaultConnection {0}

if {$board_rev == "A"} {  
add_connection pcie_0.address_span_extender_0_expanded_master arria10_hps_0.f2sdram1_data 
set_connection_parameter_value pcie_0.address_span_extender_0_expanded_master/arria10_hps_0.f2sdram1_data arbitrationPriority {1}
set_connection_parameter_value pcie_0.address_span_extender_0_expanded_master/arria10_hps_0.f2sdram1_data baseAddress {0x0000}
set_connection_parameter_value pcie_0.address_span_extender_0_expanded_master/arria10_hps_0.f2sdram1_data defaultConnection {0}

add_connection pcie_0.coreclkout_out iopll_0.refclk 

add_connection iopll_0.outclk0 pcie_0.clk_200_in_clk 

add_connection clk_0.clk_reset iopll_0.reset    

add_connection arria10_hps_0.h2f_reset iopll_0.reset 
} else  {
add_connection pcie_0.address_span_extender_0_expanded_master arria10_hps_0.f2sdram2_data 
set_connection_parameter_value pcie_0.address_span_extender_0_expanded_master/arria10_hps_0.f2sdram2_data arbitrationPriority {1}
set_connection_parameter_value pcie_0.address_span_extender_0_expanded_master/arria10_hps_0.f2sdram2_data baseAddress {0x0000}
set_connection_parameter_value pcie_0.address_span_extender_0_expanded_master/arria10_hps_0.f2sdram2_data defaultConnection {0}
}
add_connection arria10_hps_0.h2f_axi_master pcie_0.ccb_h2f_s0 
set_connection_parameter_value arria10_hps_0.h2f_axi_master/pcie_0.ccb_h2f_s0 arbitrationPriority {1}
set_connection_parameter_value arria10_hps_0.h2f_axi_master/pcie_0.ccb_h2f_s0 baseAddress {0x10000000}
set_connection_parameter_value arria10_hps_0.h2f_axi_master/pcie_0.ccb_h2f_s0 defaultConnection {0}

add_connection clk_0.clk pcie_0.clk 

add_connection arria10_hps_0.f2h_irq0 pcie_0.msgdma_0_csr_irq 
set_connection_parameter_value arria10_hps_0.f2h_irq0/pcie_0.msgdma_0_csr_irq irqNumber {4}

add_connection arria10_hps_0.f2h_irq0 pcie_0.msi_to_gic_gen_0_interrupt_sender 
set_connection_parameter_value arria10_hps_0.f2h_irq0/pcie_0.msi_to_gic_gen_0_interrupt_sender irqNumber {3}

add_connection arria10_hps_0.f2h_irq0 pcie_0.pcie_a10_hip_avmm_cra_irq 
set_connection_parameter_value arria10_hps_0.f2h_irq0/pcie_0.pcie_a10_hip_avmm_cra_irq irqNumber {5}

add_connection clk_0.clk_reset pcie_0.reset 

add_connection arria10_hps_0.h2f_reset pcie_0.reset 

} else {
add_connection clk_0.clk f2sdram_m.clk 

add_connection clk_0.clk_reset f2sdram_m.clk_reset 

add_connection arria10_hps_0.h2f_reset f2sdram_m.clk_reset 

if {$board_rev == "A"} { 
add_connection f2sdram_m.master arria10_hps_0.f2sdram1_data 
set_connection_parameter_value f2sdram_m.master/arria10_hps_0.f2sdram1_data arbitrationPriority {1}
set_connection_parameter_value f2sdram_m.master/arria10_hps_0.f2sdram1_data baseAddress {0x0000}
set_connection_parameter_value f2sdram_m.master/arria10_hps_0.f2sdram1_data defaultConnection {0}
} else {
add_connection f2sdram_m.master arria10_hps_0.f2sdram2_data 
set_connection_parameter_value f2sdram_m.master/arria10_hps_0.f2sdram2_data arbitrationPriority {1}
set_connection_parameter_value f2sdram_m.master/arria10_hps_0.f2sdram2_data baseAddress {0x0000}
set_connection_parameter_value f2sdram_m.master/arria10_hps_0.f2sdram2_data defaultConnection {0}
}
}

if {$pr_enable == 1} {
add_connection pb_lwh2f.m0 frz_ctrl_0.avl_csr
set_connection_parameter_value pb_lwh2f.m0/frz_ctrl_0.avl_csr arbitrationPriority {1}
set_connection_parameter_value pb_lwh2f.m0/frz_ctrl_0.avl_csr baseAddress {0x0450}
set_connection_parameter_value pb_lwh2f.m0/frz_ctrl_0.avl_csr defaultConnection {0}

add_connection clk_0.clk frz_ctrl_0.clock

add_connection ILC.irq frz_ctrl_0.interrupt_sender
set_connection_parameter_value ILC.irq/frz_ctrl_0.interrupt_sender irqNumber {2}

add_connection arria10_hps_0.f2h_irq0 frz_ctrl_0.interrupt_sender
set_connection_parameter_value arria10_hps_0.f2h_irq0/frz_ctrl_0.interrupt_sender irqNumber {2}

add_connection clk_0.clk_reset frz_ctrl_0.reset_n

add_connection arria10_hps_0.h2f_reset frz_ctrl_0.reset_n

if {$fpga_dp == 1} {
add_connection display_port.freeze_bridge_0_freeze_conduit_in frz_ctrl_0.freeze_conduit_out0 
set_connection_parameter_value display_port.freeze_bridge_0_freeze_conduit_in/frz_ctrl_0.freeze_conduit_out0 endPort {}
set_connection_parameter_value display_port.freeze_bridge_0_freeze_conduit_in/frz_ctrl_0.freeze_conduit_out0 endPortLSB {0}
set_connection_parameter_value display_port.freeze_bridge_0_freeze_conduit_in/frz_ctrl_0.freeze_conduit_out0 startPort {}
set_connection_parameter_value display_port.freeze_bridge_0_freeze_conduit_in/frz_ctrl_0.freeze_conduit_out0 startPortLSB {0}
set_connection_parameter_value display_port.freeze_bridge_0_freeze_conduit_in/frz_ctrl_0.freeze_conduit_out0 width {0}

add_connection frz_ctrl_0.freeze_conduit_in0 display_port.freeze_bridge_0_freeze_conduit_out 
set_connection_parameter_value frz_ctrl_0.freeze_conduit_in0/display_port.freeze_bridge_0_freeze_conduit_out endPort {}
set_connection_parameter_value frz_ctrl_0.freeze_conduit_in0/display_port.freeze_bridge_0_freeze_conduit_out endPortLSB {0}
set_connection_parameter_value frz_ctrl_0.freeze_conduit_in0/display_port.freeze_bridge_0_freeze_conduit_out startPort {}
set_connection_parameter_value frz_ctrl_0.freeze_conduit_in0/display_port.freeze_bridge_0_freeze_conduit_out startPortLSB {0}
set_connection_parameter_value frz_ctrl_0.freeze_conduit_in0/display_port.freeze_bridge_0_freeze_conduit_out width {0}

add_connection frz_ctrl_0.freeze_conduit_in1 display_port.mixer_0_conduit_bridge_1_freeze_conduit_out
set_connection_parameter_value frz_ctrl_0.freeze_conduit_in1/display_port.mixer_0_conduit_bridge_1_freeze_conduit_out endPort {}
set_connection_parameter_value frz_ctrl_0.freeze_conduit_in1/display_port.mixer_0_conduit_bridge_1_freeze_conduit_out endPortLSB {0}
set_connection_parameter_value frz_ctrl_0.freeze_conduit_in1/display_port.mixer_0_conduit_bridge_1_freeze_conduit_out startPort {}
set_connection_parameter_value frz_ctrl_0.freeze_conduit_in1/display_port.mixer_0_conduit_bridge_1_freeze_conduit_out startPortLSB {0}
set_connection_parameter_value frz_ctrl_0.freeze_conduit_in1/display_port.mixer_0_conduit_bridge_1_freeze_conduit_out width {0}

add_connection frz_ctrl_0.freeze_conduit_in2 display_port.mixer_0_conduit_bridge_0_freeze_conduit_out
set_connection_parameter_value frz_ctrl_0.freeze_conduit_in2/display_port.mixer_0_conduit_bridge_0_freeze_conduit_out endPort {}
set_connection_parameter_value frz_ctrl_0.freeze_conduit_in2/display_port.mixer_0_conduit_bridge_0_freeze_conduit_out endPortLSB {0}
set_connection_parameter_value frz_ctrl_0.freeze_conduit_in2/display_port.mixer_0_conduit_bridge_0_freeze_conduit_out startPort {}
set_connection_parameter_value frz_ctrl_0.freeze_conduit_in2/display_port.mixer_0_conduit_bridge_0_freeze_conduit_out startPortLSB {0}
set_connection_parameter_value frz_ctrl_0.freeze_conduit_in2/display_port.mixer_0_conduit_bridge_0_freeze_conduit_out width {0}

add_connection display_port.mixer_0_conduit_bridge_1_freeze_conduit_in frz_ctrl_0.freeze_conduit_out1 
set_connection_parameter_value display_port.mixer_0_conduit_bridge_1_freeze_conduit_in/frz_ctrl_0.freeze_conduit_out1 endPort {}
set_connection_parameter_value display_port.mixer_0_conduit_bridge_1_freeze_conduit_in/frz_ctrl_0.freeze_conduit_out1 endPortLSB {0}
set_connection_parameter_value display_port.mixer_0_conduit_bridge_1_freeze_conduit_in/frz_ctrl_0.freeze_conduit_out1 startPort {}
set_connection_parameter_value display_port.mixer_0_conduit_bridge_1_freeze_conduit_in/frz_ctrl_0.freeze_conduit_out1 startPortLSB {0}
set_connection_parameter_value display_port.mixer_0_conduit_bridge_1_freeze_conduit_in/frz_ctrl_0.freeze_conduit_out1 width {0}

add_connection display_port.mixer_0_conduit_bridge_0_freeze_conduit_in frz_ctrl_0.freeze_conduit_out2 
set_connection_parameter_value display_port.mixer_0_conduit_bridge_0_freeze_conduit_in/frz_ctrl_0.freeze_conduit_out2 endPort {}
set_connection_parameter_value display_port.mixer_0_conduit_bridge_0_freeze_conduit_in/frz_ctrl_0.freeze_conduit_out2 endPortLSB {0}
set_connection_parameter_value display_port.mixer_0_conduit_bridge_0_freeze_conduit_in/frz_ctrl_0.freeze_conduit_out2 startPort {}
set_connection_parameter_value display_port.mixer_0_conduit_bridge_0_freeze_conduit_in/frz_ctrl_0.freeze_conduit_out2 startPortLSB {0}
set_connection_parameter_value display_port.mixer_0_conduit_bridge_0_freeze_conduit_in/frz_ctrl_0.freeze_conduit_out2 width {0}

add_connection frz_ctrl_0.reset_source display_port.resetn
} else {
add_connection pb_lwh2f.m0 freeze_bridge_0.slv_bridge_to_sr
set_connection_parameter_value pb_lwh2f.m0/freeze_bridge_0.slv_bridge_to_sr arbitrationPriority {1}
set_connection_parameter_value pb_lwh2f.m0/freeze_bridge_0.slv_bridge_to_sr baseAddress {0x0800}
set_connection_parameter_value pb_lwh2f.m0/freeze_bridge_0.slv_bridge_to_sr defaultConnection {0}

add_connection freeze_bridge_0.slv_bridge_to_pr pr_region_0.pr_mm_bridge_0_s0
set_connection_parameter_value freeze_bridge_0.slv_bridge_to_pr/pr_region_0.pr_mm_bridge_0_s0 arbitrationPriority {1}
set_connection_parameter_value freeze_bridge_0.slv_bridge_to_pr/pr_region_0.pr_mm_bridge_0_s0 baseAddress {0x0000}
set_connection_parameter_value freeze_bridge_0.slv_bridge_to_pr/pr_region_0.pr_mm_bridge_0_s0 defaultConnection {0}

add_connection clk_0.clk pr_region_0.clk

add_connection clk_0.clk freeze_bridge_0.clock

add_connection clk_0.clk_reset pr_region_0.reset

add_connection clk_0.clk_reset freeze_bridge_0.reset_n

add_connection arria10_hps_0.h2f_reset pr_region_0.reset

add_connection arria10_hps_0.h2f_reset freeze_bridge_0.reset_n

add_connection frz_ctrl_0.reset_source pr_region_0.reset

if {$freeze_ack_dly_enable == 1} {
add_connection pb_lwh2f.m0 start_ack_pio.s1 
set_connection_parameter_value pb_lwh2f.m0/start_ack_pio.s1 arbitrationPriority {1}
set_connection_parameter_value pb_lwh2f.m0/start_ack_pio.s1 baseAddress {0x0c00}
set_connection_parameter_value pb_lwh2f.m0/start_ack_pio.s1 defaultConnection {0}

add_connection pb_lwh2f.m0 stop_ack_pio.s1 
set_connection_parameter_value pb_lwh2f.m0/stop_ack_pio.s1 arbitrationPriority {1}
set_connection_parameter_value pb_lwh2f.m0/stop_ack_pio.s1 baseAddress {0x0c10}
set_connection_parameter_value pb_lwh2f.m0/stop_ack_pio.s1 defaultConnection {0}

add_connection pb_lwh2f.m0 frz_ack_pio.s1
set_connection_parameter_value pb_lwh2f.m0/frz_ack_pio.s1 arbitrationPriority {1}
set_connection_parameter_value pb_lwh2f.m0/frz_ack_pio.s1 baseAddress {0x0c20}
set_connection_parameter_value pb_lwh2f.m0/frz_ack_pio.s1 defaultConnection {0}

add_connection clk_0.clk start_ack_pio.clk

add_connection clk_0.clk stop_ack_pio.clk

add_connection clk_0.clk frz_ack_pio.clk

add_connection clk_0.clk_reset stop_ack_pio.reset 

add_connection clk_0.clk_reset start_ack_pio.reset 

add_connection clk_0.clk_reset frz_ack_pio.reset

add_connection arria10_hps_0.h2f_reset stop_ack_pio.reset 

add_connection arria10_hps_0.h2f_reset start_ack_pio.reset

add_connection arria10_hps_0.h2f_reset frz_ack_pio.reset
} else {
add_connection frz_ctrl_0.freeze_conduit0 freeze_bridge_0.freeze_conduit
set_connection_parameter_value frz_ctrl_0.freeze_conduit0/freeze_bridge_0.freeze_conduit endPort {}
set_connection_parameter_value frz_ctrl_0.freeze_conduit0/freeze_bridge_0.freeze_conduit endPortLSB {0}
set_connection_parameter_value frz_ctrl_0.freeze_conduit0/freeze_bridge_0.freeze_conduit startPort {}
set_connection_parameter_value frz_ctrl_0.freeze_conduit0/freeze_bridge_0.freeze_conduit startPortLSB {0}
set_connection_parameter_value frz_ctrl_0.freeze_conduit0/freeze_bridge_0.freeze_conduit width {0}
}
}
}

if {$board_rev != "A"} {
add_connection clk_0.clk f2sdram_m1.clk 
add_connection clk_0.clk_reset f2sdram_m1.clk_reset 
add_connection arria10_hps_0.h2f_reset f2sdram_m1.clk_reset 
add_connection f2sdram_m1.master arria10_hps_0.f2sdram0_data 
set_connection_parameter_value f2sdram_m1.master/arria10_hps_0.f2sdram0_data arbitrationPriority {1}
set_connection_parameter_value f2sdram_m1.master/arria10_hps_0.f2sdram0_data baseAddress {0x0000}
set_connection_parameter_value f2sdram_m1.master/arria10_hps_0.f2sdram0_data defaultConnection {0}
}

add_connection pb_lwh2f.m0 ILC.avalon_slave 
set_connection_parameter_value pb_lwh2f.m0/ILC.avalon_slave arbitrationPriority {1}
set_connection_parameter_value pb_lwh2f.m0/ILC.avalon_slave baseAddress {0x0100}
set_connection_parameter_value pb_lwh2f.m0/ILC.avalon_slave defaultConnection {0}

add_connection pb_lwh2f.m0 sysid_qsys_0.control_slave 
set_connection_parameter_value pb_lwh2f.m0/sysid_qsys_0.control_slave arbitrationPriority {1}
set_connection_parameter_value pb_lwh2f.m0/sysid_qsys_0.control_slave baseAddress {0x0000}
set_connection_parameter_value pb_lwh2f.m0/sysid_qsys_0.control_slave defaultConnection {0}

add_connection arria10_hps_0.h2f_lw_axi_master pb_lwh2f.s0 
set_connection_parameter_value arria10_hps_0.h2f_lw_axi_master/pb_lwh2f.s0 arbitrationPriority {1}
set_connection_parameter_value arria10_hps_0.h2f_lw_axi_master/pb_lwh2f.s0 baseAddress {0x0000}
set_connection_parameter_value arria10_hps_0.h2f_lw_axi_master/pb_lwh2f.s0 defaultConnection {0}

add_connection pb_lwh2f.m0 led_pio.s1 
set_connection_parameter_value pb_lwh2f.m0/led_pio.s1 arbitrationPriority {1}
set_connection_parameter_value pb_lwh2f.m0/led_pio.s1 baseAddress {0x0010}
set_connection_parameter_value pb_lwh2f.m0/led_pio.s1 defaultConnection {0}

add_connection pb_lwh2f.m0 button_pio.s1 
set_connection_parameter_value pb_lwh2f.m0/button_pio.s1 arbitrationPriority {1}
set_connection_parameter_value pb_lwh2f.m0/button_pio.s1 baseAddress {0x0020}
set_connection_parameter_value pb_lwh2f.m0/button_pio.s1 defaultConnection {0}

add_connection pb_lwh2f.m0 dipsw_pio.s1 
set_connection_parameter_value pb_lwh2f.m0/dipsw_pio.s1 arbitrationPriority {1}
set_connection_parameter_value pb_lwh2f.m0/dipsw_pio.s1 baseAddress {0x0030}
set_connection_parameter_value pb_lwh2f.m0/dipsw_pio.s1 defaultConnection {0}

add_connection arria10_hps_0.h2f_axi_master onchip_memory2_0.s1 
set_connection_parameter_value arria10_hps_0.h2f_axi_master/onchip_memory2_0.s1 arbitrationPriority {1}
set_connection_parameter_value arria10_hps_0.h2f_axi_master/onchip_memory2_0.s1 baseAddress {0x0000}
set_connection_parameter_value arria10_hps_0.h2f_axi_master/onchip_memory2_0.s1 defaultConnection {0}

add_connection hps_m.master arria10_hps_0.f2h_axi_slave 
set_connection_parameter_value hps_m.master/arria10_hps_0.f2h_axi_slave arbitrationPriority {1}
set_connection_parameter_value hps_m.master/arria10_hps_0.f2h_axi_slave baseAddress {0x0000}
set_connection_parameter_value hps_m.master/arria10_hps_0.f2h_axi_slave defaultConnection {0}

add_connection fpga_m.master pb_lwh2f.s0 
set_connection_parameter_value fpga_m.master/pb_lwh2f.s0 arbitrationPriority {1}
set_connection_parameter_value fpga_m.master/pb_lwh2f.s0 baseAddress {0x00000}
set_connection_parameter_value fpga_m.master/pb_lwh2f.s0 defaultConnection {0}

add_connection clk_0.clk hps_m.clk 

add_connection clk_0.clk reset_bridge_0.clk 

add_connection clk_0.clk fpga_m.clk 

add_connection clk_0.clk pb_lwh2f.clk 

add_connection clk_0.clk sysid_qsys_0.clk 

add_connection clk_0.clk led_pio.clk 

add_connection clk_0.clk button_pio.clk 

add_connection clk_0.clk dipsw_pio.clk 

add_connection clk_0.clk ILC.clk 

if {$fpga_pcie == 1} {  

add_connection pcie_0.coreclkout_out onchip_memory2_0.clk1 

add_connection pcie_0.nreset_status_out_reset onchip_memory2_0.reset1 

add_connection pcie_0.nreset_status_out_reset arria10_hps_0.f2sdram2_reset

if {$board_rev == "A"} {
add_connection iopll_0.outclk0 arria10_hps_0.f2sdram1_clock 
} 

if {$pcie_gen == 3 || $pcie_count == 8} {

add_connection pcie_0.coreclkout_out iopll_0.refclk 

add_connection iopll_0.outclk1 onchip_memory2_0.clk1 

add_connection iopll_0.outclk1 pcie_0.clk_125_in_clk 

add_connection iopll_0.outclk0 arria10_hps_0.f2sdram2_clock 

add_connection clk_0.clk_reset iopll_0.reset    

add_connection arria10_hps_0.h2f_reset iopll_0.reset

add_connection pcie_0.nreset_status_out_reset iopll_0.reset 

add_connection clk_0.clk arria10_hps_0.f2sdram0_clock 
} else {
add_connection pcie_0.coreclkout_out arria10_hps_0.f2sdram2_clock 
add_connection clk_0.clk arria10_hps_0.f2sdram0_clock 
} 

} else {

if {$board_rev == "A"} {
add_connection clk_0.clk arria10_hps_0.f2sdram1_clock 
} else {
add_connection clk_0.clk arria10_hps_0.f2sdram0_clock 
add_connection clk_0.clk arria10_hps_0.f2sdram2_clock 
} 

add_connection clk_0.clk onchip_memory2_0.clk1 

}

if {$fpga_dp == 1} {
add_connection clock_bridge_0.out_clk arria10_hps_0.f2h_axi_clock 
} else {
add_connection clk_0.clk arria10_hps_0.f2h_axi_clock 
}

add_connection clk_0.clk arria10_hps_0.h2f_lw_axi_clock 

if {$fpga_pcie == 1 && ($pcie_gen == 3 || $pcie_count == 8) } {
add_connection iopll_0.outclk1 arria10_hps_0.h2f_axi_clock
} else {
add_connection clk_0.clk arria10_hps_0.h2f_axi_clock 
}

if {$hps_sdram == "D9RPL" || $hps_sdram == "D9PZN" || $hps_sdram == "D9RGX"} {
add_connection arria10_hps_0.emif emif_a10_hps_0.hps_emif_conduit_end 
set_connection_parameter_value arria10_hps_0.emif/emif_a10_hps_0.hps_emif_conduit_end endPort {}
set_connection_parameter_value arria10_hps_0.emif/emif_a10_hps_0.hps_emif_conduit_end endPortLSB {0}
set_connection_parameter_value arria10_hps_0.emif/emif_a10_hps_0.hps_emif_conduit_end startPort {}
set_connection_parameter_value arria10_hps_0.emif/emif_a10_hps_0.hps_emif_conduit_end startPortLSB {0}
set_connection_parameter_value arria10_hps_0.emif/emif_a10_hps_0.hps_emif_conduit_end width {0}
}

add_connection arria10_hps_0.f2h_irq0 button_pio.irq 
set_connection_parameter_value arria10_hps_0.f2h_irq0/button_pio.irq irqNumber {0}

add_connection arria10_hps_0.f2h_irq0 dipsw_pio.irq 
set_connection_parameter_value arria10_hps_0.f2h_irq0/dipsw_pio.irq irqNumber {1}

add_connection ILC.irq button_pio.irq 
set_connection_parameter_value ILC.irq/button_pio.irq irqNumber {0}

add_connection ILC.irq dipsw_pio.irq 
set_connection_parameter_value ILC.irq/dipsw_pio.irq irqNumber {1}

# add_connection clk_0.clk_reset iopll_0.reset 

# add_connection arria10_hps_0.h2f_reset iopll_0.reset  


add_connection clk_0.clk_reset arria10_hps_0.f2h_axi_reset 

add_connection clk_0.clk_reset arria10_hps_0.f2sdram0_reset 

add_connection clk_0.clk_reset arria10_hps_0.f2sdram2_reset 

add_connection clk_0.clk_reset arria10_hps_0.h2f_axi_reset 

add_connection clk_0.clk_reset arria10_hps_0.h2f_lw_axi_reset 

add_connection clk_0.clk_reset hps_m.clk_reset 

add_connection clk_0.clk_reset fpga_m.clk_reset 

add_connection clk_0.clk_reset reset_bridge_0.in_reset 

add_connection clk_0.clk_reset pb_lwh2f.reset 

add_connection clk_0.clk_reset sysid_qsys_0.reset 

add_connection clk_0.clk_reset led_pio.reset 

add_connection clk_0.clk_reset button_pio.reset 

add_connection clk_0.clk_reset dipsw_pio.reset 

add_connection clk_0.clk_reset onchip_memory2_0.reset1 

add_connection clk_0.clk_reset ILC.reset_n 

add_connection arria10_hps_0.h2f_reset arria10_hps_0.f2h_axi_reset 

add_connection arria10_hps_0.h2f_reset arria10_hps_0.f2sdram0_reset 

add_connection arria10_hps_0.h2f_reset arria10_hps_0.f2sdram2_reset 

add_connection arria10_hps_0.h2f_reset arria10_hps_0.h2f_axi_reset 

add_connection arria10_hps_0.h2f_reset arria10_hps_0.h2f_lw_axi_reset 

add_connection arria10_hps_0.h2f_reset hps_m.clk_reset 

add_connection arria10_hps_0.h2f_reset fpga_m.clk_reset 

add_connection arria10_hps_0.h2f_reset reset_bridge_0.in_reset 

add_connection arria10_hps_0.h2f_reset pb_lwh2f.reset 

add_connection arria10_hps_0.h2f_reset sysid_qsys_0.reset 

add_connection arria10_hps_0.h2f_reset led_pio.reset 

add_connection arria10_hps_0.h2f_reset button_pio.reset 

add_connection arria10_hps_0.h2f_reset dipsw_pio.reset 

add_connection arria10_hps_0.h2f_reset onchip_memory2_0.reset1 

add_connection arria10_hps_0.h2f_reset ILC.reset_n 

if {$hps_sdram == "D9RPL" || $hps_sdram == "D9PZN" || $hps_sdram == "D9RGX"} {
add_connection clk_0.clk_reset emif_a10_hps_0.global_reset_reset_sink 
}

if {$fast_trace == 1} {
add_connection arria10_hps_0.trace_s2f_clk trace_wrapper_0.clock_sink 

add_connection clk_0.clk_reset trace_wrapper_0.reset_sink 

add_connection arria10_hps_0.h2f_reset trace_wrapper_0.reset_sink 

add_connection trace_wrapper_0.h2f_tpiu arria10_hps_0.trace 
set_connection_parameter_value trace_wrapper_0.h2f_tpiu/arria10_hps_0.trace endPort {}
set_connection_parameter_value trace_wrapper_0.h2f_tpiu/arria10_hps_0.trace endPortLSB {0}
set_connection_parameter_value trace_wrapper_0.h2f_tpiu/arria10_hps_0.trace startPort {}
set_connection_parameter_value trace_wrapper_0.h2f_tpiu/arria10_hps_0.trace startPortLSB {0}
set_connection_parameter_value trace_wrapper_0.h2f_tpiu/arria10_hps_0.trace width {0}
}

add_connection clk_0.clk issp_0.source_clk 


# exported interfaces
add_interface clk_100 clock sink
set_interface_property clk_100 EXPORT_OF clk_0.clk_in
if {$hps_sdram == "D9RPL" || $hps_sdram == "D9PZN" || $hps_sdram == "D9RGX"} {
add_interface emif_a10_hps_0_mem_conduit_end conduit end
set_interface_property emif_a10_hps_0_mem_conduit_end EXPORT_OF emif_a10_hps_0.mem_conduit_end
add_interface emif_a10_hps_0_oct_conduit_end conduit end
set_interface_property emif_a10_hps_0_oct_conduit_end EXPORT_OF emif_a10_hps_0.oct_conduit_end
add_interface emif_a10_hps_0_pll_ref_clk_clock_sink clock sink
set_interface_property emif_a10_hps_0_pll_ref_clk_clock_sink EXPORT_OF emif_a10_hps_0.pll_ref_clk_clock_sink
}

add_interface f2h_cold_reset_req reset sink
set_interface_property f2h_cold_reset_req EXPORT_OF arria10_hps_0.f2h_cold_reset_req
add_interface f2h_debug_reset_req reset sink
set_interface_property f2h_debug_reset_req EXPORT_OF arria10_hps_0.f2h_debug_reset_req
add_interface f2h_stm_hw_events conduit end
set_interface_property f2h_stm_hw_events EXPORT_OF arria10_hps_0.f2h_stm_hw_events
add_interface f2h_warm_reset_req reset sink
set_interface_property f2h_warm_reset_req EXPORT_OF arria10_hps_0.f2h_warm_reset_req
add_interface hps_fpga_reset reset source
set_interface_property hps_fpga_reset EXPORT_OF reset_bridge_0.out_reset
add_interface hps_io conduit end
set_interface_property hps_io EXPORT_OF arria10_hps_0.hps_io
add_interface pio_button_external_connection conduit end
set_interface_property pio_button_external_connection EXPORT_OF button_pio.external_connection
add_interface pio_dipsw_external_connection conduit end
set_interface_property pio_dipsw_external_connection EXPORT_OF dipsw_pio.external_connection
add_interface pio_led_external_connection conduit end
set_interface_property pio_led_external_connection EXPORT_OF led_pio.external_connection
add_interface reset reset sink
set_interface_property reset EXPORT_OF clk_0.clk_in_reset

if {$hps_sgmii == 1} {
if {$board_rev == "A"} {
# re-route I2C from FPGA to IO48
add_interface arria10_hps_0_i2c1_scl_in clock sink
set_interface_property arria10_hps_0_i2c1_scl_in EXPORT_OF arria10_hps_0.i2c1_scl_in
add_interface arria10_hps_0_i2c1_clk clock source
set_interface_property arria10_hps_0_i2c1_clk EXPORT_OF arria10_hps_0.i2c1_clk
add_interface arria10_hps_0_i2c1 conduit end
set_interface_property arria10_hps_0_i2c1 EXPORT_OF arria10_hps_0.i2c1
}
# required additional interrupts from PHY
add_interface f2h_irq conduit end
set_interface_property f2h_irq EXPORT_OF arria10_hps_0.f2h_irq1

add_interface arria10_hps_0_emac_ptp_ref_clock clock sink
set_interface_property arria10_hps_0_emac_ptp_ref_clock EXPORT_OF arria10_hps_0.emac_ptp_ref_clock
add_interface ref_clk_125 clock sink
if {$sgmii_count == 1} {
set_interface_property ref_clk_125 EXPORT_OF sgmii_1.clk_125
} else {
set_interface_property ref_clk_125 EXPORT_OF clock_bridge_enet.in_clk
for {set x 1} {$x<=$sgmii_count} {incr x} {
add_connection clock_bridge_enet.out_clk sgmii_${x}.clk_125  
}
}
  
for {set x 1} {$x<=$sgmii_count} {incr x} {
#### added to force exportation of mdc of hps, case:278470
add_interface emac${x}_md_clk clock source
set_interface_property emac${x}_md_clk EXPORT_OF arria10_hps_0.emac${x}_md_clk
add_interface sgmii_${x}_emac_mdio conduit end
set_interface_property sgmii_${x}_emac_mdio EXPORT_OF sgmii_${x}.emac_mdio
add_interface sgmii_${x}_emac_ptp conduit end
set_interface_property sgmii_${x}_emac_ptp EXPORT_OF sgmii_${x}.emac_ptp
add_interface sgmii_${x}_tse_rx_is_lockedtoref conduit end
set_interface_property sgmii_${x}_tse_rx_is_lockedtoref EXPORT_OF sgmii_${x}.tse_rx_is_lockedtoref
add_interface sgmii_${x}_tse_rx_set_locktodata conduit end
set_interface_property sgmii_${x}_tse_rx_set_locktodata EXPORT_OF sgmii_${x}.tse_rx_set_locktodata
add_interface sgmii_${x}_tse_rx_set_locktoref conduit end
set_interface_property sgmii_${x}_tse_rx_set_locktoref EXPORT_OF sgmii_${x}.tse_rx_set_locktoref
add_interface sgmii_${x}_tse_serdes_control_connection conduit end
set_interface_property sgmii_${x}_tse_serdes_control_connection EXPORT_OF sgmii_${x}.tse_serdes_control_connection
add_interface sgmii_${x}_tse_serial_connection conduit end
set_interface_property sgmii_${x}_tse_serial_connection EXPORT_OF sgmii_${x}.tse_serial_connection
add_interface sgmii_${x}_tse_sgmii_status_connection conduit end
set_interface_property sgmii_${x}_tse_sgmii_status_connection EXPORT_OF sgmii_${x}.tse_sgmii_status_connection
add_interface sgmii_${x}_tse_status_led_connection conduit end
set_interface_property sgmii_${x}_tse_status_led_connection EXPORT_OF sgmii_${x}.tse_status_led_connection
add_interface sgmii_${x}_xcvr_reset_control_0_pll_select conduit end
set_interface_property sgmii_${x}_xcvr_reset_control_0_pll_select EXPORT_OF sgmii_${x}.xcvr_reset_control_0_pll_select
add_interface sgmii_${x}_xcvr_reset_control_0_rx_ready conduit end
set_interface_property sgmii_${x}_xcvr_reset_control_0_rx_ready EXPORT_OF sgmii_${x}.xcvr_reset_control_0_rx_ready
add_interface sgmii_${x}_xcvr_reset_control_0_tx_ready conduit end
set_interface_property sgmii_${x}_xcvr_reset_control_0_tx_ready EXPORT_OF sgmii_${x}.xcvr_reset_control_0_tx_ready
}
}

if {$hps_i2c_fpga_if == 1} {
add_interface i2c1_sda_buff_dout conduit end
set_interface_property i2c1_sda_buff_dout EXPORT_OF i2c1_sda_buff.dout
add_interface i2c1_sda_buff_din conduit end
set_interface_property i2c1_sda_buff_din EXPORT_OF i2c1_sda_buff.din
add_interface i2c1_sda_buff_oe conduit end
set_interface_property i2c1_sda_buff_oe EXPORT_OF i2c1_sda_buff.oe
add_interface i2c1_sda_buff_pad_io conduit end
set_interface_property i2c1_sda_buff_pad_io EXPORT_OF i2c1_sda_buff.pad_io

add_interface i2c1_scl_buff_dout conduit end
set_interface_property i2c1_scl_buff_dout EXPORT_OF i2c1_scl_buff.dout
add_interface i2c1_scl_buff_din conduit end
set_interface_property i2c1_scl_buff_din EXPORT_OF i2c1_scl_buff.din
add_interface i2c1_scl_buff_oe conduit end
set_interface_property i2c1_scl_buff_oe EXPORT_OF i2c1_scl_buff.oe
add_interface i2c1_scl_buff_pad_io conduit end
set_interface_property i2c1_scl_buff_pad_io EXPORT_OF i2c1_scl_buff.pad_io
}

if {$fpga_dp == 1} {
if {$pr_enable == 1} {
add_interface display_port_pio_1_external_connection conduit end
set_interface_property display_port_pio_1_external_connection EXPORT_OF display_port.pio_1_external_connection
}
add_interface display_port_video_pll_locked conduit end
set_interface_property display_port_video_pll_locked EXPORT_OF display_port.video_pll_locked
add_interface display_port_video_pll_outclk0 clock source
set_interface_property display_port_video_pll_outclk0 EXPORT_OF display_port.video_pll_outclk0
add_interface display_port_video_pll_outclk1 clock source
set_interface_property display_port_video_pll_outclk1 EXPORT_OF display_port.video_pll_outclk1
add_interface display_port_video_pll_outclk2 clock source
set_interface_property display_port_video_pll_outclk2 EXPORT_OF display_port.video_pll_outclk2
add_interface display_port_bitec_dp_0_clk_cal clock sink
set_interface_property display_port_bitec_dp_0_clk_cal EXPORT_OF display_port.bitec_dp_0_clk_cal
add_interface display_port_bitec_dp_0_tx conduit end
set_interface_property display_port_bitec_dp_0_tx EXPORT_OF display_port.bitec_dp_0_tx
add_interface display_port_bitec_dp_0_tx0_video_in conduit end
set_interface_property display_port_bitec_dp_0_tx0_video_in EXPORT_OF display_port.bitec_dp_0_tx0_video_in
add_interface display_port_bitec_dp_0_tx0_video_in_1 clock sink
set_interface_property display_port_bitec_dp_0_tx0_video_in_1 EXPORT_OF display_port.bitec_dp_0_tx0_video_in_1
add_interface display_port_bitec_dp_0_tx_analog_reconfig conduit end
set_interface_property display_port_bitec_dp_0_tx_analog_reconfig EXPORT_OF display_port.bitec_dp_0_tx_analog_reconfig
add_interface display_port_bitec_dp_0_tx_aux conduit end
set_interface_property display_port_bitec_dp_0_tx_aux EXPORT_OF display_port.bitec_dp_0_tx_aux
add_interface display_port_bitec_dp_0_tx_reconfig conduit end
set_interface_property display_port_bitec_dp_0_tx_reconfig EXPORT_OF display_port.bitec_dp_0_tx_reconfig
add_interface display_port_bitec_dp_0_tx_ss avalon_streaming sink
set_interface_property display_port_bitec_dp_0_tx_ss EXPORT_OF display_port.bitec_dp_0_tx_ss
add_interface display_port_bitec_dp_0_tx_ss_clk clock source
set_interface_property display_port_bitec_dp_0_tx_ss_clk EXPORT_OF display_port.bitec_dp_0_tx_ss_clk
add_interface display_port_clk_16 clock sink
set_interface_property display_port_clk_16 EXPORT_OF display_port.clk_16
add_interface display_port_clk_vip clock sink
set_interface_property display_port_clk_vip EXPORT_OF clock_bridge_0.in_clk
add_interface display_port_cvo_clocked_video conduit end
set_interface_property display_port_cvo_clocked_video EXPORT_OF display_port.cvo_clocked_video
add_interface display_port_pio_0_external_connection conduit end
set_interface_property display_port_pio_0_external_connection EXPORT_OF display_port.pio_0_external_connection
add_interface display_port_xcvr_fpll_a10_0_mcgb_rst conduit end
set_interface_property display_port_xcvr_fpll_a10_0_mcgb_rst EXPORT_OF display_port.xcvr_fpll_a10_0_mcgb_rst
add_interface display_port_xcvr_fpll_a10_0_pll_cal_busy conduit end
set_interface_property display_port_xcvr_fpll_a10_0_pll_cal_busy EXPORT_OF display_port.xcvr_fpll_a10_0_pll_cal_busy
add_interface display_port_xcvr_fpll_a10_0_pll_locked conduit end
set_interface_property display_port_xcvr_fpll_a10_0_pll_locked EXPORT_OF display_port.xcvr_fpll_a10_0_pll_locked
add_interface display_port_xcvr_fpll_a10_0_pll_refclk0 clock sink
set_interface_property display_port_xcvr_fpll_a10_0_pll_refclk0 EXPORT_OF display_port.xcvr_fpll_a10_0_pll_refclk0
add_interface display_port_xcvr_fpll_a10_0_reconfig_avmm0 avalon slave
set_interface_property display_port_xcvr_fpll_a10_0_reconfig_avmm0 EXPORT_OF display_port.xcvr_fpll_a10_0_reconfig_avmm0
add_interface display_port_xcvr_fpll_a10_0_tx_serial_clk hssi_serial_clock source
set_interface_property display_port_xcvr_fpll_a10_0_tx_serial_clk EXPORT_OF display_port.xcvr_fpll_a10_0_tx_serial_clk
add_interface display_port_xcvr_native_a10_0_reconfig_avmm_ch0 avalon slave
set_interface_property display_port_xcvr_native_a10_0_reconfig_avmm_ch0 EXPORT_OF display_port.xcvr_native_a10_0_reconfig_avmm_ch0
add_interface display_port_xcvr_native_a10_0_tx_analogreset_ack_ch0 conduit end
set_interface_property display_port_xcvr_native_a10_0_tx_analogreset_ack_ch0 EXPORT_OF display_port.xcvr_native_a10_0_tx_analogreset_ack_ch0
add_interface display_port_xcvr_native_a10_0_tx_analogreset_ack_ch1 conduit end
set_interface_property display_port_xcvr_native_a10_0_tx_analogreset_ack_ch1 EXPORT_OF display_port.xcvr_native_a10_0_tx_analogreset_ack_ch1
add_interface display_port_xcvr_native_a10_0_tx_analogreset_ack_ch2 conduit end
set_interface_property display_port_xcvr_native_a10_0_tx_analogreset_ack_ch2 EXPORT_OF display_port.xcvr_native_a10_0_tx_analogreset_ack_ch2
add_interface display_port_xcvr_native_a10_0_tx_analogreset_ack_ch3 conduit end
set_interface_property display_port_xcvr_native_a10_0_tx_analogreset_ack_ch3 EXPORT_OF display_port.xcvr_native_a10_0_tx_analogreset_ack_ch3
add_interface display_port_xcvr_native_a10_0_tx_analogreset_ch0 conduit end
set_interface_property display_port_xcvr_native_a10_0_tx_analogreset_ch0 EXPORT_OF display_port.xcvr_native_a10_0_tx_analogreset_ch0
add_interface display_port_xcvr_native_a10_0_tx_analogreset_ch1 conduit end
set_interface_property display_port_xcvr_native_a10_0_tx_analogreset_ch1 EXPORT_OF display_port.xcvr_native_a10_0_tx_analogreset_ch1
add_interface display_port_xcvr_native_a10_0_tx_analogreset_ch2 conduit end
set_interface_property display_port_xcvr_native_a10_0_tx_analogreset_ch2 EXPORT_OF display_port.xcvr_native_a10_0_tx_analogreset_ch2
add_interface display_port_xcvr_native_a10_0_tx_analogreset_ch3 conduit end
set_interface_property display_port_xcvr_native_a10_0_tx_analogreset_ch3 EXPORT_OF display_port.xcvr_native_a10_0_tx_analogreset_ch3
add_interface display_port_xcvr_native_a10_0_tx_cal_busy_ch0 conduit end
set_interface_property display_port_xcvr_native_a10_0_tx_cal_busy_ch0 EXPORT_OF display_port.xcvr_native_a10_0_tx_cal_busy_ch0
add_interface display_port_xcvr_native_a10_0_tx_cal_busy_ch1 conduit end
set_interface_property display_port_xcvr_native_a10_0_tx_cal_busy_ch1 EXPORT_OF display_port.xcvr_native_a10_0_tx_cal_busy_ch1
add_interface display_port_xcvr_native_a10_0_tx_cal_busy_ch2 conduit end
set_interface_property display_port_xcvr_native_a10_0_tx_cal_busy_ch2 EXPORT_OF display_port.xcvr_native_a10_0_tx_cal_busy_ch2
add_interface display_port_xcvr_native_a10_0_tx_cal_busy_ch3 conduit end
set_interface_property display_port_xcvr_native_a10_0_tx_cal_busy_ch3 EXPORT_OF display_port.xcvr_native_a10_0_tx_cal_busy_ch3
add_interface display_port_xcvr_native_a10_0_tx_clkout_ch0 clock source
set_interface_property display_port_xcvr_native_a10_0_tx_clkout_ch0 EXPORT_OF display_port.xcvr_native_a10_0_tx_clkout_ch0
add_interface display_port_xcvr_native_a10_0_tx_clkout_ch1 clock source
set_interface_property display_port_xcvr_native_a10_0_tx_clkout_ch1 EXPORT_OF display_port.xcvr_native_a10_0_tx_clkout_ch1
add_interface display_port_xcvr_native_a10_0_tx_clkout_ch2 clock source
set_interface_property display_port_xcvr_native_a10_0_tx_clkout_ch2 EXPORT_OF display_port.xcvr_native_a10_0_tx_clkout_ch2
add_interface display_port_xcvr_native_a10_0_tx_clkout_ch3 clock source
set_interface_property display_port_xcvr_native_a10_0_tx_clkout_ch3 EXPORT_OF display_port.xcvr_native_a10_0_tx_clkout_ch3
add_interface display_port_xcvr_native_a10_0_tx_coreclkin_ch0 clock sink
set_interface_property display_port_xcvr_native_a10_0_tx_coreclkin_ch0 EXPORT_OF display_port.xcvr_native_a10_0_tx_coreclkin_ch0
add_interface display_port_xcvr_native_a10_0_tx_coreclkin_ch1 clock sink
set_interface_property display_port_xcvr_native_a10_0_tx_coreclkin_ch1 EXPORT_OF display_port.xcvr_native_a10_0_tx_coreclkin_ch1
add_interface display_port_xcvr_native_a10_0_tx_coreclkin_ch2 clock sink
set_interface_property display_port_xcvr_native_a10_0_tx_coreclkin_ch2 EXPORT_OF display_port.xcvr_native_a10_0_tx_coreclkin_ch2
add_interface display_port_xcvr_native_a10_0_tx_coreclkin_ch3 clock sink
set_interface_property display_port_xcvr_native_a10_0_tx_coreclkin_ch3 EXPORT_OF display_port.xcvr_native_a10_0_tx_coreclkin_ch3
add_interface display_port_xcvr_native_a10_0_tx_digitalreset_ch0 conduit end
set_interface_property display_port_xcvr_native_a10_0_tx_digitalreset_ch0 EXPORT_OF display_port.xcvr_native_a10_0_tx_digitalreset_ch0
add_interface display_port_xcvr_native_a10_0_tx_digitalreset_ch1 conduit end
set_interface_property display_port_xcvr_native_a10_0_tx_digitalreset_ch1 EXPORT_OF display_port.xcvr_native_a10_0_tx_digitalreset_ch1
add_interface display_port_xcvr_native_a10_0_tx_digitalreset_ch2 conduit end
set_interface_property display_port_xcvr_native_a10_0_tx_digitalreset_ch2 EXPORT_OF display_port.xcvr_native_a10_0_tx_digitalreset_ch2
add_interface display_port_xcvr_native_a10_0_tx_digitalreset_ch3 conduit end
set_interface_property display_port_xcvr_native_a10_0_tx_digitalreset_ch3 EXPORT_OF display_port.xcvr_native_a10_0_tx_digitalreset_ch3
add_interface display_port_xcvr_native_a10_0_tx_parallel_data_ch0 conduit end
set_interface_property display_port_xcvr_native_a10_0_tx_parallel_data_ch0 EXPORT_OF display_port.xcvr_native_a10_0_tx_parallel_data_ch0
add_interface display_port_xcvr_native_a10_0_tx_parallel_data_ch1 conduit end
set_interface_property display_port_xcvr_native_a10_0_tx_parallel_data_ch1 EXPORT_OF display_port.xcvr_native_a10_0_tx_parallel_data_ch1
add_interface display_port_xcvr_native_a10_0_tx_parallel_data_ch2 conduit end
set_interface_property display_port_xcvr_native_a10_0_tx_parallel_data_ch2 EXPORT_OF display_port.xcvr_native_a10_0_tx_parallel_data_ch2
add_interface display_port_xcvr_native_a10_0_tx_parallel_data_ch3 conduit end
set_interface_property display_port_xcvr_native_a10_0_tx_parallel_data_ch3 EXPORT_OF display_port.xcvr_native_a10_0_tx_parallel_data_ch3
add_interface display_port_xcvr_native_a10_0_tx_polinv_ch0 conduit end
set_interface_property display_port_xcvr_native_a10_0_tx_polinv_ch0 EXPORT_OF display_port.xcvr_native_a10_0_tx_polinv_ch0
add_interface display_port_xcvr_native_a10_0_tx_polinv_ch1 conduit end
set_interface_property display_port_xcvr_native_a10_0_tx_polinv_ch1 EXPORT_OF display_port.xcvr_native_a10_0_tx_polinv_ch1
add_interface display_port_xcvr_native_a10_0_tx_polinv_ch2 conduit end
set_interface_property display_port_xcvr_native_a10_0_tx_polinv_ch2 EXPORT_OF display_port.xcvr_native_a10_0_tx_polinv_ch2
add_interface display_port_xcvr_native_a10_0_tx_polinv_ch3 conduit end
set_interface_property display_port_xcvr_native_a10_0_tx_polinv_ch3 EXPORT_OF display_port.xcvr_native_a10_0_tx_polinv_ch3
add_interface display_port_xcvr_native_a10_0_tx_serial_data_ch0 conduit end
set_interface_property display_port_xcvr_native_a10_0_tx_serial_data_ch0 EXPORT_OF display_port.xcvr_native_a10_0_tx_serial_data_ch0
add_interface display_port_xcvr_native_a10_0_tx_serial_data_ch1 conduit end
set_interface_property display_port_xcvr_native_a10_0_tx_serial_data_ch1 EXPORT_OF display_port.xcvr_native_a10_0_tx_serial_data_ch1
add_interface display_port_xcvr_native_a10_0_tx_serial_data_ch2 conduit end
set_interface_property display_port_xcvr_native_a10_0_tx_serial_data_ch2 EXPORT_OF display_port.xcvr_native_a10_0_tx_serial_data_ch2
add_interface display_port_xcvr_native_a10_0_tx_serial_data_ch3 conduit end
set_interface_property display_port_xcvr_native_a10_0_tx_serial_data_ch3 EXPORT_OF display_port.xcvr_native_a10_0_tx_serial_data_ch3
add_interface display_port_xcvr_native_a10_0_unused_tx_parallel_data conduit end
set_interface_property display_port_xcvr_native_a10_0_unused_tx_parallel_data EXPORT_OF display_port.xcvr_native_a10_0_unused_tx_parallel_data
add_interface display_port_xcvr_reset_control_0_pll_locked conduit end
set_interface_property display_port_xcvr_reset_control_0_pll_locked EXPORT_OF display_port.xcvr_reset_control_0_pll_locked
add_interface display_port_xcvr_reset_control_0_pll_select conduit end
set_interface_property display_port_xcvr_reset_control_0_pll_select EXPORT_OF display_port.xcvr_reset_control_0_pll_select
add_interface display_port_xcvr_reset_control_0_reset reset sink
set_interface_property display_port_xcvr_reset_control_0_reset EXPORT_OF display_port.xcvr_reset_control_0_reset
add_interface display_port_xcvr_reset_control_0_tx_analogreset conduit end
set_interface_property display_port_xcvr_reset_control_0_tx_analogreset EXPORT_OF display_port.xcvr_reset_control_0_tx_analogreset
add_interface display_port_xcvr_reset_control_0_tx_cal_busy conduit end
set_interface_property display_port_xcvr_reset_control_0_tx_cal_busy EXPORT_OF display_port.xcvr_reset_control_0_tx_cal_busy
add_interface display_port_xcvr_reset_control_0_tx_digitalreset conduit end
set_interface_property display_port_xcvr_reset_control_0_tx_digitalreset EXPORT_OF display_port.xcvr_reset_control_0_tx_digitalreset
add_interface display_port_xcvr_reset_control_0_tx_ready conduit end
set_interface_property display_port_xcvr_reset_control_0_tx_ready EXPORT_OF display_port.xcvr_reset_control_0_tx_ready
if {$frame_buffer == 0 && $pr_enable == 0} {
add_interface display_port_tpg_pio conduit end
set_interface_property display_port_tpg_pio EXPORT_OF display_port.tpg_pio
add_interface display_port_vesa_tpg conduit end
set_interface_property display_port_vesa_tpg EXPORT_OF display_port.vesa_tpg
} 
}

if {$fpga_pcie == 1} {
if {$board_rev == "A" || $pcie_gen == 3 || $pcie_count == 8} {
add_interface iopll_0_locked conduit end
set_interface_property iopll_0_locked EXPORT_OF iopll_0.locked
}
add_interface pcie_0_pcie_a10_hip_avmm_refclk clock source
set_interface_property pcie_0_pcie_a10_hip_avmm_refclk EXPORT_OF pcie_0.pcie_a10_hip_avmm_refclk
add_interface pcie_0_coreclk_fanout_clk clock source
set_interface_property pcie_0_coreclk_fanout_clk EXPORT_OF pcie_0.coreclk_fanout_clk
add_interface pcie_0_coreclk_fanout_clk_reset reset source
set_interface_property pcie_0_coreclk_fanout_clk_reset EXPORT_OF pcie_0.coreclk_fanout_clk_reset
add_interface pcie_0_pcie_a10_hip_avmm_currentspeed conduit end
set_interface_property pcie_0_pcie_a10_hip_avmm_currentspeed EXPORT_OF pcie_0.pcie_a10_hip_avmm_currentspeed
add_interface pcie_0_pcie_a10_hip_avmm_hip_ctrl conduit end
set_interface_property pcie_0_pcie_a10_hip_avmm_hip_ctrl EXPORT_OF pcie_0.pcie_a10_hip_avmm_hip_ctrl
add_interface pcie_0_pcie_a10_hip_avmm_hip_pipe conduit end
set_interface_property pcie_0_pcie_a10_hip_avmm_hip_pipe EXPORT_OF pcie_0.pcie_a10_hip_avmm_hip_pipe
add_interface pcie_0_pcie_a10_hip_avmm_hip_serial conduit end
set_interface_property pcie_0_pcie_a10_hip_avmm_hip_serial EXPORT_OF pcie_0.pcie_a10_hip_avmm_hip_serial
add_interface pcie_0_pcie_a10_hip_avmm_hip_status conduit end
set_interface_property pcie_0_pcie_a10_hip_avmm_hip_status EXPORT_OF pcie_0.pcie_a10_hip_avmm_hip_status
add_interface pcie_0_pcie_a10_hip_avmm_npor conduit end
set_interface_property pcie_0_pcie_a10_hip_avmm_npor EXPORT_OF pcie_0.pcie_a10_hip_avmm_npor
}

if {$fast_trace == 1} {
add_interface trace_wrapper_0_f2h_clk_in conduit end
set_interface_property trace_wrapper_0_f2h_clk_in EXPORT_OF trace_wrapper_0.f2h_clk_in
add_interface trace_wrapper_0_trace_data_out conduit end
set_interface_property trace_wrapper_0_trace_data_out EXPORT_OF trace_wrapper_0.trace_data_out
add_interface trace_wrapper_0_trace_clk_out clock source
set_interface_property trace_wrapper_0_trace_clk_out EXPORT_OF trace_wrapper_0.trace_clk_out
}

if {$pr_enable == 1} {
add_interface freeze_controller_0_pr_handshake conduit end
set_interface_property freeze_controller_0_pr_handshake EXPORT_OF frz_ctrl_0.pr_handshake
if {$freeze_ack_dly_enable == 1} {
add_interface start_ack_pio_external_connection conduit end
set_interface_property start_ack_pio_external_connection EXPORT_OF start_ack_pio.external_connection
add_interface stop_ack_pio_external_connection conduit end
set_interface_property stop_ack_pio_external_connection EXPORT_OF stop_ack_pio.external_connection
add_interface freeze_ack_pio_external_connection conduit end
set_interface_property freeze_ack_pio_external_connection EXPORT_OF frz_ack_pio.external_connection
add_interface freeze_ack_pio_external_connection conduit end
set_interface_property freeze_ack_pio_external_connection EXPORT_OF frz_ack_pio.external_connection
add_interface freeze_bridge_0_freeze_conduit conduit end
set_interface_property freeze_bridge_0_freeze_conduit EXPORT_OF freeze_bridge_0.freeze_conduit
add_interface freeze_controller_0_freeze_conduit0 conduit end
set_interface_property freeze_controller_0_freeze_conduit0 EXPORT_OF frz_ctrl_0.freeze_conduit0
}
}

add_interface issp_hps_resets conduit end
set_interface_property issp_hps_resets EXPORT_OF issp_0.sources


# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {AUTO}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {4}
set_interconnect_requirement {$system} {qsys_mm.burstAdapterImplementation} {GENERIC_CONVERTER}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
set_interconnect_requirement {hps_m.master} {qsys_mm.security} {SECURE}

if {$fpga_pcie == 1} {
if {$pcie_gen == 3 || $pcie_count == 8} {
set_interconnect_requirement {mm_interconnect_0|pcie_0_address_span_extender_0_expanded_master_agent.cp/router.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router.src/pcie_0_address_span_extender_0_expanded_master_limiter.cmd_sink} {qsys_mm.postTransform.pipelineCount} {1}
}
}

save_system ${qsys_name}.qsys
