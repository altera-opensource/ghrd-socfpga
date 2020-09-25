#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2016-2020 Intel Corporation.
#
#****************************************************************************
#
# This script construct sub system of PCIe for higher level integration
# The GHRD create_ghrd_qsys.tcl will call each of those subsystem construct script
# automatically based on the corresponding parameter argument defined
#
# --- alternatively, input arguments could be passed in to select other FPGA variant. 
#     sub_qsys_periph    : <name your subqsys name>,
#     devicefamily : <FPGA device family>,
#     device       : <FPGA device part number>
# example command to execute this script file
#   qsys-script --script=construct_subsys_peripheral.tcl --cmd="set sub_qsys_periph qsys_periph"
#
#****************************************************************************

if {[ file exists ./design_config.tcl ]} {
  source ./design_config.tcl
}
    
if { ![ info exists devicefamily ] } {
  set devicefamily $DEVICE_FAMILY
} else {
  puts "-- Accepted parameter \$devicefamily = $devicefamily"
}
    
if { ![ info exists device ] } {
  set device $FPGA_DEVICE
} else {
  puts "-- Accepted parameter \$device = $device"
}

if { ![ info exists niosii_en ] } {
  set niosii_en $NIOSII_EN
} else {
  puts "-- Accepted parameter \$niosii_en = $niosii_en"
}

if { ![ info exists sub_qsys_periph ] } {
  set sub_qsys_periph subsys_periph
} else {
  puts "-- Accepted parameter \$sub_qsys_periph = $sub_qsys_periph"
}

package require -exact qsys 17.1


create_system $sub_qsys_periph

set_project_property DEVICE_FAMILY $devicefamily
set_project_property DEVICE $device
set_validation_property AUTOMATIC_VALIDATION false

add_component_param "altera_clock_bridge periph_clk 
                     IP_FILE_PATH ip/$sub_qsys_periph/periph_clk.ip
                     EXPLICIT_CLOCK_RATE 100000000.0
                     NUM_CLOCK_OUTPUTS 1"

add_component_param "altera_reset_bridge periph_rst_in 
                     IP_FILE_PATH ip/$sub_qsys_periph/periph_rst_in.ip
                     ACTIVE_LOW_RESET 1
                     SYNCHRONOUS_EDGES deassert
                     NUM_RESET_OUTPUTS 1
                     USE_RESET_REQUEST 0"

if {$niosii_en == 1} {
add_component_param "altera_avalon_jtag_uart jtag_uart 
                     IP_FILE_PATH ip/$sub_qsys_periph/jtag_uart.ip
                     readBufferDepth 64
                     readIRQThreshold 8
                     writeBufferDepth 64
                     writeIRQThreshold 8"

add_component_param "altera_16550_uart uart_16550 
                     IP_FILE_PATH ip/$sub_qsys_periph/uart_16550.ip
                     FIFO_DEPTH 32"
}

add_component_param "altera_avalon_pio button_pio 
                     IP_FILE_PATH ip/$sub_qsys_periph/button_pio.ip
                     bitClearingEdgeCapReg 1
                     captureEdge 1
                     direction Input
                     edgeType FALLING
                     generateIRQ 1
                     irqType EDGE
                     width 4"

add_component_param "altera_avalon_pio dipsw_pio 
                     IP_FILE_PATH ip/$sub_qsys_periph/dipsw_pio.ip
                     bitClearingEdgeCapReg 1
                     captureEdge 1
                     direction Input
                     edgeType FALLING
                     generateIRQ 1
                     irqType EDGE
                     width 4"

add_component_param "altera_avalon_pio led_pio 
                     IP_FILE_PATH ip/$sub_qsys_periph/led_pio.ip
                     direction InOut
                     resetValue 15.0
                     width 4"

add_component_param "interrupt_latency_counter ILC 
                     IP_FILE_PATH ip/$sub_qsys_periph/ILC.ip
                     INTR_TYPE 0
                     IRQ_PORT_CNT 32"

add_component_param "altera_avalon_mm_bridge pb_cpu_0 
                     IP_FILE_PATH ip/$sub_qsys_periph/pb_cpu_0.ip
                     DATA_WIDTH 32
                     ADDRESS_WIDTH 20
                     USE_AUTO_ADDRESS_WIDTH 1
                     MAX_BURST_SIZE 1
                     MAX_PENDING_RESPONSES 1"

# connections and connection parameters
if {$niosii_en == 1} {
add_connection pb_cpu_0.m0 jtag_uart.avalon_jtag_slave
set_connection_parameter_value pb_cpu_0.m0/jtag_uart.avalon_jtag_slave arbitrationPriority {1}
set_connection_parameter_value pb_cpu_0.m0/jtag_uart.avalon_jtag_slave baseAddress {0x0010}
set_connection_parameter_value pb_cpu_0.m0/jtag_uart.avalon_jtag_slave defaultConnection {0}

add_connection pb_cpu_0.m0 uart_16550.avalon_slave
set_connection_parameter_value pb_cpu_0.m0/uart_16550.avalon_slave arbitrationPriority {1}
set_connection_parameter_value pb_cpu_0.m0/uart_16550.avalon_slave baseAddress {0x0200}
set_connection_parameter_value pb_cpu_0.m0/uart_16550.avalon_slave defaultConnection {0}
}

