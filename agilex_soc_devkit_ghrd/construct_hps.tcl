#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2021 Intel Corporation.
#
#****************************************************************************
#
# This tcl will be invoke by create_ghrd_qsys.tcl 
# This tcl script basically contained only configuration settings for HPS & HPS EMIF, connections between HPS & HPS EMIF
#
#****************************************************************************

#add_component_param "intel_falconmesa_hps agilex_hps
add_component_param "intel_agilex_hps agilex_hps
                     IP_FILE_PATH ip/$qsys_name/agilex_hps.ip 
                     MPU_EVENTS_Enable 0
                     STM_Enable $hps_stm_en
                     HPS_IO_Enable {$io48_q1_assignment $io48_q2_assignment $io48_q3_assignment $io48_q4_assignment}
                     F2S_Width $f2s_width
                     S2F_Width $s2f_width
                     LWH2F_Enable $lwh2f_width
                     EMIF_CONDUIT_Enable $hps_emif_en
                     EMIF_DDR_WIDTH $hps_emif_width
                     F2S_ADDRESS_WIDTH $f2h_addr_width
                     S2F_ADDRESS_WIDTH $h2f_addr_width
                     LWH2F_ADDRESS_WIDTH $lwh2f_addr_width
                     CLK_GPIO_SOURCE 1
                     CLK_EMACA_SOURCE 1
                     CLK_EMACB_SOURCE 1
                     CLK_EMAC_PTP_SOURCE 1
                     CLK_PSI_SOURCE 1
                     watchdog_reset $watchdog_rst_en
                     W_RESET_ACTION $watchdog_rst_act
"
#                     EMIF_DDR_WIDTH $hps_emif_width

                     
#  missing in HPS parameters
#              F2S_ready_latency 0
#              S2F_ready_latency 0
#              LWH2F_ready_latency 0
            
load_component agilex_hps
for {set i 0} {$i < 48} {incr i} {
set_component_parameter_value IO_INPUT_DELAY${i} $input_dly_chain_io48(${i})
set_component_parameter_value IO_OUTPUT_DELAY${i} $output_dly_chain_io48(${i})
}
save_component

#MPU_CLK_VCCL 1

if {$h2f_user0_clk_en == 1} {
set_component_param "agilex_hps   
                     H2F_USER0_CLK_Enable 1
                     H2F_USER0_CLK_FREQ 100
"
}

if {$h2f_user1_clk_en == 1} {
set_component_param "agilex_hps   
                     H2F_USER1_CLK_Enable 1
                     H2F_USER1_CLK_FREQ $h2f_user1_freq
"
}

if {$hps_pll_source_export == 1} {
set_component_param "agilex_hps
                     CLK_MAIN_PLL_SOURCE2 2
                     CLK_PERI_PLL_SOURCE2 2
                     F2H_FREE_CLK_Enable 1
                     F2H_FREE_CLK_FREQ 100"
}

if {$hps_nand_q12_en == 1 || $hps_nand_q34_en == 1} {
set_component_param "agilex_hps
                     NAND_PinMuxing IO
                     NAND_Mode 8-bit
"
}

if {$hps_nand_16b_en == 1} {
set_component_param "agilex_hps   NAND_Mode 16-bit"
}

if {$hps_emac0_rmii_en == 1 || $hps_emac0_rgmii_en == 1} {
set_component_param "agilex_hps   EMAC0_PinMuxing IO"
}

# TODO: pending relating mdio 0, 1, 2 to any emac. Now it is a enhancement case for HPS megawizard
if {$hps_emac0_rmii_en == 1 } {
set_component_param "agilex_hps EMAC0_CLK 50"
   if {$hps_mdio0_q1_en == 1 || $hps_mdio0_q3_en == 1 || $hps_mdio0_q4_en == 1} {
      set_component_param "agilex_hps  EMAC0_Mode RMII_with_MDIO"
   } else {
      set_component_param "agilex_hps  EMAC0_Mode RMII"
   }
} elseif {$hps_emac0_rgmii_en == 1} {
   if {$hps_mdio0_q1_en == 1 || $hps_mdio0_q3_en == 1 || $hps_mdio0_q4_en == 1} {
      set_component_param "agilex_hps  EMAC0_Mode RGMII_with_MDIO"
   } else {
      set_component_param "agilex_hps  EMAC0_Mode RGMII"
   }
}

