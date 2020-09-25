#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2018-2020 Intel Corporation.
#
#****************************************************************************
#
# This script construct sub system of MGE 10GbE (SGMII) for higher level integration
# The GHRD create_ghrd_qsys.tcl will call each of those subsystem construct script
# automatically based on the corresponding parameter argument defined
#
#****************************************************************************


source ./arguments_solver.tcl
source ./utils.tcl
set subsys_name subsys_mge
  
package require -exact qsys 18.1

create_system $subsys_name

set_project_property DEVICE_FAMILY $device_family
set_project_property DEVICE $device
set_validation_property AUTOMATIC_VALIDATION false

add_component_param "altera_clock_bridge mge_enet_refclk
                    IP_FILE_PATH ip/$subsys_name/mge_enet_refclk.ip 
                    EXPLICIT_CLOCK_RATE 125000000 
                    NUM_CLOCK_OUTPUTS 1
                    "

add_component_param "altera_reset_bridge mge_rst_125M
                    IP_FILE_PATH ip/$subsys_name/mge_rst_125M.ip 
                    ACTIVE_LOW_RESET 1
                    SYNCHRONOUS_EDGES both
                    NUM_RESET_OUTPUTS 1
                    USE_RESET_REQUEST 0
                    "
               
add_component_param "altera_reset_bridge mge_rcfg_rst
                    IP_FILE_PATH ip/$subsys_name/mge_rcfg_rst.ip 
                    ACTIVE_LOW_RESET 1
                    SYNCHRONOUS_EDGES both
                    NUM_RESET_OUTPUTS 1
                    USE_RESET_REQUEST 0
                    "

add_component_param "altera_avalon_mm_bridge pb_0
                    IP_FILE_PATH ip/$subsys_name/pb_0.ip 
                    DATA_WIDTH 32
                    ADDRESS_WIDTH 32
                    USE_AUTO_ADDRESS_WIDTH 1
                    MAX_BURST_SIZE 1
                    MAX_PENDING_RESPONSES 1
                    "                           
add_component_param "altera_avalon_mm_bridge pb_mge_rcfg_0
                    IP_FILE_PATH ip/$subsys_name/pb_mge_rcfg_0.ip 
                    DATA_WIDTH 32
                    ADDRESS_WIDTH 32
                    USE_AUTO_ADDRESS_WIDTH 1
                    MAX_BURST_SIZE 1
                    MAX_PENDING_RESPONSES 1
                    "               

add_component_param "mge_rcfg mge_rcfg_0
                    IP_FILE_PATH ip/$subsys_name/mge_rcfg_0.ip
                    NUM_OF_CHANNEL ${sgmii_count}
                    "

add_component_param "altera_iopll enet_iopll_0
                    IP_FILE_PATH ip/$qsys_name/enet_iopll_0.ip 
                    gui_reference_clock_frequency 125
                    gui_use_locked 1
                    gui_operation_mode direct
                    gui_number_of_clocks 3
                    gui_output_clock_frequency0 {125.0}
                    gui_output_clock_frequency1 {25.0}
                    gui_output_clock_frequency2 {2.5}
                    gui_pll_auto_reset 1
                    "

add_component_param "altera_xcvr_fpll_s10_htile xcvr_fpll_1G
                    IP_FILE_PATH ip/$subsys_name/xcvr_fpll_1G.ip
                    rcfg_file_prefix {altera_xcvr_fpll_s10}
                    set_prot_mode {0}
                    set_refclk_cnt {1}
                    set_bw_sel {low}
                    set_power_mode {1_0V}
                    set_auto_reference_clock_frequency {125.0}
                    set_output_clock_frequency {625.0}
                    enable_mcgb {1}
                    mcgb_div {1}
                    enable_hfreq_clk {1}
                    "
                
