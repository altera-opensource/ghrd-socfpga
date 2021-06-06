#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2017-2021 Intel Corporation.
#
#****************************************************************************
#
# This tcl will be invoke by create_ghrd_qsys.tcl 
# This tcl script basically contained only configuration settings for HPS & HPS EMIF, connections between HPS & HPS EMIF
#
#****************************************************************************

add_component_param "altera_stratix10_hps s10_hps
                    IP_FILE_PATH ip/$qsys_name/s10_hps.ip 
                    MPU_EVENTS_Enable 0
                    STM_Enable $hps_stm_en
                    HPS_IO_Enable {$io48_q1_assignment $io48_q2_assignment $io48_q3_assignment $io48_q4_assignment}
                    F2S_Width $f2s_width
                    S2F_Width $s2f_width
                    LWH2F_Enable $lwh2f_width
                    EMIF_CONDUIT_Enable $hps_emif_en
                    F2S_ADDRESS_WIDTH $f2h_addr_width
                    S2F_ADDRESS_WIDTH $h2f_addr_width
                    LWH2F_ADDRESS_WIDTH $lwh2f_addr_width
                    F2S_ready_latency 0
                    S2F_ready_latency 0
                    LWH2F_ready_latency 0
                    CLK_GPIO_SOURCE 0
"

load_component s10_hps
for {set i 0} {$i < 48} {incr i} {
set_component_parameter_value IO_INPUT_DELAY${i} $input_dly_chain_io48(${i})
set_component_parameter_value IO_OUTPUT_DELAY${i} $output_dly_chain_io48(${i})
}
save_component

if {$board == "devkit" || $board == "atso12" || $board == "ashfield" || $board == "klamath"} {
set_component_param "s10_hps    
                    F2SINTERRUPT_Enable 1
                    MPU_CLK_VCCL 2
"
}

if {$board == "pe" || $h2f_user_clk_en == 1} {
set_component_param "s10_hps    
                    H2F_USER0_CLK_Enable 1
                    H2F_USER0_CLK_FREQ 100
"

add_component_param "altera_clock_bridge clk_h2f_user_clk
                    IP_FILE_PATH ip/$qsys_name/clk_h2f_user_clk.ip 
                    EXPLICIT_CLOCK_RATE 100000000 
                    NUM_CLOCK_OUTPUTS 1
                    "
}

set_component_param "s10_hps    
                    watchdog_reset $watchdog_rst_en
                    W_RESET_ACTION $watchdog_rst_act
                    "

if {$hps_emif_en == 1} {
set_component_param "s10_hps
                    F2SDRAM0_Width $f2sdram0_width
                    F2SDRAM1_Width $f2sdram1_width
                    F2SDRAM2_Width $f2sdram2_width
                    F2SDRAM0_ready_latency 0
                    F2SDRAM1_ready_latency 0
                    F2SDRAM2_ready_latency 0
"
}

if {$hps_pll_source_export == 1} {
set_component_param "s10_hps
                    CLK_MAIN_PLL_SOURCE2 2
                    CLK_PERI_PLL_SOURCE2 2
                    F2H_FREE_CLK_Enable 1
                    F2H_FREE_CLK_FREQ 100"
}

if {$hps_nand_q12_en == 1 || $hps_nand_q34_en == 1} {
set_component_param "s10_hps
                    NAND_PinMuxing IO
                    NAND_Mode 8-bit
"
}

if {$hps_nand_16b_en == 1} {
set_component_param "s10_hps    NAND_Mode 16-bit"
}

if {$hps_emac0_rmii_en == 1 || $hps_emac0_rgmii_en == 1} {
set_component_param "s10_hps    EMAC0_PinMuxing IO"
}