if {$hps_emac1_rmii_en == 1 || $hps_emac1_rgmii_en == 1} {
   set_component_param "agilex_hps   EMAC1_PinMuxing IO"
}
if {$hps_emac1_rmii_en == 1 } {
   set_component_param "agilex_hps EMAC1_CLK 50"
   if {$hps_mdio1_q1_en == 1 || $hps_mdio1_q4_en == 1} {
      set_component_param "agilex_hps  EMAC1_Mode RMII_with_MDIO"
   } else {
      set_component_param "agilex_hps  EMAC1_Mode RMII"
   }
} elseif {$hps_emac1_rgmii_en == 1} {
   if {$hps_mdio1_q1_en == 1 || $hps_mdio1_q4_en == 1} {
      set_component_param "agilex_hps  EMAC1_Mode RGMII_with_MDIO"
   } else {
      set_component_param "agilex_hps  EMAC1_Mode RGMII"
   }
}

if {$hps_emac2_rmii_en == 1 || $hps_emac2_rgmii_en == 1} {
   set_component_param "agilex_hps   EMAC2_PinMuxing IO"
}
if {$hps_emac2_rmii_en == 1 } {
   set_component_param "agilex_hps EMAC2_CLK 50"
   if {$hps_mdio2_q1_en == 1 || $hps_mdio2_q3_en == 1} {
      set_component_param "agilex_hps  EMAC2_Mode RMII_with_MDIO"
   } else {
      set_component_param "agilex_hps  EMAC2_Mode RMII"
   }
} elseif {$hps_emac2_rgmii_en == 1} {
  if {$hps_mdio2_q1_en == 1 || $hps_mdio2_q3_en == 1} {
      set_component_param "agilex_hps  EMAC2_Mode RGMII_with_MDIO"
   } else {
      set_component_param "agilex_hps  EMAC2_Mode RGMII"
   }
}

if {$hps_sdmmc4b_q1_en == 1 || $hps_sdmmc8b_q1_en == 1 || $hps_sdmmc4b_q4_en == 1 || $hps_sdmmc8b_q4_en == 1} {
   set_component_param "agilex_hps   
                        CLK_SDMMC_SOURCE 1   
                        SDMMC_PinMuxing IO"
}

#TODO: 1-bit mode to be added
if {$hps_sdmmc4b_q1_en == 1 || $hps_sdmmc4b_q4_en == 1} {
   set_component_param "agilex_hps   SDMMC_Mode 4-bit"
} elseif {$hps_sdmmc8b_q1_en == 1 || $hps_sdmmc8b_q4_en == 1} {
   set_component_param "agilex_hps   SDMMC_Mode 8-bit"
}

if {$hps_usb0_en == 1} {
   set_component_param "agilex_hps   
                        USB0_PinMuxing IO
                        USB0_Mode default
                        "
}
if {$hps_usb1_en == 1} {
   set_component_param "agilex_hps   
                        USB1_PinMuxing IO
                        USB1_Mode default
                        "
}
 
if {$hps_spim0_q1_en == 1 || $hps_spim0_q4_en == 1} {
   set_component_param "agilex_hps   
                        SPIM0_PinMuxing IO
                        SPIM0_Mode Single_slave_selects
                        "
}

if {$hps_spim0_2ss_en == 1} {
   set_component_param "agilex_hps SPIM0_Mode Dual_slave_selects"
}

if {$hps_spim1_q1_en == 1 || $hps_spim1_q2_en == 1 || $hps_spim1_q3_en == 1} {
   set_component_param "agilex_hps   
                        SPIM1_PinMuxing IO
                        SPIM1_Mode Single_slave_selects
                        "
}

if {$hps_spim1_2ss_en == 1} {
   set_component_param "agilex_hps SPIM1_Mode Dual_slave_selects"
}

if {$hps_spis0_q1_en == 1 || $hps_spis0_q2_en == 1 || $hps_spis0_q3_en == 1} {
   set_component_param "agilex_hps   
                        SPIS0_PinMuxing IO
                        SPIS0_Mode default
                        "
}

if {$hps_spis1_q1_en == 1 || $hps_spis1_q3_en == 1 || $hps_spis1_q4_en == 1} {
   set_component_param "agilex_hps   
                        SPIS1_PinMuxing IO
                        SPIS1_Mode default
                        "
}
 
if {$hps_uart0_q1_en == 1 || $hps_uart0_q2_en == 1 || $hps_uart0_q3_en == 1} {
   set_component_param "agilex_hps   
                        UART0_PinMuxing IO
                        UART0_Mode No_flow_control
                        "
}

