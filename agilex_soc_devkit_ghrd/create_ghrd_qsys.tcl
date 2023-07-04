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

# set variant_id [expr [expr $c2p_early_revb_off<<18] + [expr $hps_en<<17] + [expr $niosii_en<<16] + [expr $hps_emif_en<<15] + [expr $fpga_emif_en<<14] + [expr $hps_emif_ecc_en<<13] + [expr $fpga_emif_ecc_en<<12] + [expr $h2f_user_clk_en<<11] + [expr $h2f_f2h_loopback_en<<10] + [expr $lwh2f_f2h_loopback_en<<9] + [expr $h2f_f2sdram0_loopback_en<<8] + [expr $h2f_f2sdram1_loopback_en<<7] + [expr $h2f_f2sdram2_loopback_en<<6] + [expr $gpio_loopback_en<<5] + [expr $hps_peri_irq_loopback_en<<4] + [expr $cross_trigger_en<<3] + [expr $hps_stm_en<<2] + [expr $ftrace_en<<1] + $fpga_peripheral_en]
# puts "VARIANT: [format %8.4x $variant_id]"
# set SYSID [expr 0x${board_rev}000000 + $variant_id]
# set SYSID $variant_id
# puts "SYSID  : [format %8.8x $variant_id]"
set SYSID "0xACD5CAFE"

package require -exact qsys 19.1

if {$fpga_peripheral_en == 1} {
source ./construct_subsys_peripheral.tcl
reload_ip_catalog
}

if {$jtag_ocm_en == 1} {
source ./construct_subsys_jtag_master.tcl
reload_ip_catalog
}

