#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2020 Intel Corporation.
#
#****************************************************************************
#
# This script construct top level qsys for the GHRD
# The value of the variables is passed in through Makefile flow argument (QSYS_TCL_CMDS).
#
# To use this script independently from Makefile flow, following command can be used 
#   qsys-script --script=create_ghrd_qsys.tcl --cmd="<TCL command to set variables' value>"
# example command to execute this script file
#   qsys-script --script=create_ghrd_qsys.tcl --cmd="set qsys_name soc_system; set devicefamily STRATIX10; set device 1SX280LU3F50E3VG"
#
#****************************************************************************

puts "\[GHRD:info\] \$prjroot = ${prjroot} "
source ${prjroot}/arguments_solver.tcl
source ${prjroot}/utils.tcl

package require -exact qsys 19.1


create_system $qsys_name

set_project_property DEVICE_FAMILY $device_family
set_project_property DEVICE $device
set_validation_property AUTOMATIC_VALIDATION false

# Following IP components are present as basic of GHRD in FPGA fabric
#   - Clock Bridge
#   - Reset Bridge
#   - Reset Release IP
#   - Onchip Memory 
add_component_param "altera_clock_bridge clk_100
                    IP_FILE_PATH ip/$qsys_name/clk_100.ip 
                    EXPLICIT_CLOCK_RATE 100000000 
                    NUM_CLOCK_OUTPUTS 1
                    "

add_component_param "altera_reset_bridge rst_in
                    IP_FILE_PATH ip/$qsys_name/rst_in.ip 
                    ACTIVE_LOW_RESET 1
                    SYNCHRONOUS_EDGES none
                    NUM_RESET_OUTPUTS 1
                    USE_RESET_REQUEST 0
                    "

add_component_param "intel_user_rst_clkgate user_rst_clkgate_0
                    IP_FILE_PATH ip/$qsys_name/user_rst_clkgate_0.ip 
                    "
					
add_component_param "intel_onchip_memory ocm
                    IP_FILE_PATH ip/$qsys_name/ocm.ip 
                    dataWidth $ocm_datawidth
                    memorySize $ocm_memsize
                    singleClockOperation 1
                    interfaceType 1
                    idWidth 10
                    "
					
if {$clk_gate_en == 1} {
add_component_param "stratix10_clkctrl clkctrl_0
                    IP_FILE_PATH ip/$qsys_name/clkctrl_0.ip 
                    NUM_CLOCKS 1
                    ENABLE 1
                    ENABLE_REGISTER_TYPE 1
                    ENABLE_TYPE 1
                    "
}

if {$f2s_address_width > 32} {
    if {$cct_en == 1} {
    add_component_param "intel_cache_coherency_translator intel_cache_coherency_translator_0
                    IP_FILE_PATH ip/$qsys_name/intel_cache_coherency_translator_0.ip
                    CONTROL_INTERFACE $cct_control_interface
                    ADDR_WIDTH $f2s_address_width
                    AXM_ID_WIDTH 5
                    AXS_ID_WIDTH 5
                    ARDOMAIN_OVERRIDE 0
                    ARBAR_OVERRIDE 0
                    ARSNOOP_OVERRIDE 0
                    ARCACHE_OVERRIDE 2
                    AWDOMAIN_OVERRIDE 0
                    AWBAR_OVERRIDE 0
                    AWSNOOP_OVERRIDE 0
                    AWCACHE_OVERRIDE 2
                    AxUSER_OVERRIDE 0xE0
                    AxPROT_OVERRIDE 1
                    DATA_WIDTH $f2s_data_width
                    "
	}
}

add_component_param "altera_address_span_extender ext_hps_m_master
                    IP_FILE_PATH ip/$qsys_name/ext_hps_m_master.ip
                    BURSTCOUNT_WIDTH 1
                    MASTER_ADDRESS_WIDTH 33
                    SLAVE_ADDRESS_WIDTH 30
                    ENABLE_SLAVE_PORT 0
                    MAX_PENDING_READS 1
                    "
if {$sub_fpga_rgmii_en == 1} {
add_instance subsys_fpga_rgmii fpga_rgmii_subsys
reload_ip_catalog
}

if {$sub_hps_en == 1} {
add_instance subsys_hps hps_subsys
reload_ip_catalog
}

if {$sub_peri_en == 1} {
add_instance subsys_periph peripheral_subsys
reload_ip_catalog
}

if {$sub_debug_en == 1} {
add_instance subsys_debug jtag_subsys
reload_ip_catalog
}


connect "         clk_100.out_clk                        ext_hps_m_master.clock
                  rst_in.out_reset                       ext_hps_m_master.reset"
													     
connect_map "     subsys_debug.hps_m_master              ext_hps_m_master.windowed_slave 0x0 "
#connect_map "     ext_hps_m_master.expanded_master      subsys_hps.fpga2hps 0x1_0000_0000 "
connect_map "     ext_hps_m_master.expanded_master       subsys_hps.f2sdram 0x0000 "
													     
