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
  - Optional FPGA RGMII subsystem that consists of GMII-to-RGMII conversion for HPS XGMAC into FPGA IO connection
  - Optional PR subsystem that consists of Partial Reconfiguration regions to be demonstrated


This repository hosts build scripts for AGILEX 5 GHRD.

## Dependency
* Intel Quartus Prime 24.3.1
* Intel Custom IP will be download automatically from rocketboard.org by the Makefile. The download link will be updated to the Makefile for the latest version.
* Supported Board
  - Intel Agilex 5 Premium Development Kit
  - Intel Agilex 5 Modular Development Kit
* armclang
  - This is required for compiling HPS Wipe Firmware (software/hps_debug/hps_debug.ihex) for *_hps_debug.sof generation

## Project Details

- **Family**: Agilex 5 E-Series
- **Quartus Version**: 24.3.1
- **Development Kit**: Agilex 5 FPGA E-Series 065B Premium Development Kit DK-A5E065BB32AES1
- **Device Part**: A5ED065BB32AE6SR0
*********************
- **Family**: Agilex 5 E-Series
- **Quartus Version**: 24.3.1
- **Development Kit**: Agilex 5 FPGA E-Series 065B MODULAR Development Kit MK-A5E065BB32AES1
- **Device Part**: A5ED065BB32AE6SR0

## Tested Platform for the GHRD Make flow
* Red Hat Enterprise Linux Server release 6.10
* SUSE Linux Enterprise Server 12 SP5

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
2) Customize the GHRD settings via 'make' command along with 'generate_from_tcl' command as well.\
   Multiple \<PARAMETER\> may be customized at one time.\
   If parameter is not customized, it will take the default value from `USER TOPLEVEL CONFIGURATION` in Makefile.\
   Each subsystem also has a individual Makefile.\
   Please also refer to **make Parameter Descriptions** for possible customization.
   - $ make `<PARAMETER>`\=\<value\> generate_from_tcl
3) Optional way to generate default Quartus Project and source files. [Not neccesary if step 2 is applied]
   - $ make generate_from_tcl
4) Compile Quartus Project and generate the configuration file
   - $ make sof or
   - $ make all

## Make Parameter Descriptions
#### `BOARD_TYPE`
The `BOARD_TYPE` parameter is used to specify the type of board that supported with their features. Below is a list of supported boards along with their key features.
| \<value\> | Description        | Platform                 |
| ------------------ | ----------------------------|--------|
| DK-A5E065BB32AES1  | Agilex 5 Premium Devkit     | DevKit |
| MK-A5E065BB32AES1  | Agilex 5 Modular Devki      | DevKit |

Based on the `BOARD_TYPE`, the ghrd script will automatically find and execute the board specific `.tcl` and `.inc` script in the board folder.

#### `DAUGHTER_CARD`
The `DAUGHTER_CARD` parameter is used to specify the type of daughter card attached to the main board. A daughter card is a smaller circuit board that connects to the main board to expand its functionality, providing additional features such as communication modules, or I/O ports. Below is a list of supported daughter card along with their supported board and description.  

|  \<value\>  |  Description      | Supported Board                               |
| ------------------ | ----------------- | ----------------------------------------- |
| devkit_dc_oobe         | Out-of-Box Experience HPS Daughter Card with <br>TSN Config 1 and TSN Config 2     | DevKit |
| devkit_dc_nand        | HPS Daugther Card with NAND       | DevKit |
| devkit_dc_emmc        | HPS Daugther Card with eMMC       | DevKit |
| debug2         | HPS Daughter Card with debug2      | DevKit |
| mod_som        | Modular Devkit SOM Card     | Modular Devkit |

#### `DEVICE`
The `DEVICE` parameter represents the specific OPN (Orderable Part Number) for the hardware component being used. The OPN uniquely identifies a device in the product catalog and is used to ensure the correct configuration, initialization, and usage of the component in the Quartus. By specifying the `DEVICE`=\<value\>, Quartus will tailor its behavior to match the selected part. Below is a list of supported OPNs Part Number.  
|  \<value\>  |  Description      |
| ------------------ | -----------|
| A5ED065BB32AE5SR0| 5s FPGA OPN  |  
| A5ED065BB32AE6SR0| 6s FPGA OPN  |

