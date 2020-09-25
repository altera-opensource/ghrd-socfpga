#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2020 Intel Corporation.
#
#****************************************************************************
#
# This script construct sub system of MGE 10GbE 1588 DMA for higher level integration
# The GHRD create_ghrd_qsys.tcl will call each of those subsystem construct script
# automatically based on the corresponding parameter argument defined
#
#****************************************************************************


source ./arguments_solver.tcl
source ./utils.tcl
  
package require -exact qsys 18.1

source ./construct_subsys_mge_rx_dma.tcl
source ./construct_subsys_mge_tx_dma.tcl
reload_ip_catalog

set subsys_10gbe_name subsys_mge_10gbe_1588_dma
create_system $subsys_10gbe_name

set_project_property DEVICE_FAMILY $device_family
set_project_property DEVICE $device
set_validation_property AUTOMATIC_VALIDATION false



add_component_param "altera_clock_bridge mge_10gbe_1588_dma_clk
                     IP_FILE_PATH ip/$subsys_10gbe_name/mge_10gbe_1588_dma_clk.ip 
                     EXPLICIT_CLOCK_RATE 156250000 
                     NUM_CLOCK_OUTPUTS 1
                     "

add_component_param "altera_reset_bridge mge_10gbe_1588_dma_reset
                     IP_FILE_PATH ip/$subsys_10gbe_name/mge_10gbe_1588_dma_reset.ip 
                     ACTIVE_LOW_RESET 1
                     SYNCHRONOUS_EDGES both
                     NUM_RESET_OUTPUTS 1
                     USE_RESET_REQUEST 0
                     "
                     
add_component_param "altera_avalon_mm_bridge mge_10gbe_1588_dma_csr
                     IP_FILE_PATH ip/$subsys_10gbe_name/mge_10gbe_1588_dma_csr.ip 
                     DATA_WIDTH 32
                     ADDRESS_WIDTH 32
                     USE_AUTO_ADDRESS_WIDTH 1
                     MAX_BURST_SIZE 1
                     MAX_PENDING_RESPONSES 1
                     "
                     
for {set x 1} {$x<=$hps_mge_10gbe_1588_count} {incr x} {
   add_instance mge_tx_dma_ch${x} subsys_mge_tx_dma
   add_instance mge_rx_dma_ch${x} subsys_mge_rx_dma
}


# --------------- Connections and connection parameters ------------------#
connect "mge_10gbe_1588_dma_clk.out_clk            mge_10gbe_1588_dma_reset.clk
         mge_10gbe_1588_dma_clk.out_clk            mge_10gbe_1588_dma_csr.clk
         mge_10gbe_1588_dma_reset.out_reset        mge_10gbe_1588_dma_csr.reset
         "
         
for {set x 1} {$x<=$hps_mge_10gbe_1588_count} {incr x} {
connect "mge_10gbe_1588_dma_clk.out_clk            mge_tx_dma_ch${x}.clk
         mge_10gbe_1588_dma_reset.out_reset        mge_tx_dma_ch${x}.reset
         mge_10gbe_1588_dma_clk.out_clk            mge_rx_dma_ch${x}.clk
         mge_10gbe_1588_dma_reset.out_reset        mge_rx_dma_ch${x}.reset
         "
}
         
for {set x 1} {$x<=$hps_mge_10gbe_1588_count} {incr x} {
connect_map "mge_10gbe_1588_dma_csr.m0      mge_tx_dma_ch${x}.csr [expr {0x0 + ($x-1)*0x200}]
             mge_10gbe_1588_dma_csr.m0      mge_rx_dma_ch${x}.csr [expr {0x100 + ($x-1)*0x200}]
             "
}


# --------------------    Exported Interfaces     -----------------------#
export mge_10gbe_1588_dma_clk    in_clk      clk
export mge_10gbe_1588_dma_reset  in_reset    reset
export mge_10gbe_1588_dma_csr    s0          csr

for {set x 1} {$x<=$hps_mge_10gbe_1588_count} {incr x} {
export mge_tx_dma_ch${x}      pktout              mge_tx_dma_ch${x}_pktout
export mge_tx_dma_ch${x}      timestamp           mge_tx_dma_ch${x}_timestamp
export mge_tx_dma_ch${x}      timestamp_req       mge_tx_dma_ch${x}_timestamp_req
export mge_rx_dma_ch${x}      pktin               mge_rx_dma_ch${x}_pktin
export mge_rx_dma_ch${x}      timestamp           mge_rx_dma_ch${x}_timestamp
export mge_rx_dma_ch${x}      pause_control       mge_rx_dma_ch${x}_pause_control

export mge_tx_dma_ch${x}      prefetcher_read_master     tx_dma_ch${x}_prefetcher_read_master 
export mge_tx_dma_ch${x}      prefetcher_write_master    tx_dma_ch${x}_prefetcher_write_master
export mge_tx_dma_ch${x}      read_master                tx_dma_ch${x}_read_master            
export mge_rx_dma_ch${x}      prefetcher_read_master     rx_dma_ch${x}_prefetcher_read_master 
export mge_rx_dma_ch${x}      prefetcher_write_master    rx_dma_ch${x}_prefetcher_write_master
export mge_rx_dma_ch${x}      write_master               rx_dma_ch${x}_write_master 

export mge_tx_dma_ch${x}      irq                        tx_dma_ch${x}_irq
export mge_rx_dma_ch${x}      irq                        rx_dma_ch${x}_irq
}

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {AUTO}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
    
sync_sysinfo_parameters 
    
save_system ${subsys_10gbe_name}.qsys
