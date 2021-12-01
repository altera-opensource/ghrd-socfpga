#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2015-2020 Intel Corporation.
#
#****************************************************************************
#
# This script construct sub system of Display Port for higher level integration
# The GHRD create_ghrd_qsys.tcl will call each of those subsystem construct script
# automatically based on the corresponding parameter argument defined
#
# --- alternatively, input arguments could be passed in to select other FPGA variant. 
#     sub_qsys_dp      : <name your subsystem qsys>,
#     devicefamily     : <FPGA device family>,
#     device           : <FPGA device part number>
#     frame_buffer     : 1 or 0
#     pr_dp_mix_enable : 1 or 0
#
# example command to execute this script file separately
#   qsys-script --script=create_ghrd_qsys.tcl --cmd="set sub_qsys_dp subsys_dp"
#
#****************************************************************************

source ./design_config.tcl

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
    
if { ![ info exists sub_qsys_dp ] } {
  set sub_qsys_dp subsys_dp
} else {
  puts "-- Accepted parameter \$sub_qsys_dp = $sub_qsys_dp"
}

if { ![ info exists frame_buffer ] } {
  set frame_buffer $ADD_FRAME_BUFFER
} else {
  puts "-- Accepted parameter \$frame_buffer = $frame_buffer"
}

if { ![ info exists pr_dp_mix_enable ] } {
  set pr_dp_mix_enable $PARTIAL_RECONFIGURATION_DISP_PORT_MIX_ENABLE
} else {
  puts "-- Accepted parameter \$pr_dp_mix_enable = $pr_dp_mix_enable"
}


if {$pr_dp_mix_enable == 1} {
source ./construct_subsys_mixer.tcl
reload_ip_catalog
}

package require -exact qsys 17.1

create_system $sub_qsys_dp

set_project_property DEVICE_FAMILY $devicefamily
set_project_property DEVICE $device

if {$frame_buffer == 1} {
#TBD, to verify again why color plane = 3 not working on display
# set_instance_parameter_value frame_buf {NUMBER_OF_COLOR_PLANES} {3}
add_component_param "alt_vip_cl_vfb frame_buf 
                     IP_FILE_PATH ip/$sub_qsys_dp/frame_buf.ip
                     NUMBER_OF_COLOR_PLANES 4
                     MAX_WIDTH 1280
                     MAX_HEIGHT 720
                     CLOCKS_ARE_SEPARATE 0
                     MEM_PORT_WIDTH 128
                     MEM_BUFFER_OFFSET 16777216
                     BURST_ALIGNMENT 1
                     WRITE_FIFO_DEPTH 256
                     WRITE_BURST_TARGET 64
                     READ_FIFO_DEPTH 256
                     READ_BURST_TARGET 64
                     READER_RUNTIME_CONTROL 1
                     IS_FRAME_READER 1
                     DROP_FRAMES 1
                     REPEAT_FRAMES 1
                     DROP_INVALID_FIELDS 1
                     MULTI_FRAME_DELAY 1
                     MAX_SYMBOLS_PER_PACKET 10"
} else {
if {$pr_dp_mix_enable == 0} {
add_component_param "alt_vip_cl_tpg tpg_0 
                     IP_FILE_PATH ip/$sub_qsys_dp/tpg_0.ip
                     MAX_WIDTH 1280
                     MAX_HEIGHT 720
                     OUTPUT_FORMAT {4.4.4}
                     INTERLACING PROGRESSIVE
                     PATTERN_0 colorbars"
}
}

add_component_param "altera_dp bitec_dp_0 
                     IP_FILE_PATH ip/$sub_qsys_dp/bitec_dp_0.ip
                     TX_MAX_LINK_RATE 20
                     TX_MAX_LANE_COUNT 4
                     TX_SUPPORT_ANALOG_RECONFIG 1
                     TX_AUX_DEBUG 1
                     TX_SYMBOLS_PER_CLOCK 4
                     TX_SUPPORT_DP 1
                     TX_SUPPORT_AUTOMATED_TEST 1
                     TX_MAX_NUM_OF_STREAMS 1
                     RX_SUPPORT_DP 0
                     SELECT_SUPPORTED_VARIANT 5"
if {$pr_dp_mix_enable == 1} {
set_component_param "bitec_dp_0 
                    TX_VIDEO_BPS 10 
                    TX_PIXELS_PER_CLOCK 2"
} else {
set_component_param "bitec_dp_0 
                    TX_VIDEO_BPS 8  
                    TX_PIXELS_PER_CLOCK 1"
}

add_component_param "altera_avalon_fifo aux_fifo 
                     IP_FILE_PATH ip/$sub_qsys_dp/aux_fifo.ip
                     bitsPerSymbol 32
                     channelWidth 1
                     errorWidth 1
                     fifoDepth 2048
                     fifoInputInterfaceOptions AVALONST_SINK
                     fifoOutputInterfaceOptions AVALONMM_READ
                     singleClockMode 1
                     symbolsPerBeat 1
                     usePacket 1
                     useWriteControl 1"