#### `INITIALIZATION_FIRST`
The `INITIALIZATION_FIRST` parameter controls the system initialization sequence and determines which part of the system is initialized first. This is critical in systems with both an HPS (Hard Processor System) and FPGA (Field-Programmable Gate Array) as they can be initialized in different orders depending on the use case.  
|  \<value\>  |  Description      |
| ------------------ | -----------|
|hps| HPS initialization first configuration is often used when the HPS manages the configuration of the FPGA or when the system requires the processor to handle boot and initialization logic before the FPGA is activated.|
|fpga| FPGA fabric initialization first configuration is used when the FPGA needs to be ready before the HPS or when the FPGA is responsible for handling critical tasks that must be operational at startup. |

#### `SUB_HPS_EN`
The `SUB_HPS_EN` parameter is used to enable or disable the Hard Processor System (HPS) within a system. The HPS typically consists of a processor core and related peripherals, and controlling whether it's enabled or disabled can help optimize system resources depending on the application's requirements.  
|  \<value\>  |  Description      |
| ------------------ | -----------|
|0| Disabled. The system will bypass the HPS, which can reduce power consumption or allocate tasks solely to the FPGA or other components. This is useful in scenarios where the HPS is not needed for the application. |
|1| Enabled. The system will initialize and utilize the HPS for processing tasks. This is used when the processor needs to be active for managing the system's operations.  | 

#### `HPS_EMIF_EN`
The `HPS_EMIF_EN` parameter is used to enable or disable the HPS External Memory Interface (EMIF), which manages the communication between the FPGA and external memory devices such as DDR, SDRAM, or other memory modules. The external memory interface is critical in applications where high-speed data transfer and large memory capacity are required. This parameter controls whether the design can access external memory through the HPS.  
|  \<value\>  |  Description      |
| ------------------ | -----------|
|0| Disable the HPS External Memory Interface. The FPGA will not access external memory through the HPS, which can be useful in design that do not need external memory, potentially lowering power consumption. |
|1| Enables the HPS External Memory Interface. This allows the FPGA to communicate with external memory devices via the HPS.   | 

#### `HPS_EMIF_TOPOLOGY`
The `HPS_EMIF_TOPOLOGY` parameter refers to organization of memory channels and ranks in the memory subsystem. The more the data lines means the wider data path between memory and processor, enabling higher data transfer rate, better performance especially in applications that require large amount of data to be transferred quickly such as gaming, multimedia processing or data analytics. Note that  
	- Single vs Dual channel memory configuration. Memory channels provide additional parallel data paths between the memory and processor.  
	- 16 data lines means memory can transfer 16 bits of data in parallel with each clock cycle while 32 data lines can transfer 32 bits which doubled the transfer rate.  
|  \<value\>  |  Description      |
| ------------------ | -----------|
|0| 1x16 - Indicates a single memory channel with 16 data lines.  |
|1| 1x32 [default] - Indicates a single memory channel with 32 data lines  |

#### `HPS_EMIF_ECC_EN`
The `HPS_EMIF_ECC_EN` parameter enables or disables the Error-Correcting Code (ECC) feature in the HPS External Memory Interface (EMIF). The purpose of ECC is to enhance the reliability and integrity of data stored in memory by detecting and correcting single-bit memory errors and detecting multi-bit errors. Enabling ECC helps safeguard against data corruption in critical applications, ensuring that data integrity is maintained even in the presence of hardware faults.  
|  \<value\>  |  Description      |
| ------------------ | -----------|
|0| Disable. The system will not perform error correction, which may result in lower overhead, but there is a risk of undetected memory errors. |
|1| Enables. The system will detect and correct single-bit errors and detect multi-bit errors in the external memory, improving data reliability. | 

