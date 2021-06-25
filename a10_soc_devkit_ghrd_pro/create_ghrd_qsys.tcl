#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2014-2021 Intel Corporation.
#
#****************************************************************************
#
# This script construct top level qsys for the GHRD
# to use this script, 
# example command to execute this script file
#   qsys-script --script=create_ghrd_qsys.tcl
#
# --- alternatively, input arguments could be passed in to select other FPGA variant. 
#     qsys_name        : <name your qsys top>,
#     devicefamily     : <FPGA device family>,
#     device           : <FPGA device part number>
#     hps_sdram        : <FBGA code of memory device>
#     boot_device      : <selection of boot source, either SDMMC, QSPI, NAND, or FPGA>
#     hps_sdram_ecc    : 1 or 0
#     board_rev        : <selection of development board revision, either A or B>
#     bsel             : override boot select
#                      "0:RESERVED" 
#                      "1:FPGA" 
#                      "2:NAND Flash (1.8v)" 
#                      "3:NAND Flash (3.0v)" 
#                      "4:SD/MMC External Transceiver (1.8v)" 
#                      "5:SD/MMC Internal Transceiver (3.0v)" 
#                      "6:Quad SPI Flash (1.8v)" 
#                      "7:Quad SPI Flash (3.0v)"
#     spim0_en         : 1 or 0
#     fast_trace       : 1 or 0
#     early_io_release : 1 or 0
#     qsys_pro         : 1 or 0
#     hps_sgmii        : 1 or 0
#     sgmii_count      : 1 or 2
#     fpga_dp          : 1 or 0
#     frame_buffer     : 1 or 0
#     fpga_pcie        : 1 or 0
#     pcie_gen         : 2 or 3
#     pcie_count       : 4 or 8  (x8 currently supported for gen2 only)
#     pr_enable        : 1 or 0
#     pr_region_count  : 1 or 2
#     pr_ip_enable     : 1 or 0
#     freeze_ack_dly_enable        : 1 or 0
#     fpga_ocm_msgdma_enable : 1 or 0
#     pr_dp_mix_enable : 1 or 0
#     niosii_en        : 1 or 0
#     niosii_mmu_en    : 1 or 0
#     fpga_tse           : 1 or 0
#     tse_variant          : 1 or 0
#     tse_interface        : 1 or 0
#     transceiver_type     : 1 or 0
#     dma_prefetch_enable  : 1 or 0
#     reconfig_enable      : 1 or 0
#     mdio_enable          : 1 or 0
#     mdio_clk_div         : 40 or 50
#
# example command to execute this script file
#   qsys-script --script=create_ghrd_qsys.tcl --cmd="set qsys_name soc_system; set devicefamily "Arria 10"; set device 10AS066N3F40E2SG"
#
#****************************************************************************

source ./design_config.tcl
source ./utils.tcl
global sub_qsys_pr
global pr_region_id_switch

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
    
if { ![ info exists qsys_name ] } {
  set qsys_name $QSYS_NAME
} else {
  puts "-- Accepted parameter \$qsys_name = $qsys_name"
}

if { ![ info exists hps_sdram ] } {
  set hps_sdram $HPS_SDRAM_DEVICE
} else {
  puts "-- Accepted parameter \$hps_sdram = $hps_sdram"
}

if { ![ info exists hps_sdram_ecc ] } {
  set hps_sdram_ecc $HPS_SDRAM_ECC_ENABLE
} else {
  puts "-- Accepted parameter \$hps_sdram_ecc = $hps_sdram_ecc"
}

if { ![ info exists boot_device ] } {
  set boot_device $BOOT_SOURCE
} else {
  puts "-- Accepted parameter \$boot_device = $boot_device"
}

if { ![ info exists board_rev ] } {
  set board_rev $BOARD_REV
} else {
  puts "-- Accepted parameter \$board_rev = $board_rev"
  if {$board_rev == "A"} {
    puts "*** Board Rev $board_rev is not supported in this GHRD generation. GHRD for rev B board and latest will be created. ***"
  }
}

if { ![ info exists bsel ] } {
  set bsel $BSEL
} else {
  set BSEL_EN 1
  puts "-- Accepted parameter \$bsel = $bsel"
}

#
# verify bsel override against boot device
#
if {$BSEL_EN == 1} {
  #
  # If bsel is not reservered or fpga,
  # then only allow overriding of voltage to
  # to same boot_device.
  #
  if {$bsel != 0 && $bsel != 1} {
    if {$boot_device == "SDMMC"} {
      if {$bsel != 4 && $bsel != 5} {
        puts stderr "BOOT_DEVICE is $boot_device\n"
        puts stderr "Only valid values for bsel are 0, 1, 4, and 5\n"
        exit 1;
      }
    } elseif {$boot_device == "QSPI"} {
      if {$bsel != 6 && $bsel != 7} {
        puts stderr "BOOT_DEVICE is $boot_device\n"
        puts "Only valid overrides are 0, 1, 6, and 7\n"
        exit 1;
      }
    } elseif {$boot_device == "NAND"} {
      if {$bsel != 2 && $bsel != 3} {
        puts stderr "BOOT_DEVICE is $boot_device\n"
        puts stderr "Only valid overrides are 0, 1, 2, and 3\n"
        exit 1;
      }
    }
  }
}

if { ![ info exists spim0_en ] } {
    set spim0_en $SPIM0_EN
} else {
    puts "-- Accepted parameter \$spim0_en = $spim0_en"
}

if { ![ info exists fast_trace ] } {
  set fast_trace $FTRACE_ENABLE
} else {
  puts "-- Accepted parameter \$fast_trace = $fast_trace"
}

if { ![ info exists early_io_release ] } {
  set early_io_release $EARLY_IO_RELEASE
} else {
  puts "-- Accepted parameter \$early_io_release = $early_io_release"
}

if { ![ info exists qsys_pro ] } {
  set qsys_pro $QSYS_PRO
} else {
  puts "-- Accepted parameter \$qsys_pro = $qsys_pro"
}


if { ![ info exists hps_sgmii ] } {
  set hps_sgmii $SGMII_ENABLE
} else {
  puts "-- Accepted parameter \$hps_sgmii = $hps_sgmii"
}

if { ![ info exists sgmii_count ] } {
  set sgmii_count $SGMII_COUNT
} else {
  puts "-- Accepted parameter \$sgmii_count = $sgmii_count"
}

if { ![ info exists fpga_dp ] } {
  set fpga_dp $DISP_PORT_ENABLE
} else {
  puts "-- Accepted parameter \$fpga_dp = $fpga_dp"
}

if { ![ info exists frame_buffer ] } {
  set frame_buffer $ADD_FRAME_BUFFER
} else {
  puts "-- Accepted parameter \$frame_buffer = $frame_buffer"
}

if { ![ info exists fpga_pcie ] } {
  set fpga_pcie $PCIE_ENABLE
} else {
  puts "-- Accepted parameter \$fpga_pcie = $fpga_pcie"
}

if { ![ info exists pcie_gen ] } {
  set pcie_gen $GEN_ENABLE
} else {
  puts "-- Accepted parameter \$pcie_gen = $pcie_gen"
}

if { ![ info exists pcie_count ] } {
  set pcie_count $PCIE_COUNT
} else {
  puts "-- Accepted parameter \$pcie_count = $pcie_count"
}

if { ![ info exists pr_enable ] } {
  set pr_enable $PARTIAL_RECONFIGURATION
} else {
  puts "-- Accepted parameter \$pr_enable = $pr_enable"
}

if { ![ info exists pr_region_count ] } {
  set pr_region_count $PR_REGION_COUNT
} else {
  puts "-- Accepted parameter \$pr_region_count = $pr_region_count"
}

if { ![ info exists pr_ip_enable ] } {
  set pr_ip_enable $PARTIAL_RECONFIGURATION_CORE_IP
} else {
  puts "-- Accepted parameter \$pr_ip_enable = $pr_ip_enable"
}

if { ![ info exists fpga_ocm_msgdma_enable ] } {
  set fpga_ocm_msgdma_enable $FPGA_OCM_MSGDMA
} else {
  puts "-- Accepted parameter \$fpga_ocm_msgdma_enable = $fpga_ocm_msgdma_enable"
}

if { ![ info exists freeze_ack_dly_enable ] } {
  set freeze_ack_dly_enable $FREEZE_ACK_DELAY_ENABLE
} else {
  puts "-- Accepted parameter \$freeze_ack_dly_enable = $freeze_ack_dly_enable"
}

if { ![ info exists pr_dp_mix_enable ] } {
  set pr_dp_mix_enable $PARTIAL_RECONFIGURATION_DISP_PORT_MIX_ENABLE
} else {
  puts "-- Accepted parameter \$pr_dp_mix_enable = $pr_dp_mix_enable"
}

if { ![ info exists niosii_en ] } {
  set niosii_en $NIOSII_ENABLE
} else {
  puts "-- Accepted parameter \$niosii_en = $niosii_en"
}

if { ![ info exists niosii_mmu_en ] } {
  set niosii_mmu_en $NIOSII_MMU_ENABLE
} else {
  puts "-- Accepted parameter \$niosii_mmu_en = $niosii_mmu_en"
}

if { ![ info exists fpga_tse ] } {
  set fpga_tse $TSE_ENABLE
} else {
  puts "-- Accepted parameter \$fpga_tse = $fpga_tse"
}

if { ![ info exists tse_variant ] } {
  set tse_variant $TSE_VARIANT
} else {
  puts "-- Accepted parameter \$tse_variant = $tse_variant"
}

if { ![ info exists tse_interface ] } {
  set tse_interface $TSE_INTERFACE
} else {
  puts "-- Accepted parameter \$tse_interface = $tse_interface"
}

if { ![ info exists transceiver_type ] } {
  set transceiver_type $TRANSCEIVER_TYPE
} else {
  puts "-- Accepted parameter \$transceiver_type = $transceiver_type"
}

if { ![ info exists dma_prefetch_enable ] } {
  set dma_prefetch_enable $DMA_PREFETCH_ENABLE
} else {
  puts "-- Accepted parameter \$dma_prefetch_enable = $dma_prefetch_enable"
}

if { ![ info exists reconfig_enable ] } {
  set reconfig_enable $RECONFIGURATION_ENABLE
} else {
  puts "-- Accepted parameter \$reconfig_enable = $reconfig_enable"
}

if { ![ info exists mdio_enable ] } {
  set mdio_enable $MDIO_ENABLE
} else {
  puts "-- Accepted parameter \$mdio_enable = $mdio_enable"
}

if { ![ info exists mdio_clk_div ] } {
  set mdio_clk_div $MDIO_CLK_DIVIDER
} else {
  puts "-- Accepted parameter \$mdio_clk_div = $mdio_clk_div"
}

# Internal parameter derivation
if {$hps_sdram_ecc == 1} {
   set hps_sdram_width 40 
} else {
   set hps_sdram_width 32
}

if {$boot_device == "SDMMC"} {
set dedicated_io_assignment "SDMMC:D0 SDMMC:CMD SDMMC:CCLK SDMMC:D1 SDMMC:D2 SDMMC:D3 NONE NONE SDMMC:D4 SDMMC:D5 SDMMC:D6 SDMMC:D7 UART1:TX UART1:RX"
set boot_code 0
} elseif {$boot_device == "QSPI"} {
set dedicated_io_assignment "QSPI:CLK QSPI:IO0 QSPI:SS0 QSPI:IO1 QSPI:IO2_WPN QSPI:IO3_HOLD NONE NONE NONE NONE NONE NONE UART1:TX UART1:RX"
set boot_code 1
} elseif {$boot_device == "NAND"} {
set dedicated_io_assignment "NAND:ADQ0 NAND:ADQ1 NAND:WE_N NAND:RE_N NAND:ADQ2 NAND:ADQ3 NAND:CLE NAND:ALE NAND:RB NAND:CE_N NAND:ADQ4 NAND:ADQ5 NAND:ADQ6 NAND:ADQ7"
set boot_code 2
} elseif {$boot_device == "FPGA"} {
set dedicated_io_assignment "NONE NONE NONE NONE NONE NONE NONE NONE NONE NONE NONE NONE UART1:TX UART1:RX"
set boot_code 3
} else {
set dedicated_io_assignment "NONE NONE NONE NONE NONE NONE NONE NONE NONE NONE NONE NONE NONE NONE"
set boot_code 4
}

if {$hps_sdram == "D9RGX"} {
set hps_ddr 0
} elseif {$hps_sdram == "D9PZN"} {
set hps_ddr 1
} elseif {$hps_sdram == "D9RPL"} {
set hps_ddr 2
} elseif {$hps_sdram == "D9TNZ"} {
set hps_ddr 3
} elseif {$hps_sdram == "D9WFH"} {
set hps_ddr 4
}

if {$fast_trace == 1 } {
set early_trace 0
} else {
set early_trace 1
}

set hps_i2c_fpga_if 0


if {$early_trace == 1} {
set etrace_data_assignment "TRACE:D0 TRACE:D1 TRACE:D2 TRACE:D3"
set etrace_clk_assignment "TRACE:CLK"
} else {
set etrace_data_assignment "unused unused unused unused"
set etrace_clk_assignment "unused"
}

set io48_q1_assignment "USB0:CLK USB0:STP USB0:DIR USB0:DATA0 USB0:DATA1 USB0:NXT USB0:DATA2 USB0:DATA3 USB0:DATA4 USB0:DATA5 USB0:DATA6 USB0:DATA7"
set io48_q2_assignment "EMAC0:TX_CLK EMAC0:TX_CTL EMAC0:RX_CLK EMAC0:RX_CTL EMAC0:TXD0 EMAC0:TXD1 EMAC0:RXD0 EMAC0:RXD1 EMAC0:TXD2 EMAC0:TXD3 EMAC0:RXD2 EMAC0:RXD3"
if {$boot_device == "NAND"} {
set io48_q3_assignment "SPIM1:CLK SPIM1:MOSI SPIM1:MISO SPIM1:SS0_N SPIM1:SS1_N GPIO UART1:TX UART1:RX NONE NONE MDIO0:MDIO MDIO0:MDC"
} else {
set io48_q3_assignment "SPIM1:CLK SPIM1:MOSI SPIM1:MISO SPIM1:SS0_N SPIM1:SS1_N GPIO NONE NONE NONE NONE MDIO0:MDIO MDIO0:MDC"
}
set io48_q4_assignment "I2C1:SDA I2C1:SCL GPIO $etrace_clk_assignment GPIO GPIO NONE GPIO $etrace_data_assignment"


set variant_id [expr [expr $early_io_release<<14] + [expr $PCIE_ENABLE<<13] + [expr $CROSS_TRIGGER_ENABLE<<12] + [expr [expr $early_trace]<<11] + [expr $fast_trace<<10] + [expr $fpga_dp<<9] + [expr $hps_sgmii<<8] + [expr $boot_code<<4] + [expr $hps_sdram_ecc<<3] + $hps_ddr]
puts "VARIANT: [format %8.4x $variant_id]"

set SYSID [expr 0x${board_rev}0080000 + $variant_id]
puts "SYSID  : [format %8.8x $SYSID]"

package require -exact qsys 17.1
reload_ip_catalog

if {$hps_sgmii == 1} {
source ./construct_subsys_sgmii.tcl 
reload_ip_catalog
}

if {$fpga_dp == 1} {
source ./construct_subsys_dp.tcl
reload_ip_catalog
}

if {$fpga_pcie == 1} {
source ./construct_subsys_pcie.tcl
reload_ip_catalog
}

if {$pr_enable == 1 && $pr_dp_mix_enable == 0} {
for {set k 0} {$k<$pr_region_count} {incr k} {
if {$k == 0} {
set sub_qsys_pr "pr_region_0"
set pr_region_id_switch 0
source ./construct_subsys_pr_region.tcl
reload_ip_catalog
} else {
set sub_qsys_pr "pr_region_1"
set pr_region_id_switch 1
source ./construct_subsys_pr_region.tcl
reload_ip_catalog
}
}
}

if {$niosii_en == 1} {
source ./construct_subsys_peripheral.tcl
reload_ip_catalog
}

if {$fpga_tse == 1} {
source ./construct_subsys_tse.tcl
reload_ip_catalog
}

create_system $qsys_name

set_project_property DEVICE_FAMILY $devicefamily
set_project_property DEVICE $device

add_component_param "altera_clock_bridge clk_100 
                     IP_FILE_PATH ip/$qsys_name/clk_100.ip
                     EXPLICIT_CLOCK_RATE 100000000 
                     NUM_CLOCK_OUTPUTS 1"

add_component_param "altera_reset_bridge rst_in 
                     IP_FILE_PATH ip/$qsys_name/rst_in.ip
                     ACTIVE_LOW_RESET 1 
                     SYNCHRONOUS_EDGES deassert
                     NUM_RESET_OUTPUTS 1
                     USE_RESET_REQUEST 0"

add_component_param "altera_reset_bridge rst_bdg 
                     IP_FILE_PATH ip/$qsys_name/rst_bdg.ip
                     SYNCHRONOUS_EDGES deassert
                     NUM_RESET_OUTPUTS 1
                     USE_RESET_REQUEST 0"   
                     
if {$niosii_en == 1} {
set_component_param "rst_bdg    
                    ACTIVE_LOW_RESET 1"
} else {
set_component_param "rst_bdg    
                    ACTIVE_LOW_RESET 0"
}

add_component_param "altera_avalon_onchip_memory2 ocm_0 
                     IP_FILE_PATH ip/$qsys_name/ocm_0.ip
                     memorySize 262144.0
                     singleClockOperation 1"    
if {$boot_device == "FPGA"} {
set_component_param "ocm_0  
                    initMemContent 1    
                    useNonDefaultInitFile 1 
                    initializationFileName onchip_mem.hex"
}
if {$fpga_pcie == 1} {
if {$pcie_gen == 3} {
if {$pcie_count == 8} {
set_component_param "ocm_0  
                    dataWidth 512"
} else {
set_component_param "ocm_0  
                    dataWidth 256"
}
} else {
if {$pcie_count == 8} {
set_component_param "ocm_0  
                    dataWidth 256"
} else {
set_component_param "ocm_0  
                    dataWidth 128"
}
}
} else {
set_component_param "ocm_0  
                    dataWidth $OCM_WIDTH"
}