add_connection pb_cpu_0.m0 ILC.avalon_slave
set_connection_parameter_value pb_cpu_0.m0/ILC.avalon_slave arbitrationPriority {1}
set_connection_parameter_value pb_cpu_0.m0/ILC.avalon_slave baseAddress {0x0100}
set_connection_parameter_value pb_cpu_0.m0/ILC.avalon_slave defaultConnection {0}

add_connection pb_cpu_0.m0 led_pio.s1
set_connection_parameter_value pb_cpu_0.m0/led_pio.s1 arbitrationPriority {1}
set_connection_parameter_value pb_cpu_0.m0/led_pio.s1 baseAddress {0x0080}
set_connection_parameter_value pb_cpu_0.m0/led_pio.s1 defaultConnection {0}

add_connection pb_cpu_0.m0 dipsw_pio.s1
set_connection_parameter_value pb_cpu_0.m0/dipsw_pio.s1 arbitrationPriority {1}
set_connection_parameter_value pb_cpu_0.m0/dipsw_pio.s1 baseAddress {0x0070}
set_connection_parameter_value pb_cpu_0.m0/dipsw_pio.s1 defaultConnection {0}

add_connection pb_cpu_0.m0 button_pio.s1
set_connection_parameter_value pb_cpu_0.m0/button_pio.s1 arbitrationPriority {1}
set_connection_parameter_value pb_cpu_0.m0/button_pio.s1 baseAddress {0x0060}
set_connection_parameter_value pb_cpu_0.m0/button_pio.s1 defaultConnection {0}

if {$niosii_en == 1} {
add_connection periph_clk.out_clk jtag_uart.clk

add_connection periph_clk.out_clk uart_16550.clock

}
add_connection periph_clk.out_clk periph_rst_in.clk

add_connection periph_clk.out_clk pb_cpu_0.clk

add_connection periph_clk.out_clk ILC.clk

add_connection periph_clk.out_clk led_pio.clk

add_connection periph_clk.out_clk dipsw_pio.clk

add_connection periph_clk.out_clk button_pio.clk

if {$niosii_en == 1} {
add_connection periph_rst_in.out_reset jtag_uart.reset

add_connection periph_rst_in.out_reset uart_16550.reset_sink
}

add_connection periph_rst_in.out_reset pb_cpu_0.reset

add_connection periph_rst_in.out_reset led_pio.reset

add_connection periph_rst_in.out_reset dipsw_pio.reset

add_connection periph_rst_in.out_reset button_pio.reset

add_connection periph_rst_in.out_reset ILC.reset_n

# exported interfaces
if {$niosii_en == 1} {
add_interface uart_16550_RS_232_Modem conduit end
set_interface_property uart_16550_RS_232_Modem EXPORT_OF uart_16550.RS_232_Modem
add_interface uart_16550_RS_232_Serial conduit end
set_interface_property uart_16550_RS_232_Serial EXPORT_OF uart_16550.RS_232_Serial
add_interface uart_16550_irq_sender interrupt sender
set_interface_property uart_16550_irq_sender EXPORT_OF uart_16550.irq_sender
add_interface jtag_uart_irq interrupt sender
set_interface_property jtag_uart_irq EXPORT_OF jtag_uart.irq
}
add_interface button_pio_external_connection conduit end
set_interface_property button_pio_external_connection EXPORT_OF button_pio.external_connection
add_interface button_pio_irq interrupt sender
set_interface_property button_pio_irq EXPORT_OF button_pio.irq
add_interface reset reset sink
set_interface_property reset EXPORT_OF periph_rst_in.in_reset
add_interface clk clock sink
set_interface_property clk EXPORT_OF periph_clk.in_clk
add_interface dipsw_pio_external_connection conduit end
set_interface_property dipsw_pio_external_connection EXPORT_OF dipsw_pio.external_connection
add_interface dipsw_pio_irq interrupt sender
set_interface_property dipsw_pio_irq EXPORT_OF dipsw_pio.irq
add_interface ILC_irq interrupt receiver
set_interface_property ILC_irq EXPORT_OF ILC.irq
add_interface led_pio_external_connection conduit end
set_interface_property led_pio_external_connection EXPORT_OF led_pio.external_connection
add_interface pb_cpu_0_s0 avalon slave
set_interface_property pb_cpu_0_s0 EXPORT_OF pb_cpu_0.s0

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {AUTO}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
    
sync_sysinfo_parameters
save_system ${sub_qsys_periph}.qsys