#### `SUB_FPGA_RGMII_EN`
The `SUB_FPGA_RGMII_EN` parameter enables or disables the RGMII (Reduced Gigabit Media-Independent Interface) in the FPGA, which is part of the TSN (Time-Sensitive Networking) configuration 2. TSN is a set of standards that allows for time-sensitive data transmission over Ethernet networks, ensuring reliable and deterministic communication for critical applications such as industrial automation and automotive systems. When enabled, the RGMII interface facilitates high-speed Ethernet communication between the FPGA and external Ethernet PHYs, making it crucial for systems that require TSN functionality.

|  \<value\>  |  Description      |
| ------------------ | -----------|
|0| Disables the RGMII interface, which design do not need TSN config2.  |
|1| Enables the RGMII interface and configures the FPGA for TSN config2.  | 

#### `SUB_PERI_EN`
The `SUB_PERI_EN` parameter is used to enable or disable the peripheral subsystem, which includes components such as the system identification (SYSID) and FPGA General Purpose Input/Output (GPIO). The SYSID is typically used for system identification, providing versioning and identification data, while the FPGA GPIO allows for general-purpose input/output control for interfacing with external devices or subsystems.
|  \<value\>  |  Description      |
| ------------------ | -----------|
|0| Disables the peripheral subsystem. This can be useful in systems where these peripherals are not needed, potentially saving resources.  |
|1| Enables the peripheral subsystem. This is useful when interact with external peripherals or need system identification for management or debugging purposes.  |

#### `HPS_CLK_SOURCE`  
The `HPS_CLK_SOURCE` parameter specifies the clock source for the Hard Processor System (HPS). This parameter allows users to choose between using the HPS External Oscillator or the FPGA Free Clock as the system clock source. The clock source is crucial for determining the timing and synchronization of system operations, particularly in applications requiring precise clocking or when switching between clock sources for flexibility.
|  \<value\>  |  Description      |
| ------------------ | -----------|
|0| Uses the HPS External Oscillator as the clock source. This is typically used for stable, high-precision timing sourced from an onboard or external oscillator dedicated to the HPS.  |
|1| Uses the FPGA Free Clock as the clock source. This option allows the FPGA to provide the clock, which can be useful when user need flexible or internally generated clocking for the system.  |

#### `RESET_HPS_WARM_EN`
The `RESET_HPS_WARM_EN` parameter is used to enable or disable the warm reset functionality for the Hard Processor System (HPS). A warm reset allows the system to reset certain components or the processor without fully powering down the entire system. This is useful for quickly restarting operations while preserving some system state, rather than performing a full cold reset.
  
|  \<value\>  |  Description      |
| ------------------ | -----------|
|0| Disable HPS warm reset. A full system reset will be required for any restart, which might be useful when a complete reinitialization of the HPS is needed.  |
|1| Enable HPS warm reset. This allows the system to perform a warm reset, restarting certain HPS components without completely powering down, which can save time during reboot cycles.  |

#### `RESET_H2F_COLD_EN`
The `RESET_H2F_COLD_EN` parameter controls whether the Hard Processor System (HPS) can trigger a cold reset of the FPGA. A cold reset completely resets the FPGA, clearing all configurations and states, ensuring that the system restarts from a clean state. This is typically used when a full reinitialization of the FPGA is required.

|  \<value\>  |  Description      |
| ------------------ | -----------|
|0| Disables HPS to FPGA cold reset. The FPGA will not be reset by the HPS, preserving its current configuration and state even if the HPS requires a restart.  |
|1| Enables HPS to FPGA cold reset. This allows the HPS to initiate a complete reset of the FPGA, clearing all configurations and resetting it to the initial state.  |

#### `RESET_SDM_WATCHDOG_CFG`
The `RESET_SDM_WATCHDOG_CFG` parameter determines the action to be taken when the SDM (System Debug Module) watchdog timer expires. The available options include triggering an HPS Cold Reset, an HPS Warm Reset, or initiating a Remote Update. This configuration is essential for managing system recovery and stability, as it allows the system to respond to watchdog events based on the specific needs of the application.

|  \<value\>  |  Description      |
| ------------------ | -----------|
|0| Performs an HPS Cold Reset, completely restarting the HPS and clearing all states and configurations. This option is typically used when a full system reinitialization is necessary after a watchdog event.  |
|1| Performs an HPS Warm Reset, which restarts the HPS without a complete power cycle, allowing for a quicker recovery while maintaining some system state.  |
|2| Triggers a Remote Update, which allows the system to load new configurations or firmware remotely after a watchdog event. This is useful for systems that need to update or recover from a failure automatically.  |