if {$niosii_en == 1} {
# generate alternate version A10 SoC GHRD with NiosII soft Processor instead of HPS
add_component_param "altera_nios2_gen2 cpu 
                     IP_FILE_PATH ip/$qsys_name/cpu.ip
                     mmu_TLBMissExcSlave tb_ram_1k.s2
                     resetSlave qspi_0.avl_mem
                     resetOffset 0x00000040
                     dividerType srt2
                     impl Fast
                     icache_size 32768
                     icache_numTCIM 1
                     dcache_size 32768
                     dcache_numTCDM 1
                     setting_activateTrace 1"
if {$niosii_mmu_en == 1} {
set_component_param "cpu    
                    mmu_enabled 1"
}
if {$qsys_pro == 1} {
set_component_param "cpu    
                    exceptionSlave a10_emif.ctrl_amm_avalon_slave_0"
} else {
set_component_param "cpu    
                    exceptionSlave a10_emif_ecc_core.ctrl_amm_avalon_slave_0"
}

add_component_param "altera_avalon_onchip_memory2 tb_ram_1k 
                     IP_FILE_PATH ip/$qsys_name/tb_ram_1k.ip
                     dualPort 1
                     memorySize 1024.0
                     singleClockOperation 1"

add_component_param "altera_emif a10_emif 
                     IP_FILE_PATH ip/$qsys_name/a10_emif.ip
                     PROTOCOL_ENUM PROTOCOL_DDR4
                     PHY_DDR4_MEM_CLK_FREQ_MHZ 1066.667
                     PHY_DDR4_DEFAULT_REF_CLK_FREQ 0
                     PHY_DDR4_USER_REF_CLK_FREQ_MHZ 133.333
                     MEM_DDR4_DQ_WIDTH 72
                     PHY_DDR4_DEFAULT_IO 0
                     PHY_DDR4_USER_DATA_IN_MODE_ENUM IN_OCT_60_CAL
                     MEM_DDR4_BANK_GROUP_WIDTH 1
                     MEM_DDR4_ALERT_N_PLACEMENT_ENUM DDR4_ALERT_N_PLACEMENT_DATA_LANES
                     MEM_DDR4_ALERT_N_DQS_GROUP 8
                     MEM_DDR4_RTT_NOM_ENUM DDR4_RTT_NOM_RZQ_6
                     MEM_DDR4_READ_DBI 0
                     MEM_DDR4_SPEEDBIN_ENUM DDR4_SPEEDBIN_2666"
## The density-dependent refresh parameter has to be reduced to match 8Gbit density. Without it, accesses to memory conducted will fail deterministically.
set_component_param "a10_emif   
                    MEM_DDR4_ROW_ADDR_WIDTH 15  
                    CTRL_DDR4_MMR_EN 1  
                    CTRL_DDR4_ECC_EN 1  
                    CTRL_DDR4_ECC_AUTO_CORRECTION_EN 1  
                    PLL_ADD_EXTRA_CLKS 1    
                    PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_5 213.333 
                    PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_6 48.485"
if {$fpga_tse == 1} {
set_component_param "a10_emif   
                    PLL_USER_NUM_OF_EXTRA_CLKS 3"
if {$mdio_clk_div == 50} {
set_component_param "a10_emif   
                    PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_7 118.519"
} else {
set_component_param "a10_emif   
                    PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_7 96.97"
}
} else {
set_component_param "a10_emif   
                    PLL_USER_NUM_OF_EXTRA_CLKS 2"
}
#########preset setting for DDR4-2666U CL18 Component 8Gb MT40A512M16JY-75E, D9TNZ (512Mb x16)
set_component_param "a10_emif   
                    MEM_DDR4_TCL 16 
                    MEM_DDR4_WTCL 11    
                    PHY_DDR4_USER_DATA_OUT_MODE_ENUM OUT_OCT_48_CAL 
                    MEM_DDR4_TIS_PS 55.0    
                    MEM_DDR4_TIS_AC_MV 90.0 
                    MEM_DDR4_TIH_PS 80.0    
                    MEM_DDR4_TIH_DC_MV 65.0 
                    MEM_DDR4_TDIVW_TOTAL_UI 0.22    
                    MEM_DDR4_VDIVW_TOTAL 120    
                    MEM_DDR4_TDQSQ_UI 0.18  
                    MEM_DDR4_TQH_UI 0.74    
                    MEM_DDR4_TDQSCK_PS 170.0    
                    MEM_DDR4_TQSH_CYC 0.4   
                    MEM_DDR4_TRCD_NS 13.5
                    MEM_DDR4_TRP_NS 13.5    
                    MEM_DDR4_TRRD_L_CYC 8   
                    MEM_DDR4_TRRD_S_CYC 7   
                    MEM_DDR4_TFAW_NS 30.0   
                    MEM_DDR4_TWTR_L_CYC 10  
                    MEM_DDR4_TWTR_S_CYC 4   
                    MEM_DDR4_TRFC_NS 350.0  
                    DIAG_DDR4_SKIP_CA_LEVEL 1"
#########
set_component_param "a10_emif   
                    PHY_DDR4_USER_AC_IO_STD_ENUM IO_STD_SSTL_12 
                    PHY_DDR4_USER_CK_IO_STD_ENUM IO_STD_SSTL_12 
                    PHY_DDR4_USER_DATA_IO_STD_ENUM IO_STD_POD_12    
                    PHY_DDR4_USER_AC_MODE_ENUM OUT_OCT_40_CAL   
                    PHY_DDR4_USER_CK_MODE_ENUM OUT_OCT_40_CAL   
                    PHY_DDR4_USER_PLL_REF_CLK_IO_STD_ENUM IO_STD_LVDS   
                    PHY_DDR4_USER_RZQ_IO_STD_ENUM IO_STD_CMOS_12"

add_instance periph subsys_periph

add_component_param "altera_jtag_avalon_master fpga_m 
                     IP_FILE_PATH ip/$qsys_name/fpga_m.ip"

add_component_param "altera_avalon_mm_bridge pb_c2ph 
                     IP_FILE_PATH ip/$qsys_name/pb_c2ph.ip  
                    DATA_WIDTH 32   
                    ADDRESS_WIDTH 32    
                    USE_AUTO_ADDRESS_WIDTH 1    
                    MAX_BURST_SIZE 1    
                    MAX_PENDING_RESPONSES 1"

add_component_param "altera_generic_quad_spi_controller2 qspi_0 
                     IP_FILE_PATH ip/$qsys_name/qspi_0.ip   
                    FLASH_TYPE EPCQL1024"

add_component_param "altera_iopll qspi_pll 
                     IP_FILE_PATH ip/$qsys_name/qspi_pll.ip 
                    gui_reference_clock_frequency 100.0 
                    gui_use_locked 1    
                    gui_operation_mode direct   
                    gui_number_of_clocks 1  
                    gui_output_clock_frequency0 40.0"

add_component_param "altera_address_span_extender ddr_ext 
                     IP_FILE_PATH ip/$qsys_name/ddr_ext.ip  
                    MASTER_ADDRESS_WIDTH 31 
                    SLAVE_ADDRESS_WIDTH 25  
                    BURSTCOUNT_WIDTH 1  
                    ENABLE_SLAVE_PORT 0 
                    MAX_PENDING_READS 4"

add_component_param "altera_avalon_mm_clock_crossing_bridge cpu_ccb 
                     IP_FILE_PATH ip/$qsys_name/cpu_ccb.ip  
                    ADDRESS_WIDTH 27    
                    USE_AUTO_ADDRESS_WIDTH 1    
                    MAX_BURST_SIZE 8    
                    COMMAND_FIFO_DEPTH 16   
                    RESPONSE_FIFO_DEPTH 16"

add_component_param "altera_avalon_timer timer_0 
                     IP_FILE_PATH ip/$qsys_name/timer_0.ip  
                    period 10"

add_component_param "altera_avalon_timer timer_1 
                     IP_FILE_PATH ip/$qsys_name/timer_1.ip"

add_component_param "altera_avalon_sysid_qsys sysid 
                     IP_FILE_PATH ip/$qsys_name/sysid.ip    
                    id -87110914"

add_component_param "altera_irq_bridge irq_bg 
                     IP_FILE_PATH ip/$qsys_name/irq_bg.ip   
                    IRQ_N 0"
if {$fpga_tse == 1} {
set_component_param "irq_bg 
                    IRQ_WIDTH 3"
} else {
set_component_param "irq_bg 
                    IRQ_WIDTH 1"
}
} else {
add_component_param "altera_in_system_sources_probes issp_0 
                     IP_FILE_PATH ip/$qsys_name/issp_0.ip   
                    instance_id RST 
                    probe_width 0   
                    source_width 3  
                    source_initial_value 0  
                    create_source_clock 1"

# generate ordinary A10 SoC GHRD with HPS
add_instance_param "altera_arria10_hps a10_hps
                    MPU_EVENTS_Enable 0 
                    STM_Enable 1    
                    F2S_Width 6 
                    S2F_Width 4 
                    LWH2F_Enable 2  
                    F2SDRAM_PORT_CONFIG 6   
                    F2SDRAM0_ENABLED 1  
                    F2SDRAM1_ENABLED 0  
                    F2SDRAM2_ENABLED 1  
                    F2SINTERRUPT_Enable 1   
                    CLK_SDMMC_SOURCE 1  
                    MPU_CLK_VCCL 1  
                    CUSTOM_MPU_CLK 1020 
                    L3_MAIN_FREE_CLK 200    
                    L4_SYS_FREE_CLK 1   
                    NOCDIV_L4MAINCLK 0  
                    NOCDIV_L4MPCLK 0    
                    NOCDIV_L4SPCLK 2    
                    NOCDIV_CS_ATCLK 0   
                    NOCDIV_CS_PDBGCLK 1 
                    NOCDIV_CS_TRACECLK 1    
                    HPS_DIV_GPIO_FREQ 125   
                    FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_EMAC1_GTX_CLK 125
                    FPGA_PERIPHERAL_OUTPUT_CLOCK_FREQ_EMAC2_GTX_CLK 125 
                    F2H_DBG_RST_Enable 1    
                    F2H_WARM_RST_Enable 1   
                    F2H_COLD_RST_Enable 1"
if {$hps_sdram == "D9RPL" || $hps_sdram == "D9PZN" || $hps_sdram == "D9RGX" || $hps_sdram == "D9TNZ" || $hps_sdram == "D9WFH"} {
set_instance_param "a10_hps 
                    EMIF_CONDUIT_Enable 1"
} else {
set_instance_param "a10_hps 
                    EMIF_CONDUIT_Enable 0"
}
set_instance_param "a10_hps 
                    EMAC0_PinMuxing IO  
                    EMAC0_Mode RGMII_with_MDIO"
if {$hps_sgmii == 1} {
set_instance_param "a10_hps 
                    EMAC1_PinMuxing FPGA    
                    EMAC1_Mode RGMII_with_MDIO"
} else {    
set_instance_param "a10_hps 
                    EMAC1_PinMuxing Unused  
                    EMAC1_Mode N/A"
}
if {$hps_sgmii == 1 && $sgmii_count == 2} {
set_instance_param "a10_hps 
                    EMAC2_PinMuxing FPGA    
                    EMAC2_Mode RGMII_with_MDIO"
} else {
set_instance_param "a10_hps 
                    EMAC2_PinMuxing Unused  
                    EMAC2_Mode N/A"
}
if {$boot_device == "NAND"} {
set_instance_param "a10_hps 
                    NAND_PinMuxing IO   
                    NAND_Mode 8-bit"
} else {
set_instance_param "a10_hps 
                    NAND_PinMuxing Unused   
                    NAND_Mode N/A"
}
if {$boot_device == "QSPI"} {
set_instance_param "a10_hps 
                    QSPI_PinMuxing IO   
                    QSPI_Mode 1ss"
} else {
set_instance_param "a10_hps 
                    QSPI_PinMuxing Unused   
                    QSPI_Mode N/A"
}
if {$boot_device == "SDMMC"} {
set_instance_param "a10_hps 
                    SDMMC_PinMuxing IO  
                    SDMMC_Mode 8-bit"
} else {
set_instance_param "a10_hps 
                    SDMMC_PinMuxing Unused  
                    SDMMC_Mode N/A"
}
set_instance_param "a10_hps 
                    USB0_PinMuxing IO   
                    USB0_Mode default"
if {$spim0_en == 1} {
set_instance_param "a10_hps 
                    SPIM0_PinMuxing FPGA    
                    SPIM0_Mode Single_slave_selects"
} else {
set_instance_param "a10_hps 
                    SPIM0_PinMuxing Unused  
                    SPIM0_Mode N/A"
}
set_instance_param "a10_hps 
                    SPIM1_PinMuxing IO  
                    SPIM1_Mode Dual_slave_selects   
                    UART1_PinMuxing IO  
                    UART1_Mode No_flow_control"
if {$hps_i2c_fpga_if == 1} {
# re-route I2C1 from FPGA to IO48
set_instance_param "a10_hps 
                    I2C1_PinMuxing FPGA"
} else {
set_instance_param "a10_hps 
                    I2C1_PinMuxing IO"
}
set_instance_param "a10_hps 
                    I2C1_Mode default"
if {$fast_trace == 1} {
set_instance_param "a10_hps 
                    TRACE_PinMuxing FPGA    
                    TRACE_Mode default"
} elseif {$early_trace == 1} {
set_instance_param "a10_hps 
                    TRACE_PinMuxing IO  
                    TRACE_Mode default"
} else {
set_instance_param "a10_hps 
                    TRACE_PinMuxing Unused  
                    TRACE_Mode default"
}
set_instance_param "a10_hps 
                    HPS_IO_Enable {$dedicated_io_assignment $io48_q1_assignment $io48_q2_assignment $io48_q3_assignment $io48_q4_assignment}"
if {$BSEL_EN == 1} {
if {$boot_device == "FPGA"} {
set_instance_param "a10_hps 
                    BOOT_FROM_FPGA_Enable 1 
                    BSEL_EN 1   
                    BSEL 1"
} else {
set_instance_param "a10_hps
                    BSEL_EN 1   
                    BSEL $bsel"
}
} else {
set_instance_param "a10_hps
                    BSEL_EN 0   
                    BSEL 1"
}

if {$hps_sdram == "D9RPL"} {
# dual rank DDR3 -1866
add_component_param "altera_emif_a10_hps emif_hps 
                     IP_FILE_PATH ip/$qsys_name/emif_hps.ip 
                    PROTOCOL_ENUM PROTOCOL_DDR3
                    IS_ED_SLAVE 0   
                    INTERNAL_TESTING_MODE 0 
                    PLL_ADD_EXTRA_CLKS 0    
                    PLL_USER_NUM_OF_EXTRA_CLKS 0    
                    PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_0 0  
                    PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_1 0  
                    PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_2 0  
                    PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_3 0  
                    PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_4 0  
                    PLL_EXTRA_CLK_DESIRED_FREQ_MHZ_GUI_5 100.0  
                    PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_5 100.0   
                    PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_5 0  
                    PLL_EXTRA_CLK_DESIRED_PHASE_GUI_5 0.0   
                    PLL_EXTRA_CLK_ACTUAL_PHASE_PS_GUI_5 0.0 
                    PLL_EXTRA_CLK_ACTUAL_PHASE_DEG_GUI_5 0.0    
                    PLL_EXTRA_CLK_DESIRED_DUTY_CYCLE_GUI_5 50.0 
                    PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_GUI_5 50.0
                    PLL_EXTRA_CLK_DESIRED_FREQ_MHZ_GUI_6 100.0  
                    PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_6 100.0   
                    PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_6 0  
                    PLL_EXTRA_CLK_DESIRED_PHASE_GUI_6 0.0   
                    PLL_EXTRA_CLK_ACTUAL_PHASE_PS_GUI_6 0.0 
                    PLL_EXTRA_CLK_ACTUAL_PHASE_DEG_GUI_6 0.0    
                    PLL_EXTRA_CLK_DESIRED_DUTY_CYCLE_GUI_6 50.0 
                    PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_GUI_6 50.0
                    PLL_EXTRA_CLK_DESIRED_FREQ_MHZ_GUI_7 100.0  
                    PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_7 100.0   
                    PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_7 0  
                    PLL_EXTRA_CLK_DESIRED_PHASE_GUI_7 0.0   
                    PLL_EXTRA_CLK_ACTUAL_PHASE_PS_GUI_7 0.0 
                    PLL_EXTRA_CLK_ACTUAL_PHASE_DEG_GUI_7 0.0    
                    PLL_EXTRA_CLK_DESIRED_DUTY_CYCLE_GUI_7 50.0 
                    PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_GUI_7 50.0
                    PLL_EXTRA_CLK_DESIRED_FREQ_MHZ_GUI_8 100.0  
                    PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_8 100.0   
                    PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_8 0  
                    PLL_EXTRA_CLK_DESIRED_PHASE_GUI_8 0.0   
                    PLL_EXTRA_CLK_ACTUAL_PHASE_PS_GUI_8 0.0 
                    PLL_EXTRA_CLK_ACTUAL_PHASE_DEG_GUI_8 0.0    
                    PLL_EXTRA_CLK_DESIRED_DUTY_CYCLE_GUI_8 50.0 
                    PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_GUI_8 50.0  
                    PHY_DDR3_CONFIG_ENUM CONFIG_PHY_AND_HARD_CTRL   
                    PHY_DDR3_USER_PING_PONG_EN 0    
                    PHY_DDR3_MEM_CLK_FREQ_MHZ 800.0 
                    PHY_DDR3_DEFAULT_REF_CLK_FREQ 0 
                    PHY_DDR3_USER_REF_CLK_FREQ_MHZ 133.333  
                    PHY_DDR3_REF_CLK_JITTER_PS 10.0 
                    PHY_DDR3_RATE_ENUM RATE_HALF    
                    PHY_DDR3_CORE_CLKS_SHARING_ENUM CORE_CLKS_SHARING_DISABLED  
                    PHY_DDR3_IO_VOLTAGE 1.5 
                    PHY_DDR3_DEFAULT_IO 0   
                    PHY_DDR3_CAL_ADDR0 0    
                    PHY_DDR3_CAL_ADDR1 8    
                    PHY_DDR3_CAL_ENABLE_NON_DES 1   
                    PHY_DDR3_USER_AC_IO_STD_ENUM IO_STD_SSTL_15_C1  
                    PHY_DDR3_USER_AC_MODE_ENUM CURRENT_ST_12    
                    PHY_DDR3_USER_AC_SLEW_RATE_ENUM SLEW_RATE_FAST  
                    PHY_DDR3_USER_CK_IO_STD_ENUM IO_STD_SSTL_15_C1  
                    PHY_DDR3_USER_CK_MODE_ENUM CURRENT_ST_12    
                    PHY_DDR3_USER_CK_SLEW_RATE_ENUM SLEW_RATE_FAST  
                    PHY_DDR3_USER_DATA_IO_STD_ENUM IO_STD_SSTL_15   
                    PHY_DDR3_USER_DATA_OUT_MODE_ENUM OUT_OCT_34_CAL 
                    PHY_DDR3_USER_DATA_IN_MODE_ENUM IN_OCT_120_CAL  
                    PHY_DDR3_USER_PLL_REF_CLK_IO_STD_ENUM IO_STD_LVDS   
                    PHY_DDR3_USER_RZQ_IO_STD_ENUM IO_STD_CMOS_15"
if {$early_io_release == 1} {
set_component_param "emif_hps
                    PHY_DDR3_HPS_ENABLE_EARLY_RELEASE 1"
}
set_component_param "emif_hps   
                    MEM_DDR3_FORMAT_ENUM MEM_FORMAT_UDIMM   
                    MEM_DDR3_DQ_WIDTH $hps_sdram_width  
                    MEM_DDR3_DQ_PER_DQS 8   
                    MEM_DDR3_DISCRETE_CS_WIDTH 1    
                    MEM_DDR3_NUM_OF_DIMMS 1 
                    MEM_DDR3_RANKS_PER_DIMM 2   
                    MEM_DDR3_CKE_PER_DIMM 1 
                    MEM_DDR3_CK_WIDTH 1 
                    MEM_DDR3_ROW_ADDR_WIDTH 15  
                    MEM_DDR3_COL_ADDR_WIDTH 10  
                    MEM_DDR3_BANK_ADDR_WIDTH 3  
                    MEM_DDR3_DM_EN 1    
                    MEM_DDR3_MIRROR_ADDRESSING_EN 1 
                    MEM_DDR3_RDIMM_CONFIG 0 
                    MEM_DDR3_LRDIMM_EXTENDED_CONFIG 0x0 
                    MEM_DDR3_ALERT_N_PLACEMENT_ENUM DDR3_ALERT_N_PLACEMENT_AC_LANES 
                    MEM_DDR3_ALERT_N_DQS_GROUP 0    
                    MEM_DDR3_BL_ENUM DDR3_BL_BL8    
                    MEM_DDR3_BT_ENUM DDR3_BT_SEQUENTIAL 
                    MEM_DDR3_ASR_ENUM DDR3_ASR_MANUAL   
                    MEM_DDR3_SRT_ENUM DDR3_SRT_NORMAL   
                    MEM_DDR3_PD_ENUM DDR3_PD_OFF    
                    MEM_DDR3_DRV_STR_ENUM DDR3_DRV_STR_RZQ_7    
                    MEM_DDR3_DLL_EN 1   
                    MEM_DDR3_RTT_NOM_ENUM DDR3_RTT_NOM_ODT_DISABLED 
                    MEM_DDR3_RTT_WR_ENUM DDR3_RTT_WR_RZQ_4  
                    MEM_DDR3_WTCL 8 
                    MEM_DDR3_ATCL_ENUM DDR3_ATCL_DISABLED   
                    MEM_DDR3_TCL 11 
                    MEM_DDR3_USE_DEFAULT_ODT 1  
                    MEM_DDR3_R_ODTN_1X1 {Rank\ 0}   
                    MEM_DDR3_R_ODT0_1X1 off 
                    MEM_DDR3_W_ODTN_1X1 {Rank\ 0}   
                    MEM_DDR3_W_ODT0_1X1 on  
                    MEM_DDR3_R_ODTN_2X2 {Rank\ 0 Rank\ 1}   
                    MEM_DDR3_R_ODT0_2X2 {off off}   
                    MEM_DDR3_R_ODT1_2X2 {off off}   
                    MEM_DDR3_W_ODTN_2X2 {Rank\ 0 Rank\ 1}   
                    MEM_DDR3_W_ODT0_2X2 {on off}    
                    MEM_DDR3_W_ODT1_2X2 {off on}    
                    MEM_DDR3_R_ODTN_4X2 {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}   
                    MEM_DDR3_R_ODT0_4X2 {off off on on} 
                    MEM_DDR3_R_ODT1_4X2 {on on off off} 
                    MEM_DDR3_W_ODTN_4X2 {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}   
                    MEM_DDR3_W_ODT0_4X2 {off off on on}     
                    MEM_DDR3_W_ODT1_4X2 {on on off off} 
                    MEM_DDR3_R_ODTN_4X4 {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}   
                    MEM_DDR3_R_ODT0_4X4 {off off off off}   
                    MEM_DDR3_R_ODT1_4X4 {off off on on} 
                    MEM_DDR3_R_ODT2_4X4 {off off off off}   
                    MEM_DDR3_R_ODT3_4X4 {on on off off} 
                    MEM_DDR3_W_ODTN_4X4 {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}   
                    MEM_DDR3_W_ODT0_4X4 {on on off off} 
                    MEM_DDR3_W_ODT1_4X4 {off off on on} 
                    MEM_DDR3_W_ODT2_4X4 {off off on on} 
                    MEM_DDR3_W_ODT3_4X4 {on on off off} 
                    MEM_DDR3_SPEEDBIN_ENUM DDR3_SPEEDBIN_1866   
                    MEM_DDR3_TIS_PS 65  
                    MEM_DDR3_TIS_AC_MV 135  
                    MEM_DDR3_TIH_PS 100 
                    MEM_DDR3_TIH_DC_MV 100  
                    MEM_DDR3_TDS_PS 68  
                    MEM_DDR3_TDS_AC_MV 135  
                    MEM_DDR3_TDH_PS 70  
                    MEM_DDR3_TDH_DC_MV 100  
                    MEM_DDR3_TDQSQ_PS 85    
                    MEM_DDR3_TQH_CYC 0.38   
                    MEM_DDR3_TDQSCK_PS 195  
                    MEM_DDR3_TDQSS_CYC 0.27 
                    MEM_DDR3_TQSH_CYC 0.4   
                    MEM_DDR3_TDSH_CYC 0.18  
                    MEM_DDR3_TWLS_PS 140.0  
                    MEM_DDR3_TWLH_PS 140.0  
                    MEM_DDR3_TDSS_CYC 0.18  
                    MEM_DDR3_TINIT_US 500   
                    MEM_DDR3_TMRD_CK_CYC 4  
                    MEM_DDR3_TRAS_NS 34.0   
                    MEM_DDR3_TRCD_NS 13.91  
                    MEM_DDR3_TRP_NS 13.91   
                    MEM_DDR3_TREFI_US 7.8   
                    MEM_DDR3_TRFC_NS 350.0  
                    MEM_DDR3_TWR_NS 15.0    
                    MEM_DDR3_TWTR_CYC 6 
                    MEM_DDR3_TFAW_NS 30.0   
                    MEM_DDR3_TRRD_CYC 4 
                    MEM_DDR3_TRTP_CYC 6 
                    BOARD_DDR3_USE_DEFAULT_SLEW_RATES 1 
                    BOARD_DDR3_USE_DEFAULT_ISI_VALUES 1 
                    BOARD_DDR3_USER_CK_SLEW_RATE 4.0    
                    BOARD_DDR3_USER_AC_SLEW_RATE 2.0    
                    BOARD_DDR3_USER_RCLK_SLEW_RATE 5.0  
                    BOARD_DDR3_USER_WCLK_SLEW_RATE 4.0  
                    BOARD_DDR3_USER_RDATA_SLEW_RATE 2.5 
                    BOARD_DDR3_USER_WDATA_SLEW_RATE 2.0 
                    BOARD_DDR3_USER_AC_ISI_NS 0.0   
                    BOARD_DDR3_USER_RCLK_ISI_NS 0.0 
                    BOARD_DDR3_USER_WCLK_ISI_NS 0.0 
                    BOARD_DDR3_USER_RDATA_ISI_NS 0.0    
                    BOARD_DDR3_USER_WDATA_ISI_NS 0.0    
                    BOARD_DDR3_IS_SKEW_WITHIN_DQS_DESKEWED 0    
                    BOARD_DDR3_BRD_SKEW_WITHIN_DQS_NS 0.02  
                    BOARD_DDR3_PKG_BRD_SKEW_WITHIN_DQS_NS 0.02  
                    BOARD_DDR3_IS_SKEW_WITHIN_AC_DESKEWED 1 
                    BOARD_DDR3_BRD_SKEW_WITHIN_AC_NS 0.02   
                    BOARD_DDR3_PKG_BRD_SKEW_WITHIN_AC_NS 0.02   
                    BOARD_DDR3_DQS_TO_CK_SKEW_NS 0.02   
                    BOARD_DDR3_SKEW_BETWEEN_DIMMS_NS 0.05   
                    BOARD_DDR3_SKEW_BETWEEN_DQS_NS 0.02 
                    BOARD_DDR3_AC_TO_CK_SKEW_NS 0.0 
                    BOARD_DDR3_MAX_CK_DELAY_NS 0.6  
                    BOARD_DDR3_MAX_DQS_DELAY_NS 0.6 
                    CTRL_DDR3_AVL_PROTOCOL_ENUM CTRL_AVL_PROTOCOL_ST    
                    CTRL_DDR3_SELF_REFRESH_EN 0 
                    CTRL_DDR3_AUTO_POWER_DOWN_EN 0  
                    CTRL_DDR3_AUTO_POWER_DOWN_CYCS 32   
                    CTRL_DDR3_USER_REFRESH_EN 0 
                    CTRL_DDR3_USER_PRIORITY_EN 0    
                    CTRL_DDR3_AUTO_PRECHARGE_EN 0   
                    CTRL_DDR3_ADDR_ORDER_ENUM DDR3_CTRL_ADDR_ORDER_CS_R_B_C 
                    CTRL_DDR3_ECC_EN $hps_sdram_ecc 
                    CTRL_DDR3_ECC_AUTO_CORRECTION_EN $hps_sdram_ecc 
                    CTRL_DDR3_REORDER_EN 1  
                    CTRL_DDR3_STARVE_LIMIT 10   
                    CTRL_DDR3_MMR_EN $hps_sdram_ecc 
                    CTRL_DDR3_RD_TO_WR_SAME_CHIP_DELTA_CYCS 0   
                    CTRL_DDR3_WR_TO_RD_SAME_CHIP_DELTA_CYCS 0   
                    CTRL_DDR3_RD_TO_RD_DIFF_CHIP_DELTA_CYCS 0   
                    CTRL_DDR3_RD_TO_WR_DIFF_CHIP_DELTA_CYCS 0   
                    CTRL_DDR3_WR_TO_WR_DIFF_CHIP_DELTA_CYCS 0   
                    CTRL_DDR3_WR_TO_RD_DIFF_CHIP_DELTA_CYCS 0   
                    DIAG_DDR3_SIM_CAL_MODE_ENUM SIM_CAL_MODE_SKIP   
                    DIAG_DDR3_EXPORT_SEQ_AVALON_SLAVE CAL_DEBUG_EXPORT_MODE_DISABLED    
                    DIAG_DDR3_EXPORT_SEQ_AVALON_MASTER 0    
                    DIAG_DDR3_EX_DESIGN_NUM_OF_SLAVES 1 
                    DIAG_DDR3_INTERFACE_ID 0    
                    DIAG_DDR3_EFFICIENCY_MONITOR EFFMON_MODE_DISABLED   
                    DIAG_DDR3_USE_TG_AVL_2 0    
                    DIAG_DDR3_CA_LEVEL_EN 0"
} elseif {$hps_sdram == "D9PZN"} { 
# single rank DDR3 -2133
add_component_param "altera_emif_a10_hps emif_hps 
                     IP_FILE_PATH ip/$qsys_name/emif_hps.ip 
                    PROTOCOL_ENUM PROTOCOL_DDR3
                    IS_ED_SLAVE 0   
                    INTERNAL_TESTING_MODE 0 
                    PLL_ADD_EXTRA_CLKS 0    
                    PLL_USER_NUM_OF_EXTRA_CLKS 0    
                    PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_0 0  
                    PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_1 0  
                    PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_2 0  
                    PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_3 0  
                    PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_4 0  
                    PLL_EXTRA_CLK_DESIRED_FREQ_MHZ_GUI_5 100.0  
                    PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_5 100.0   
                    PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_5 0  
                    PLL_EXTRA_CLK_DESIRED_PHASE_GUI_5 0.0   
                    PLL_EXTRA_CLK_ACTUAL_PHASE_PS_GUI_5 0.0 
                    PLL_EXTRA_CLK_ACTUAL_PHASE_DEG_GUI_5 0.0    
                    PLL_EXTRA_CLK_DESIRED_DUTY_CYCLE_GUI_5 50.0 
                    PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_GUI_5 50.0
                    PLL_EXTRA_CLK_DESIRED_FREQ_MHZ_GUI_6 100.0  
                    PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_6 100.0   
                    PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_6 0  
                    PLL_EXTRA_CLK_DESIRED_PHASE_GUI_6 0.0   
                    PLL_EXTRA_CLK_ACTUAL_PHASE_PS_GUI_6 0.0 
                    PLL_EXTRA_CLK_ACTUAL_PHASE_DEG_GUI_6 0.0    
                    PLL_EXTRA_CLK_DESIRED_DUTY_CYCLE_GUI_6 50.0 
                    PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_GUI_6 50.0
                    PLL_EXTRA_CLK_DESIRED_FREQ_MHZ_GUI_7 100.0  
                    PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_7 100.0   
                    PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_7 0  
                    PLL_EXTRA_CLK_DESIRED_PHASE_GUI_7 0.0   
                    PLL_EXTRA_CLK_ACTUAL_PHASE_PS_GUI_7 0.0 
                    PLL_EXTRA_CLK_ACTUAL_PHASE_DEG_GUI_7 0.0    
                    PLL_EXTRA_CLK_DESIRED_DUTY_CYCLE_GUI_7 50.0 
                    PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_GUI_7 50.0
                    PLL_EXTRA_CLK_DESIRED_FREQ_MHZ_GUI_8 100.0  
                    PLL_EXTRA_CLK_ACTUAL_FREQ_MHZ_GUI_8 100.0   
                    PLL_EXTRA_CLK_PHASE_SHIFT_UNIT_GUI_8 0  
                    PLL_EXTRA_CLK_DESIRED_PHASE_GUI_8 0.0   
                    PLL_EXTRA_CLK_ACTUAL_PHASE_PS_GUI_8 0.0 
                    PLL_EXTRA_CLK_ACTUAL_PHASE_DEG_GUI_8 0.0    
                    PLL_EXTRA_CLK_DESIRED_DUTY_CYCLE_GUI_8 50.0 
                    PLL_EXTRA_CLK_ACTUAL_DUTY_CYCLE_GUI_8 50.0  
                    PHY_DDR3_CONFIG_ENUM CONFIG_PHY_AND_HARD_CTRL   
                    PHY_DDR3_USER_PING_PONG_EN 0    
                    PHY_DDR3_MEM_CLK_FREQ_MHZ 1066.667
                    PHY_DDR3_DEFAULT_REF_CLK_FREQ 0 
                    PHY_DDR3_USER_REF_CLK_FREQ_MHZ 133.333  
                    PHY_DDR3_REF_CLK_JITTER_PS 10.0 
                    PHY_DDR3_RATE_ENUM RATE_HALF    
                    PHY_DDR3_CORE_CLKS_SHARING_ENUM CORE_CLKS_SHARING_DISABLED  
                    PHY_DDR3_IO_VOLTAGE 1.5 
                    PHY_DDR3_DEFAULT_IO 0   
                    PHY_DDR3_CAL_ADDR0 0    
                    PHY_DDR3_CAL_ADDR1 8    
                    PHY_DDR3_CAL_ENABLE_NON_DES 1   
                    PHY_DDR3_USER_AC_IO_STD_ENUM IO_STD_SSTL_15_C1  
                    PHY_DDR3_USER_AC_MODE_ENUM CURRENT_ST_12    
                    PHY_DDR3_USER_AC_SLEW_RATE_ENUM SLEW_RATE_FAST  
                    PHY_DDR3_USER_CK_IO_STD_ENUM IO_STD_SSTL_15_C1  
                    PHY_DDR3_USER_CK_MODE_ENUM CURRENT_ST_12    
                    PHY_DDR3_USER_CK_SLEW_RATE_ENUM SLEW_RATE_FAST  
                    PHY_DDR3_USER_DATA_IO_STD_ENUM IO_STD_SSTL_15   
                    PHY_DDR3_USER_DATA_OUT_MODE_ENUM OUT_OCT_34_CAL 
                    PHY_DDR3_USER_DATA_IN_MODE_ENUM IN_OCT_120_CAL  
                    PHY_DDR3_USER_PLL_REF_CLK_IO_STD_ENUM IO_STD_LVDS   
                    PHY_DDR3_USER_RZQ_IO_STD_ENUM IO_STD_CMOS_15"
if {$early_io_release == 1} {
set_component_param "emif_hps
                    PHY_DDR3_HPS_ENABLE_EARLY_RELEASE 1"
}
set_component_param "emif_hps   
                    MEM_DDR3_FORMAT_ENUM MEM_FORMAT_UDIMM   
                    MEM_DDR3_DQ_WIDTH $hps_sdram_width  
                    MEM_DDR3_DQ_PER_DQS 8   
                    MEM_DDR3_DISCRETE_CS_WIDTH 1    
                    MEM_DDR3_NUM_OF_DIMMS 1 
                    MEM_DDR3_RANKS_PER_DIMM 2   
                    MEM_DDR3_CKE_PER_DIMM 1 
                    MEM_DDR3_CK_WIDTH 1 
                    MEM_DDR3_ROW_ADDR_WIDTH 15  
                    MEM_DDR3_COL_ADDR_WIDTH 10  
                    MEM_DDR3_BANK_ADDR_WIDTH 3  
                    MEM_DDR3_DM_EN 1    
                    MEM_DDR3_MIRROR_ADDRESSING_EN 1 
                    MEM_DDR3_RDIMM_CONFIG 0 
                    MEM_DDR3_LRDIMM_EXTENDED_CONFIG 0x0 
                    MEM_DDR3_ALERT_N_PLACEMENT_ENUM DDR3_ALERT_N_PLACEMENT_AC_LANES 
                    MEM_DDR3_ALERT_N_DQS_GROUP 0    
                    MEM_DDR3_BL_ENUM DDR3_BL_BL8    
                    MEM_DDR3_BT_ENUM DDR3_BT_SEQUENTIAL 
                    MEM_DDR3_ASR_ENUM DDR3_ASR_MANUAL   
                    MEM_DDR3_SRT_ENUM DDR3_SRT_NORMAL   
                    MEM_DDR3_PD_ENUM DDR3_PD_OFF    
                    MEM_DDR3_DRV_STR_ENUM DDR3_DRV_STR_RZQ_7    
                    MEM_DDR3_DLL_EN 1   
                    MEM_DDR3_RTT_NOM_ENUM DDR3_RTT_NOM_ODT_DISABLED 
                    MEM_DDR3_RTT_WR_ENUM DDR3_RTT_WR_RZQ_4  
                    MEM_DDR3_WTCL 10    
                    MEM_DDR3_ATCL_ENUM DDR3_ATCL_DISABLED   
                    MEM_DDR3_TCL 14 
                    MEM_DDR3_USE_DEFAULT_ODT 1  
                    MEM_DDR3_R_ODTN_1X1 {Rank\ 0}   
                    MEM_DDR3_R_ODT0_1X1 off 
                    MEM_DDR3_W_ODTN_1X1 {Rank\ 0}   
                    MEM_DDR3_W_ODT0_1X1 on  
                    MEM_DDR3_R_ODTN_2X2 {Rank\ 0 Rank\ 1}   
                    MEM_DDR3_R_ODT0_2X2 {off off}   
                    MEM_DDR3_R_ODT1_2X2 {off off}   
                    MEM_DDR3_W_ODTN_2X2 {Rank\ 0 Rank\ 1}   
                    MEM_DDR3_W_ODT0_2X2 {on off}    
                    MEM_DDR3_W_ODT1_2X2 {off on}    
                    MEM_DDR3_R_ODTN_4X2 {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}   
                    MEM_DDR3_R_ODT0_4X2 {off off on on} 
                    MEM_DDR3_R_ODT1_4X2 {on on off off} 
                    MEM_DDR3_W_ODTN_4X2 {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}   
                    MEM_DDR3_W_ODT0_4X2 {off off on on}     
                    MEM_DDR3_W_ODT1_4X2 {on on off off} 
                    MEM_DDR3_R_ODTN_4X4 {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}   
                    MEM_DDR3_R_ODT0_4X4 {off off off off}   
                    MEM_DDR3_R_ODT1_4X4 {off off on on} 
                    MEM_DDR3_R_ODT2_4X4 {off off off off}   
                    MEM_DDR3_R_ODT3_4X4 {on on off off} 
                    MEM_DDR3_W_ODTN_4X4 {Rank\ 0 Rank\ 1 Rank\ 2 Rank\ 3}   
                    MEM_DDR3_W_ODT0_4X4 {on on off off} 
                    MEM_DDR3_W_ODT1_4X4 {off off on on} 
                    MEM_DDR3_W_ODT2_4X4 {off off on on} 
                    MEM_DDR3_W_ODT3_4X4 {on on off off} 
                    MEM_DDR3_SPEEDBIN_ENUM DDR3_SPEEDBIN_2133   
                    MEM_DDR3_TIS_PS 60  
                    MEM_DDR3_TIS_AC_MV 135  
                    MEM_DDR3_TIH_PS 95  
                    MEM_DDR3_TIH_DC_MV 100  
                    MEM_DDR3_TDS_PS 53  
                    MEM_DDR3_TDS_AC_MV 135  
                    MEM_DDR3_TDH_PS 55  
                    MEM_DDR3_TDH_DC_MV 100  
                    MEM_DDR3_TDQSQ_PS 75    
                    MEM_DDR3_TQH_CYC 0.38   
                    MEM_DDR3_TDQSCK_PS 180  
                    MEM_DDR3_TDQSS_CYC 0.27 
                    MEM_DDR3_TQSH_CYC 0.4   
                    MEM_DDR3_TDSH_CYC 0.18  
                    MEM_DDR3_TWLS_PS 125.0  
                    MEM_DDR3_TWLH_PS 125.0  
                    MEM_DDR3_TDSS_CYC 0.18  
                    MEM_DDR3_TINIT_US 500   
                    MEM_DDR3_TMRD_CK_CYC 4  
                    MEM_DDR3_TRAS_NS 33.0   
                    MEM_DDR3_TRCD_NS 13.13  
                    MEM_DDR3_TRP_NS 13.13   
                    MEM_DDR3_TREFI_US 7.8   
                    MEM_DDR3_TRFC_NS 260.0  
                    MEM_DDR3_TWR_NS 15.0    
                    MEM_DDR3_TWTR_CYC 8 
                    MEM_DDR3_TFAW_NS 35.0   
                    MEM_DDR3_TRRD_CYC 6 
                    MEM_DDR3_TRTP_CYC 8 
                    BOARD_DDR3_USE_DEFAULT_SLEW_RATES 1 
                    BOARD_DDR3_USE_DEFAULT_ISI_VALUES 1 
                    BOARD_DDR3_USER_CK_SLEW_RATE 4.0    
                    BOARD_DDR3_USER_AC_SLEW_RATE 2.0    
                    BOARD_DDR3_USER_RCLK_SLEW_RATE 5.0  
                    BOARD_DDR3_USER_WCLK_SLEW_RATE 4.0  
                    BOARD_DDR3_USER_RDATA_SLEW_RATE 2.5 
                    BOARD_DDR3_USER_WDATA_SLEW_RATE 2.0 
                    BOARD_DDR3_USER_AC_ISI_NS 0.0   
                    BOARD_DDR3_USER_RCLK_ISI_NS 0.0 
                    BOARD_DDR3_USER_WCLK_ISI_NS 0.0 
                    BOARD_DDR3_USER_RDATA_ISI_NS 0.0    
                    BOARD_DDR3_USER_WDATA_ISI_NS 0.0    
                    BOARD_DDR3_IS_SKEW_WITHIN_DQS_DESKEWED 0    
                    BOARD_DDR3_BRD_SKEW_WITHIN_DQS_NS 0.02  
                    BOARD_DDR3_PKG_BRD_SKEW_WITHIN_DQS_NS 0.02  
                    BOARD_DDR3_IS_SKEW_WITHIN_AC_DESKEWED 1 
                    BOARD_DDR3_BRD_SKEW_WITHIN_AC_NS 0.02   
                    BOARD_DDR3_PKG_BRD_SKEW_WITHIN_AC_NS 0.02   
                    BOARD_DDR3_DQS_TO_CK_SKEW_NS 0.02   
                    BOARD_DDR3_SKEW_BETWEEN_DIMMS_NS 0.05   
                    BOARD_DDR3_SKEW_BETWEEN_DQS_NS 0.02 
                    BOARD_DDR3_AC_TO_CK_SKEW_NS 0.0 
                    BOARD_DDR3_MAX_CK_DELAY_NS 0.6  
                    BOARD_DDR3_MAX_DQS_DELAY_NS 0.6 
                    CTRL_DDR3_AVL_PROTOCOL_ENUM CTRL_AVL_PROTOCOL_ST    
                    CTRL_DDR3_SELF_REFRESH_EN 0 
                    CTRL_DDR3_AUTO_POWER_DOWN_EN 0  
                    CTRL_DDR3_AUTO_POWER_DOWN_CYCS 32   
                    CTRL_DDR3_USER_REFRESH_EN 0 
                    CTRL_DDR3_USER_PRIORITY_EN 0    
                    CTRL_DDR3_AUTO_PRECHARGE_EN 0   
                    CTRL_DDR3_ADDR_ORDER_ENUM DDR3_CTRL_ADDR_ORDER_CS_R_B_C 
                    CTRL_DDR3_ECC_EN $hps_sdram_ecc 
                    CTRL_DDR3_ECC_AUTO_CORRECTION_EN $hps_sdram_ecc 
                    CTRL_DDR3_REORDER_EN 1  
                    CTRL_DDR3_STARVE_LIMIT 10   
                    CTRL_DDR3_MMR_EN $hps_sdram_ecc 
                    CTRL_DDR3_RD_TO_WR_SAME_CHIP_DELTA_CYCS 0   
                    CTRL_DDR3_WR_TO_RD_SAME_CHIP_DELTA_CYCS 0   
                    CTRL_DDR3_RD_TO_RD_DIFF_CHIP_DELTA_CYCS 0   
                    CTRL_DDR3_RD_TO_WR_DIFF_CHIP_DELTA_CYCS 0   
                    CTRL_DDR3_WR_TO_WR_DIFF_CHIP_DELTA_CYCS 0   
                    CTRL_DDR3_WR_TO_RD_DIFF_CHIP_DELTA_CYCS 0   
                    DIAG_DDR3_SIM_CAL_MODE_ENUM SIM_CAL_MODE_SKIP   
                    DIAG_DDR3_EXPORT_SEQ_AVALON_SLAVE CAL_DEBUG_EXPORT_MODE_DISABLED    
                    DIAG_DDR3_EXPORT_SEQ_AVALON_MASTER 0    
                    DIAG_DDR3_EX_DESIGN_NUM_OF_SLAVES 1 
                    DIAG_DDR3_INTERFACE_ID 0    
                    DIAG_DDR3_EFFICIENCY_MONITOR EFFMON_MODE_DISABLED   
                    DIAG_DDR3_USE_TG_AVL_2 0    
                    DIAG_DDR3_CA_LEVEL_EN 0"
} elseif {$hps_sdram == "D9RGX"} {
# DDR4 single rank -2133
set_validation_property AUTOMATIC_VALIDATION false
add_component_param "altera_emif_a10_hps emif_hps 
                     IP_FILE_PATH ip/$qsys_name/emif_hps.ip 
                    PROTOCOL_ENUM PROTOCOL_DDR4
                    MEM_DDR4_DQ_WIDTH $hps_sdram_width  
                    MEM_DDR4_ALERT_N_PLACEMENT_ENUM DDR4_ALERT_N_PLACEMENT_DATA_LANES   
                    MEM_DDR4_ALERT_N_DQS_GROUP 3    
                    DIAG_DDR4_SKIP_CA_LEVEL 1   
                    MEM_DDR4_RTT_NOM_ENUM DDR4_RTT_NOM_RZQ_6    
                    PHY_DDR4_USER_REF_CLK_FREQ_MHZ 133.333  
                    PHY_DDR4_DEFAULT_REF_CLK_FREQ 0 
                    CTRL_DDR4_ECC_EN $hps_sdram_ecc 
                    CTRL_DDR4_ECC_AUTO_CORRECTION_EN $hps_sdram_ecc 
                    CTRL_DDR4_MMR_EN $hps_sdram_ecc 
                    PHY_DDR4_DEFAULT_IO 0   
                    PHY_DDR4_USER_DATA_IN_MODE_ENUM IN_OCT_60_CAL   
                    PHY_DDR4_MEM_CLK_FREQ_MHZ 1066.667"
if {$early_io_release == 1} {
set_component_param "emif_hps
                    PHY_DDR4_HPS_ENABLE_EARLY_RELEASE 1"
}
set_component_param "emif_hps
                    MEM_DDR4_SPEEDBIN_ENUM DDR4_SPEEDBIN_2666
                    MEM_DDR4_BANK_GROUP_WIDTH 1"
### 3 settings for 15.1 to 16.1
# set_instance_parameter_value emif_hps {MEM_DDR4_TDIVW_TOTAL_UI} {0.2}
# set_instance_parameter_value emif_hps {MEM_DDR4_TDQSQ_UI} {0.16}
# set_instance_parameter_value emif_hps {MEM_DDR4_TQH_UI} {0.76}
# set_instance_parameter_value emif_hps {MEM_DDR4_TCL} {20}
# set_instance_parameter_value emif_hps {MEM_DDR4_WTCL} {18}
# set_instance_parameter_value emif_hps {MEM_DDR4_TRCD_NS} {14.25}
# set_instance_parameter_value emif_hps {MEM_DDR4_TRP_NS} {14.25}
# set_instance_parameter_value emif_hps {MEM_DDR4_TWTR_L_CYC} {10}
# set_instance_parameter_value emif_hps {MEM_DDR4_TWTR_S_CYC} {4}
# set_instance_parameter_value emif_hps {MEM_DDR4_TRRD_L_CYC} {8}
# set_instance_parameter_value emif_hps {MEM_DDR4_TRRD_S_CYC} {7}
### 3 setting for 15.0
# set_instance_parameter_value emif_hps {MEM_DDR4_TDIVW_DJ_CYC} {0.1}
# set_instance_parameter_value emif_hps {MEM_DDR4_TDQSQ_PS} {66}
# set_instance_parameter_value emif_hps {MEM_DDR4_TQH_CYC} {0.38}
#---------------------------
set_component_param "emif_hps
                    MEM_DDR4_SPEEDBIN_ENUM DDR4_SPEEDBIN_2666
                    MEM_DDR4_TFAW_NS 30.0
                    MEM_DDR4_TCL 16
                    MEM_DDR4_WTCL 11
                    MEM_DDR4_TIS_PS 50
                    MEM_DDR4_TIH_PS 75
                    MEM_DDR4_TDIVW_TOTAL_UI 0.23
                    MEM_DDR4_VDIVW_TOTAL 110
                    MEM_DDR4_TDQSQ_UI 0.19
                    MEM_DDR4_TQH_UI 0.71
                    MEM_DDR4_TDQSCK_PS 160
                    MEM_DDR4_TQSH_CYC 0.46
                    MEM_DDR4_TMRD_CK_CYC 10
                    MEM_DDR4_TRCD_NS 12.5
                    MEM_DDR4_TRP_NS 12.5
                    MEM_DDR4_TWTR_L_CYC 8
                    MEM_DDR4_TWTR_S_CYC 3
                    MEM_DDR4_TRRD_L_CYC 7
                    MEM_DDR4_TRRD_S_CYC 6
                    PHY_DDR4_USER_AC_IO_STD_ENUM IO_STD_SSTL_12
                    PHY_DDR4_USER_CK_IO_STD_ENUM IO_STD_SSTL_12
                    PHY_DDR4_USER_DATA_IO_STD_ENUM IO_STD_POD_12
                    PHY_DDR4_USER_AC_MODE_ENUM OUT_OCT_40_CAL
                    PHY_DDR4_USER_CK_MODE_ENUM OUT_OCT_40_CAL
                    PHY_DDR4_USER_DATA_OUT_MODE_ENUM OUT_OCT_34_CAL
                    PHY_DDR4_USER_PLL_REF_CLK_IO_STD_ENUM IO_STD_LVDS
                    PHY_DDR4_USER_RZQ_IO_STD_ENUM IO_STD_CMOS_12"
set_validation_property AUTOMATIC_VALIDATION true
} elseif {$hps_sdram == "D9TNZ"} {
# DDR4 single rank -2666
add_component_param "altera_emif_a10_hps emif_hps 
                     IP_FILE_PATH ip/$qsys_name/emif_hps.ip 
                    PROTOCOL_ENUM PROTOCOL_DDR4
                    MEM_DDR4_DQ_WIDTH $hps_sdram_width  
                    MEM_DDR4_ALERT_N_PLACEMENT_ENUM DDR4_ALERT_N_PLACEMENT_DATA_LANES   
                    MEM_DDR4_ALERT_N_DQS_GROUP 3    
                    DIAG_DDR4_SKIP_CA_LEVEL 1   
                    MEM_DDR4_RTT_NOM_ENUM DDR4_RTT_NOM_RZQ_6    
                    PHY_DDR4_USER_REF_CLK_FREQ_MHZ 133.333  
                    PHY_DDR4_DEFAULT_REF_CLK_FREQ 0 
                    CTRL_DDR4_ECC_EN $hps_sdram_ecc 
                    CTRL_DDR4_ECC_AUTO_CORRECTION_EN $hps_sdram_ecc 
                    CTRL_DDR4_MMR_EN $hps_sdram_ecc 
                    PHY_DDR4_DEFAULT_IO 0   
                    PHY_DDR4_USER_DATA_IN_MODE_ENUM IN_OCT_60_CAL   
                    PHY_DDR4_MEM_CLK_FREQ_MHZ 1066.667  
                    MEM_DDR4_TCL 20
                    MEM_DDR4_WTCL 16
                    MEM_DDR4_ROW_ADDR_WIDTH 15"
set_validation_property AUTOMATIC_VALIDATION false
if {$early_io_release == 1} {
set_component_param "emif_hps
                    PHY_DDR4_HPS_ENABLE_EARLY_RELEASE 1"
}
set_component_param "emif_hps
                    MEM_DDR4_SPEEDBIN_ENUM DDR4_SPEEDBIN_2666
                    MEM_DDR4_BANK_GROUP_WIDTH 1
                    MEM_DDR4_TIS_PS 55
                    MEM_DDR4_TIH_PS 75
                    MEM_DDR4_TDIVW_TOTAL_UI 0.22
                    MEM_DDR4_VDIVW_TOTAL 120
                    MEM_DDR4_TDQSQ_UI 0.18
                    MEM_DDR4_TQH_UI 0.74
                    MEM_DDR4_TDQSCK_PS 170
                    MEM_DDR4_TQSH_CYC 0.4
                    MEM_DDR4_TMRD_CK_CYC 8
                    MEM_DDR4_TRCD_NS 13.5
                    MEM_DDR4_TRP_NS 13.5
                    MEM_DDR4_TWTR_L_CYC 10
                    MEM_DDR4_TWTR_S_CYC 4
                    MEM_DDR4_TRRD_L_CYC 7
                    MEM_DDR4_TRRD_S_CYC 6
                    PHY_DDR4_USER_AC_IO_STD_ENUM IO_STD_SSTL_12
                    PHY_DDR4_USER_CK_IO_STD_ENUM IO_STD_SSTL_12
                    PHY_DDR4_USER_DATA_IO_STD_ENUM IO_STD_POD_12
                    PHY_DDR4_USER_AC_MODE_ENUM OUT_OCT_40_CAL
                    PHY_DDR4_USER_CK_MODE_ENUM OUT_OCT_40_CAL
                    PHY_DDR4_USER_DATA_OUT_MODE_ENUM OUT_OCT_34_CAL
                    PHY_DDR4_USER_PLL_REF_CLK_IO_STD_ENUM IO_STD_LVDS
                    PHY_DDR4_USER_RZQ_IO_STD_ENUM IO_STD_CMOS_12"
## The density-dependent refresh parameter has to be reduced to match 8Gbit density. Without it, accesses to memory conducted will fail deterministically.
set_component_param "emif_hps
                    MEM_DDR4_TRFC_NS 350.0
                    MEM_DDR4_TFAW_NS 30.0"
set_validation_property AUTOMATIC_VALIDATION true
} elseif {$hps_sdram == "D9WFH"} {
# DDR4 single rank -2666
add_component_param "altera_emif_a10_hps emif_hps
                     IP_FILE_PATH ip/$qsys_name/emif_hps.ip
                    PROTOCOL_ENUM PROTOCOL_DDR4
                    MEM_DDR4_DQ_WIDTH $hps_sdram_width
                    MEM_DDR4_ALERT_N_PLACEMENT_ENUM DDR4_ALERT_N_PLACEMENT_DATA_LANES
                    MEM_DDR4_ALERT_N_DQS_GROUP 3
                    DIAG_DDR4_SKIP_CA_LEVEL 1
                    MEM_DDR4_RTT_NOM_ENUM DDR4_RTT_NOM_RZQ_6
                    PHY_DDR4_USER_REF_CLK_FREQ_MHZ 133.333
                    PHY_DDR4_DEFAULT_REF_CLK_FREQ 0
                    CTRL_DDR4_ECC_EN $hps_sdram_ecc
                    CTRL_DDR4_ECC_AUTO_CORRECTION_EN $hps_sdram_ecc
                    CTRL_DDR4_MMR_EN $hps_sdram_ecc
                    PHY_DDR4_DEFAULT_IO 0
                    PHY_DDR4_USER_DATA_IN_MODE_ENUM IN_OCT_60_CAL
                    PHY_DDR4_MEM_CLK_FREQ_MHZ 1066.667
                    MEM_DDR4_TCL 20
                    MEM_DDR4_WTCL 16
                    MEM_DDR4_ROW_ADDR_WIDTH 15"
set_validation_property AUTOMATIC_VALIDATION false
if {$early_io_release == 1} {
set_component_param "emif_hps
                    PHY_DDR4_HPS_ENABLE_EARLY_RELEASE 1"
}
set_component_param "emif_hps
                    MEM_DDR4_SPEEDBIN_ENUM DDR4_SPEEDBIN_2666
                    MEM_DDR4_BANK_GROUP_WIDTH 1
                    MEM_DDR4_TIS_PS 55
                    MEM_DDR4_TIH_PS 80
                    MEM_DDR4_TDIVW_TOTAL_UI 0.22
                    MEM_DDR4_VDIVW_TOTAL 120
                    MEM_DDR4_TDQSQ_UI 0.18
                    MEM_DDR4_TQH_UI 0.74
                    MEM_DDR4_TDVWP_UI 0.72
                    MEM_DDR4_TDQSCK_PS 170
                    MEM_DDR4_TDQSS_CYC 0.27
                    MEM_DDR4_TQSH_CYC 0.4
                    MEM_DDR4_TDSH_CYC 0.18
                    MEM_DDR4_TDSS_CYC 0.18
                    MEM_DDR4_TWLS_CYC 0.13
                    MEM_DDR4_TWLH_CYC 0.13
                    MEM_DDR4_TINIT_US 500
                    MEM_DDR4_TMRD_CK_CYC 8
                    MEM_DDR4_TRAS_NS 32
                    MEM_DDR4_TRCD_NS 14.25
                    MEM_DDR4_TRP_NS 14.25
                    MEM_DDR4_TWR_NS 15
                    MEM_DDR4_TRRD_S_CYC 7
                    MEM_DDR4_TRRD_L_CYC 8
                    MEM_DDR4_TFAW_NS 30.0
                    MEM_DDR4_TCCD_S_CYC 4
                    MEM_DDR4_TCCD_L_CYC 6
                    MEM_DDR4_TWTR_S_CYC 3
                    MEM_DDR4_TWTR_L_CYC 9
                    PHY_DDR4_USER_AC_IO_STD_ENUM IO_STD_SSTL_12
                    PHY_DDR4_USER_CK_IO_STD_ENUM IO_STD_SSTL_12
                    PHY_DDR4_USER_DATA_IO_STD_ENUM IO_STD_POD_12
                    PHY_DDR4_USER_AC_MODE_ENUM OUT_OCT_40_CAL
                    PHY_DDR4_USER_CK_MODE_ENUM OUT_OCT_40_CAL
                    PHY_DDR4_USER_DATA_OUT_MODE_ENUM OUT_OCT_34_CAL
                    PHY_DDR4_USER_PLL_REF_CLK_IO_STD_ENUM IO_STD_LVDS
                    PHY_DDR4_USER_RZQ_IO_STD_ENUM IO_STD_CMOS_12"
## The density-dependent refresh parameter has to be reduced to match 8Gbit density. Without it, accesses to memory conducted will fail deterministically.
set_component_param "emif_hps
                    MEM_DDR4_TRFC_NS 350.0
                    MEM_DDR4_TREFI_US 7.8
                    "
set_validation_property AUTOMATIC_VALIDATION true
} else {
# No valid SDRAM device selected
}

if {$fast_trace == 1} {
add_component_param "altera_trace_wrapper trace_wrapper_0 
                     IP_FILE_PATH ip/$qsys_name/trace_wrapper_0.ip  
                    IN_DWIDTH 32
                    NUM_PIPELINE_REG 1"
}

add_component_param "altera_jtag_avalon_master hps_m 
                     IP_FILE_PATH ip/$qsys_name/hps_m.ip"

add_component_param "altera_jtag_avalon_master fpga_m 
                     IP_FILE_PATH ip/$qsys_name/fpga_m.ip"                   
                     
add_component_param "altera_avalon_mm_bridge pb_lwh2f 
                     IP_FILE_PATH ip/$qsys_name/pb_lwh2f.ip 
                    DATA_WIDTH 32
                    ADDRESS_WIDTH 20
                    USE_AUTO_ADDRESS_WIDTH 1
                    MAX_BURST_SIZE 1
                    MAX_PENDING_RESPONSES 1"

add_component_param "altera_avalon_sysid_qsys sys_id 
                     IP_FILE_PATH ip/$qsys_name/sys_id.ip   
                    id $SYSID"

add_component_param "altera_avalon_pio led_pio 
                     IP_FILE_PATH ip/$qsys_name/led_pio.ip  
                    direction InOut
                    resetValue 0.0
                    width 4"

add_component_param "altera_avalon_pio button_pio 
                     IP_FILE_PATH ip/$qsys_name/button_pio.ip   
                    bitClearingEdgeCapReg 1
                    captureEdge 1   
                    direction Input
                    edgeType FALLING    
                    generateIRQ 1
                    irqType EDGE    
                    resetValue 0.0
                    width 4"
                    
add_component_param "altera_avalon_pio dipsw_pio 
                     IP_FILE_PATH ip/$qsys_name/dipsw_pio.ip    
                    bitClearingEdgeCapReg 1
                    captureEdge 1   
                    direction Input
                    edgeType ANY    
                    generateIRQ 1
                    irqType EDGE    
                    resetValue 0.0
                    width 4"

if {$fpga_pcie == 0 && $fpga_tse == 0} {
add_component_param "altera_jtag_avalon_master f2sdram2_m 
                     IP_FILE_PATH ip/$qsys_name/f2sdram2_m.ip"
}


if {$fpga_dp == 0 || $frame_buffer == 0} {
add_component_param "altera_jtag_avalon_master f2sdram0_m 
                     IP_FILE_PATH ip/$qsys_name/f2sdram0_m.ip"
}

add_component_param "interrupt_latency_counter ILC 
                     IP_FILE_PATH ip/$qsys_name/ILC.ip
                    INTR_TYPE 0"
if {$pr_enable == 1} {
if {$pr_region_count == 2} {
set_component_param "ILC
                    IRQ_PORT_CNT 4"
} else {
set_component_param "ILC
                    IRQ_PORT_CNT 3"
}
} elseif {$fpga_tse == 1} {
set_component_param "ILC
                    IRQ_PORT_CNT 6"
}  else {
set_component_param "ILC
                    IRQ_PORT_CNT 2"
}

if {$hps_i2c_fpga_if == 1} {
add_component_param "altera_gpio i2c1_sda 
                     IP_FILE_PATH ip/$qsys_name/i2c1_sda.ip 
                    PIN_TYPE_GUI Bidir
                    gui_enable_migratable_port_names 0  
                    gui_diff_buff 0
                    gui_pseudo_diff 1   
                    gui_bus_hold 0
                    gui_open_drain 1    
                    gui_use_oe 0
                    gui_enable_termination_ports 0  
                    gui_io_reg_mode none
                    gui_sreset_mode None    
                    gui_areset_mode None
                    gui_enable_cke 0    
                    gui_hr_logic 0
                    gui_separate_io_clks 0  
                    SIZE 1"

add_component_param "altera_gpio i2c1_scl 
                     IP_FILE_PATH ip/$qsys_name/i2c1_scl.ip 
                    PIN_TYPE_GUI Bidir
                    gui_enable_migratable_port_names 0  
                    gui_diff_buff 0
                    gui_pseudo_diff 1   
                    gui_bus_hold 0
                    gui_open_drain 1    
                    gui_use_oe 0
                    gui_enable_termination_ports 0  
                    gui_io_reg_mode none
                    gui_sreset_mode None    
                    gui_areset_mode None
                    gui_enable_cke 0    
                    gui_hr_logic 0
                    gui_separate_io_clks 0  
                    SIZE 1"
}

# instantiate SGMII subsystem(PCS only) for HPS EMAC
if {$hps_sgmii == 1} {
for {set x 1} {$x<=$sgmii_count} {incr x} {
add_instance sgmii_$x subsys_sgmii
### If we want to support user specific subsystem name then subsystem name needed while sourcing the construct_*, and matching
#add_instance sgmii_$x $sgmii_sub_system_name
}
if {$sgmii_count > 1} {
add_component_param "altera_clock_bridge clk_bdg_enet 
                     IP_FILE_PATH ip/$qsys_name/clk_bdg_enet.ip 
                    EXPLICIT_CLOCK_RATE 125000000.0
                    NUM_CLOCK_OUTPUTS 1"
}
}

}