add_component_param "altera_iopll video_pll 
                     IP_FILE_PATH ip/$sub_qsys_dp/video_pll.ip
                     gui_reference_clock_frequency 270.0
                     gui_use_locked 1
                     gui_operation_mode normal
                     gui_output_clock_frequency0 74.25
                     gui_output_clock_frequency1 16.0
                     gui_output_clock_frequency2 50.0"
if {$pr_dp_mix_enable == 1} {
set_component_param "video_pll  
                    gui_number_of_clocks 3"
} else {
set_component_param "video_pll  
                    gui_number_of_clocks 4  
                    gui_output_clock_frequency3 148.5"
}

add_component_param "altera_clock_bridge dp_clk_100 
                     IP_FILE_PATH ip/$sub_qsys_dp/dp_clk_100.ip
                     EXPLICIT_CLOCK_RATE 100000000.0
                     NUM_CLOCK_OUTPUTS 1"

add_component_param "altera_clock_bridge clk_16 
                     IP_FILE_PATH ip/$sub_qsys_dp/clk_16.ip
                     EXPLICIT_CLOCK_RATE 16000000.0
                     NUM_CLOCK_OUTPUTS 1"

add_component_param "altera_clock_bridge clk_vip 
                     IP_FILE_PATH ip/$sub_qsys_dp/clk_vip.ip
                     EXPLICIT_CLOCK_RATE 74250000.0
                     NUM_CLOCK_OUTPUTS 1"

add_component_param "altera_nios2_gen2 cpu 
                     IP_FILE_PATH ip/$sub_qsys_dp/cpu.ip
                     impl Tiny"                  
if {$pr_dp_mix_enable == 1} {   
set_component_param "cpu    
                    resetSlave mixer_0.onchip_mem.s1    
                    exceptionSlave mixer_0.onchip_mem.s1"
} else {
set_component_param "cpu    
                    resetSlave onchip_mem.s1    
                    exceptionSlave onchip_mem.s1"
}

add_component_param "alt_vip_cl_cvo cvo 
                     IP_FILE_PATH ip/$sub_qsys_dp/cvo.ip
                     COLOUR_PLANES_ARE_IN_PARALLEL 1
                     CLOCKS_ARE_SAME 0"

if {$frame_buffer == 1} {
set_component_param "cvo    
                    NUMBER_OF_COLOUR_PLANES 4"
} else {
set_component_param "cvo    
                    NUMBER_OF_COLOUR_PLANES 3"
}
if {$pr_dp_mix_enable == 1} {
set_component_param "cvo    
                    BPS 10  
                    PIXELS_IN_PARALLEL 2    
                    H_ACTIVE_PIXELS 1920    
                    V_ACTIVE_LINES 1080 
                    FIFO_DEPTH 1920 
                    THRESHOLD 1919  
                    GENERATE_SYNC 0 
                    H_SYNC_LENGTH 44    
                    H_FRONT_PORCH 88    
                    H_BACK_PORCH 148    
                    V_SYNC_LENGTH 5 
                    V_FRONT_PORCH 4 
                    V_BACK_PORCH 36"
} else {
set_component_param "cvo    
                    BPS 8   
                    PIXELS_IN_PARALLEL 1    
                    H_ACTIVE_PIXELS 1280    
                    V_ACTIVE_LINES 720  
                    FIFO_DEPTH 1280 
                    THRESHOLD 1279  
                    GENERATE_SYNC 0 
                    H_SYNC_LENGTH 40    
                    H_FRONT_PORCH 110   
                    H_BACK_PORCH 220    
                    V_SYNC_LENGTH 5 
                    V_FRONT_PORCH 5 
                    V_BACK_PORCH 20"
}

add_component_param "altera_avalon_jtag_uart jtag_uart 
                     IP_FILE_PATH ip/$sub_qsys_dp/jtag_uart.ip
                     readBufferDepth 1024
                     readIRQThreshold 1
                     writeBufferDepth 1024
                     writeIRQThreshold 1"
                     
add_component_param "altera_avalon_pio pio_0 
                     IP_FILE_PATH ip/$sub_qsys_dp/pio_0.ip
                     direction Input
                     width 1"

add_component_param "altera_reset_bridge dp_rst_bdg 
                     IP_FILE_PATH ip/$sub_qsys_dp/dp_rst_bdg.ip
                     ACTIVE_LOW_RESET 1
                     SYNCHRONOUS_EDGES deassert
                     NUM_RESET_OUTPUTS 1
                     USE_RESET_REQUEST 0"

add_component_param "altera_avalon_timer sys_timer 
                     IP_FILE_PATH ip/$sub_qsys_dp/sys_timer.ip
                     periodUnits USEC"

