#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2017-2021 Intel Corporation.
#
#****************************************************************************
#
# This file resolves all passed in arguments into GHRD understood parameterizable setting

# Following are list of arguments supported and its valid values
#   project_name                : <name your quartus project>
#   qsys_name                   : <name your qsys top>
#   top_name                    : <top RTL module name of Quartus project>
#   device_family               : <FPGA device family>
#   device                      : <FPGA device part number>
#   hps_en                      : 1 or 0
#   sys_initialization          : HPS initialization sequence, HPS_FIRST or FPGA_FIRST
#   hps_dap_mode                : HPS debug split mode, 2(SDM Pins),1(HPS Pins),0(disabled)
#   board_rev                   : A1 or A0
#   c2p_early_revb_off          : 1 or 0
#   niosii_en                   : 1 or 0
#   niosii_mmu_en               : 1 or 0
#   niosii_mem                  : ocm or ddr
#   hps_emif_en                 : 1 or 0
#   hps_emif_type               : ddr3 or ddr4
#   fpga_emif_en                : 1 or 0
#   hps_emif_width              : 16, 32, 64 (irrespective of ECC)
#   hps_emif_ecc_en             : 1 or 0 
#   fpga_emif_width             : 16, 32, 64 (irrespective of ECC)
#   fpga_emif_ecc_en            : 1 or 0 
#   h2f_user_clk_en             : 1 or 0 
#   f2sdram0_width              : 3, 2, 1 or 0(as disable)
#   f2sdram1_width              : 3, 2, 1 or 0(as disable)
#   f2sdram2_width              : 3, 2, 1 or 0(as disable)
#   h2f_width                   : 128, 64, 32 or 0(as disable)
#   f2h_width                   : 128, 64, 32 or 0(as disable)
#   lwh2f_width                 : 32 or 0(as disable)
#   h2f_addr_width              : 32 or 21
#   f2h_addr_width              : 33 (10GbE-1588) or 32 or 21
#   lwh2f_addr_width            : 21
#   h2f_f2h_loopback_en         : 1 or 0 
#   lwh2f_f2h_loopback_en       : 1 or 0
#   h2f_f2sdram0_loopback_en    : 1 or 0
#   h2f_f2sdram1_loopback_en    : 1 or 0
#   h2f_f2sdram2_loopback_en    : 1 or 0
#   gpio_loopback_en            : 1 or 0
#   fpga_i2c_en                 : 1 or 0
#   hps_peri_irq_loopback_en    : 1 or 0
#   cross_trigger_en            : 1 or 0
#   hps_stm_en                  : 1 or 0
#   ftrace_en                   : 1 or 0
#   ftrace_output_width         : 16 or 32
#   hps_pll_source_export       : 1 or 0
#   watchdog_rst_en             : 1 or 0
#   watchdog_rst_act            : 0, 1 or 2
#   daughter_card               : Daughter card selection, either "devkit_dc_oobe", "devkit_dc_nand", "devkit_dc_emmc"
#   board                       : pe or devkit or atso12 or ashfield
#   fpga_peripheral_en          : 1 or 0
#   fpga_pcie                   : 1 or 0
#   pcie_gen                    : 3
#   pcie_count                  : 8
#   pcie_hptxs                  : 1 or 0
#   pcie_f2h                    : 1 or 0
#   sgmii_count                 : 1 or 2
#   hps_mge_en                  : 1 or 0
#   hps_mge_10gbe_1588_en       : 1 or 0
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

if { ![ info exists board_rev ] } {
 set board_rev $BOARD_REV
} else {
 puts "-- Accepted parameter \$board_rev = $board_rev"
}

if { ![ info exists c2p_early_revb_off ] } {
 set c2p_early_revb_off $C2P_EARLY_REVB_OFF
} else {
 puts "-- Accepted parameter \$c2p_early_revb_off = $c2p_early_revb_off"
}

if { ![ info exists hps_emif_en ] } {
 set hps_emif_en $HPS_EMIF_EN
} else {
 puts "-- Accepted parameter \$hps_emif_en = $hps_emif_en"
}

