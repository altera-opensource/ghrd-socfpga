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
}

source ./arguments_solver.tcl

source ./board/board_${board}_pin_assignment_table.tcl
global pin_assignment_table

set hdlfiles "${top_name}.v,custom_ip/debounce/debounce.v,custom_ip/edge_detect/altera_edge_detector.v,custom_ip/sgpio_slave/sgpio_slave.v"

if {$freeze_ack_dly_enable == 1 && $pr_enable == 1} {
set hdlfiles "${hdlfiles},custom_ip/ack_delay_logic/ack_delay_logic.sv"
}

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

set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
set_global_assignment -name SDC_FILE ghrd_timing.sdc

if {$hps_etile_1588_25gbe_en == 1 && $hps_etile_1588_10gbe_en == 1} {
set_global_assignment -name DESIGN_ASSISTANT_WAIVER_FILE etile_dr_da_drc.dawf
} elseif {$hps_etile_1588_25gbe_en == 1} {
set_global_assignment -name DESIGN_ASSISTANT_WAIVER_FILE etile_25gbe_da_drc.dawf
} else {
set_global_assignment -name DESIGN_ASSISTANT_WAIVER_FILE etile_10gbe_da_drc.dawf
}

# #HSDES 2207525670: User Reset Gate IP
# set_global_assignment -name DISABLE_REGISTER_POWERUP_INITIALIZATION ON

#HSDES 14010012832: Turn off debug certificate
set_global_assignment -name HPS_DAP_NO_CERTIFICATE on

set_global_assignment -name ENABLE_INTERMEDIATE_SNAPSHOTS ON

if {$fpga_pcie == 1} {
    set_global_assignment -name SDC_FILE fpga_pcie.sdc
    set_global_assignment -name OPTIMIZATION_MODE "AGGRESSIVE PERFORMANCE"
    set_global_assignment -name QII_AUTO_PACKED_REGISTERS "SPARSE AUTO"
}

if {$freeze_ack_dly_enable == 1 && $pr_enable == 1} {
set_global_assignment -name SDC_FILE fpga_pr.sdc
set_global_assignment -name ROUTER_TIMING_OPTIMIZATION_LEVEL MAXIMUM
set_global_assignment -name OPTIMIZATION_MODE "HIGH PERFORMANCE EFFORT"
set_global_assignment -name OPTIMIZATION_TECHNIQUE SPEED
}

if {$pr_enable == 1} {
set_global_assignment -name FAST_PRESERVE AUTO
}

if {$hps_sgmii_en == 1} {
set_global_assignment -name OPTIMIZATION_MODE "SUPERIOR PERFORMANCE"
}

if {$hps_etile_1588_en == 1} {
    set_global_assignment -name SDC_FILE etile_25gbe.sdc
    set_global_assignment -name OPTIMIZATION_MODE "SUPERIOR PERFORMANCE WITH MAXIMUM PLACEMENT EFFORT"
    set_global_assignment -name QII_AUTO_PACKED_REGISTERS "SPARSE AUTO"
}

# enabling signaltap
if {$cross_trigger_en == 1} { 
set_global_assignment -name ENABLE_SIGNALTAP ON
set_global_assignment -name USE_SIGNALTAP_FILE cti_tapping.stp
set_global_assignment -name SIGNALTAP_FILE cti_tapping.stp
}

if {$hps_en == 1} {
# Call "board_${board}_config.tcl" SDMIO config
config_sdmio

# Call "board_${board}_config.tcl" Misc config
if {[expr { [llength [info procs config_misc]]}] > 0} {
    config_misc
} else {
    puts "Warning (GHRD): proc \"config_misc\" is not exist in file:board_${board}_config.tcl"
}

if {$sys_initialization == "hps"} {
set_global_assignment -name HPS_INITIALIZATION "HPS FIRST"
} else {
set_global_assignment -name HPS_INITIALIZATION "AFTER INIT_DONE"
}

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

if {$pr_enable == 1} {
set_global_assignment -name REVISION_TYPE PR_BASE
set_instance_assignment -name GLOBAL_SIGNAL GLOBAL_CLOCK -to fpga_clk_100

for {set n 0} {$n < $pr_region_count} {incr n} {
#PR partition reserved area region
set place_lower_x_coord $pr_x_origin
set place_lower_y_coord [expr $pr_y_origin + 77*$n]
set place_upper_x_coord [expr $pr_x_origin + $pr_width - 1]
set place_upper_y_coord [expr $pr_y_origin + 77*$n + $pr_height - 1]
set route_lower_x_coord [expr $pr_x_origin - 1]
set route_lower_y_coord [expr $pr_y_origin + 77*$n - 1]
set route_upper_x_coord [expr $pr_x_origin + $pr_width]
set route_upper_y_coord [expr $pr_y_origin + 77*$n + $pr_height]
set_instance_assignment -name PARTITION pr_partition_${n} -to soc_inst|pr_region_${n}
set_instance_assignment -name PARTIAL_RECONFIGURATION_PARTITION ON -to soc_inst|pr_region_${n}
set_instance_assignment -name PLACE_REGION "$place_lower_x_coord $place_lower_y_coord $place_upper_x_coord $place_upper_y_coord" -to soc_inst|pr_region_${n}
set_instance_assignment -name ROUTE_REGION "$route_lower_x_coord $route_lower_y_coord $route_upper_x_coord $route_upper_y_coord" -to soc_inst|pr_region_${n}
set_instance_assignment -name RESERVE_PLACE_REGION ON -to soc_inst|pr_region_${n}
set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to soc_inst|pr_region_${n}
}
}

if {$pr_enable == 1} {
# Temporary until PR is merged into combine GHRD
set_global_assignment -name STRATIX_JTAG_USER_CODE 3
set_global_assignment -name USE_CHECKSUM_AS_USERCODE OFF
} else {
if {$board == "devkit_fm86" | $board == "devkit_fm87" | $board == "DK-SI-AGF014E" && $daughter_card == "devkit_dc_oobe"} {
set_global_assignment -name STRATIX_JTAG_USER_CODE 4
set_global_assignment -name USE_CHECKSUM_AS_USERCODE OFF
} elseif {$board == "DK-SI-AGF014E" && $daughter_card == "devkit_dc_nand"} {
set_global_assignment -name STRATIX_JTAG_USER_CODE 1
set_global_assignment -name USE_CHECKSUM_AS_USERCODE OFF
} elseif {$board == "DK-SI-AGF014E" && $daughter_card == "devkit_dc_emmc"} {
set_global_assignment -name STRATIX_JTAG_USER_CODE 2
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

if {$hps_emif_en == 1} {
source ./pin_assign_agilex_emif.tcl
}

set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_ref_clk

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
if {$hps_sdmmc4b_q1_en == 1 || $hps_sdmmc8b_q1_en == 1 || $hps_sdmmc4b_q4_en == 1 || $hps_sdmmc8b_q4_en == 1} {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdmmc_CMD
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdmmc_CCLK
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_sdmmc_CMD
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_sdmmc_CCLK 
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_sdmmc_CMD
if {$hps_sdmmc8b_q1_en == 1 || $hps_sdmmc8b_q4_en == 1} {
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
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_gpio1_io${io_num}
}
}
}
}

  
project_close