if {$hps_uart0_fc_en == 1} {
   set_component_param "agilex_hps   UART0_Mode Flow_control"
}

if {$hps_uart1_q1_en == 1 || $hps_uart1_q3_en == 1 || $hps_uart1_q4_en == 1} {
   set_component_param "agilex_hps   
                        UART1_PinMuxing IO
                        UART1_Mode No_flow_control
                        "
}

if {$hps_uart1_fc_en == 1} {
   set_component_param "agilex_hps   UART1_Mode Flow_control"
}

if {$hps_i2c0_q1_en == 1 || $hps_i2c0_q2_en == 1 || $hps_i2c0_q3_en == 1} {
   set_component_param "agilex_hps   
                        I2C0_PinMuxing IO
                        I2C0_Mode default
                        "
}

if {$hps_i2c1_q1_en == 1 || $hps_i2c1_q2_en == 1 || $hps_i2c1_q3_en == 1 || $hps_i2c1_q4_en == 1} {
   set_component_param "agilex_hps   
                        I2C1_PinMuxing IO
                        I2C1_Mode default
                        "
}

if {$hps_i2c_emac0_q1_en == 1 || $hps_i2c_emac0_q3_en == 1 || $hps_i2c_emac0_q4_en == 1} {
   set_component_param "agilex_hps   
                        I2CEMAC0_PinMuxing IO
                        I2CEMAC0_Mode default
                        "
}

if {$hps_i2c_emac1_q1_en == 1 || $hps_i2c_emac1_q4_en == 1} {
   set_component_param "agilex_hps   
                        I2CEMAC1_PinMuxing IO
                        I2CEMAC1_Mode default
                        "
}

if {$hps_i2c_emac2_q1_en == 1 || $hps_i2c_emac2_q3_en == 1 || $hps_i2c_emac2_q4_en == 1} {
   set_component_param "agilex_hps   
                        I2CEMAC2_PinMuxing IO
                        I2CEMAC2_Mode default
                        "
}

if {$hps_sgmii_emac1_en == 1} {
set_component_param "agilex_hps
                     EMAC1_PinMuxing FPGA
                     EMAC1_Mode RGMII_with_MDIO 
                     FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_EMAC1_GTX_CLK 125
                     "
}

if {$hps_sgmii_emac2_en == 1} {
set_component_param "agilex_hps
                     EMAC2_PinMuxing FPGA
                     EMAC2_Mode RGMII_with_MDIO 
                     FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_EMAC2_GTX_CLK 125
                     "
}

if {$gpio_loopback_en == 1 || $fpga_pcie == 1} {
   set_component_param "agilex_hps   
                        GP_Enable 1
                        "
}

if {$cct_en == 1} {
   set_component_param "agilex_hps 
                        F2S_mode 1
                        F2S_Route_config 2
                        "
} 

if {$hps_etile_1588_en == 1} {
if {$hps_i2c0_q1_en == 0 && $hps_i2c0_q2_en == 0 && $hps_i2c0_q3_en == 0} {
   set_component_param "agilex_hps
                       I2C0_PinMuxing FPGA
                       I2C0_Mode default
                       "
   set etile_25gbe_i2c 0
   puts "Etile 25GbE I2C0 enable"
} elseif {$hps_i2c1_q1_en == 0 && $hps_i2c1_q2_en == 0 && $hps_i2c1_q3_en == 0 && $hps_i2c1_q4_en == 0} {
   set_component_param "agilex_hps
                       I2C1_PinMuxing FPGA
                       I2C1_Mode default
                       "
   set etile_25gbe_i2c 1
   puts "Etile 25GbE I2C1 enable"
} else {
   error "Error: Conflict HPS i2c settings. None of I2C available"
}

}

 # CM_PinMuxing
 # CM_Mode
 # PLL_CLK0
 # PLL_CLK1
 # PLL_CLK2
 # PLL_CLK3
 # PLL_CLK4
