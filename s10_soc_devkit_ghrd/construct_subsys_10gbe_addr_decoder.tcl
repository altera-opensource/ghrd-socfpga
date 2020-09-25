#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2020 Intel Corporation.
#
#****************************************************************************
#
# This script construct sub system of 10GbE Address decoder for 10GbE 1588 design
# Example command to execute this script file
#   qsys-script --script=construct_subsys_10gbe_addr_decoder.tcl
#
#****************************************************************************

source ./arguments_solver.tcl
source ./utils.tcl
  
package require -exact qsys 18.1

reload_ip_catalog

set subsys_10gbe_name subsys_10gbe_addr_decoder
create_system $subsys_10gbe_name

set_project_property DEVICE_FAMILY $device_family
set_project_property DEVICE $device
set_validation_property AUTOMATIC_VALIDATION false



add_component_param "altera_clock_bridge mge_10gbe_refclk_csr
                     IP_FILE_PATH ip/$subsys_10gbe_name/mge_10gbe_refclk_csr.ip 
                     EXPLICIT_CLOCK_RATE 125000000 
                     NUM_CLOCK_OUTPUTS 1
                     "

add_component_param "altera_reset_bridge mge_10gbe_reset
                     IP_FILE_PATH ip/$subsys_10gbe_name/mge_10gbe_reset.ip 
                     ACTIVE_LOW_RESET 1
                     SYNCHRONOUS_EDGES both
                     NUM_RESET_OUTPUTS 1
                     USE_RESET_REQUEST 0
                     "
                    
add_component_param "altera_avalon_mm_bridge mge_10gbe_csr
                     IP_FILE_PATH ip/$subsys_10gbe_name/mge_10gbe_csr.ip 
                     DATA_WIDTH 32
                     ADDRESS_WIDTH 32
                     USE_AUTO_ADDRESS_WIDTH 1
                     MAX_BURST_SIZE 1
                     MAX_PENDING_RESPONSES 1
                     "

add_component_param "avmm_feedthough_bridge csr_reconfig
                     IP_FILE_PATH ip/$subsys_10gbe_name/csr_reconfig.ip 
                     DATA_WIDTH 32
                     ADDRESS_WIDTH 2
                     USE_WAITREQUEST 0
                     READLATENCY 1
                     WRITE_WAIT 0
                     READ_WAIT 0
                     "

add_component_param "avmm_feedthough_bridge csr_master_tod
                     IP_FILE_PATH ip/$subsys_10gbe_name/csr_master_tod.ip 
                     DATA_WIDTH 32
                     ADDRESS_WIDTH 4
                     USE_WAITREQUEST 1
                     READLATENCY 1
                     WRITE_WAIT 0
                     READ_WAIT 0
                     "

for {set x 1} {$x<=$hps_mge_10gbe_1588_max_count} {incr x} {    
   add_component_param "avmm_feedthough_bridge csr_mac_ch${x}
                        IP_FILE_PATH ip/$subsys_10gbe_name/csr_mac_ch${x}.ip 
                        DATA_WIDTH 32
                        ADDRESS_WIDTH 10
                        USE_WAITREQUEST 1
                        READLATENCY 0
                        WRITE_WAIT 0
                        READ_WAIT 0
                        "
   
   add_component_param "avmm_feedthough_bridge csr_phy_ch${x}
                        IP_FILE_PATH ip/$subsys_10gbe_name/csr_phy_ch${x}.ip 
                        DATA_WIDTH 32
                        ADDRESS_WIDTH 11
                        USE_WAITREQUEST 1
                        READLATENCY 0
                        WRITE_WAIT 0
                        READ_WAIT 0
                        "
                        
   add_component_param "avmm_feedthough_bridge csr_tod_10g_ch${x}
                        IP_FILE_PATH ip/$subsys_10gbe_name/csr_tod_10g_ch${x}.ip 
                        DATA_WIDTH 32
                        ADDRESS_WIDTH 4
                        USE_WAITREQUEST 1
                        READLATENCY 1
                        WRITE_WAIT 0
                        READ_WAIT 0
                        "
                        
   add_component_param "avmm_feedthough_bridge csr_tod_2p5g_ch${x}
                        IP_FILE_PATH ip/$subsys_10gbe_name/csr_tod_2p5g_ch${x}.ip 
                        DATA_WIDTH 32
                        ADDRESS_WIDTH 4
                        USE_WAITREQUEST 1
                        READLATENCY 1
                        WRITE_WAIT 0
                        READ_WAIT 0
                        "
                        
   add_component_param "avmm_feedthough_bridge csr_tod_1g_ch${x}
                        IP_FILE_PATH ip/$subsys_10gbe_name/csr_tod_1g_ch${x}.ip 
                        DATA_WIDTH 32
                        ADDRESS_WIDTH 4
                        USE_WAITREQUEST 1
                        READLATENCY 1
                        WRITE_WAIT 0
                        READ_WAIT 0
                        "
}