add_component_param "altera_xcvr_fpll_a10 fpll_0 
                     IP_FILE_PATH ip/$sub_qsys_dp/fpll_0.ip
                     enable_pll_reconfig 1
                     rcfg_sv_file_enable 1
                     rcfg_mif_file_enable 1
                     generate_docs 1
                     gui_bw_sel medium
                     gui_desired_refclk_frequency 270.0
                     gui_hssi_output_clock_frequency 2700.0
                     enable_mcgb 1
                     enable_bonding_clks 1
                     pma_width 20"

add_component_param "altera_xcvr_native_a10 a10_xcvr 
                     IP_FILE_PATH ip/$sub_qsys_dp/a10_xcvr.ip
                     duplex_mode tx
                     channels 4
                     set_data_rate 5400
                     enable_simple_interface 1
                     set_enable_calibration 1"
##TBD##
#update bonding mode to PMA_PCS according to PE char report,
#bonding master always need to set to lowest channel 
#3 here equivalent channel 0 on the a10 soc kit
######
set_component_param "a10_xcvr   
                    bonded_mode pma_only    
                    enable_port_tx_analog_reset_ack 1   
                    number_physical_bonding_clocks 1    
                    std_pcs_pma_width 20    
                    std_tx_byte_ser_mode {Serialize x2} 
                    std_tx_polinv_enable 1  
                    enable_port_tx_polinv 1 
                    set_capability_reg_enable 1 
                    set_csr_soft_logic_enable 1 
                    set_prbs_soft_logic_enable 1    
                    generate_docs 1 
                    rcfg_enable 1   
                    rcfg_shared 1   
                    rcfg_sv_file_enable 1   
                    rcfg_h_file_enable 1    
                    rcfg_mif_file_enable 1"

add_component_param "altera_xcvr_reset_control dp_xcvr_ctrl 
                     IP_FILE_PATH ip/$sub_qsys_dp/dp_xcvr_ctrl.ip
                     CHANNELS 4
                     SYS_CLK_IN_MHZ 100
                     SYNCHRONIZE_RESET 1
                     TX_PLL_ENABLE 1
                     TX_ENABLE 1
                     T_TX_ANALOGRESET 70000
                     T_TX_DIGITALRESET 70000
                     T_PLL_LOCK_HYST 20
                     RX_ENABLE 0"

add_component_param "altera_avalon_pio xdash 
                     IP_FILE_PATH ip/$sub_qsys_dp/xdash.ip
                     direction Output
                     width 32"

add_component_param "altera_avalon_mm_bridge pb_dp 
                     IP_FILE_PATH ip/$sub_qsys_dp/pb_dp.ip
                     DATA_WIDTH 32
                     ADDRESS_WIDTH 11
                     USE_AUTO_ADDRESS_WIDTH 1
                     MAX_BURST_SIZE 1
                     MAX_PENDING_RESPONSES 1"

if {$pr_dp_mix_enable == 1} {   
if {$pr_persona == 1} { 
add_instance mixer_0 subsys_mixer_pr_persona
} else {
add_instance mixer_0 subsys_mixer_pr
}   
add_component_param "alt_vip_cl_tpg tpg_0 
                     IP_FILE_PATH ip/$sub_qsys_dp/tpg_0.ip
                     BITS_PER_SYMBOL 10
                     NUMBER_OF_COLOR_PLANES 2
                     PIXELS_IN_PARALLEL 2
                     MAX_WIDTH 1920
                     MAX_HEIGHT 1080
                     OUTPUT_FORMAT {4.4.4}
                     INTERLACING PROGRESSIVE
                     PATTERN_0 colorbars"

add_component_param "altera_avlst_pr_freeze_bridge st_bdg_0 
                     IP_FILE_PATH ip/$sub_qsys_dp/st_bdg_0.ip
                     Interface_Type {Avalon-ST Sink}
                     sink_bridge_signal_Enable {No No Yes Yes Yes Yes}
                     SINK_BRIDGE_DATABIT_PERSYMBOL 10
                     SINK_BRIDGE_SYMBOLS_PERBEAT 6
                     SINK_BRIDGE_READY_LATENCY 1
                     SINK_BRIDGE_MAX_CHANNEL 0"

add_component_param "altera_avlst_pr_freeze_bridge altera_avlst_pr_freeze_bridge 
                     IP_FILE_PATH ip/$sub_qsys_dp/altera_avlst_pr_freeze_bridge.ip
                     Interface_Type {Avalon-ST Source}
                     source_bridge_signal_Enable {No No Yes Yes Yes Yes}
                     SOURCE_BRIDGE_DATABIT_PERSYMBOL 10
                     SOURCE_BRIDGE_SYMBOLS_PERBEAT 6
                     SOURCE_BRIDGE_READY_LATENCY 1
                     SOURCE_BRIDGE_MAX_CHANNEL 0"

add_component_param "altera_avlmm_pr_freeze_bridge frz_bdg_0 
                     IP_FILE_PATH ip/$sub_qsys_dp/frz_bdg_0.ip
                     Interface_Type {Avalon-MM Slave}
                     slv_bridge_signal_Enable {Yes No Yes Yes Yes Yes Yes Yes Yes Yes Yes No No No}
                     SLV_BRIDGE_ADDR_WIDTH 22
                     SLV_BRIDGE_BURSTCOUNT_WIDTH 1
                     SLV_BRIDGE_BURST_LINEWRAP 0
                     SLV_BRIDGE_BURST_BNDR_ONLY 1
                     SLV_BRIDGE_MAX_PENDING_READS 1
                     SLV_BRIDGE_MAX_PENDING_WRITES 0"

add_component_param "altera_reset_bridge pr_rst_bg 
                     IP_FILE_PATH ip/$sub_qsys_dp/pr_rst_bg.ip
                     ACTIVE_LOW_RESET 0
                     SYNCHRONOUS_EDGES deassert
                     NUM_RESET_OUTPUTS 1
                     USE_RESET_REQUEST 0"
} else {
add_component_param "altera_avalon_onchip_memory2 onchip_mem 
                     IP_FILE_PATH ip/$sub_qsys_dp/onchip_mem.ip
                     dataWidth 32
                     initializationFileName control_onchip_mem
                     memorySize 90000.0
                     useNonDefaultInitFile 1"
}