#### `RESET_WATCHDOG_EN`
The `RESET_WATCHDOG_EN` parameter is used to enable or disable the watchdog reset functionality. The watchdog timer is a safety mechanism designed to reset the system if it becomes unresponsive or if a software error occurs. By enabling the watchdog reset, the system can automatically reset to recover from faults. Disabling it will prevent the system from resetting based on the watchdog timer, which may be useful for specific debugging or controlled environments.
|  \<value\>  |  Description      |
| ------------------ | -----------|
|0| Disables the watchdog reset. The system will not reset based on the watchdog timer, which can be useful in situations where automatic resets are not desired.  |
|1| Enables the watchdog reset. The system will automatically reset if the watchdog timer expires, helping to recover from software or hardware failures.  |

#### `F2S_DATA_WIDTH`
The `F2S_DATA_WIDTH` parameter is used to configure the data width of the FPGA-to-SoC (F2S) interface. This parameter allows the user to enable or disable a 256-bit data width for high-performance data transfer between the FPGA and the SoC. 
|  \<value\>  |  Description      |
| ------------------ | -----------|
|0| Disables the f2s data width by setting F2S bridge to unused.  |
|256| Enables 256-bit data width for the FPGA-to-SoC interface, allowing data transfers between the FPGA and the SoC.  |

#### `F2S_ADDRESS_WIDTH`
The `F2S_ADDRESS_WIDTH` parameter defines the address width for the FPGA-to-SoC (F2S) interface, which is responsible for addressing memory locations during data transfers between the FPGA and the SoC. This parameter allows you to configure the address width between a minimum of 20 bits and a maximum of 40 bits, giving flexibility based on the memory addressing requirements. A wider address width allows for addressing a larger memory space, but may require more resources, while a narrower width limits memory space but reduces resource usage.
|  \<value\>  |  Description      |
| ------------------ | -----------|
|20| The address width set at 20 bits (minimum).  |
|32| The address width set at 32 bits in default.  |
|40| The address width set at 40 bits (maximum).  |

#### `F2SDRAM_DATA_WIDTH`
The `F2SDRAM_DATA_WIDTH` parameter is used to set the data width for the interface between the FPGA and SDRAM. This parameter allows the user to choose from different data width options: 0 bits, 64 bits, 128 bits, or 256 bits. A wider data width increases the bandwidth for data transfers between the FPGA and SDRAM, allowing for faster performance, while a narrower width reduces the resource usage but limits the data transfer rate.
|  \<value\>  |  Description      |
| ------------------ | -----------|
|0| Disables the FPGA-to-SDRAM interface, no data transfers will occur.  |
|64| Enables a 64-bit data width, providing moderate data bandwidth.  |
|128| Enables a 128-bit data width, offering higher data transfer rates.  |
|256| Enables a 256-bit data width, providing the maximum data transfer bandwidth for performance-intensive applications.  |

#### `F2SDRAM_ADDR_WIDTH`
The `F2SDRAM_ADDR_WIDTH` parameter is used to define the address width for the FPGA-to-SDRAM interface. This width determines how much memory space can be addressed when communicating between the FPGA and the SDRAM. The parameter can be set to a minimum of 20 bits, with 32 bits and up to a maximum of 40 bits that supported by GHRD. A wider address width allows the system to address a larger memory space, but may also require more resources, while a narrower address width limits the addressable memory but conserves resources.
|  \<value\>  |  Description      |
| ------------------ | -----------|
|20| Sets the address width to 20 bits, suitable for smaller memory spaces and reduced resource usage.  |
|32| Sets the address width to 32 bits, allowing for larger memory spaces while maintaining a balance between resource usage and addressing capacity. |
|40| Sets the address width to 40 bits, providing the maximum addressable memory space, ideal for large-scale memory applications.  |

