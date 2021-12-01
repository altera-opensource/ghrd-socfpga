# Agilex Golden Hardware Reference Design (GHRD) Build Scripts

Agilex GHRD is a reference design for Intel Agilex System On Chip (SoC) FPGA. The GHRD works together with Golden Software Reference design (GSRD) for complete solution to boot Uboot and Linux with Intel SoC Development board. 

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
	
This repository hosts build scripts for AGILEX GHRD.

## Dependency
* Intel Quartus Prime 21.3
* Intel Custom IP will be download automatically from rocketboard.org by the Makefile. The download link will be updated to the Makefile for the latest version.
* Supported Board
  - Intel Agilex F-Series Transceiver-SoC Development Kit
  - Intel Agilex F-Series FPGA Development Kit 
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

1. General Settings (Under section: "User Settings")

   - File: ./Makefile
   - `BOARD_TYPE`          : Board Type
     - "devkit" -> F-Series SoC Devkit (Default), "pcie_devkit" (F-Series FPGA Devkit)
   - `BOOTS_FIRST`         : System initialization mode.
     - "fpga", "hps" (Default)
   - `HPS_JTAG_MODE`       : HPS JTAG mode.
     - "combined" (Default), "separate"
   - `DAUGHTER_CARD`       : Daughter Card Option (Not available for F-Series FPGA Devkit)
     - "devkit_dc_oobe", "devkit_dc_nand", "devkit_dc_emmc"
   - `ENABLE_HPS_EMIF_ECC` : Enable HPS EMIF ECC. REVA Agilex doesn't support ECC Enable.
     - 0 (Default), 1

2. Board Related Settings
   - board "devkit" (F-Series SoC Devkit)
     - File: ./board/board_devkit_make_config.inc
     - `QUARTUS_DEVICE`      : Device OPN
       - AGFB014R24A3E3VR0 (Default)
     - `BOARD_PWRMGT`        : Board Power management option for Agilex F-Series Transceiver-SoC Development Kit and Agilex F-Series FPGA Development Kit.
       - "linear", "enpirion" (Default)
     - `HPS_SGMII_EMAC1_EN`  : HPS SGMII Enablement (HPS EMAC + TSE IP (PHY MODE))
       - 1 (Default), 0
   - Board Related Settings - board "pcie_devkit" (F-Series FPGA Devkit)
     - File: ./board/board_pcie_devkit_make_config.inc
     - `QUARTUS_DEVICE`      : Device OPN
       - AGFB014R24A3E3VR0 (Default)