# connections and connection parameters
add_connection cpu.data_master jtag_uart.avalon_jtag_slave 
set_connection_parameter_value cpu.data_master/jtag_uart.avalon_jtag_slave arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/jtag_uart.avalon_jtag_slave baseAddress {0x01042a80}
set_connection_parameter_value cpu.data_master/jtag_uart.avalon_jtag_slave defaultConnection {0}

add_connection cpu.data_master cpu.debug_mem_slave 
set_connection_parameter_value cpu.data_master/cpu.debug_mem_slave arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/cpu.debug_mem_slave baseAddress {0x01042000}
set_connection_parameter_value cpu.data_master/cpu.debug_mem_slave defaultConnection {0}

add_connection cpu.data_master sys_timer.s1 
set_connection_parameter_value cpu.data_master/sys_timer.s1 arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/sys_timer.s1 baseAddress {0x01042800}
set_connection_parameter_value cpu.data_master/sys_timer.s1 defaultConnection {0}

add_connection cpu.data_master xdash.s1 
set_connection_parameter_value cpu.data_master/xdash.s1 arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/xdash.s1 baseAddress {0x01042980}
set_connection_parameter_value cpu.data_master/xdash.s1 defaultConnection {0}

add_connection cpu.data_master pio_0.s1 
set_connection_parameter_value cpu.data_master/pio_0.s1 arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/pio_0.s1 baseAddress {0x01042900}
set_connection_parameter_value cpu.data_master/pio_0.s1 defaultConnection {0}

add_connection cpu.data_master bitec_dp_0.tx_mgmt 
set_connection_parameter_value cpu.data_master/bitec_dp_0.tx_mgmt arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/bitec_dp_0.tx_mgmt baseAddress {0x0000}
set_connection_parameter_value cpu.data_master/bitec_dp_0.tx_mgmt defaultConnection {0}

add_connection cpu.instruction_master cpu.debug_mem_slave 
set_connection_parameter_value cpu.instruction_master/cpu.debug_mem_slave arbitrationPriority {1}
set_connection_parameter_value cpu.instruction_master/cpu.debug_mem_slave baseAddress {0x01042000}
set_connection_parameter_value cpu.instruction_master/cpu.debug_mem_slave defaultConnection {0}

add_connection cpu.data_master aux_fifo.in_csr 
set_connection_parameter_value cpu.data_master/aux_fifo.in_csr arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/aux_fifo.in_csr baseAddress {0x00200000}
set_connection_parameter_value cpu.data_master/aux_fifo.in_csr defaultConnection {0}

add_connection cpu.data_master aux_fifo.out 
set_connection_parameter_value cpu.data_master/aux_fifo.out arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/aux_fifo.out baseAddress {0x00200020}
set_connection_parameter_value cpu.data_master/aux_fifo.out defaultConnection {0}

add_connection pb_dp.m0 bitec_dp_0.tx_mgmt 
set_connection_parameter_value pb_dp.m0/bitec_dp_0.tx_mgmt arbitrationPriority {1}
set_connection_parameter_value pb_dp.m0/bitec_dp_0.tx_mgmt baseAddress {0x0000}
set_connection_parameter_value pb_dp.m0/bitec_dp_0.tx_mgmt defaultConnection {0}