if { ![ info exists hps_emif_type ] } {
 set hps_emif_type $HPS_EMIF_TYPE
} else {
 puts "-- Accepted parameter \$hps_emif_type = $hps_emif_type"
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

if { ![ info exists h2f_user_clk_en ] } {
 set h2f_user_clk_en $H2F_USER_CLK_EN
} else {
 puts "-- Accepted parameter \$h2f_user_clk_en = $h2f_user_clk_en"
}

if { ![ info exists f2sdram0_width ] } {
 set f2sdram0_width $F2SDRAM0_WIDTH
} else {
 puts "-- Accepted parameter \$f2sdram0_width = $f2sdram0_width"
}
 
if { ![ info exists f2sdram1_width ] } {
 set f2sdram1_width $F2SDRAM1_WIDTH
} else {
 puts "-- Accepted parameter \$f2sdram1_width = $f2sdram1_width"
}

if { ![ info exists f2sdram2_width ] } {
 set f2sdram2_width $F2SDRAM2_WIDTH
} else {
 puts "-- Accepted parameter \$f2sdram2_width = $f2sdram2_width"
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

if { ![ info exists h2f_f2h_loopback_en ] } {
 set h2f_f2h_loopback_en $H2F_F2H_LOOPBACK_EN
} else {
 puts "-- Accepted parameter \$h2f_f2h_loopback_en = $h2f_f2h_loopback_en"
}

if { ![ info exists lwh2f_f2h_loopback_en ] } {
 set lwh2f_f2h_loopback_en $LWH2F_F2H_LOOPBACK_EN
} else {
 puts "-- Accepted parameter \$lwh2f_f2h_loopback_en = $lwh2f_f2h_loopback_en"
}

if { ![ info exists h2f_f2sdram0_loopback_en ] } {
 set h2f_f2sdram0_loopback_en $H2F_F2SDRAM0_LOOPBACK_EN
} else {
 puts "-- Accepted parameter \$h2f_f2sdram0_loopback_en = $h2f_f2sdram0_loopback_en"
}

if { ![ info exists h2f_f2sdram1_loopback_en ] } {
 set h2f_f2sdram1_loopback_en $H2F_F2SDRAM1_LOOPBACK_EN
} else {
 puts "-- Accepted parameter \$h2f_f2sdram1_loopback_en = $h2f_f2sdram1_loopback_en"
}

if { ![ info exists h2f_f2sdram2_loopback_en ] } {
 set h2f_f2sdram2_loopback_en $H2F_F2SDRAM2_LOOPBACK_EN
} else {
 puts "-- Accepted parameter \$h2f_f2sdram2_loopback_en = $h2f_f2sdram2_loopback_en"
}

if { ![ info exists hps_peri_irq_loopback_en ] } {
 set hps_peri_irq_loopback_en $HPS_PERI_IRQ_LOOPBACK_EN
} else {
 puts "-- Accepted parameter \$hps_peri_irq_loopback_en = $hps_peri_irq_loopback_en"
}

if { ![ info exists gpio_loopback_en ] } {
 set gpio_loopback_en $GPIO_LOOPBACK_EN
} else {
 puts "-- Accepted parameter \$gpio_loopback_en = $gpio_loopback_en"
}

if { ![ info exists fpga_i2c_en ] } {
   set fpga_i2c_en $FPGA_I2C_EN
} else {
   puts "-- Accepted parameter \$fpga_i2c_en = $fpga_i2c_en"
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

if { ![ info exists board ] } {
 set board $BOARD
} else {
 puts "-- Accepted parameter \$board = $board"
}

if { ![ info exists niosii_en ] } {
 set niosii_en $NIOSII_EN
} else {
 puts "-- Accepted parameter \$niosii_en = $niosii_en"
}

if { ![ info exists niosii_mmu_en ] } {
 set niosii_mmu_en $NIOSII_MMU_EN
} else {
 puts "-- Accepted parameter \$niosii_mmu_en = $niosii_mmu_en"
}

if { ![ info exists niosii_mem ] } {
 set niosii_mem $NIOSII_MEM
} else {
 puts "-- Accepted parameter \$niosii_mem = $niosii_mem"
}

if { ![ info exists fpga_peripheral_en ] } {
 set fpga_peripheral_en $FPGA_PERIPHERAL_EN
} else {
 puts "-- Accepted parameter \$fpga_peripheral_en = $fpga_peripheral_en"
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

if { ![ info exists fpga_pcie ] } {
 set fpga_pcie $PCIE_EN
} else {
 puts "-- Accepted parameter \$fpga_pcie = $fpga_pcie"
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

if { ![ info exists pcie_f2h ] } {
 set pcie_f2h $PCIE_F2H
} else {
 puts "-- Accepted parameter \$pcie_f2h = $pcie_f2h"
}

if { ![ info exists sgmii_count ] } {
 set sgmii_count $SGMII_COUNT
} else {
 puts "-- Accepted parameter \$sgmii_count = $sgmii_count"
}

if { ![ info exists hps_mge_en ] } {
 set hps_mge_en $HPS_MGE_EN
} else {
 puts "-- Accepted parameter \$hps_mge_en = $hps_mge_en"
}

if { ![ info exists hps_mge_10gbe_1588_en ] } {
 set hps_mge_10gbe_1588_en $HPS_MGE_10GBE_1588_EN
} else {
 puts "-- Accepted parameter \$hps_mge_10gbe_1588_en = $hps_mge_10gbe_1588_en"
}

if { ![ info exists hps_mge_10gbe_1588_count ] } {
 set hps_mge_10gbe_1588_count $HPS_MGE_10GBE_1588_COUNT
} else {
 puts "-- Accepted parameter \$hps_mge_10gbe_1588_count = $hps_mge_10gbe_1588_count"
}

if { ![ info exists hps_mge_10gbe_1588_max_count ] } {
 set hps_mge_10gbe_1588_max_count $HPS_MGE_10GBE_1588_MAX_COUNT
} else {
 puts "-- Accepted parameter \$hps_mge_10gbe_1588_max_count = $hps_mge_10gbe_1588_max_count"
}

if {$hps_en == 1} {
puts "Solver INFO: hps ENABLED"
} else {
puts "Solver INFO: NO hps"
}

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

source ./s10_hps_pinmux_solver.tcl
source ./s10_hps_parameter_solver.tcl
source ./s10_hps_io48_delay_chain_solver.tcl

## ----------------
## Parameter Auto Derivation
## ----------------

# for acp_adapter
if {$hps_mge_10gbe_1588_en == 1} {
    set acp_adapter_en 1
    set acp_adapter_csr_en 1
    set acp_adapter_gpio_en 0
} elseif {$fpga_pcie == 1 && $pcie_f2h == 1} {
    set acp_adapter_en 1
    set acp_adapter_csr_en 1
    set acp_adapter_gpio_en 0
} else {
    set acp_adapter_en 0
}

#Parameter Overriding
if { $fpga_i2c_en == 1 && $hps_mge_10gbe_1588_en == 1 } {
  error "Error GHRD argument solver" "FPGA_I2C_EN and HPS_MGE_10GBE_1588_EN cannot be enable at the same time"
}

if { $hps_mge_10gbe_1588_en == 1 || $fpga_pcie == 1} {
   puts "Overriding f2h_addr_width to 33"
   set f2h_addr_width 33
}

#Checking for HPS MGE SGMII Mode
if {$hps_mge_en == 1} {
   set hps_mge_mac {}
   if {$hps_emac0_rmii_en == 0 && $hps_emac0_rgmii_en == 0} {
      lappend hps_mge_mac 0
   }
   if {$hps_emac1_rmii_en == 0 && $hps_emac1_rgmii_en == 0} {
      lappend hps_mge_mac 1
   }
   if {$hps_emac2_rmii_en == 0 && $hps_emac2_rgmii_en == 0} {
      lappend hps_mge_mac 2
   }

   puts "debug print: hps_mge_mac = $hps_mge_mac."

   set hps_mge_mac_listlength [llength $hps_mge_mac]

   if {$hps_mge_mac_listlength < 1} {
      error "Error GHRD argument solver" "All HPS EMAC occupied for HPS IOs. Nothing left for HPS SGMII mode"
   }

   if {$sgmii_count > $hps_mge_mac_listlength && $hps_mge_mac_listlength >0 } {
      error "Error GHRD argument solver" "Requested SGMII count is more than unused HPS EMAC. Please reduce the SGMII Count"
   }
}

# Was thinking to enable single TCL entry for flow of TOP RTL, qsys, quartus generation. Ideal still pending implementation
# exec quartus_sh --script=create_ghrd_quartus.tcl $top_quartus_arg
# exec qsys-script --script=create_ghrd_qsys.tcl --quartus-project=$project_name.qpf --cmd="$qsys_arg"