# TODO: pending relating mdio 0, 1, 2 to any emac. Now it is a enhancement case for HPS megawizard
if {$hps_emac0_rmii_en == 1 } {
set_component_param "s10_hps EMAC0_CLK 50"
  if {$hps_mdio0_q1_en == 1 || $hps_mdio0_q3_en == 1 || $hps_mdio0_q4_en == 1} {
    set_component_param "s10_hps    EMAC0_Mode RMII_with_MDIO"
  } else {
    set_component_param "s10_hps    EMAC0_Mode RMII"
  }
} elseif {$hps_emac0_rgmii_en == 1} {
  if {$hps_mdio0_q1_en == 1 || $hps_mdio0_q3_en == 1 || $hps_mdio0_q4_en == 1} {
    set_component_param "s10_hps    EMAC0_Mode RGMII_with_MDIO"
  } else {
    set_component_param "s10_hps    EMAC0_Mode RGMII"
  }
}

if {$hps_emac1_rmii_en == 1 || $hps_emac1_rgmii_en == 1} {
set_component_param "s10_hps    EMAC1_PinMuxing IO"
}
if {$hps_emac1_rmii_en == 1 } {
set_component_param "s10_hps EMAC1_CLK 50"
  if {$hps_mdio1_q1_en == 1 || $hps_mdio1_q4_en == 1} {
    set_component_param "s10_hps    EMAC1_Mode RMII_with_MDIO"
  } else {
    set_component_param "s10_hps    EMAC1_Mode RMII"
  }
} elseif {$hps_emac1_rgmii_en == 1} {
  if {$hps_mdio1_q1_en == 1 || $hps_mdio1_q4_en == 1} {
    set_component_param "s10_hps    EMAC1_Mode RGMII_with_MDIO"
  } else {
    set_component_param "s10_hps    EMAC1_Mode RGMII"
  }
}

if {$hps_emac2_rmii_en == 1 || $hps_emac2_rgmii_en == 1} {
set_component_param "s10_hps    EMAC2_PinMuxing IO"
}
if {$hps_emac2_rmii_en == 1 } {
set_component_param "s10_hps EMAC2_CLK 50"
  if {$hps_mdio2_q1_en == 1 || $hps_mdio2_q3_en == 1} {
    set_component_param "s10_hps    EMAC2_Mode RMII_with_MDIO"
  } else {
    set_component_param "s10_hps    EMAC2_Mode RMII"
  }
} elseif {$hps_emac2_rgmii_en == 1} {
  if {$hps_mdio2_q1_en == 1 || $hps_mdio2_q3_en == 1} {
    set_component_param "s10_hps    EMAC2_Mode RGMII_with_MDIO"
  } else {
    set_component_param "s10_hps    EMAC2_Mode RGMII"
  }
}

if {$hps_sdmmc4b_q1_en == 1 || $hps_sdmmc8b_q1_en == 1 || $hps_sdmmc4b_q4_en == 1 || $hps_sdmmc8b_q4_en == 1} {
set_component_param "s10_hps    
                    CLK_SDMMC_SOURCE 0  
                    SDMMC_PinMuxing IO"
}

#TODO: 1-bit mode to be added
if {$hps_sdmmc4b_q1_en == 1 || $hps_sdmmc4b_q4_en == 1} {
set_component_param "s10_hps    SDMMC_Mode 4-bit"
} elseif {$hps_sdmmc8b_q1_en == 1 || $hps_sdmmc8b_q4_en == 1} {
set_component_param "s10_hps    SDMMC_Mode 8-bit"
}

if {$hps_usb0_en == 1} {
set_component_param "s10_hps    
                    USB0_PinMuxing IO
                    USB0_Mode default
                    "
}
if {$hps_usb1_en == 1} {
set_component_param "s10_hps    
                    USB1_PinMuxing IO
                    USB1_Mode default
                    "
}
 
if {$hps_spim0_q1_en == 1 || $hps_spim0_q4_en == 1} {
set_component_param "s10_hps    
                    SPIM0_PinMuxing IO
                    SPIM0_Mode Single_slave_selects
                    "
}

if {$hps_spim0_2ss_en == 1} {
set_component_param "s10_hps SPIM0_Mode Dual_slave_selects"
}

if {$hps_spim1_q1_en == 1 || $hps_spim1_q2_en == 1 || $hps_spim1_q3_en == 1} {
set_component_param "s10_hps    
                    SPIM1_PinMuxing IO
                    SPIM1_Mode Single_slave_selects
                    "
}