for {set x 1} {$x<=$sgmii_count} {incr x} {
add_component_param "altera_hps_emac_interface_splitter emac_splitter_${x}
                    IP_FILE_PATH ip/$subsys_name/emac_splitter_${x}.ip
                    "
                    
add_component_param "hps_to_mge_gmii_adapter hps_to_mge_gmii_adapter_${x}
                    IP_FILE_PATH ip/$subsys_name/hps_to_mge_gmii_adapter_${x}.ip
                    "

add_component_param "alt_mge_phy alt_mge_phy_${x}
                    IP_FILE_PATH ip/$subsys_name/alt_mge_phy_${x}.ip
                    ANALOG_VOLTAGE {1_0V}
                    DEFAULT_MODE {1}
                    ENABLE_IEEE1588 {0}
                    ENABLE_SGMII {1}
                    EXCLUDE_NATIVE_PHY {0}
                    EXT_PHY_MGBASET {1}
                    EXT_PHY_NBASET {0}
                    PHY_IDENTIFIER {0}
                    REFCLK_FREQ_BASER {0}
                    SHOW_HIDDEN_OPTIONS {0}
                    SPEED_VARIANT {1}
                    TX_PLL_CLOCK_NETWORK_1G {xN}
                    TX_PLL_CLOCK_NETWORK_2P5G {xN}
                    TX_PMA_CLK_DIV_1G {1}
                    TX_PMA_CLK_DIV_2P5G {1}
                    XCVR_RCFG_JTAG_ENABLE {0}
                    XCVR_SET_CAPABILITY_REG_ENABLE {0}
                    XCVR_SET_CSR_SOFT_LOGIC_ENABLE {0}
                    XCVR_SET_ODI_SOFT_LOGIC_ENABLE {0}
                    XCVR_SET_PRBS_SOFT_LOGIC_ENABLE {0}
                    XCVR_SET_USER_IDENTIFIER {0}
                  "

add_component_param "altera_xcvr_reset_control_s10 xcvr_reset_${x}
                    IP_FILE_PATH ip/$subsys_name/xcvr_reset_${x}.ip
                    TILE_TYPE {h_tile}
                    CHANNELS {1}
                    PLLS {2}
                    SYS_CLK_IN_MHZ {125}
                    TX_ENABLE {1}
                    TX_MANUAL_RESET {0}
                    T_TX_ANALOGRESET {70000}
                    T_TX_DIGITALRESET {70000}
                    RX_ENABLE {1}
                    RX_MANUAL_RESET {0}
                    T_RX_ANALOGRESET {70000}
                    T_RX_DIGITALRESET {5000}
                    gui_pll_cal_busy {0}
                   "
}

connect "mge_enet_refclk.out_clk    mge_rst_125M.clk
         mge_enet_refclk.out_clk    mge_rcfg_rst.clk
         mge_enet_refclk.out_clk    pb_0.clk
         mge_enet_refclk.out_clk    mge_rcfg_0.clock
         mge_enet_refclk.out_clk    pb_mge_rcfg_0.clk
         mge_enet_refclk.out_clk    enet_iopll_0.refclk
         mge_enet_refclk.out_clk    xcvr_fpll_1G.pll_refclk0
         
         mge_rst_125M.out_reset     pb_0.reset
         mge_rst_125M.out_reset     pb_mge_rcfg_0.reset
         mge_rst_125M.out_reset     enet_iopll_0.reset
         
         mge_rcfg_rst.out_reset     mge_rcfg_0.reset_sink
         "

connect_map "mge_rcfg_0.reconfig_xcvr_master    pb_mge_rcfg_0.s0   0x0
             "

for {set x 1} {$x<=$sgmii_count} {incr x} {        
# connections and connection parameters
connect_map "pb_0.m0    hps_to_mge_gmii_adapter_${x}.csr    [expr {0x80 * ($x-1) + 0x40}]"
connect_map "pb_0.m0    alt_mge_phy_${x}.avalon_mm_csr      [expr {0x80 * ($x-1) }]"
connect_map "pb_mge_rcfg_0.m0    alt_mge_phy_${x}.reconfig_avmm   [expr {0x2000 * ($x-1)}]"

connect "mge_enet_refclk.out_clk    hps_to_mge_gmii_adapter_${x}.clock
         mge_enet_refclk.out_clk    alt_mge_phy_${x}.csr_clk
         mge_enet_refclk.out_clk    alt_mge_phy_${x}.reconfig_clk
         mge_enet_refclk.out_clk    alt_mge_phy_${x}.rx_cdr_refclk_0
         mge_enet_refclk.out_clk    xcvr_reset_${x}.clock
         "
         
connect "mge_rst_125M.out_reset     hps_to_mge_gmii_adapter_${x}.reset_sink
         mge_rst_125M.out_reset     alt_mge_phy_${x}.reconfig_reset
         mge_rst_125M.out_reset     alt_mge_phy_${x}.reset
         "
         
connect "enet_iopll_0.outclk0      hps_to_mge_gmii_adapter_${x}.pll_125m_clk
         enet_iopll_0.outclk1      hps_to_mge_gmii_adapter_${x}.pll_25m_clk
         enet_iopll_0.outclk2      hps_to_mge_gmii_adapter_${x}.pll_2_5m_clk
         "
         
connect "emac_splitter_${x}.hps_gmii            hps_to_mge_gmii_adapter_${x}.hps_gmii
         alt_mge_phy_${x}.gmii16b_rx_d          hps_to_mge_gmii_adapter_${x}.gmii16b_rx_d  
         alt_mge_phy_${x}.gmii16b_rx_dv         hps_to_mge_gmii_adapter_${x}.gmii16b_rx_dv 
         alt_mge_phy_${x}.gmii16b_rx_err        hps_to_mge_gmii_adapter_${x}.gmii16b_rx_err
         hps_to_mge_gmii_adapter_${x}.gmii16b_tx_d    alt_mge_phy_${x}.gmii16b_tx_d
         hps_to_mge_gmii_adapter_${x}.gmii16b_tx_en   alt_mge_phy_${x}.gmii16b_tx_en
         hps_to_mge_gmii_adapter_${x}.gmii16b_tx_err  alt_mge_phy_${x}.gmii16b_tx_err
         alt_mge_phy_${x}.rx_clkena             hps_to_mge_gmii_adapter_${x}.phy_rx_clkena
         alt_mge_phy_${x}.rx_clkout             hps_to_mge_gmii_adapter_${x}.phy_rx_clkout
         alt_mge_phy_${x}.tx_clkena             hps_to_mge_gmii_adapter_${x}.phy_tx_clkena
         alt_mge_phy_${x}.tx_clkout             hps_to_mge_gmii_adapter_${x}.phy_tx_clkout
         alt_mge_phy_${x}.operating_speed       hps_to_mge_gmii_adapter_${x}.phy_speed
         xcvr_reset_${x}.rx_analogreset         alt_mge_phy_${x}.rx_analogreset
         xcvr_reset_${x}.rx_analogreset_stat    alt_mge_phy_${x}.rx_analogreset_stat
         xcvr_reset_${x}.rx_digitalreset        alt_mge_phy_${x}.rx_digitalreset
         xcvr_reset_${x}.rx_digitalreset_stat   alt_mge_phy_${x}.rx_digitalreset_stat
         xcvr_reset_${x}.rx_is_lockedtodata     alt_mge_phy_${x}.rx_is_lockedtodata
         xcvr_reset_${x}.tx_analogreset         alt_mge_phy_${x}.tx_analogreset
         xcvr_reset_${x}.tx_analogreset_stat    alt_mge_phy_${x}.tx_analogreset_stat
         xcvr_reset_${x}.tx_digitalreset        alt_mge_phy_${x}.tx_digitalreset
         xcvr_reset_${x}.tx_digitalreset_stat   alt_mge_phy_${x}.tx_digitalreset_stat         

         mge_rcfg_0.pll_select_chan${x}         xcvr_reset_${x}.pll_select
         mge_rcfg_0.mge_chan${x}_resetn         xcvr_reset_${x}.reset
         mge_rst_125M.out_reset                 xcvr_reset_${x}.reset
         mge_rcfg_0.xcvr_mode_chan${x}          alt_mge_phy_${x}.xcvr_mode

         mge_rcfg_0.rx_cal_busy_chan${x}_out    xcvr_reset_${x}.rx_cal_busy            
         mge_rcfg_0.tx_cal_busy_chan${x}_out    xcvr_reset_${x}.tx_cal_busy            
         alt_mge_phy_${x}.rx_cal_busy           mge_rcfg_0.rx_cal_busy_chan${x}
         alt_mge_phy_${x}.tx_cal_busy           mge_rcfg_0.tx_cal_busy_chan${x}
         "
}


