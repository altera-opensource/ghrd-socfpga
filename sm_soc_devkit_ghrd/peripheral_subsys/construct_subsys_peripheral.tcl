#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2023 Intel Corporation.
#
#****************************************************************************
#
# This script construct Peripherals subsystem for higher level integration later.
# The Makefile in $prjroot folder will pass in variable needed by this TCL as defined
# in the subsystem Makefile automatically. User will have the ability to modify the 
# defined variable dynamically during (MAKE) target flow of generate_from_tcl.
#
#****************************************************************************
set currentdir [pwd]
set foldername [file tail $currentdir]
puts "\[GHRD:info\] Directory name: $foldername"

puts "\[GHRD:info\] \$prjroot = ${prjroot} "
source ${prjroot}/arguments_solver.tcl
source ${prjroot}/utils.tcl

if {$board == "cvr"} {
	    source $prjroot/board/board_cvr_config.tcl
	} else {
	    source $prjroot/board/board_DK-A5E065BB32AES1_config.tcl
	}

set subsys_name $foldername

package require -exact qsys 19.1

set SYSID "0xACD5CAFE"

create_system $subsys_name

set_project_property DEVICE_FAMILY $device_family
set_project_property DEVICE $device
set_validation_property AUTOMATIC_VALIDATION false

add_component_param "altera_clock_bridge periph_clk 
                    IP_FILE_PATH ip/$subsys_name/periph_clk.ip 
                    EXPLICIT_CLOCK_RATE 100000000 
                    NUM_CLOCK_OUTPUTS 1
                    "

add_component_param "altera_reset_bridge periph_rst_in 
                    IP_FILE_PATH ip/$subsys_name/periph_rst_in.ip 
                    ACTIVE_LOW_RESET 1
                    SYNCHRONOUS_EDGES both
                    NUM_RESET_OUTPUTS 1
                    USE_RESET_REQUEST 0
                    "

add_component_param "altera_avalon_sysid_qsys sysid
                    IP_FILE_PATH ip/$subsys_name/sysid.ip 
                    id $SYSID
                    "

if {$fpga_button_pio_width >0} {
add_component_param "altera_avalon_pio button_pio 
                    IP_FILE_PATH ip/$subsys_name/button_pio.ip 
                    bitClearingEdgeCapReg 1
                    captureEdge 1
                    direction Input
                    edgeType FALLING
                    generateIRQ 1
                    irqType EDGE
                    width $fpga_button_pio_width
                    "
}

if {$fpga_dipsw_pio_width >0} {
add_component_param "altera_avalon_pio dipsw_pio 
                    IP_FILE_PATH ip/$subsys_name/dipsw_pio.ip 
                    bitClearingEdgeCapReg 1
                    captureEdge 1
                    direction Input
                    edgeType FALLING
                    generateIRQ 1
                    irqType EDGE
                    width $fpga_dipsw_pio_width
                    "
}

if {$fpga_led_pio_width >0} {
set led_resetValue [expr {2^$fpga_led_pio_width -1 }]
add_component_param "altera_avalon_pio led_pio 
                    IP_FILE_PATH ip/$subsys_name/led_pio.ip 
                    direction InOut
                    width [expr {$fpga_led_pio_width -1}]
                    resetValue $led_resetValue
"
}

# Temporary turn off as 23.2.1 no ILC
#add_component_param "interrupt_latency_counter ILC 
#                    IP_FILE_PATH ip/$subsys_name/ILC.ip 
#                    INTR_TYPE 0
#                    IRQ_PORT_CNT 2
#                    "

if {$dfl_rom_en == 1} {
add_component_param "dfl_rom dfl_rom_inst
                    IP_FILE_PATH ip/$subsys_name/dfl_rom_inst.ip
                    ADDR_WIDTH 12
                    "
}

add_component_param "altera_avalon_mm_bridge pb_cpu_0 
                    IP_FILE_PATH ip/$subsys_name/pb_cpu_0.ip 
                    DATA_WIDTH 32
                    ADDRESS_WIDTH 20
                    USE_AUTO_ADDRESS_WIDTH 1
                    MAX_BURST_SIZE 1
                    MAX_PENDING_RESPONSES 1
                    "                           

