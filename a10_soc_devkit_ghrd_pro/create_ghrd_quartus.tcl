#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2014-2020 Intel Corporation.
#
#****************************************************************************
#
# This script generates the Quartus project for the GHRD.
# To execute this script using quartus_sh for generating Quartus QPF and QSF accordingly
#   quartus_sh --script=create_ghrd_quartus.tcl
#
#****************************************************************************

source ./design_config.tcl

set devicefamily $DEVICE_FAMILY
set device $FPGA_DEVICE
set projectname $QUARTUS_NAME
set qsysname $QSYS_NAME
set topname $SYS_TOP_NAME
set boot_device $BOOT_SOURCE
set fast_trace $FTRACE_ENABLE
set hps_sdram_ecc $HPS_SDRAM_ECC_ENABLE
set board_rev $BOARD_REV
set early_io_release $EARLY_IO_RELEASE
set qsys_pro $QSYS_PRO
set hps_sgmii $SGMII_ENABLE
set sgmii_count $SGMII_COUNT
set fpga_dp $DISP_PORT_ENABLE
set fpga_pcie $PCIE_ENABLE
set pcie_gen $GEN_ENABLE
set pcie_count $PCIE_COUNT
set frame_buffer $ADD_FRAME_BUFFER
set pr_enable $PARTIAL_RECONFIGURATION
set pr_region_count $PR_REGION_COUNT
set freeze_ack_dly_enable $FREEZE_ACK_DELAY_ENABLE
set pr_dp_mix_enable $PARTIAL_RECONFIGURATION_DISP_PORT_MIX_ENABLE
set pr_x_origin $PR_X_ORIGIN
set pr_y_origin $PR_Y_ORIGIN
set pr_width $PR_WIDTH
set pr_height $PR_HEIGHT
set niosii_en $NIOSII_ENABLE
set fpga_tse $TSE_ENABLE


# ... alternatively, above parameters can be passed in as script arguments
#   quartus_sh --script=create_ghrd_quartus.tcl <parameter1 value1 parameter2 value2 ...>
# parameters of this TCL includes
#   devicefamily     : FPGA device family
#   device           : FPGA device number
#   projectname      : Quartus project name
#   topname          : top module name
#   boot_device      : Boot source selection, either "SDMMC", "QSPI", "NAND" or "FPGA"
#   fast_trace       : enabling Fast Trace x16 to FPGA IO, 1 or 0
#   early_io_release : enabling HPS early IO release for split RBF configuration
#   hps_sdram_ecc    : enable ECC support from the HPS EMIF
#   board_rev        : selection of development board revision, A or B
#   qsys_pro         : use qsys pro or qsys classic
#   hps_sgmii        : enabling hps emac routing to FPGA for SGMII Enet, 1 or 0
#   sgmii_count      : number of SGMII Ethernet interface, support 1 to 2
#   fpga_dp          : enabling display port in FPGA
#   frame_buffer     : enabling frame buffer module for display port in FPGA
#   fpga_pcie        : enabling PCIe in FPGA
#   pcie_gen         : enabling generation select for PCIe in FPGA, support 2 or 3
#   pcie_count       : number of lanes in the PCIe interface, support 4 & 8 (x8 currently supported for gen2 only)
#   pr_enable        : enable partial reconfiguration
#   pr_region_count  : number of PR regions
#   freeze_ack_dly_enable : enable acknowledgement delay testing for freeze controller
#   pr_dp_mix_enable : enable partial reconfiguration for display port with mixer subsystem as pr region
#   pr_x_origin      : origin x coordinate of pr partition reserved region
#   pr_y_origin      : origin y coordinate of pr partition reserved region
#   pr_width         : width of pr partition reserved region
#   pr_height        : height of pr partition reserved region
#   niosii_en        : enable niosii soft processor
#   fpga_tse         : enable TSE in FPGA

proc show_arguments {} {
  global quartus
  global devicefamily
  global device
  global projectname
  global qsysname
  global topname
  global qipfiles
  global hdlfiles
  global hps_sdram_ecc
  global board_rev
  global early_io_release
  global qsys_pro
  global hps_sgmii
  global sgmii_count
  global fpga_dp
  global frame_buffer
  global boot_device
  global fast_trace
  global fpga_pcie
  global pcie_gen 
  global pcie_count
  global pr_enable
  global pr_region_count
  global freeze_ack_dly_enable
  global pr_dp_mix_enable
  global pr_x_origin
  global pr_y_origin
  global pr_width
  global pr_height
  global niosii_en
  global fpga_tse

foreach {key value} $quartus(args) {
puts "-> Accepted parameter: $key,  \tValue: $value"
if {$key == "devicefamily"} {
set devicefamily $value
}
if {$key == "device"} {
set device $value
}
if {$key == "projectname"} {
set projectname $value
}
if {$key == "qsysname"} {
set qsysname $value
}
if {$key == "topname"} {
set topname $value
}
if {$key == "boot_device"} {
set boot_device $value
}
if {$key == "fast_trace"} {
set fast_trace $value
}
if {$key == "hps_sdram_ecc"} {
set hps_sdram_ecc $value
}
if {$key == "board_rev"} {
set board_rev $value
}
if {$key == "early_io_release"} {
set early_io_release $value
}
if {$key == "qsys_pro"} {
set qsys_pro $value
}
if {$key == "hps_sgmii"} {
set hps_sgmii $value
}
if {$key == "sgmii_count"} {
set sgmii_count $value
}
if {$key == "fpga_dp"} {
set fpga_dp $value
}
if {$key == "frame_buffer"} {
set frame_buffer $value
}
if {$key == "fpga_pcie"} {
set fpga_pcie $value
}
if {$key == "pcie_gen"} {
set pcie_gen $value
}
if {$key == "pcie_count"} {
set pcie_count $value
}
if {$key == "pr_enable"} {
set pr_enable $value
}
if {$key == "pr_region_count"} {
set pr_region_count $value
}
if {$key == "freeze_ack_dly_enable"} {
set freeze_ack_dly_enable $value
}
if {$key == "pr_dp_mix_enable"} {
set pr_dp_mix_enable $value
}
if {$key == "pr_x_origin"} {
set pr_x_origin $value
}

if {$key == "pr_y_origin"} {
set pr_y_origin $value
}   

if {$key == "pr_width"} {
set pr_width $value
}

if {$key == "pr_height"} {
set pr_height $value
}

if {$key == "niosii_en"} {
set niosii_en $value
}

if {$key == "fpga_tse"} {
set fpga_tse $value
}

}
}
show_arguments

if {$qsys_pro == 0} {
set qipfiles "${qsysname}/${qsysname}.qip"
} else {
set qipfiles ""
}
set qsysfile "${qsysname}.qsys"
set hdlfiles "${SYS_TOP_NAME}.v,custom_ip/debounce/debounce.v,custom_ip/edge_detect/altera_edge_detector.v"