if {$hps_peri_irq_loopback_en == 0} {
   set_component_param "agilex_hps   
                        F2SINTERRUPT_Enable $hps_f2s_irq_en
"
} else {
   set_component_param "agilex_hps   
                        F2SINTERRUPT_Enable 1
                        S2FINTERRUPT_CLOCKPERIPHERAL_Enable 1
                        S2FINTERRUPT_WATCHDOG_Enable 1
                        S2FINTERRUPT_L4TIMER_Enable 1
                        S2FINTERRUPT_SYSTIMER_Enable 1
                        S2FINTERRUPT_SYSTEMMANAGER_Enable 1
                        S2FINTERRUPT_DMA_Enable 1
                        S2FINTERRUPT_EMAC0_Enable $s2f_emac0_irq_en
                        S2FINTERRUPT_EMAC1_Enable $s2f_emac1_irq_en
                        S2FINTERRUPT_EMAC2_Enable $s2f_emac2_irq_en
                        S2FINTERRUPT_GPIO_Enable $s2f_gpio_irq_en
                        S2FINTERRUPT_I2CEMAC0_Enable $s2f_i2cemac0_irq_en
                        S2FINTERRUPT_I2CEMAC1_Enable $s2f_i2cemac1_irq_en
                        S2FINTERRUPT_I2CEMAC2_Enable $s2f_i2cemac2_irq_en
                        S2FINTERRUPT_I2C0_Enable $s2f_i2c0_irq_en
                        S2FINTERRUPT_I2C1_Enable $s2f_i2c1_irq_en
                        S2FINTERRUPT_NAND_Enable $s2f_nand_irq_en
                        S2FINTERRUPT_SDMMC_Enable $s2f_sdmmc_irq_en
                        S2FINTERRUPT_SPIM0_Enable $s2f_spim0_irq_en
                        S2FINTERRUPT_SPIM1_Enable $s2f_spim1_irq_en
                        S2FINTERRUPT_SPIS0_Enable $s2f_spis0_irq_en
                        S2FINTERRUPT_SPIS1_Enable $s2f_spis1_irq_en
                        S2FINTERRUPT_UART0_Enable $s2f_uart0_irq_en
                        S2FINTERRUPT_UART1_Enable $s2f_uart1_irq_en
                        S2FINTERRUPT_USB0_Enable $s2f_usb0_irq_en
                        S2FINTERRUPT_USB1_Enable $s2f_usb1_irq_en
                        "
} 

# Support only in Agilex Char Board
if {$ftrace_en == 1} {
   set_component_param "agilex_hps TRACE_PinMuxing FPGA"
   
   add_component_param "altera_trace_wrapper ext_trace
                        IP_FILE_PATH ip/$qsys_name/ext_trace.ip 
                        NUM_PIPELINE_REG 1"

   #HPS Trace: 4,8,12 yield 64bits output trace from hps
   #FPGA Trace: 16-bit yield only 32bits output trace; 32-bit yield 64bits output trace
   set ftrace_mode "${ftrace_output_width}-bit"
   set_component_param "agilex_hps   TRACE_Mode $ftrace_mode"
                  
   set_component_param "ext_trace IN_DWIDTH $ftrace_output_width"
} 

if {$hps_trace_q12_en == 1 || $hps_trace_q34_en == 1 || $hps_trace_8b_en == 1 || $hps_trace_12b_en == 1 || $hps_trace_16b_en == 1} {
   set_component_param "agilex_hps TRACE_PinMuxing IO"
}

if {$hps_trace_q12_en == 1 || $hps_trace_q34_en == 1} {
   set_component_param "agilex_hps TRACE_Mode 4-bit"
}

if {$hps_trace_8b_en == 1} {
   set_component_param "agilex_hps   TRACE_Mode 8-bit"
} elseif {$hps_trace_12b_en == 1} {
   set_component_param "agilex_hps   TRACE_Mode 12-bit"
} elseif {$hps_trace_16b_en == 1} {
   set_component_param "agilex_hps   TRACE_Mode 16-bit"
}

if {$hps_emif_en == 1} {
   set cpu_instance agilex_hps
   source ./construct_agilex_emif.tcl
}

# if {$fpga_pcie == 1} {
# set_component_param "agilex_hps S2F_ready_latency 1"
# #ACE-lite
# set_component_param "agilex_hps   F2S_mode 1"
# set_component_param "agilex_hps   F2S_ready_latency 1"
# }

# --------------- Connections and connection parameters ------------------#