add_component_param "intel_ssgdma ssgdma_0 
                    IP_FILE_PATH ip/$subsys_name/ssgdma_0.ip 
                    DMA_MODE {DMA SoC mode}
                    AXI_ST_PORT_FREQ_SOC_MODE_AGILEX5 100
                    NUM_H2D_MM_PORTS 1
                    NUM_H2D_ST_PORTS 0
                    NUM_D2H_ST_PORTS 0
                    "

# --------------- Connections and connection parameters ------------------#
connect "   periph_clk.out_clk sysid.clk
            periph_rst_in.out_reset sysid.reset
            periph_clk.out_clk ssgdma_0.axi_lite_clk
            periph_rst_in.out_reset ssgdma_0.axi_lite_areset_n
        "

connect_map "  pb_cpu_0.m0 ssgdma_0.host_csr 0x400000 "

#connect_map "   pb_cpu_0.m0 ILC.avalon_slave 0x10100 "

if {$fpga_led_pio_width >0} {
connect_map "   pb_cpu_0.m0 led_pio.s1 0x10080"
}

if {$fpga_dipsw_pio_width >0} {
connect_map "   pb_cpu_0.m0 dipsw_pio.s1 0x10070"
}

if {$fpga_button_pio_width >0} {
connect_map "   pb_cpu_0.m0 button_pio.s1 0x10060"
}

connect_map "   pb_cpu_0.m0 sysid.control_slave 0x1_0000 "

connect "   periph_clk.out_clk pb_cpu_0.clk
            periph_clk.out_clk periph_rst_in.clk
"
#            periph_clk.out_clk ILC.clk

if {$fpga_led_pio_width >0} {
connect "   periph_clk.out_clk      led_pio.clk
            periph_rst_in.out_reset led_pio.reset"
}
if {$fpga_dipsw_pio_width >0} {
connect "   periph_clk.out_clk      dipsw_pio.clk
            periph_rst_in.out_reset dipsw_pio.reset"
}
if {$fpga_button_pio_width >0} {
connect "   periph_clk.out_clk      button_pio.clk
            periph_rst_in.out_reset button_pio.reset"
}

connect "   periph_rst_in.out_reset pb_cpu_0.reset
"
#periph_rst_in.out_reset ILC.reset_n

if {$dfl_rom_en == 1} {
connect "   periph_clk.out_clk dfl_rom_inst.clk
            periph_rst_in.out_reset dfl_rom_inst.clk_reset"
connect_map "  pb_cpu_0.m0 dfl_rom_inst.intel_axi4lite_subordinate 0x0 "
}

# exported interfaces

export periph_rst_in in_reset reset
export periph_clk in_clk clk
export ssgdma_0 host_clk ssgdma_host_clk
export ssgdma_0 host_aresetn ssgdma_host_aresetn
export ssgdma_0 host ssgdma_host
export ssgdma_0 interrupt ssgdma_interrupt
export ssgdma_0 h2d0_mm_clk ssgdma_h2d0_mm_clk
export ssgdma_0 h2d0_mm_resetn ssgdma_h2d0_mm_resetn
export ssgdma_0 h2d0 ssgdma_h2d0


if {$fpga_button_pio_width >0} {
export button_pio external_connection button_pio_external_connection
export button_pio irq button_pio_irq
}
if {$fpga_dipsw_pio_width >0} {
export dipsw_pio external_connection dipsw_pio_external_connection
export dipsw_pio irq dipsw_pio_irq
}
#export ILC irq ILC_irq
if {$fpga_led_pio_width >0} {
export led_pio external_connection led_pio_external_connection
}
export pb_cpu_0 s0 pb_cpu_0_s0

# interconnect requirements
set_domain_assignment {$system} {qsys_mm.clockCrossingAdapter} {AUTO}
set_domain_assignment {$system} {qsys_mm.maxAdditionalLatency} {1}
set_domain_assignment {$system} {qsys_mm.enableEccProtection} {FALSE}
set_domain_assignment {$system} {qsys_mm.insertDefaultSlave} {FALSE}
    
sync_sysinfo_parameters 
    
save_system ${subsys_name}.qsys