if {$cct_en == 1} {	                                     
	connect "	  clk_100.out_clk                        intel_cache_coherency_translator_0.clock
			      rst_in.out_reset                       intel_cache_coherency_translator_0.reset
		"                                                
													     
    if {$cct_control_interface == 2} {                   
        connect " clk_100.out_clk                        intel_cache_coherency_translator_0.csr_clock
                  rst_in.out_reset                       intel_cache_coherency_translator_0.csr_reset
                "
    }

    if {$f2s_address_width >32} {
        connect_map "subsys_debug.hps_m_master           ext_hps_m_master.windowed_slave            0x0"
        connect_map "ext_hps_m_master.expanded_master    intel_cache_coherency_translator_0.s0      0x0"
    } else {                                             
        connect_map "subsys_debug.hps_m_master           intel_cache_coherency_translator_0.s0      0x0"
    }
	
	connect_map "intel_cache_coherency_translator_0.m0   subsys_hps.fpga2hps 0x0000 "
	connect_map "subsys_hps.lwhps2fpga                   intel_cache_coherency_translator_0.csr "
	connect_map "subsys_debug.fpga_m_master              intel_cache_coherency_translator_0.csr 0x10200 "
}

# --------------- Connections and connection parameters ------------------#


connect "clk_100.out_clk   ocm.clk1
         rst_in.out_reset  ocm.reset1 
        "
           
if {$sub_hps_en == 1} {
  
  if {$hps_clk_source == 1} {
  connect " clk_100.out_clk   subsys_hps.clk
            rst_in.out_reset  subsys_hps.reset 
          "
  }
  if {$f2sdram_width > 0} {
  connect " clk_100.out_clk   subsys_hps.f2sdram_clk
            rst_in.out_reset  subsys_hps.f2sdram_rst 
          "
  }
  if {$lwh2f_width > 0} {
  connect " clk_100.out_clk   subsys_hps.lwhps2fpga_clk
            rst_in.out_reset  subsys_hps.lwhps2fpga_rst 
          "
  }
  if {$h2f_width > 0} {
  connect " clk_100.out_clk   subsys_hps.hps2fpga_clk
            rst_in.out_reset  subsys_hps.hps2fpga_rst 
          "
  }
  if {$f2s_data_width > 0} {
  connect " clk_100.out_clk   subsys_hps.fpga2hps_clk
            rst_in.out_reset  subsys_hps.fpga2hps_rst 
          "
  }

}


           
if {$sub_debug_en == 1} {
    connect_map "subsys_debug.fpga_m_master ocm.axi_s1 0x40000"

    connect "clk_100.out_clk     subsys_debug.clk
             rst_in.out_reset    subsys_debug.reset   
            "

    if {$hps_usb0_en == 1 | $hps_usb1_en == 1} {
        connect_map "subsys_debug.fpga_m_master subsys_hps.usb31_phy_reconfig_slave 0x800000"
    }
}

#if {$sub_peri_en == 1} {
#	connect_map "   subsys_debug.fpga_m_master   subsys_periph.control_slave 0x10000"
#}

if {$sub_peri_en == 1} {
connect "clk_100.out_clk   subsys_periph.clk
         rst_in.out_reset  subsys_periph.reset
         clk_100.out_clk   subsys_periph.ssgdma_host_clk
         rst_in.out_reset  subsys_periph.ssgdma_host_aresetn
         clk_100.out_clk   subsys_periph.ssgdma_h2d0_mm_clk
         rst_in.out_reset  subsys_periph.ssgdma_h2d0_mm_resetn
         "
}

if {$sub_peri_en == 1} {
    if {$fpga_button_pio_width >0} {
#       connect "agilex_hps.f2h_irq0      periph.button_pio_irq"
#       set_connection_parameter_value agilex_hps.f2h_irq0/periph.button_pio_irq irqNumber {1}
      # connect "subsys_periph.ILC_irq       subsys_periph.button_pio_irq"
      # set_connection_parameter_value subsys_periph.ILC_irq/subsys_periph.button_pio_irq irqNumber {1}
    }
    if {$fpga_dipsw_pio_width >0} {
#       connect "agilex_hps.f2h_irq0      periph.dipsw_pio_irq"
#       set_connection_parameter_value agilex_hps.f2h_irq0/periph.dipsw_pio_irq irqNumber {0}
      # connect "subsys_periph.ILC_irq       subsys_periph.dipsw_pio_irq"
      # set_connection_parameter_value subsys_periph.ILC_irq/subsys_periph.dipsw_pio_irq irqNumber {0}
    }
}

if {$h2f_width > 0} {
    connect_map "subsys_hps.hps2fpga ocm.axi_s1 0x0000"
}

