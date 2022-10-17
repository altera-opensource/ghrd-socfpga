#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2020 Intel Corporation.
#
#****************************************************************************
#
# This script generates the top level RTL for the GHRD
# To use this script, 
# example command to execute this script file
#   tclsh create_ghrd_top.tcl
#
# --- The default value is defined in design_config.tcl (Default)
#
# --- alternatively, input arguments could be passed in to select other design variant. 
#     Refer arguments_solver.tcl for list of acceptable arguments
#
#****************************************************************************

#package require altera_terp
source $::env(QUARTUS_ROOTDIR)/../ip/altera/common/hw_tcl_packages/altera_terp.tcl

foreach {key val} $::argv {
  set ${key} $val
}
source ./arguments_solver.tcl

# construct parameters value used in / affect terp file
set param(top_name)                     $top_name
set param(qsys_name)                    $qsys_name
set param(daughter_card)                $daughter_card
set param(clk_gate_en)                  $clk_gate_en
set param(hps_emif_ecc_en)              $hps_emif_ecc_en
set param(hps_emif_en)                  $hps_emif_en
set param(hps_emif_rate)                $hps_emif_rate
set param(hps_emif_ref_clk_freq_mhz)    $hps_emif_ref_clk_freq_mhz
set param(hps_emif_mem_clk_freq_mhz)    $hps_emif_mem_clk_freq_mhz
set param(hps_emif_width)               $hps_emif_width
set param(hps_emif_mem_part)            $hps_emif_mem_part
set param(hps_emif_bank_gp_width)       $hps_emif_bank_gp_width
set param(hps_emif_type)                $hps_emif_type
set param(fpga_emif_ecc_en)             $fpga_emif_ecc_en
set param(fpga_emif_en)                 $fpga_emif_en
set param(fpga_emif_width)              $fpga_emif_width
set param(fpga_peripheral_en)           $fpga_peripheral_en
set param(fpga_sgpio_en)                $fpga_sgpio_en
set param(hps_en)                       $hps_en
set param(h2f_user0_clk_en)             $h2f_user0_clk_en
set param(board_rev)                    $board_rev
set param(cross_trigger_en)             $cross_trigger_en
set param(hps_stm_en)                   $hps_stm_en
set param(hps_sdmmc4b_q1_en)            $hps_sdmmc4b_q1_en
set param(hps_sdmmc8b_q1_en)            $hps_sdmmc8b_q1_en
set param(hps_sdmmc4b_q4_en)            $hps_sdmmc4b_q4_en
set param(hps_sdmmc8b_q4_en)            $hps_sdmmc8b_q4_en
set param(hps_usb0_en)                  $hps_usb0_en
set param(hps_usb1_en)                  $hps_usb1_en
set param(hps_emac0_rmii_en)            $hps_emac0_rmii_en
set param(hps_emac0_rgmii_en)           $hps_emac0_rgmii_en
set param(hps_emac1_rmii_en)            $hps_emac1_rmii_en
set param(hps_emac1_rgmii_en)           $hps_emac1_rgmii_en
set param(hps_emac2_rmii_en)            $hps_emac2_rmii_en
set param(hps_emac2_rgmii_en)           $hps_emac2_rgmii_en
set param(hps_spim0_q1_en)              $hps_spim0_q1_en
set param(hps_spim0_q4_en)              $hps_spim0_q4_en
set param(hps_spim0_q4_alt_en)          $hps_spim0_q4_alt_en
set param(hps_spim0_2ss_en)             $hps_spim0_2ss_en
set param(hps_spim1_q1_en)              $hps_spim1_q1_en
set param(hps_spim1_q2_en)              $hps_spim1_q2_en
set param(hps_spim1_q3_en)              $hps_spim1_q3_en
set param(hps_spim1_2ss_en)             $hps_spim1_2ss_en
set param(hps_spis0_q1_en)              $hps_spis0_q1_en
set param(hps_spis0_q2_en)              $hps_spis0_q2_en
set param(hps_spis0_q3_en)              $hps_spis0_q3_en
set param(hps_spis1_q1_en)              $hps_spis1_q1_en
set param(hps_spis1_q3_en)              $hps_spis1_q3_en
set param(hps_spis1_q4_en)              $hps_spis1_q4_en
set param(hps_uart0_q1_en)              $hps_uart0_q1_en
set param(hps_uart0_q2_en)              $hps_uart0_q2_en
set param(hps_uart0_q3_en)              $hps_uart0_q3_en
set param(hps_uart0_fc_en)              $hps_uart0_fc_en
set param(hps_uart1_q1_en)              $hps_uart1_q1_en
set param(hps_uart1_q3_en)              $hps_uart1_q3_en
set param(hps_uart1_q4_en)              $hps_uart1_q4_en
set param(hps_uart1_fc_en)              $hps_uart1_fc_en
set param(hps_mdio0_q1_en)              $hps_mdio0_q1_en
set param(hps_mdio0_q3_en)              $hps_mdio0_q3_en
set param(hps_mdio0_q4_en)              $hps_mdio0_q4_en
set param(hps_mdio1_q1_en)              $hps_mdio1_q1_en
set param(hps_mdio1_q4_en)              $hps_mdio1_q4_en
set param(hps_mdio2_q1_en)              $hps_mdio2_q1_en
set param(hps_mdio2_q3_en)              $hps_mdio2_q3_en
set param(hps_i2c0_q1_en)               $hps_i2c0_q1_en
set param(hps_i2c0_q2_en)               $hps_i2c0_q2_en
set param(hps_i2c0_q3_en)               $hps_i2c0_q3_en
set param(hps_i2c1_q1_en)               $hps_i2c1_q1_en
set param(hps_i2c1_q2_en)               $hps_i2c1_q2_en
set param(hps_i2c1_q3_en)               $hps_i2c1_q3_en
set param(hps_i2c1_q4_en)               $hps_i2c1_q4_en
set param(hps_i2c_emac0_q1_en)          $hps_i2c_emac0_q1_en
set param(hps_i2c_emac0_q3_en)          $hps_i2c_emac0_q3_en
set param(hps_i2c_emac0_q4_en)          $hps_i2c_emac0_q4_en
set param(hps_i2c_emac1_q1_en)          $hps_i2c_emac1_q1_en
set param(hps_i2c_emac1_q4_en)          $hps_i2c_emac1_q4_en
set param(hps_i2c_emac2_q1_en)          $hps_i2c_emac2_q1_en
set param(hps_i2c_emac2_q3_en)          $hps_i2c_emac2_q3_en
set param(hps_i2c_emac2_q4_en)          $hps_i2c_emac2_q4_en
set param(hps_nand_q12_en)              $hps_nand_q12_en
set param(hps_nand_q34_en)              $hps_nand_q34_en
set param(hps_nand_16b_en)              $hps_nand_16b_en
set param(hps_trace_q12_en)             $hps_trace_q12_en
set param(hps_trace_q34_en)             $hps_trace_q34_en
set param(hps_trace_8b_en)              $hps_trace_8b_en
set param(hps_trace_12b_en)             $hps_trace_12b_en
set param(hps_trace_16b_en)             $hps_trace_16b_en
set param(hps_trace_alt_en)             $hps_trace_alt_en
set param(hps_gpio0_en)                 $hps_gpio0_en
set param(hps_gpio0_list)               $hps_gpio0_list
set param(hps_gpio1_en)                 $hps_gpio1_en
set param(hps_gpio1_list)               $hps_gpio1_list
set param(hps_pll_out_en)               $hps_pll_out_en
set param(s2f_emac0_irq_en)             $s2f_emac0_irq_en
set param(s2f_emac1_irq_en)             $s2f_emac1_irq_en
set param(s2f_emac2_irq_en)             $s2f_emac2_irq_en
set param(s2f_gpio_irq_en)              $s2f_gpio_irq_en
set param(s2f_i2cemac0_irq_en)          $s2f_i2cemac0_irq_en
set param(s2f_i2cemac1_irq_en)          $s2f_i2cemac1_irq_en
set param(s2f_i2cemac2_irq_en)          $s2f_i2cemac2_irq_en
set param(s2f_i2c0_irq_en)              $s2f_i2c0_irq_en
set param(s2f_i2c1_irq_en)              $s2f_i2c1_irq_en
set param(s2f_nand_irq_en)              $s2f_nand_irq_en
set param(s2f_sdmmc_irq_en)             $s2f_sdmmc_irq_en
set param(s2f_spim0_irq_en)             $s2f_spim0_irq_en
set param(s2f_spim1_irq_en)             $s2f_spim1_irq_en
set param(s2f_spis0_irq_en)             $s2f_spis0_irq_en
set param(s2f_spis1_irq_en)             $s2f_spis1_irq_en
set param(s2f_uart0_irq_en)             $s2f_uart0_irq_en
set param(s2f_uart1_irq_en)             $s2f_uart1_irq_en
set param(s2f_usb0_irq_en)              $s2f_usb0_irq_en
set param(s2f_usb1_irq_en)              $s2f_usb1_irq_en
set param(hps_peri_irq_loopback_en)     $hps_peri_irq_loopback_en
set param(hps_f2s_irq_en)               $hps_f2s_irq_en
set param(gpio_loopback_en)             $gpio_loopback_en
set param(hps_etile_1588_en)            $hps_etile_1588_en
set param(hps_etile_1588_count)         $hps_etile_1588_count
set param(board)                        $board
if {[info exists fpga_led_pio_width ]} {
    set param(fpga_led_pio_width)           $fpga_led_pio_width
}
if {[info exists fpga_dipsw_pio_width ]} {
    set param(fpga_dipsw_pio_width)         $fpga_dipsw_pio_width
}
if {[info exists fpga_button_pio_width ]} {
    set param(fpga_button_pio_width)        $fpga_button_pio_width
}
set param(ftrace_en)                    $ftrace_en
set param(ftrace_output_width)          $ftrace_output_width
set param(fpga_pcie)                    $fpga_pcie
set param(pcie_gen)                     $pcie_gen
set param(pcie_count)                   $pcie_count
set param(hps_io_off)                   $hps_io_off
set param(hps_jtag_en)                  $hps_jtag_en
set param(jtag_ocm_en)                  $jtag_ocm_en
set param(pr_enable)                    $pr_enable
set param(pr_region_count)              $pr_region_count
set param(freeze_ack_dly_enable)        $freeze_ack_dly_enable
set param(hps_sgmii_emac1_en)           $hps_sgmii_emac1_en
set param(hps_sgmii_emac2_en)           $hps_sgmii_emac2_en
set param(hps_sgmii_en)                 $hps_sgmii_en
set param(hps_sgmii_emac_start_node)    $hps_sgmii_emac_start_node
set param(hps_sgmii_emac_end_node)      $hps_sgmii_emac_end_node
set param(niosv_subsys_en)              $niosv_subsys_en

##-------------------------##
# TOP RTL WRAPPER
##-------------------------##

# path to the TERP template
set template_path "top_level_template.v.terp" 
# file handle for template
set template_fh [open $template_path] 
# template contents
set template   [read $template_fh] 
# we are done with the file so we should close it
close $template_fh 
set content [altera_terp $template param]
set fo [open "./${top_name}.v" "w"] 
puts $fo $content
close $fo

##-------------------------##
# TOP SDC WRAPPER
##-------------------------##
# path to the TERP template
set template_path "top_level_sdc_template.sdc.terp" 
# file handle for template
set template_fh [open $template_path] 
# template contents
set template   [read $template_fh] 
# we are done with the file so we should close it
close $template_fh 
set content [altera_terp $template param]
set fo [open "./ghrd_timing.sdc" "w"] 
puts $fo $content
close $fo

