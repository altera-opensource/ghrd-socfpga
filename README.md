# Golden Hardware Reference Design (GHRD) Build Scripts

GHRD is a reference design for Intel System On Chip (SoC) FPGA. The GHRD works together with Golden Software Reference design (GSRD) for complete solution to boot Uboot and Linux with Intel SoC Development board. 

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
  - PCIe Rootport IP
  - Ethernet IP 

## This repository hosts build scripts for all GHRD. Build scripts are organized according to the Intel SoC FPGA Family:
### GHRD for Intel Quartus Prime Pro Edition
*  agilex_soc_devkit_ghrd
*  s10_soc_devkit_ghrd
*  a10_soc_devkit_ghrd_pro

### GHRD for Intel Quartus Prime Standard Edtion
*  a10_soc_devkit_ghrd_std
*  cv_soc_devkit_ghrd

## Build Steps:
Refer to the README in repective folder for build steps.
