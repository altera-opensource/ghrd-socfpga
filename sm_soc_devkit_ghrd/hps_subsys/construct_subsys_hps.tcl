#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2021 Intel Corporation.
#
#****************************************************************************
#
# This script construct sub system of HPS for higher level integration
# This tcl will be invoke by create_ghrd_qsys.tcl 
# This tcl script basically contained only configuration settings for HPS & HPS EMIF, connections between HPS & HPS EMIF
#
#****************************************************************************

# source ./arguments_solver.tcl
# source ./utils.tcl


set subsys_name subsys_hps
  
package require -exact qsys 19.1

create_system $subsys_name

set_project_property DEVICE_FAMILY $device_family
set_project_property DEVICE $device
set_validation_property AUTOMATIC_VALIDATION false

# add_component_param "altera_clock_bridge hps_clk 
                    # IP_FILE_PATH ip/$subsys_name/hps_clk.ip 
                    # EXPLICIT_CLOCK_RATE 100000000 
                    # NUM_CLOCK_OUTPUTS 1
                    # "

# add_component_param "altera_reset_bridge hps_rst_in 
                    # IP_FILE_PATH ip/$subsys_name/hps_rst_in.ip 
                    # ACTIVE_LOW_RESET 1
                    # SYNCHRONOUS_EDGES both
                    # NUM_RESET_OUTPUTS 1
                    # USE_RESET_REQUEST 0
                    # "

add_component_param "intel_agilex_5_soc agilex_hps
                     IP_FILE_PATH ip/$subsys_name/agilex_hps.ip 
                     MPU_EVENTS_Enable 0
					 GP_Enable 0
					 Debug_APB_Enable 0
                     STM_Enable $hps_stm_en
					 JTAG_Enable 0
					 CTI_Enable 0
					 DMA_PeriphID 0
					 DMA_Enable No
                     HPS_IO_Enable {$io48_q1_assignment $io48_q2_assignment $io48_q3_assignment $io48_q4_assignment}
                     H2F_Width $h2f_width
					 H2F_Address_Width $h2f_addr_width
					 f2sdram_data_width $f2sdram_data_width
					 f2sdram_address_width $f2sdram_address_width
					 f2s_data_width $f2s_data_width
					 f2s_address_width $f2s_address_width
					 f2s_mode acelite
                     LWH2F_Width $lwh2f_width
					 LWH2F_Address_Width $lwh2f_addr_width
                     EMIF_AXI_Enable $hps_emif_en
                     Rst_watchdog_en $reset_watchdog_en
					 Rst_hps_warm_en $reset_hps_warm_en
					 Rst_h2f_cold_en $reset_h2f_cold_en
					 Rst_sdm_wd_config $reset_sdm_watchdog_cfg
"


if {$hps_emif_en == 1} {
    source ../board/emif_setting.tcl

}
# EMIF_DDR_WIDTH $hps_emif_width     
       
#load_component agilex_hps
#for {set i 0} {$i < 48} {incr i} {
#set_component_parameter_value IO_INPUT_DELAY${i} $input_dly_chain_io48(${i})
#set_component_parameter_value IO_OUTPUT_DELAY${i} $output_dly_chain_io48(${i})
#}
#save_component

#MPU_CLK_VCCL 1

# connect "hps_clk.out_clk hps_rst_in.clk" 

if {$user0_clk_src_select == 1} {
set_component_param "agilex_hps   
                     User0_clk_src_select 1
                     User0_clk_freq 100
"
}

