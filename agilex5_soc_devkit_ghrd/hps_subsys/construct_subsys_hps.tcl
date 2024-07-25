#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2023 Intel Corporation.
#
#****************************************************************************
#
# This script construct Hard Processor subsystem for higher level integration later.
# The Makefile in $prjroot folder will pass in variable needed by this TCL as defined
# in the subsystem Makefile automatically. User will have the ability to modify the 
# defined variable dynamically during (MAKE) target flow of generate_from_tcl.
#
#****************************************************************************
set currentdir [pwd]
set foldername [file tail $currentdir]
puts "\[GHRD:info\] Directory name: $foldername"

puts "\[GHRD:info\] \$prjroot = ${prjroot}"
source ${prjroot}/arguments_solver.tcl
source ${prjroot}/utils.tcl

set subsys_name $foldername
  
package require -exact qsys 24.3

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


create_system $subsys_name

set_project_property DEVICE_FAMILY $device_family
set_project_property DEVICE $device
set_validation_property AUTOMATIC_VALIDATION false

if {$hps_clk_source == 1} {
add_component_param "altera_clock_bridge sub_clk 
                    IP_FILE_PATH ip/$subsys_name/sub_clk.ip 
                    EXPLICIT_CLOCK_RATE 100000000 
                    NUM_CLOCK_OUTPUTS 1
                    "

add_component_param "altera_reset_bridge sub_rst_in 
                    IP_FILE_PATH ip/$subsys_name/sub_rst_in.ip 
                    ACTIVE_LOW_RESET 1
                    SYNCHRONOUS_EDGES both
                    NUM_RESET_OUTPUTS 1
                    USE_RESET_REQUEST 0
                    "
}

add_component_param "intel_agilex_5_soc agilex_hps
                     IP_FILE_PATH ip/$subsys_name/agilex_hps.ip 
                     MPU_EVENTS_Enable 0
                     GP_Enable 0
                     Debug_APB_Enable 0
                     STM_Enable 0
                     JTAG_Enable 0
                     CTI_Enable 0
                     DMA_PeriphID 0
                     DMA_Enable {No No No No No No No No}
                     F2H_IRQ_Enable 1
                     HPS_IO_Enable {$io48_q1_assignment $io48_q2_assignment $io48_q3_assignment $io48_q4_assignment}
                     H2F_Width $h2f_width
					 H2F_Address_Width $h2f_addr_width
					 f2sdram_data_width $f2sdram_width
					 f2sdram_address_width $f2sdram_addr_width
					 f2s_data_width $f2s_data_width
					 f2s_address_width $f2s_address_width
                     LWH2F_Width $lwh2f_width
					 LWH2F_Address_Width $lwh2f_addr_width
                     EMIF_AXI_Enable $hps_emif_en
                     EMIF_Topology $emif_topology
					 MPU_clk_ccu_div {2:Div2}
					 MPU_clk_periph_div {4:Div4}
					 Rst_sdm_wd_config $reset_sdm_watchdog_cfg
					 F2H_free_clk_mhz 125
                     "
if {$device == "A5ED065BB32AE6SR0" || $device == "A5ED065BB32AE5SR0"} {
   set_component_param "agilex_hps
                        MPLL_Override true
                        MPLL_VCO_Override_mhz 3200.0
                        MPLL_C0_Override_mhz 800.0
                        MPLL_C1_Override_mhz 800.0
                        MPLL_C2_Override_mhz 533.33
                        MPLL_C3_Override_mhz 400.0
                        PPLL_Override true
                        PPLL_VCO_Override_mhz 3000.0
                        PPLL_C0_Override_mhz 600.0
                        PPLL_C1_Override_mhz 600.0
                        PPLL_C2_Override_mhz 24.0
                        PPLL_C3_Override_mhz 500.0
                        MPU_clk_override true
                        MPU_clk_src_override 2
                        MPU_clk_freq_override_mhz 533.33
                        MPU_core01_src_override 1
                        MPU_core01_freq_override_mhz 800.0
                        MPU_core2_freq_override_mhz 800.0
                        MPU_core3_freq_override_mhz 800.0
                        "
} elseif {$device == "A5ED065BB32AE4SR0"} {
   set_component_param "agilex_hps
                        MPLL_Override true
                        MPLL_VCO_Override_mhz 2800.0
                        MPLL_C0_Override_mhz 1400.0
                        MPLL_C1_Override_mhz 700.0
                        MPLL_C2_Override_mhz 933.33
                        MPLL_C3_Override_mhz 400.0
                        PPLL_Override true
                        PPLL_VCO_Override_mhz 2500.0
                        PPLL_C0_Override_mhz 1250.0
                        PPLL_C1_Override_mhz 500.0
                        PPLL_C2_Override_mhz 25.0
                        PPLL_C3_Override_mhz 500.0
                        MPU_clk_override true
                        MPU_clk_src_override 2
                        MPU_clk_freq_override_mhz 933.33
                        MPU_core01_src_override 4
                        MPU_core01_freq_override_mhz 1250.0
                        MPU_core2_freq_override_mhz 1400.0
                        MPU_core3_freq_override_mhz 1400.0
                        "
}
					 