if {$pr_dp_mix_enable == 1} {   
add_connection frz_bdg_0.slv_bridge_to_pr mixer_0.pr_mm_bdg_s0
set_connection_parameter_value frz_bdg_0.slv_bridge_to_pr/mixer_0.pr_mm_bdg_s0 arbitrationPriority {1}
set_connection_parameter_value frz_bdg_0.slv_bridge_to_pr/mixer_0.pr_mm_bdg_s0 baseAddress {0x0000}
set_connection_parameter_value frz_bdg_0.slv_bridge_to_pr/mixer_0.pr_mm_bdg_s0 defaultConnection {0}

add_connection cpu.instruction_master/frz_bdg_0.slv_bridge_to_sr
set_connection_parameter_value cpu.instruction_master/frz_bdg_0.slv_bridge_to_sr arbitrationPriority {1}
set_connection_parameter_value cpu.instruction_master/frz_bdg_0.slv_bridge_to_sr baseAddress {0x00400000}
set_connection_parameter_value cpu.instruction_master/frz_bdg_0.slv_bridge_to_sr defaultConnection {0}

add_connection cpu.data_master frz_bdg_0.slv_bridge_to_sr
set_connection_parameter_value cpu.data_master/frz_bdg_0.slv_bridge_to_sr arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/frz_bdg_0.slv_bridge_to_sr baseAddress {0x00400000}
set_connection_parameter_value cpu.data_master/frz_bdg_0.slv_bridge_to_sr defaultConnection {0}

add_connection tpg_0.dout st_bdg_0.sink_bridge_to_sr

add_connection st_bdg_0.sink_bridge_to_pr mixer_0.st_adpt_in_pr

add_connection mixer_0.st_adpt_out_pr st_bdg_1.source_bridge_to_pr

add_connection st_bdg_1.source_bridge_to_sr cvo.din

add_connection dp_clk_100.out_clk frz_bdg_0.clock   

add_connection dp_clk_100.out_clk mixer_0.clk

add_connection dp_clk_100.out_clk pr_rst_bg.clk 

add_connection clk_vip.out_clk mixer_0.clock_bridge_0_vid_in    

add_connection clk_vip.out_clk tpg_0.main_clock 

add_connection clk_vip.out_clk st_bdg_1.clock

add_connection clk_vip.out_clk st_bdg_0.clock   

add_connection cpu.debug_reset_request mixer_0.reset

add_connection cpu.debug_reset_request tpg_0.main_reset

add_connection dp_rst_bdg.out_reset frz_bdg_0.reset_n

add_connection dp_rst_bdg.out_reset mixer_0.reset

add_connection dp_rst_bdg.out_reset tpg_0.main_reset

add_connection dp_rst_bdg.out_reset st_bdg_0.reset_n

add_connection dp_rst_bdg.out_reset st_bdg_1.reset_n

add_connection pr_rst_bg.out_reset cpu.reset 

add_connection pr_rst_bg.out_reset bitec_dp_0.aux_reset 

add_connection pr_rst_bg.out_reset cvo.main_reset

add_connection pr_rst_bg.out_reset fpll_0.reconfig_reset0

add_connection pr_rst_bg.out_reset a10_xcvr.reconfig_reset_ch0 

add_connection pr_rst_bg.out_reset jtag_uart.reset 

add_connection pr_rst_bg.out_reset sys_timer.reset 

add_connection pr_rst_bg.out_reset xdash.reset 

add_connection pr_rst_bg.out_reset pio_0.reset 

add_connection pr_rst_bg.out_reset bitec_dp_0.reset 
    
add_connection pr_rst_bg.out_reset pb_dp.reset 

add_connection pr_rst_bg.out_reset aux_fifo.reset_in 

add_connection pr_rst_bg.out_reset mixer_0.reset

add_connection pr_rst_bg.out_reset tpg_0.main_reset
} else {
add_connection cpu.data_master onchip_mem.s1 
set_connection_parameter_value cpu.data_master/onchip_mem.s1 arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/onchip_mem.s1 baseAddress {0x01020000}
set_connection_parameter_value cpu.data_master/onchip_mem.s1 defaultConnection {0}

add_connection cpu.instruction_master onchip_mem.s1 
set_connection_parameter_value cpu.instruction_master/onchip_mem.s1 arbitrationPriority {1}
set_connection_parameter_value cpu.instruction_master/onchip_mem.s1 baseAddress {0x01020000}
set_connection_parameter_value cpu.instruction_master/onchip_mem.s1 defaultConnection {0}

add_connection dp_clk_100.out_clk onchip_mem.clk1 

add_connection cpu.debug_reset_request onchip_mem.reset1 

add_connection dp_rst_bdg.out_reset onchip_mem.reset1 
}

add_connection clk_16.out_clk bitec_dp_0.aux_clk 

add_connection dp_clk_100.out_clk pio_0.clk 

