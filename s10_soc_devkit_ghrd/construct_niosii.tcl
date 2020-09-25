#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2017-2020 Intel Corporation.
#
#****************************************************************************
#
# This tcl script basically contained only configuration settings for NiosII & FPGA EMIF, connections between NiosII & FPGA EMIF
# The GHRD create_ghrd_qsys.tcl will call each of those subsystem construct script
# automatically based on the corresponding parameter argument defined
#
#****************************************************************************

add_component_param "altera_nios2_gen2 cpu  
                    IP_FILE_PATH ip/$qsys_name/cpu.ip 
                    setting_activateTrace 1
                    mmu_TLBMissExcSlave tb_ram_1k.s2
                    resetSlave ocm.s1
                    dividerType srt2
                    impl Fast
                    icache_size 32768
                    icache_numTCIM 1
                    dcache_size 32768
                    dcache_numTCDM 1
"

if {$niosii_mmu_en == 1} {
set_component_param "cpu    mmu_enabled 1"
}
if {$niosii_mem == "ddr"} {
set_component_param "cpu    exceptionSlave fpga_emif.ctrl_amm_0"
} else {
set_component_param "cpu    exceptionSlave ocm.s1"
}

if {$niosii_mem == "ddr"} {
set cpu_instance cpu
source ./construct_s10_emif.tcl

add_component_param "altera_address_span_extender ext_ddr  
                    IP_FILE_PATH ip/$qsys_name/ext_ddr.ip
                    SLAVE_ADDRESS_WIDTH 25
                    BURSTCOUNT_WIDTH 7
                    MASTER_ADDRESS_WIDTH 31
                    ENABLE_SLAVE_PORT 0
                    MAX_PENDING_READS 16
"

add_component_param "altera_reset_bridge emif_rst_bdg  
                    IP_FILE_PATH ip/$qsys_name/emif_rst_bdg.ip
                    ACTIVE_LOW_RESET 1
                    SYNCHRONOUS_EDGES deassert
                    NUM_RESET_OUTPUTS 1
                    USE_RESET_REQUEST 0
"
}

add_component_param "altera_avalon_onchip_memory2 tb_ram_1k  
                    IP_FILE_PATH ip/$qsys_name/tb_ram_1k.ip
                    dualPort 1
                    memorySize 1024.0
                    singleClockOperation 1
"

add_component_param "altera_avalon_timer timer_0  
                    IP_FILE_PATH ip/$qsys_name/timer_0.ip
                    period 10
"

add_component_param "altera_avalon_timer timer_1  
                    IP_FILE_PATH ip/$qsys_name/timer_1.ip
"

# connections and connection parameters
connect_map "   cpu.data_master cpu.debug_mem_slave 0x18000800
"

connect_map "   cpu.instruction_master cpu.debug_mem_slave 0x18000800
"

connect_map "   cpu.data_master ocm.s1 0x18040000
"

connect_map "   cpu.instruction_master ocm.s1 0x18040000
"

connect_map "   cpu.tightly_coupled_data_master_0 tb_ram_1k.s1 0x0000
"

connect_map "   cpu.tightly_coupled_instruction_master_0 tb_ram_1k.s2 0x0000
"

connect_map "   cpu.data_master sysid.control_slave 0x18000020
"

connect_map "   cpu.data_master timer_1.s1 0x18000040
"

connect_map "   cpu.data_master timer_0.s1 0x18000000
"

connect "   clk_100.out_clk timer_1.clk
            clk_100.out_clk timer_0.clk
            clk_100.out_clk cpu.clk
            clk_100.out_clk tb_ram_1k.clk1
            rst_in.out_reset timer_1.reset
            rst_in.out_reset timer_0.reset
            rst_in.out_reset cpu.reset
            rst_in.out_reset tb_ram_1k.reset1
            cpu.debug_reset_request sysid.reset
            cpu.debug_reset_request timer_1.reset
            cpu.debug_reset_request timer_0.reset
            cpu.debug_reset_request cpu.reset
            cpu.debug_reset_request tb_ram_1k.reset1
            cpu.debug_reset_request ocm.reset1
            cpu.irq timer_1.irq
            cpu.irq timer_0.irq
            cpu.irq periph.uart_16550_irq_sender
            cpu.irq periph.jtag_uart_irq
            cpu.irq periph.mb_client_irq
"
set_connection_parameter_value cpu.irq/periph.uart_16550_irq_sender irqNumber {4}
set_connection_parameter_value cpu.irq/periph.jtag_uart_irq irqNumber {3}
set_connection_parameter_value cpu.irq/periph.mb_client_irq irqNumber {2}
set_connection_parameter_value cpu.irq/timer_1.irq irqNumber {1}
set_connection_parameter_value cpu.irq/timer_0.irq irqNumber {0}

if {$niosii_mem == "ddr"} {
connect_map "   cpu.instruction_master ext_ddr.windowed_slave 0x10000000
"

connect_map "   cpu.data_master ext_ddr.windowed_slave 0x10000000
"

connect_map "   ext_ddr.expanded_master fpga_emif.ctrl_amm_0 0x0000
"

connect "   clk_100.out_clk emif_rst_bdg.clk
            fpga_emif.emif_usr_clk cpu.clk
            fpga_emif.emif_usr_clk tb_ram_1k.clk1
            fpga_emif.emif_usr_clk ext_ddr.clock
            cpu.debug_reset_request ext_ddr.reset
            rst_in.out_reset ext_ddr.reset
            rst_in.out_reset emif_rst_bdg.in_reset
            fpga_emif.emif_usr_reset_n emif_rst_bdg.in_reset
            fpga_emif.emif_usr_reset_n cpu.reset
            fpga_emif.emif_usr_reset_n tb_ram_1k.reset1
            fpga_emif.emif_usr_reset_n ocm.reset1
            fpga_emif.emif_usr_reset_n ext_ddr.reset
"
}

# exported interfaces
if {$niosii_mem == "ddr"} {
export emif_rst_bdg out_reset emif_usr_reset_n
}