if {$f2sdram_width > 0} {
reload_ip_catalog
add_component_param "f2sdram_adapter f2sdram_adapter
					 IP_FILE_PATH ip/$subsys_name/f2sdram_adapter.ip 
					 DATA_WIDTH $f2sdram_width
					"
				
}

if {$reset_watchdog_en == 1} {
set_component_param "agilex_hps 
                     Rst_watchdog_en $reset_watchdog_en
					 "
}

if {$reset_hps_warm_en == 1} {
set_component_param "agilex_hps 
                     Rst_hps_warm_en $reset_hps_warm_en
					 "
}
					 
if {$reset_h2f_cold_en == 1} {
set_component_param "agilex_hps 
                     Rst_h2f_cold_en $reset_h2f_cold_en
					 "
}

if {$sub_fpga_rgmii_en == 1} {
   set_component_param "agilex_hps 
                     EMAC1_PinMuxing FPGA
                     EMAC1_Mode RGMII_with_MDIO
	             "
  
}

# EMIF_DDR_WIDTH $hps_emif_width 
if {$hps_emif_en == 1} {
    set cpu_instance agilex_hps
	set board_emif_config_file "$prjroot/board/board_${board}_emif_setting.tcl"
    if {[file exist $board_emif_config_file]} {
        source $board_emif_config_file
    } else {
        error "$board_emif_config_file not exist!! Please make sure the board settings files are included in folder ./board/"
    }
}

load_component agilex_hps
for {set i 0} {$i < 48} {incr i} {
set_component_parameter_value IO_INPUT_DELAY${i} $input_dly_chain_io48(${i})
set_component_parameter_value IO_OUTPUT_DELAY${i} $output_dly_chain_io48(${i})
}
save_component

#MPU_CLK_VCCL 1

# if {$user0_clk_src_select == 1} {
# set_component_param "agilex_hps   
                     # User0_clk_src_select 1
                     # User0_clk_freq 100
# "
# }

# if {$user1_clk_src_select == 1} {
# set_component_param "agilex_hps   
                     # User1_clk_src_select 1
                     # User1_clk_freq $user1_clk_freq
# "
# }