connect "mge_10gbe_refclk_csr.out_clk    mge_10gbe_reset.clk
         mge_10gbe_refclk_csr.out_clk    mge_10gbe_csr.clk
         mge_10gbe_refclk_csr.out_clk    csr_reconfig.clock
         mge_10gbe_refclk_csr.out_clk    csr_master_tod.clock
         
         mge_10gbe_reset.out_reset       mge_10gbe_csr.reset
         mge_10gbe_reset.out_reset       csr_reconfig.reset
         mge_10gbe_reset.out_reset       csr_master_tod.reset
         "
         
for {set x 1} {$x<=$hps_mge_10gbe_1588_max_count} {incr x} {    
   connect "mge_10gbe_refclk_csr.out_clk    csr_mac_ch${x}.clock
            mge_10gbe_refclk_csr.out_clk    csr_phy_ch${x}.clock
            mge_10gbe_refclk_csr.out_clk    csr_tod_10g_ch${x}.clock
            mge_10gbe_refclk_csr.out_clk    csr_tod_2p5g_ch${x}.clock
            mge_10gbe_refclk_csr.out_clk    csr_tod_1g_ch${x}.clock
            
            mge_10gbe_reset.out_reset       csr_mac_ch${x}.reset
            mge_10gbe_reset.out_reset       csr_phy_ch${x}.reset
            mge_10gbe_reset.out_reset       csr_tod_10g_ch${x}.reset
            mge_10gbe_reset.out_reset       csr_tod_2p5g_ch${x}.reset
            mge_10gbe_reset.out_reset       csr_tod_1g_ch${x}.reset
            "
}

connect_map "mge_10gbe_csr.m0            csr_master_tod.s0    0x10000
             mge_10gbe_csr.m0            csr_reconfig.s0      0x10100
             "

for {set x 1} {$x<=$hps_mge_10gbe_1588_max_count} {incr x} {    
   connect_map "mge_10gbe_csr.m0        csr_mac_ch${x}.s0        [expr {0x8000 * ($x-1) }]
                mge_10gbe_csr.m0        csr_phy_ch${x}.s0        [expr {0x8000 * ($x-1) + 0x2000}]
                mge_10gbe_csr.m0        csr_tod_10g_ch${x}.s0    [expr {0x8000 * ($x-1) + 0x6000}]
                mge_10gbe_csr.m0        csr_tod_2p5g_ch${x}.s0   [expr {0x8000 * ($x-1) + 0x6040}]
                mge_10gbe_csr.m0        csr_tod_1g_ch${x}.s0     [expr {0x8000 * ($x-1) + 0x6080}]
                "
}
# exported interfaces
export mge_10gbe_refclk_csr     in_clk         refclk_csr
export mge_10gbe_reset          in_reset       reset

export mge_10gbe_csr            s0             csr

export csr_reconfig           m0             csr_reconfig
export csr_master_tod         m0             csr_master_tod

for {set x 1} {$x<=$hps_mge_10gbe_1588_max_count} {incr x} {   
export csr_mac_ch${x}         m0             csr_mac_ch${x}     
export csr_phy_ch${x}         m0             csr_phy_ch${x}     
export csr_tod_10g_ch${x}     m0             csr_tod_10g_ch${x} 
export csr_tod_2p5g_ch${x}    m0             csr_tod_2p5g_ch${x}
export csr_tod_1g_ch${x}      m0             csr_tod_1g_ch${x}  
}

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {AUTO}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
    
sync_sysinfo_parameters 
    
save_system ${subsys_10gbe_name}.qsys