if {$fpga_dp == 1} {
if {$qsys_pro == 0} {
set qipfiles "${qipfiles},./custom_ip/diffin/diffin.qip"
}
set hdlfiles "${hdlfiles},intel_custom_ip/buslvds/buslvds.v,intel_custom_ip/pdo/pdo.v,intel_custom_ip/bitec_reconfig_alt_a10/bitec_reconfig_alt_a10.v"
}

if {$freeze_ack_dly_enable == 1 && $pr_enable == 1} {
set hdlfiles "${hdlfiles},custom_ip/ack_delay_logic/ack_delay_logic.sv"
}

#regsub -all {\mfoo\M} $string bar string
#set wordList [regexp -inline -all -- {\S+} $text]
if {[regexp {,} $qipfiles]} {
  set qipfilelist [split $qipfiles ,]
} else {
  set qipfilelist $qipfiles
}

if {[regexp {,} $hdlfiles]} {
  set hdlfilelist [split $hdlfiles ,]
} else {
  set hdlfilelist $hdlfiles
}

project_new -overwrite -family $devicefamily -part $device $projectname

set_global_assignment -name TOP_LEVEL_ENTITY $topname

set_global_assignment -name IP_SEARCH_PATHS "intel_custom_ip/**/*;custom_ip/**/*"

foreach qipfile $qipfilelist {
  set_global_assignment -name QIP_FILE $qipfile
}

foreach hdlfile $hdlfilelist {
  set_global_assignment -name VERILOG_FILE $hdlfile
}
set_global_assignment -name QSYS_FILE $qsysfile
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
set_global_assignment -name SDC_FILE ghrd_timing.sdc
if {$hps_sgmii == 1} {
set_global_assignment -name SDC_FILE hps_sgmii.sdc
}
if {$fpga_dp == 1} {
set_global_assignment -name SDC_FILE fpga_dp.sdc
}
if {$fpga_pcie == 1} {
set_global_assignment -name SDC_FILE fpga_pcie.sdc
}
if {$freeze_ack_dly_enable == 1 && $pr_enable == 1} {
set_global_assignment -name SDC_FILE fpga_pr.sdc
}
if {$niosii_en == 1} {
set_global_assignment -name SDC_FILE fpga_niosii.sdc
}
if {$fpga_tse == 1} {
set_global_assignment -name SDC_FILE fpga_sgmii.sdc
}

# enabling signaltap
if {$CROSS_TRIGGER_ENABLE == 1} { 
set_global_assignment -name ENABLE_SIGNALTAP ON
set_global_assignment -name USE_SIGNALTAP_FILE cti_tapping.stp
set_global_assignment -name SIGNALTAP_FILE cti_tapping.stp
}

if {$early_io_release == 1} {
set_global_assignment -name HPS_EARLY_IO_RELEASE ON
}
if {$niosii_en == 1} {
set_global_assignment -name OPTIMIZATION_MODE "HIGH PERFORMANCE EFFORT"
# set_global_assignment -name INI_VARS "ASM_ENABLE_ADVANCED_DEVICES=ON;PTI_ENABLE_TIMING_ON_PROGRAMMINS_PINS=ON;FIOMGR_ENABLE_SPI_TIMING=ON"
set_global_assignment -name ROUTER_TIMING_OPTIMIZATION_LEVEL MAXIMUM
}
set_global_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON

set_global_assignment -name GENERATE_RBF_FILE ON

if {$fpga_dp == 1} {
set_global_assignment -name QIP_FILE intel_custom_ip/nios2_display_port/dp_a10ghrd/mem_init/meminit.qip
}

if {$pcie_count == 8 || $pcie_gen == 3} {
set_global_assignment -name OPTIMIZATION_MODE "SUPERIOR PERFORMANCE WITH MAXIMUM PLACEMENT EFFORT"
set_global_assignment -name ROUTER_TIMING_OPTIMIZATION_LEVEL MAXIMUM
#set_global_assignment -name QII_AUTO_PACKED_REGISTERS NORMAL
#set_global_assignment -name OPTIMIZATION_MODE "HIGH PERFORMANCE EFFORT"
#set_global_assignment -name OPTIMIZATION_MODE "AGGRESSIVE PERFORMANCE"
#set_global_assignment -name OPTIMIZATION_TECHNIQUE SPEED
set_global_assignment -name AUTO_DELAY_CHAINS_FOR_HIGH_FANOUT_INPUT_PINS ON
#set_global_assignment -name ROUTER_LCELL_INSERTION_AND_LOGIC_DUPLICATION ON
set_global_assignment -name SEED 2
}

if {$pr_enable == 1} {
set_global_assignment -name ROUTER_TIMING_OPTIMIZATION_LEVEL MAXIMUM
set_global_assignment -name OPTIMIZATION_MODE "HIGH PERFORMANCE EFFORT"
set_global_assignment -name OPTIMIZATION_TECHNIQUE SPEED
}
#added IOPLL required to set the global signal off for reset controller output
# set_instance_assignment -name GLOBAL_SIGNAL OFF -to "ghrd_10as066n2:soc_inst|altera_reset_controller:*|altera_reset_synchronizer:alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out"

#HSDES:1408905471. Fixed HOLD VIOLATION for 'altera_reserved_tck'
set_instance_assignment -name GLOBAL_SIGNAL GLOBAL_CLOCK -to auto_fab_0|alt_sld_fab_0|alt_sld_fab_0|jtagpins|atom_inst|core_tck 

# pin location assignments
set_location_assignment PIN_AM10 -to fpga_clk_100
set_location_assignment PIN_AV21 -to fpga_reset_n
set_location_assignment PIN_AR23 -to fpga_led_pio[0]
set_location_assignment PIN_AR22 -to fpga_led_pio[1]
set_location_assignment PIN_AM21 -to fpga_led_pio[2]
set_location_assignment PIN_AL20 -to fpga_led_pio[3]
set_location_assignment PIN_P3 -to fpga_dipsw_pio[0]
set_location_assignment PIN_P4 -to fpga_dipsw_pio[1]
set_location_assignment PIN_P1 -to fpga_dipsw_pio[2]
set_location_assignment PIN_R1 -to fpga_dipsw_pio[3]
set_location_assignment PIN_R5 -to fpga_button_pio[0]
set_location_assignment PIN_T5 -to fpga_button_pio[1]
set_location_assignment PIN_P5 -to fpga_button_pio[2]
set_location_assignment PIN_P6 -to fpga_button_pio[3]

