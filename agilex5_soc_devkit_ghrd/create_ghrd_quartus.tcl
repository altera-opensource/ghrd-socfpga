#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2020 Intel Corporation.
#
#****************************************************************************
#
# This script generates the Quartus project for the GHRD.
# To execute this script using quartus_sh for generating Quartus QPF and QSF accordingly
#   quartus_sh --script=create_ghrd_quartus.tcl
#
#****************************************************************************

foreach {key value} $quartus(args) {
  set ${key} $value
  puts "Quartus script got $key = $value"
}

# Derive channel and width from hps_emif_topology
set mystring $hps_emif_topology
set pattern {[0-9]+}

# Find and print each number individually
set start 0
while {[regexp $pattern [string range $mystring $start end] match]} {
    set number $match
if {$number <=5} {
    set hps_emif_channel $number
} else {
	set hps_emif_width $number
}
    set start [expr {[string first $match $mystring] + [string length $match]}]
}


#puts "prjroot = ${prjroot} "
#source ${prjroot}/arguments_solver.tcl
source ./arguments_solver.tcl

#source ${prjroot}/board/board_${board}_pin_assignment_table.tcl
source ./board/board_${board}_pin_assignment_table.tcl
global pin_assignment_table

set hdlfiles "${top_name}.v,custom_ip/debounce/debounce.v,custom_ip/reset_sync/altera_reset_synchronizer.v"

if {[regexp {,} $hdlfiles]} {
    set hdlfilelist [split $hdlfiles ,]
} else {
    set hdlfilelist $hdlfiles
}

project_new -overwrite -family $device_family -part $device $project_name

set_global_assignment -name TOP_LEVEL_ENTITY $top_name

foreach hdlfile $hdlfilelist {
    set_global_assignment -name VERILOG_FILE $hdlfile
}

set_global_assignment -name IP_SEARCH_PATHS "intel_custom_ip/**/*;custom_ip/**/*"

if {$sub_fpga_rgmii_en == 1} {
set_instance_assignment -name INPUT_DELAY_CHAIN 63 -to fpga_rgmii_rx_ctl
set_instance_assignment -name INPUT_DELAY_CHAIN 63 -to fpga_rgmii_rxd[0]
set_instance_assignment -name INPUT_DELAY_CHAIN 63 -to fpga_rgmii_rxd[1]
set_instance_assignment -name INPUT_DELAY_CHAIN 63 -to fpga_rgmii_rxd[2]
set_instance_assignment -name INPUT_DELAY_CHAIN 63 -to fpga_rgmii_rxd[3]
}

set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files

# #HSDES 2207525670: User Reset Gate IP
# set_global_assignment -name DISABLE_REGISTER_POWERUP_INITIALIZATION ON

#HSDES 14010012832: Turn off debug certificate
set_global_assignment -name HPS_DAP_NO_CERTIFICATE on

set_global_assignment -name ENABLE_INTERMEDIATE_SNAPSHOTS ON

# enabling signaltap
if {$cross_trigger_en == 1} {
set_global_assignment -name ENABLE_SIGNALTAP ON
set_global_assignment -name USE_SIGNALTAP_FILE cti_tapping.stp
set_global_assignment -name SIGNALTAP_FILE cti_tapping.stp
}

if {$sub_hps_en == 1} {
# Call "board_${board}_config.tcl" SDMIO config
config_sdmio

# Call "board_${board}_config.tcl" Misc config
#if {[expr { [llength [info procs config_misc]]}] > 0} {
#    config_misc
#} else {
#    puts "Warning (GHRD): proc \"config_misc\" is not exist in file:board_${board}_config.tcl"
#}

if {$initialization_first == "hps"} {
set_global_assignment -name HPS_INITIALIZATION "HPS FIRST"
} else {
set_global_assignment -name HPS_INITIALIZATION "AFTER INIT_DONE"
}
set_global_assignment -name DEVICE_INITIALIZATION_CLOCK OSC_CLK_1_125MHZ
if {$hps_dap_mode == 1} {
set_global_assignment -name HPS_DAP_SPLIT_MODE "HPS PINS"
} elseif {$hps_dap_mode == 2} {
set_global_assignment -name HPS_DAP_SPLIT_MODE "SDM PINS"
} else {
set_global_assignment -name HPS_DAP_SPLIT_MODE DISABLED
}

#Power Management related assignments
# Call "board_${board}_config.tcl" PWRMGT config
config_pwrmgt

if {$daughter_card == "devkit_dc_oobe" || $daughter_card == "mod_som" } {
  if {$sub_fpga_rgmii_en == 1} {
    set_global_assignment -name STRATIX_JTAG_USER_CODE "A"
  } else {
    set_global_assignment -name STRATIX_JTAG_USER_CODE 4
  }
  set_global_assignment -name USE_CHECKSUM_AS_USERCODE OFF
} elseif {$daughter_card == "devkit_dc_nand"} {
set_global_assignment -name STRATIX_JTAG_USER_CODE 1
set_global_assignment -name USE_CHECKSUM_AS_USERCODE OFF
} elseif {$daughter_card == "devkit_dc_emmc"} {
set_global_assignment -name STRATIX_JTAG_USER_CODE 2
set_global_assignment -name USE_CHECKSUM_AS_USERCODE OFF
} elseif {$daughter_card == "debug2"} {
set_global_assignment -name STRATIX_JTAG_USER_CODE 5
set_global_assignment -name USE_CHECKSUM_AS_USERCODE OFF
}
}