#### `H2F_WIDTH`
The `H2F_WIDTH` parameter is used to configure the data width for the HPS-to-FPGA (H2F) interface. This determines the amount of data that can be transferred between the HPS (Hard Processor System) and the FPGA in a single operation. The available options include 0 bits (disabling the interface), 32 bits, 64 bits, and 128 bits. Wider data widths enable faster data transfers and higher bandwidth, but may require more resources, while narrower widths conserve resources but may reduce performance.
|  \<value\>  |  Description      |
| ------------------ | -----------|
|0| Disables the HPS-to-FPGA interface, no data transfers will occur.  |
|32| Sets the data width to 32 bits, providing moderate data transfer capabilities.  |
|64| Sets the data width to 64 bits, allowing for faster data transfers with greater bandwidth.  |
|128| Sets the data width to 128 bits, offering the highest bandwidth for performance-critical applications.  |

#### `H2F_ADDR_WIDTH`
The `H2F_ADDR_WIDTH` parameter defines the address width for the HPS-to-FPGA (H2F) interface. This parameter determines how much memory space can be addressed between the Hard Processor System (HPS) and the FPGA. The address width can be set from a minimum of 20 bits to a maximum of 38 bits, giving flexibility based on the memory addressing requirements. A wider address width allows the system to address a larger memory space, while a narrower width may conserve resources but limit the addressable memory.
|  \<value\>  |  Description      |
| ------------------ | -----------|
|20| The address width set at 20 bits (minimum).  |
|38| The address width set at 38 bits (maximum).  |

#### `LWH2F_WIDTH`
The `LWH2F_WIDTH` parameter sets the data width for the Lightweight HPS-to-FPGA (LWH2F) interface. This interface is typically used for lower-bandwidth data transfers between the Hard Processor System (HPS) and the FPGA. The data width can be configured to either 0 bits (disabling the interface) or 32 bits, which provides the connection to peripheral subsystem. 
|  \<value\>  |  Description      |
| ------------------ | -----------|
|0| Disables the Lightweight HPS-to-FPGA interface, no data transfers will occur.  |
|32| Sets the data width to 32 bits, enabling moderate data transfers between the HPS and FPGA for control or lightweight operations.  |

#### `LWH2F_ADDR_WIDTH`
The `LWH2F_ADDR_WIDTH` parameter defines the address width for the Lightweight HPS-to-FPGA (LWH2F) interface. This interface is designed for lower-bandwidth data transfers between the Hard Processor System (HPS) and the FPGA, typically used for control or status register access. The address width can be set from a minimum of 20 bits to a maximum of 29 bits, providing flexibility for addressing the memory space as needed. A wider address width allows the system to address a larger memory space, while a narrower width may save resources but limit memory addressability.

|  \<value\>  |  Description      |
| ------------------ | -----------|
|20| The address width set at 20 bits (minimum).  |
|29| The address width set at 29 bits (maximum).  |

#### `SUB_DEBUG_EN`
The `SUB_DEBUG_EN` parameter is used to enable or disable the JTAG subsystem connection for debugging purposes. When enabled, it allows access to the JTAG interface for debugging the system, providing the ability to monitor, test, and control the FPGA or other components during development or troubleshooting. Disabling this parameter will turn off the JTAG connection, reducing resource usage but preventing access to the debugging tools.
|  \<value\>  |  Description      |
| ------------------ | -----------|
|0| Disables the JTAG subsystem connection, reducing resource usage and preventing debugging access.  |
|1| Enables the JTAG subsystem connection, allowing for system debugging and testing via the JTAG interface.  |

#### `PWR_A55_CORE0_1_ON`
The `PWR_A55_CORE0_1_ON` parameter is used to power on the A55 MPU (Microprocessor Unit) cores 0 and 1. Enabling this parameter will turn on these two cores, allowing them to perform processing tasks. This is crucial for running applications that require the use of these cores. Disabling it will power down the cores, reducing power consumption when they are not needed.  

|  \<value\>  |  Description      |
| ------------------ | -----------|
|0| Powers off A55 MPU cores 0 and 1, reducing power consumption.  |
|1| Powers on A55 MPU cores 0 and 1, allowing them to execute processing tasks.  |