if {$f2h_width > 0} {
   if {$hps_etile_1588_en == 1} {
      connect "etile_25gbe_1588.dma_clkout agilex_hps.f2h_axi_clock"
      connect "etile_25gbe_1588.dma_clkout_reset agilex_hps.f2h_axi_reset"
   } elseif {$fpga_pcie == 1} {
      connect "pcie_0.pcie_p0_app_clk agilex_hps.f2h_axi_clock"
   } elseif {$f2h_clk_source == 1} {
      if {$h2f_user1_clk_en == 0} {
         error "Error: H2F_USER1_CLK_EN is not enabled. F2H CLK source error. "
      }
      connect "agilex_hps.h2f_user1_clock agilex_hps.f2h_axi_clock"
   } else {
      connect "clk_100.out_clk agilex_hps.f2h_axi_clock"
   }

   connect "rst_in.out_reset agilex_hps.f2h_axi_reset"
}

if {$h2f_width > 0} {
   if {$fpga_pcie == 1} {
      connect "pcie_0.pcie_p0_app_clk agilex_hps.h2f_axi_clock"
   } elseif {$h2f_clk_source ==1} {
      if {$h2f_user1_clk_en == 0} {
         error "Error: H2F_USER1_CLK_EN is not enabled. H2F CLK source error. "
      }
      connect "agilex_hps.h2f_user1_clock agilex_hps.h2f_axi_clock"
   } else {
      connect "clk_100.out_clk agilex_hps.h2f_axi_clock"
   }

   connect "rst_in.out_reset agilex_hps.h2f_axi_reset"
}

if {$lwh2f_width > 0} {
   if {$lwh2f_clk_source ==1} {
      if {$h2f_user1_clk_en == 0} {
         error "Error: H2F_USER1_CLK_EN is not enabled. LWH2F CLK source error. "
      }
      connect "agilex_hps.h2f_user1_clock agilex_hps.h2f_lw_axi_clock"
   } else {
      connect "clk_100.out_clk agilex_hps.h2f_lw_axi_clock"
   }

   connect "rst_in.out_reset agilex_hps.h2f_lw_axi_reset"
}

if {$jtag_ocm_en == 1} {
   if {$ocm_clk_source == 0} {
   connect "   clk_100.out_clk   ocm.clk1"
   } else {
   connect "   agilex_hps.h2f_user1_clock   ocm.clk1"
   }
}

if {$h2f_width > 0} {
   if {$hps_etile_1588_en == 1} {
      connect_map "agilex_hps.h2f_axi_master    etile_25gbe_1588.csr   0x02000000"
   }

   if {$fpga_pcie == 1} {
      if {$pcie_hptxs == 1} {
         connect_map "agilex_hps.h2f_axi_master    pcie_0.pb_hptxs   0x10000000"
         connect_map "jtg_mst.fpga_m_master        pcie_0.pb_hptxs   0x10000000"
      } else {
         connect_map "agilex_hps.h2f_axi_master    pcie_0.pb_txs     0x10000000"
         connect_map "jtg_mst.fpga_m_master        pcie_0.pb_txs     0x10000000"
      }
      
      connect_map "agilex_hps.h2f_axi_master    pcie_0.pb_hip_reconfig  0x20000000"
      connect_map "jtg_mst.fpga_m_master        pcie_0.pb_hip_reconfig  0x20000000"
   } 
   
   if {$h2f_f2h_loopback_en == 1} {
      if {$cct_en == 0} {
         connect_map "agilex_hps.h2f_axi_master  agilex_hps.f2h_axi_slave 0x0"
      } else {
         connect_map "agilex_hps.h2f_axi_master  intel_cache_coherency_translator_0.s0  0x0"
      }
   } elseif {$h2f_width > 0 && $jtag_ocm_en == 1} {
      connect_map "agilex_hps.h2f_axi_master ocm.s1 0x0"
   }
}