# instantiate Display Port subsystem
if {$fpga_dp == 1} {
add_instance dp_0 subsys_dp
### If we want to support user specific subsystem name then subsystem name needed while sourcing the construct_*, and matching
#add_instance dp_0 $displayport_sub_system_name
add_component_param "altera_in_system_sources_probes issp_dp 
                     IP_FILE_PATH ip/$qsys_name/issp_dp.ip  
                    probe_width 0
                    source_width 1
                    source_initial_value 1
                    create_source_clock 1"

add_component_param "altera_clock_bridge clock_bridge_0 
                     IP_FILE_PATH ip/$qsys_name/clock_bridge_0.ip   
                    EXPLICIT_CLOCK_RATE 74250000.0
                    NUM_CLOCK_OUTPUTS 1"
}

# instantiate PCIe subsystem
if {$fpga_pcie == 1} {
add_instance pcie_0 subsys_pcie

if {$pcie_gen == 3 || $pcie_count == 8} {
add_component_param "altera_iopll iopll_0 
                     IP_FILE_PATH ip/$qsys_name/iopll_0.ip  
                    gui_reference_clock_frequency 250.0
                    gui_use_locked 1
                    gui_operation_mode direct
                    gui_number_of_clocks 2
                    gui_output_clock_frequency0 220.0
                    gui_output_clock_frequency1 125.0"
}
}