if {$fpga_pcie == 1} {
source ./construct_subsys_pcie.tcl
reload_ip_catalog
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

if {$hps_sgmii_en == 1} {
source ./construct_subsys_sgmii.tcl
reload_ip_catalog
}

if {$niosv_subsys_en == 1} {
source ./construct_subsys_niosv.tcl
reload_ip_catalog
}

if {$hps_etile_1588_en == 1} {
source ./construct_subsys_etile_25gbe.tcl
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

if {$clk_gate_en == 1} {
add_component_param "stratix10_clkctrl clkctrl_0
                    IP_FILE_PATH ip/$qsys_name/clkctrl_0.ip 
                    NUM_CLOCKS 1
                    ENABLE 1
                    ENABLE_REGISTER_TYPE 1
                    ENABLE_TYPE 1
                    "
}

if {$jtag_ocm_en == 1} {
## Temporary disable src_prb_rst
# add_component_param "altera_in_system_sources_probes src_prb_rst
#                   IP_FILE_PATH ip/$qsys_name/src_prb_rst.ip 
#                   create_source_clock 1
#                   probe_width 0
#                   source_initial_value 1
#                   source_width 1
#                   "

add_component_param "altera_avalon_sysid_qsys sysid
                    IP_FILE_PATH ip/$qsys_name/sysid.ip 
                    id $SYSID
                    "

add_instance jtg_mst subsys_jtg_mst

add_component_param "altera_avalon_onchip_memory2 ocm
                    IP_FILE_PATH ip/$qsys_name/ocm.ip 
                    dataWidth $ocm_datawidth
                    memorySize $ocm_memsize
                    slave1Latency 2
                    singleClockOperation 1
                    "

# if {$ocm_memsize <= 262144} {
set addr_width [expr { log($ocm_memsize) / log(2)} ]
add_component_param "altera_avalon_mm_bridge fpga_m2ocm_pb
                    IP_FILE_PATH ip/$qsys_name/fpga_m2ocm_pb.ip 
                    DATA_WIDTH 128
                    ADDRESS_WIDTH $addr_width
                    USE_AUTO_ADDRESS_WIDTH 0
                    "
# }
}

if {$fpga_peripheral_en == 1} {
add_instance periph subsys_periph
}

if {$niosv_subsys_en ==1} {
add_instance niosv subsys_niosv
}

if {$cct_en == 1} {
if {$f2h_width > 0} {
add_component_param "intel_cache_coherency_translator intel_cache_coherency_translator_0
                    IP_FILE_PATH ip/$qsys_name/intel_cache_coherency_translator_0.ip
                    CONTROL_INTERFACE $cct_control_interface
                    ADDR_WIDTH $f2h_addr_width
                    AXM_ID_WIDTH 5
                    AXS_ID_WIDTH 5
                    ARDOMAIN_OVERRIDE 0
                    ARBAR_OVERRIDE 0
                    ARSNOOP_OVERRIDE 0
                    ARCACHE_OVERRIDE_EN 1
                    ARCACHE_OVERRIDE 2
                    AWDOMAIN_OVERRIDE 0
                    AWBAR_OVERRIDE 0
                    AWSNOOP_OVERRIDE 0
                    AWCACHE_OVERRIDE_EN 1
                    AWCACHE_OVERRIDE 2
                    AxUSER_OVERRIDE 0xE0
                    AxPROT_OVERRIDE_EN 1
                    AxPROT_OVERRIDE 1
                    DATA_WIDTH $f2h_width
                    "
}

if {$f2h_addr_width > 32} {
add_component_param "altera_address_span_extender ext_hps_m_master
                    IP_FILE_PATH ip/$qsys_name/ext_hps_m_master.ip
                    BURSTCOUNT_WIDTH 1
                    MASTER_ADDRESS_WIDTH $f2h_addr_width
                    SLAVE_ADDRESS_WIDTH 30
                    ENABLE_SLAVE_PORT 0
                    MAX_PENDING_READS 1
                    "
}
}
# instantiate PCIe subsystem
if {$fpga_pcie == 1} {
add_instance pcie_0 subsys_pcie

add_component_param "altera_reset_bridge pcie_nreset_status_merge
                    IP_FILE_PATH ip/$qsys_name/pcie_nreset_status_merge.ip 
                    ACTIVE_LOW_RESET 1
                    SYNCHRONOUS_EDGES deassert
                    NUM_RESET_OUTPUTS 1
                    USE_RESET_REQUEST 0
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

if {$hps_sgmii_en == 1} {
add_component_param "altera_clock_bridge clk_125
                    IP_FILE_PATH ip/$qsys_name/clk_125.ip 
                    EXPLICIT_CLOCK_RATE 125000000 
                    NUM_CLOCK_OUTPUTS 1
                    "

for {set m $hps_sgmii_emac_start_node} {$m<=$hps_sgmii_emac_end_node} {incr m} {
add_instance subsys_sgmii_emac${m} subsys_sgmii
}
}

if {$jop_en == 1} {
add_component_param "intel_jop_blaster jop
                    IP_FILE_PATH ip/$qsys_name/jop.ip 
                    EXPORT_SLD_ED {0}
                    MEM_SIZE {4096}
                    MEM_WIDTH {64}
                    USE_TCK_ENA {1}
                    "
}

if {$hps_etile_1588_en == 1} {
add_instance etile_25gbe_1588 subsys_etile_25gbe_1588
}

if {$hps_en == 1} {
#setup HPS and HPS EMIF
source ./construct_hps.tcl
}

if {$hps_emif_en == 1 || $fpga_emif_en == 1} {
if {$hps_emif_en == 1 && $fpga_emif_en == 1} {
set num_calbus 2
} else {
set num_calbus 1
}
add_component_param "altera_emif_cal emif_calbus_0
                     IP_FILE_PATH ip/$qsys_name/emif_calbus_0.ip 
                     NUM_CALBUS_INTERFACE $num_calbus 
                     "
}

# --------------- Connections and connection parameters ------------------#
#connect "   clk_100.out_clk rst_in.clk
#"
#Disable for HSD 14019499053 

if {$jtag_ocm_en == 1} {
## Temporary disable src_prb_rst
# connect "   clk_100.out_clk src_prb_rst.source_clk
# "

connect "   clk_100.out_clk sysid.clk
            rst_in.out_reset sysid.reset
"

connect "   clk_100.out_clk   jtg_mst.clk
            rst_in.out_reset  jtg_mst.reset
            rst_in.out_reset  ocm.reset1    
"

if {$ocm_clk_source == 0} {
connect "   clk_100.out_clk   fpga_m2ocm_pb.clk
            rst_in.out_reset  fpga_m2ocm_pb.reset
"

connect_map "   fpga_m2ocm_pb.m0        ocm.s1 0x0" 

#connect_map "  jtg_mst.fpga_m_master   fpga_m2ocm_pb.s0 0x80000"
connect_map "   jtg_mst.fpga_m_master   fpga_m2ocm_pb.s0 0x80000000"
}

connect_map "   jtg_mst.fpga_m_master   sysid.control_slave 0x0"

if {$fpga_peripheral_en == 1} {
connect_map "   jtg_mst.fpga_m_master   periph.pb_cpu_0_s0 0x1000"
}

if {$hps_sgmii_en == 1} {
if {$hps_sgmii_emac1_en == 1} {
connect_map "   jtg_mst.fpga_m_master   subsys_sgmii_emac1.csr 0x3000"
}
if {$hps_sgmii_emac2_en == 1} {
connect_map "   jtg_mst.fpga_m_master   subsys_sgmii_emac2.csr 0x4000"
}
}

if {$hps_etile_1588_en == 1} {
connect_map "   jtg_mst.fpga_m_master   etile_25gbe_1588.csr   0x02000000"
}
}

if {$fpga_peripheral_en == 1} {
connect "clk_100.out_clk   periph.clk
         rst_in.out_reset  periph.reset
         "
}

if {$niosv_subsys_en == 1} {
connect "clk_100.out_clk   niosv.clk
         rst_in.out_reset  niosv.reset
         "
}

#if {$h2f_f2h_loopback_acp_adapter_en == 1 && $h2f_f2h_loopback_en == 1} {
#if {$f2h_clk_source == 1} {
#connect "agilex_hps.h2f_user1_clock  acp_bridge_128_0.clock"
#} else {
#connect "clk_100.out_clk         acp_bridge_128_0.clock"
#}
#connect "rst_in.out_reset        acp_bridge_128_0.reset"
#
#connect "clk_100.out_clk         acp_bridge_128_0.csr_clock"
#connect "rst_in.out_reset        acp_bridge_128_0.csr_reset"
#}

if {$hps_emif_en == 1 && $fpga_emif_en == 1} {
connect "emif_hps.emif_calbus             emif_calbus_0.emif_calbus_0
         emif_calbus_0.emif_calbus_clk    emif_hps.emif_calbus_clk
         
         emif_fpga.emif_calbus            emif_calbus_0.emif_calbus_1
         emif_calbus_0.emif_calbus_clk    emif_fpga.emif_calbus_clk
         "
} elseif {$hps_emif_en == 1} {
connect "emif_hps.emif_calbus             emif_calbus_0.emif_calbus_0
         emif_calbus_0.emif_calbus_clk    emif_hps.emif_calbus_clk
         "
} elseif {$fpga_emif_en == 1} {
connect "emif_fpga.emif_calbus            emif_calbus_0.emif_calbus_0
         emif_calbus_0.emif_calbus_clk    emif_fpga.emif_calbus_clk
         "
}

if {$cct_en == 1 } {
    if {$hps_etile_1588_en == 1} {
        connect "etile_25gbe_1588.dma_clkout        intel_cache_coherency_translator_0.clock"
        connect "etile_25gbe_1588.dma_clkout_reset  intel_cache_coherency_translator_0.reset"
    } elseif {$fpga_pcie == 1} {
        connect "pcie_0.pcie_p0_app_clk             intel_cache_coherency_translator_0.clock"
    } elseif {$f2h_clk_source == 1} {
        connect "agilex_hps.h2f_user1_clock         intel_cache_coherency_translator_0.clock"
    } else {
        connect "clk_100.out_clk                    intel_cache_coherency_translator_0.clock"
    }

    connect "rst_in.out_reset        intel_cache_coherency_translator_0.reset"

    if {$f2h_addr_width >32} {
        connect "clk_100.out_clk                    ext_hps_m_master.clock
                 rst_in.out_reset                   ext_hps_m_master.reset"
    }

    if {$cct_control_interface == 2} {
        connect "clk_100.out_clk                   intel_cache_coherency_translator_0.csr_clock
                 rst_in.out_reset                  intel_cache_coherency_translator_0.csr_reset
                "
    }

    if {$f2h_addr_width >32} {
        connect_map "jtg_mst.hps_m_master          ext_hps_m_master.windowed_slave   0x0"
        connect_map "ext_hps_m_master.expanded_master   intel_cache_coherency_translator_0.s0      0x0"
    } else {
        connect_map "jtg_mst.hps_m_master          intel_cache_coherency_translator_0.s0           0x0"
    }

    if {$fpga_pcie == 1} {
        connect_map "pcie_0.ext_expanded_master    intel_cache_coherency_translator_0.s0           0x0"
    }

    if {$hps_etile_1588_en == 1} {
        for {set x 1} {$x<=$hps_etile_1588_count} {incr x} {
            connect_map "etile_25gbe_1588.tx_dma_ch${x}_prefetcher_read_master      intel_cache_coherency_translator_0.s0 0x0
                         etile_25gbe_1588.tx_dma_ch${x}_prefetcher_write_master     intel_cache_coherency_translator_0.s0 0x0
                         etile_25gbe_1588.tx_dma_ch${x}_read_master                 intel_cache_coherency_translator_0.s0 0x0
                         etile_25gbe_1588.rx_dma_ch${x}_prefetcher_read_master      intel_cache_coherency_translator_0.s0 0x0
                         etile_25gbe_1588.rx_dma_ch${x}_prefetcher_write_master     intel_cache_coherency_translator_0.s0 0x0
                         etile_25gbe_1588.rx_dma_ch${x}_write_master                intel_cache_coherency_translator_0.s0 0x0
                     "
        }
    }
}

# PCIe subsystem
if {$fpga_pcie == 1} {
connect "clk_100.out_clk                     pcie_0.clk
         rst_in.out_reset                      pcie_0.reset
       "
       
connect "pcie_0.pcie_p0_app_clk              pcie_nreset_status_merge.clk"
       
#connect "pcie_nreset_status_merge.out_reset  ocm.reset1"
connect "pcie_nreset_status_merge.out_reset  pcie_0.nreset_status_merge"
   
for {set x 0} {$x < 4} {incr x} {
# connect "pcie_0.p${x}_app_reset_status_n         pcie_nreset_status_merge.in_reset
#          "
}
connect_map "pcie_0.pb_2_ocm_m0 ocm.s1 0x0"

}

if {$hps_etile_1588_en == 1} {
connect "clk_100.out_clk                     etile_25gbe_1588.clk
         rst_in.out_reset                    etile_25gbe_1588.reset
       "
}

if {$pr_enable == 1} {
for {set k 0} {$k<$pr_region_count} {incr k} {
connect_map "frz_bdg_${k}.slv_bridge_to_pr   pr_region_${k}.pr_mm_bridge_0_s0 0x0000
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
}

if {$freeze_ack_dly_enable == 1} {
connect     "clk_100.out_clk     start_ack_pio.clk
             clk_100.out_clk     stop_ack_pio.clk
             rst_in.out_reset    stop_ack_pio.reset 
             rst_in.out_reset    start_ack_pio.reset
            "
}
}

if {$hps_sgmii_en == 1} {
connect     "clk_100.out_clk                       agilex_hps.emac_ptp_ref_clock
            "

for {set m $hps_sgmii_emac_start_node} {$m<=$hps_sgmii_emac_end_node} {incr m} {
connect     "clk_100.out_clk                       subsys_sgmii_emac${m}.csr_clk
             clk_125.out_clk                       subsys_sgmii_emac${m}.clk_125
             rst_in.out_reset                      subsys_sgmii_emac${m}.rst_in
             agilex_hps.emac${m}_gtx_clk           subsys_sgmii_emac${m}.emac_gtx_clk
             subsys_sgmii_emac${m}.emac_rx_clk_in  agilex_hps.emac${m}_rx_clk_in
             subsys_sgmii_emac${m}.emac_tx_clk_in  agilex_hps.emac${m}_tx_clk_in
             agilex_hps.emac${m}_rx_reset          subsys_sgmii_emac${m}.emac_rx_reset
             agilex_hps.emac${m}_tx_reset          subsys_sgmii_emac${m}.emac_tx_reset
             agilex_hps.emac${m}                   subsys_sgmii_emac${m}.splitter_emac
            "
}
}

if {$jop_en == 1} {
connect     "clk_100.out_clk                       jop.clk
            rst_in.out_reset                       jop.reset
            "
}

####################################
#                exported interfaces

## Temporary disable src_prb_rst
# if {$jtag_ocm_en == 1} {
# export src_prb_rst sources src_prb_rst_sources
# }
export clk_100 in_clk clk_100
export rst_in in_reset reset
export user_rst_clkgate_0 ninit_done ninit_done
if {$clk_gate_en == 1} {
export clkctrl_0 clkctrl_input clkctrl_input
export clkctrl_0 clkctrl_output clkctrl_output
}

if {$fpga_peripheral_en == 1} {
if {$fpga_button_pio_width >0} {
export periph button_pio_external_connection button_pio_external_connection
}
if {$fpga_dipsw_pio_width >0} {
export periph dipsw_pio_external_connection dipsw_pio_external_connection
}
if {$fpga_led_pio_width >0} {
export periph led_pio_external_connection led_pio_external_connection
}
}

# PCIe subsystem
if {$fpga_pcie == 1} {
export pcie_0 pcie_hip_serial pcie_hip_serial

export pcie_0 pcie_hip_refclk0 pcie_hip_refclk0

export pcie_0 pcie_hip_refclk1 pcie_hip_refclk1

export pcie_0 pcie_hip_perst pcie_hip_perst

export pcie_0 pcie_ninit_done pcie_ninit_done

# Hack for themporary hack for dummy_user_avmm_rst
#export pcie_0 pcie_dummy_user_avmm_rst pcie_dummy_user_avmm_rst

for {set x 0} {$x < 4} {incr x} {
export pcie_0 pcie_p${x}_pld_warm_rst_rdy       pcie_p${x}_pld_warm_rst_rdy
export pcie_0 pcie_p${x}_link_req_rst_n         pcie_p${x}_link_req_rst_n
export pcie_0 pcie_p${x}_app_reset_status_n     pcie_p${x}_app_reset_status_n
}

export pcie_nreset_status_merge in_reset    pcie_nreset_status_merge
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

# SGMII
if {$hps_sgmii_en == 1} {
export clk_125               in_clk                     clk_125
for {set m $hps_sgmii_emac_start_node} {$m<=$hps_sgmii_emac_end_node} {incr m} {
export agilex_hps emac${m}_md_clk emac${m}_mdc

export subsys_sgmii_emac${m} sgmii_status               emac${m}_sgmii_status
export subsys_sgmii_emac${m} status_led                 emac${m}_status_led
export subsys_sgmii_emac${m} serdes_control             emac${m}_serdes_control
export subsys_sgmii_emac${m} lvds_tx_pll_locked         emac${m}_lvds_tx_pll_locked
export subsys_sgmii_emac${m} sgmii_debug_status_pio     emac${m}_sgmii_debug_status_pio

export subsys_sgmii_emac${m} serial_connection          emac${m}_serial

export subsys_sgmii_emac${m} mdio                       emac${m}_mdio
export subsys_sgmii_emac${m} ptp                        emac${m}_ptp
}
}

if {$niosv_subsys_en == 1} {
export niosv  issp_reset_out  niosv_issp_reset_out
export niosv  issp_reset_in   niosv_issp_reset_in
}

# Etile HIP 25GbE Subsystem
if {$hps_etile_1588_en == 1} {
export etile_25gbe_1588     clk_ref         etile_25gbe_clk_ref
export etile_25gbe_1588     serial_p        etile_25gbe_serial_p
export etile_25gbe_1588     serial_n        etile_25gbe_serial_n
export etile_25gbe_1588     ninit_done      etile_25gbe_ninit_done
export etile_25gbe_1588     master_todclk   etile_25gbe_master_todclk

export etile_25gbe_1588     qsfpdd_status_pio     qsfpdd_status_pio
export etile_25gbe_1588     qsfpdd_ctrl_pio_0       qsfpdd_ctrl_pio_0

}

if {$hps_etile_1588_en == 1} {
    set_postadaptation_assignment mm_interconnect_0|cmd_demux.src0/crosser.in qsys_mm.postTransform.pipelineCount 1
    set_postadaptation_assignment mm_interconnect_0|cmd_demux.src1/crosser_001.in qsys_mm.postTransform.pipelineCount 1
    set_postadaptation_assignment mm_interconnect_0|crosser_003.out/rsp_mux.sink1 qsys_mm.postTransform.pipelineCount 1
    set_postadaptation_assignment mm_interconnect_0|etile_25gbe_1588_rx_dma_ch1_prefetcher_read_master_agent.cp/router_001.sink qsys_mm.postTransform.pipelineCount 1
    set_postadaptation_assignment mm_interconnect_0|etile_25gbe_1588_rx_dma_ch1_prefetcher_read_master_limiter.rsp_src/etile_25gbe_1588_rx_dma_ch1_prefetcher_read_master_agent.rp qsys_mm.postTransform.pipelineCount 1
    set_postadaptation_assignment mm_interconnect_0|etile_25gbe_1588_rx_dma_ch1_prefetcher_write_master_agent.cp/router_002.sink qsys_mm.postTransform.pipelineCount 1
    set_postadaptation_assignment mm_interconnect_0|etile_25gbe_1588_rx_dma_ch1_write_master_agent.cp/router_003.sink qsys_mm.postTransform.pipelineCount 1
    set_postadaptation_assignment mm_interconnect_0|etile_25gbe_1588_tx_dma_ch1_prefetcher_read_master_agent.cp/router_004.sink qsys_mm.postTransform.pipelineCount 1
    set_postadaptation_assignment mm_interconnect_0|etile_25gbe_1588_tx_dma_ch1_prefetcher_read_master_limiter.rsp_src/etile_25gbe_1588_tx_dma_ch1_prefetcher_read_master_agent.rp qsys_mm.postTransform.pipelineCount 1
    set_postadaptation_assignment mm_interconnect_0|etile_25gbe_1588_tx_dma_ch1_prefetcher_write_master_agent.cp/router_005.sink qsys_mm.postTransform.pipelineCount 1
    set_postadaptation_assignment mm_interconnect_0|etile_25gbe_1588_tx_dma_ch1_read_master_agent.cp/router_006.sink qsys_mm.postTransform.pipelineCount 1
    set_postadaptation_assignment mm_interconnect_0|etile_25gbe_1588_tx_dma_ch1_read_master_limiter.rsp_src/etile_25gbe_1588_tx_dma_ch1_read_master_agent.rp qsys_mm.postTransform.pipelineCount 1
    set_postadaptation_assignment mm_interconnect_0|router_001.src/etile_25gbe_1588_rx_dma_ch1_prefetcher_read_master_limiter.cmd_sink qsys_mm.postTransform.pipelineCount 1
    set_postadaptation_assignment mm_interconnect_0|router_002.src/cmd_demux_002.sink qsys_mm.postTransform.pipelineCount 1
    set_postadaptation_assignment mm_interconnect_0|router_003.src/cmd_demux_003.sink qsys_mm.postTransform.pipelineCount 1
    set_postadaptation_assignment mm_interconnect_0|router_004.src/etile_25gbe_1588_tx_dma_ch1_prefetcher_read_master_limiter.cmd_sink qsys_mm.postTransform.pipelineCount 1
    set_postadaptation_assignment mm_interconnect_0|router_005.src/cmd_demux_005.sink qsys_mm.postTransform.pipelineCount 1
    set_postadaptation_assignment mm_interconnect_0|router_006.src/etile_25gbe_1588_tx_dma_ch1_read_master_limiter.cmd_sink qsys_mm.postTransform.pipelineCount 1
    set_postadaptation_assignment mm_interconnect_0|rsp_mux.src/ext_hps_m_master_expanded_master_rsp_width_adapter.sink qsys_mm.postTransform.pipelineCount 1
    set_postadaptation_assignment mm_interconnect_0|rsp_mux_002.src/etile_25gbe_1588_rx_dma_ch1_prefetcher_write_master_agent.rp qsys_mm.postTransform.pipelineCount 1
    set_postadaptation_assignment mm_interconnect_0|rsp_mux_003.src/etile_25gbe_1588_rx_dma_ch1_write_master_agent.rp qsys_mm.postTransform.pipelineCount 1
    set_postadaptation_assignment mm_interconnect_0|rsp_mux_005.src/etile_25gbe_1588_tx_dma_ch1_prefetcher_write_master_agent.rp qsys_mm.postTransform.pipelineCount 1
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
