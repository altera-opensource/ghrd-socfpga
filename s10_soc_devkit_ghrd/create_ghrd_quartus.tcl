#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2017-2021 Intel Corporation.
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

if {$board == "devkit"} {
    source ./board/pin_assignment_table_devkit.tcl
    global pin_assignment_table_devkit
}

if {$board == "pe"} {
    source ./board/pin_assignment_table_pe.tcl
    global pin_assignment_table_pe
}

if {$board == "atso12"} {
    source ./board/pin_assignment_table_atso12.tcl
    global pin_assignment_table_atso12
}

if {$board == "ashfield"} {
    source ./board/pin_assignment_table_ashfield.tcl
    global pin_assignment_table_ashfield
}

if {$board == "klamath"} {
    source ./board/pin_assignment_table_klamath.tcl
    global pin_assignment_table_klamath
}

set hdlfiles "custom_ip/debounce/debounce.v,custom_ip/edge_detect/altera_edge_detector.v,custom_ip/reset_sync/altera_reset_synchronizer.v"

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

set_global_assignment -name SYSTEMVERILOG_FILE ${top_name}.sv

foreach hdlfile $hdlfilelist {
    set_global_assignment -name VERILOG_FILE $hdlfile
}

set_global_assignment -name IP_SEARCH_PATHS "custom_ip/**/*;intel_custom_ip/**/*"

set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
set_global_assignment -name SDC_FILE ghrd_timing.sdc
set_global_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON


#HSDES 2207525670: User Reset Gate IP
set_global_assignment -name DISABLE_REGISTER_POWERUP_INITIALIZATION ON

#HSDES 1409588865: Turn off debug certificate
set_global_assignment -name HPS_DAP_NO_CERTIFICATE on
 
if {$board == "devkit"} {
    set_global_assignment -name DEVICE_INITIALIZATION_CLOCK OSC_CLK_1_125MHZ
}

if {$fpga_i2c_en == 1} {
    set_global_assignment -name SDC_FILE fpga_i2c.sdc
}

if {$fpga_pcie == 1} {
    set_global_assignment -name SDC_FILE fpga_pcie.sdc
    set_global_assignment -name OPTIMIZATION_MODE "SUPERIOR PERFORMANCE WITH MAXIMUM PLACEMENT EFFORT"
    set_global_assignment -name QII_AUTO_PACKED_REGISTERS "SPARSE AUTO"
}