add_connection dp_clk_100.out_clk dp_rst_bdg.clk 

add_connection dp_clk_100.out_clk xdash.clk 

add_connection dp_clk_100.out_clk sys_timer.clk 

add_connection dp_clk_100.out_clk jtag_uart.clk 

add_connection dp_clk_100.out_clk cpu.clk 

add_connection dp_clk_100.out_clk bitec_dp_0.clk 

add_connection dp_clk_100.out_clk dp_xcvr_ctrl.clock 

add_connection clk_vip.out_clk cvo.main_clock

add_connection dp_clk_100.out_clk fpll_0.reconfig_clk0

add_connection dp_clk_100.out_clk a10_xcvr.reconfig_clk_ch0 

add_connection dp_clk_100.out_clk bitec_dp_0.xcvr_mgmt_clk 

add_connection clk_16.out_clk aux_fifo.clk_in 

add_connection dp_clk_100.out_clk pb_dp.clk 

add_connection dp_xcvr_ctrl.pll_powerdown fpll_0.pll_powerdown
set_connection_parameter_value dp_xcvr_ctrl.pll_powerdown/fpll_0.pll_powerdown endPort {}
set_connection_parameter_value dp_xcvr_ctrl.pll_powerdown/fpll_0.pll_powerdown endPortLSB {0}
set_connection_parameter_value dp_xcvr_ctrl.pll_powerdown/fpll_0.pll_powerdown startPort {}
set_connection_parameter_value dp_xcvr_ctrl.pll_powerdown/fpll_0.pll_powerdown startPortLSB {0}
set_connection_parameter_value dp_xcvr_ctrl.pll_powerdown/fpll_0.pll_powerdown width {0}

add_connection fpll_0.tx_bonding_clocks a10_xcvr.tx_bonding_clocks_ch0

add_connection fpll_0.tx_bonding_clocks a10_xcvr.tx_bonding_clocks_ch1

add_connection fpll_0.tx_bonding_clocks a10_xcvr.tx_bonding_clocks_ch2

add_connection fpll_0.tx_bonding_clocks a10_xcvr.tx_bonding_clocks_ch3

add_connection cpu.irq jtag_uart.irq 
set_connection_parameter_value cpu.irq/jtag_uart.irq irqNumber {0}

add_connection cpu.irq sys_timer.irq 
set_connection_parameter_value cpu.irq/sys_timer.irq irqNumber {2}

add_connection cpu.irq bitec_dp_0.tx_mgmt_interrupt 
set_connection_parameter_value cpu.irq/bitec_dp_0.tx_mgmt_interrupt irqNumber {1}

add_connection cpu.irq aux_fifo.in_irq
set_connection_parameter_value cpu.irq/aux_fifo.in_irq irqNumber {4}

add_connection cpu.debug_reset_request bitec_dp_0.aux_reset 

add_connection cpu.debug_reset_request cvo.main_reset

add_connection cpu.debug_reset_request fpll_0.reconfig_reset0

add_connection cpu.debug_reset_request a10_xcvr.reconfig_reset_ch0 

add_connection cpu.debug_reset_request cpu.reset 

add_connection cpu.debug_reset_request jtag_uart.reset 

add_connection cpu.debug_reset_request sys_timer.reset 

add_connection cpu.debug_reset_request xdash.reset 

add_connection cpu.debug_reset_request pio_0.reset 

add_connection cpu.debug_reset_request bitec_dp_0.reset 
    
add_connection cpu.debug_reset_request pb_dp.reset 

add_connection cpu.debug_reset_request aux_fifo.reset_in 

add_connection dp_rst_bdg.out_reset bitec_dp_0.aux_reset 

add_connection dp_rst_bdg.out_reset cvo.main_reset 

add_connection dp_rst_bdg.out_reset fpll_0.reconfig_reset0

add_connection dp_rst_bdg.out_reset a10_xcvr.reconfig_reset_ch0 

add_connection dp_rst_bdg.out_reset cpu.reset 

add_connection dp_rst_bdg.out_reset jtag_uart.reset 

add_connection dp_rst_bdg.out_reset sys_timer.reset 

add_connection dp_rst_bdg.out_reset bitec_dp_0.reset 

add_connection dp_rst_bdg.out_reset xdash.reset 

add_connection dp_rst_bdg.out_reset pio_0.reset 

add_connection dp_rst_bdg.out_reset video_pll.reset 

add_connection dp_rst_bdg.out_reset aux_fifo.reset_in 

add_connection dp_rst_bdg.out_reset pb_dp.reset 

add_connection bitec_dp_0.tx_aux_debug aux_fifo.in 