if {$user1_clk_src_select == 1} {
set_component_param "agilex_hps   
                     User1_clk_src_select 1
                     User1_clk_freq $user1_clk_freq
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

if {$hps_sdmmc4b_q1_en == 1 || $hps_sdmmc8b_q1_alt_en == 1 || $hps_sdmmc_pupd_q4_en == 1 || $hps_sdmmc_pwr_q4_en == 1} {
   set_component_param "agilex_hps   
                        CLK_SDMMC_SOURCE 1   
                        SDMMC_PinMuxing IO"
}

#TODO: 1-bit mode to be added
if {$hps_sdmmc4b_q1_en == 1 || $hps_sdmmc_pupd_q4_en == 1} {
   set_component_param "agilex_hps   SDMMC_Mode 4-bit"
} elseif {$hps_sdmmc8b_q1_alt_en == 1 || $hps_sdmmc_pwr_q4_en == 1} {
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

#if {$hps_sgmii_emac1_en == 1} {
#set_component_param "agilex_hps
#                     EMAC1_PinMuxing FPGA
#                     EMAC1_Mode RGMII_with_MDIO 
#                     FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_EMAC1_GTX_CLK 125
#                     "
#}

#if {$hps_sgmii_emac2_en == 1} {
#set_component_param "agilex_hps
#                     EMAC2_PinMuxing FPGA
#                     EMAC2_Mode RGMII_with_MDIO 
#                     FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_EMAC2_GTX_CLK 125
#                     "
#}

#if {$gpio_loopback_en == 1 || $fpga_pcie == 1} {
#   set_component_param "agilex_hps   
#                        GP_Enable 1
#                        "
#}

if {$cct_en == 1} {
   set_component_param "agilex_hps 
                        F2S_mode acelite
                        "
} #F2S_Route_config 2

if {$hps_i2c1_q1_en == 0 && $hps_i2c1_q2_en == 0 && $hps_i2c1_q3_en == 0 && $hps_i2c1_q4_en == 0} {
   set_component_param "agilex_hps
                       I2C1_PinMuxing FPGA
                       I2C1_Mode default
                       "
   set etile_25gbe_i2c 1
   puts "Etile 25GbE I2C1 enable"
} else {
   error "Error: Conflict HPS i2c settings. None of I2C available"
}

# connect "hps_clk.out_clk agilex_hps.I2C1_scl_i" 

 # CM_PinMuxing
 # CM_Mode
 # PLL_CLK0
 # PLL_CLK1
 # PLL_CLK2
 # PLL_CLK3
 # PLL_CLK4
#if {$hps_peri_irq_loopback_en == 0} {
#   set_component_param "agilex_hps   
#                        F2H_IRQ_Enable $hps_f2s_irq_en
#"
#} else {
#   set_component_param "agilex_hps   
#                        F2H_IRQ_Enable 1
#						H2F_IRQ_PeriphClock_Enable 1
#						H2F_IRQ_ECC_SERR_Enable	1
#						H2F_IRQ_L4Timer_Enable 1
#						H2F_IRQ_SYSTimer_Enable 1
#						H2F_IRQ_Watchdog_Enable 1
#						H2F_IRQ_DMA_Enable0 1
#						H2F_IRQ_DMA_Enable1 1
#						H2F_IRQ_GPIO0_Enable $h2f_gpio0_irq_en
#						H2F_IRQ_GPIO1_Enable $h2f_gpio1_irq_en
#						H2F_IRQ_EMAC0_Enable $h2f_emac0_irq_en
#						H2F_IRQ_EMAC1_Enable $h2f_emac1_irq_en      
#						H2F_IRQ_EMAC2_Enable $h2f_emac2_irq_en      
#						H2F_IRQ_I2CEMAC0_Enable $h2f_i2cemac0_irq_en
#						H2F_IRQ_I2CEMAC1_Enable $h2f_i2cemac1_irq_en
#						H2F_IRQ_I2CEMAC2_Enable $h2f_i2cemac2_irq_en
#						H2F_IRQ_I2C0_Enable $h2f_i2c0_irq_en
#						H2F_IRQ_I2C1_Enable $h2f_i2c1_irq_en
#						H2F_IRQ_I3C0_Enable $h2f_i3c0_irq_en
#						H2F_IRQ_I3C1_Enable $h2f_i3c1_irq_en
#						H2F_IRQ_NAND_Enable $h2f_nand_irq_en
#						H2F_IRQ_SDMMC_Enable $h2f_sdmmc_irq_en
#						H2F_IRQ_SPIM0_Enable $h2f_spim0_irq_en
#						H2F_IRQ_SPIM1_Enable $h2f_spim1_irq_en
#						H2F_IRQ_SPIS0_Enable $h2f_spis0_irq_en
#						H2F_IRQ_SPIS1_Enable $h2f_spis1_irq_en
#						H2F_IRQ_UART0_Enable $h2f_uart0_irq_en
#						H2F_IRQ_UART1_Enable $h2f_uart1_irq_en
#						H2F_IRQ_USB2_0_Enable $h2f_usb0_irq_en
#						H2F_IRQ_USB2_1_Enable $h2f_usb1_irq_en
#                        "
#}

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

# --------------- Connections and connection parameters ------------------#





#if {$jtag_ocm_en == 1} {
#   if {$ocm_clk_source == 0} {
#   connect "   hps_clk.out_clk   ocm.clk1"
#   } else {
#   connect "   agilex_hps.h2f_user1_clock   ocm.clk1"
#   }
#}

#if {$h2f_width > 0} {
#   if {$h2f_width > 0 && $jtag_ocm_en == 1} {
#      connect_map "agilex_hps.hps2fpga ocm.s1 0x0"
#   }
#}
#
#if {$lwh2f_width > 0} {
#   if {$jtag_ocm_en == 1} {
#      connect_map "agilex_hps.lwhps2fpga sysid.control_slave 0x0"
#   }
#   
#   if {$fpga_peripheral_en == 1} {
#     connect_map "agilex_hps.lwhps2fpga periph.pb_cpu_0_s0 0x1000"
#   }
#}

#if {$jtag_ocm_en == 1} {
   #if { $acp_adapter_en == 0} {
   #   connect_map "jtg_mst.hps_m_master agilex_hps.f2h_axi_slave 0x0"
   #
   #   if {$secure_f2h_axi_slave == 1} {
   #      #set_interconnect_requirement {agilex_hps.f2h_axi_slave} qsys_mm.security {SECURE}
   #      #set_interconnect_requirement {jtg_mst.hps_m_master} qsys_mm.security {SECURE}
   #      set_interface_assignment {agilex_hps.f2h_axi_slave} {qsys_mm.security} {SECURE}
   #      set_interface_assignment {jtg_mst.hps_m_master} {qsys_mm.security} {SECURE}
   #   }
   #}
#}

#if {$hps_f2s_irq_en == 1} {
#   if {$hps_peri_irq_loopback_en == 1} {
#      # peripherals that do not have external ports will have their irq exported for loopback connection
#   connect "agilex_hps.f2h_irq0 agilex_hps.h2f_dma_abort_interrupt
#         agilex_hps.f2h_irq0 agilex_hps.h2f_dma_interrupt0
#         agilex_hps.f2h_irq0 agilex_hps.h2f_dma_interrupt1
#         agilex_hps.f2h_irq0 agilex_hps.h2f_dma_interrupt2
#         agilex_hps.f2h_irq0 agilex_hps.h2f_dma_interrupt3
#         agilex_hps.f2h_irq0 agilex_hps.h2f_dma_interrupt4
#         agilex_hps.f2h_irq0 agilex_hps.h2f_dma_interrupt5
#         agilex_hps.f2h_irq0 agilex_hps.h2f_dma_interrupt6
#         agilex_hps.f2h_irq0 agilex_hps.h2f_dma_interrupt7
#         agilex_hps.f2h_irq0 agilex_hps.h2f_wdog0_interrupt
#         agilex_hps.f2h_irq0 agilex_hps.h2f_wdog1_interrupt
#         agilex_hps.f2h_irq0 agilex_hps.h2f_wdog2_interrupt
#         agilex_hps.f2h_irq0 agilex_hps.h2f_wdog3_interrupt
#         agilex_hps.f2h_irq0 agilex_hps.h2f_timer_l4sp_0_interrupt
#         agilex_hps.f2h_irq0 agilex_hps.h2f_timer_l4sp_1_interrupt
#         agilex_hps.f2h_irq0 agilex_hps.h2f_timer_sys_0_interrupt
#         agilex_hps.f2h_irq0 agilex_hps.h2f_timer_sys_1_interrupt
#         agilex_hps.f2h_irq0 agilex_hps.h2f_clkmgr_interrupt
#         agilex_hps.f2h_irq0 agilex_hps.h2f_ecc_derr_interrupt
#         agilex_hps.f2h_irq0 agilex_hps.h2f_ecc_serr_interrupt"
#      if {$h2f_emac0_irq_en == 1} {
#         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_emac0_interrupt"
#      }
#      if {$h2f_emac1_irq_en == 1} {
#         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_emac1_interrupt"
#      }
#      if {$h2f_emac2_irq_en == 1} {
#         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_emac2_interrupt"
#      }
#      if {$h2f_gpio_irq_en == 1} {
#         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_gpio0_interrupt
#               agilex_hps.f2h_irq0 agilex_hps.h2f_gpio1_interrupt"
#      }
#      if {$h2f_i2c0_irq_en == 1} {
#         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_i2c0_interrupt"
#      }
#      if {$h2f_i2c1_irq_en == 1} {
#         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_i2c1_interrupt"
#      }
#      if {$h2f_i2cemac0_irq_en == 1} {
#         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_i2c_emac0_interrupt"
#      }
#      if {$h2f_i2cemac1_irq_en == 1} {
#         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_i2c_emac1_interrupt"
#      }
#      if {$h2f_i2cemac2_irq_en == 1} {
#         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_i2c_emac2_interrupt"
#      }
#      if {$h2f_uart0_irq_en == 1} {
#         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_uart0_interrupt"
#      }
#      if {$h2f_uart1_irq_en == 1} {
#         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_uart1_interrupt"
#      }
#      if {$h2f_nand_irq_en == 1} {
#         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_nand_interrupt"
#      }
#      if {$h2f_sdmmc_irq_en == 1} {
#         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_sdmmc_interrupt"
#      }
#      if {$h2f_spim0_irq_en == 1} {
#         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_spim0_interrupt"
#      }
#      if {$h2f_spim1_irq_en == 1} {
#         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_spim1_interrupt"
#      }
#      if {$h2f_spis0_irq_en == 1} {
#         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_spis0_interrupt"
#      }
#      if {$h2f_spis1_irq_en == 1} {
#         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_spis1_interrupt"
#      }
#      if {$h2f_usb0_irq_en == 1} {
#         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_usb0_interrupt"
#      }
#      if {$h2f_usb1_irq_en == 1} {
#         connect "agilex_hps.f2h_irq0 agilex_hps.h2f_usb1_interrupt"
#      }
#   } else {
#      if {$fpga_peripheral_en == 1} {
#         if {$fpga_button_pio_width >0} {
#            connect "agilex_hps.f2h_irq0      periph.button_pio_irq"
#            set_connection_parameter_value agilex_hps.f2h_irq0/periph.button_pio_irq irqNumber {1}
#            connect "periph.ILC_irq       periph.button_pio_irq"
#            set_connection_parameter_value periph.ILC_irq/periph.button_pio_irq irqNumber {1}
#         }
#         if {$fpga_dipsw_pio_width >0} {
#            connect "agilex_hps.f2h_irq0      periph.dipsw_pio_irq"
#            set_connection_parameter_value agilex_hps.f2h_irq0/periph.dipsw_pio_irq irqNumber {0}
#            connect "periph.ILC_irq       periph.dipsw_pio_irq"
#            set_connection_parameter_value periph.ILC_irq/periph.dipsw_pio_irq irqNumber {0}
#         }
#      }
#   }
#}

if {$ftrace_en == 1} {
connect "rst_in.out_reset     ext_trace.reset_sink
         agilex_hps.trace_h2f_clk ext_trace.clock_sink
         agilex_hps.trace         ext_trace.h2f_tpiu"
}

if {$hps_pll_source_export == 1} {
connect "clk_100.out_clk agilex_hps.f2h_free_clock"
}

#if {$acp_adapter_en == 1} {
# # temporary commented cause it lock the bridges.
# connect "pcie_nreset_status_merge.out_reset agilex_hps.h2f_axi_reset
#          pcie_nreset_status_merge.out_reset agilex_hps.h2f_lw_axi_reset"

#   if {$f2h_width > 0} {
#      connect  "pcie_nreset_status_merge.out_reset agilex_hps.f2h_axi_reset"
#      connect_map "axi_bridge_for_acp_0.m0   agilex_hps.f2h_axi_slave    0x0000"
#   }
#}

# --------------------    Exported Interfaces     -----------------------#
export agilex_hps h2f_reset h2f_reset
export agilex_hps usb31_io usb31_io
# export hps_rst_in in_reset reset
# export hps_clk in_clk clk
export agilex_hps I2C1 I2C1

if {$hps_io_off == 0} {
export agilex_hps hps_io hps_io
}

if {$hps_stm_en == 1} {
export agilex_hps stm_hwevents agilex_hps_f2h_stm_hw_events
export agilex_hps h2f_cs agilex_hps_h2f_cs
}

if {$reset_watchdog_en == 1} {
export agilex_hps h2f_watchdog_reset wd_reset
}


if {$f2s_data_width > 0} {
    export agilex_hps fpga2hps fpga2hps
    export agilex_hps fpga2hps_axi_clock fpga2hps_clk
    export agilex_hps fpga2hps_axi_reset fpga2hps_rst
}

if {$f2sdram_data_width > 0} {
    export agilex_hps f2sdram f2sdram
    export agilex_hps f2sdram_axi_clock f2sdram_clk
    export agilex_hps f2sdram_axi_reset f2sdram_rst
}

if {$h2f_width > 0} {
    export agilex_hps hps2fpga hps2fpga
    export agilex_hps hps2fpga_axi_clock hps2fpga_clk
    export agilex_hps hps2fpga_axi_reset hps2fpga_rst
}

if {$lwh2f_width > 0} {
    export agilex_hps lwhps2fpga lwhps2fpga
    export agilex_hps lwhps2fpga_axi_clock lwhps2fpga_clk
    export agilex_hps lwhps2fpga_axi_reset lwhps2fpga_rst
}






#if {$hps_f2s_irq_en == 1 || $hps_peri_irq_loopback_en == 1} {
#export agilex_hps fpga2hps_interrupt fpga2hps_interrupt
#}

#if {$user0_clk_src_select == 1} {
#export agilex_hps h2f_user0_clock user_clk_src_select
#}

#if {$gpio_loopback_en == 1 || $fpga_pcie == 1} {
#export agilex_hps h2f_gp agilex_hps_h2f_gp
#} 

if {$ftrace_en == 1} {
export ext_trace f2h_clk_in ext_trace_f2h_clk_in
export ext_trace trace_clk_out ext_trace_trace_clk_out
export ext_trace trace_data_out ext_trace_trace_data_out
}

# interconnect requirements
set_domain_assignment {$system} {qsys_mm.clockCrossingAdapter} {AUTO}
set_domain_assignment {$system} {qsys_mm.maxAdditionalLatency} {1}
set_domain_assignment {$system} {qsys_mm.enableEccProtection} {FALSE}
set_domain_assignment {$system} {qsys_mm.insertDefaultSlave} {FALSE}
    
sync_sysinfo_parameters 
    
save_system ${subsys_name}.qsys