if {$hps_clk_source == 1} {
set_component_param "agilex_hps
                     MPLL_Clock_Source {1:FPGA Free Clock}
                     PPLL_Clock_Source {1:FPGA Free Clock}
                     F2H_free_clock_enable 1
                     F2H_free_clk_mhz 25"
# Above F2H_free_clk_mhz is temporary edit to reflect PO need. It shall revert to 100 MHz when release to follow default clock rate on board
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
# if {$ftrace_en == 1} {
   # set_component_param "agilex_hps TRACE_PinMuxing FPGA"
   
   # add_component_param "altera_trace_wrapper ext_trace
                        # IP_FILE_PATH ip/$qsys_name/ext_trace.ip 
                        # NUM_PIPELINE_REG 1"

   #HPS Trace: 4,8,12 yield 64bits output trace from hps
   #FPGA Trace: 16-bit yield only 32bits output trace; 32-bit yield 64bits output trace
   # set ftrace_mode "${ftrace_output_width}-bit"
   # set_component_param "agilex_hps   TRACE_Mode $ftrace_mode"
                  
   # set_component_param "ext_trace IN_DWIDTH $ftrace_output_width"
# } 

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
#   if {$sub_peri_en == 1} {
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
#      if {$sub_peri_en == 1} {
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

# if {$ftrace_en == 1} {
# connect "rst_in.out_reset     ext_trace.reset_sink
         # agilex_hps.trace_h2f_clk ext_trace.clock_sink
         # agilex_hps.trace         ext_trace.h2f_tpiu"
# }
if {$hps_clk_source == 1} {
connect "sub_clk.out_clk agilex_hps.f2h_free_clk
         sub_clk.out_clk sub_rst_in.clk 
        "
}

if {$f2sdram_width > 0} {
connect "f2sdram_adapter.axi4_man agilex_hps.f2sdram
		"
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
export agilex_hps fpga2hps_interrupt f2h_irq_in
if {$hps_usb0_en == 1 | $hps_usb1_en == 1} {
export agilex_hps usb31_io usb31_io
export agilex_hps usb31_phy_pma_cpu_clk usb31_phy_pma_cpu_clk
export agilex_hps usb31_phy_refclk_p usb31_phy_refclk_p
export agilex_hps usb31_phy_refclk_n usb31_phy_refclk_n
export agilex_hps usb31_phy_rx_serial_n usb31_phy_rx_serial_n
export agilex_hps usb31_phy_rx_serial_p usb31_phy_rx_serial_p
export agilex_hps usb31_phy_tx_serial_n usb31_phy_tx_serial_n
export agilex_hps usb31_phy_tx_serial_p usb31_phy_tx_serial_p
export agilex_hps usb31_phy_reconfig_rst usb31_phy_reconfig_rst
export agilex_hps usb31_phy_reconfig_clk usb31_phy_reconfig_clk
export agilex_hps usb31_phy_reconfig_slave usb31_phy_reconfig_slave
}

if {$hps_clk_source == 1} {
export sub_rst_in in_reset reset
export sub_clk in_clk clk
}

if {$hps_io_off == 0} {
export agilex_hps hps_io hps_io
}

if {$reset_watchdog_en == 1} {
export agilex_hps h2f_watchdog_reset h2f_watchdog_reset
}

# h2f_warm_reset_handshake conduit is exposed when the f2sdram bridge is enabled
if {$f2sdram_width > 0} {
export agilex_hps h2f_warm_reset_handshake h2f_warm_reset_handshake
}
					 
if {$reset_h2f_cold_en == 1} {
export agilex_hps h2f_cold_reset h2f_cold_reset
}

# if {$hps_stm_en == 1} {
# export agilex_hps stm_hwevents agilex_hps_f2h_stm_hw_events
# export agilex_hps h2f_cs agilex_hps_h2f_cs
# }

# if {$reset_watchdog_en == 1} {
# export agilex_hps h2f_watchdog_reset wd_reset
# }


if {$f2s_data_width > 0} {
    export agilex_hps fpga2hps fpga2hps
    export agilex_hps fpga2hps_clock fpga2hps_clk
    export agilex_hps fpga2hps_reset fpga2hps_rst
}

if {$f2sdram_width > 0} {
    export agilex_hps f2sdram_axi_clock f2sdram_clk
    export agilex_hps f2sdram_axi_reset f2sdram_rst
	export f2sdram_adapter clock f2sdram_adapter_clk
	export f2sdram_adapter reset f2sdram_adapter_rst
	export f2sdram_adapter axi4_sub f2sdram_adapter_axi4_sub
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

if {$sub_fpga_rgmii_en == 1} {
    export agilex_hps emac1 emac1
    export agilex_hps emac1_app_rst emac1_app_rst
    export agilex_hps emac1_mdio emac1_mdio
    export agilex_hps emac_ptp_clk emac_ptp_clk
    export agilex_hps emac_timestamp_clk emac_timestamp_clk
    export agilex_hps emac_timestamp_data emac_timestamp_data
   
}


if {$pwr_mpu_l3_cache_size < 2} {
   set_component_param "agilex_hps   
                        Pwr_mpu_l3_cache_size $pwr_mpu_l3_cache_size
                        "
}

if {$pwr_a55_core0_1_on == 0} {
   set_component_param "agilex_hps   
                        Pwr_a55_core0_1_on false                        
                        "
}

if {$pwr_a76_core2_on == 0} {
   set_component_param "agilex_hps   
                        Pwr_a76_core2_on false
                        "
}

if {$pwr_a76_core3_on == 0} {
   set_component_param "agilex_hps   
                        Pwr_a76_core3_on false
                        "
}

if {$pwr_boot_core_sel == 0} {
   set_component_param "agilex_hps   
                        Pwr_boot_core_sel  0
                        "
}

if {$pwr_boot_core_sel == 1} {
   set_component_param "agilex_hps   
                        Pwr_boot_core_sel  2
                        "
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

# if {$ftrace_en == 1} {
# export ext_trace f2h_clk_in ext_trace_f2h_clk_in
# export ext_trace trace_clk_out ext_trace_trace_clk_out
# export ext_trace trace_data_out ext_trace_trace_data_out
# }

# interconnect requirements
# set_domain_assignment {$system} {qsys_mm.clockCrossingAdapter} {AUTO}
# set_domain_assignment {$system} {qsys_mm.maxAdditionalLatency} {1}
# set_domain_assignment {$system} {qsys_mm.enableEccProtection} {FALSE}
# set_domain_assignment {$system} {qsys_mm.insertDefaultSlave} {FALSE}

sync_sysinfo_parameters     

save_system ${subsys_name}.qsys

