#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2017-2020 Intel Corporation.
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

# if {$board == "devkit"} {
# source ./pin_assignment_table_devkit.tcl
# global pin_assignment_table_devkit
# }

# if {$board == "pe"} {
# source ./pin_assignment_table_pe.tcl
# global pin_assignment_table_pe
# }

# set variant_id [expr [expr $c2p_early_revb_off<<18] + [expr $hps_en<<17] + [expr $niosii_en<<16] + [expr $hps_emif_en<<15] + [expr $fpga_emif_en<<14] + [expr $hps_emif_ecc_en<<13] + [expr $fpga_emif_ecc_en<<12] + [expr $h2f_user_clk_en<<11] + [expr $h2f_f2h_loopback_en<<10] + [expr $lwh2f_f2h_loopback_en<<9] + [expr $h2f_f2sdram0_loopback_en<<8] + [expr $h2f_f2sdram1_loopback_en<<7] + [expr $h2f_f2sdram2_loopback_en<<6] + [expr $gpio_loopback_en<<5] + [expr $hps_peri_irq_loopback_en<<4] + [expr $cross_trigger_en<<3] + [expr $hps_stm_en<<2] + [expr $ftrace_en<<1] + $fpga_peripheral_en]
# puts "VARIANT: [format %8.4x $variant_id]"
# set SYSID [expr 0x${board_rev}000000 + $variant_id]
# set SYSID $variant_id
# puts "SYSID  : [format %8.8x $variant_id]"
set SYSID "0xACD5CAFE"

package require -exact qsys 18.1

if {$fpga_peripheral_en == 1} {
source ./construct_subsys_peripheral.tcl
reload_ip_catalog
}

if {$board == "devkit" || $board == "atso12" || $board == "ashfield" || $board == "klamath"} {
source ./construct_subsys_jtag_master.tcl
reload_ip_catalog
}

if {$fpga_pcie == 1} {
source ./construct_subsys_pcie.tcl
reload_ip_catalog
}

if {$hps_mge_en == 1} {
source ./construct_subsys_mge.tcl
reload_ip_catalog
}

if {$hps_mge_10gbe_1588_en == 1} {
source ./construct_subsys_mge_10gbe_1588_dma.tcl
source ./construct_subsys_mge_10gbe_1588_ctrl.tcl
source ./construct_ip_alt_mge_10gbe_1588.tcl
reload_ip_catalog
set subsys_10gbe_name "ip_alt_mge_10gbe_1588"
}

