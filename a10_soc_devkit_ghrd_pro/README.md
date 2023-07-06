# Arria 10 (A10) Golden Hardware Reference Design (GHRD) Build Scripts

A10 GHRD is a reference design for Intel A10 System On Chip (SoC) FPGA. The GHRD works together with Golden Software Reference design (GSRD) for complete solution to boot Uboot and Linux with Intel SoC Development board. 

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
  - SGMII with HPS EMAC and Triple-Speed Ethernet Intel FPGA IP (PHY)
  - SGMII with Triple-Speed Ethernet Intel FPGA IP (MAC + PHY)
  - Partial Reconfiguration

This repository hosts build scripts for S10 GHRD.

## Dependency
* Intel Quartus Prime 23.3
* Intel Custom IP will be download automatically from rocketboard.org by the Makefile. The download link will be updated to the Makefile for the latest version.
* Supported Board
  - Intel Arria 10 SoC Development Kit

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
   - $ `make generate_from_tcl`
3) Compile Quartus Project and generate the configuration file
   - $ `make sof` or $ `make all`

## GHRD Customization in Makefile
Here are the list of custom settings support in Makefile. 
- `QUARTUS_DEVICE`                  : Device OPN
  - 10AS066N3F40E2SG (Default - BOARD_REV:C), 10AS066N3F40E2SGE2 (BOARD_REV:B), 10AS066N2F40I2SGES (BOARD_REV:A)
- `BOARD_REV`                       : Board Revision
  - C (Default), B, A
- `HPS_BOOT_DEVICE`                 : HPS BOOT DEVICE.
  - SDMMC (Default), QSPI, NAND
- `ENABLE_EARLY_IO_RELEASE`         : Enable Early IO Release
  - 0, 1 (Default)
- `ENABLE_HPS_EMIF_ECC`             : Enable HPS EMIF ECC. REVA Agilex doesnt support ECC Enable.
  - 0, 1 (Default)

### Enable only one of the below at a time. Work in progress to enable them at once.
- `HPS_ENABLE_SGMII`                : Enable SGMII (1GbE, 100MbE, 10MbE) design (HPS EMAC + Triple-Speed Ethernet Intel FPGA IP). 
  - 0 (Default), 1
- `HPS_ENABLE_TSE`                  : Enable SGMII (1GbE, 100MbE, 10MbE) with TSE MAC (Triple-Speed Ethernet Intel FPGA IP - both MAC and PHY).
  - 0 (Default), 1
- `ENABLE_PCIE`                     : Enable Gen2x8 PCIe Design.
  - 0 (Default), 1
- `ENABLE_PARTIAL_RECONFIGURATION`  : Enable Partial Reconfiguration Design.
  - 0 (Default), 1