# instantiate PR subsystem
if {$pr_enable == 1} {

if {$pr_dp_mix_enable == 1} {
add_component_param "altera_pr_region_controller frz_ctrl_0 
                     IP_FILE_PATH ip/$qsys_name/frz_ctrl_0.ip   
                    ENABLE_CSR 1
                    NUM_INTF_BRIDGE 3
                    ENABLE_PR_REGION_FREEZE 1"

add_component_param "altera_reset_bridge pr_src_rst 
                     IP_FILE_PATH ip/$qsys_name/pr_src_rst.ip   
                    ACTIVE_LOW_RESET 0
                    SYNCHRONOUS_EDGES deassert
                    NUM_RESET_OUTPUTS 1
                    USE_RESET_REQUEST 0"
} else {
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
                    SLV_BRIDGE_BURST_BNDR_ONLY 0
                    SLV_BRIDGE_MAX_PENDING_READS 1
                    SLV_BRIDGE_MAX_PENDING_WRITES 0"
}
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
if {$fpga_ocm_msgdma_enable ==1} {
add_instance hps2ocm_msgdma altera_msgdma

add_instance ocm2hps_msgdma altera_msgdma
}

if {$fpga_tse == 1} {
add_component_param "altera_clock_bridge enet_cb 
                     IP_FILE_PATH ip/$qsys_name/enet_cb.ip  
                    EXPLICIT_CLOCK_RATE 125000000.0
                    NUM_CLOCK_OUTPUTS 1"

if {$niosii_en == 0} {
add_component_param "altera_avalon_mm_bridge pb_f2sdram 
                     IP_FILE_PATH ip/$qsys_name/pb_f2sdram.ip   
                    DATA_WIDTH 128
                    ADDRESS_WIDTH 32
                    USE_AUTO_ADDRESS_WIDTH 1
                    MAX_BURST_SIZE 4
                    MAX_PENDING_RESPONSES 8"

if {$mdio_clk_div == 50} {
add_component_param "altera_iopll tse_pll 
                     IP_FILE_PATH ip/$qsys_name/tse_pll.ip  
                    gui_reference_clock_frequency 100.0
                    gui_number_of_clocks 1
                    gui_output_clock_frequency0 125.0"
}
} else {
add_component_param "altera_avalon_mm_clock_crossing_bridge tse_ccb 
                     IP_FILE_PATH ip/$qsys_name/tse_ccb.ip  
                    ADDRESS_WIDTH 27
                    USE_AUTO_ADDRESS_WIDTH 1
                    MAX_BURST_SIZE 4
                    RESPONSE_FIFO_DEPTH 8
                    COMMAND_FIFO_DEPTH 8"
}

for {set j 0} {$j<2} {incr j} {
add_instance tse_$j subsys_tse
}
}

########################################################### 
# connections and connection parameters                   #
###########################################################
add_connection clk_100.out_clk rst_in.clk
if {$niosii_en == 0} {
if {$fpga_pcie == 1 || $fpga_tse == 1} {
if {$fpga_pcie == 1} {
if {$pcie_gen == 3} {
add_connection iopll_0.outclk0 a10_hps.f2sdram2_clock 
} else {
if {$pcie_count == 8} {

add_connection iopll_0.outclk0 a10_hps.f2sdram2_clock 

} else {
add_connection pcie_0.coreclkout_out a10_hps.f2sdram2_clock 
}
}
}
if {$fpga_tse == 1} {
if {$mdio_clk_div == 50} {
add_connection tse_pll.outclk0 a10_hps.f2sdram2_clock
} else {
add_connection clk_100.out_clk a10_hps.f2sdram2_clock
}
}
} else {
add_connection clk_100.out_clk a10_hps.f2sdram2_clock
}

if {$fpga_pcie == 0 && $fpga_tse == 0} {
add_connection clk_100.out_clk f2sdram2_m.clk 

add_connection rst_in.out_reset f2sdram2_m.clk_reset 

add_connection a10_hps.h2f_reset f2sdram2_m.clk_reset 

add_connection f2sdram2_m.master a10_hps.f2sdram2_data 
set_connection_parameter_value f2sdram2_m.master/a10_hps.f2sdram2_data arbitrationPriority {1}
set_connection_parameter_value f2sdram2_m.master/a10_hps.f2sdram2_data baseAddress {0x0000}
set_connection_parameter_value f2sdram2_m.master/a10_hps.f2sdram2_data defaultConnection {0}
}
}

if {$fpga_pcie == 1 && $niosii_en == 0} {
if {$pcie_gen == 3 || $pcie_count == 8} {
add_connection iopll_0.outclk1 ocm_0.clk1 
} else {
add_connection pcie_0.coreclkout_out ocm_0.clk1 
}
} else {
add_connection clk_100.out_clk ocm_0.clk1 
}
add_connection rst_in.out_reset ocm_0.reset1

if {$niosii_en == 1} {
# setup connection for alternate A10 SoC GHRD with NiosII soft Processor
add_connection cpu.data_master cpu.debug_mem_slave
set_connection_parameter_value cpu.data_master/cpu.debug_mem_slave arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/cpu.debug_mem_slave baseAddress {0x08000800}
set_connection_parameter_value cpu.data_master/cpu.debug_mem_slave defaultConnection {0}

add_connection cpu.instruction_master cpu.debug_mem_slave
set_connection_parameter_value cpu.instruction_master/cpu.debug_mem_slave arbitrationPriority {1}
set_connection_parameter_value cpu.instruction_master/cpu.debug_mem_slave baseAddress {0x08000800}
set_connection_parameter_value cpu.instruction_master/cpu.debug_mem_slave defaultConnection {0}

if {$niosii_mmu_en == 1} {
add_connection cpu.data_master cpu_ccb.s0
set_connection_parameter_value cpu.data_master/cpu_ccb.s0 arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/cpu_ccb.s0 baseAddress {0x10000000}
set_connection_parameter_value cpu.data_master/cpu_ccb.s0 defaultConnection {0}

add_connection cpu.instruction_master cpu_ccb.s0
set_connection_parameter_value cpu.instruction_master/cpu_ccb.s0 arbitrationPriority {1}
set_connection_parameter_value cpu.instruction_master/cpu_ccb.s0 baseAddress {0x10000000}
set_connection_parameter_value cpu.instruction_master/cpu_ccb.s0 defaultConnection {0}

add_connection cpu.data_master qspi_0.avl_mem
set_connection_parameter_value cpu.data_master/qspi_0.avl_mem arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/qspi_0.avl_mem baseAddress {0x0}
set_connection_parameter_value cpu.data_master/qspi_0.avl_mem defaultConnection {0}

add_connection cpu.instruction_master qspi_0.avl_mem
set_connection_parameter_value cpu.instruction_master/qspi_0.avl_mem arbitrationPriority {1}
set_connection_parameter_value cpu.instruction_master/qspi_0.avl_mem baseAddress {0x0}
set_connection_parameter_value cpu.instruction_master/qspi_0.avl_mem defaultConnection {0}
} else {
add_connection cpu.data_master cpu_ccb.s0
set_connection_parameter_value cpu.data_master/cpu_ccb.s0 arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/cpu_ccb.s0 baseAddress {0x0}
set_connection_parameter_value cpu.data_master/cpu_ccb.s0 defaultConnection {0}

add_connection cpu.instruction_master cpu_ccb.s0
set_connection_parameter_value cpu.instruction_master/cpu_ccb.s0 arbitrationPriority {1}
set_connection_parameter_value cpu.instruction_master/cpu_ccb.s0 baseAddress {0x0}
set_connection_parameter_value cpu.instruction_master/cpu_ccb.s0 defaultConnection {0}

add_connection cpu.data_master qspi_0.avl_mem
set_connection_parameter_value cpu.data_master/qspi_0.avl_mem arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/qspi_0.avl_mem baseAddress {0x10000000}
set_connection_parameter_value cpu.data_master/qspi_0.avl_mem defaultConnection {0}

add_connection cpu.instruction_master qspi_0.avl_mem
set_connection_parameter_value cpu.instruction_master/qspi_0.avl_mem arbitrationPriority {1}
set_connection_parameter_value cpu.instruction_master/qspi_0.avl_mem baseAddress {0x10000000}
set_connection_parameter_value cpu.instruction_master/qspi_0.avl_mem defaultConnection {0}
}

add_connection cpu.tightly_coupled_data_master_0 tb_ram_1k.s1
set_connection_parameter_value cpu.tightly_coupled_data_master_0/tb_ram_1k.s1 arbitrationPriority {1}
set_connection_parameter_value cpu.tightly_coupled_data_master_0/tb_ram_1k.s1 baseAddress {0x08000000}
set_connection_parameter_value cpu.tightly_coupled_data_master_0/tb_ram_1k.s1 defaultConnection {0}

add_connection cpu.tightly_coupled_instruction_master_0 tb_ram_1k.s2
set_connection_parameter_value cpu.tightly_coupled_instruction_master_0/tb_ram_1k.s2 arbitrationPriority {1}
set_connection_parameter_value cpu.tightly_coupled_instruction_master_0/tb_ram_1k.s2 baseAddress {0x08000000}
set_connection_parameter_value cpu.tightly_coupled_instruction_master_0/tb_ram_1k.s2 defaultConnection {0}

add_connection cpu.data_master ocm_0.s1 
set_connection_parameter_value cpu.data_master/ocm_0.s1 arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/ocm_0.s1 baseAddress {0x08040000}
set_connection_parameter_value cpu.data_master/ocm_0.s1 defaultConnection {0}

add_connection cpu.instruction_master ocm_0.s1 
set_connection_parameter_value cpu.instruction_master/ocm_0.s1 arbitrationPriority {1}
set_connection_parameter_value cpu.instruction_master/ocm_0.s1 baseAddress {0x08040000}
set_connection_parameter_value cpu.instruction_master/ocm_0.s1 defaultConnection {0}

add_connection fpga_m.master ocm_0.s1 
set_connection_parameter_value fpga_m.master/ocm_0.s1 arbitrationPriority {1}
set_connection_parameter_value fpga_m.master/ocm_0.s1 baseAddress {0x08040000}
set_connection_parameter_value fpga_m.master/ocm_0.s1 defaultConnection {0}

add_connection cpu.data_master pb_c2ph.s0
set_connection_parameter_value cpu.data_master/pb_c2ph.s0 arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/pb_c2ph.s0 baseAddress {0x08020000}
set_connection_parameter_value cpu.data_master/pb_c2ph.s0 defaultConnection {0}

add_connection fpga_m.master pb_c2ph.s0
set_connection_parameter_value fpga_m.master/pb_c2ph.s0 arbitrationPriority {1}
set_connection_parameter_value fpga_m.master/pb_c2ph.s0 baseAddress {0x08020000}
set_connection_parameter_value fpga_m.master/pb_c2ph.s0 defaultConnection {0}

add_connection cpu_ccb.m0/ddr_ext.windowed_slave
set_connection_parameter_value cpu_ccb.m0/ddr_ext.windowed_slave arbitrationPriority {1}
set_connection_parameter_value cpu_ccb.m0/ddr_ext.windowed_slave baseAddress {0x0000}
set_connection_parameter_value cpu_ccb.m0/ddr_ext.windowed_slave defaultConnection {0}

add_connection ddr_ext.expanded_master a10_emif.ctrl_amm_avalon_slave_0
set_connection_parameter_value ddr_ext.expanded_master/a10_emif.ctrl_amm_avalon_slave_0 arbitrationPriority {1}
set_connection_parameter_value ddr_ext.expanded_master/a10_emif.ctrl_amm_avalon_slave_0 baseAddress {0x0000}
set_connection_parameter_value ddr_ext.expanded_master/a10_emif.ctrl_amm_avalon_slave_0 defaultConnection {0}

add_connection pb_c2ph.m0 a10_emif.ctrl_mmr_slave_avalon_slave_0
set_connection_parameter_value pb_c2ph.m0/a10_emif.ctrl_mmr_slave_avalon_slave_0 arbitrationPriority {1}
set_connection_parameter_value pb_c2ph.m0/a10_emif.ctrl_mmr_slave_avalon_slave_0 baseAddress {0x2000}
set_connection_parameter_value pb_c2ph.m0/a10_emif.ctrl_mmr_slave_avalon_slave_0 defaultConnection {0}

add_connection pb_c2ph.m0 periph.pb_cpu_0_s0
set_connection_parameter_value pb_c2ph.m0/periph.pb_cpu_0_s0 arbitrationPriority {1}
set_connection_parameter_value pb_c2ph.m0/periph.pb_cpu_0_s0 baseAddress {0x0400}
set_connection_parameter_value pb_c2ph.m0/periph.pb_cpu_0_s0 defaultConnection {0}

add_connection pb_c2ph.m0 qspi_0.avl_csr
set_connection_parameter_value pb_c2ph.m0/qspi_0.avl_csr arbitrationPriority {1}
set_connection_parameter_value pb_c2ph.m0/qspi_0.avl_csr baseAddress {0x0}
set_connection_parameter_value pb_c2ph.m0/qspi_0.avl_csr defaultConnection {0}

add_connection pb_c2ph.m0 sysid.control_slave
set_connection_parameter_value pb_c2ph.m0/sysid.control_slave arbitrationPriority {1}
set_connection_parameter_value pb_c2ph.m0/sysid.control_slave baseAddress {0x0820}
set_connection_parameter_value pb_c2ph.m0/sysid.control_slave defaultConnection {0}

add_connection pb_c2ph.m0 timer_1.s1
set_connection_parameter_value pb_c2ph.m0/timer_1.s1 arbitrationPriority {1}
set_connection_parameter_value pb_c2ph.m0/timer_1.s1 baseAddress {0x0860}
set_connection_parameter_value pb_c2ph.m0/timer_1.s1 defaultConnection {0}

add_connection pb_c2ph.m0 timer_0.s1
set_connection_parameter_value pb_c2ph.m0/timer_0.s1 arbitrationPriority {1}
set_connection_parameter_value pb_c2ph.m0/timer_0.s1 baseAddress {0x0840}
set_connection_parameter_value pb_c2ph.m0/timer_0.s1 defaultConnection {0}

add_connection clk_100.out_clk sysid.clk

add_connection clk_100.out_clk timer_1.clk

add_connection clk_100.out_clk timer_0.clk

add_connection clk_100.out_clk irq_bg.clk

add_connection clk_100.out_clk pb_c2ph.clk 

add_connection clk_100.out_clk periph.clk

add_connection clk_100.out_clk fpga_m.clk

add_connection clk_100.out_clk rst_bdg.clk

add_connection clk_100.out_clk qspi_pll.refclk      

add_connection a10_emif.emif_usr_clk_clock_source ddr_ext.clock

add_connection a10_emif.emif_usr_clk_clock_source/cpu_ccb.m0_clk

add_connection a10_emif.pll_extra_clk_0_clock_source cpu.clk

add_connection a10_emif.pll_extra_clk_0_clock_source tb_ram_1k.clk1

add_connection a10_emif.pll_extra_clk_0_clock_source cpu_ccb.s0_clk

add_connection qspi_pll.outclk0 qspi_0.clock_sink

add_connection rst_in.out_reset sysid.reset

add_connection rst_in.out_reset timer_1.reset

add_connection rst_in.out_reset timer_0.reset

add_connection rst_in.out_reset irq_bg.clk_reset

add_connection rst_in.out_reset a10_emif.global_reset_reset_sink

add_connection rst_in.out_reset qspi_0.reset

add_connection rst_in.out_reset fpga_m.clk_reset 

add_connection rst_in.out_reset pb_c2ph.reset 

add_connection rst_in.out_reset cpu.reset

add_connection rst_in.out_reset periph.reset

add_connection rst_in.out_reset tb_ram_1k.reset1

add_connection rst_in.out_reset ddr_ext.reset

add_connection rst_in.out_reset cpu_ccb.m0_reset

add_connection rst_in.out_reset cpu_ccb.s0_reset

add_connection rst_in.out_reset qspi_pll.reset

add_connection cpu.debug_reset_request qspi_0.reset

add_connection cpu.debug_reset_request cpu.reset

add_connection cpu.debug_reset_request sysid.reset

add_connection cpu.debug_reset_request timer_0.reset

add_connection cpu.debug_reset_request timer_1.reset

add_connection cpu.debug_reset_request periph.reset

add_connection cpu.debug_reset_request irq_bg.clk_reset

add_connection cpu.debug_reset_request tb_ram_1k.reset1

add_connection cpu.debug_reset_request pb_c2ph.reset

add_connection a10_emif.emif_usr_reset_reset_source cpu_ccb.m0_reset

add_connection a10_emif.emif_usr_reset_reset_source cpu_ccb.s0_reset

add_connection a10_emif.emif_usr_reset_reset_source rst_bdg.in_reset

add_connection a10_emif.emif_usr_reset_reset_source cpu.reset

add_connection a10_emif.emif_usr_reset_reset_source ddr_ext.reset

add_connection a10_emif.emif_usr_reset_reset_source tb_ram_1k.reset1

add_connection periph.ILC_irq periph.button_pio_irq
set_connection_parameter_value periph.ILC_irq/periph.button_pio_irq irqNumber {5}

add_connection periph.ILC_irq periph.dipsw_pio_irq
set_connection_parameter_value periph.ILC_irq/periph.dipsw_pio_irq irqNumber {4}

add_connection periph.ILC_irq periph.jtag_uart_irq
set_connection_parameter_value periph.ILC_irq/periph.jtag_uart_irq irqNumber {3}

add_connection periph.ILC_irq periph.uart_16550_irq_sender
set_connection_parameter_value periph.ILC_irq/periph.uart_16550_irq_sender irqNumber {2}

add_connection periph.ILC_irq timer_1.irq
set_connection_parameter_value periph.ILC_irq/timer_1.irq irqNumber {1}

add_connection periph.ILC_irq timer_0.irq
set_connection_parameter_value periph.ILC_irq/timer_0.irq irqNumber {0}

if {$fpga_tse == 1} {
add_connection periph.ILC_irq irq_bg.sender2_irq
set_connection_parameter_value periph.ILC_irq/irq_bg.sender2_irq irqNumber {13}

add_connection periph.ILC_irq irq_bg.sender1_irq
set_connection_parameter_value periph.ILC_irq/irq_bg.sender1_irq irqNumber {12}

add_connection cpu.irq irq_bg.sender2_irq
set_connection_parameter_value cpu.irq/irq_bg.sender2_irq irqNumber {13}

add_connection cpu.irq irq_bg.sender1_irq
set_connection_parameter_value cpu.irq/irq_bg.sender1_irq irqNumber {12}

add_connection cpu.irq irq_bg.sender0_irq
set_connection_parameter_value cpu.irq/irq_bg.sender0_irq irqNumber {11}
} else {
add_connection cpu.irq irq_bg.sender0_irq
set_connection_parameter_value cpu.irq/irq_bg.sender0_irq irqNumber {7}
}

add_connection cpu.irq periph.uart_16550_irq_sender
set_connection_parameter_value cpu.irq/periph.uart_16550_irq_sender irqNumber {5}

add_connection cpu.irq periph.button_pio_irq
set_connection_parameter_value cpu.irq/periph.button_pio_irq irqNumber {4}

add_connection cpu.irq periph.jtag_uart_irq
set_connection_parameter_value cpu.irq/periph.jtag_uart_irq irqNumber {3}

add_connection cpu.irq periph.dipsw_pio_irq
set_connection_parameter_value cpu.irq/periph.dipsw_pio_irq irqNumber {2}

add_connection cpu.irq timer_1.irq
set_connection_parameter_value cpu.irq/timer_1.irq irqNumber {1}

add_connection cpu.irq timer_0.irq
set_connection_parameter_value cpu.irq/timer_0.irq irqNumber {0}
} else {
# setup connection for ordinary A10 SoC GHRD with HPS
add_connection pb_lwh2f.m0 ILC.avalon_slave 
set_connection_parameter_value pb_lwh2f.m0/ILC.avalon_slave arbitrationPriority {1}
set_connection_parameter_value pb_lwh2f.m0/ILC.avalon_slave baseAddress {0x0100}
set_connection_parameter_value pb_lwh2f.m0/ILC.avalon_slave defaultConnection {0}

add_connection pb_lwh2f.m0 sys_id.control_slave 
set_connection_parameter_value pb_lwh2f.m0/sys_id.control_slave arbitrationPriority {1}
set_connection_parameter_value pb_lwh2f.m0/sys_id.control_slave baseAddress {0x0000}
set_connection_parameter_value pb_lwh2f.m0/sys_id.control_slave defaultConnection {0}

add_connection a10_hps.h2f_lw_axi_master pb_lwh2f.s0 
set_connection_parameter_value a10_hps.h2f_lw_axi_master/pb_lwh2f.s0 arbitrationPriority {1}
set_connection_parameter_value a10_hps.h2f_lw_axi_master/pb_lwh2f.s0 baseAddress {0x0000}
set_connection_parameter_value a10_hps.h2f_lw_axi_master/pb_lwh2f.s0 defaultConnection {0}

add_connection pb_lwh2f.m0 led_pio.s1 
set_connection_parameter_value pb_lwh2f.m0/led_pio.s1 arbitrationPriority {1}
set_connection_parameter_value pb_lwh2f.m0/led_pio.s1 baseAddress {0x0010}
set_connection_parameter_value pb_lwh2f.m0/led_pio.s1 defaultConnection {0}

add_connection pb_lwh2f.m0 button_pio.s1 
set_connection_parameter_value pb_lwh2f.m0/button_pio.s1 arbitrationPriority {1}
set_connection_parameter_value pb_lwh2f.m0/button_pio.s1 baseAddress {0x0020}
set_connection_parameter_value pb_lwh2f.m0/button_pio.s1 defaultConnection {0}

add_connection pb_lwh2f.m0 dipsw_pio.s1 
set_connection_parameter_value pb_lwh2f.m0/dipsw_pio.s1 arbitrationPriority {1}
set_connection_parameter_value pb_lwh2f.m0/dipsw_pio.s1 baseAddress {0x0030}
set_connection_parameter_value pb_lwh2f.m0/dipsw_pio.s1 defaultConnection {0}

add_connection a10_hps.h2f_axi_master ocm_0.s1 
set_connection_parameter_value a10_hps.h2f_axi_master/ocm_0.s1 arbitrationPriority {1}
set_connection_parameter_value a10_hps.h2f_axi_master/ocm_0.s1 baseAddress {0x0000}
set_connection_parameter_value a10_hps.h2f_axi_master/ocm_0.s1 defaultConnection {0}

add_connection hps_m.master a10_hps.f2h_axi_slave 
set_connection_parameter_value hps_m.master/a10_hps.f2h_axi_slave arbitrationPriority {1}
set_connection_parameter_value hps_m.master/a10_hps.f2h_axi_slave baseAddress {0x0000}
set_connection_parameter_value hps_m.master/a10_hps.f2h_axi_slave defaultConnection {0}

add_connection fpga_m.master pb_lwh2f.s0 
set_connection_parameter_value fpga_m.master/pb_lwh2f.s0 arbitrationPriority {1}
set_connection_parameter_value fpga_m.master/pb_lwh2f.s0 baseAddress {0x00000}
set_connection_parameter_value fpga_m.master/pb_lwh2f.s0 defaultConnection {0}

add_connection clk_100.out_clk hps_m.clk 

add_connection clk_100.out_clk rst_bdg.clk 

add_connection clk_100.out_clk fpga_m.clk 

add_connection clk_100.out_clk pb_lwh2f.clk 

add_connection clk_100.out_clk a10_hps.h2f_lw_axi_clock

add_connection clk_100.out_clk a10_hps.f2h_axi_clock 

add_connection clk_100.out_clk sys_id.clk 

add_connection clk_100.out_clk led_pio.clk 

add_connection clk_100.out_clk button_pio.clk 

add_connection clk_100.out_clk dipsw_pio.clk 

add_connection clk_100.out_clk ILC.clk 

if {$hps_sdram == "D9RPL" || $hps_sdram == "D9PZN" || $hps_sdram == "D9RGX" || $hps_sdram == "D9TNZ" || $hps_sdram == "D9WFH"} {
add_connection a10_hps.emif emif_hps.hps_emif_conduit_end 
set_connection_parameter_value a10_hps.emif/emif_hps.hps_emif_conduit_end endPort {}
set_connection_parameter_value a10_hps.emif/emif_hps.hps_emif_conduit_end endPortLSB {0}
set_connection_parameter_value a10_hps.emif/emif_hps.hps_emif_conduit_end startPort {}
set_connection_parameter_value a10_hps.emif/emif_hps.hps_emif_conduit_end startPortLSB {0}
set_connection_parameter_value a10_hps.emif/emif_hps.hps_emif_conduit_end width {0}
}

add_connection a10_hps.f2h_irq0 button_pio.irq 
set_connection_parameter_value a10_hps.f2h_irq0/button_pio.irq irqNumber {0}

add_connection a10_hps.f2h_irq0 dipsw_pio.irq 
set_connection_parameter_value a10_hps.f2h_irq0/dipsw_pio.irq irqNumber {1}

add_connection ILC.irq button_pio.irq 
set_connection_parameter_value ILC.irq/button_pio.irq irqNumber {0}

add_connection ILC.irq dipsw_pio.irq 
set_connection_parameter_value ILC.irq/dipsw_pio.irq irqNumber {1}

add_connection rst_in.out_reset a10_hps.f2h_axi_reset 

add_connection rst_in.out_reset a10_hps.f2sdram0_reset 

add_connection rst_in.out_reset a10_hps.f2sdram2_reset 

add_connection rst_in.out_reset a10_hps.h2f_axi_reset 

add_connection rst_in.out_reset a10_hps.h2f_lw_axi_reset 

add_connection rst_in.out_reset hps_m.clk_reset 

add_connection rst_in.out_reset fpga_m.clk_reset 

add_connection rst_in.out_reset rst_bdg.in_reset 

add_connection rst_in.out_reset pb_lwh2f.reset 

add_connection rst_in.out_reset sys_id.reset 

add_connection rst_in.out_reset led_pio.reset 

add_connection rst_in.out_reset button_pio.reset 

add_connection rst_in.out_reset dipsw_pio.reset 

add_connection rst_in.out_reset ILC.reset_n 

add_connection a10_hps.h2f_reset a10_hps.f2h_axi_reset 

add_connection a10_hps.h2f_reset a10_hps.f2sdram0_reset 

add_connection a10_hps.h2f_reset a10_hps.f2sdram2_reset 

add_connection a10_hps.h2f_reset a10_hps.h2f_axi_reset 

add_connection a10_hps.h2f_reset a10_hps.h2f_lw_axi_reset 

add_connection a10_hps.h2f_reset hps_m.clk_reset 

add_connection a10_hps.h2f_reset fpga_m.clk_reset 

add_connection a10_hps.h2f_reset rst_bdg.in_reset 

add_connection a10_hps.h2f_reset pb_lwh2f.reset 

add_connection a10_hps.h2f_reset sys_id.reset 

add_connection a10_hps.h2f_reset led_pio.reset 

add_connection a10_hps.h2f_reset button_pio.reset 

add_connection a10_hps.h2f_reset dipsw_pio.reset 

add_connection a10_hps.h2f_reset ocm_0.reset1 

add_connection a10_hps.h2f_reset ILC.reset_n 

if {$hps_sdram == "D9RPL" || $hps_sdram == "D9PZN" || $hps_sdram == "D9RGX" || $hps_sdram == "D9TNZ" || $hps_sdram == "D9WFH"} {
add_connection rst_in.out_reset emif_hps.global_reset_reset_sink 
}

if {$fast_trace == 1} {
add_connection a10_hps.trace_s2f_clk trace_wrapper_0.clock_sink 

add_connection rst_in.out_reset trace_wrapper_0.reset_sink 

add_connection a10_hps.h2f_reset trace_wrapper_0.reset_sink 

add_connection trace_wrapper_0.h2f_tpiu a10_hps.trace 
set_connection_parameter_value trace_wrapper_0.h2f_tpiu/a10_hps.trace endPort {}
set_connection_parameter_value trace_wrapper_0.h2f_tpiu/a10_hps.trace endPortLSB {0}
set_connection_parameter_value trace_wrapper_0.h2f_tpiu/a10_hps.trace startPort {}
set_connection_parameter_value trace_wrapper_0.h2f_tpiu/a10_hps.trace startPortLSB {0}
set_connection_parameter_value trace_wrapper_0.h2f_tpiu/a10_hps.trace width {0}
}

add_connection clk_100.out_clk issp_0.source_clk 

# HPS EMAC SGMII subsystem
if {$hps_sgmii == 1} {
for {set x 1} {$x<=$sgmii_count} {incr x} {
add_connection clk_100.out_clk sgmii_${x}.clk 
add_connection rst_in.out_reset sgmii_${x}.reset 
add_connection a10_hps.h2f_reset sgmii_${x}.reset 

add_connection a10_hps.emac${x} sgmii_${x}.emac 
set_connection_parameter_value a10_hps.emac${x}/sgmii_${x}.emac endPort {}
set_connection_parameter_value a10_hps.emac${x}/sgmii_${x}.emac endPortLSB {0}
set_connection_parameter_value a10_hps.emac${x}/sgmii_${x}.emac startPort {}
set_connection_parameter_value a10_hps.emac${x}/sgmii_${x}.emac startPortLSB {0}
set_connection_parameter_value a10_hps.emac${x}/sgmii_${x}.emac width {0}

add_connection sgmii_${x}.emac_tx_clk_in a10_hps.emac${x}_tx_clk_in 
add_connection sgmii_${x}.emac_rx_clk_in a10_hps.emac${x}_rx_clk_in 
add_connection a10_hps.emac${x}_gtx_clk sgmii_${x}.emac_gtx_clk 
add_connection a10_hps.emac${x}_rx_reset sgmii_${x}.emac_rx_reset 
add_connection a10_hps.emac${x}_tx_reset sgmii_${x}.emac_tx_reset 

add_connection pb_lwh2f.m0 sgmii_${x}.gmii_to_sgmii_adapter_avalon_slave 
set_connection_parameter_value pb_lwh2f.m0/sgmii_${x}.gmii_to_sgmii_adapter_avalon_slave arbitrationPriority {1}
set_connection_parameter_value pb_lwh2f.m0/sgmii_${x}.gmii_to_sgmii_adapter_avalon_slave baseAddress [expr [expr $x* 0x0200] + 0x40]
set_connection_parameter_value pb_lwh2f.m0/sgmii_${x}.gmii_to_sgmii_adapter_avalon_slave defaultConnection {0}

add_connection pb_lwh2f.m0 sgmii_${x}.pcs_control_port 
set_connection_parameter_value pb_lwh2f.m0/sgmii_${x}.pcs_control_port arbitrationPriority {1}
set_connection_parameter_value pb_lwh2f.m0/sgmii_${x}.pcs_control_port baseAddress [expr $x* 0x0200]
set_connection_parameter_value pb_lwh2f.m0/sgmii_${x}.pcs_control_port defaultConnection {0}
}
}

}

# Display Port subsystem
if {$fpga_dp == 1 && $niosii_en == 0} {
add_connection pb_lwh2f.m0 dp_0.pb_dp_s0 
set_connection_parameter_value pb_lwh2f.m0/dp_0.pb_dp_s0 arbitrationPriority {1}
set_connection_parameter_value pb_lwh2f.m0/dp_0.pb_dp_s0 baseAddress {0x2000}
set_connection_parameter_value pb_lwh2f.m0/dp_0.pb_dp_s0 defaultConnection {0}

if {$frame_buffer == 1} {
add_connection dp_0.alt_vip_cl_vfb_0_mem_master_rd a10_hps.f2sdram0_data 
set_connection_parameter_value dp_0.alt_vip_cl_vfb_0_mem_master_rd/a10_hps.f2sdram0_data arbitrationPriority {1}
set_connection_parameter_value dp_0.alt_vip_cl_vfb_0_mem_master_rd/a10_hps.f2sdram0_data baseAddress {0x0000}
set_connection_parameter_value dp_0.alt_vip_cl_vfb_0_mem_master_rd/a10_hps.f2sdram0_data defaultConnection {0}

add_connection pb_lwh2f.m0 dp_0.alt_vip_cl_vfb_0_control
set_connection_parameter_value pb_lwh2f.m0/dp_0.alt_vip_cl_vfb_0_control arbitrationPriority {1}
set_connection_parameter_value pb_lwh2f.m0/dp_0.alt_vip_cl_vfb_0_control baseAddress {0x0280}
set_connection_parameter_value pb_lwh2f.m0/dp_0.alt_vip_cl_vfb_0_control defaultConnection {0}

add_connection a10_hps.f2h_irq0 dp_0.alt_vip_cl_vfb_0_control_interrupt
set_connection_parameter_value a10_hps.f2h_irq0/dp_0.alt_vip_cl_vfb_0_control_interrupt irqNumber {6}

add_connection dp_0.video_pll_outclk3 a10_hps.f2sdram0_clock
} else {
add_connection f2sdram0_m.master a10_hps.f2sdram0_data 
set_connection_parameter_value f2sdram0_m.master/a10_hps.f2sdram0_data arbitrationPriority {1}
set_connection_parameter_value f2sdram0_m.master/a10_hps.f2sdram0_data baseAddress {0x0000}
set_connection_parameter_value f2sdram0_m.master/a10_hps.f2sdram0_data defaultConnection {0}

add_connection clk_100.out_clk a10_hps.f2sdram0_clock

add_connection clk_100.out_clk f2sdram0_m.clk 

add_connection rst_in.out_reset f2sdram0_m.clk_reset 

add_connection a10_hps.h2f_reset f2sdram0_m.clk_reset 
}

add_connection clk_100.out_clk issp_dp.source_clk 

add_connection clk_100.out_clk dp_0.clk_100 

add_connection clock_bridge_0.out_clk dp_0.clk_vip 

add_connection rst_in.out_reset dp_0.resetn 

add_connection a10_hps.h2f_reset dp_0.resetn  
} elseif {$fpga_dp == 1 && $niosii_en == 1} {
#DP enabled with NiosII as main Processor
add_connection pb_c2ph.m0 dp_0.pb_dp_s0
set_connection_parameter_value pb_c2ph.m0/dp_0.pb_dp_s0 arbitrationPriority {1}
set_connection_parameter_value pb_c2ph.m0/dp_0.pb_dp_s0 baseAddress {0x3000}
set_connection_parameter_value pb_c2ph.m0/dp_0.pb_dp_s0 defaultConnection {0}
if {$frame_buffer == 1} {
add_connection dp_0.alt_vip_cl_vfb_0_mem_master_rd ddr_ext.windowed_slave
set_connection_parameter_value dp_0.alt_vip_cl_vfb_0_mem_master_rd/ddr_ext.windowed_slave arbitrationPriority {1}
set_connection_parameter_value dp_0.alt_vip_cl_vfb_0_mem_master_rd/ddr_ext.windowed_slave baseAddress {0x0000}
set_connection_parameter_value dp_0.alt_vip_cl_vfb_0_mem_master_rd/ddr_ext.windowed_slave defaultConnection {0}

add_connection pb_c2ph.m0 dp_0.alt_vip_cl_vfb_0_control
set_connection_parameter_value pb_c2ph.m0/dp_0.alt_vip_cl_vfb_0_control arbitrationPriority {1}
set_connection_parameter_value pb_c2ph.m0/dp_0.alt_vip_cl_vfb_0_control baseAddress {0x880}
set_connection_parameter_value pb_c2ph.m0/dp_0.alt_vip_cl_vfb_0_control defaultConnection {0}

add_connection periph.ILC_irq dp_0.alt_vip_cl_vfb_0_control_interrupt
set_connection_parameter_value periph.ILC_irq/dp_0.alt_vip_cl_vfb_0_control_interrupt irqNumber {14}

add_connection cpu.irq dp_0.alt_vip_cl_vfb_0_control_interrupt
set_connection_parameter_value cpu.irq/dp_0.alt_vip_cl_vfb_0_control_interrupt irqNumber {14}
}

add_connection clk_100.out_clk issp_dp.source_clk 

add_connection clk_100.out_clk dp_0.clk_100 

add_connection clock_bridge_0.out_clk dp_0.clk_vip 

add_connection rst_in.out_reset dp_0.resetn 

add_connection cpu.debug_reset_request dp_0.resetn

add_connection a10_emif.emif_usr_reset_reset_source dp_0.resetn 
} elseif {$fpga_dp == 0 && $niosii_en == 1} {
#DP disabled with NiosII as main Processor
} else {
add_connection clk_100.out_clk a10_hps.f2sdram0_clock

add_connection clk_100.out_clk f2sdram0_m.clk 

add_connection rst_in.out_reset f2sdram0_m.clk_reset 

add_connection a10_hps.h2f_reset f2sdram0_m.clk_reset 

add_connection f2sdram0_m.master a10_hps.f2sdram0_data 
set_connection_parameter_value f2sdram0_m.master/a10_hps.f2sdram0_data arbitrationPriority {1}
set_connection_parameter_value f2sdram0_m.master/a10_hps.f2sdram0_data baseAddress {0x0000}
set_connection_parameter_value f2sdram0_m.master/a10_hps.f2sdram0_data defaultConnection {0}
}


# PCIe subsystem
if {$fpga_pcie == 1 && $niosii_en == 0} {
add_connection pcie_0.pb_2_ocm_m0 ocm_0.s1 
set_connection_parameter_value pcie_0.pb_2_ocm_m0/ocm_0.s1 arbitrationPriority {1}
set_connection_parameter_value pcie_0.pb_2_ocm_m0/ocm_0.s1 baseAddress {0x0000}
set_connection_parameter_value pcie_0.pb_2_ocm_m0/ocm_0.s1 defaultConnection {0}

add_connection pb_lwh2f.m0 pcie_0.pb_lwh2f_pcie_s0 
set_connection_parameter_value pb_lwh2f.m0/pcie_0.pb_lwh2f_pcie_s0 arbitrationPriority {1}
set_connection_parameter_value pb_lwh2f.m0/pcie_0.pb_lwh2f_pcie_s0 baseAddress {0x00010000}
set_connection_parameter_value pb_lwh2f.m0/pcie_0.pb_lwh2f_pcie_s0 defaultConnection {0}

add_connection a10_hps.h2f_axi_master pcie_0.ccb_h2f_s0 
set_connection_parameter_value a10_hps.h2f_axi_master/pcie_0.ccb_h2f_s0 arbitrationPriority {1}
set_connection_parameter_value a10_hps.h2f_axi_master/pcie_0.ccb_h2f_s0 baseAddress {0x10000000}
set_connection_parameter_value a10_hps.h2f_axi_master/pcie_0.ccb_h2f_s0 defaultConnection {0}

add_connection pcie_0.address_span_extender_0_expanded_master a10_hps.f2sdram2_data 
set_connection_parameter_value pcie_0.address_span_extender_0_expanded_master/a10_hps.f2sdram2_data arbitrationPriority {1}
set_connection_parameter_value pcie_0.address_span_extender_0_expanded_master/a10_hps.f2sdram2_data baseAddress {0x0000}
set_connection_parameter_value pcie_0.address_span_extender_0_expanded_master/a10_hps.f2sdram2_data defaultConnection {0}

add_connection pcie_0.nreset_status_out_reset ocm_0.reset1 

add_connection pcie_0.nreset_status_out_reset a10_hps.f2sdram2_reset

add_connection clk_100.out_clk pcie_0.clk 

add_connection rst_in.out_reset pcie_0.reset 

add_connection a10_hps.h2f_reset pcie_0.reset 

if {$pcie_gen == 3} {
add_connection iopll_0.outclk1 a10_hps.h2f_axi_clock

add_connection pcie_0.coreclkout_out iopll_0.refclk 

add_connection iopll_0.outclk1 pcie_0.clk_125_in_clk 

add_connection rst_in.out_reset iopll_0.reset   

add_connection a10_hps.h2f_reset iopll_0.reset

add_connection pcie_0.nreset_status_out_reset iopll_0.reset 

if {$pcie_count != 8} {
add_connection a10_hps.f2h_irq0 pcie_0.msgdma_0_csr_irq 
set_connection_parameter_value a10_hps.f2h_irq0/pcie_0.msgdma_0_csr_irq irqNumber {4}
} 
} else {
if {$pcie_count == 8} {
add_connection iopll_0.outclk1 a10_hps.h2f_axi_clock

add_connection pcie_0.coreclkout_out iopll_0.refclk 

add_connection iopll_0.outclk1 pcie_0.clk_125_in_clk 

add_connection rst_in.out_reset iopll_0.reset   

add_connection a10_hps.h2f_reset iopll_0.reset

add_connection pcie_0.nreset_status_out_reset iopll_0.reset 
} else {
add_connection clk_100.out_clk a10_hps.h2f_axi_clock 
}
add_connection a10_hps.f2h_irq0 pcie_0.msgdma_0_csr_irq 
set_connection_parameter_value a10_hps.f2h_irq0/pcie_0.msgdma_0_csr_irq irqNumber {4}
}

add_connection a10_hps.f2h_irq0 pcie_0.msi_to_gic_gen_0_interrupt_sender 
set_connection_parameter_value a10_hps.f2h_irq0/pcie_0.msi_to_gic_gen_0_interrupt_sender irqNumber {3}

add_connection a10_hps.f2h_irq0 pcie_0.pcie_a10_hip_avmm_cra_irq 
set_connection_parameter_value a10_hps.f2h_irq0/pcie_0.pcie_a10_hip_avmm_cra_irq irqNumber {5}

} elseif {$fpga_pcie == 1 && $niosii_en == 1} {
#PCIe enabled with NiosII as main Processor
add_connection pcie_0.pb_2_ocm_m0 ocm_0.s1 
set_connection_parameter_value pcie_0.pb_2_ocm_m0/ocm_0.s1 arbitrationPriority {1}
set_connection_parameter_value pcie_0.pb_2_ocm_m0/ocm_0.s1 baseAddress {0x0000}
set_connection_parameter_value pcie_0.pb_2_ocm_m0/ocm_0.s1 defaultConnection {0}

add_connection pb_c2ph.m0 pcie_0.pb_lwh2f_pcie_s0
set_connection_parameter_value pb_c2ph.m0/pcie_0.pb_lwh2f_pcie_s0 arbitrationPriority {1}
set_connection_parameter_value pb_c2ph.m0/pcie_0.pb_lwh2f_pcie_s0 baseAddress {0x00010000}
set_connection_parameter_value pb_c2ph.m0/pcie_0.pb_lwh2f_pcie_s0 defaultConnection {0}

add_connection cpu.data_master pcie_0.ccb_h2f_s0
set_connection_parameter_value cpu.data_master/pcie_0.ccb_h2f_s0 arbitrationPriority {1}
set_connection_parameter_value cpu.data_master/pcie_0.ccb_h2f_s0 baseAddress {0x20000000}
set_connection_parameter_value cpu.data_master/pcie_0.ccb_h2f_s0 defaultConnection {0}

add_connection pcie_0.address_span_extender_0_expanded_master ddr_ext.windowed_slave
set_connection_parameter_value pcie_0.address_span_extender_0_expanded_master/ddr_ext.windowed_slave arbitrationPriority {1}
set_connection_parameter_value pcie_0.address_span_extender_0_expanded_master/ddr_ext.windowed_slave baseAddress {0x10000000}
set_connection_parameter_value pcie_0.address_span_extender_0_expanded_master/ddr_ext.windowed_slave defaultConnection {0}

add_connection pcie_0.nreset_status_out_reset ocm_0.reset1 

add_connection clk_100.out_clk pcie_0.clk 

add_connection rst_in.out_reset pcie_0.reset 

add_connection cpu.debug_reset_request pcie_0.reset

add_connection a10_emif.emif_usr_reset_reset_source pcie_0.reset 

if {$pcie_gen == 3} {
add_connection pcie_0.coreclkout_out iopll_0.refclk 

add_connection iopll_0.outclk1 pcie_0.clk_125_in_clk 

add_connection rst_in.out_reset iopll_0.reset   

add_connection pcie_0.nreset_status_out_reset iopll_0.reset 
if {$pcie_count != 8} {
add_connection periph.ILC_irq pcie_0.msgdma_0_csr_irq
set_connection_parameter_value periph.ILC_irq/pcie_0.msgdma_0_csr_irq irqNumber {15}

add_connection cpu.irq pcie_0.msgdma_0_csr_irq
set_connection_parameter_value cpu.irq/pcie_0.msgdma_0_csr_irq irqNumber {15}
} 
} else {
if {$pcie_count == 8} {
add_connection pcie_0.coreclkout_out iopll_0.refclk 

add_connection iopll_0.outclk1 pcie_0.clk_125_in_clk 

add_connection rst_in.out_reset iopll_0.reset   

add_connection pcie_0.nreset_status_out_reset iopll_0.reset 
} else {
}
add_connection periph.ILC_irq pcie_0.msgdma_0_csr_irq
set_connection_parameter_value periph.ILC_irq/pcie_0.msgdma_0_csr_irq irqNumber {15}

add_connection cpu.irq pcie_0.msgdma_0_csr_irq
set_connection_parameter_value cpu.irq/pcie_0.msgdma_0_csr_irq irqNumber {15}
}

add_connection cpu.irq pcie_0.msi_to_gic_gen_0_interrupt_sender 
set_connection_parameter_value cpu.irq/pcie_0.msi_to_gic_gen_0_interrupt_sender irqNumber {16}

add_connection cpu.irq pcie_0.pcie_a10_hip_avmm_cra_irq 
set_connection_parameter_value cpu.irq/pcie_0.pcie_a10_hip_avmm_cra_irq irqNumber {17}

add_connection periph.ILC_irq pcie_0.msi_to_gic_gen_0_interrupt_sender 
set_connection_parameter_value periph.ILC_irq/pcie_0.msi_to_gic_gen_0_interrupt_sender irqNumber {16}

add_connection periph.ILC_irq pcie_0.pcie_a10_hip_avmm_cra_irq 
set_connection_parameter_value periph.ILC_irq/pcie_0.pcie_a10_hip_avmm_cra_irq irqNumber {17}
} elseif {$fpga_pcie == 0 && $niosii_en == 1} {
#PCIe disabled with NiosII as main Processor
} else {
add_connection clk_100.out_clk a10_hps.h2f_axi_clock 
}

# PR subsystem
if {$pr_enable == 1} {
if {$pr_dp_mix_enable == 1} {
add_connection pb_lwh2f.m0 frz_ctrl_0.avl_csr
set_connection_parameter_value pb_lwh2f.m0/frz_ctrl_0.avl_csr arbitrationPriority {1}
set_connection_parameter_value pb_lwh2f.m0/frz_ctrl_0.avl_csr baseAddress {0x0450}
set_connection_parameter_value pb_lwh2f.m0/frz_ctrl_0.avl_csr defaultConnection {0}

add_connection frz_ctrl_0.bridge_freeze0 dp_0.frz_bdg_0_freeze_conduit
set_connection_parameter_value frz_ctrl_0.bridge_freeze0/dp_0.frz_bdg_0_freeze_conduit endPort {}
set_connection_parameter_value frz_ctrl_0.bridge_freeze0/dp_0.frz_bdg_0_freeze_conduit endPortLSB {0}
set_connection_parameter_value frz_ctrl_0.bridge_freeze0/dp_0.frz_bdg_0_freeze_conduit startPort {}
set_connection_parameter_value frz_ctrl_0.bridge_freeze0/dp_0.frz_bdg_0_freeze_conduit startPortLSB {0}
set_connection_parameter_value frz_ctrl_0.bridge_freeze0/dp_0.frz_bdg_0_freeze_conduit width {0}

add_connection frz_ctrl_0.bridge_freeze1 dp_0.st_bdg_0_freeze_conduit
set_connection_parameter_value frz_ctrl_0.bridge_freeze1/dp_0.st_bdg_0_freeze_conduit endPort {}
set_connection_parameter_value frz_ctrl_0.bridge_freeze1/dp_0.st_bdg_0_freeze_conduit endPortLSB {0}
set_connection_parameter_value frz_ctrl_0.bridge_freeze1/dp_0.st_bdg_0_freeze_conduit startPort {}
set_connection_parameter_value frz_ctrl_0.bridge_freeze1/dp_0.st_bdg_0_freeze_conduit startPortLSB {0}
set_connection_parameter_value frz_ctrl_0.bridge_freeze1/dp_0.st_bdg_0_freeze_conduit width {0}

add_connection frz_ctrl_0.bridge_freeze2 dp_0.st_bdg_1_freeze_conduit
set_connection_parameter_value frz_ctrl_0.bridge_freeze2/dp_0.st_bdg_1_freeze_conduit endPort {}
set_connection_parameter_value frz_ctrl_0.bridge_freeze2/dp_0.st_bdg_1_freeze_conduit endPortLSB {0}
set_connection_parameter_value frz_ctrl_0.bridge_freeze2/dp_0.st_bdg_1_freeze_conduit startPort {}
set_connection_parameter_value frz_ctrl_0.bridge_freeze2/dp_0.st_bdg_1_freeze_conduit startPortLSB {0}
set_connection_parameter_value frz_ctrl_0.bridge_freeze2/dp_0.st_bdg_1_freeze_conduit width {0}

add_connection frz_ctrl_0.pr_region_freeze0 dp_0.mixer_0_onchip_mem_freeze_interface
set_connection_parameter_value frz_ctrl_0.pr_region_freeze0/dp_0.mixer_0_onchip_mem_freeze_interface endPort {}
set_connection_parameter_value frz_ctrl_0.pr_region_freeze0/dp_0.mixer_0_onchip_mem_freeze_interface endPortLSB {0}
set_connection_parameter_value frz_ctrl_0.pr_region_freeze0/dp_0.mixer_0_onchip_mem_freeze_interface startPort {}
set_connection_parameter_value frz_ctrl_0.pr_region_freeze0/dp_0.mixer_0_onchip_mem_freeze_interface startPortLSB {0}
set_connection_parameter_value frz_ctrl_0.pr_region_freeze0/dp_0.mixer_0_onchip_mem_freeze_interface width {0}

add_connection ILC.irq frz_ctrl_0.interrupt_sender
set_connection_parameter_value ILC.irq/frz_ctrl_0.interrupt_sender irqNumber {2}

add_connection a10_hps.f2h_irq0 frz_ctrl_0.interrupt_sender
set_connection_parameter_value a10_hps.f2h_irq0/frz_ctrl_0.interrupt_sender irqNumber {2}

add_connection clk_100.out_clk frz_ctrl_0.clock

add_connection clk_100.out_clk pr_src_rst.clk 

add_connection rst_in.out_reset frz_ctrl_0.reset

add_connection a10_hps.h2f_reset frz_ctrl_0.reset

add_connection frz_ctrl_0.reset_source dp_0.pr_reset

add_connection frz_ctrl_0.reset_source pr_src_rst.in_reset
} else {
for {set k 0} {$k<$pr_region_count} {incr k} {
set frz_ctrl_offset [format 0x%x [expr [expr 0x10*$k]+0x450]] 
set frz_bdg_offset [format 0x%x [expr [expr 0x400*$k]+0x800]] 
add_connection pb_lwh2f.m0 frz_ctrl_${k}.avl_csr
set_connection_parameter_value pb_lwh2f.m0/frz_ctrl_${k}.avl_csr arbitrationPriority {1}
set_connection_parameter_value pb_lwh2f.m0/frz_ctrl_${k}.avl_csr baseAddress $frz_ctrl_offset
set_connection_parameter_value pb_lwh2f.m0/frz_ctrl_${k}.avl_csr defaultConnection {0}

add_connection pb_lwh2f.m0 frz_bdg_${k}.slv_bridge_to_sr
set_connection_parameter_value pb_lwh2f.m0/frz_bdg_${k}.slv_bridge_to_sr arbitrationPriority {1}
set_connection_parameter_value pb_lwh2f.m0/frz_bdg_${k}.slv_bridge_to_sr baseAddress $frz_bdg_offset
set_connection_parameter_value pb_lwh2f.m0/frz_bdg_${k}.slv_bridge_to_sr defaultConnection {0}

add_connection frz_bdg_${k}.slv_bridge_to_pr pr_region_${k}.pr_mm_bridge_0_s0
set_connection_parameter_value frz_bdg_${k}.slv_bridge_to_pr/pr_region_${k}.pr_mm_bridge_0_s0 arbitrationPriority {1}
set_connection_parameter_value frz_bdg_${k}.slv_bridge_to_pr/pr_region_${k}.pr_mm_bridge_0_s0 baseAddress {0x0000}
set_connection_parameter_value frz_bdg_${k}.slv_bridge_to_pr/pr_region_${k}.pr_mm_bridge_0_s0 defaultConnection {0}

if {$freeze_ack_dly_enable == 0} {
add_connection frz_ctrl_${k}.bridge_freeze0 frz_bdg_${k}.freeze_conduit
set_connection_parameter_value frz_ctrl_${k}.bridge_freeze0/frz_bdg_${k}.freeze_conduit endPort {}
set_connection_parameter_value frz_ctrl_${k}.bridge_freeze0/frz_bdg_${k}.freeze_conduit endPortLSB {0}
set_connection_parameter_value frz_ctrl_${k}.bridge_freeze0/frz_bdg_${k}.freeze_conduit startPort {}
set_connection_parameter_value frz_ctrl_${k}.bridge_freeze0/frz_bdg_${k}.freeze_conduit startPortLSB {0}
set_connection_parameter_value frz_ctrl_${k}.bridge_freeze0/frz_bdg_${k}.freeze_conduit width {0}
}

add_connection clk_100.out_clk pr_region_${k}.clk

add_connection clk_100.out_clk frz_bdg_${k}.clock

add_connection clk_100.out_clk frz_ctrl_${k}.clock

add_connection rst_in.out_reset pr_region_${k}.reset

add_connection rst_in.out_reset frz_bdg_${k}.reset_n

add_connection a10_hps.h2f_reset pr_region_${k}.reset

add_connection a10_hps.h2f_reset frz_bdg_${k}.reset_n

add_connection frz_ctrl_${k}.reset_source pr_region_${k}.reset

add_connection rst_in.out_reset frz_ctrl_${k}.reset

add_connection a10_hps.h2f_reset frz_ctrl_${k}.reset

set frz_ctrl_int [expr 2+$k]
add_connection ILC.irq frz_ctrl_${k}.interrupt_sender
set_connection_parameter_value ILC.irq/frz_ctrl_${k}.interrupt_sender irqNumber $frz_ctrl_int

add_connection a10_hps.f2h_irq0 frz_ctrl_${k}.interrupt_sender
set_connection_parameter_value a10_hps.f2h_irq0/frz_ctrl_${k}.interrupt_sender irqNumber $frz_ctrl_int
}

if {$freeze_ack_dly_enable == 1} {
add_connection pb_lwh2f.m0 start_ack_pio.s1 
set_connection_parameter_value pb_lwh2f.m0/start_ack_pio.s1 arbitrationPriority {1}
set_connection_parameter_value pb_lwh2f.m0/start_ack_pio.s1 baseAddress {0x1800}
set_connection_parameter_value pb_lwh2f.m0/start_ack_pio.s1 defaultConnection {0}

add_connection pb_lwh2f.m0 stop_ack_pio.s1 
set_connection_parameter_value pb_lwh2f.m0/stop_ack_pio.s1 arbitrationPriority {1}
set_connection_parameter_value pb_lwh2f.m0/stop_ack_pio.s1 baseAddress {0x1810}
set_connection_parameter_value pb_lwh2f.m0/stop_ack_pio.s1 defaultConnection {0}

add_connection clk_100.out_clk start_ack_pio.clk

add_connection clk_100.out_clk stop_ack_pio.clk

add_connection rst_in.out_reset stop_ack_pio.reset 

add_connection rst_in.out_reset start_ack_pio.reset 

add_connection a10_hps.h2f_reset stop_ack_pio.reset 

add_connection a10_hps.h2f_reset start_ack_pio.reset
}
}

if {$pr_ip_enable == 1}  {
add_connection pb_lwh2f.m0 pr_ip.avmm_slave
set_connection_parameter_value pb_lwh2f.m0/pr_ip.avmm_slave arbitrationPriority {1}
set_connection_parameter_value pb_lwh2f.m0/pr_ip.avmm_slave baseAddress {0xc000}
set_connection_parameter_value pb_lwh2f.m0/pr_ip.avmm_slave defaultConnection {0}
add_connection clk_100.out_clk pr_ip.clk
add_connection rst_in.out_reset pr_ip.nreset  
}
}

if {$fpga_ocm_msgdma_enable ==1} {
add_connection clk_100.out_clk hps2ocm_msgdma.clock
add_connection rst_in.out_reset hps2ocm_msgdma.reset_n

add_connection pb_lwh2f.m0/hps2ocm_msgdma.csr
set_connection_parameter_value pb_lwh2f.m0/hps2ocm_msgdma.csr arbitrationPriority {1}
set_connection_parameter_value pb_lwh2f.m0/hps2ocm_msgdma.csr defaultConnection {0}
set_connection_parameter_value pb_lwh2f.m0/hps2ocm_msgdma.csr baseAddress {0x100000}

add_connection a10_hps.f2h_irq0/hps2ocm_msgdma.csr_irq
set_connection_parameter_value a10_hps.f2h_irq0/hps2ocm_msgdma.csr_irq irqNumber 2

add_connection pb_lwh2f.m0/hps2ocm_msgdma.descriptor_slave
set_connection_parameter_value pb_lwh2f.m0/hps2ocm_msgdma.descriptor_slave arbitrationPriority {1}
set_connection_parameter_value pb_lwh2f.m0/hps2ocm_msgdma.descriptor_slave defaultConnection {0}
set_connection_parameter_value pb_lwh2f.m0/hps2ocm_msgdma.descriptor_slave baseAddress {0x100020}

add_connection hps2ocm_msgdma.mm_read/a10_hps.f2h_axi_slave
add_connection hps2ocm_msgdma.mm_write/ocm_0.s1

add_connection clk_100.out_clk ocm2hps_msgdma.clock
add_connection rst_in.out_reset ocm2hps_msgdma.reset_n

add_connection pb_lwh2f.m0/ocm2hps_msgdma.csr
set_connection_parameter_value pb_lwh2f.m0/ocm2hps_msgdma.csr arbitrationPriority {1}
set_connection_parameter_value pb_lwh2f.m0/ocm2hps_msgdma.csr defaultConnection {0}
set_connection_parameter_value pb_lwh2f.m0/ocm2hps_msgdma.csr baseAddress {0x100040}

add_connection a10_hps.f2h_irq0/ocm2hps_msgdma.csr_irq
set_connection_parameter_value a10_hps.f2h_irq0/ocm2hps_msgdma.csr_irq irqNumber 3

add_connection pb_lwh2f.m0/ocm2hps_msgdma.descriptor_slave
set_connection_parameter_value pb_lwh2f.m0/ocm2hps_msgdma.descriptor_slave arbitrationPriority {1}
set_connection_parameter_value pb_lwh2f.m0/ocm2hps_msgdma.descriptor_slave defaultConnection {0}
set_connection_parameter_value pb_lwh2f.m0/ocm2hps_msgdma.descriptor_slave baseAddress {0x100060}

add_connection ocm2hps_msgdma.mm_read/ocm_0.s1
set_connection_parameter_value ocm2hps_msgdma.mm_read/ocm_0.s1 arbitrationPriority {1}
set_connection_parameter_value ocm2hps_msgdma.mm_read/ocm_0.s1 defaultConnection {0}

add_connection ocm2hps_msgdma.mm_write/a10_hps.f2h_axi_slave
set_connection_parameter_value ocm2hps_msgdma.mm_write/a10_hps.f2h_axi_slave arbitrationPriority {1}
set_connection_parameter_value ocm2hps_msgdma.mm_write/a10_hps.f2h_axi_slave defaultConnection {0}
}

if {$fpga_tse == 1} {
if {$niosii_en == 1} {
add_connection a10_emif.pll_extra_clk_2_clock_source tse_ccb.s0_clk

add_connection a10_emif.emif_usr_clk_clock_source tse_ccb.m0_clk

add_connection a10_emif.emif_usr_reset_reset_source tse_ccb.m0_reset

add_connection cpu.debug_reset_request tse_ccb.m0_reset

add_connection rst_in.out_reset tse_ccb.m0_reset

add_connection a10_emif.emif_usr_reset_reset_source tse_ccb.s0_reset

add_connection cpu.debug_reset_request tse_ccb.s0_reset

add_connection rst_in.out_reset tse_ccb.s0_reset

add_connection tse_ccb.m0/ddr_ext.windowed_slave
set_connection_parameter_value tse_ccb.m0/ddr_ext.windowed_slave arbitrationPriority {1}
set_connection_parameter_value tse_ccb.m0/ddr_ext.windowed_slave baseAddress {0x0000}
set_connection_parameter_value tse_ccb.m0/ddr_ext.windowed_slave defaultConnection {0}

for {set j 0} {$j<2} {incr j} {
set mm_bg_slave_offset [format 0x%x [expr [expr 0x800*$j]+0x1000]] 
add_connection pb_c2ph.m0 tse_${j}.mm_bg_0_s0
set_connection_parameter_value pb_c2ph.m0/tse_${j}.mm_bg_0_s0 arbitrationPriority {1}
set_connection_parameter_value pb_c2ph.m0/tse_${j}.mm_bg_0_s0 baseAddress $mm_bg_slave_offset
set_connection_parameter_value pb_c2ph.m0/tse_${j}.mm_bg_0_s0 defaultConnection {0}

add_connection tse_${j}.msgdma_rx_mm_write/tse_ccb.s0
set_connection_parameter_value tse_${j}.msgdma_rx_mm_write/tse_ccb.s0 arbitrationPriority {1}
set_connection_parameter_value tse_${j}.msgdma_rx_mm_write/tse_ccb.s0 baseAddress {0x0000}
set_connection_parameter_value tse_${j}.msgdma_rx_mm_write/tse_ccb.s0 defaultConnection {0}

add_connection tse_${j}.msgdma_tx_mm_read/tse_ccb.s0
set_connection_parameter_value tse_${j}.msgdma_tx_mm_read/tse_ccb.s0 arbitrationPriority {1}
set_connection_parameter_value tse_${j}.msgdma_tx_mm_read/tse_ccb.s0 baseAddress {0x0000}
set_connection_parameter_value tse_${j}.msgdma_tx_mm_read/tse_ccb.s0 defaultConnection {0}

if {$dma_prefetch_enable == 1} {
add_connection tse_${j}.msgdma_rx_descriptor_read_master tse_ccb.s0
set_connection_parameter_value tse_${j}.msgdma_rx_descriptor_read_master/tse_ccb.s0 arbitrationPriority {1}
set_connection_parameter_value tse_${j}.msgdma_rx_descriptor_read_master/tse_ccb.s0 baseAddress {0x0}
set_connection_parameter_value tse_${j}.msgdma_rx_descriptor_read_master/tse_ccb.s0 defaultConnection {0}

add_connection tse_${j}.msgdma_tx_descriptor_read_master tse_ccb.s0
set_connection_parameter_value tse_${j}.msgdma_tx_descriptor_read_master/tse_ccb.s0 arbitrationPriority {1}
set_connection_parameter_value tse_${j}.msgdma_tx_descriptor_read_master/tse_ccb.s0 baseAddress {0x0}
set_connection_parameter_value tse_${j}.msgdma_tx_descriptor_read_master/tse_ccb.s0 defaultConnection {0}

add_connection tse_${j}.msgdma_rx_descriptor_write_master tse_ccb.s0
set_connection_parameter_value tse_${j}.msgdma_rx_descriptor_write_master/tse_ccb.s0 arbitrationPriority {1}
set_connection_parameter_value tse_${j}.msgdma_rx_descriptor_write_master/tse_ccb.s0 baseAddress {0x0}
set_connection_parameter_value tse_${j}.msgdma_rx_descriptor_write_master/tse_ccb.s0 defaultConnection {0}

add_connection tse_${j}.msgdma_tx_descriptor_write_master tse_ccb.s0
set_connection_parameter_value tse_${j}.msgdma_tx_descriptor_write_master/tse_ccb.s0 arbitrationPriority {1}
set_connection_parameter_value tse_${j}.msgdma_tx_descriptor_write_master/tse_ccb.s0 baseAddress {0x0}
set_connection_parameter_value tse_${j}.msgdma_tx_descriptor_write_master/tse_ccb.s0 defaultConnection {0}
}

if {$mdio_clk_div == 50} {
add_connection a10_emif.pll_extra_clk_2_clock_source tse_${j}.clk
} else {
add_connection a10_emif.pll_extra_clk_2_clock_source tse_${j}.clk
}

add_connection enet_cb.out_clk tse_${j}.refclk_125

add_connection a10_emif.emif_usr_reset_reset_source tse_${j}.reset

add_connection cpu.debug_reset_request tse_${j}.reset

add_connection rst_in.out_reset tse_${j}.reset

set rx_int_no [expr [expr 2*$j]+7]
set tx_int_no [expr [expr 2*$j]+8]

add_connection periph.ILC_irq tse_${j}.msgdma_rx_csr_irq
set_connection_parameter_value periph.ILC_irq/tse_${j}.msgdma_rx_csr_irq irqNumber $rx_int_no

add_connection periph.ILC_irq tse_${j}.msgdma_tx_csr_irq
set_connection_parameter_value periph.ILC_irq/tse_${j}.msgdma_tx_csr_irq irqNumber $tx_int_no

add_connection cpu.irq tse_${j}.msgdma_rx_csr_irq
set_connection_parameter_value cpu.irq/tse_${j}.msgdma_rx_csr_irq irqNumber $rx_int_no

add_connection cpu.irq tse_${j}.msgdma_tx_csr_irq
set_connection_parameter_value cpu.irq/tse_${j}.msgdma_tx_csr_irq irqNumber $tx_int_no
}
} else {
if {$mdio_clk_div == 50} {
add_connection clk_100.out_clk tse_pll.refclk

add_connection rst_in.out_reset tse_pll.reset

add_connection a10_hps.h2f_reset tse_pll.reset 

add_connection tse_pll.outclk0 pb_f2sdram.clk
} else {
add_connection clk_100.out_clk pb_f2sdram.clk 
}

add_connection rst_in.out_reset pb_f2sdram.reset 

add_connection a10_hps.h2f_reset pb_f2sdram.reset 

add_connection pb_f2sdram.m0 a10_hps.f2sdram2_data
set_connection_parameter_value pb_f2sdram.m0/a10_hps.f2sdram2_data arbitrationPriority {1}
set_connection_parameter_value pb_f2sdram.m0/a10_hps.f2sdram2_data baseAddress {0x0000}
set_connection_parameter_value pb_f2sdram.m0/a10_hps.f2sdram2_data defaultConnection {0}

for {set j 0} {$j<2} {incr j} {
set mm_bg_slave_offset [format 0x%x [expr [expr 0x800*$j]+0x1000]] 
add_connection pb_lwh2f.m0 tse_${j}.mm_bg_0_s0
set_connection_parameter_value pb_lwh2f.m0/tse_${j}.mm_bg_0_s0 arbitrationPriority {1}
set_connection_parameter_value pb_lwh2f.m0/tse_${j}.mm_bg_0_s0 baseAddress $mm_bg_slave_offset
set_connection_parameter_value pb_lwh2f.m0/tse_${j}.mm_bg_0_s0 defaultConnection {0}

add_connection tse_${j}.msgdma_rx_mm_write pb_f2sdram.s0
set_connection_parameter_value tse_${j}.msgdma_rx_mm_write/pb_f2sdram.s0 arbitrationPriority {1}
set_connection_parameter_value tse_${j}.msgdma_rx_mm_write/pb_f2sdram.s0 baseAddress {0x0000}
set_connection_parameter_value tse_${j}.msgdma_rx_mm_write/pb_f2sdram.s0 defaultConnection {0}

add_connection tse_${j}.msgdma_tx_mm_read pb_f2sdram.s0
set_connection_parameter_value tse_${j}.msgdma_tx_mm_read/pb_f2sdram.s0 arbitrationPriority {1}
set_connection_parameter_value tse_${j}.msgdma_tx_mm_read/pb_f2sdram.s0 baseAddress {0x0000}
set_connection_parameter_value tse_${j}.msgdma_tx_mm_read/pb_f2sdram.s0 defaultConnection {0}

if {$dma_prefetch_enable == 1} {
add_connection tse_${j}.msgdma_rx_descriptor_read_master pb_f2sdram.s0
set_connection_parameter_value tse_${j}.msgdma_rx_descriptor_read_master/pb_f2sdram.s0 arbitrationPriority {1}
set_connection_parameter_value tse_${j}.msgdma_rx_descriptor_read_master/pb_f2sdram.s0 baseAddress {0x0000}
set_connection_parameter_value tse_${j}.msgdma_rx_descriptor_read_master/pb_f2sdram.s0 defaultConnection {0}

add_connection tse_${j}.msgdma_tx_descriptor_read_master pb_f2sdram.s0
set_connection_parameter_value tse_${j}.msgdma_tx_descriptor_read_master/pb_f2sdram.s0 arbitrationPriority {1}
set_connection_parameter_value tse_${j}.msgdma_tx_descriptor_read_master/pb_f2sdram.s0 baseAddress {0x0000}
set_connection_parameter_value tse_${j}.msgdma_tx_descriptor_read_master/pb_f2sdram.s0 defaultConnection {0}

add_connection tse_${j}.msgdma_rx_descriptor_write_master pb_f2sdram.s0
set_connection_parameter_value tse_${j}.msgdma_rx_descriptor_write_master/pb_f2sdram.s0 arbitrationPriority {1}
set_connection_parameter_value tse_${j}.msgdma_rx_descriptor_write_master/pb_f2sdram.s0 baseAddress {0x0000}
set_connection_parameter_value tse_${j}.msgdma_rx_descriptor_write_master/pb_f2sdram.s0 defaultConnection {0}

add_connection tse_${j}.msgdma_tx_descriptor_write_master pb_f2sdram.s0
set_connection_parameter_value tse_${j}.msgdma_tx_descriptor_write_master/pb_f2sdram.s0 arbitrationPriority {1}
set_connection_parameter_value tse_${j}.msgdma_tx_descriptor_write_master/pb_f2sdram.s0 baseAddress {0x0000}
set_connection_parameter_value tse_${j}.msgdma_tx_descriptor_write_master/pb_f2sdram.s0 defaultConnection {0}
}

if {$mdio_clk_div == 50} {
add_connection tse_pll.outclk0 tse_${j}.clk
} else {
add_connection clk_100.out_clk tse_${j}.clk
}
add_connection enet_cb.out_clk tse_${j}.refclk_125

add_connection rst_in.out_reset tse_${j}.reset

add_connection a10_hps.h2f_reset tse_${j}.reset

set rx_int_no [expr [expr 2*$j]+2]
set tx_int_no [expr [expr 2*$j]+3]

add_connection ILC.irq tse_${j}.msgdma_rx_csr_irq
set_connection_parameter_value ILC.irq/tse_${j}.msgdma_rx_csr_irq irqNumber $rx_int_no

add_connection ILC.irq tse_${j}.msgdma_tx_csr_irq
set_connection_parameter_value ILC.irq/tse_${j}.msgdma_tx_csr_irq irqNumber $tx_int_no

add_connection a10_hps.f2h_irq0 tse_${j}.msgdma_rx_csr_irq
set_connection_parameter_value a10_hps.f2h_irq0/tse_${j}.msgdma_rx_csr_irq irqNumber $rx_int_no

add_connection a10_hps.f2h_irq0 tse_${j}.msgdma_tx_csr_irq
set_connection_parameter_value a10_hps.f2h_irq0/tse_${j}.msgdma_tx_csr_irq irqNumber $tx_int_no
}
}
}

# exported interfaces
add_interface clk_100 clock sink
set_interface_property clk_100 EXPORT_OF clk_100.in_clk
add_interface reset reset sink
set_interface_property reset EXPORT_OF rst_in.in_reset
# NiosII soft processor
if {$niosii_en == 1} {
add_interface emif_usr_reset reset source
set_interface_property emif_usr_reset EXPORT_OF rst_bdg.out_reset
add_interface a10_emif_mem conduit end
set_interface_property a10_emif_mem EXPORT_OF a10_emif.mem_conduit_end
add_interface a10_emif_ctrl_ecc_user_interrupt conduit end
set_interface_property a10_emif_ctrl_ecc_user_interrupt EXPORT_OF a10_emif.ctrl_ecc_user_interrupt_conduit_end_0
add_interface a10_emif_pll_ref_clk_clock clock sink
set_interface_property a10_emif_pll_ref_clk_clock EXPORT_OF a10_emif.pll_ref_clk_clock_sink
add_interface a10_emif_oct conduit end
set_interface_property a10_emif_oct EXPORT_OF a10_emif.oct_conduit_end
add_interface a10_emif_status conduit end
set_interface_property a10_emif_status EXPORT_OF a10_emif.status_conduit_end
add_interface uart_16550_rs_232_modem conduit end
set_interface_property uart_16550_rs_232_modem EXPORT_OF periph.uart_16550_RS_232_Modem
add_interface uart_16550_rs_232_serial conduit end
set_interface_property uart_16550_rs_232_serial EXPORT_OF periph.uart_16550_RS_232_Serial
add_interface button_pio_external_connection conduit end
set_interface_property button_pio_external_connection EXPORT_OF periph.button_pio_external_connection
add_interface dipsw_pio_external_connection conduit end
set_interface_property dipsw_pio_external_connection EXPORT_OF periph.dipsw_pio_external_connection
add_interface led_pio_external_connection conduit end
set_interface_property led_pio_external_connection EXPORT_OF periph.led_pio_external_connection
add_interface irq_bg_receiver_irq interrupt receiver
set_interface_property irq_bg_receiver_irq EXPORT_OF irq_bg.receiver_irq
add_interface qspi_pll_locked conduit end
set_interface_property qspi_pll_locked EXPORT_OF qspi_pll.locked
} else {
# HPS Processor
if {$hps_sdram == "D9RPL" || $hps_sdram == "D9PZN" || $hps_sdram == "D9RGX" || $hps_sdram == "D9TNZ" || $hps_sdram == "D9WFH"} {
add_interface emif_a10_hps_0_mem_conduit_end conduit end
set_interface_property emif_a10_hps_0_mem_conduit_end EXPORT_OF emif_hps.mem_conduit_end
add_interface emif_a10_hps_0_oct_conduit_end conduit end
set_interface_property emif_a10_hps_0_oct_conduit_end EXPORT_OF emif_hps.oct_conduit_end
add_interface emif_a10_hps_0_pll_ref_clk_clock_sink clock sink
set_interface_property emif_a10_hps_0_pll_ref_clk_clock_sink EXPORT_OF emif_hps.pll_ref_clk_clock_sink
}
if {$boot_device == "FPGA"} {
add_interface f2h_boot_from_fpga conduit end
set_interface_property f2h_boot_from_fpga EXPORT_OF a10_hps.f2h_boot_from_fpga
}
add_interface f2h_cold_reset_req reset sink
set_interface_property f2h_cold_reset_req EXPORT_OF a10_hps.f2h_cold_reset_req
add_interface f2h_debug_reset_req reset sink
set_interface_property f2h_debug_reset_req EXPORT_OF a10_hps.f2h_debug_reset_req
add_interface f2h_stm_hw_events conduit end
set_interface_property f2h_stm_hw_events EXPORT_OF a10_hps.f2h_stm_hw_events
add_interface f2h_warm_reset_req reset sink
set_interface_property f2h_warm_reset_req EXPORT_OF a10_hps.f2h_warm_reset_req
add_interface hps_fpga_reset reset source
set_interface_property hps_fpga_reset EXPORT_OF rst_bdg.out_reset
add_interface hps_io conduit end
set_interface_property hps_io EXPORT_OF a10_hps.hps_io
add_interface pio_button_external_connection conduit end
set_interface_property pio_button_external_connection EXPORT_OF button_pio.external_connection
add_interface pio_dipsw_external_connection conduit end
set_interface_property pio_dipsw_external_connection EXPORT_OF dipsw_pio.external_connection
add_interface pio_led_external_connection conduit end
set_interface_property pio_led_external_connection EXPORT_OF led_pio.external_connection

if {$hps_i2c_fpga_if == 1} {
add_interface i2c1_sda_buff_dout conduit end
set_interface_property i2c1_sda_buff_dout EXPORT_OF i2c1_sda.dout
add_interface i2c1_sda_buff_din conduit end
set_interface_property i2c1_sda_buff_din EXPORT_OF i2c1_sda.din
add_interface i2c1_sda_buff_oe conduit end
set_interface_property i2c1_sda_buff_oe EXPORT_OF i2c1_sda.oe
add_interface i2c1_sda_buff_pad_io conduit end
set_interface_property i2c1_sda_buff_pad_io EXPORT_OF i2c1_sda.pad_io

add_interface i2c1_scl_dout conduit end
set_interface_property i2c1_scl_dout EXPORT_OF i2c1_scl.dout
add_interface i2c1_scl_din conduit end
set_interface_property i2c1_scl_din EXPORT_OF i2c1_scl.din
add_interface i2c1_scl_oe conduit end
set_interface_property i2c1_scl_oe EXPORT_OF i2c1_scl.oe
add_interface i2c1_scl_pad_io conduit end
set_interface_property i2c1_scl_pad_io EXPORT_OF i2c1_scl.pad_io
}

if {$fast_trace == 1} {
add_interface trace_wrapper_0_f2h_clk_in conduit end
set_interface_property trace_wrapper_0_f2h_clk_in EXPORT_OF trace_wrapper_0.f2h_clk_in
add_interface trace_wrapper_0_trace_data_out conduit end
set_interface_property trace_wrapper_0_trace_data_out EXPORT_OF trace_wrapper_0.trace_data_out
add_interface trace_wrapper_0_trace_clk_out clock source
set_interface_property trace_wrapper_0_trace_clk_out EXPORT_OF trace_wrapper_0.trace_clk_out
}

add_interface issp_hps_resets conduit end
set_interface_property issp_hps_resets EXPORT_OF issp_0.sources

# HPS EMAC SGMII subsystem
if {$hps_sgmii == 1} {

# required additional interrupts from PHY
add_interface f2h_irq conduit end
set_interface_property f2h_irq EXPORT_OF a10_hps.f2h_irq1

add_interface arria10_hps_0_emac_ptp_ref_clock clock sink
set_interface_property arria10_hps_0_emac_ptp_ref_clock EXPORT_OF a10_hps.emac_ptp_ref_clock
add_interface ref_clk_125 clock sink
if {$sgmii_count == 1} {
set_interface_property ref_clk_125 EXPORT_OF sgmii_1.clk_125
} else {
set_interface_property ref_clk_125 EXPORT_OF clk_bdg_enet.in_clk
for {set x 1} {$x<=$sgmii_count} {incr x} {
add_connection clk_bdg_enet.out_clk sgmii_${x}.clk_125  
}
}
  
for {set x 1} {$x<=$sgmii_count} {incr x} {
#### added to force exportation of mdc of hps, case:278470
add_interface emac${x}_md_clk clock source
set_interface_property emac${x}_md_clk EXPORT_OF a10_hps.emac${x}_md_clk
add_interface sgmii_${x}_emac_mdio conduit end
set_interface_property sgmii_${x}_emac_mdio EXPORT_OF sgmii_${x}.emac_mdio
add_interface sgmii_${x}_emac_ptp conduit end
set_interface_property sgmii_${x}_emac_ptp EXPORT_OF sgmii_${x}.emac_ptp
add_interface sgmii_${x}_tse_rx_is_lockedtoref conduit end
set_interface_property sgmii_${x}_tse_rx_is_lockedtoref EXPORT_OF sgmii_${x}.tse_rx_is_lockedtoref
add_interface sgmii_${x}_tse_rx_set_locktodata conduit end
set_interface_property sgmii_${x}_tse_rx_set_locktodata EXPORT_OF sgmii_${x}.tse_rx_set_locktodata
add_interface sgmii_${x}_tse_rx_set_locktoref conduit end
set_interface_property sgmii_${x}_tse_rx_set_locktoref EXPORT_OF sgmii_${x}.tse_rx_set_locktoref
add_interface sgmii_${x}_tse_serdes_control_connection conduit end
set_interface_property sgmii_${x}_tse_serdes_control_connection EXPORT_OF sgmii_${x}.tse_serdes_control_connection
add_interface sgmii_${x}_tse_serial_connection conduit end
set_interface_property sgmii_${x}_tse_serial_connection EXPORT_OF sgmii_${x}.tse_serial_connection
add_interface sgmii_${x}_tse_sgmii_status_connection conduit end
set_interface_property sgmii_${x}_tse_sgmii_status_connection EXPORT_OF sgmii_${x}.tse_sgmii_status_connection
add_interface sgmii_${x}_tse_status_led_connection conduit end
set_interface_property sgmii_${x}_tse_status_led_connection EXPORT_OF sgmii_${x}.tse_status_led_connection
add_interface sgmii_${x}_xcvr_reset_control_0_pll_select conduit end
set_interface_property sgmii_${x}_xcvr_reset_control_0_pll_select EXPORT_OF sgmii_${x}.xcvr_reset_control_0_pll_select
add_interface sgmii_${x}_xcvr_reset_control_0_rx_ready conduit end
set_interface_property sgmii_${x}_xcvr_reset_control_0_rx_ready EXPORT_OF sgmii_${x}.xcvr_reset_control_0_rx_ready
add_interface sgmii_${x}_xcvr_reset_control_0_tx_ready conduit end
set_interface_property sgmii_${x}_xcvr_reset_control_0_tx_ready EXPORT_OF sgmii_${x}.xcvr_reset_control_0_tx_ready
}
}
}

# Display Port subsystem
if {$fpga_dp == 1} {
if {$pr_dp_mix_enable == 1} {
add_interface pr_source_reset reset sink
set_interface_property pr_source_reset EXPORT_OF pr_src_rst.out_reset
}
add_interface issp_dp_out conduit end
set_interface_property issp_dp_out EXPORT_OF issp_dp.sources
add_interface dp_0_video_pll_refclk clock sink
set_interface_property dp_0_video_pll_refclk EXPORT_OF dp_0.video_pll_refclk
add_interface dp_0_video_pll_locked conduit end
set_interface_property dp_0_video_pll_locked EXPORT_OF dp_0.video_pll_locked
add_interface dp_0_video_pll_outclk0 clock source
set_interface_property dp_0_video_pll_outclk0 EXPORT_OF dp_0.video_pll_outclk0
add_interface dp_0_video_pll_outclk1 clock source
set_interface_property dp_0_video_pll_outclk1 EXPORT_OF dp_0.video_pll_outclk1
add_interface dp_0_video_pll_outclk2 clock source
set_interface_property dp_0_video_pll_outclk2 EXPORT_OF dp_0.video_pll_outclk2
add_interface dp_0_bitec_dp_0_clk_cal clock sink
set_interface_property dp_0_bitec_dp_0_clk_cal EXPORT_OF dp_0.bitec_dp_0_clk_cal
add_interface dp_0_bitec_dp_0_tx conduit end
set_interface_property dp_0_bitec_dp_0_tx EXPORT_OF dp_0.bitec_dp_0_tx
add_interface dp_0_bitec_dp_0_tx0_video_in conduit end
set_interface_property dp_0_bitec_dp_0_tx0_video_in EXPORT_OF dp_0.bitec_dp_0_tx0_video_in
add_interface dp_0_bitec_dp_0_tx0_video_in_1 clock sink
set_interface_property dp_0_bitec_dp_0_tx0_video_in_1 EXPORT_OF dp_0.bitec_dp_0_tx0_video_in_1
add_interface dp_0_bitec_dp_0_tx_analog_reconfig conduit end
set_interface_property dp_0_bitec_dp_0_tx_analog_reconfig EXPORT_OF dp_0.bitec_dp_0_tx_analog_reconfig
add_interface dp_0_bitec_dp_0_tx_aux conduit end
set_interface_property dp_0_bitec_dp_0_tx_aux EXPORT_OF dp_0.bitec_dp_0_tx_aux
add_interface dp_0_bitec_dp_0_tx_reconfig conduit end
set_interface_property dp_0_bitec_dp_0_tx_reconfig EXPORT_OF dp_0.bitec_dp_0_tx_reconfig
add_interface dp_0_clk_16 clock sink
set_interface_property dp_0_clk_16 EXPORT_OF dp_0.clk_16
add_interface dp_0_clk_vip clock sink
set_interface_property dp_0_clk_vip EXPORT_OF clock_bridge_0.in_clk
add_interface dp_0_cvo_clocked_video conduit end
set_interface_property dp_0_cvo_clocked_video EXPORT_OF dp_0.cvo_clocked_video
add_interface dp_0_pio_0_external_connection conduit end
set_interface_property dp_0_pio_0_external_connection EXPORT_OF dp_0.pio_0_external_connection
add_interface dp_0_fpll_0_mcgb_rst conduit end
set_interface_property dp_0_fpll_0_mcgb_rst EXPORT_OF dp_0.fpll_0_mcgb_rst
add_interface dp_0_fpll_0_pll_cal_busy conduit end
set_interface_property dp_0_fpll_0_pll_cal_busy EXPORT_OF dp_0.fpll_0_pll_cal_busy
add_interface dp_0_xcvr_fpll_0_pll_locked conduit end
set_interface_property dp_0_fpll_0_pll_locked EXPORT_OF dp_0.fpll_0_pll_locked
add_interface dp_0_fpll_0_pll_refclk0 clock sink
set_interface_property dp_0_fpll_0_pll_refclk0 EXPORT_OF dp_0.fpll_0_pll_refclk0
add_interface dp_0_fpll_0_reconfig_avmm0 avalon slave
set_interface_property dp_0_fpll_0_reconfig_avmm0 EXPORT_OF dp_0.fpll_0_reconfig_avmm0
add_interface dp_0_fpll_0_tx_serial_clk hssi_serial_clock source
set_interface_property dp_0_fpll_0_tx_serial_clk EXPORT_OF dp_0.fpll_0_tx_serial_clk
add_interface dp_0_a10_xcvr_reconfig_avmm_ch0 avalon slave
set_interface_property dp_0_a10_xcvr_reconfig_avmm_ch0 EXPORT_OF dp_0.a10_xcvr_reconfig_avmm_ch0
for {set i 0} {$i<4} {incr i} {
add_interface dp_0_a10_xcvr_tx_analogreset_ack_ch${i} conduit end
set_interface_property dp_0_a10_xcvr_tx_analogreset_ack_ch${i} EXPORT_OF dp_0.a10_xcvr_tx_analogreset_ack_ch${i}
add_interface dp_0_a10_xcvr_tx_analogreset_ch${i} conduit end
set_interface_property dp_0_a10_xcvr_tx_analogreset_ch${i} EXPORT_OF dp_0.a10_xcvr_tx_analogreset_ch${i}
add_interface dp_0_a10_xcvr_tx_cal_busy_ch${i} conduit end
set_interface_property dp_0_a10_xcvr_tx_cal_busy_ch${i} EXPORT_OF dp_0.a10_xcvr_tx_cal_busy_ch${i}
add_interface dp_0_a10_xcvr_tx_clkout_ch${i} clock source
set_interface_property dp_0_a10_xcvr_tx_clkout_ch${i} EXPORT_OF dp_0.a10_xcvr_tx_clkout_ch${i}
add_interface dp_0_a10_xcvr_tx_coreclkin_ch${i} clock sink
set_interface_property dp_0_a10_xcvr_tx_coreclkin_ch${i} EXPORT_OF dp_0.a10_xcvr_tx_coreclkin_ch${i}
add_interface dp_0_a10_xcvr_tx_digitalreset_ch${i} conduit end
set_interface_property dp_0_a10_xcvr_tx_digitalreset_ch${i} EXPORT_OF dp_0.a10_xcvr_tx_digitalreset_ch${i}
add_interface dp_0_a10_xcvr_tx_parallel_data_ch${i} conduit end
set_interface_property dp_0_a10_xcvr_tx_parallel_data_ch${i} EXPORT_OF dp_0.a10_xcvr_tx_parallel_data_ch${i}
add_interface dp_0_a10_xcvr_tx_polinv_ch${i} conduit end
set_interface_property dp_0_a10_xcvr_tx_polinv_ch${i} EXPORT_OF dp_0.a10_xcvr_tx_polinv_ch${i}
add_interface dp_0_a10_xcvr_tx_serial_data_ch${i} conduit end
set_interface_property dp_0_a10_xcvr_tx_serial_data_ch${i} EXPORT_OF dp_0.a10_xcvr_tx_serial_data_ch${i}
}
add_interface dp_0_a10_xcvr_unused_tx_parallel_data conduit end
set_interface_property dp_0_a10_xcvr_unused_tx_parallel_data EXPORT_OF dp_0.a10_xcvr_unused_tx_parallel_data
add_interface dp_0_xcvr_ctrl_pll_locked conduit end
set_interface_property dp_0_xcvr_ctrl_pll_locked EXPORT_OF dp_0.xcvr_ctrl_pll_locked
add_interface dp_0_xcvr_ctrl_pll_select conduit end
set_interface_property dp_0_xcvr_ctrl_pll_select EXPORT_OF dp_0.xcvr_ctrl_pll_select
add_interface dp_0_xcvr_ctrl_reset reset sink
set_interface_property dp_0_xcvr_ctrl_reset EXPORT_OF dp_0.xcvr_ctrl_reset
add_interface dp_0_xcvr_ctrl_tx_analogreset conduit end
set_interface_property dp_0_xcvr_ctrl_tx_analogreset EXPORT_OF dp_0.xcvr_ctrl_tx_analogreset
add_interface dp_0_xcvr_ctrl_tx_cal_busy conduit end
set_interface_property dp_0_xcvr_ctrl_tx_cal_busy EXPORT_OF dp_0.xcvr_ctrl_tx_cal_busy
add_interface dp_0_xcvr_ctrl_tx_digitalreset conduit end
set_interface_property dp_0_xcvr_ctrl_tx_digitalreset EXPORT_OF dp_0.xcvr_ctrl_tx_digitalreset
add_interface dp_0_xcvr_ctrl_tx_ready conduit end
set_interface_property dp_0_xcvr_ctrl_tx_ready EXPORT_OF dp_0.xcvr_ctrl_tx_ready
}

# PCIe subsystem
if {$fpga_pcie == 1} {
if {$pcie_gen == 3 || $pcie_count == 8} {
add_interface iopll_0_locked conduit end
set_interface_property iopll_0_locked EXPORT_OF iopll_0.locked
}
add_interface pcie_0_pcie_a10_hip_avmm_refclk clock source
set_interface_property pcie_0_pcie_a10_hip_avmm_refclk EXPORT_OF pcie_0.pcie_a10_hip_avmm_refclk
add_interface pcie_0_coreclk_fanout_clk clock source
set_interface_property pcie_0_coreclk_fanout_clk EXPORT_OF pcie_0.coreclk_fanout_clk
add_interface pcie_0_coreclk_fanout_clk_reset reset source
set_interface_property pcie_0_coreclk_fanout_clk_reset EXPORT_OF pcie_0.coreclk_fanout_clk_reset
add_interface pcie_0_pcie_a10_hip_avmm_currentspeed conduit end
set_interface_property pcie_0_pcie_a10_hip_avmm_currentspeed EXPORT_OF pcie_0.pcie_a10_hip_avmm_currentspeed
add_interface pcie_0_pcie_a10_hip_avmm_hip_ctrl conduit end
set_interface_property pcie_0_pcie_a10_hip_avmm_hip_ctrl EXPORT_OF pcie_0.pcie_a10_hip_avmm_hip_ctrl
add_interface pcie_0_pcie_a10_hip_avmm_hip_pipe conduit end
set_interface_property pcie_0_pcie_a10_hip_avmm_hip_pipe EXPORT_OF pcie_0.pcie_a10_hip_avmm_hip_pipe
add_interface pcie_0_pcie_a10_hip_avmm_hip_serial conduit end
set_interface_property pcie_0_pcie_a10_hip_avmm_hip_serial EXPORT_OF pcie_0.pcie_a10_hip_avmm_hip_serial
add_interface pcie_0_pcie_a10_hip_avmm_hip_status conduit end
set_interface_property pcie_0_pcie_a10_hip_avmm_hip_status EXPORT_OF pcie_0.pcie_a10_hip_avmm_hip_status
add_interface pcie_0_pcie_a10_hip_avmm_npor conduit end
set_interface_property pcie_0_pcie_a10_hip_avmm_npor EXPORT_OF pcie_0.pcie_a10_hip_avmm_npor
}

# PR subsystem
if {$pr_enable == 1} {
for {set k 0} {$k<$pr_region_count} {incr k} {
add_interface frz_ctrl_${k}_pr_handshake conduit end
set_interface_property frz_ctrl_${k}_pr_handshake EXPORT_OF frz_ctrl_${k}.pr_handshake
}
if {$freeze_ack_dly_enable == 1} {
add_interface start_ack_pio_external_connection conduit end
set_interface_property start_ack_pio_external_connection EXPORT_OF start_ack_pio.external_connection
add_interface stop_ack_pio_external_connection conduit end
set_interface_property stop_ack_pio_external_connection EXPORT_OF stop_ack_pio.external_connection
for {set k 0} {$k<$pr_region_count} {incr k} {
add_interface frz_bdg_${k}_freeze_conduit conduit end
set_interface_property frz_bdg_${k}_freeze_conduit EXPORT_OF frz_bdg_${k}.freeze_conduit
add_interface frz_ctrl_${k}_bridge_freeze0 conduit end
set_interface_property frz_ctrl_${k}_bridge_freeze0 EXPORT_OF frz_ctrl_${k}.bridge_freeze0
}
}
}

if {$fpga_tse == 1} {
add_interface ref_clk_125 clock sink
set_interface_property ref_clk_125 EXPORT_OF enet_cb.in_clk
if {$niosii_en == 0} {
add_interface f2h_irq conduit end
set_interface_property f2h_irq EXPORT_OF a10_hps.f2h_irq1
if {$mdio_clk_div == 50} {
add_interface tse_pll_locked conduit end
set_interface_property tse_pll_locked EXPORT_OF tse_pll.locked
}
}
for {set j 0} {$j<2} {incr j} {
add_interface tse_${j}_eth_tse_0_mac_mdio_connection conduit end
set_interface_property tse_${j}_eth_tse_0_mac_mdio_connection EXPORT_OF tse_${j}.eth_tse_0_mac_mdio_connection
add_interface tse_${j}_eth_tse_0_mac_misc_connection conduit end
set_interface_property tse_${j}_eth_tse_0_mac_misc_connection EXPORT_OF tse_${j}.eth_tse_0_mac_misc_connection
add_interface tse_${j}_eth_tse_0_rx_is_lockedtoref conduit end
set_interface_property tse_${j}_eth_tse_0_rx_is_lockedtoref EXPORT_OF tse_${j}.eth_tse_0_rx_is_lockedtoref
add_interface tse_${j}_eth_tse_0_rx_set_locktodata conduit end
set_interface_property tse_${j}_eth_tse_0_rx_set_locktodata EXPORT_OF tse_${j}.eth_tse_0_rx_set_locktodata
add_interface tse_${j}_eth_tse_0_rx_set_locktoref conduit end
set_interface_property tse_${j}_eth_tse_0_rx_set_locktoref EXPORT_OF tse_${j}.eth_tse_0_rx_set_locktoref
add_interface tse_${j}_eth_tse_0_serdes_control_connection conduit end
set_interface_property tse_${j}_eth_tse_0_serdes_control_connection EXPORT_OF tse_${j}.eth_tse_0_serdes_control_connection
add_interface tse_${j}_eth_tse_0_serial_connection conduit end
set_interface_property tse_${j}_eth_tse_0_serial_connection EXPORT_OF tse_${j}.eth_tse_0_serial_connection
add_interface tse_${j}_eth_tse_0_status_led_connection conduit end
set_interface_property tse_${j}_eth_tse_0_status_led_connection EXPORT_OF tse_${j}.eth_tse_0_status_led_connection
add_interface tse_${j}_xcvr_reset_control_0_pll_select conduit end
set_interface_property tse_${j}_xcvr_reset_control_0_pll_select EXPORT_OF tse_${j}.xcvr_ctrl_pll_select
add_interface tse_${j}_xcvr_reset_control_0_rx_ready conduit end
set_interface_property tse_${j}_xcvr_reset_control_0_rx_ready EXPORT_OF tse_${j}.xcvr_ctrl_rx_ready
add_interface tse_${j}_xcvr_reset_control_0_tx_ready conduit end
set_interface_property tse_${j}_xcvr_reset_control_0_tx_ready EXPORT_OF tse_${j}.xcvr_ctrl_tx_ready
}
}

# interconnect requirements
set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {AUTO}
set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {4}
set_interconnect_requirement {$system} {qsys_mm.burstAdapterImplementation} {GENERIC_CONVERTER}
set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
set_interconnect_requirement {hps_m.master} {qsys_mm.security} {SECURE}

# interconnect pipeline addition for PCIe Gen3x4, Gen2x8
if {$fpga_pcie == 1} {
if {$pcie_gen == 3 || $pcie_count == 8} {
set_interconnect_requirement {mm_interconnect_0|pcie_0_address_span_extender_0_expanded_master_agent.cp/router.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router.src/pcie_0_address_span_extender_0_expanded_master_limiter.cmd_sink} {qsys_mm.postTransform.pipelineCount} {1}
}
if {$pcie_gen == 2 && $pcie_count == 8} {
set_interconnect_requirement {mm_interconnect_0|cmd_mux.src/a10_hps_f2sdram2_data_wr_burst_adapter.sink0} qsys_mm.postTransform.pipelineCount {1}
set_interconnect_requirement {mm_interconnect_0|cmd_mux_001.src/a10_hps_f2sdram2_data_rd_burst_adapter.sink0} qsys_mm.postTransform.pipelineCount {1}
}
if {$pcie_gen == 3 && $pcie_count == 4} {
set_interconnect_requirement {mm_interconnect_0|a10_hps_f2sdram2_data_rd_cmd_width_adapter.src/a10_hps_f2sdram2_data_rd_burst_adapter.sink0} qsys_mm.postTransform.pipelineCount {1}
# set_interconnect_requirement {mm_interconnect_0|cmd_demux.src1/async_fifo_001.in} qsys_mm.postTransform.pipelineCount {1}
set_interconnect_requirement {mm_interconnect_0|cmd_mux.src/a10_hps_f2sdram2_data_wr_burst_adapter.sink0} qsys_mm.postTransform.pipelineCount {1}
set_interconnect_requirement {mm_interconnect_0|cmd_mux_001.src/a10_hps_f2sdram2_data_rd_burst_adapter.sink0} qsys_mm.postTransform.pipelineCount {1}
}
if {$pcie_gen == 3 && $pcie_count == 8} {
set_interconnect_requirement {mm_interconnect_0|a10_hps_f2sdram2_data_wr_cmd_width_adapter.src/a10_hps_f2sdram2_data_wr_burst_adapter.sink0} qsys_mm.postTransform.pipelineCount {1}
}
}

sync_sysinfo_parameters
save_system ${qsys_name}.qsys
sync_sysinfo_parameters