if {$hps_mge_10gbe_1588_en == 1} {
    set_global_assignment -name VERILOG_FILE intel_custom_ip/alt_mge_10gbe_1588/reconfig/alt_mge_rcfg_txpll_switch.v
    set_global_assignment -name VERILOG_FILE intel_custom_ip/alt_mge_10gbe_1588/reconfig/alt_mge_rcfg_rxcdr_switch.v
    set_global_assignment -name VERILOG_FILE intel_custom_ip/alt_mge_10gbe_1588/reconfig/alt_mge_rcfg_mif_rom.v
    set_global_assignment -name VERILOG_FILE intel_custom_ip/alt_mge_10gbe_1588/reconfig/alt_mge_rcfg_mif_master.v
    set_global_assignment -name VERILOG_FILE intel_custom_ip/alt_mge_10gbe_1588/reconfig/alt_mge_rcfg_ch_recal.v
    set_global_assignment -name SYSTEMVERILOG_FILE intel_custom_ip/alt_mge_10gbe_1588/reconfig/alt_mge_rcfg.sv
    set_global_assignment -name SYSTEMVERILOG_FILE intel_custom_ip/alt_mge_10gbe_1588/reconfig/alt_mge_phy_reconfig_parameters_CFG2.sv
    set_global_assignment -name SYSTEMVERILOG_FILE intel_custom_ip/alt_mge_10gbe_1588/reconfig/alt_mge_phy_reconfig_parameters_CFG1.sv
    set_global_assignment -name SYSTEMVERILOG_FILE intel_custom_ip/alt_mge_10gbe_1588/reconfig/alt_mge_phy_reconfig_parameters_CFG0.sv
    set_global_assignment -name VERILOG_FILE intel_custom_ip/alt_mge_10gbe_1588/altera_eth_1588_pps.v
    set_global_assignment -name VERILOG_FILE intel_custom_ip/alt_mge_10gbe_1588/alt_mge_reset_synchronizer.v
    set_global_assignment -name VERILOG_FILE intel_custom_ip/alt_mge_10gbe_1588/alt_mge_channel.v
    set_global_assignment -name SYSTEMVERILOG_FILE intel_custom_ip/alt_mge_10gbe_1588/alt_mge_rd.sv
    set_global_assignment -name OPTIMIZATION_MODE "SUPERIOR PERFORMANCE WITH MAXIMUM PLACEMENT EFFORT"
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

if {$c2p_early_revb_off == 1} { 
#For ND5REVB_H_SX_F2397B, disable SEU in your project setting
    set_global_assignment -name ENABLE_ED_CRC_CHECK OFF
    if {$board == "pe"} {
        set_global_assignment -name INI_VARS "ASM_ENABLE_ADVANCED_DEVICES=ON; force_vid_off=on; hps_dump_handoff_data=on; unpowered_hssi_list=0_0,1_0,2_0,0_1,1_1,2_1"
    } else {
        set_global_assignment -name INI_VARS "ASM_ENABLE_ADVANCED_DEVICES=ON; hps_dump_handoff_data=on; unpowered_hssi_list=0_0,1_0,2_0,0_1,1_1,2_1"
    }                                                                                   
} else {
    if {$board == "pe"} {
        set_global_assignment -name INI_VARS "ASM_ENABLE_ADVANCED_DEVICES=ON; force_vid_off=on; hps_dump_handoff_data=on"
    } else {
        set_global_assignment -name INI_VARS "ASM_ENABLE_ADVANCED_DEVICES=ON; hps_dump_handoff_data=on"
    }   
}

# enabling signaltap
if {$cross_trigger_en == 1 && $h2f_user_clk_en == 0} { 
set_global_assignment -name ENABLE_SIGNALTAP ON
set_global_assignment -name USE_SIGNALTAP_FILE cti_tapping.stp
set_global_assignment -name SIGNALTAP_FILE cti_tapping.stp
}

if {$hps_en == 1} {
if {$board != "atso12" && $board != "ashfield"} {
#assign the SDM IO12 pin to HPS cold reset port
set_global_assignment -name USE_HPS_COLD_RESET SDM_IO12
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
if {$board == "devkit"} {
set_global_assignment -name VID_OPERATION_MODE "PMBUS MASTER"
set_global_assignment -name USE_PWRMGT_SCL SDM_IO0
set_global_assignment -name USE_PWRMGT_SDA SDM_IO16
set_global_assignment -name PWRMGT_BUS_SPEED_MODE "400 KHZ"
set_global_assignment -name PWRMGT_PAGE_COMMAND_ENABLE ON
set_global_assignment -name PWRMGT_SLAVE_DEVICE_TYPE OTHER
set_global_assignment -name PWRMGT_SLAVE_DEVICE0_ADDRESS 47
set_global_assignment -name PWRMGT_SLAVE_DEVICE1_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE2_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE3_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE4_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE5_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE6_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE7_ADDRESS 00
set_global_assignment -name PWRMGT_PAGE_COMMAND_ENABLE ON
set_global_assignment -name PWRMGT_VOLTAGE_OUTPUT_FORMAT "AUTO DISCOVERY"
set_global_assignment -name PWRMGT_TRANSLATED_VOLTAGE_VALUE_UNIT VOLTS
} elseif {$board == "atso12"} {
set_global_assignment -name VID_OPERATION_MODE "PMBUS MASTER"
set_global_assignment -name USE_PWRMGT_SCL SDM_IO14
set_global_assignment -name USE_PWRMGT_SDA SDM_IO11
set_global_assignment -name PWRMGT_BUS_SPEED_MODE "400 KHZ"
set_global_assignment -name PWRMGT_PAGE_COMMAND_ENABLE ON
set_global_assignment -name PWRMGT_SLAVE_DEVICE_TYPE LTM4677
set_global_assignment -name PWRMGT_SLAVE_DEVICE0_ADDRESS 41
set_global_assignment -name PWRMGT_SLAVE_DEVICE1_ADDRESS 42
set_global_assignment -name PWRMGT_SLAVE_DEVICE2_ADDRESS 43
set_global_assignment -name PWRMGT_SLAVE_DEVICE3_ADDRESS 44
set_global_assignment -name PWRMGT_SLAVE_DEVICE4_ADDRESS 45
set_global_assignment -name PWRMGT_SLAVE_DEVICE5_ADDRESS 46
set_global_assignment -name PWRMGT_SLAVE_DEVICE6_ADDRESS 47
set_global_assignment -name PWRMGT_SLAVE_DEVICE7_ADDRESS 48
set_global_assignment -name PWRMGT_PAGE_COMMAND_ENABLE ON
set_global_assignment -name PWRMGT_VOLTAGE_OUTPUT_FORMAT "AUTO DISCOVERY"
set_global_assignment -name PWRMGT_TRANSLATED_VOLTAGE_VALUE_UNIT VOLTS
set_global_assignment -name USE_CONF_DONE SDM_IO16
} elseif {$board == "ashfield"} {
set_global_assignment -name VID_OPERATION_MODE "PMBUS MASTER"
set_global_assignment -name USE_PWRMGT_SCL SDM_IO0
set_global_assignment -name USE_PWRMGT_SDA SDM_IO12
set_global_assignment -name PWRMGT_BUS_SPEED_MODE "400 KHZ"
set_global_assignment -name PWRMGT_PAGE_COMMAND_ENABLE ON
set_global_assignment -name PWRMGT_SLAVE_DEVICE_TYPE LTM4677
set_global_assignment -name PWRMGT_SLAVE_DEVICE0_ADDRESS 4F
set_global_assignment -name PWRMGT_SLAVE_DEVICE1_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE2_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE3_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE4_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE5_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE6_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE7_ADDRESS 00
set_global_assignment -name PWRMGT_PAGE_COMMAND_ENABLE ON
set_global_assignment -name PWRMGT_VOLTAGE_OUTPUT_FORMAT "AUTO DISCOVERY"
set_global_assignment -name PWRMGT_TRANSLATED_VOLTAGE_VALUE_UNIT VOLTS
set_global_assignment -name USE_CONF_DONE SDM_IO16
} elseif {$board == "klamath"} {
set_global_assignment -name VID_OPERATION_MODE "PMBUS MASTER"
set_global_assignment -name USE_PWRMGT_SCL SDM_IO14
set_global_assignment -name USE_PWRMGT_SDA SDM_IO11
set_global_assignment -name PWRMGT_BUS_SPEED_MODE "400 KHZ"
set_global_assignment -name PWRMGT_PAGE_COMMAND_ENABLE ON
set_global_assignment -name PWRMGT_SLAVE_DEVICE_TYPE OTHER
set_global_assignment -name PWRMGT_SLAVE_DEVICE0_ADDRESS 60
set_global_assignment -name PWRMGT_SLAVE_DEVICE1_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE2_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE3_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE4_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE5_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE6_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE7_ADDRESS 00
set_global_assignment -name PWRMGT_VOLTAGE_OUTPUT_FORMAT "DIRECT FORMAT"
set_global_assignment -name PWRMGT_DIRECT_FORMAT_COEFFICIENT_M 1
set_global_assignment -name PWRMGT_TRANSLATED_VOLTAGE_VALUE_UNIT MILLIVOLTS
set_global_assignment -name USE_CONF_DONE SDM_IO16
set_global_assignment -name USE_INIT_DONE SDM_IO0
}

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

if {$board == "devkit" && $daughter_card == "devkit_dc_oobe"} {
set_global_assignment -name STRATIX_JTAG_USER_CODE 4
set_global_assignment -name USE_CHECKSUM_AS_USERCODE OFF
} elseif {$board == "devkit" && $daughter_card == "devkit_dc_nand"} {
set_global_assignment -name STRATIX_JTAG_USER_CODE 1
set_global_assignment -name USE_CHECKSUM_AS_USERCODE OFF
} elseif {$board == "devkit" && $daughter_card == "devkit_dc_emmc"} {
set_global_assignment -name STRATIX_JTAG_USER_CODE 2
set_global_assignment -name USE_CHECKSUM_AS_USERCODE OFF
}

# fpga pin assignments
if {$board == "devkit" || $board == "atso12" || $board == "ashfield" || $board == "klamath"} {
dict for {pin info} $pin_assignment_table {
dict with info {
    if {$width_in_bits == 1} {
      set_location_assignment PIN_$location -to $pin
      if {[ string compare $io_standard "USE_AS_3V_GPIO" ] == 0} {
         set_instance_assignment -name USE_AS_3V_GPIO ON -to $pin
      } else {
         set_instance_assignment -name IO_STANDARD "$io_standard" -to $pin
      }
    } else {
    set count 0
    foreach loc $location {
      set pin_mod "$pin[$count]"
      set_location_assignment PIN_$loc -to $pin_mod
      if {[ string compare $io_standard "USE_AS_3V_GPIO" ] == 0} {
         set_instance_assignment -name USE_AS_3V_GPIO ON -to $pin_mod
      } else {
         set_instance_assignment -name IO_STANDARD "$io_standard" -to $pin_mod
      }
      incr count
    }
    }
}
}
    
    set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to fpga_led_pio 
    set_instance_assignment -name SLEW_RATE 0 -to fpga_led_pio 

    if {$fpga_i2c_en == 1} {
        set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to fpga_i2c_sda
        set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to fpga_i2c_scl
        set_instance_assignment -name AUTO_OPEN_DRAIN_PINS ON -to fpga_i2c_sda
        set_instance_assignment -name AUTO_OPEN_DRAIN_PINS ON -to fpga_i2c_scl
        set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to fpga_i2c_sda
        set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to fpga_i2c_scl
    }
    
    if {$fpga_pcie == 1} {
        set_instance_assignment -name USE_AS_3V_GPIO ON -to mux_io_1v8_20 
        set_instance_assignment -name IO_STANDARD "1.8 V" -to mux_io_1v8_20 
        set_location_assignment PIN_AH17 -to mux_io_1v8_20
                
        set_instance_assignment -name USE_AS_3V_GPIO ON -to pcie_hip_npor_pin_perst 
#       set_location_assignment PIN_AE14 -to pcie_hip_npor_pin_perst
    }
   
   if {$hps_mge_10gbe_1588_en == 1} {
      # Clock termination setting
      set_instance_assignment -name XCVR_S10_REFCLK_TERM_TRISTATE TRISTATE_OFF -to mge_refclk_125m
      set_instance_assignment -name XCVR_S10_REFCLK_TERM_TRISTATE TRISTATE_OFF -to mge_refclk_10g
      set_instance_assignment -name USE_AS_3V_GPIO ON -to sfpa_txdisable
      set_instance_assignment -name USE_AS_3V_GPIO ON -to sfpa_ratesel[0]
      set_instance_assignment -name USE_AS_3V_GPIO ON -to sfpa_ratesel[1]
      set_instance_assignment -name USE_AS_3V_GPIO ON -to sfpa_los
      set_instance_assignment -name USE_AS_3V_GPIO ON -to sfpa_txfault
      set_instance_assignment -name USE_AS_3V_GPIO ON -to sfpa_mod0_prstn
      set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to sfpa_txdisable
      set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to sfpa_ratesel
      set_instance_assignment -name SLEW_RATE 1 -to sfpa_txdisable
      set_instance_assignment -name SLEW_RATE 1 -to sfpa_ratesel
      set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to sfpa_i2c_scl
      set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to sfpa_i2c_sda
      set_instance_assignment -name SLEW_RATE 1 -to sfpa_i2c_scl
      set_instance_assignment -name SLEW_RATE 1 -to sfpa_i2c_sda
   }
   
   if {$hps_mge_en == 1 || $hps_mge_10gbe_1588_en == 1} {
      set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to enet_refclk
   }
} 

if {$hps_emif_en == 1} {
source ./pin_assign_s10_emif.tcl
}

set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_ref_clk

if {$daughter_card == "devkit_dc4" || $daughter_card == "devkit_dc2" || $daughter_card == "devkit_dc_oobe"} {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_jtag_tck
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_jtag_tms
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_jtag_tdo
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_jtag_tdi 
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_jtag_tdo 
set_instance_assignment -name SLEW_RATE 1 -to hps_jtag_tdo 
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_jtag_tck
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_jtag_tms
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_jtag_tdi
}
if {$hps_sdmmc4b_q1_en == 1 || $hps_sdmmc8b_q1_en == 1 || $hps_sdmmc4b_q4_en == 1 || $hps_sdmmc8b_q4_en == 1} {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdmmc_CMD
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdmmc_CCLK
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_sdmmc_CMD
set_instance_assignment -name SLEW_RATE 1 -to hps_sdmmc_CMD
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_sdmmc_CCLK 
set_instance_assignment -name SLEW_RATE 1 -to hps_sdmmc_CCLK 
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
set_instance_assignment -name SLEW_RATE 1 -to hps_sdmmc_D${i}
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
set_instance_assignment -name SLEW_RATE 1 -to hps_usb${usb_en}_STP
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_usb${usb_en}_CLK
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_usb${usb_en}_DIR
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_usb${usb_en}_NXT
for {set j 0} {$j < 8} {incr j} {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb${usb_en}_DATA${j}
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_usb${usb_en}_DATA${j}
set_instance_assignment -name SLEW_RATE 1 -to hps_usb${usb_en}_DATA${j}
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
set_instance_assignment -name SLEW_RATE 1 -to hps_emac${emac_en}_TX_CLK
set_instance_assignment -name SLEW_RATE 1 -to hps_emac${emac_en}_TX_CTL
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_emac${emac_en}_RX_CLK
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_emac${emac_en}_RX_CTL
#set_instance_assignment -name SLEW_RATE 1 -to hps_emac${emac_en}_TX_CLK
#set_instance_assignment -name SLEW_RATE 1 -to hps_emac${emac_en}_TX_CTL
#set_instance_assignment -name OUTPUT_DELAY_CHAIN 8 -to hps_emac0_TX_CLK

for {set j 0} {$j < $emac_bits} {incr j} {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac${emac_en}_RXD${j}
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac${emac_en}_TXD${j}
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_emac${emac_en}_TXD${j}
set_instance_assignment -name SLEW_RATE 1 -to hps_emac${emac_en}_TXD${j}
#set_instance_assignment -name SLEW_RATE 1 -to hps_emac${emac_en}_TXD${j}
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_emac${emac_en}_RXD${j}
}
if {($emac_en == 0 && ($hps_mdio0_q1_en == 1 || $hps_mdio0_q3_en == 1 || $hps_mdio0_q4_en == 1)) || ($emac_en == 1 && ($hps_mdio1_q1_en == 1 || $hps_mdio1_q4_en == 1)) || ($emac_en == 2 && ($hps_mdio2_q1_en == 1 || $hps_mdio2_q3_en == 1))} {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac${emac_en}_MDIO
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac${emac_en}_MDC
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_emac${emac_en}_MDIO
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_emac${emac_en}_MDC
set_instance_assignment -name SLEW_RATE 1 -to hps_emac${emac_en}_MDIO
set_instance_assignment -name SLEW_RATE 1 -to hps_emac${emac_en}_MDC
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
set_instance_assignment -name SLEW_RATE 1 -to hps_spim${spim_en}_CLK
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_spim${spim_en}_MOSI
set_instance_assignment -name SLEW_RATE 1 -to hps_spim${spim_en}_MOSI
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_spim${spim_en}_SS0_N
set_instance_assignment -name SLEW_RATE 1 -to hps_spim${spim_en}_SS0_N
if {($hps_spim0_2ss_en == 1 && $spim_en == 0) || ($hps_spim1_2ss_en == 1 && $spim_en == 1)} {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_spim${spim_en}_SS1_N
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_spim${spim_en}_SS1_N
set_instance_assignment -name SLEW_RATE 1 -to hps_spim${spim_en}_SS1_N
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
set_instance_assignment -name SLEW_RATE 1 -to hps_spis${spis_en}_MISO
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
set_instance_assignment -name SLEW_RATE 1 -to hps_uart${uart_en}_TX
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_uart${uart_en}_RX
if {($hps_uart0_fc_en == 1 && $uart_en == 0) || ($hps_uart1_fc_en == 1 && $uart_en == 1)} {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_uart${uart_en}_CTS_N
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_uart${uart_en}_RTS_N
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_uart${uart_en}_RTS_N
set_instance_assignment -name SLEW_RATE 1 -to hps_uart${uart_en}_RTS_N
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
set_instance_assignment -name SLEW_RATE 1 -to hps_i2c${i2c_en}_SDA
set_instance_assignment -name CURRENT_STRENGTH_NEW 4MA -to hps_i2c${i2c_en}_SCL
set_instance_assignment -name SLEW_RATE 1 -to hps_i2c${i2c_en}_SCL
set_instance_assignment -name AUTO_OPEN_DRAIN_PINS ON -to hps_i2c${i2c_en}_SDA
set_instance_assignment -name AUTO_OPEN_DRAIN_PINS ON -to hps_i2c${i2c_en}_SCL
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_i2c${i2c_en}_SDA
set_instance_assignment -name SLEW_RATE 1 -to hps_i2c${i2c_en}_SDA
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_i2c${i2c_en}_SCL
set_instance_assignment -name SLEW_RATE 1 -to hps_i2c${i2c_en}_SCL
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
set_instance_assignment -name SLEW_RATE 1 -to hps_i2c_emac${i2c_emac_en}_SDA
set_instance_assignment -name SLEW_RATE 1 -to hps_i2c_emac${i2c_emac_en}_SCL
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
set_instance_assignment -name SLEW_RATE 1 -to hps_nand_WE_N
set_instance_assignment -name SLEW_RATE 1 -to hps_nand_RE_N
set_instance_assignment -name SLEW_RATE 1 -to hps_nand_WP_N 
set_instance_assignment -name SLEW_RATE 1 -to hps_nand_CLE
set_instance_assignment -name SLEW_RATE 1 -to hps_nand_ALE
set_instance_assignment -name SLEW_RATE 1 -to hps_nand_CE_N  
if {$hps_nand_16b_en == 1} {
set nand_bits 16
} else {
set nand_bits 8
}
for {set k 0} {$k < $nand_bits} {incr k} {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_nand_ADQ${k}
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_nand_ADQ${k}
set_instance_assignment -name SLEW_RATE 1 -to hps_nand_ADQ${k}
} 
}
if {$hps_trace_q12_en == 1 || $hps_trace_q34_en == 1} {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_trace_CLK
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to hps_trace_CLK
set_instance_assignment -name SLEW_RATE 1 -to hps_trace_CLK
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
set_instance_assignment -name SLEW_RATE 1 -to hps_trace_D${k}
} 
}
if {$hps_gpio0_en == 1 || $hps_gpio1_en == 1} {
if {$hps_gpio0_en == 1} {
foreach io_num $hps_gpio0_list {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_gpio0_io${io_num}
set_instance_assignment -name CURRENT_STRENGTH_NEW 2MA -to hps_gpio0_io${io_num}
set_instance_assignment -name SLEW_RATE 1 -to hps_gpio0_io${io_num}
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_gpio0_io${io_num}
}
}
if {$hps_gpio1_en == 1} {
foreach io_num $hps_gpio1_list {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_gpio1_io${io_num}
set_instance_assignment -name CURRENT_STRENGTH_NEW 2MA -to hps_gpio1_io${io_num}
set_instance_assignment -name SLEW_RATE 1 -to hps_gpio1_io${io_num}
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_gpio1_io${io_num}
}
}
}
}

if {$niosii_en == 1} {
#VID related to fix critical warnings in Assembler
set_global_assignment -name VID_OPERATION_MODE "PMBUS MASTER"
set_global_assignment -name USE_PWRMGT_SCL SDM_IO14
set_global_assignment -name USE_PWRMGT_SDA SDM_IO11
set_global_assignment -name USE_CONF_DONE SDM_IO16
set_global_assignment -name USE_INIT_DONE SDM_IO0
set_global_assignment -name PWRMGT_BUS_SPEED_MODE "400 KHZ"
set_global_assignment -name PWRMGT_PAGE_COMMAND_ENABLE ON
set_global_assignment -name PWRMGT_SLAVE_DEVICE_TYPE LTM4677
set_global_assignment -name PWRMGT_SLAVE_DEVICE0_ADDRESS 4F
set_global_assignment -name PWRMGT_SLAVE_DEVICE1_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE2_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE3_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE4_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE5_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE6_ADDRESS 00
set_global_assignment -name PWRMGT_SLAVE_DEVICE7_ADDRESS 00
set_global_assignment -name PWRMGT_PAGE_COMMAND_ENABLE ON
set_global_assignment -name PWRMGT_VOLTAGE_OUTPUT_FORMAT "AUTO DISCOVERY"
set_global_assignment -name PWRMGT_TRANSLATED_VOLTAGE_VALUE_UNIT VOLTS

# pin location assignments
set_location_assignment PIN_J33 -to fpga_clk_100
set_location_assignment PIN_BH12 -to fpga_reset_n
set_location_assignment PIN_BC21 -to fpga_led_pio[0]
set_location_assignment PIN_BC20 -to fpga_led_pio[1]
set_location_assignment PIN_BA20 -to fpga_led_pio[2]
set_location_assignment PIN_BA21 -to fpga_led_pio[3]
set_location_assignment PIN_BD21 -to fpga_led_pio[4]
set_location_assignment PIN_BB20 -to fpga_led_pio[5]
set_location_assignment PIN_AW21 -to fpga_led_pio[6]
set_location_assignment PIN_AY21 -to fpga_led_pio[7]
set_location_assignment PIN_AV20 -to fpga_dipsw_pio[0]
set_location_assignment PIN_AV21 -to fpga_dipsw_pio[1]
set_location_assignment PIN_AT19 -to fpga_dipsw_pio[2]
set_location_assignment PIN_BE19 -to fpga_dipsw_pio[3]
set_location_assignment PIN_BB18 -to fpga_dipsw_pio[4]
set_location_assignment PIN_BC18 -to fpga_dipsw_pio[5]
set_location_assignment PIN_BD18 -to fpga_dipsw_pio[6]
set_location_assignment PIN_BG17 -to fpga_button_pio[0]
set_location_assignment PIN_BE17 -to fpga_button_pio[1]
set_location_assignment PIN_BH18 -to fpga_button_pio[2]
set_location_assignment PIN_BJ19 -to fpga_button_pio[3]
set_location_assignment PIN_BF17 -to fpga_button_pio[4]
set_location_assignment PIN_BH17 -to fpga_button_pio[5]
set_location_assignment PIN_BJ18 -to fpga_button_pio[6]
set_location_assignment PIN_BJ20 -to fpga_button_pio[7]

if {$fpga_emif_en == 1} {
source ./pin_assign_s10_emif.tcl
}

set_instance_assignment -name IO_STANDARD LVDS -to fpga_clk_100
set_instance_assignment -name IO_STANDARD "1.8 V" -to fpga_reset_n
for {set z 0} {$z < 7} {incr z} {
set_instance_assignment -name IO_STANDARD "1.8 V" -to fpga_dipsw_pio[${z}]
}
for {set y 0} {$y < 8} {incr y} {
set_instance_assignment -name IO_STANDARD "1.8 V" -to fpga_led_pio[${y}]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fpga_button_pio[${y}]
}
}

if {$hps_mge_en == 1} {
for {set x 1} {$x<=$sgmii_count} {incr x} {
set_instance_assignment -name CURRENT_STRENGTH_NEW 2MA -to emac${x}_mdio
set_instance_assignment -name SLEW_RATE 1 -to emac${x}_mdio
set_instance_assignment -name CURRENT_STRENGTH_NEW 2MA -to emac${x}_mdc
set_instance_assignment -name SLEW_RATE 1 -to emac${x}_mdc
set_instance_assignment -name CURRENT_STRENGTH_NEW 2MA -to emac${x}_phy_irq
set_instance_assignment -name SLEW_RATE 1 -to emac${x}_phy_irq
set_instance_assignment -name CURRENT_STRENGTH_NEW 2MA -to emac${x}_phy_rst_n
set_instance_assignment -name SLEW_RATE 1 -to emac${x}_phy_rst_n
}
}

if {$fpga_pcie == 1} {
set_instance_assignment -name CURRENT_STRENGTH_NEW 2MA -to mux_io_1v8_20
set_instance_assignment -name SLEW_RATE 1 -to mux_io_1v8_20
}

project_close
