#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2017-2020 Intel Corporation.
#
#****************************************************************************
#
# This script construct sub system of PCIe for higher level integration
# The GHRD create_ghrd_qsys.tcl will call each of those subsystem construct script
# automatically based on the corresponding parameter argument defined
#
#****************************************************************************

source ./arguments_solver.tcl
source ./utils.tcl
set sub_qsys_periph subsys_periph
  
package require -exact qsys 18.1

create_system $sub_qsys_periph

set_project_property DEVICE_FAMILY $device_family
set_project_property DEVICE $device
set_validation_property AUTOMATIC_VALIDATION false

add_component_param "altera_clock_bridge periph_clk 
                    IP_FILE_PATH ip/$sub_qsys_periph/periph_clk.ip 
                    EXPLICIT_CLOCK_RATE 100000000 
                    NUM_CLOCK_OUTPUTS 1
                    "

add_component_param "altera_reset_bridge periph_rst_in 
                    IP_FILE_PATH ip/$sub_qsys_periph/periph_rst_in.ip 
                    ACTIVE_LOW_RESET 1
                    SYNCHRONOUS_EDGES both
                    NUM_RESET_OUTPUTS 1
                    USE_RESET_REQUEST 0
                    "

if {$niosii_en == 1} {
add_component_param "altera_avalon_jtag_uart jtag_uart 
                    IP_FILE_PATH ip/$sub_qsys_periph/jtag_uart.ip 
                    readBufferDepth 64
                    readIRQThreshold 8
                    writeBufferDepth 64
                    writeIRQThreshold 8
                    "
        
add_component_param "altera_16550_uart uart_16550 
                    IP_FILE_PATH ip/$sub_qsys_periph/uart_16550.ip 
                    FIFO_DEPTH 32
                    "
                    
add_component_param "altera_s10_mailbox_client mb_client 
                    IP_FILE_PATH ip/$sub_qsys_periph/mb_client.ip 
                    "
}

add_component_param "altera_avalon_pio button_pio 
                    IP_FILE_PATH ip/$sub_qsys_periph/button_pio.ip 
                    bitClearingEdgeCapReg 1
                    captureEdge 1
                    direction Input
                    edgeType FALLING
                    generateIRQ 1
                    irqType EDGE
                    width 4
                    "

add_component_param "altera_avalon_pio dipsw_pio 
                    IP_FILE_PATH ip/$sub_qsys_periph/dipsw_pio.ip 
                    bitClearingEdgeCapReg 1
                    captureEdge 1
                    direction Input
                    edgeType FALLING
                    generateIRQ 1
                    irqType EDGE
                    width 4
                    "

add_component_param "altera_avalon_pio led_pio 
                    IP_FILE_PATH ip/$sub_qsys_periph/led_pio.ip 
                    direction InOut
                    resetValue 15.0
                    "
                    
set_component_param "led_pio
                    width 3
                    resetValue 7
"

add_component_param "interrupt_latency_counter ILC 
                    IP_FILE_PATH ip/$sub_qsys_periph/ILC.ip 
                    INTR_TYPE 0
                    IRQ_PORT_CNT 2
                    "   
               
if {$pr_enable == 1} {
if {$pr_region_count == 2} {
set_component_param "ILC
                    IRQ_PORT_CNT 4"
} else {
set_component_param "ILC
                    IRQ_PORT_CNT 3"
}
} else {
set_component_param "ILC
                    IRQ_PORT_CNT 2"
}

add_component_param "altera_avalon_mm_bridge pb_cpu_0 
                    IP_FILE_PATH ip/$sub_qsys_periph/pb_cpu_0.ip 
                    DATA_WIDTH 32
                    ADDRESS_WIDTH 20
                    USE_AUTO_ADDRESS_WIDTH 1
                    MAX_BURST_SIZE 1
                    MAX_PENDING_RESPONSES 1
                    "                           

# connections and connection parameters
if {$niosii_en == 1} {
connect_map "   pb_cpu_0.m0 jtag_uart.avalon_jtag_slave 0x0010
"

connect_map "   pb_cpu_0.m0 uart_16550.avalon_slave 0x0200
"

connect_map "   pb_cpu_0.m0 mb_client.avmm 0x0400
"
}

connect_map "   pb_cpu_0.m0 ILC.avalon_slave 0x0100
"

connect_map "   pb_cpu_0.m0 led_pio.s1 0x0080
"

connect_map "   pb_cpu_0.m0 dipsw_pio.s1 0x0070
"

connect_map "   pb_cpu_0.m0 button_pio.s1 0x0060
"

if {$niosii_en == 1} {
connect "   periph_clk.out_clk jtag_uart.clk
            periph_clk.out_clk uart_16550.clock
            periph_clk.out_clk mb_client.in_clk
"
}

connect "   periph_clk.out_clk pb_cpu_0.clk
            periph_clk.out_clk periph_rst_in.clk
            periph_clk.out_clk ILC.clk
            periph_clk.out_clk led_pio.clk
            periph_clk.out_clk dipsw_pio.clk
            periph_clk.out_clk button_pio.clk
"

if {$niosii_en == 1} {
connect "   periph_rst_in.out_reset jtag_uart.reset
            periph_rst_in.out_reset uart_16550.reset_sink
            periph_rst_in.out_reset mb_client.in_reset
"
}

connect "   periph_rst_in.out_reset pb_cpu_0.reset
            periph_rst_in.out_reset led_pio.reset
            periph_rst_in.out_reset dipsw_pio.reset
            periph_rst_in.out_reset button_pio.reset
            periph_rst_in.out_reset ILC.reset_n
"

# exported interfaces
if {$niosii_en == 1} {
export uart_16550 RS_232_Modem uart_16550_RS_232_Modem
export uart_16550 RS_232_Serial uart_16550_RS_232_Serial
export uart_16550 irq_sender uart_16550_irq_sender
export jtag_uart irq jtag_uart_irq
export mb_client irq mb_client_irq
}

export periph_rst_in in_reset reset
export periph_clk in_clk clk
export button_pio external_connection button_pio_external_connection
export button_pio irq button_pio_irq
export dipsw_pio external_connection dipsw_pio_external_connection
export dipsw_pio irq dipsw_pio_irq
export ILC irq ILC_irq
export led_pio external_connection led_pio_external_connection
export pb_cpu_0 s0 pb_cpu_0_s0

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {AUTO}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
    
sync_sysinfo_parameters 
    
save_system ${sub_qsys_periph}.qsys