#### `PWR_A76_CORE2_ON`
The `PWR_A76_CORE2_ON` parameter is used to power on the A76 MPU (Microprocessor Unit) core 2. Enabling this parameter turns on the core, allowing it to handle processing tasks. This core is part of the high-performance cluster, typically used for demanding tasks. Disabling it powers down core 2, conserving energy when the additional processing power is not required.  

|  \<value\>  |  Description      |
| ------------------ | -----------|
|0| Powers off the A76 MPU core 2, reducing power consumption.  |
|1| Powers on the A76 MPU core 2, enabling it for high-performance tasks.  |

#### `PWR_A76_CORE3_ON`
The `PWR_A76_CORE3_ON` parameter is used to power on the A76 MPU (Microprocessor Unit) core 3. When enabled, core 3 is powered on, allowing it to perform high-performance processing tasks. This core is part of the powerful A76 core cluster, often used for compute-intensive operations. Disabling it will power down core 3, saving power when high processing power is not needed.  

|  \<value\>  |  Description      |
| ------------------ | -----------|
|0| Powers off the A76 MPU core 3, reducing power consumption.   |
|1| Powers on the A76 MPU core 3, allowing it to execute high-performance tasks.  |

#### `PWR_BOOT_CORE_SEL`
The `PWR_BOOT_CORE_SEL` parameter allows user to select which core to use as the boot core for the system. Only two cores are available for boot: A55 Core0 and A76 Core2. The boot core is responsible for initializing the system and executing the boot process. Depending on user system's requirements, user can choose between these two cores for boot.

|  \<value\>  |  Description      |
| ------------------ | -----------|
|0| Selects A55 Core0 as the boot core, typically used for lower-power boot sequences.   |
|1| Selects A76 Core2 as the boot core, generally used for high-performance boot sequences.  |


## Recommendations for HPS_EMIF_MEM_CLK_FREQ_MHZ and HPS_EMIF_REF_CLK_FREQ_MHZ
#### `HPS_EMIF_MEM_CLK_FREQ_MHZ`:
- parameter sets the reference clock frequency (in MHz) for the HPS External Memory Interface (EMIF). This clock is essential for synchronizing communication between the FPGA and external memory devices. The correct reference clock frequency ensures proper operation and data transfer rates for the selected memory protocol. The default value typically corresponds to the onboard reference clock, but it can be adjusted based on the memory configuration and system requirements.

#### `HPS_EMIF_MEM_CLK_FREQ_MHZ`:
- parameter is the memory clock speed which refers to the rate at which the memory system operates (in MHz). This indicate how many cycles per second the memory can perform. In the context of DDR memory, the memory clock freqeuncy represetns the rate at which data is transferred between memory modules and memory controller. However since DDR memory transfer data on both rising and falling edges of clock signal, the effective data rate is twice the memory clock frequency. For example, if memory clock frequency is 800MHz, the effective data rate would be 1600MT/s (Megatransfer per second).

#### Users are recommended to select the following frequency [Mhz]:
1) for 6s FPGA OPN (A5ED065BB32AE6SR0):
   - `HPS_EMIF_MEM_CLK_FREQ_MHZ`=800
   - `HPS_EMIF_REF_CLK_FREQ_MHZ`=100
2) for 5s FPGA OPN (A5ED065BB32AE5SR0):
   - `HPS_EMIF_MEM_CLK_FREQ_MHZ`=933.333
   - `HPS_EMIF_REF_CLK_FREQ_MHZ`=116.6666

#### If other values are needed by the design:
1) Execute **Build Steps** 1 and 2.\
   Exclude HPS_EMIF_MEM_CLK_FREQ_MHZ and HPS_EMIF_REF_CLK_FREQ_MHZ from make parameters.
3) Launch Platform Designer GUI:
   - $make qsys_edit
4) Navigate to subsys_hps -> emif_hps -> Dive Into Packaged Subsystem...
5) Select the desired **Memory Operating Frequency** and **Reference Clock Frequency** from the drop down list.
6) manually amend **EMIF_REF_CLOCK** in ghrd_timing.sdc to align with the Reference Clock Frequency set in qsys.