if {$lwh2f_width > 0} {
   if {$cct_en == 1} {
      if {$cct_control_interface == 2} {
         connect_map "agilex_hps.h2f_lw_axi_master     intel_cache_coherency_translator_0.csr   0x210"
         connect_map "jtg_mst.fpga_m_master            intel_cache_coherency_translator_0.csr   0x210"
      }
   }

   if {$fpga_pcie == 1} {
      connect_map "agilex_hps.h2f_lw_axi_master     pcie_0.pb_lwh2f_pcie       0x00040000"
      connect_map "jtg_mst.fpga_m_master            pcie_0.pb_lwh2f_pcie       0x00040000"
   } 
   
   if {$pr_enable == 1} {
      for {set k 0} {$k<$pr_region_count} {incr k} {
         set frz_ctrl_offset [format 0x%x [expr [expr 0x10*$k]+0x450]] 
         set frz_bdg_offset [format 0x%x [expr [expr 0x400*$k]+0x800]] 
         connect_map "agilex_hps.h2f_lw_axi_master     frz_ctrl_${k}.avl_csr            $frz_ctrl_offset
                      agilex_hps.h2f_lw_axi_master     frz_bdg_${k}.slv_bridge_to_sr    $frz_bdg_offset
                     "
      }
      if {$freeze_ack_dly_enable == 1} {
         connect_map "agilex_hps.h2f_lw_axi_master     start_ack_pio.s1     0x1800
                      agilex_hps.h2f_lw_axi_master     stop_ack_pio.s1      0x1810
                     "
      }
   }
   
   if {$hps_sgmii_en == 1} {
      if {$hps_sgmii_emac1_en == 1} {
         connect_map "   agilex_hps.h2f_lw_axi_master   subsys_sgmii_emac1.csr 0x3000"
      }
      if {$hps_sgmii_emac2_en == 1} {
         connect_map "   agilex_hps.h2f_lw_axi_master   subsys_sgmii_emac1.csr 0x4000"
      }
   }
   
   if {$lwh2f_f2h_loopback_en && $lwh2f_addr_width >= $f2h_addr_width} {
      connect_map "agilex_hps.h2f_lw_axi_master agilex_hps.f2h_axi_slave 0x0"
   } 
   
   if {$jtag_ocm_en == 1} {
      connect_map "agilex_hps.h2f_lw_axi_master sysid.control_slave 0x0"
   }
   
   if {$fpga_peripheral_en == 1 || $fpga_sgpio_en == 1} {
      connect_map "agilex_hps.h2f_lw_axi_master periph.pb_cpu_0_s0 0x1000"
   }
   
   if {$jop_en == 1} {
      connect_map "agilex_hps.h2f_lw_axi_master jop.avmm_s 0x8000"
   }
}

if {$jtag_ocm_en == 1} {
   if { $cct_en == 0} {
      connect_map "jtg_mst.hps_m_master agilex_hps.f2h_axi_slave 0x0"

      if {$secure_f2h_axi_slave == 1} {
         #set_interconnect_requirement {agilex_hps.f2h_axi_slave} qsys_mm.security {SECURE}
         #set_interconnect_requirement {jtg_mst.hps_m_master} qsys_mm.security {SECURE}
         set_interface_assignment {agilex_hps.f2h_axi_slave} {qsys_mm.security} {SECURE}
         set_interface_assignment {jtg_mst.hps_m_master} {qsys_mm.security} {SECURE}
      }
   }
}