if {$hps_spim1_2ss_en == 1} {
set_component_param "s10_hps SPIM1_Mode Dual_slave_selects"
}

if {$hps_spis0_q1_en == 1 || $hps_spis0_q2_en == 1 || $hps_spis0_q3_en == 1} {
set_component_param "s10_hps    
                    SPIS0_PinMuxing IO
                    SPIS0_Mode default
                    "
}

if {$hps_spis1_q1_en == 1 || $hps_spis1_q3_en == 1 || $hps_spis1_q4_en == 1} {
set_component_param "s10_hps    
                    SPIS1_PinMuxing IO
                    SPIS1_Mode default
                    "
}
 
if {$hps_uart0_q1_en == 1 || $hps_uart0_q2_en == 1 || $hps_uart0_q3_en == 1} {
set_component_param "s10_hps    
                    UART0_PinMuxing IO
                    UART0_Mode No_flow_control
                    "
}

if {$hps_uart0_fc_en == 1} {
set_component_param "s10_hps    UART0_Mode Flow_control"
}

if {$hps_uart1_q1_en == 1 || $hps_uart1_q3_en == 1 || $hps_uart1_q4_en == 1} {
set_component_param "s10_hps    
                    UART1_PinMuxing IO
                    UART1_Mode No_flow_control
                    "
}

if {$hps_uart1_fc_en == 1} {
set_component_param "s10_hps    UART1_Mode Flow_control"
}

if {$hps_i2c0_q1_en == 1 || $hps_i2c0_q2_en == 1 || $hps_i2c0_q3_en == 1} {
set_component_param "s10_hps    
                    I2C0_PinMuxing IO
                    I2C0_Mode default
                    "
}

if {$hps_i2c1_q1_en == 1 || $hps_i2c1_q2_en == 1 || $hps_i2c1_q3_en == 1 || $hps_i2c1_q4_en == 1} {
set_component_param "s10_hps    
                    I2C1_PinMuxing IO
                    I2C1_Mode default
                    "
}

if {$hps_i2c_emac0_q1_en == 1 || $hps_i2c_emac0_q3_en == 1 || $hps_i2c_emac0_q4_en == 1} {
set_component_param "s10_hps    
                    I2CEMAC0_PinMuxing IO
                    I2CEMAC0_Mode default
                    "
}

if {$hps_i2c_emac1_q1_en == 1 || $hps_i2c_emac1_q4_en == 1} {
set_component_param "s10_hps    
                    I2CEMAC1_PinMuxing IO
                    I2CEMAC1_Mode default
                    "
}

if {$hps_i2c_emac2_q1_en == 1 || $hps_i2c_emac2_q3_en == 1 || $hps_i2c_emac2_q4_en == 1} {
set_component_param "s10_hps    
                    I2CEMAC2_PinMuxing IO
                    I2CEMAC2_Mode default
                    "
}

if {$hps_mge_en == 1} {
for {set x 1} {$x<=$sgmii_count} {incr x} {
set_component_param "s10_hps
                     EMAC${x}_PinMuxing FPGA
                     EMAC${x}_Mode RGMII_with_MDIO 
                     FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_EMAC${x}_GTX_CLK 125
                     "
}
}

if {$hps_mge_10gbe_1588_en == 1} {
if {$hps_i2c0_q1_en == 0 && $hps_i2c0_q2_en == 0 && $hps_i2c0_q3_en == 0} {
set_component_param "s10_hps    
                    I2C0_PinMuxing FPGA
                    I2C0_Mode default
                    "
set mge_10gbe_i2c 0
puts "MGE I2C0 enable"
} elseif {$hps_i2c1_q1_en == 0 && $hps_i2c1_q2_en == 0 && $hps_i2c1_q3_en == 0 && $hps_i2c1_q4_en == 0} {
set_component_param "s10_hps    
                    I2C1_PinMuxing FPGA
                    I2C1_Mode default
                    "
set mge_10gbe_i2c 1
puts "MGE I2C1 enable"
} else {
error "Error: Conflict HPS i2c settings. None of I2C available"
}

}

