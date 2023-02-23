# Cyclone V (CV) Golden Hardware Reference Design (GHRD) Build Scripts

CV GHRD is a reference design for Intel CV System On Chip (SoC) FPGA. The GHRD works together with Golden Software Reference design (GSRD) for complete solution to boot Uboot and Linux with Intel SoC Development board. 

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

This repository hosts build scripts for S10 GHRD.

## Dependency
* Intel Quartus Prime 22.1std
* Supported Board
  - Intel Cyclone V SoC Development Kit

## Tested Platform for the GHRD Make flow
* Red Hat Enterprise Linux Server release 6.10

## Available Make Target:
The GHRD is built with Makefile. Here are the supported Make Targets:
*********************
* Target: `generate_from_tcl`
  * Generate the Quartus Project source files from tcl script source
*********************
* Target: `help`
  * Displays this info (i.e. the available targets)
*********************
* Target: `program_fpga`
  * Quartus program sof to your attached dev board
*********************
* Target: `qsys_edit`
  * Launch Platform Designer GUI
*********************
* Target: `quartus_edit`
  * Launch Quartus Prime Standard GUI
*********************
* Target: `scrub_clean`
  * Restore design to its barebones state
*********************
* Target: `sof`
  * QSys generate & Quartus compile this design
*********************
* Target: `tgz`
  * Create a tarball with the barebones source files that comprise this design
*********************

## Build Steps
1) Customize the GHRD settings in Makefile. [Not necessary if the default option is good]
2) Generate the Quartus Project and source files.
   - $ make `generate_from_tcl`
3) Compile Quartus Project and generate the configuration file
   - $ `make sof` or $ `make all`

## GHRD Customization in Makefile
- `ENABLE_PCIE`    : Enable Gen1x4 PCIE Design.
  - 0 (Default), 1