# fpga pin assignments
if {[info exists pin_assignment_table]} {
    dict for {pin info} $pin_assignment_table {
        dict with info {
            if {$width_in_bits == 1} {
            set_location_assignment PIN_$location -to $pin
            if {[dict exist $pin_assignment_table $pin io_standard]} {
                set_instance_assignment -name IO_STANDARD "$io_standard" -to $pin
            }
            if {[dict exist $pin_assignment_table $pin  weakpullup]} {
                set_instance_assignment -name WEAK_PULL_UP_RESISTOR "$weakpullup" -to $pin
            }
            if {$direction == "output" || $direction == "inout"} {
                if {[dict exist $pin_assignment_table $pin currentstrength]} {
                    set_instance_assignment -name CURRENT_STRENGTH_NEW "$currentstrength" -to $pin
                }
                if {[dict exist $pin_assignment_table $pin slewrate]} {
                    set_instance_assignment -name SLEW_RATE "$slewrate" -to $pin
                }
            }
            } else {
            set count 0
            foreach loc $location {
                set pin_mod "$pin[$count]"
                set_location_assignment PIN_$loc -to $pin_mod
                if {[dict exist $pin_assignment_table $pin io_standard]} {
                    set_instance_assignment -name IO_STANDARD "$io_standard" -to $pin_mod
                }
                if {[dict exist $pin_assignment_table $pin weakpullup]} {
                    set_instance_assignment -name WEAK_PULL_UP_RESISTOR "$weakpullup" -to $pin_mod
                }
                if {$direction == "output" || $direction == "inout"} {
                    if {[dict exist $pin_assignment_table $pin currentstrength]} {
                        set_instance_assignment -name CURRENT_STRENGTH_NEW "$currentstrength" -to $pin_mod
                    }
                    if {[dict exist $pin_assignment_table $pin slewrate]} {
                        set_instance_assignment -name SLEW_RATE "$slewrate" -to $pin_mod
                    }
                }
                incr count
                }
            }
        }
    }
}

set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_osc_clk

if {$hps_emif_en} {
   if {$board  == "DK-A5E065BB32AES1" || $board  == "cvr" || $board == "lbm" || $board == "bbr" || $board == "MK-A5E065BB32AES1"} {

   set ranks r1
   set width $hps_emif_width
   set ecc   $hps_emif_ecc_en
   }
   if {$ecc} {
      incr width 8
   }

   if {$board == "lbm" } {
    # Hard coded to ch1 for PO.
    # TODO : Parameterize based on channel selection.
	if { ( $hps_emif_width == 32 ) && ( $hps_emif_channel == 1 ) } {
	set key   x32_r1_1ch
	} elseif { ( $hps_emif_width == 16 ) && ( $hps_emif_channel == 1 ) } {
	set key   x16_r1_1ch
	}
    # set key "x${width}_${ranks}_1ch"
   } elseif {$board == "bbr"} {
		if { ( $hps_emif_width == 16 ) && ( $hps_emif_channel == 1 ) } {
			set key   x16_r1_1ch
		} elseif { ( $hps_emif_width == 16 ) && ( $hps_emif_channel == 2 ) } {
			set key   x16_r1_2ch
		}
   } else {
    set key "x${width}_${ranks}"
   }
   # Search for key in the first line
   set key_line [lindex $pin_matrix 0]
   set idx [lsearch $key_line $key]

   if {$idx < 0} {
      error "Could not locate configuration $key for EMIF generation"
   }

   set mem_type_idx [lsearch $key_line "MEM"]

   if {$mem_type_idx < 0} {
      error "Could not locate memory type specifier in pinout matrix for EMIF generation"
   }

   puts "key = $key"
   puts "board = $board"
   puts "mem_type = $hps_emif_type"

   # Now add all items
   set skip_first 1
   foreach key_line $pin_matrix {
      if {$skip_first} {
         set skip_first 0
      } else {
         set pin [lindex $key_line $idx]
         set mem_type [lindex $key_line $mem_type_idx]

         if {$pin != "unused" && (($mem_type == $hps_emif_type) || ($mem_type == "both"))} {
            set_location_assignment $pin -to [lindex $key_line 0]
            puts "Setting: set_location_assignment $pin -to [lindex $key_line 0]"
         }
      }
   }
}

