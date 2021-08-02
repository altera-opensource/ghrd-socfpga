# Stratix 10 Golden Hardware Reference Design (GHRD) Build Scripts

S10 GHRD is a reference design for Intel S10 System On Chip (SoC) FPGA. The GHRD works together with Golden Software Reference design (GSRD) for complete solution to boot Uboot and Linux with Intel SoC Development board. 

This reference design demonstrating the following system integration between Hard Processor System (HPS) and FPGA IPs:
- Hard Processor System enablement and configuration
  - HPS Peripheral and I/O (eg, NAND, SD/MMC, EMAC, USB, SPI, I2C, UART, and GPIO)
  - HPS Clock and Reset
  - HPS FPGA Bridge and Interrupt
- HPS EMIF configuration
- System integration with FPGA IPs
  - SYSID
  - Programmable I/O (PIO) IP for controlling DIPSW, PushButton, and LEDs)
  - FPGA On-Chip Memory
  - PCIe RootPort IP
  - SGMII with HPS EMAC and 1G/2.5G/5G/10G Multi-Rate Ethernet PHY Intel FPGA IP
  - 10GbE 1588v2 with Low Latency Ethernet 10G MAC Intel FPGA IP + 1G/2.5G/5G/10G Multi-Rate Ethernet PHY Intel FPGA IP
  - Partial Reconfiguration

This repository hosts build scripts for S10 GHRD.

## Dependency
* Intel Quartus Prime 21.2
* Intel Custom IP will be download automatically from rocketboard.org by the Makefile. The download link will be updated to the Makefile for the latest version.
* Supported Board
  - Intel Stratix 10 SX SoC Development Kit
* armclang
  - This is required for compiling HPS Wipe Firmware (software/hps_debug/hps_debug.ihex) for *_hps_debug.sof generation
	
## Tested Platform for the GHRD Make flow
* Red Hat Enterprise Linux Server release 6.10
    
## Available Make Target:
The GHRD is built with Makefile. Here are the supported Make Targets:
*********************
* Target: `generate_from_tcl`
  *   Generate the Quartus Project source files from tcl script source
*********************
* Target: `help`
  *   Displays this info (i.e. the available targets)
*********************
* Target: `qsys_edit`
  *   Launch Platform Designer GUI
*********************
* Target: `quartus_edit`
  *   Launch Quartus Prime GUI
*********************
* Target: `scrub_clean`
  *   Restore design to its barebones state
*********************
* Target: `sof`
  *   QSys generate & Quartus compile this design
*********************
* Target: `tgz`
  *   Create a tarball with the barebones source files that comprise this design
*********************

## Build Steps
1) Customize the GHRD settings in Makefile. [Not necessary if the default option is good]
2) Generate the Quartus Project and source files.
   - $ make `generate_from_tcl`
3) Compile Quartus Project and generate the configuration file
   - $ `make sof` or $ `make all`
   - Note: The "software/hps_debug/hps_debug.ihex" will have dependency of armclang. If armclang is not available, the generation of *_hps_debug.sof will be skipped.

## GHRD Customization in Makefile
Here are the list of custom settings support in Makefile. 
- `QUARTUS_DEVICE`                  : Device OPN
  - 1SX280LU2F50E2VG (Default)
- `BOOTS_FIRST`                     : System initialization mode.
  - "fpga", "hps" (Default)
- `HPS_JTAG_MODE`                   : HPS JTAG mode.
  - "combined" (Default), "separate"
- `DAUGHTER_CARD`                   : Daughter Card Option
  - "devkit_dc_oobe" (Default), "devkit_dc_nand", "devkit_dc_emmc"
- `ENABLE_HPS_EMIF_ECC`             : Enable HPS EMIF ECC.
  - 0, 1 (Default)
                      
### Enable only one of the below at a time. Work in progress to enable them at once.
- `HPS_ENABLE_SGMII`                : Enable SGMII (1GbE, 100MbE, 10MbE) design (HPS EMAC + 1G/2.5G/5G/10G Multi-Rate Ethernet PHY Intel FPGA IP). 
  - 0 (Default), 1
- `HPS_ENABLE_10GbE`                : Enable 10GbE 1588 Design. (Low Latency Ethernet 10G MAC Intel FPGA IP + 1G/2.5G/5G/10G Multi-Rate Ethernet PHY Intel FPGA IP). PTPv2 2-Step enabled.
  - 0 (Default), 1
- `ENABLE_PCIE`                     : Enable Gen3x8 PCIe Design.
  - 0 (Default), 1
- `ENABLE_PARTIAL_RECONFIGURATION`  : Enable Partial Reconfiguration Design.
  - 0 (Default), 1