if {$hps_sgmii == 1 || $fpga_tse == 1} {
set_location_assignment PIN_AG29 -to pcs_clk_125

if {$hps_sgmii == 1} {
set_location_assignment PIN_AG33 -to emac1_sgmii_rxp                                 
set_location_assignment PIN_AG32 -to "emac1_sgmii_rxp(n)"                                 
set_location_assignment PIN_AK39 -to emac1_sgmii_txp                                 
set_location_assignment PIN_AK38 -to "emac1_sgmii_txp(n)"  
set_location_assignment PIN_AR20 -to emac1_fpga_mdc
set_location_assignment PIN_AV16 -to emac1_fpga_mdio
set_location_assignment PIN_N2 -to sgmii1_phy_irq_n
set_location_assignment PIN_N1 -to sgmii1_phy_reset_n
if {$sgmii_count == 2} {                               
set_location_assignment PIN_AV17 -to emac2_fpga_mdc
set_location_assignment PIN_AW20 -to emac2_fpga_mdio
set_location_assignment PIN_R3 -to sgmii2_phy_irq_n
set_location_assignment PIN_R2 -to sgmii2_phy_reset_n
set_location_assignment PIN_AH35 -to emac2_sgmii_rxp                                 
set_location_assignment PIN_AH34 -to "emac2_sgmii_rxp(n)"                                 
set_location_assignment PIN_AL37 -to emac2_sgmii_txp                                 
set_location_assignment PIN_AL36 -to "emac2_sgmii_txp(n)" 
}
}

if {$fpga_tse == 1} {
set_location_assignment PIN_AG33 -to mac0_sgmii_rxp                                 
set_location_assignment PIN_AG32 -to "mac0_sgmii_rxp(n)"                                 
set_location_assignment PIN_AK39 -to mac0_sgmii_txp                                 
set_location_assignment PIN_AK38 -to "mac0_sgmii_txp(n)"  
set_location_assignment PIN_AR20 -to mac0_fpga_mdc
set_location_assignment PIN_AV16 -to mac0_fpga_mdio
set_location_assignment PIN_N2 -to sgmii0_phy_irq_n
set_location_assignment PIN_N1 -to sgmii0_phy_reset_n                            
set_location_assignment PIN_AV17 -to mac1_fpga_mdc
set_location_assignment PIN_AW20 -to mac1_fpga_mdio
set_location_assignment PIN_R3 -to sgmii1_phy_irq_n
set_location_assignment PIN_R2 -to sgmii1_phy_reset_n
set_location_assignment PIN_AH35 -to mac1_sgmii_rxp                                 
set_location_assignment PIN_AH34 -to "mac1_sgmii_rxp(n)"                                 
set_location_assignment PIN_AL37 -to mac1_sgmii_txp                                 
set_location_assignment PIN_AL36 -to "mac1_sgmii_txp(n)" 
}

}

if {$fpga_dp == 1} {
set_location_assignment PIN_AT22 -to dp_aux_ch_n
set_location_assignment PIN_AU22 -to dp_aux_ch_p
set_location_assignment PIN_N4 -to tx_hpd
set_location_assignment PIN_N3 -to dp_on
set_location_assignment PIN_G29 -to dp_refclk
set_location_assignment PIN_B35 -to dp_tx_serial_out[0]
set_location_assignment PIN_A37 -to dp_tx_serial_out[1]
set_location_assignment PIN_B39 -to dp_tx_serial_out[2]
set_location_assignment PIN_C37 -to dp_tx_serial_out[3]
}

if {$fpga_pcie == 1} {
set_location_assignment PIN_AE29 -to pcie_refclk_100
set_location_assignment PIN_AE33 -to pcie_rx_serial_in[0]
set_location_assignment PIN_AD31 -to pcie_rx_serial_in[1]
set_location_assignment PIN_AD35 -to pcie_rx_serial_in[2]
set_location_assignment PIN_AC33 -to pcie_rx_serial_in[3]
set_location_assignment PIN_AG37 -to pcie_tx_serial_out[0]
set_location_assignment PIN_AF39 -to pcie_tx_serial_out[1]
set_location_assignment PIN_AE37 -to pcie_tx_serial_out[2]
set_location_assignment PIN_AD39 -to pcie_tx_serial_out[3]
if {$pcie_count == 8} {
set_location_assignment PIN_AB31 -to pcie_rx_serial_in[4]
set_location_assignment PIN_AB35 -to pcie_rx_serial_in[5]
set_location_assignment PIN_AA33 -to pcie_rx_serial_in[6]
set_location_assignment PIN_Y35  -to pcie_rx_serial_in[7]
set_location_assignment PIN_AC37 -to pcie_tx_serial_out[4]
set_location_assignment PIN_AB39 -to pcie_tx_serial_out[5]
set_location_assignment PIN_AA37 -to pcie_tx_serial_out[6]
set_location_assignment PIN_Y39  -to pcie_tx_serial_out[7]
}
set_location_assignment PIN_AV18 -to pcie_a10_hip_npor_pin_perst
}

set_instance_assignment -name IO_STANDARD LVDS -to fpga_clk_100
set_instance_assignment -name IO_STANDARD "1.8 V" -to fpga_reset_n
for {set k 0} {$k < 4} {incr k} {
set_instance_assignment -name IO_STANDARD "1.8 V" -to fpga_dipsw_pio[${k}]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fpga_led_pio[${k}]
set_instance_assignment -name IO_STANDARD "1.8 V" -to fpga_button_pio[${k}]
}

if {$hps_sgmii == 1 || $fpga_tse == 1} {
set_instance_assignment -name IO_STANDARD LVDS -to pcs_clk_125
set_instance_assignment -name IO_STANDARD LVDS -to "pcs_clk_125(n)"

if {$hps_sgmii == 1} {
for {set z 1} {$z <= $sgmii_count} {incr z} {
set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to emac${z}_sgmii_txp
set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to emac${z}_sgmii_rxp
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to emac${z}_sgmii_txp
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "emac${z}_sgmii_txp(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to emac${z}_sgmii_rxp
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "emac${z}_sgmii_rxp(n)"
}
}

if {$fpga_tse == 1} {
for {set m 0} {$m < 2} {incr m} {
set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to mac${m}_sgmii_txp
set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to mac${m}_sgmii_rxp
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to mac${m}_sgmii_txp
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "mac${m}_sgmii_txp(n)"
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to mac${m}_sgmii_rxp
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to "mac${m}_sgmii_rxp(n)"
}
}
}

if {$fpga_dp == 1} {
set_instance_assignment -name IO_STANDARD "1.8 V" -to tx_hpd
set_instance_assignment -name IO_STANDARD "1.8 V" -to dp_on
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to dp_aux_ch_n
set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to dp_aux_ch_p
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.8-V SSTL CLASS I" -to dp_aux_ch_n
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.8-V SSTL CLASS I" -to dp_aux_ch_p
set_instance_assignment -name IO_STANDARD LVDS -to dp_refclk
for {set i 0} {$i < 4} {incr i} {
set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to dp_tx_serial_out[${i}]
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to dp_tx_serial_out[${i}]
}
}