if {$hps_io_off == 0} {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_jtag_tck
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_jtag_tms
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_jtag_tdo
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_jtag_tdi
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_jtag_tdo
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_jtag_tck
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_jtag_tms
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_jtag_tdi
}
if {$hps_sdmmc4b_q1_en == 1 || $hps_sdmmc8b_q1_alt_en == 1 || $hps_sdmmc_pupd_q4_en == 1 || $hps_sdmmc_pwr_q4_en == 1} {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdmmc_CMD
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdmmc_CCLK
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_sdmmc_CMD
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_sdmmc_CCLK
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_sdmmc_CMD
if {$hps_sdmmc8b_q1_alt_en == 1 || $hps_sdmmc_pwr_q4_en == 1} {
set sdmmc_bits 8
} else {
set sdmmc_bits 4
}
for {set i 0} {$i < $sdmmc_bits} {incr i} {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdmmc_D${i}
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_sdmmc_D${i}
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_sdmmc_D${i}
}
}
if {$hps_usb0_en == 1 || $hps_usb1_en == 1} {
set usb ""
if {$hps_usb0_en == 1} {
lappend usb 0
}
if {$hps_usb1_en == 1} {
lappend usb 1
}
foreach usb_en $usb {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb${usb_en}_CLK
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb${usb_en}_STP
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb${usb_en}_DIR
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb${usb_en}_NXT
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_usb${usb_en}_STP
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_usb${usb_en}_CLK
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_usb${usb_en}_DIR
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_usb${usb_en}_NXT
for {set j 0} {$j < 8} {incr j} {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb${usb_en}_DATA${j}
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_usb${usb_en}_DATA${j}
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_usb${usb_en}_DATA${j}
}
}
}
if {$hps_emac0_rmii_en == 1 || $hps_emac0_rgmii_en == 1 || $hps_emac1_rmii_en == 1 || $hps_emac1_rgmii_en == 1 || $hps_emac2_rmii_en == 1 || $hps_emac2_rgmii_en == 1} {
set emac ""
if {$hps_emac0_rmii_en == 1 || $hps_emac0_rgmii_en == 1} {
lappend emac 0
}
if {$hps_emac1_rmii_en == 1 || $hps_emac1_rgmii_en == 1} {
lappend emac 1
}
if {$hps_emac2_rmii_en == 1 || $hps_emac2_rgmii_en == 1} {
lappend emac 2
}

foreach emac_en $emac {
if {$hps_emac0_rgmii_en == 1 || $hps_emac1_rgmii_en == 1 || $hps_emac2_rgmii_en == 1} {
if {$emac_en == 0 && $hps_emac0_rgmii_en == 1} {
set emac_bits 4
} elseif {$emac_en == 1 && $hps_emac1_rgmii_en == 1} {
set emac_bits 4
} elseif {$emac_en == 2 && $hps_emac2_rgmii_en == 1} {
set emac_bits 4
} else {
set emac_bits 2
}
}

set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac${emac_en}_TX_CLK
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac${emac_en}_TX_CTL
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac${emac_en}_RX_CLK
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac${emac_en}_RX_CTL
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_emac${emac_en}_TX_CLK
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_emac${emac_en}_TX_CTL
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_emac${emac_en}_RX_CLK
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_emac${emac_en}_RX_CTL
#set_instance_assignment -name SLEW_RATE 1 -to hps_emac${emac_en}_TX_CLK
#set_instance_assignment -name SLEW_RATE 1 -to hps_emac${emac_en}_TX_CTL
#set_instance_assignment -name OUTPUT_DELAY_CHAIN 8 -to hps_emac0_TX_CLK

for {set j 0} {$j < $emac_bits} {incr j} {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac${emac_en}_RXD${j}
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac${emac_en}_TXD${j}
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_emac${emac_en}_TXD${j}
#set_instance_assignment -name SLEW_RATE 1 -to hps_emac${emac_en}_TXD${j}
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_emac${emac_en}_RXD${j}
}
if {($emac_en == 0 && ($hps_mdio0_q1_en == 1 || $hps_mdio0_q3_en == 1 || $hps_mdio0_q4_en == 1)) || ($emac_en == 1 && ($hps_mdio1_q1_en == 1 || $hps_mdio1_q4_en == 1)) || ($emac_en == 2 && ($hps_mdio2_q1_en == 1 || $hps_mdio2_q3_en == 1))} {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac${emac_en}_MDIO
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac${emac_en}_MDC
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_emac${emac_en}_MDIO
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_emac${emac_en}_MDC
set_instance_assignment -name AUTO_OPEN_DRAIN_PINS ON -to hps_emac${emac_en}_MDIO
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_emac${emac_en}_MDIO
}
}
}
if {$hps_spim0_q1_en == 1 || $hps_spim0_q4_en == 1 || $hps_spim1_q1_en == 1 || $hps_spim1_q2_en == 1 || $hps_spim1_q3_en == 1} {
set spim ""
if {$hps_spim0_q1_en == 1 || $hps_spim0_q4_en == 1} {
lappend spim 0
}
if {$hps_spim1_q1_en == 1 || $hps_spim1_q2_en == 1 || $hps_spim1_q3_en == 1} {
lappend spim 1
}
foreach spim_en $spim {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_spim${spim_en}_CLK
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_spim${spim_en}_MOSI
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_spim${spim_en}_MISO
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_spim${spim_en}_SS0_N
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_spim${spim_en}_CLK
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_spim${spim_en}_MOSI
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_spim${spim_en}_SS0_N
if {($hps_spim0_2ss_en == 1 && $spim_en == 0) || ($hps_spim1_2ss_en == 1 && $spim_en == 1)} {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_spim${spim_en}_SS1_N
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_spim${spim_en}_SS1_N
}
}
}
if {$hps_spis0_q1_en == 1 || $hps_spis0_q2_en == 1 || $hps_spis0_q3_en == 1 || $hps_spis1_q1_en == 1 || $hps_spis1_q3_en == 1 || $hps_spis1_q4_en == 1} {
set spis ""
if {$hps_spis0_q1_en == 1 || $hps_spis0_q2_en == 1 || $hps_spis0_q3_en == 1} {
lappend spis 0
}
if {$hps_spis1_q1_en == 1 || $hps_spis1_q3_en == 1 || $hps_spis1_q4_en == 1} {
lappend spis 1
}
foreach spis_en $spis {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_spis${spis_en}_CLK
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_spis${spis_en}_MOSI
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_spis${spis_en}_MISO
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_spis${spis_en}_SS0_N
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_spis${spis_en}_MISO
}
}
if {$hps_uart0_q1_en == 1 || $hps_uart0_q2_en == 1 || $hps_uart0_q3_en == 1 || $hps_uart1_q1_en == 1 || $hps_uart1_q3_en == 1 || $hps_uart1_q4_en == 1} {
set uart ""
if {$hps_uart0_q1_en == 1 || $hps_uart0_q2_en == 1 || $hps_uart0_q3_en == 1} {
lappend uart 0
}
if {$hps_uart1_q1_en == 1 || $hps_uart1_q3_en == 1 || $hps_uart1_q4_en == 1} {
lappend uart 1
}
foreach uart_en $uart {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_uart${uart_en}_TX
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_uart${uart_en}_RX
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_uart${uart_en}_TX
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_uart${uart_en}_RX
if {($hps_uart0_fc_en == 1 && $uart_en == 0) || ($hps_uart1_fc_en == 1 && $uart_en == 1)} {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_uart${uart_en}_CTS_N
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_uart${uart_en}_RTS_N
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_uart${uart_en}_RTS_N
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_uart${uart_en}_CTS_N
}
}
}
if {$hps_i2c0_q1_en == 1 || $hps_i2c0_q2_en == 1 || $hps_i2c0_q3_en == 1 || $hps_i2c1_q1_en == 1 || $hps_i2c1_q2_en == 1 || $hps_i2c1_q3_en == 1 || $hps_i2c1_q4_en == 1} {
set i2c ""
if {$hps_i2c0_q1_en == 1 || $hps_i2c0_q2_en == 1 || $hps_i2c0_q3_en == 1} {
lappend i2c 0
}
if {$hps_i2c1_q1_en == 1 || $hps_i2c1_q2_en == 1 || $hps_i2c1_q3_en == 1 || $hps_i2c1_q4_en == 1} {
lappend i2c 1
}
foreach i2c_en $i2c {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_i2c${i2c_en}_SDA
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_i2c${i2c_en}_SCL
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_i2c${i2c_en}_SDA
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_i2c${i2c_en}_SCL
set_instance_assignment -name AUTO_OPEN_DRAIN_PINS ON -to hps_i2c${i2c_en}_SDA
set_instance_assignment -name AUTO_OPEN_DRAIN_PINS ON -to hps_i2c${i2c_en}_SCL
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_i2c${i2c_en}_SDA
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_i2c${i2c_en}_SCL
}
}
if {$hps_i2c_emac0_q1_en == 1 || $hps_i2c_emac0_q3_en == 1 || $hps_i2c_emac0_q4_en == 1 || $hps_i2c_emac1_q1_en == 1 || $hps_i2c_emac1_q4_en == 1 || $hps_i2c_emac2_q1_en == 1 || $hps_i2c_emac2_q3_en == 1 || $hps_i2c_emac2_q4_en == 1} {
set i2c_emac ""
if {$hps_i2c_emac0_q1_en == 1 || $hps_i2c_emac0_q3_en == 1 || $hps_i2c_emac0_q4_en == 1} {
lappend i2c_emac 0
}
if {$hps_i2c_emac1_q1_en == 1 || $hps_i2c_emac1_q4_en == 1} {
lappend i2c_emac 1
}
if {$hps_i2c_emac2_q1_en == 1 || $hps_i2c_emac2_q3_en == 1 || $hps_i2c_emac2_q4_en == 1} {
lappend i2c_emac 2
}
foreach i2c_emac_en $i2c_emac {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_i2c_emac${i2c_emac_en}_SDA
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_i2c_emac${i2c_emac_en}_SCL
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_i2c_emac${i2c_emac_en}_SDA
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_i2c_emac${i2c_emac_en}_SCL
set_instance_assignment -name AUTO_OPEN_DRAIN_PINS ON -to hps_i2c_emac${i2c_emac_en}_SDA
set_instance_assignment -name AUTO_OPEN_DRAIN_PINS ON -to hps_i2c_emac${i2c_emac_en}_SCL
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_i2c_emac${i2c_emac_en}_SDA
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_i2c_emac${i2c_emac_en}_SCL
}
}
if {$hps_nand_q12_en == 1 || $hps_nand_q34_en == 1 || $hps_nand_16b_en == 1} {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_nand_WE_N
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_nand_RE_N
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_nand_WP_N
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_nand_CLE
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_nand_ALE
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_nand_RB
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_nand_CE_N
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_nand_WE_N
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_nand_RE_N
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_nand_WP_N
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_nand_CLE
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_nand_ALE
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_nand_CE_N
if {$hps_nand_16b_en == 1} {
set nand_bits 16
} else {
set nand_bits 8
}
for {set k 0} {$k < $nand_bits} {incr k} {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_nand_ADQ${k}
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_nand_ADQ${k}
}
}
if {$hps_trace_q12_en == 1 || $hps_trace_q34_en == 1} {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_trace_CLK
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_trace_CLK
if {$hps_trace_16b_en == 1} {
set trace_bits 16
} elseif {$hps_trace_12b_en == 1} {
set trace_bits 12
} elseif {$hps_trace_8b_en == 1} {
set trace_bits 8
} else {
set trace_bits 4
}
for {set k 0} {$k < $trace_bits} {incr k} {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_trace_D${k}
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_trace_D${k}
}
}
if {$hps_gpio0_en == 1 || $hps_gpio1_en == 1} {
if {$hps_gpio0_en == 1} {
foreach io_num $hps_gpio0_list {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_gpio0_io${io_num}
set_instance_assignment -name CURRENT_STRENGTH_NEW 2MA -to hps_gpio0_io${io_num}
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_gpio0_io${io_num}
}
}
if {$hps_gpio1_en == 1} {
foreach io_num $hps_gpio1_list {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_gpio1_io${io_num}
set_instance_assignment -name CURRENT_STRENGTH_NEW 2MA -to hps_gpio1_io${io_num}
# set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_gpio1_io${io_num}
}
}
}

set_global_assignment -name SDC_FILE ghrd_timing.sdc

# Promote timing failures to errors
set_global_assignment -name PROMOTE_WARNING_TO_ERROR 332148

# Promote pins without location assignments to errors
set_global_assignment -name PROMOTE_WARNING_TO_ERROR 12677 -disable

project_close