if {$sub_peri_en == 1} {
   if {$lwh2f_width > 0} {
     connect_map "subsys_hps.lwhps2fpga subsys_periph.pb_cpu_0_s0 0x0"
     
     connect "subsys_hps.f2h_irq_in subsys_periph.button_pio_irq"
     set_connection_parameter_value subsys_hps.f2h_irq_in/subsys_periph.button_pio_irq irqNumber {0}
     connect "subsys_hps.f2h_irq_in subsys_periph.dipsw_pio_irq"
     set_connection_parameter_value subsys_hps.f2h_irq_in/subsys_periph.dipsw_pio_irq irqNumber {1}
     connect "subsys_hps.f2h_irq_in subsys_periph.ssgdma_interrupt"
     set_connection_parameter_value subsys_hps.f2h_irq_in/subsys_periph.ssgdma_interrupt irqNumber {2}
   }
   if {$f2s_data_width > 0} {
     connect_map "subsys_periph.ssgdma_host subsys_hps.fpga2hps 0x0"
   }
   connect_map "subsys_periph.ssgdma_h2d0 ocm.axi_s1 0x0"
}

if {$hps_usb0_en == 1 | $hps_usb1_en == 1} {
     connect "rst_in.out_reset subsys_hps.usb31_phy_reconfig_rst 
              clk_100.out_clk subsys_hps.usb31_phy_reconfig_clk 
             "
     connect_map "subsys_hps.lwhps2fpga subsys_hps.usb31_phy_reconfig_slave 0x80_0000"
}


if {$sub_fpga_rgmii_en == 1} {
   connect "subsys_fpga_rgmii.hps_gmii subsys_hps.emac0
            clk_100.out_clk   subsys_fpga_rgmii.clk
            rst_in.out_reset  subsys_fpga_rgmii.reset
           "
}

# ---------------- Exported Interfaces ----------------------------------------#
export clk_100 in_clk clk_100
export rst_in in_reset reset
export user_rst_clkgate_0 ninit_done ninit_done
export subsys_hps hps_io hps_io
if {$hps_usb0_en == 1 | $hps_usb1_en == 1} {
export subsys_hps usb31_io usb31_io
export subsys_hps o_pma_cu_clk o_pma_cu_clk
export subsys_hps usb31_phy_pma_cpu_clk usb31_phy_pma_cpu_clk
export subsys_hps usb31_phy_refclk_p usb31_phy_refclk_p
export subsys_hps usb31_phy_refclk_n usb31_phy_refclk_n
export subsys_hps usb31_phy_rx_serial_n usb31_phy_rx_serial_n
export subsys_hps usb31_phy_rx_serial_p usb31_phy_rx_serial_p
export subsys_hps usb31_phy_tx_serial_n usb31_phy_tx_serial_n
export subsys_hps usb31_phy_tx_serial_p usb31_phy_tx_serial_p
}

if {$reset_watchdog_en == 1} {
export subsys_hps h2f_watchdog_reset h2f_watchdog_reset
}

if {$reset_hps_warm_en == 1} {
export subsys_hps h2f_warm_reset_handshake h2f_warm_reset_handshake
}
					 
if {$reset_h2f_cold_en == 1} {
export subsys_hps h2f_cold_reset h2f_cold_reset
}

if {$hps_emif_en == 1} {
export subsys_hps emif_hps_emif_mem_0 emif_hps_emif_mem_0
export subsys_hps emif_hps_emif_oct_0 emif_hps_emif_oct_0
export subsys_hps emif_hps_emif_ref_clk_0 emif_hps_emif_ref_clk_0
}

if {$clk_gate_en == 1} {
export clkctrl_0 clkctrl_input clkctrl_input
export clkctrl_0 clkctrl_output clkctrl_output
}

if {$sub_peri_en == 1} {
if {$fpga_button_pio_width >0} {
export subsys_periph button_pio_external_connection button_pio_external_connection
}
if {$fpga_dipsw_pio_width >0} {
export subsys_periph dipsw_pio_external_connection dipsw_pio_external_connection
}
if {$fpga_led_pio_width >0} {
export subsys_periph led_pio_external_connection led_pio_external_connection
}
}

if {$sub_fpga_rgmii_en == 1} {
export subsys_fpga_rgmii phy_rgmii phy_rgmii
export subsys_hps emac_timestamp_clk emac_timestamp_clk
export subsys_hps emac_ptp_clk emac_ptp_clk
export subsys_hps emac0_mdio emac0_mdio
}

# interconnect requirements
set_domain_assignment {$system} {qsys_mm.clockCrossingAdapter} {AUTO}
set_domain_assignment {$system} {qsys_mm.maxAdditionalLatency} {4}
set_domain_assignment {$system} {qsys_mm.enableEccProtection} {FALSE}
set_domain_assignment {$system} {qsys_mm.insertDefaultSlave} {FALSE}
set_domain_assignment {$system} {qsys_mm.burstAdapterImplementation} {PER_BURST_TYPE_CONVERTER}

sync_sysinfo_parameters 
save_system ${qsys_name}.qsys
sync_sysinfo_parameters
save_system ${qsys_name}.qsys