if {$fpga_pcie == 1} {
set_instance_assignment -name IO_STANDARD HCSL -to pcie_refclk_100
set_instance_assignment -name IO_STANDARD "1.8 V" -to pcie_a10_hip_npor_pin_perst

if {$pcie_count == 8} {
set number_of_lanes 8
} else {
set number_of_lanes 4
}

for {set j 0} {$j < $number_of_lanes} {incr j} {
set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to pcie_tx_serial_out[${j}]
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to pcie_tx_serial_out[${j}]
set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to pcie_rx_serial_in[${j}]
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to pcie_rx_serial_in[${j}]
}

if {$pcie_count == 8 || $pcie_gen == 3} {
set_instance_assignment -name GLOBAL_SIGNAL OFF -to "soc_inst|*|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain_out"
set_instance_assignment -name GLOBAL_SIGNAL OFF -to "soc_inst|*|g_avmm_128.avmm_128.avalon_bridge|rstn_rr"
}

}

if {$pr_enable == 1 && $pr_dp_mix_enable == 0} {
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

if {$pr_enable == 1 && $pr_dp_mix_enable == 1} {
#PR partition reserved area region
set place_lower_x_coord $pr_x_origin
set place_lower_y_coord $pr_y_origin
set place_upper_x_coord [expr $pr_x_origin + $pr_width - 1]
set place_upper_y_coord [expr $pr_y_origin + $pr_height - 1]
set_global_assignment -name REVISION_TYPE PR_BASE
set_instance_assignment -name GLOBAL_SIGNAL GLOBAL_CLOCK -to fpga_clk_100
set_instance_assignment -name PARTITION pr_partition_0 -to soc_inst|dp_0|mixer_0
set_instance_assignment -name PARTIAL_RECONFIGURATION_PARTITION ON -to soc_inst|dp_0|mixer_0
set_instance_assignment -name PLACE_REGION "$place_lower_x_coord $place_lower_y_coord $place_upper_x_coord $place_upper_y_coord" -to soc_inst|dp_0|mixer_0
set_instance_assignment -name ROUTE_REGION "0 0 148 224" -to soc_inst|dp_0|mixer_0
# set_instance_assignment -name PLACE_REGION "8 115 51 163" -to soc_inst|dp_0|mixer_0
# set_instance_assignment -name ROUTE_REGION "7 114 52 164" -to soc_inst|dp_0|mixer_0
set_instance_assignment -name RESERVE_PLACE_REGION ON -to soc_inst|dp_0|mixer_0
set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to soc_inst|dp_0|mixer_0
}

if {$niosii_en == 1} {
set_global_assignment -name ENABLE_OCT_DONE ON
set_global_assignment -name STRATIXV_CONFIGURATION_SCHEME "ACTIVE SERIAL X4"
set_global_assignment -name USE_CONFIGURATION_DEVICE ON
set_global_assignment -name STRATIXII_CONFIGURATION_DEVICE EPCQL1024
set_location_assignment PIN_AN3 -to a10_emif_mem_mem_a[0]
set_location_assignment PIN_AM4 -to a10_emif_mem_mem_a[1]
set_location_assignment PIN_AL3 -to a10_emif_mem_mem_a[2]
set_location_assignment PIN_AL4 -to a10_emif_mem_mem_a[3]
set_location_assignment PIN_AL5 -to a10_emif_mem_mem_a[4]
set_location_assignment PIN_AK5 -to a10_emif_mem_mem_a[5]
set_location_assignment PIN_AK6 -to a10_emif_mem_mem_a[6]
set_location_assignment PIN_AJ6 -to a10_emif_mem_mem_a[7]
set_location_assignment PIN_AK3 -to a10_emif_mem_mem_a[8]
set_location_assignment PIN_AJ4 -to a10_emif_mem_mem_a[9]
set_location_assignment PIN_AJ5 -to a10_emif_mem_mem_a[10]
set_location_assignment PIN_AH6 -to a10_emif_mem_mem_a[11]
set_location_assignment PIN_AG7 -to a10_emif_mem_mem_a[12]
set_location_assignment PIN_AJ3 -to a10_emif_mem_mem_a[13]
set_location_assignment PIN_AH3 -to a10_emif_mem_mem_a[14]
set_location_assignment PIN_AF7 -to a10_emif_mem_mem_a[15]
set_location_assignment PIN_AE7 -to a10_emif_mem_mem_a[16]
set_location_assignment PIN_AL2 -to a10_emif_mem_mem_act_n
set_location_assignment PIN_AF9 -to a10_emif_mem_mem_alert_n
set_location_assignment PIN_AF5 -to a10_emif_mem_mem_ba[0]
set_location_assignment PIN_AH4 -to a10_emif_mem_mem_ba[1]
set_location_assignment PIN_AG4 -to a10_emif_mem_mem_bg[0]
set_location_assignment PIN_AK1 -to a10_emif_mem_mem_ck[0]
set_location_assignment PIN_AK2 -to a10_emif_mem_mem_ck_n[0]
set_location_assignment PIN_AM1 -to a10_emif_mem_mem_cke[0]
set_location_assignment PIN_AM2 -to a10_emif_mem_mem_cs_n[0]
set_location_assignment PIN_AH8 -to a10_emif_mem_mem_dbi_n[0]
set_location_assignment PIN_AM6 -to a10_emif_mem_mem_dbi_n[1]
set_location_assignment PIN_AM5 -to a10_emif_mem_mem_dbi_n[2]
set_location_assignment PIN_AT4 -to a10_emif_mem_mem_dbi_n[3]
set_location_assignment PIN_AA10 -to a10_emif_mem_mem_dbi_n[4]
set_location_assignment PIN_AB5 -to a10_emif_mem_mem_dbi_n[5]
set_location_assignment PIN_AB2 -to a10_emif_mem_mem_dbi_n[6]
set_location_assignment PIN_AC1 -to a10_emif_mem_mem_dbi_n[7]
set_location_assignment PIN_AE11 -to a10_emif_mem_mem_dbi_n[8]
set_location_assignment PIN_AG12 -to a10_emif_mem_mem_dq[0]
set_location_assignment PIN_AJ9 -to a10_emif_mem_mem_dq[1]
set_location_assignment PIN_AH9 -to a10_emif_mem_mem_dq[2]
set_location_assignment PIN_AF12 -to a10_emif_mem_mem_dq[3]
set_location_assignment PIN_AH11 -to a10_emif_mem_mem_dq[4]
set_location_assignment PIN_AG11 -to a10_emif_mem_mem_dq[5]
set_location_assignment PIN_AJ8 -to a10_emif_mem_mem_dq[6]
set_location_assignment PIN_AJ11 -to a10_emif_mem_mem_dq[7]
set_location_assignment PIN_AK8 -to a10_emif_mem_mem_dq[8]
set_location_assignment PIN_AL8 -to a10_emif_mem_mem_dq[9]
set_location_assignment PIN_AK10 -to a10_emif_mem_mem_dq[10]
set_location_assignment PIN_AL9 -to a10_emif_mem_mem_dq[11]
set_location_assignment PIN_AN6 -to a10_emif_mem_mem_dq[12]
set_location_assignment PIN_AK7 -to a10_emif_mem_mem_dq[13]
set_location_assignment PIN_AM9 -to a10_emif_mem_mem_dq[14]
set_location_assignment PIN_AL7 -to a10_emif_mem_mem_dq[15]
set_location_assignment PIN_AR3 -to a10_emif_mem_mem_dq[16]
set_location_assignment PIN_AU2 -to a10_emif_mem_mem_dq[17]
set_location_assignment PIN_AP4 -to a10_emif_mem_mem_dq[18]
set_location_assignment PIN_AP3 -to a10_emif_mem_mem_dq[19]
set_location_assignment PIN_AN4 -to a10_emif_mem_mem_dq[20]
set_location_assignment PIN_AU1 -to a10_emif_mem_mem_dq[21]
set_location_assignment PIN_AP5 -to a10_emif_mem_mem_dq[22]
set_location_assignment PIN_AT3 -to a10_emif_mem_mem_dq[23]
set_location_assignment PIN_AU4 -to a10_emif_mem_mem_dq[24]
set_location_assignment PIN_AW5 -to a10_emif_mem_mem_dq[25]
set_location_assignment PIN_AU5 -to a10_emif_mem_mem_dq[26]
set_location_assignment PIN_AV4 -to a10_emif_mem_mem_dq[27]
set_location_assignment PIN_AW4 -to a10_emif_mem_mem_dq[28]
set_location_assignment PIN_AR6 -to a10_emif_mem_mem_dq[29]
set_location_assignment PIN_AR7 -to a10_emif_mem_mem_dq[30]
set_location_assignment PIN_AT5 -to a10_emif_mem_mem_dq[31]
set_location_assignment PIN_Y8 -to a10_emif_mem_mem_dq[32]
set_location_assignment PIN_AB11 -to a10_emif_mem_mem_dq[33]
set_location_assignment PIN_AB10 -to a10_emif_mem_mem_dq[34]
set_location_assignment PIN_AB9 -to a10_emif_mem_mem_dq[35]
set_location_assignment PIN_W8 -to a10_emif_mem_mem_dq[36]
set_location_assignment PIN_Y10 -to a10_emif_mem_mem_dq[37]
set_location_assignment PIN_AA9 -to a10_emif_mem_mem_dq[38]
set_location_assignment PIN_AB7 -to a10_emif_mem_mem_dq[39]
set_location_assignment PIN_Y6 -to a10_emif_mem_mem_dq[40]
set_location_assignment PIN_Y7 -to a10_emif_mem_mem_dq[41]
set_location_assignment PIN_AA5 -to a10_emif_mem_mem_dq[42]
set_location_assignment PIN_Y5 -to a10_emif_mem_mem_dq[43]
set_location_assignment PIN_AD4 -to a10_emif_mem_mem_dq[44]
set_location_assignment PIN_AC6 -to a10_emif_mem_mem_dq[45]
set_location_assignment PIN_AD5 -to a10_emif_mem_mem_dq[46]
set_location_assignment PIN_AB6 -to a10_emif_mem_mem_dq[47]
set_location_assignment PIN_AB4 -to a10_emif_mem_mem_dq[48]
set_location_assignment PIN_W1 -to a10_emif_mem_mem_dq[49]
set_location_assignment PIN_Y1 -to a10_emif_mem_mem_dq[50]
set_location_assignment PIN_AA4 -to a10_emif_mem_mem_dq[51]
set_location_assignment PIN_Y3 -to a10_emif_mem_mem_dq[52]
set_location_assignment PIN_AB1 -to a10_emif_mem_mem_dq[53]
set_location_assignment PIN_Y2 -to a10_emif_mem_mem_dq[54]
set_location_assignment PIN_AC4 -to a10_emif_mem_mem_dq[55]
set_location_assignment PIN_AE3 -to a10_emif_mem_mem_dq[56]
set_location_assignment PIN_AE2 -to a10_emif_mem_mem_dq[57]
set_location_assignment PIN_AE1 -to a10_emif_mem_mem_dq[58]
set_location_assignment PIN_AF3 -to a10_emif_mem_mem_dq[59]
set_location_assignment PIN_AG2 -to a10_emif_mem_mem_dq[60]
set_location_assignment PIN_AF2 -to a10_emif_mem_mem_dq[61]
set_location_assignment PIN_AD3 -to a10_emif_mem_mem_dq[62]
set_location_assignment PIN_AD1 -to a10_emif_mem_mem_dq[63]
set_location_assignment PIN_AD9 -to a10_emif_mem_mem_dq[64]
set_location_assignment PIN_AE10 -to a10_emif_mem_mem_dq[65]
set_location_assignment PIN_AC8 -to a10_emif_mem_mem_dq[66]
set_location_assignment PIN_AC9 -to a10_emif_mem_mem_dq[67]
set_location_assignment PIN_AD8 -to a10_emif_mem_mem_dq[68]
set_location_assignment PIN_AC11 -to a10_emif_mem_mem_dq[69]
set_location_assignment PIN_AD10 -to a10_emif_mem_mem_dq[70]
set_location_assignment PIN_AF10 -to a10_emif_mem_mem_dq[71]
set_location_assignment PIN_AG9 -to a10_emif_mem_mem_dqs[0]
set_location_assignment PIN_AN7 -to a10_emif_mem_mem_dqs[1]
set_location_assignment PIN_AR5 -to a10_emif_mem_mem_dqs[2]
set_location_assignment PIN_AW6 -to a10_emif_mem_mem_dqs[3]
set_location_assignment PIN_AA7 -to a10_emif_mem_mem_dqs[4]
set_location_assignment PIN_AE5 -to a10_emif_mem_mem_dqs[5]
set_location_assignment PIN_AA2 -to a10_emif_mem_mem_dqs[6]
set_location_assignment PIN_AH1 -to a10_emif_mem_mem_dqs[7]
set_location_assignment PIN_AF8 -to a10_emif_mem_mem_dqs[8]
set_location_assignment PIN_AG10 -to a10_emif_mem_mem_dqs_n[0]
set_location_assignment PIN_AM7 -to a10_emif_mem_mem_dqs_n[1]
set_location_assignment PIN_AP6 -to a10_emif_mem_mem_dqs_n[2]
set_location_assignment PIN_AV6 -to a10_emif_mem_mem_dqs_n[3]
set_location_assignment PIN_AA8 -to a10_emif_mem_mem_dqs_n[4]
set_location_assignment PIN_AE6 -to a10_emif_mem_mem_dqs_n[5]
set_location_assignment PIN_AA3 -to a10_emif_mem_mem_dqs_n[6]
set_location_assignment PIN_AG1 -to a10_emif_mem_mem_dqs_n[7]
set_location_assignment PIN_AE8 -to a10_emif_mem_mem_dqs_n[8]
set_location_assignment PIN_AR1 -to a10_emif_mem_mem_odt[0]
set_location_assignment PIN_AH2 -to a10_emif_mem_mem_par
set_location_assignment PIN_AN2 -to a10_emif_mem_mem_reset_n
set_location_assignment PIN_AG5 -to a10_emif_pll_ref_clk_clock_clk
set_location_assignment PIN_AH7 -to a10_emif_oct_oct_rzqin
set_location_assignment PIN_AU21 -to uart_rx
set_location_assignment PIN_AV22 -to uart_tx

# set_location_assignment PIN_AH17 -to qspi_io0    
# set_location_assignment PIN_AK17 -to qspi_io1   
# set_location_assignment PIN_AK16 -to qspi_io2_wpn
# set_location_assignment PIN_AK18 -to qspi_io3_hold
# set_location_assignment PIN_AJ18 -to qspi_clk  
# set_location_assignment PIN_AJ16 -to qspi_ss0

# set_instance_assignment -name IO_STANDARD "1.8 V" -to qspi_io0    
# set_instance_assignment -name IO_STANDARD "1.8 V" -to qspi_io1   
# set_instance_assignment -name IO_STANDARD "1.8 V" -to qspi_io2_wpn
# set_instance_assignment -name IO_STANDARD "1.8 V" -to qspi_io3_hold
# set_instance_assignment -name IO_STANDARD "1.8 V" -to qspi_clk  
# set_instance_assignment -name IO_STANDARD "1.8 V" -to qspi_ss0

set_instance_assignment -name IO_STANDARD "1.8 V" -to uart_rx    
set_instance_assignment -name IO_STANDARD "1.8 V" -to uart_tx 

#fix recovery timing for DDR reset
set_instance_assignment -name GLOBAL_SIGNAL OFF -to "ghrd_10as066n2:soc_inst|*|altera_reset_synchronizer_int_chain_out"
set_instance_assignment -name GLOBAL_SIGNAL OFF -to "ghrd_10as066n2:soc_inst|*|r_sync_rst"
} else {
if {$HPS_SDRAM_DEVICE == "D9RPL" || $HPS_SDRAM_DEVICE == "D9PZN" || $HPS_SDRAM_DEVICE == "D9RGX" || $HPS_SDRAM_DEVICE == "D9TNZ"} {
set_location_assignment PIN_F25 -to emif_ref_clk
set_location_assignment PIN_G24 -to "emif_ref_clk(n)"
set_location_assignment PIN_E26 -to hps_memory_oct_rzqin

if {$fast_trace == 1} {
set_location_assignment PIN_AU17 -to ftrace_data[15]
set_location_assignment PIN_AU20 -to ftrace_data[14]
set_location_assignment PIN_AT20 -to ftrace_data[13]
set_location_assignment PIN_AU19 -to ftrace_data[12]
set_location_assignment PIN_AT19 -to ftrace_data[11]
set_location_assignment PIN_AT17 -to ftrace_data[10]
set_location_assignment PIN_AR17 -to ftrace_data[9]
set_location_assignment PIN_AT18 -to ftrace_data[8]
set_location_assignment PIN_AR18 -to ftrace_data[7]
set_location_assignment PIN_AP19 -to ftrace_data[6]
set_location_assignment PIN_AN19 -to ftrace_data[5]
set_location_assignment PIN_AR16 -to ftrace_data[4]
set_location_assignment PIN_AP16 -to ftrace_data[3]
set_location_assignment PIN_AN16 -to ftrace_data[2]
set_location_assignment PIN_AM16 -to ftrace_data[1]
set_location_assignment PIN_AM19 -to ftrace_data[0]
set_location_assignment PIN_AU16 -to ftrace_clk
}

# instance assignments
set_instance_assignment -name IO_STANDARD LVDS -to emif_ref_clk
set_instance_assignment -name IO_STANDARD LVDS -to "emif_ref_clk(n)"
if {$HPS_SDRAM_DEVICE == "D9RGX" || $HPS_SDRAM_DEVICE == "D9TNZ"} {
  set_location_assignment PIN_AG24 -to hps_memory_mem_alert_n
}
}

if {$fast_trace == 1} {
set_instance_assignment -name IO_STANDARD "1.8 V" -to ftrace_clk
for {set l 0} {$l < 16} {incr l} {
set_instance_assignment -name IO_STANDARD "1.8 V" -to ftrace_data[${l}]
}
}

# HPS peripherals assignments
set_location_assignment PIN_H18 -to hps_emac0_TX_CLK
set_location_assignment PIN_H19 -to hps_emac0_TX_CTL
set_location_assignment PIN_E20 -to hps_emac0_TXD0
set_location_assignment PIN_F20 -to hps_emac0_TXD1
set_location_assignment PIN_F19 -to hps_emac0_TXD2
set_location_assignment PIN_G19 -to hps_emac0_TXD3
set_location_assignment PIN_F18 -to hps_emac0_RX_CLK
set_location_assignment PIN_G17 -to hps_emac0_RX_CTL
set_location_assignment PIN_G20 -to hps_emac0_RXD0
set_location_assignment PIN_G21 -to hps_emac0_RXD1
set_location_assignment PIN_F22 -to hps_emac0_RXD2
set_location_assignment PIN_G22 -to hps_emac0_RXD3
set_location_assignment PIN_K20 -to hps_emac0_MDC
set_location_assignment PIN_K21 -to hps_emac0_MDIO

set_location_assignment PIN_B21 -to hps_memory_mem_act_n
set_location_assignment PIN_J24 -to hps_memory_mem_bg
set_location_assignment PIN_A18 -to hps_memory_mem_par
set_location_assignment PIN_B26 -to hps_memory_mem_a[0]
set_location_assignment PIN_C26 -to hps_memory_mem_a[1]
set_location_assignment PIN_C22 -to hps_memory_mem_a[2]
set_location_assignment PIN_C21 -to hps_memory_mem_a[3]
set_location_assignment PIN_C25 -to hps_memory_mem_a[4]
set_location_assignment PIN_B24 -to hps_memory_mem_a[5]
set_location_assignment PIN_B22 -to hps_memory_mem_a[6]
set_location_assignment PIN_C23 -to hps_memory_mem_a[7]
set_location_assignment PIN_D23 -to hps_memory_mem_a[8]
set_location_assignment PIN_E23 -to hps_memory_mem_a[9]
set_location_assignment PIN_C24 -to hps_memory_mem_a[10]
set_location_assignment PIN_D24 -to hps_memory_mem_a[11]
set_location_assignment PIN_F26 -to hps_memory_mem_a[12]
set_location_assignment PIN_G26 -to hps_memory_mem_a[13]
set_location_assignment PIN_G25 -to hps_memory_mem_a[14]
set_location_assignment PIN_F24 -to hps_memory_mem_a[15]
set_location_assignment PIN_F23 -to hps_memory_mem_a[16]
set_location_assignment PIN_E25 -to hps_memory_mem_ba[0]
set_location_assignment PIN_H24 -to hps_memory_mem_ba[1]
set_location_assignment PIN_B20 -to hps_memory_mem_ck
set_location_assignment PIN_B19 -to hps_memory_mem_ck_n
set_location_assignment PIN_A24 -to hps_memory_mem_cke
set_location_assignment PIN_A22 -to hps_memory_mem_cs_n
set_location_assignment PIN_A19 -to hps_memory_mem_reset_n
set_location_assignment PIN_A26 -to hps_memory_mem_odt
set_location_assignment PIN_AN26 -to hps_memory_mem_dbi_n[0]
set_location_assignment PIN_AU25 -to hps_memory_mem_dbi_n[1]
set_location_assignment PIN_AV26 -to hps_memory_mem_dbi_n[2]
set_location_assignment PIN_AH25 -to hps_memory_mem_dbi_n[3]
set_location_assignment PIN_AP26 -to hps_memory_mem_dq[0]
set_location_assignment PIN_AN24 -to hps_memory_mem_dq[1]
set_location_assignment PIN_AN23 -to hps_memory_mem_dq[2]
set_location_assignment PIN_AM24 -to hps_memory_mem_dq[3]
set_location_assignment PIN_AK26 -to hps_memory_mem_dq[4]
set_location_assignment PIN_AL23 -to hps_memory_mem_dq[5]
set_location_assignment PIN_AL26 -to hps_memory_mem_dq[6]
set_location_assignment PIN_AK23 -to hps_memory_mem_dq[7]
set_location_assignment PIN_AP23 -to hps_memory_mem_dq[8]
set_location_assignment PIN_AT26 -to hps_memory_mem_dq[9]
set_location_assignment PIN_AR26 -to hps_memory_mem_dq[10]
set_location_assignment PIN_AR25 -to hps_memory_mem_dq[11]
set_location_assignment PIN_AT23 -to hps_memory_mem_dq[12]
set_location_assignment PIN_AP25 -to hps_memory_mem_dq[13]
set_location_assignment PIN_AU24 -to hps_memory_mem_dq[14]
set_location_assignment PIN_AU26 -to hps_memory_mem_dq[15]
set_location_assignment PIN_AU28 -to hps_memory_mem_dq[16]
set_location_assignment PIN_AU27 -to hps_memory_mem_dq[17]
set_location_assignment PIN_AV23 -to hps_memory_mem_dq[18]
set_location_assignment PIN_AW28 -to hps_memory_mem_dq[19]
set_location_assignment PIN_AV24 -to hps_memory_mem_dq[20]
set_location_assignment PIN_AW24 -to hps_memory_mem_dq[21]
set_location_assignment PIN_AV28 -to hps_memory_mem_dq[22]
set_location_assignment PIN_AV27 -to hps_memory_mem_dq[23]
set_location_assignment PIN_AH24 -to hps_memory_mem_dq[24]
set_location_assignment PIN_AH23 -to hps_memory_mem_dq[25]
set_location_assignment PIN_AG25 -to hps_memory_mem_dq[26]
set_location_assignment PIN_AF24 -to hps_memory_mem_dq[27]
set_location_assignment PIN_AF25 -to hps_memory_mem_dq[28]
set_location_assignment PIN_AJ24 -to hps_memory_mem_dq[29]
set_location_assignment PIN_AJ23 -to hps_memory_mem_dq[30]
set_location_assignment PIN_AJ26 -to hps_memory_mem_dq[31]
set_location_assignment PIN_AM25 -to hps_memory_mem_dqs[0]
set_location_assignment PIN_AT25 -to hps_memory_mem_dqs[1]
set_location_assignment PIN_AW26 -to hps_memory_mem_dqs[2]
set_location_assignment PIN_AK25 -to hps_memory_mem_dqs[3]
set_location_assignment PIN_AL25 -to hps_memory_mem_dqs_n[0]
set_location_assignment PIN_AT24 -to hps_memory_mem_dqs_n[1]
set_location_assignment PIN_AW25 -to hps_memory_mem_dqs_n[2]
set_location_assignment PIN_AJ25 -to hps_memory_mem_dqs_n[3]
if {$hps_sdram_ecc == 1} {
set_location_assignment PIN_M25 -to hps_memory_mem_dq[32]
set_location_assignment PIN_K26 -to hps_memory_mem_dq[33]
set_location_assignment PIN_N25 -to hps_memory_mem_dq[34]
set_location_assignment PIN_L26 -to hps_memory_mem_dq[35]
set_location_assignment PIN_L25 -to hps_memory_mem_dq[36]
set_location_assignment PIN_N24 -to hps_memory_mem_dq[37]
set_location_assignment PIN_M24 -to hps_memory_mem_dq[38]
set_location_assignment PIN_J25 -to hps_memory_mem_dq[39]
set_location_assignment PIN_K25 -to hps_memory_mem_dqs[4]
set_location_assignment PIN_L24 -to hps_memory_mem_dqs_n[4]
set_location_assignment PIN_P25 -to hps_memory_mem_dbi_n[4]
}

if {$boot_device == "SDMMC"} {
set_location_assignment PIN_K16 -to hps_sdio_CLK
set_location_assignment PIN_H16 -to hps_sdio_CMD
set_location_assignment PIN_E16 -to hps_sdio_D0
set_location_assignment PIN_G16 -to hps_sdio_D1
set_location_assignment PIN_H17 -to hps_sdio_D2
set_location_assignment PIN_F15 -to hps_sdio_D3
set_location_assignment PIN_M19 -to hps_sdio_D4
set_location_assignment PIN_E15 -to hps_sdio_D5
set_location_assignment PIN_J16 -to hps_sdio_D6
set_location_assignment PIN_L18 -to hps_sdio_D7
} elseif {$boot_device == "QSPI"} {
set_location_assignment PIN_H16 -to hps_qspi_IO0    
set_location_assignment PIN_G16 -to hps_qspi_IO1   
set_location_assignment PIN_H17 -to hps_qspi_IO2_WPN
set_location_assignment PIN_F15 -to hps_qspi_IO3_HOLD
set_location_assignment PIN_E16 -to hps_qspi_CLK  
set_location_assignment PIN_K16 -to hps_qspi_SS0
} elseif {$boot_device == "NAND"} {
set_location_assignment PIN_N19 -to hps_nand_ALE
set_location_assignment PIN_E15 -to hps_nand_CE_N
set_location_assignment PIN_L17 -to hps_nand_CLE
set_location_assignment PIN_G16 -to hps_nand_RE_N
set_location_assignment PIN_M19 -to hps_nand_RB
set_location_assignment PIN_E16 -to hps_nand_ADQ0
set_location_assignment PIN_H16 -to hps_nand_ADQ1
set_location_assignment PIN_H17 -to hps_nand_ADQ2
set_location_assignment PIN_F15 -to hps_nand_ADQ3
set_location_assignment PIN_J16 -to hps_nand_ADQ4
set_location_assignment PIN_L18 -to hps_nand_ADQ5
set_location_assignment PIN_M17 -to hps_nand_ADQ6
set_location_assignment PIN_K17 -to hps_nand_ADQ7
set_location_assignment PIN_K16 -to hps_nand_WE_N
} else {
# Likely boot from FPGA is selected
}
set_location_assignment PIN_D18 -to hps_usb0_CLK
set_location_assignment PIN_C19 -to hps_usb0_DIR
set_location_assignment PIN_F17 -to hps_usb0_NXT
set_location_assignment PIN_E18 -to hps_usb0_STP
set_location_assignment PIN_D19 -to hps_usb0_D0
set_location_assignment PIN_E17 -to hps_usb0_D1
set_location_assignment PIN_C17 -to hps_usb0_D2
set_location_assignment PIN_C18 -to hps_usb0_D3
set_location_assignment PIN_D21 -to hps_usb0_D4
set_location_assignment PIN_D20 -to hps_usb0_D5
set_location_assignment PIN_E21 -to hps_usb0_D6
set_location_assignment PIN_E22 -to hps_usb0_D7
set_location_assignment PIN_K18 -to hps_spim1_CLK
set_location_assignment PIN_L19 -to hps_spim1_MOSI
set_location_assignment PIN_H22 -to hps_spim1_MISO
set_location_assignment PIN_H21 -to hps_spim1_SS0_N
set_location_assignment PIN_J21 -to hps_spim1_SS1_N
if {$boot_device == "NAND"} {
set_location_assignment PIN_J18 -to hps_uart1_TX
set_location_assignment PIN_J19 -to hps_uart1_RX
} else {
set_location_assignment PIN_M17 -to hps_uart1_TX
set_location_assignment PIN_K17 -to hps_uart1_RX
}
set_location_assignment PIN_L20 -to hps_i2c1_SDA
set_location_assignment PIN_M20 -to hps_i2c1_SCL
set_location_assignment PIN_J20 -to hps_gpio_GPIO05

set_location_assignment PIN_N20 -to hps_gpio_GPIO14
set_location_assignment PIN_K23 -to hps_gpio_GPIO16
set_location_assignment PIN_L23 -to hps_gpio_GPIO17
set_location_assignment PIN_N22 -to hps_gpio_GPIO19

if {$fast_trace == 0} {
set_location_assignment PIN_P20 -to hps_trace_CLK
set_location_assignment PIN_K22 -to hps_trace_D0
set_location_assignment PIN_L22 -to hps_trace_D1
set_location_assignment PIN_M22 -to hps_trace_D2
set_location_assignment PIN_M21 -to hps_trace_D3
}
if {$boot_device == "SDMMC"} {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_CLK
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_CMD
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_D0
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_D1
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_D2
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_D3
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_D4
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_D5
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_D6
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_sdio_D7
} elseif {$boot_device == "QSPI"} {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_qspi_IO0    
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_qspi_IO1   
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_qspi_IO2_WPN
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_qspi_IO3_HOLD
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_qspi_CLK  
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_qspi_SS0
} elseif {$boot_device == "NAND"} {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_nand_ALE
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_nand_CE_N
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_nand_CLE
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_nand_RE_N
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_nand_RB
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_nand_ADQ0
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_nand_ADQ1
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_nand_ADQ2
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_nand_ADQ3
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_nand_ADQ4
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_nand_ADQ5
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_nand_ADQ6
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_nand_ADQ7
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_nand_WE_N
} else {
# Likely boot from FPGA is selected
}
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac0_TX_CLK
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac0_TX_CTL
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac0_TXD0
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac0_TXD1
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac0_TXD2
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac0_TXD3
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac0_RX_CLK
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac0_RX_CTL
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac0_RXD0
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac0_RXD1
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac0_RXD2
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac0_RXD3
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac0_MDC
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_emac0_MDIO
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_spim1_CLK
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_spim1_MOSI
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_spim1_MISO
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_spim1_SS0_N
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_spim1_SS1_N
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_uart1_TX
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_uart1_RX
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb0_CLK
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb0_DIR
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb0_NXT
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb0_STP
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb0_D0
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb0_D1
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb0_D2
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb0_D3
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb0_D4
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb0_D5
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb0_D6
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_usb0_D7
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_i2c1_SDA
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_i2c1_SCL
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_gpio_GPIO05

set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_gpio_GPIO14
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_gpio_GPIO16
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_gpio_GPIO17
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_gpio_GPIO19

if {$fast_trace == 0} {
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_trace_CLK
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_trace_D0
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_trace_D1
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_trace_D2
set_instance_assignment -name IO_STANDARD "1.8 V" -to hps_trace_D3
}
if {$boot_device == "SDMMC"} {
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to hps_sdio_CLK
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to hps_sdio_CMD
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to hps_sdio_D0
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to hps_sdio_D1
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to hps_sdio_D2
set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to hps_sdio_D3

# WEAK PULL UP needed for sdio[4..7] CASE:283997
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_sdio_D4
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_sdio_D5
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_sdio_D6
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to hps_sdio_D7

set_instance_assignment -name SLEW_RATE 1 -to hps_sdio_CLK
set_instance_assignment -name SLEW_RATE 1 -to hps_sdio_CMD
set_instance_assignment -name SLEW_RATE 1 -to hps_sdio_D0
set_instance_assignment -name SLEW_RATE 1 -to hps_sdio_D1
set_instance_assignment -name SLEW_RATE 1 -to hps_sdio_D2
set_instance_assignment -name SLEW_RATE 1 -to hps_sdio_D3
}
# Actual delay value = integer value x max offset value of device handbook / (number of setting available -1)
# 8 * 1145ps / 15 = 610ps
set_instance_assignment -name OUTPUT_DELAY_CHAIN 8 -to hps_emac0_TX_CLK
}

project_close