# exported interfaces
export mge_rst_125M   in_reset    reset_125m
export mge_rcfg_rst   in_reset    mge_rcfg_reset_sink

export mge_enet_refclk  in_clk     enet_refclk
export enet_iopll_0     locked     enet_iopll_locked
export mge_rcfg_0       status     mge_rcfg_status

export pb_0 s0 pb_s

for {set x 1} {$x<=$sgmii_count} {incr x} {   
export emac_splitter_${x} emac            emac${x}
export emac_splitter_${x} emac_gtx_clk    emac${x}_gtx_clk
export emac_splitter_${x} emac_rx_clk_in  emac${x}_rx_clk_in
export emac_splitter_${x} emac_rx_reset   emac${x}_rx_reset
export emac_splitter_${x} emac_tx_clk_in  emac${x}_tx_clk_in
export emac_splitter_${x} emac_tx_reset   emac${x}_tx_reset
export emac_splitter_${x} mdio            emac${x}_mdio
export emac_splitter_${x} ptp             emac${x}_ptp

export alt_mge_phy_${x} led_an            mge_phy${x}_led_an
export alt_mge_phy_${x} led_char_err      mge_phy${x}_led_char_err
export alt_mge_phy_${x} led_disp_err      mge_phy${x}_led_disp_err
export alt_mge_phy_${x} led_link          mge_phy${x}_led_link
export alt_mge_phy_${x} led_panel_link    mge_phy${x}_led_panel_link
export alt_mge_phy_${x} rx_serial_data    mge_phy${x}_rx_serial_data
export alt_mge_phy_${x} tx_serial_data    mge_phy${x}_tx_serial_data
export alt_mge_phy_${x} tx_serial_clk     mge_phy${x}_tx_serial_clk

export xcvr_reset_${x}  pll_locked        xcvr_reset_${x}_pll_locked
export xcvr_reset_${x}  tx_ready          xcvr_reset_${x}_tx_ready
export xcvr_reset_${x}  rx_ready          xcvr_reset_${x}_rx_ready

export hps_to_mge_gmii_adapter_${x}   pll_locked     gmii_adapter${x}_pll_locked
}

export xcvr_fpll_1G        mcgb_serial_clk     fpll_1G_mcgb_serial_clk
export xcvr_fpll_1G        pll_locked          fpll_1G_pll_locked



# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {AUTO}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
    
sync_sysinfo_parameters 
    
save_system ${subsys_name}.qsys