if {$hps_f2s_irq_en == 1} {
   if {$hps_peri_irq_loopback_en == 1} {
      # peripherals that do not have external ports will have their irq exported for loopback connection
   connect "agilex_hps.f2h_irq0 agilex_hps.h2f_dma_abort_interrupt
         agilex_hps.f2h_irq0 agilex_hps.h2f_dma_interrupt0
         agilex_hps.f2h_irq0 agilex_hps.h2f_dma_interrupt1
         agilex_hps.f2h_irq0 agilex_hps.h2f_dma_interrupt2
         agilex_hps.f2h_irq0 agilex_hps.h2f_dma_interrupt3
         agilex_hps.f2h_irq0 agilex_hps.h2f_dma_interrupt4
         agilex_hps.f2h_irq0 agilex_hps.h2f_dma_interrupt5
         agilex_hps.f2h_irq0 agilex_hps.h2f_dma_interrupt6
         agilex_hps.f2h_irq0 agilex_hps.h2f_dma_interrupt7
         agilex_hps.f2h_irq0 agilex_hps.h2f_wdog0_interrupt
         agilex_hps.f2h_irq0 agilex_hps.h2f_wdog1_interrupt
         agilex_hps.f2h_irq0 agilex_hps.h2f_wdog2_interrupt
         agilex_hps.f2h_irq0 agilex_hps.h2f_wdog3_interrupt
         agilex_hps.f2h_irq0 agilex_hps.h2f_timer_l4sp_0_interrupt
         agilex_hps.f2h_irq0 agilex_hps.h2f_timer_l4sp_1_interrupt
         agilex_hps.f2h_irq0 agilex_hps.h2f_timer_sys_0_interrupt
         agilex_hps.f2h_irq0 agilex_hps.h2f_timer_sys_1_interrupt
         agilex_hps.f2h_irq0 agilex_hps.h2f_clkmgr_interrupt
         agilex_hps.f2h_irq0 agilex_hps.h2f_ecc_derr_interrupt
         agilex_hps.f2h_irq0 agilex_hps.h2f_ecc_serr_interrupt"
      if {$s2f_emac0_irq_en == 1} {
         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_emac0_interrupt"
      }
      if {$s2f_emac1_irq_en == 1} {
         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_emac1_interrupt"
      }
      if {$s2f_emac2_irq_en == 1} {
         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_emac2_interrupt"
      }
      if {$s2f_gpio_irq_en == 1} {
         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_gpio0_interrupt
               agilex_hps.f2h_irq0 agilex_hps.h2f_gpio1_interrupt"
      }
      if {$s2f_i2c0_irq_en == 1} {
         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_i2c0_interrupt"
      }
      if {$s2f_i2c1_irq_en == 1} {
         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_i2c1_interrupt"
      }
      if {$s2f_i2cemac0_irq_en == 1} {
         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_i2c_emac0_interrupt"
      }
      if {$s2f_i2cemac1_irq_en == 1} {
         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_i2c_emac1_interrupt"
      }
      if {$s2f_i2cemac2_irq_en == 1} {
         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_i2c_emac2_interrupt"
      }
      if {$s2f_uart0_irq_en == 1} {
         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_uart0_interrupt"
      }
      if {$s2f_uart1_irq_en == 1} {
         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_uart1_interrupt"
      }
      if {$s2f_nand_irq_en == 1} {
         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_nand_interrupt"
      }
      if {$s2f_sdmmc_irq_en == 1} {
         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_sdmmc_interrupt"
      }
      if {$s2f_spim0_irq_en == 1} {
         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_spim0_interrupt"
      }
      if {$s2f_spim1_irq_en == 1} {
         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_spim1_interrupt"
      }
      if {$s2f_spis0_irq_en == 1} {
         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_spis0_interrupt"
      }
      if {$s2f_spis1_irq_en == 1} {
         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_spis1_interrupt"
      }
      if {$s2f_usb0_irq_en == 1} {
         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_usb0_interrupt"
      }
      if {$s2f_usb1_irq_en == 1} {
         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_usb1_interrupt"
      }
   } else {
      if {$fpga_peripheral_en == 1} {
         if {$fpga_button_pio_width >0} {
            connect "agilex_hps.f2h_irq0      periph.button_pio_irq"
            set_connection_parameter_value agilex_hps.f2h_irq0/periph.button_pio_irq irqNumber {1}
            connect "periph.ILC_irq       periph.button_pio_irq"
            set_connection_parameter_value periph.ILC_irq/periph.button_pio_irq irqNumber {1}
         }
         if {$fpga_dipsw_pio_width >0} {
            connect "agilex_hps.f2h_irq0      periph.dipsw_pio_irq"
            set_connection_parameter_value agilex_hps.f2h_irq0/periph.dipsw_pio_irq irqNumber {0}
            connect "periph.ILC_irq       periph.dipsw_pio_irq"
            set_connection_parameter_value periph.ILC_irq/periph.dipsw_pio_irq irqNumber {0}
         }
      }
      
      if {$fpga_pcie == 1} {
         for {set x 0} {$x < 4} {incr x} {
            connect "agilex_hps.f2h_irq0   pcie_0.msi2gic_${x}_interrupt
                     agilex_hps.f2h_irq0   pcie_0.pcie_hip_p${x}_cra_irq
                     "
            set irq_no [expr {$x*2 + 2}]
            set_connection_parameter_value agilex_hps.f2h_irq0/pcie_0.msi2gic_${x}_interrupt irqNumber $irq_no
            incr irq_no 1
            set_connection_parameter_value agilex_hps.f2h_irq0/pcie_0.pcie_hip_p${x}_cra_irq irqNumber $irq_no
         } 
      }
      
      if {$pr_enable} {
         for {set k 0} {$k<$pr_region_count} {incr k} {      
            set frz_ctrl_int [expr 2+$k]
            connect "periph.ILC_irq      frz_ctrl_${k}.interrupt_sender
                     agilex_hps.f2h_irq0     frz_ctrl_${k}.interrupt_sender
                     "
            set_connection_parameter_value periph.ILC_irq/frz_ctrl_${k}.interrupt_sender irqNumber $frz_ctrl_int
            set_connection_parameter_value agilex_hps.f2h_irq0/frz_ctrl_${k}.interrupt_sender irqNumber $frz_ctrl_int
         }
      }

      if {$hps_etile_1588_en  == 1} {
         connect "agilex_hps.f2h_irq0   etile_25gbe_1588.qsfpdd_status_pio_irq
                  agilex_hps.f2h_irq0   etile_25gbe_1588.debug_status_pio_irq
                  "
         set_connection_parameter_value agilex_hps.f2h_irq0/etile_25gbe_1588.qsfpdd_status_pio_irq irqNumber 5
         set_connection_parameter_value agilex_hps.f2h_irq0/etile_25gbe_1588.debug_status_pio_irq irqNumber 6

         for {set x 1} {$x<=$hps_etile_1588_count} {incr x} {
             connect "agilex_hps.f2h_irq0   etile_25gbe_1588.tx_dma_ch${x}_irq
                      agilex_hps.f2h_irq0   etile_25gbe_1588.rx_dma_ch${x}_irq
                      "
             set irq_no [expr {$x + 6}]
             set_connection_parameter_value agilex_hps.f2h_irq0/etile_25gbe_1588.tx_dma_ch${x}_irq irqNumber $irq_no
             incr irq_no 1
             set_connection_parameter_value agilex_hps.f2h_irq0/etile_25gbe_1588.rx_dma_ch${x}_irq irqNumber $irq_no
         }
      }
   }
}

