# Agilex 5 Golden Hardware Reference Design (GHRD) Build Scripts

Agilex 5 GHRD is a reference design for Intel Agilex System On Chip (SoC) FPGA. The GHRD works together with Golden Software Reference design (GSRD) for complete solution to boot Uboot and Linux with Intel SoC Development board. 

This reference design demonstrating the following system integration between Hard Processor System (HPS) and FPGA IPs:
- Hard Processor System enablement and configuration
  - HPS Peripheral and I/O (eg, NAND, SD/MMC, EMAC, USB, SPI, I2C, UART, and GPIO)
  - HPS Clock and Reset
  - HPS FPGA Bridge and Interrupt
- HPS EMIF configuration
- System integration with FPGA IPs
  - Peripheral subsystem that consists of System ID, sSGDMA IP for data movement, Programmable I/O (PIO) IP for controlling DIPSW, PushButton, and LEDs. Optionally to enable DFL ROM for OFS peripherals information discovery
  - Debug subsystem that consists of JTAG-to-Avalon Master IP to allow System-Console debug activity and FPGA content access through JTAG
  - FPGA On-Chip Memory
  - Optional Nios subsystem that consists of NiosV, its execution RAM (FPGA DDR or Onchip Memory), and Mailbox Simple FPGA IP as a medium of communication with HPS
  - Optional FPGA RGMII subsysten that consists of GMII-to-RGMII conversion for HPS XGMAC into FPGA IO connection
  - Optional PR subsystem that consists of Partial Reconfiguration regions to be demonstrated

	
This repository hosts build scripts for AGILEX 5 GHRD.

## Dependency
* Intel Quartus Prime 23.4
* Intel Custom IP will be download automatically from rocketboard.org by the Makefile. The download link will be updated to the Makefile for the latest version.
* Supported Board
  - Intel Agilex 5 Premium Development Kit
  - Intel Agilex 5 Modular Development Kit
* armclang
  - This is required for compiling HPS Wipe Firmware (software/hps_debug/hps_debug.ihex) for *_hps_debug.sof generation

## Tested Platform for the GHRD Make flow
* Red Hat Enterprise Linux Server release 6.10

## Available Make Target:
The GHRD is built with Makefile. Here are the supported Make Targets:
*********************
* Target: `config`
  *   Discover and display parameterization made available for GHRD creation
*********************
* Target: `generate_from_tcl`
  *   Generate the Quartus Project source files from tcl script source
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
* Target: `help`
  *   Displays this info (i.e. the available targets)
*********************

## Build Steps
1) Retrive available parameterization of GHRD and knowing the default parameterization
   - $ make config
2) Customize the GHRD settings via 'make config' command. Multiple \<PARAMETER\> may be customized at one time [Not necessary if the default option is good]
   - $ make \<PARAMETER\>\=\<value\> config
3) Optional way to customize the GHRD setting along with 'make generate_from_tcl' command as well.
   - $ make \<PARAMETER\>\=\<value\> generate_from_tcl
4) Generate the Quartus Project and source files. [Not neccesary if step 3 is applied]
   - $ make generate_from_tcl
5) Compile Quartus Project and generate the configuration file
   - $ make sof or 
   - $ make all
   - Note: The "software/hps_debug/hps_debug.ihex" will have dependency of armclang. If armclang is not available, the generation of *_hps_debug.sof will be skipped.