if {$frame_buffer == 1} {
add_connection frame_buf.dout cvo.din

add_connection clk_vip.out_clk frame_buf.main_clock 

add_connection cpu.debug_reset_request frame_buf.main_reset

add_connection dp_rst_bdg.out_reset frame_buf.main_reset
} else {
if {$pr_dp_mix_enable == 0} {   
add_connection clk_vip.out_clk tpg_0.main_clock

add_connection tpg_0.dout cvo.din

add_connection cpu.debug_reset_request tpg_0.main_reset

add_connection dp_rst_bdg.out_reset tpg_0.main_reset
}
}

# exported interfaces

if {$pr_dp_mix_enable == 1} {
add_interface frz_bdg_0_freeze_conduit conduit end
set_interface_property frz_bdg_0_freeze_conduit EXPORT_OF frz_bdg_0.freeze_conduit
add_interface st_bdg_1_freeze_conduit conduit end
set_interface_property st_bdg_1_freeze_conduit EXPORT_OF st_bdg_1.freeze_conduit
add_interface st_bdg_0_freeze_conduit conduit end
set_interface_property st_bdg_0_freeze_conduit EXPORT_OF st_bdg_0.freeze_conduit
add_interface mixer_0_onchip_mem_freeze_interface conduit end
set_interface_property mixer_0_onchip_mem_freeze_interface EXPORT_OF mixer_0.onchip_mem_freeze_interface
add_interface pr_reset reset sink
set_interface_property pr_reset EXPORT_OF pr_rst_bg.in_reset
} else {
add_interface video_pll_outclk3 clock source
set_interface_property video_pll_outclk3 EXPORT_OF video_pll.outclk3
}   
if {$frame_buffer == 1} {
add_interface alt_vip_cl_vfb_0_control avalon slave
set_interface_property alt_vip_cl_vfb_0_control EXPORT_OF frame_buf.control
add_interface alt_vip_cl_vfb_0_control_interrupt interrupt sender
set_interface_property alt_vip_cl_vfb_0_control_interrupt EXPORT_OF frame_buf.control_interrupt
add_interface alt_vip_cl_vfb_0_mem_master_rd avalon master
set_interface_property alt_vip_cl_vfb_0_mem_master_rd EXPORT_OF frame_buf.mem_master_rd
}
add_interface pb_dp_s0 avalon slave
set_interface_property pb_dp_s0 EXPORT_OF pb_dp.s0
add_interface video_pll_refclk clock sink
set_interface_property video_pll_refclk EXPORT_OF video_pll.refclk
add_interface video_pll_locked conduit end
set_interface_property video_pll_locked EXPORT_OF video_pll.locked
add_interface video_pll_outclk0 clock source
set_interface_property video_pll_outclk0 EXPORT_OF video_pll.outclk0
add_interface video_pll_outclk1 clock source
set_interface_property video_pll_outclk1 EXPORT_OF video_pll.outclk1
add_interface video_pll_outclk2 clock source
set_interface_property video_pll_outclk2 EXPORT_OF video_pll.outclk2
add_interface bitec_dp_0_clk_cal clock sink
set_interface_property bitec_dp_0_clk_cal EXPORT_OF bitec_dp_0.clk_cal
add_interface bitec_dp_0_tx conduit end
set_interface_property bitec_dp_0_tx EXPORT_OF bitec_dp_0.tx_xcvr_interface
add_interface bitec_dp_0_tx0_video_in conduit end
set_interface_property bitec_dp_0_tx0_video_in EXPORT_OF bitec_dp_0.tx_video_in
add_interface bitec_dp_0_tx0_video_in_1 clock sink
set_interface_property bitec_dp_0_tx0_video_in_1 EXPORT_OF bitec_dp_0.tx_vid_clk
add_interface bitec_dp_0_tx_analog_reconfig conduit end
set_interface_property bitec_dp_0_tx_analog_reconfig EXPORT_OF bitec_dp_0.tx_analog_reconfig
add_interface bitec_dp_0_tx_aux conduit end
set_interface_property bitec_dp_0_tx_aux EXPORT_OF bitec_dp_0.tx_aux
add_interface bitec_dp_0_tx_reconfig conduit end
set_interface_property bitec_dp_0_tx_reconfig EXPORT_OF bitec_dp_0.tx_reconfig
add_interface clk_100 clock sink
set_interface_property clk_100 EXPORT_OF dp_clk_100.in_clk
add_interface clk_16 clock sink
set_interface_property clk_16 EXPORT_OF clk_16.in_clk
add_interface clk_vip clock sink
set_interface_property clk_vip EXPORT_OF clk_vip.in_clk
add_interface cvo_clocked_video conduit end
set_interface_property cvo_clocked_video EXPORT_OF cvo.clocked_video
add_interface pio_0_external_connection conduit end
set_interface_property pio_0_external_connection EXPORT_OF pio_0.external_connection
add_interface resetn reset sink
set_interface_property resetn EXPORT_OF dp_rst_bdg.in_reset
add_interface fpll_0_mcgb_rst conduit end
set_interface_property fpll_0_mcgb_rst EXPORT_OF fpll_0.mcgb_rst
add_interface fpll_0_pll_cal_busy conduit end
set_interface_property fpll_0_pll_cal_busy EXPORT_OF fpll_0.pll_cal_busy
add_interface fpll_0_pll_locked conduit end
set_interface_property fpll_0_pll_locked EXPORT_OF fpll_0.pll_locked
add_interface fpll_0_pll_refclk0 clock sink
set_interface_property fpll_0_pll_refclk0 EXPORT_OF fpll_0.pll_refclk0
add_interface fpll_0_reconfig_avmm0 avalon slave
set_interface_property fpll_0_reconfig_avmm0 EXPORT_OF fpll_0.reconfig_avmm0
add_interface fpll_0_tx_serial_clk hssi_serial_clock source
set_interface_property fpll_0_tx_serial_clk EXPORT_OF fpll_0.tx_serial_clk
add_interface a10_xcvr_reconfig_avmm_ch0 avalon slave
set_interface_property a10_xcvr_reconfig_avmm_ch0 EXPORT_OF a10_xcvr.reconfig_avmm_ch0
for {set i 0} {$i<4} {incr i} {
add_interface a10_xcvr_tx_analogreset_ack_ch${i} conduit end
set_interface_property a10_xcvr_tx_analogreset_ack_ch${i} EXPORT_OF a10_xcvr.tx_analogreset_ack_ch${i}
add_interface a10_xcvr_tx_analogreset_ch${i} conduit end
set_interface_property a10_xcvr_tx_analogreset_ch${i} EXPORT_OF a10_xcvr.tx_analogreset_ch${i}
add_interface a10_xcvr_tx_cal_busy_ch${i} conduit end
set_interface_property a10_xcvr_tx_cal_busy_ch${i} EXPORT_OF a10_xcvr.tx_cal_busy_ch${i}
add_interface a10_xcvr_tx_clkout_ch${i} clock source
set_interface_property a10_xcvr_tx_clkout_ch${i} EXPORT_OF a10_xcvr.tx_clkout_ch${i}
add_interface a10_xcvr_tx_coreclkin_ch${i} clock sink
set_interface_property a10_xcvr_tx_coreclkin_ch${i} EXPORT_OF a10_xcvr.tx_coreclkin_ch${i}
add_interface a10_xcvr_tx_digitalreset_ch${i} conduit end
set_interface_property a10_xcvr_tx_digitalreset_ch${i} EXPORT_OF a10_xcvr.tx_digitalreset_ch${i}
add_interface a10_xcvr_tx_parallel_data_ch${i} conduit end
set_interface_property a10_xcvr_tx_parallel_data_ch${i} EXPORT_OF a10_xcvr.tx_parallel_data_ch${i}
add_interface a10_xcvr_tx_polinv_ch${i} conduit end
set_interface_property a10_xcvr_tx_polinv_ch${i} EXPORT_OF a10_xcvr.tx_polinv_ch${i}
add_interface a10_xcvr_tx_serial_data_ch${i} conduit end
set_interface_property a10_xcvr_tx_serial_data_ch${i} EXPORT_OF a10_xcvr.tx_serial_data_ch${i}
}
add_interface a10_xcvr_unused_tx_parallel_data conduit end
set_interface_property a10_xcvr_unused_tx_parallel_data EXPORT_OF a10_xcvr.unused_tx_parallel_data
add_interface xcvr_ctrl_pll_locked conduit end
set_interface_property xcvr_ctrl_pll_locked EXPORT_OF dp_xcvr_ctrl.pll_locked
add_interface xcvr_ctrl_pll_select conduit end
set_interface_property xcvr_ctrl_pll_select EXPORT_OF dp_xcvr_ctrl.pll_select
add_interface xcvr_ctrl_reset reset sink
set_interface_property xcvr_ctrl_reset EXPORT_OF dp_xcvr_ctrl.reset
add_interface xcvr_ctrl_tx_analogreset conduit end
set_interface_property xcvr_ctrl_tx_analogreset EXPORT_OF dp_xcvr_ctrl.tx_analogreset
add_interface xcvr_ctrl_tx_cal_busy conduit end
set_interface_property xcvr_ctrl_tx_cal_busy EXPORT_OF dp_xcvr_ctrl.tx_cal_busy
add_interface xcvr_ctrl_tx_digitalreset conduit end
set_interface_property xcvr_ctrl_tx_digitalreset EXPORT_OF dp_xcvr_ctrl.tx_digitalreset
add_interface xcvr_ctrl_tx_ready conduit end
set_interface_property xcvr_ctrl_tx_ready EXPORT_OF dp_xcvr_ctrl.tx_ready

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {AUTO}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}

sync_sysinfo_parameters
save_system ${sub_qsys_dp}.qsys