if {$pr_enable == 1} {
for {set k 0} {$k<$pr_region_count} {incr k} {
if {$k == 0} {
set sub_qsys_pr "${pr_region_name}_0"
set pr_region_id_switch 0
source ./construct_subsys_pr_region.tcl
reload_ip_catalog
} else {
set sub_qsys_pr "${pr_region_name}_1"
set pr_region_id_switch 1
source ./construct_subsys_pr_region.tcl
reload_ip_catalog
}
}
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

if {$clk_gate_en == 1} {
add_component_param "stratix10_clkctrl clkctrl_0
                    IP_FILE_PATH ip/$qsys_name/clkctrl_0.ip 
                    NUM_CLOCKS 1
                    ENABLE 1
                    ENABLE_REGISTER_TYPE 1
                    ENABLE_TYPE 1
                    "
}

add_component_param "altera_in_system_sources_probes src_prb_rst
                    IP_FILE_PATH ip/$qsys_name/src_prb_rst.ip 
                    create_source_clock 1
                    probe_width 0
                    source_initial_value 1
                    source_width 1
                    "
                    
add_component_param "altera_avalon_sysid_qsys sysid
                    IP_FILE_PATH ip/$qsys_name/sysid.ip 
                    id $SYSID
                    "

if {$board == "devkit" || $board == "atso12" || $board == "ashfield" || $board == "klamath"} {
add_instance jtg_mst subsys_jtg_mst

add_component_param "altera_avalon_onchip_memory2 ocm
                    IP_FILE_PATH ip/$qsys_name/ocm.ip 
                    dataWidth 256
                    memorySize 262144.0
                    slave1Latency 3
                    singleClockOperation 1
                    "
                    
add_component_param "altera_avalon_mm_bridge fpga_m2ocm_pb
                    IP_FILE_PATH ip/$qsys_name/fpga_m2ocm_pb.ip 
                    DATA_WIDTH 128
                    ADDRESS_WIDTH 18
                    USE_AUTO_ADDRESS_WIDTH 1
                    "
               
if {($fpga_pcie == 1 && $pcie_f2h == 1) || $hps_mge_10gbe_1588_en == 1} {
add_component_param "altera_address_span_extender ext_hps_m_master 
                     IP_FILE_PATH ip/$qsys_name/ext_hps_m_master.ip
                     BURSTCOUNT_WIDTH 1
                     MASTER_ADDRESS_WIDTH 33
                     SLAVE_ADDRESS_WIDTH 30
                     ENABLE_SLAVE_PORT 0
                     MAX_PENDING_READS 1"
}
}

if {$fpga_peripheral_en == 1} {
add_instance periph subsys_periph
}

if {$hps_mge_en == 1} {
add_instance hps_mge subsys_mge

add_component_param "altera_clock_bridge enet_refclk
               IP_FILE_PATH ip/$qsys_name/enet_refclk.ip 
               EXPLICIT_CLOCK_RATE 125000000 
               NUM_CLOCK_OUTPUTS 1
               "
               
add_component_param "altera_avalon_pio mge_led_pio 
               IP_FILE_PATH ip/$sub_qsys_periph/mge_led_pio.ip 
               captureEdge 1
               direction Input
               edgeType FALLING
               generateIRQ 0
               width [expr {$sgmii_count * 5 +3}] 
               "
               
add_component_param "altera_avalon_pio mge_rcfg_pio 
               IP_FILE_PATH ip/$sub_qsys_periph/mge_rcfg_pio.ip 
               captureEdge 1
               direction Input
               edgeType FALLING
               generateIRQ 0
               width 4
               "
}

if {$acp_adapter_en == 1} {
    if {$f2h_width > 0} {
    add_component_param "s10_axi_bridge_for_acp_128 axi_bridge_for_acp_0
                    IP_FILE_PATH ip/$qsys_name/axi_bridge_for_acp_0.ip
                    CSR_EN $acp_adapter_csr_en
                    GPIO_EN $acp_adapter_gpio_en
                    ADDR_WIDTH $f2h_addr_width
                    "
    }
}

if {$hps_mge_10gbe_1588_en == 1} {
add_component_param "altera_clock_bridge mge_10gbe_clk_156p25
                     IP_FILE_PATH ip/$subsys_10gbe_name/mge_10gbe_clk_156p25.ip 
                     EXPLICIT_CLOCK_RATE 156250000 
                     NUM_CLOCK_OUTPUTS 1
                     "

add_component_param "altera_clock_bridge mge_refclk_csr
                     IP_FILE_PATH ip/$subsys_10gbe_name/mge_refclk_csr.ip 
                     EXPLICIT_CLOCK_RATE 125000000 
                     NUM_CLOCK_OUTPUTS 1
                     "

add_component_param "altera_clock_bridge mge_refclk_csr_out
                     IP_FILE_PATH ip/$subsys_10gbe_name/mge_refclk_csr_out.ip 
                     EXPLICIT_CLOCK_RATE 125000000 
                     NUM_CLOCK_OUTPUTS 1
                     "

add_component_param "altera_reset_bridge mge_reset_csr_out
                     IP_FILE_PATH ip/$subsys_10gbe_name/mge_reset_csr_out.ip 
                     ACTIVE_LOW_RESET 0
                     SYNCHRONOUS_EDGES both
                     NUM_RESET_OUTPUTS 1
                     USE_RESET_REQUEST 0
                     "
                     
add_component_param "altera_avalon_mm_bridge mge_csr
                     IP_FILE_PATH ip/$subsys_10gbe_name/mge_csr.ip 
                     DATA_WIDTH 32
                     ADDRESS_WIDTH 17
                     USE_AUTO_ADDRESS_WIDTH 0
                     MAX_BURST_SIZE 1
                     MAX_PENDING_RESPONSES 1
                     "

add_instance mge_10gbe_1588_dma  subsys_mge_10gbe_1588_dma
add_instance mge_10gbe_1588_ctrl subsys_mge_10gbe_1588_ctrl

add_component_param "altera_avalon_mm_bridge mge_dma_mm_bridge
                     IP_FILE_PATH ip/$subsys_10gbe_name/mge_dma_mm_bridge.ip
                     ADDRESS_UNITS {SYMBOLS}
                     ADDRESS_WIDTH {33}
                     DATA_WIDTH {128}
                     LINEWRAPBURSTS {0}
                     MAX_BURST_SIZE {64}
                     MAX_PENDING_RESPONSES {4}
                     MAX_PENDING_WRITES {4}
                     PIPELINE_COMMAND {1}
                     PIPELINE_RESPONSE {1}
                     SYMBOL_WIDTH {8}
                     SYNC_RESET {0}
                     USE_AUTO_ADDRESS_WIDTH {0}
                     USE_RESPONSE {1}
                     USE_WRITERESPONSE {1}
                     "
}
        
# instantiate PCIe subsystem
if {$fpga_pcie == 1} {
add_instance pcie_0 subsys_pcie

add_component_param "altera_reset_bridge pcie_rst_bg
                    IP_FILE_PATH ip/$qsys_name/pcie_rst_bg.ip 
                    ACTIVE_LOW_RESET 1
                    SYNCHRONOUS_EDGES both
                    NUM_RESET_OUTPUTS 1
                    USE_RESET_REQUEST 0
                    "
               
add_component_param "altera_avalon_pio pcie_link_stat_pio 
               IP_FILE_PATH ip/$sub_qsys_periph/pcie_link_stat_pio.ip 
               captureEdge 1
               direction Input
               edgeType FALLING
               generateIRQ 0
               width 14
               "
}

# instantiate PR subsystem
if {$pr_enable == 1} {
for {set k 0} {$k<$pr_region_count} {incr k} {
add_component_param "altera_pr_region_controller frz_ctrl_${k} 
                     IP_FILE_PATH ip/$qsys_name/frz_ctrl_${k}.ip    
                    ENABLE_CSR 1
                    NUM_INTF_BRIDGE 1"

add_instance pr_region_${k} pr_region_${k}

add_component_param "altera_avlmm_pr_freeze_bridge frz_bdg_${k} 
                     IP_FILE_PATH ip/$qsys_name/frz_bdg_${k}.ip 
                    Interface_Type {Avalon-MM Slave}
                    slv_bridge_signal_Enable {Yes No Yes Yes Yes Yes Yes Yes Yes Yes Yes No No No}
                    SLV_BRIDGE_ADDR_WIDTH 10
                    SLV_BRIDGE_BURSTCOUNT_WIDTH 1
                    SLV_BRIDGE_BURST_LINEWRAP 0
                    SLV_BRIDGE_BURST_BNDR_ONLY 1
                    SLV_BRIDGE_MAX_PENDING_READS 1
                    SLV_BRIDGE_MAX_PENDING_WRITES 0"
}


if {$freeze_ack_dly_enable == 1} {
add_component_param "altera_iopll iopll_0 
                     IP_FILE_PATH ip/$qsys_name/iopll_0.ip  
                    gui_reference_clock_frequency 250.0
                    gui_use_locked 1
                    gui_operation_mode direct
                    gui_number_of_clocks 2
                    gui_output_clock_frequency0 220.0
                    gui_output_clock_frequency1 125.0"

}

if {$pr_ip_enable == 1} {
add_component_param "alt_pr pr_ip 
                     IP_FILE_PATH ip/$qsys_name/pr_ip.ip    
                    PR_INTERNAL_HOST 1
                    ENABLE_JTAG 0
                    ENABLE_AVMM_SLAVE 1
                    ENABLE_INTERRUPT 0
                    DATA_WIDTH_INDEX 32
                    CDRATIO 1
                    EDCRC_OSC_DIVIDER 2"
}

}
        
if {$hps_en == 1} {
#setup HPS and HPS EMIF
source ./construct_hps.tcl
}

if {$niosii_en == 1} {
#setup NiosII and FPGA EMIF
source ./construct_niosii.tcl
}

# --------------- Connections and connection parameters ------------------#
connect "   clk_100.out_clk src_prb_rst.source_clk
"

connect "   clk_100.out_clk sysid.clk
            rst_in.out_reset sysid.reset
"

if {$board == "devkit" || $board == "atso12" || $board == "ashfield" || $board == "klamath"} {
connect "   clk_100.out_clk jtg_mst.clk
            rst_in.out_reset jtg_mst.reset
            clk_100.out_clk ocm.clk1
            rst_in.out_reset ocm.reset1 
            clk_100.out_clk fpga_m2ocm_pb.clk
            rst_in.out_reset fpga_m2ocm_pb.reset
"

connect_map "   jtg_mst.fpga_m_master fpga_m2ocm_pb.s0 0x40000"

connect_map "   fpga_m2ocm_pb.m0 ocm.s1 0x0"    

connect_map "   jtg_mst.fpga_m_master sysid.control_slave 0x0"

if {$fpga_peripheral_en == 1} {
connect_map "   jtg_mst.fpga_m_master periph.pb_cpu_0_s0 0x1000"
}

if {($fpga_pcie == 1 && $pcie_f2h == 1) || $hps_mge_10gbe_1588_en == 1} {
connect "clk_100.out_clk            ext_hps_m_master.clock
         rst_in.out_reset           ext_hps_m_master.reset"

connect_map "jtg_mst.hps_m_master   ext_hps_m_master.windowed_slave 0x0"
}
}

if {$fpga_peripheral_en == 1} {
connect "clk_100.out_clk periph.clk
         rst_in.out_reset periph.reset
         periph.ILC_irq periph.button_pio_irq
         periph.ILC_irq periph.dipsw_pio_irq"

set_connection_parameter_value periph.ILC_irq/periph.button_pio_irq irqNumber {1}
set_connection_parameter_value periph.ILC_irq/periph.dipsw_pio_irq irqNumber {0}
}

if {$acp_adapter_en == 1} {
    if {$f2h_width > 0} {
        connect "rst_in.out_reset                   axi_bridge_for_acp_0.reset
                 clk_100.out_clk                    axi_bridge_for_acp_0.csr_clock
                 rst_in.out_reset                   axi_bridge_for_acp_0.csr_reset"
        if {$fpga_pcie == 1} {
            connect "pcie_0.coreclkout_out          axi_bridge_for_acp_0.clock"
        } elseif {$hps_mge_10gbe_1588_en == 1} {
            connect "mge_10gbe_clk_156p25.out_clk   axi_bridge_for_acp_0.clock"
        }

        connect_map "jtg_mst.fpga_m_master          axi_bridge_for_acp_0.csr 0x210
                     s10_hps.h2f_lw_axi_master      axi_bridge_for_acp_0.csr 0x210
                    "
    }
}

# PCIe subsystem
if {$fpga_pcie == 1} {
connect "clk_100.out_clk           pcie_0.clk
         rst_in.out_reset          pcie_rst_bg.in_reset
         pcie_0.coreclkout_out     pcie_rst_bg.clk
         s10_hps.f2h_irq0          pcie_0.msi2gic_interrupt
         s10_hps.f2h_irq0          pcie_0.pcie_hip_cra_irq
         pcie_rst_bg.out_reset     pcie_0.reset
         clk_100.out_clk           pcie_link_stat_pio.clk
         rst_in.out_reset          pcie_link_stat_pio.reset
       "

set_connection_parameter_value s10_hps.f2h_irq0/pcie_0.msi2gic_interrupt irqNumber {2}
set_connection_parameter_value s10_hps.f2h_irq0/pcie_0.pcie_hip_cra_irq irqNumber {3}

connect_map "pcie_0.pb_2_ocm_m0 ocm.s1 0x0"

connect_map "jtg_mst.fpga_m_master pcie_0.hip_reconfig 0x20000000"

connect_map "jtg_mst.fpga_m_master pcie_0.pb_lwh2f_pcie 0x00010000"

connect_map "jtg_mst.fpga_m_master pcie_link_stat_pio.s1 0x200"

# connect_map "jtg_mst.fpga_m_master pcie_0.txs_ccb 0x10000000"
if {$pcie_hptxs == 1} {
connect_map "jtg_mst.fpga_m_master pcie_0.hptxs 0x10000000"
} else {
connect_map "jtg_mst.fpga_m_master pcie_0.txs 0x10000000"
}

if {$pcie_f2h == 1} {
connect_map "pcie_0.ext_expanded_master            axi_bridge_for_acp_0.s0 0x0
             pcie_0.ext_expanded_master_upper2GB   axi_bridge_for_acp_0.s0 0x0"
}
}

if {$hps_mge_en == 1} {
connect    "rst_in.out_reset     hps_mge.reset_125m
            enet_refclk.out_clk  hps_mge.enet_refclk                                            
            enet_refclk.out_clk  mge_led_pio.clk                                            
            rst_in.out_reset     mge_led_pio.reset                                            
            enet_refclk.out_clk  mge_rcfg_pio.clk                                            
            rst_in.out_reset     mge_rcfg_pio.reset                                            
            "

for {set x 1} {$x<=$sgmii_count} {incr x} {
set selected_mac [lindex ${hps_mge_mac} [expr {${x}-1}]]
connect     "hps_mge.emac${x} s10_hps.emac${selected_mac}
             s10_hps.emac${selected_mac}_gtx_clk hps_mge.emac${x}_gtx_clk
             hps_mge.emac${x}_rx_clk_in s10_hps.emac${selected_mac}_rx_clk_in
             s10_hps.emac${selected_mac}_rx_reset hps_mge.emac${x}_rx_reset
             hps_mge.emac${x}_tx_clk_in s10_hps.emac${selected_mac}_tx_clk_in
             s10_hps.emac${selected_mac}_tx_reset hps_mge.emac${x}_tx_reset
             "
}

connect_map "jtg_mst.fpga_m_master     hps_mge.pb_s   0x3000
             s10_hps.h2f_lw_axi_master hps_mge.pb_s   0x3000
             jtg_mst.fpga_m_master     mge_led_pio.s1 0x100
             s10_hps.h2f_lw_axi_master mge_led_pio.s1 0x100
             jtg_mst.fpga_m_master     mge_rcfg_pio.s1 0x110
             s10_hps.h2f_lw_axi_master mge_rcfg_pio.s1 0x110
             "
             
connect     "clk_100.out_clk  s10_hps.emac_ptp_ref_clock
            "
}

if {$hps_mge_10gbe_1588_en == 1} {
connect "mge_refclk_csr.out_clk                 mge_refclk_csr_out.in_clk
         mge_refclk_csr.out_clk                 mge_reset_csr_out.clk
         rst_in.out_reset                       mge_reset_csr_out.in_reset
         mge_refclk_csr.out_clk                 mge_csr.clk
         rst_in.out_reset                       mge_csr.reset
         mge_10gbe_clk_156p25.out_clk           mge_dma_mm_bridge.clk
         rst_in.out_reset                       mge_dma_mm_bridge.reset
         "
         
connect "mge_10gbe_clk_156p25.out_clk           mge_10gbe_1588_dma.clk
         rst_in.out_reset                       mge_10gbe_1588_dma.reset
         mge_10gbe_clk_156p25.out_clk           mge_10gbe_1588_ctrl.clk
         rst_in.out_reset                       mge_10gbe_1588_ctrl.reset
         "

connect_map "jtg_mst.fpga_m_master     mge_csr.s0              0x20000
             s10_hps.h2f_lw_axi_master mge_csr.s0              0x20000
             "

connect_map "jtg_mst.fpga_m_master        mge_10gbe_1588_ctrl.csr    0x300
             s10_hps.h2f_lw_axi_master    mge_10gbe_1588_ctrl.csr    0x300
             jtg_mst.fpga_m_master        mge_10gbe_1588_dma.csr     0x2000
             s10_hps.h2f_lw_axi_master    mge_10gbe_1588_dma.csr     0x2000
             "
for {set x 1} {$x<=$hps_mge_10gbe_1588_count} {incr x} {
connect_map "mge_10gbe_1588_dma.tx_dma_ch${x}_prefetcher_read_master     mge_dma_mm_bridge.s0    0x0000
             mge_10gbe_1588_dma.tx_dma_ch${x}_prefetcher_write_master    mge_dma_mm_bridge.s0    0x0000
             mge_10gbe_1588_dma.tx_dma_ch${x}_read_master                mge_dma_mm_bridge.s0    0x0000
             mge_10gbe_1588_dma.rx_dma_ch${x}_prefetcher_read_master     mge_dma_mm_bridge.s0    0x0000
             mge_10gbe_1588_dma.rx_dma_ch${x}_prefetcher_write_master    mge_dma_mm_bridge.s0    0x0000
             mge_10gbe_1588_dma.rx_dma_ch${x}_write_master               mge_dma_mm_bridge.s0    0x0000
             mge_dma_mm_bridge.m0                                        axi_bridge_for_acp_0.s0 0x0000
             "
}
}

if {$pr_enable == 1} {
for {set k 0} {$k<$pr_region_count} {incr k} {
set frz_ctrl_offset [format 0x%x [expr [expr 0x10*$k]+0x450]] 
set frz_bdg_offset [format 0x%x [expr [expr 0x400*$k]+0x800]] 
connect_map "s10_hps.h2f_lw_axi_master       frz_ctrl_${k}.avl_csr            $frz_ctrl_offset
             s10_hps.h2f_lw_axi_master       frz_bdg_${k}.slv_bridge_to_sr    $frz_bdg_offset
             frz_bdg_${k}.slv_bridge_to_pr   pr_region_${k}.pr_mm_bridge_0_s0 0x0000
            "

if {$freeze_ack_dly_enable == 0} {
connect     "frz_ctrl_${k}.bridge_freeze0    frz_bdg_${k}.freeze_conduit
            "
}

connect     "clk_100.out_clk     pr_region_${k}.clk
             clk_100.out_clk     frz_bdg_${k}.clock
             clk_100.out_clk     frz_ctrl_${k}.clock

             rst_in.out_reset    pr_region_${k}.reset
             rst_in.out_reset    frz_bdg_${k}.reset_n
            
             frz_ctrl_${k}.reset_source pr_region_${k}.reset
            
             rst_in.out_reset frz_ctrl_${k}.reset
            "
            
set frz_ctrl_int [expr 11+$k]
connect     "periph.ILC_irq      frz_ctrl_${k}.interrupt_sender
             s10_hps.f2h_irq0    frz_ctrl_${k}.interrupt_sender
            "
#set_connection_parameter_value periph.ILC_irq/frz_ctrl_${k}.interrupt_sender irqNumber $frz_ctrl_int
set_connection_parameter_value s10_hps.f2h_irq0/frz_ctrl_${k}.interrupt_sender irqNumber $frz_ctrl_int
}

if {$freeze_ack_dly_enable == 1} {
connect_map "s10_hps.h2f_lw_axi_master      start_ack_pio.s1     0x1800
             s10_hps.h2f_lw_axi_master      stop_ack_pio.s1      0x1810
            "

connect     "clk_100.out_clk     start_ack_pio.clk
             clk_100.out_clk     stop_ack_pio.clk
             rst_in.out_reset    stop_ack_pio.reset 
             rst_in.out_reset    start_ack_pio.reset
            "
}
}


####################################
#                exported interfaces
export src_prb_rst sources src_prb_rst_sources

export clk_100 in_clk clk_100
export rst_in in_reset reset
export user_rst_clkgate_0 ninit_done ninit_done
if {$clk_gate_en == 1} {
export clkctrl_0 clkctrl_input clkctrl_input
export clkctrl_0 clkctrl_output clkctrl_output
}

if {$fpga_peripheral_en == 1} {
export periph button_pio_external_connection button_pio_external_connection
export periph dipsw_pio_external_connection dipsw_pio_external_connection
export periph led_pio_external_connection led_pio_external_connection

if {$niosii_en == 1} {
export periph uart_16550_RS_232_Modem uart_16550_RS_232_Modem
export periph uart_16550_RS_232_Serial uart_16550_RS_232_Serial
}
}

# MGE SGMII
if {$hps_mge_en == 1} {
export enet_refclk   in_clk               enet_refclk
export hps_mge       mge_rcfg_reset_sink  mge_rcfg_reset_sink
export mge_led_pio   external_connection  mge_led_pio
export mge_rcfg_pio  external_connection  mge_rcfg_pio
export hps_mge       enet_iopll_locked    enet_iopll_locked
export hps_mge       mge_rcfg_status      mge_rcfg_status

for {set x 1} {$x<=$sgmii_count} {incr x} {
set selected_mac [lindex ${hps_mge_mac} [expr {${x}-1}]]
export s10_hps emac${selected_mac}_md_clk emac${x}_mdc

export hps_mge emac${x}_mdio                 emac${x}_mdio
export hps_mge emac${x}_ptp                  emac${x}_ptp
export hps_mge mge_phy${x}_led_an            emac${x}_led_an
export hps_mge mge_phy${x}_led_char_err      emac${x}_led_char_err
export hps_mge mge_phy${x}_led_disp_err      emac${x}_led_disp_err
export hps_mge mge_phy${x}_led_link          emac${x}_led_link
export hps_mge mge_phy${x}_led_panel_link    emac${x}_led_panel_link
export hps_mge mge_phy${x}_rx_serial_data    emac${x}_rx_serial_data
export hps_mge mge_phy${x}_tx_serial_data    emac${x}_tx_serial_data
export hps_mge mge_phy${x}_tx_serial_clk     emac${x}_mge_tx_serial_clk
export hps_mge xcvr_reset_${x}_pll_locked    xcvr_reset_${x}_pll_locked
export hps_mge xcvr_reset_${x}_tx_ready      xcvr_reset_${x}_tx_ready
export hps_mge xcvr_reset_${x}_rx_ready      xcvr_reset_${x}_rx_ready
export hps_mge gmii_adapter${x}_pll_locked   gmii_adapter${x}_pll_locked
}

export hps_mge fpll_1G_mcgb_serial_clk       fpll_1G_mcgb_serial_clk
export hps_mge fpll_1G_pll_locked            fpll_1G_pll_locked
}

# PCIe subsystem
if {$fpga_pcie == 1} {
export pcie_0 pcie_hip_refclk pcie_hip_refclk

export pcie_0 pcie_hip_currentspeed pcie_hip_currentspeed

export pcie_0 pcie_hip_ctrl pcie_hip_ctrl

export pcie_0 pcie_hip_pipe pcie_hip_pipe

export pcie_0 pcie_hip_serial pcie_hip_serial

export pcie_0 pcie_hip_status pcie_hip_status

export pcie_0 pcie_hip_npor pcie_hip_npor

export pcie_link_stat_pio   external_connection  pcie_link_stat_pio
}

if {$hps_mge_10gbe_1588_en == 1} {
export mge_refclk_csr         in_clk              mge_refclk_csr
export mge_refclk_csr_out     out_clk             mge_refclk_csr_out
export mge_reset_csr_out      out_reset           mge_reset_csr_out
export mge_10gbe_clk_156p25   in_clk              mge_10gbe_clk_156p25
export mge_csr                m0                  mge_csr

for {set x 1} {$x<=$hps_mge_10gbe_1588_count} {incr x} {
export mge_10gbe_1588_dma      mge_tx_dma_ch${x}_pktout           mge_tx_dma_ch${x}_pktout
export mge_10gbe_1588_dma      mge_tx_dma_ch${x}_timestamp        mge_tx_dma_ch${x}_timestamp
export mge_10gbe_1588_dma      mge_tx_dma_ch${x}_timestamp_req    mge_tx_dma_ch${x}_timestamp_req
export mge_10gbe_1588_dma      mge_rx_dma_ch${x}_pktin            mge_rx_dma_ch${x}_pktin
export mge_10gbe_1588_dma      mge_rx_dma_ch${x}_timestamp        mge_rx_dma_ch${x}_timestamp
export mge_10gbe_1588_dma      mge_rx_dma_ch${x}_pause_control    mge_rx_dma_ch${x}_pause_control
}

export mge_10gbe_1588_ctrl     sfp_control_pio                    sfp_control_pio
export mge_10gbe_1588_ctrl     mge_10gbe_status_pio               mge_10gbe_status_pio
export mge_10gbe_1588_ctrl     mge_10gbe_debug_status_pio         mge_10gbe_debug_status_pio
export mge_10gbe_1588_ctrl     mge_10gbe_mac_link_status_pio      mge_10gbe_mac_link_status_pio
export mge_10gbe_1588_ctrl     mge_10gbe_tod_start_sync_ctrl_pio  mge_10gbe_tod_start_sync_ctrl_pio
}

# PR subsystem
if {$pr_enable == 1} {
for {set k 0} {$k<$pr_region_count} {incr k} {
export frz_ctrl_${k} pr_handshake frz_ctrl_${k}_pr_handshake
}
if {$freeze_ack_dly_enable == 1} {
export start_ack_pio external_connection  start_ack_pio_external_connection
export stop_ack_pio  external_connection  stop_ack_pio_external_connection
for {set k 0} {$k<$pr_region_count} {incr k} {
export frz_bdg_${k}     freeze_conduit    frz_bdg_${k}_freeze_conduit
export frz_ctrl_${k}    bridge_freeze0    frz_ctrl_${k}_bridge_freeze0
}
}
}

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {AUTO}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
set_interconnect_requirement {$system} qsys_mm.burstAdapterImplementation {PER_BURST_TYPE_CONVERTER}

if {$fpga_pcie == 1} {
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {4}
#set_interconnect_requirement {mm_interconnect_0|cmd_demux_001.src0/cmd_mux.sink1} qsys_mm.postTransform.pipelineCount {1}
#set_interconnect_requirement {mm_interconnect_0|cmd_demux_001.src1/cmd_mux_001.sink1} qsys_mm.postTransform.pipelineCount {1}
#set_interconnect_requirement {mm_interconnect_0|cmd_demux_002.src0/cmd_mux.sink2} qsys_mm.postTransform.pipelineCount {1}
#set_interconnect_requirement {mm_interconnect_0|cmd_demux_002.src1/cmd_mux_001.sink2} qsys_mm.postTransform.pipelineCount {1}
#set_interconnect_requirement {mm_interconnect_0|pcie_0_ext_expanded_master_agent.cp/router_001.sink} qsys_mm.postTransform.pipelineCount {1}
#set_interconnect_requirement {mm_interconnect_0|pcie_0_ext_expanded_master_limiter.rsp_src/pcie_0_ext_expanded_master_agent.rp} qsys_mm.postTransform.pipelineCount {1}
#set_interconnect_requirement {mm_interconnect_0|pcie_0_ext_expanded_master_upper2GB_agent.cp/router_002.sink} qsys_mm.postTransform.pipelineCount {1}
#set_interconnect_requirement {mm_interconnect_0|pcie_0_ext_expanded_master_upper2GB_limiter.rsp_src/pcie_0_ext_expanded_master_upper2GB_agent.rp} qsys_mm.postTransform.pipelineCount {1}
#set_interconnect_requirement {mm_interconnect_0|rsp_demux.src0/crosser_002.in} qsys_mm.postTransform.pipelineCount {1}
#set_interconnect_requirement {mm_interconnect_0|rsp_demux.src1/rsp_mux_001.sink0} qsys_mm.postTransform.pipelineCount {1}
#set_interconnect_requirement {mm_interconnect_0|rsp_demux.src2/rsp_mux_002.sink0} qsys_mm.postTransform.pipelineCount {1}
#set_interconnect_requirement {mm_interconnect_0|rsp_demux_001.src0/crosser_003.in} qsys_mm.postTransform.pipelineCount {1}
#set_interconnect_requirement {mm_interconnect_0|rsp_demux_001.src1/rsp_mux_001.sink1} qsys_mm.postTransform.pipelineCount {1}
#set_interconnect_requirement {mm_interconnect_0|rsp_demux_001.src2/rsp_mux_002.sink1} qsys_mm.postTransform.pipelineCount {1}
}

sync_sysinfo_parameters 
save_system ${qsys_name}.qsys
sync_sysinfo_parameters 