if {$ftrace_en == 1} {
connect "rst_in.out_reset     ext_trace.reset_sink
         agilex_hps.trace_s2f_clk ext_trace.clock_sink
         agilex_hps.trace         ext_trace.h2f_tpiu"
}

if {$hps_pll_source_export == 1} {
connect "clk_100.out_clk agilex_hps.f2h_free_clock"
}

if {$cct_en == 1} {
# # temporary commented cause it lock the bridges.
# connect "pcie_nreset_status_merge.out_reset agilex_hps.h2f_axi_reset
#          pcie_nreset_status_merge.out_reset agilex_hps.h2f_lw_axi_reset"

   if {$f2h_width > 0} {
#      connect  "pcie_nreset_status_merge.out_reset agilex_hps.f2h_axi_reset"
      connect_map "intel_cache_coherency_translator_0.m0   agilex_hps.f2h_axi_slave    0x0000"
   }
}

# --------------------    Exported Interfaces     -----------------------#
export agilex_hps h2f_reset h2f_reset
if {$hps_io_off == 0} {
export agilex_hps hps_io hps_io
}

if {$hps_stm_en == 1} {
export agilex_hps f2h_stm_hw_events agilex_hps_f2h_stm_hw_events
export agilex_hps h2f_cs agilex_hps_h2f_cs
}

if {$watchdog_rst_en == 1} {
export agilex_hps h2f_watchdog_rst wd_reset
}

if {$hps_f2s_irq_en == 1 || $hps_peri_irq_loopback_en == 1} {
export agilex_hps f2h_irq1 f2h_irq1
}

if {$h2f_user0_clk_en == 1} {
export agilex_hps h2f_user0_clock h2f_user_clk
}

if {$gpio_loopback_en == 1 || $fpga_pcie == 1} {
export agilex_hps h2f_gp agilex_hps_h2f_gp
} 

if {$ftrace_en == 1} {
export ext_trace f2h_clk_in ext_trace_f2h_clk_in
export ext_trace trace_clk_out ext_trace_trace_clk_out
export ext_trace trace_data_out ext_trace_trace_data_out
}

if {$hps_etile_1588_en == 1} {
export agilex_hps i2c${etile_25gbe_i2c}_scl_in   qsfpdd_i2c_scl_in
export agilex_hps i2c${etile_25gbe_i2c}_clk      qsfpdd_i2c_clk
export agilex_hps i2c${etile_25gbe_i2c}          qsfpdd_i2c
}

##----------------
## USB timing
##---------------
set_component_param     "agilex_hps
                         IO_INPUT_DELAY1 {126}
                         IO_INPUT_DELAY2 {126}
                         IO_INPUT_DELAY3 {126}
                         IO_INPUT_DELAY4 {126}
                         IO_INPUT_DELAY5 {126}
                         IO_INPUT_DELAY6 {126}
                         IO_INPUT_DELAY7 {126}
                         IO_INPUT_DELAY8 {126}
                         IO_INPUT_DELAY9 {126}
                         IO_INPUT_DELAY10 {126}
                         IO_INPUT_DELAY11 {126}"