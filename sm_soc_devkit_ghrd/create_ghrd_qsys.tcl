#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2020 Intel Corporation.
#
#****************************************************************************
#
# This script construct top level qsys for the GHRD
# to use this script, 
# example command to execute this script file
#   qsys-script --script=create_ghrd_qsys.tcl
#
# The value of the arguments is resolved from arguments_solver.tcl. The default value is defined in design_config.tcl.
#
# --- alternatively, input arguments could be passed in to select other FPGA variant. 
#     Refer arguments_solver.tcl for list of acceptable arguments

# example command to execute this script file
#   qsys-script --script=create_ghrd_qsys.tcl --cmd="set qsys_name soc_system; set devicefamily STRATIX10; set device 1SX280LU3F50E3VG"
#
#****************************************************************************

source ./arguments_solver.tcl
source ./utils.tcl

package require -exact qsys 19.1

if {$fpga_peripheral_en == 1} {
source ./peripheral_subsys/construct_subsys_peripheral.tcl
reload_ip_catalog
}

if {$jtag_ocm_en == 1} {
source ./jtag_subsys/construct_subsys_jtag_master.tcl
reload_ip_catalog
}
if {$hps_en == 1} {
source ./hps_subsys/construct_subsys_hps.tcl
reload_ip_catalog
}

create_system $qsys_name

set_project_property DEVICE_FAMILY $device_family
set_project_property DEVICE $device
set_validation_property AUTOMATIC_VALIDATION false

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

add_component_param "altera_s10_user_rst_clkgate user_rst_clkgate_0
                    IP_FILE_PATH ip/$qsys_name/user_rst_clkgate_0.ip 
                    "
					
add_component_param "intel_onchip_memory ocm
                    IP_FILE_PATH ip/$qsys_name/ocm.ip 
                    dataWidth $ocm_datawidth
                    memorySize $ocm_memsize
                    singleClockOperation 1
		    interfaceType 1
		    idWidth 6
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

if {$jtag_ocm_en == 1} {
add_instance jtg_mst subsys_jtg_mst
}

if {$fpga_peripheral_en == 1} {
add_instance periph_subsys subsys_periph
}

if {$hps_en == 1} {
add_instance hps_subsys subsys_hps
}

connect "   clk_100.out_clk                    ext_hps_m_master.clock
            rst_in.out_reset                   ext_hps_m_master.reset"

connect_map "   jtg_mst.hps_m_master              ext_hps_m_master.windowed_slave 0x0 "
connect_map "   ext_hps_m_master.expanded_master  hps_subsys.fpga2hps 0x1_0000_0000 "
connect_map "   ext_hps_m_master.expanded_master  hps_subsys.f2sdram 0x0000 "
	
if {$cct_en == 1} {	
	connect "	clk_100.out_clk        intel_cache_coherency_translator_0.clock
			    rst_in.out_reset       intel_cache_coherency_translator_0.reset
		"

    if {$cct_control_interface == 2} {
        connect "clk_100.out_clk                   intel_cache_coherency_translator_0.csr_clock
                 rst_in.out_reset                  intel_cache_coherency_translator_0.csr_reset
                "
    }

    if {$f2s_address_width >32} {
        connect_map "jtg_mst.hps_m_master               ext_hps_m_master.windowed_slave            0x0"
        connect_map "ext_hps_m_master.expanded_master   intel_cache_coherency_translator_0.s0      0x0"
    } else {
        connect_map "jtg_mst.hps_m_master               intel_cache_coherency_translator_0.s0      0x0"
    }
	
	connect_map " intel_cache_coherency_translator_0.m0              hps_subsys.fpga2hps 0x0000 "
	connect_map " hps_subsys.lwhps2fpga                              intel_cache_coherency_translator_0.csr "
	connect_map " jtg_mst.fpga_m_master                              intel_cache_coherency_translator_0.csr 0x10200 "
}

# --------------- Connections and connection parameters ------------------#

if {$hps_en == 1} {
connect "clk_100.out_clk   hps_subsys.clk
         rst_in.out_reset  hps_subsys.reset
         "
}

if {$jtag_ocm_en == 1} {
   if {$ocm_clk_source == 0} {
	connect "   clk_100.out_clk   ocm.clk1
			   rst_in.out_reset  ocm.reset1 
		   "
	connect_map " jtg_mst.fpga_m_master ocm.axi_s1 0x40000	"
   }
}

if {$jtag_ocm_en == 1} {
connect "   clk_100.out_clk   jtg_mst.clk
            rst_in.out_reset  jtg_mst.reset   
"
}

#if {$fpga_peripheral_en == 1} {
#	connect_map "   jtg_mst.fpga_m_master   periph_subsys.control_slave 0x10000"
#}

if {$fpga_peripheral_en == 1} {
connect "clk_100.out_clk   periph_subsys.clk
         rst_in.out_reset  periph_subsys.reset
         "
}

if {$fpga_peripheral_en == 1} {
    if {$fpga_button_pio_width >0} {
#       connect "agilex_hps.f2h_irq0      periph.button_pio_irq"
#       set_connection_parameter_value agilex_hps.f2h_irq0/periph.button_pio_irq irqNumber {1}
       connect "periph_subsys.ILC_irq       periph_subsys.button_pio_irq"
       set_connection_parameter_value periph_subsys.ILC_irq/periph_subsys.button_pio_irq irqNumber {1}
    }
    if {$fpga_dipsw_pio_width >0} {
#       connect "agilex_hps.f2h_irq0      periph.dipsw_pio_irq"
#       set_connection_parameter_value agilex_hps.f2h_irq0/periph.dipsw_pio_irq irqNumber {0}
       connect "periph_subsys.ILC_irq       periph_subsys.dipsw_pio_irq"
       set_connection_parameter_value periph_subsys.ILC_irq/periph_subsys.dipsw_pio_irq irqNumber {0}
    }
}

if {$h2f_width > 0} {
   if {$h2f_width > 0 && $jtag_ocm_en == 1} {
      connect_map "hps_subsys.hps2fpga ocm.axi_s1 0x0000"
   }
}

if {$lwh2f_width > 0} {
   #if {$jtag_ocm_en == 1} {
   #   connect_map "hps_subsys.lwhps2fpga periph_subsys.control_slave 0x1_0000"
   #}
   
   if {$fpga_peripheral_en == 1} {
     connect_map "hps_subsys.lwhps2fpga periph_subsys.pb_cpu_0_s0 0x20000"
   }
}

# ---------------- Exported Interfaces ----------------------------------------#
export clk_100 in_clk clk_100
export rst_in in_reset reset
export user_rst_clkgate_0 ninit_done ninit_done
export hps_subsys usb31_io usb31_io
export hps_subsys I2C1 I2C1
export hps_subsys hps_io hps_io

if {$clk_gate_en == 1} {
export clkctrl_0 clkctrl_input clkctrl_input
export clkctrl_0 clkctrl_output clkctrl_output
}

if {$fpga_peripheral_en == 1} {
if {$fpga_button_pio_width >0} {
export periph_subsys button_pio_external_connection button_pio_external_connection
}
if {$fpga_dipsw_pio_width >0} {
export periph_subsys dipsw_pio_external_connection dipsw_pio_external_connection
}
if {$fpga_led_pio_width >0} {
export periph_subsys led_pio_external_connection led_pio_external_connection
}
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