if {$fpga_i2c_en == 1} {
if {$hps_i2c0_q1_en == 0 && $hps_i2c0_q2_en == 0 && $hps_i2c0_q3_en == 0} {
set_component_param "s10_hps    
                    I2C0_PinMuxing FPGA
                    I2C0_Mode default
                    "
set fpga_i2c_no 0
puts "fpga i2C0 enable"
} elseif {$hps_i2c1_q1_en == 0 && $hps_i2c1_q2_en == 0 && $hps_i2c1_q3_en == 0 && $hps_i2c1_q4_en == 0} {
set_component_param "s10_hps    
                    I2C1_PinMuxing FPGA
                    I2C1_Mode default
                    "
set fpga_i2c_no 1
puts "fpga I2C1 enable"
} else {
error "Error: Conflict HPS i2c settings. None of I2C available"
}
}

if {$gpio_loopback_en == 1 || $fpga_pcie == 1} {
set_component_param "s10_hps    
                    GP_Enable 1
                    "
}

 # CM_PinMuxing
 # CM_Mode
 # PLL_CLK0
 # PLL_CLK1
 # PLL_CLK2
 # PLL_CLK3
 # PLL_CLK4
 
 
if {$hps_peri_irq_loopback_en == 1} {
set_component_param "s10_hps    
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

#case:506129 - S10 GHRD: S10 HPS Trace data output width is inconsistent with the Trace-bit option between "4,8,12" and 16
if {$ftrace_en == 1} {
set_component_param "s10_hps TRACE_PinMuxing FPGA"

add_component_param "altera_trace_wrapper ext_trace
                    IP_FILE_PATH ip/$qsys_name/ext_trace.ip 
                    NUM_PIPELINE_REG 1"

#4,8,12 yield 64bits output trace from hps, 16 yield only 32bits
set_component_param "s10_hps    TRACE_Mode 12-bit"
# set_component_param "s10_hps  TRACE_Mode ${ftrace_output_width}-bit"
                    
set_component_param "ext_trace IN_DWIDTH $ftrace_output_width"
} 

if {$hps_trace_q12_en == 1 || $hps_trace_q34_en == 1 || $hps_trace_8b_en == 1 || $hps_trace_12b_en == 1 || $hps_trace_16b_en == 1} {
set_component_param "s10_hps TRACE_PinMuxing IO"
}

if {$hps_trace_q12_en == 1 || $hps_trace_q34_en == 1} {
set_component_param "s10_hps TRACE_Mode 4-bit"
}

if {$hps_trace_8b_en == 1} {
set_component_param "s10_hps    TRACE_Mode 8-bit"
} elseif {$hps_trace_12b_en == 1} {
set_component_param "s10_hps    TRACE_Mode 12-bit"
} elseif {$hps_trace_16b_en == 1} {
set_component_param "s10_hps    TRACE_Mode 16-bit"
}

if {$hps_emif_en == 1} {
set cpu_instance s10_hps
source ./construct_s10_emif.tcl
}

if {$fpga_pcie == 1} {
set_component_param "s10_hps    S2F_ready_latency 1"
if {$pcie_f2h == 1} {
#ACE-lite
set_component_param "s10_hps    F2S_mode 1"
set_component_param "s10_hps    F2S_ready_latency 1"
}
set_component_param "s10_hps    F2SDRAM0_ready_latency 1"
}

if {$hps_mge_10gbe_1588_en == 1} {
#ACE-lite
set_component_param "s10_hps    F2S_mode 1"
set_component_param "s10_hps    F2S_ready_latency 1"
}

# --------------- Connections and connection parameters ------------------#
if {$hps_emif_en == 1} {
    if {$f2sdram0_width > 0} {
    if {$fpga_pcie != 1} {
        connect "clk_100.out_clk s10_hps.f2sdram0_clock"
    }
        connect "rst_in.out_reset s10_hps.f2sdram0_reset"
    }
    if {$f2sdram1_width > 0} {
        connect "clk_100.out_clk s10_hps.f2sdram1_clock
                rst_in.out_reset s10_hps.f2sdram1_reset"
    }
    if {$f2sdram2_width > 0} {
        connect "clk_100.out_clk s10_hps.f2sdram2_clock
                rst_in.out_reset s10_hps.f2sdram2_reset"
    }
}

if {$f2h_width > 0} {
if {$fpga_pcie == 1 && $pcie_f2h == 1} {
connect "pcie_0.coreclkout_out s10_hps.f2h_axi_clock
         pcie_0.nreset_status_out s10_hps.f2h_axi_reset
         rst_in.out_reset s10_hps.f2h_axi_reset"
} elseif {$hps_mge_10gbe_1588_en == 1} {
connect "mge_10gbe_clk_156p25.out_clk s10_hps.f2h_axi_clock
         rst_in.out_reset s10_hps.f2h_axi_reset"
} else {
connect "clk_100.out_clk s10_hps.f2h_axi_clock
         rst_in.out_reset s10_hps.f2h_axi_reset"
}
}

if {$h2f_width > 0} {
if {$fpga_pcie != 1} {
connect "clk_100.out_clk s10_hps.h2f_axi_clock"
}
connect "rst_in.out_reset s10_hps.h2f_axi_reset"
}

if {$hps_mge_en == 1} {
connect "enet_refclk.out_clk s10_hps.h2f_lw_axi_clock
        rst_in.out_reset s10_hps.h2f_lw_axi_reset"
} elseif {$hps_mge_10gbe_1588_en == 1} {
connect "mge_refclk_csr.out_clk s10_hps.h2f_lw_axi_clock
        rst_in.out_reset s10_hps.h2f_lw_axi_reset"
} else {
if {$lwh2f_width > 0} {
connect "clk_100.out_clk s10_hps.h2f_lw_axi_clock
        rst_in.out_reset s10_hps.h2f_lw_axi_reset"
}
}

if {$h2f_f2h_loopback_en == 1} {
#temporary workaround for case:490612 and case:491241 to enable F2H bridge in ACE-lite mode
connect_map "s10_hps.h2f_axi_master s10_hps.f2h_axi_slave 0x0"
} elseif {$h2f_f2sdram0_loopback_en == 1 || $h2f_f2sdram1_loopback_en == 1 || $h2f_f2sdram2_loopback_en == 1} {
if {$h2f_f2sdram0_loopback_en == 1} {
connect_map "s10_hps.h2f_axi_master s10_hps.f2sdram0_data 0x0"
}
if {$h2f_f2sdram1_loopback_en == 1} {
connect_map "s10_hps.h2f_axi_master s10_hps.f2sdram1_data 0x0"
}
if {$h2f_f2sdram2_loopback_en == 1} {
connect_map "s10_hps.h2f_axi_master s10_hps.f2sdram2_data 0x0"
}
} else {
if {$board == "devkit" || $board == "atso12" || $board == "ashfield" || $board == "klamath"} {
connect_map "s10_hps.h2f_axi_master ocm.s1 0x0"
}
}

if {$lwh2f_f2h_loopback_en && $lwh2f_addr_width >= $f2h_addr_width} { 
#temporary workaround for case:490612 and case:491241 to enable F2H bridge in ACE-lite mode
connect_map "s10_hps.h2f_lw_axi_master s10_hps.f2h_axi_slave 0x0"
} else {
connect_map "s10_hps.h2f_lw_axi_master sysid.control_slave 0x0"
if {$board == "devkit" || $board == "atso12" || $board == "ashfield" || $board == "klamath"} {
connect_map "s10_hps.h2f_lw_axi_master periph.pb_cpu_0_s0 0x1000"
}
}

if {$board == "devkit" || $board == "atso12" || $board == "ashfield" || $board == "klamath"} {
if {$fpga_peripheral_en == 1} {
connect "s10_hps.f2h_irq0 periph.button_pio_irq
        s10_hps.f2h_irq0 periph.dipsw_pio_irq"
set_connection_parameter_value s10_hps.f2h_irq0/periph.button_pio_irq irqNumber {1}
set_connection_parameter_value s10_hps.f2h_irq0/periph.dipsw_pio_irq irqNumber {0}
}

if {$lwh2f_f2h_loopback_en == 0 && $h2f_f2h_loopback_en == 0} {
#temporary workaround for case:490612 and case:491241 to enable F2H bridge in ACE-lite mode
if {($fpga_pcie == 1 && $pcie_f2h == 1) || $hps_mge_10gbe_1588_en == 1} {
connect_map "ext_hps_m_master.expanded_master axi_bridge_for_acp_0.s0 0x0"
} else {
connect_map "jtg_mst.hps_m_master s10_hps.f2h_axi_slave 0x0"
}
}

if {$h2f_f2sdram0_loopback_en == 0 || $h2f_f2sdram1_loopback_en == 0 || $h2f_f2sdram2_loopback_en == 0} {
set h2f_f2sdram_loopback_list "$h2f_f2sdram0_loopback_en $h2f_f2sdram1_loopback_en $h2f_f2sdram2_loopback_en"
for {set x 0} {$x<$f2sdram_count} {incr x} {
set count 0
foreach h2f_f2sdram_loopback $h2f_f2sdram_loopback_list {
if {$count == $x && $h2f_f2sdram_loopback == 0} {
connect_map "jtg_mst.f2sdram_m_${x}_master s10_hps.f2sdram${x}_data 0x0"
}
incr count
}
}
}
}

if {$board == "pe"  || $h2f_user_clk_en == 1} {
connect "s10_hps.h2f_user0_clock clk_h2f_user_clk.in_clk"
}

if {$hps_peri_irq_loopback_en == 1} {
    # peripherals that do not have external ports will have their irq exported for loopback connection
connect "s10_hps.f2h_irq0 s10_hps.h2f_dma_abort_interrupt
        s10_hps.f2h_irq0 s10_hps.h2f_dma_interrupt0
        s10_hps.f2h_irq0 s10_hps.h2f_dma_interrupt1
        s10_hps.f2h_irq0 s10_hps.h2f_dma_interrupt2
        s10_hps.f2h_irq0 s10_hps.h2f_dma_interrupt3
        s10_hps.f2h_irq0 s10_hps.h2f_dma_interrupt4
        s10_hps.f2h_irq0 s10_hps.h2f_dma_interrupt5
        s10_hps.f2h_irq0 s10_hps.h2f_dma_interrupt6
        s10_hps.f2h_irq0 s10_hps.h2f_dma_interrupt7
        s10_hps.f2h_irq0 s10_hps.h2f_wdog0_interrupt
        s10_hps.f2h_irq0 s10_hps.h2f_wdog1_interrupt
        s10_hps.f2h_irq0 s10_hps.h2f_wdog2_interrupt
        s10_hps.f2h_irq0 s10_hps.h2f_wdog3_interrupt
        s10_hps.f2h_irq0 s10_hps.h2f_timer_l4sp_0_interrupt
        s10_hps.f2h_irq0 s10_hps.h2f_timer_l4sp_1_interrupt
        s10_hps.f2h_irq0 s10_hps.h2f_timer_sys_0_interrupt
        s10_hps.f2h_irq0 s10_hps.h2f_timer_sys_1_interrupt
        s10_hps.f2h_irq0 s10_hps.h2f_clkmgr_interrupt
        s10_hps.f2h_irq0 s10_hps.h2f_ecc_derr_interrupt
        s10_hps.f2h_irq0 s10_hps.h2f_ecc_serr_interrupt"
    if {$s2f_emac0_irq_en == 1} {
        connect "s10_hps.f2h_irq0 s10_hps.h2f_emac0_interrupt"
    }
    if {$s2f_emac1_irq_en == 1} {
        connect "s10_hps.f2h_irq0 s10_hps.h2f_emac1_interrupt"
    }
    if {$s2f_emac2_irq_en == 1} {
        connect "s10_hps.f2h_irq0 s10_hps.h2f_emac2_interrupt"
    }
    if {$s2f_gpio_irq_en == 1} {
        connect "s10_hps.f2h_irq0 s10_hps.h2f_gpio0_interrupt
                s10_hps.f2h_irq0 s10_hps.h2f_gpio1_interrupt"
    }
    if {$s2f_i2c0_irq_en == 1} {
        connect "s10_hps.f2h_irq0 s10_hps.h2f_i2c0_interrupt"
    }
    if {$s2f_i2c1_irq_en == 1} {
        connect "s10_hps.f2h_irq0 s10_hps.h2f_i2c1_interrupt"
    }
    if {$s2f_i2cemac0_irq_en == 1} {
        connect "s10_hps.f2h_irq0 s10_hps.h2f_i2c_emac0_interrupt"
    }
    if {$s2f_i2cemac1_irq_en == 1} {
        connect "s10_hps.f2h_irq0 s10_hps.h2f_i2c_emac1_interrupt"
    }
    if {$s2f_i2cemac2_irq_en == 1} {
        connect "s10_hps.f2h_irq0 s10_hps.h2f_i2c_emac2_interrupt"
    }
    if {$s2f_uart0_irq_en == 1} {
        connect "s10_hps.f2h_irq0 s10_hps.h2f_uart0_interrupt"
    }
    if {$s2f_uart1_irq_en == 1} {
        connect "s10_hps.f2h_irq0 s10_hps.h2f_uart1_interrupt"
    }
    if {$s2f_nand_irq_en == 1} {
        connect "s10_hps.f2h_irq0 s10_hps.h2f_nand_interrupt"
    }
    if {$s2f_sdmmc_irq_en == 1} {
        connect "s10_hps.f2h_irq0 s10_hps.h2f_sdmmc_interrupt"
    }
    if {$s2f_spim0_irq_en == 1} {
        connect "s10_hps.f2h_irq0 s10_hps.h2f_spim0_interrupt"
    }
    if {$s2f_spim1_irq_en == 1} {
        connect "s10_hps.f2h_irq0 s10_hps.h2f_spim1_interrupt"
    }
    if {$s2f_spis0_irq_en == 1} {
        connect "s10_hps.f2h_irq0 s10_hps.h2f_spis0_interrupt"
    }
    if {$s2f_spis1_irq_en == 1} {
        connect "s10_hps.f2h_irq0 s10_hps.h2f_spis1_interrupt"
    }
    if {$s2f_usb0_irq_en == 1} {
        connect "s10_hps.f2h_irq0 s10_hps.h2f_usb0_interrupt"
    }
    if {$s2f_usb1_irq_en == 1} {
        connect "s10_hps.f2h_irq0 s10_hps.h2f_usb1_interrupt"
    }
}

if {$ftrace_en == 1} {
connect "rst_in.out_reset ext_trace.reset_sink
         s10_hps.trace_s2f_clk ext_trace.clock_sink
         s10_hps.trace ext_trace.h2f_tpiu"
}

if {$hps_pll_source_export == 1} {
connect "clk_100.out_clk s10_hps.f2h_free_clock"
}

if {$fpga_pcie == 1} {
connect "pcie_0.coreclkout_out s10_hps.f2sdram0_clock
         clk_100.out_clk s10_hps.h2f_axi_clock
         pcie_0.nreset_status_out s10_hps.f2sdram0_reset
         pcie_0.nreset_status_out s10_hps.h2f_axi_reset
         pcie_0.nreset_status_out s10_hps.h2f_lw_axi_reset"
         
# connect_map "s10_hps.h2f_axi_master pcie_0.txs_ccb 0x10000000"
if {$pcie_hptxs == 1} {
connect_map "s10_hps.h2f_axi_master pcie_0.hptxs 0x10000000"
} else {
connect_map "s10_hps.h2f_axi_master pcie_0.txs 0x10000000"
}

if {$pcie_f2h == 1} {
#connect_map "pcie_0.ext_expanded_master s10_hps.f2h_axi_slave 0x0000"
connect_map "axi_bridge_for_acp_0.m0 s10_hps.f2h_axi_slave 0x0000"
} else {
connect_map "pcie_0.ext_expanded_master s10_hps.f2sdram0_data 0x0000"
}
connect_map "s10_hps.h2f_axi_master pcie_0.hip_reconfig 0x20000000"
connect_map "s10_hps.h2f_lw_axi_master pcie_0.pb_lwh2f_pcie 0x00010000"
connect_map "s10_hps.h2f_lw_axi_master pcie_link_stat_pio.s1 0x200"
}

if {$hps_mge_10gbe_1588_en == 1} {
for {set x 1} {$x<=$hps_mge_10gbe_1588_count} {incr x} {  
         
connect "s10_hps.f2h_irq0       mge_10gbe_1588_dma.tx_dma_ch1_irq
         s10_hps.f2h_irq0       mge_10gbe_1588_dma.rx_dma_ch1_irq
         s10_hps.f2h_irq0       mge_10gbe_1588_ctrl.sfp_control_pio_irq
         s10_hps.f2h_irq0       mge_10gbe_1588_ctrl.mge_10gbe_status_pio_irq
         s10_hps.f2h_irq0       mge_10gbe_1588_ctrl.mge_10gbe_mac_link_status_pio_irq
       "
set_connection_parameter_value s10_hps.f2h_irq0/mge_10gbe_1588_dma.tx_dma_ch1_irq irqNumber {4}
set_connection_parameter_value s10_hps.f2h_irq0/mge_10gbe_1588_dma.rx_dma_ch1_irq irqNumber {5}
set_connection_parameter_value s10_hps.f2h_irq0/mge_10gbe_1588_ctrl.sfp_control_pio_irq irqNumber {6}
set_connection_parameter_value s10_hps.f2h_irq0/mge_10gbe_1588_ctrl.mge_10gbe_status_pio_irq irqNumber {7}
set_connection_parameter_value s10_hps.f2h_irq0/mge_10gbe_1588_ctrl.mge_10gbe_mac_link_status_pio_irq irqNumber {8}

if {$hps_mge_10gbe_1588_count == 2} {
connect "s10_hps.f2h_irq0       mge_10gbe_1588_dma.tx_dma_ch2_irq
         s10_hps.f2h_irq0       mge_10gbe_1588_dma.rx_dma_ch2_irq
       "
set_connection_parameter_value s10_hps.f2h_irq0/mge_10gbe_1588_dma.tx_dma_ch2_irq irqNumber {9}
set_connection_parameter_value s10_hps.f2h_irq0/mge_10gbe_1588_dma.rx_dma_ch2_irq irqNumber {10}
}
       
}
connect_map "axi_bridge_for_acp_0.m0   s10_hps.f2h_axi_slave 0x0000"
}

# --------------------    Exported Interfaces     -----------------------#
export s10_hps h2f_reset h2f_reset
export s10_hps hps_io hps_io
export s10_hps f2h_stm_hw_events s10_hps_f2h_stm_hw_events

if {$watchdog_rst_en == 1} {
export s10_hps h2f_watchdog_rst wd_reset
}

if {$board == "devkit" || $board =="atso12" || $board == "ashfield" || $board == "klamath" || $hps_peri_irq_loopback_en == 1} {
export s10_hps f2h_irq1 f2h_irq1
}

if {$board == "pe"  || $h2f_user_clk_en == 1} {
export clk_h2f_user_clk out_clk h2f_user_clk
}

if {$gpio_loopback_en == 1 || $fpga_pcie == 1} {
export s10_hps h2f_gp s10_hps_h2f_gp
}

if {$fpga_i2c_en == 1} {
export s10_hps i2c${fpga_i2c_no}_scl_in   fpga_i2c_scl_in
export s10_hps i2c${fpga_i2c_no}_clk      fpga_i2c_clk
export s10_hps i2c${fpga_i2c_no}          fpga_i2c
}

if {$ftrace_en == 1} {
export ext_trace f2h_clk_in ext_trace_f2h_clk_in
export ext_trace trace_clk_out ext_trace_trace_clk_out
export ext_trace trace_data_out ext_trace_trace_data_out
}

if {$hps_mge_10gbe_1588_en == 1} {
export s10_hps i2c${mge_10gbe_i2c}_scl_in   sfp_i2c_scl_in
export s10_hps i2c${mge_10gbe_i2c}_clk      sfp_i2c_clk
export s10_hps i2c${mge_10gbe_i2c}          sfp_i2c
}
