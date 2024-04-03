#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2023 Intel Corporation.
#
#****************************************************************************
#
# This script construct Peripherals subsystem for higher level integration later.
# The Makefile in $prjroot folder will pass in variable needed by this TCL as defined
# in the subsystem Makefile automatically. User will have the ability to modify the 
# defined variable dynamically during (MAKE) target flow of generate_from_tcl.
#
#****************************************************************************
set currentdir [pwd]
set foldername [file tail $currentdir]
puts "\[GHRD:info\] Directory name: $foldername"

puts "\[GHRD:info\] \$prjroot = ${prjroot} "
source ${prjroot}/arguments_solver.tcl
source ${prjroot}/utils.tcl

if {$board == "cvr"} {
	    source $prjroot/board/board_cvr_config.tcl
	} else {
	    source $prjroot/board/board_DK-A5E065BB32AES1_config.tcl
	}

set subsys_name $foldername

package require -exact qsys 23.4

#proc do_create_bbb {} {
#global subsys_name
#global device
#global device_family

	# create the system
	create_system $subsys_name
	#set_project_property BOARD {default}
	set_project_property DEVICE $device
	set_project_property DEVICE_FAMILY $device_family
	# set_project_property HIDE_FROM_IP_CATALOG {false}
	# set_use_testbench_naming_pattern 0 {}

	# add HDL parameters

add_component_param "altera_clock_bridge clock_in 
                    IP_FILE_PATH ip/$subsys_name/clock_in.ip 
                    EXPLICIT_CLOCK_RATE 100000000 
                    NUM_CLOCK_OUTPUTS 1
                    "

	# add the components
	# add_component clock_in ip/$subsys_name/clock_in.ip altera_clock_bridge clock_in 19.2.0
	# load_component clock_in
	# set_component_parameter_value EXPLICIT_CLOCK_RATE {100000000.0}
	# set_component_parameter_value NUM_CLOCK_OUTPUTS {1}
	# set_component_project_property HIDE_FROM_IP_CATALOG {false}
	# save_component
	# load_instantiation clock_in
	# remove_instantiation_interfaces_and_ports
	# add_instantiation_interface in_clk clock INPUT
	# set_instantiation_interface_parameter_value in_clk clockRate {0}
	# set_instantiation_interface_parameter_value in_clk externallyDriven {false}
	# set_instantiation_interface_parameter_value in_clk ptfSchematicName {}
	# add_instantiation_interface_port in_clk in_clk clk 1 STD_LOGIC Input
	# add_instantiation_interface out_clk clock OUTPUT
	# set_instantiation_interface_parameter_value out_clk associatedDirectClock {in_clk}
	# set_instantiation_interface_parameter_value out_clk clockRate {100000000}
	# set_instantiation_interface_parameter_value out_clk clockRateKnown {true}
	# set_instantiation_interface_parameter_value out_clk externallyDriven {false}
	# set_instantiation_interface_parameter_value out_clk ptfSchematicName {}
	# set_instantiation_interface_sysinfo_parameter_value out_clk clock_rate {100000000}
	# add_instantiation_interface_port out_clk out_clk clk 1 STD_LOGIC Output
	# save_instantiation
	# add_component intel_agilex_5_soc_0 ip/bbb/bbb_intel_agilex_5_soc_0.ip intel_agilex_5_soc intel_agilex_5_soc_0 1.0.0
	# load_component intel_agilex_5_soc_0
	# set_component_parameter_value ATB_Enable {0}
	# set_component_parameter_value CM_Mode {N/A}
	# set_component_parameter_value CM_PinMuxing {Unused}
	# set_component_parameter_value CTI_Enable {0}
	# set_component_parameter_value DMA_Enable {No No No No No No No No}
	# set_component_parameter_value Debug_APB_Enable {0}
	# set_component_parameter_value EMAC0_Mode {RGMII}
	# set_component_parameter_value EMAC0_PTP {0}
	# set_component_parameter_value EMAC0_PinMuxing {FPGA}
	# set_component_parameter_value EMAC1_Mode {N/A}
	# set_component_parameter_value EMAC1_PTP {0}
	# set_component_parameter_value EMAC1_PinMuxing {Unused}
	# set_component_parameter_value EMAC2_Mode {N/A}
	# set_component_parameter_value EMAC2_PTP {0}
	# set_component_parameter_value EMAC2_PinMuxing {Unused}
	# set_component_parameter_value EMIF_AXI_Enable {0}
	# set_component_parameter_value EMIF_Topology {0}
	# set_component_parameter_value F2H_IRQ_Enable {0}
	# set_component_parameter_value F2H_free_clk_mhz {200}
	# set_component_parameter_value F2H_free_clock_enable {0}
	# set_component_parameter_value FPGA_EMAC0_gtx_clk_mhz {125.0}
	# set_component_parameter_value FPGA_EMAC0_md_clk_mhz {2.5}
	# set_component_parameter_value FPGA_EMAC1_gtx_clk_mhz {125.0}
	# set_component_parameter_value FPGA_EMAC1_md_clk_mhz {2.5}
	# set_component_parameter_value FPGA_EMAC2_gtx_clk_mhz {125.0}
	# set_component_parameter_value FPGA_EMAC2_md_clk_mhz {2.5}
	# set_component_parameter_value FPGA_I2C0_sclk_mhz {125.0}
	# set_component_parameter_value FPGA_I2C1_sclk_mhz {125.0}
	# set_component_parameter_value FPGA_I2CEMAC0_clk_mhz {125.0}
	# set_component_parameter_value FPGA_I2CEMAC1_clk_mhz {125.0}
	# set_component_parameter_value FPGA_I2CEMAC2_clk_mhz {125.0}
	# set_component_parameter_value FPGA_I3CM_sclk_mhz {125.0}
	# set_component_parameter_value FPGA_I3CS_sclk_mhz {125.0}
	# set_component_parameter_value FPGA_SPIM0_sclk_mhz {125.0}
	# set_component_parameter_value FPGA_SPIM1_sclk_mhz {125.0}
	# set_component_parameter_value GP_Enable {0}
	# set_component_parameter_value H2F_Address_Width {38}
	# set_component_parameter_value H2F_IRQ_DMA_Enable0 {0}
	# set_component_parameter_value H2F_IRQ_DMA_Enable1 {0}
	# set_component_parameter_value H2F_IRQ_ECC_SERR_Enable {0}
	# set_component_parameter_value H2F_IRQ_EMAC0_Enable {0}
	# set_component_parameter_value H2F_IRQ_EMAC1_Enable {0}
	# set_component_parameter_value H2F_IRQ_EMAC2_Enable {0}
	# set_component_parameter_value H2F_IRQ_GPIO0_Enable {0}
	# set_component_parameter_value H2F_IRQ_GPIO1_Enable {0}
	# set_component_parameter_value H2F_IRQ_I2C0_Enable {0}
	# set_component_parameter_value H2F_IRQ_I2C1_Enable {0}
	# set_component_parameter_value H2F_IRQ_I2CEMAC0_Enable {0}
	# set_component_parameter_value H2F_IRQ_I2CEMAC1_Enable {0}
	# set_component_parameter_value H2F_IRQ_I2CEMAC2_Enable {0}
	# set_component_parameter_value H2F_IRQ_I3C0_Enable {0}
	# set_component_parameter_value H2F_IRQ_I3C1_Enable {0}
	# set_component_parameter_value H2F_IRQ_L4Timer_Enable {0}
	# set_component_parameter_value H2F_IRQ_NAND_Enable {0}
	# set_component_parameter_value H2F_IRQ_PeriphClock_Enable {0}
	# set_component_parameter_value H2F_IRQ_SDMMC_Enable {0}
	# set_component_parameter_value H2F_IRQ_SPIM0_Enable {0}
	# set_component_parameter_value H2F_IRQ_SPIM1_Enable {0}
	# set_component_parameter_value H2F_IRQ_SPIS0_Enable {0}
	# set_component_parameter_value H2F_IRQ_SPIS1_Enable {0}
	# set_component_parameter_value H2F_IRQ_SYSTimer_Enable {0}
	# set_component_parameter_value H2F_IRQ_UART0_Enable {0}
	# set_component_parameter_value H2F_IRQ_UART1_Enable {0}
	# set_component_parameter_value H2F_IRQ_USB0_Enable {0}
	# set_component_parameter_value H2F_IRQ_USB1_Enable {0}
	# set_component_parameter_value H2F_IRQ_Watchdog_Enable {0}
	# set_component_parameter_value H2F_Width {0}
	# set_component_parameter_value HPS_IO_Enable {unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused unused}
	# set_component_parameter_value I2C0_Mode {N/A}
	# set_component_parameter_value I2C0_PinMuxing {Unused}
	# set_component_parameter_value I2C1_Mode {N/A}
	# set_component_parameter_value I2C1_PinMuxing {Unused}
	# set_component_parameter_value I2CEMAC0_Mode {N/A}
	# set_component_parameter_value I2CEMAC0_PinMuxing {Unused}
	# set_component_parameter_value I2CEMAC1_Mode {N/A}
	# set_component_parameter_value I2CEMAC1_PinMuxing {Unused}
	# set_component_parameter_value I2CEMAC2_Mode {N/A}
	# set_component_parameter_value I2CEMAC2_PinMuxing {Unused}
	# set_component_parameter_value I3C0_Mode {N/A}
	# set_component_parameter_value I3C0_PinMuxing {Unused}
	# set_component_parameter_value I3C1_Mode {N/A}
	# set_component_parameter_value I3C1_PinMuxing {Unused}
	# set_component_parameter_value IO_INPUT_DELAY0 {-1}
	# set_component_parameter_value IO_INPUT_DELAY1 {-1}
	# set_component_parameter_value IO_INPUT_DELAY10 {-1}
	# set_component_parameter_value IO_INPUT_DELAY11 {-1}
	# set_component_parameter_value IO_INPUT_DELAY12 {-1}
	# set_component_parameter_value IO_INPUT_DELAY13 {-1}
	# set_component_parameter_value IO_INPUT_DELAY14 {-1}
	# set_component_parameter_value IO_INPUT_DELAY15 {-1}
	# set_component_parameter_value IO_INPUT_DELAY16 {-1}
	# set_component_parameter_value IO_INPUT_DELAY17 {-1}
	# set_component_parameter_value IO_INPUT_DELAY18 {-1}
	# set_component_parameter_value IO_INPUT_DELAY19 {-1}
	# set_component_parameter_value IO_INPUT_DELAY2 {-1}
	# set_component_parameter_value IO_INPUT_DELAY20 {-1}
	# set_component_parameter_value IO_INPUT_DELAY21 {-1}
	# set_component_parameter_value IO_INPUT_DELAY22 {-1}
	# set_component_parameter_value IO_INPUT_DELAY23 {-1}
	# set_component_parameter_value IO_INPUT_DELAY24 {-1}
	# set_component_parameter_value IO_INPUT_DELAY25 {-1}
	# set_component_parameter_value IO_INPUT_DELAY26 {-1}
	# set_component_parameter_value IO_INPUT_DELAY27 {-1}
	# set_component_parameter_value IO_INPUT_DELAY28 {-1}
	# set_component_parameter_value IO_INPUT_DELAY29 {-1}
	# set_component_parameter_value IO_INPUT_DELAY3 {-1}
	# set_component_parameter_value IO_INPUT_DELAY30 {-1}
	# set_component_parameter_value IO_INPUT_DELAY31 {-1}
	# set_component_parameter_value IO_INPUT_DELAY32 {-1}
	# set_component_parameter_value IO_INPUT_DELAY33 {-1}
	# set_component_parameter_value IO_INPUT_DELAY34 {-1}
	# set_component_parameter_value IO_INPUT_DELAY35 {-1}
	# set_component_parameter_value IO_INPUT_DELAY36 {-1}
	# set_component_parameter_value IO_INPUT_DELAY37 {-1}
	# set_component_parameter_value IO_INPUT_DELAY38 {-1}
	# set_component_parameter_value IO_INPUT_DELAY39 {-1}
	# set_component_parameter_value IO_INPUT_DELAY4 {-1}
	# set_component_parameter_value IO_INPUT_DELAY40 {-1}
	# set_component_parameter_value IO_INPUT_DELAY41 {-1}
	# set_component_parameter_value IO_INPUT_DELAY42 {-1}
	# set_component_parameter_value IO_INPUT_DELAY43 {-1}
	# set_component_parameter_value IO_INPUT_DELAY44 {-1}
	# set_component_parameter_value IO_INPUT_DELAY45 {-1}
	# set_component_parameter_value IO_INPUT_DELAY46 {-1}
	# set_component_parameter_value IO_INPUT_DELAY47 {-1}
	# set_component_parameter_value IO_INPUT_DELAY5 {-1}
	# set_component_parameter_value IO_INPUT_DELAY6 {-1}
	# set_component_parameter_value IO_INPUT_DELAY7 {-1}
	# set_component_parameter_value IO_INPUT_DELAY8 {-1}
	# set_component_parameter_value IO_INPUT_DELAY9 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY0 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY1 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY10 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY11 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY12 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY13 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY14 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY15 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY16 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY17 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY18 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY19 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY2 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY20 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY21 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY22 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY23 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY24 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY25 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY26 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY27 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY28 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY29 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY3 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY30 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY31 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY32 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY33 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY34 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY35 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY36 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY37 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY38 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY39 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY4 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY40 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY41 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY42 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY43 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY44 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY45 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY46 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY47 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY5 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY6 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY7 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY8 {-1}
	# set_component_parameter_value IO_OUTPUT_DELAY9 {-1}
	# set_component_parameter_value JTAG_Enable {0}
	# set_component_parameter_value LWH2F_Address_Width {29}
	# set_component_parameter_value LWH2F_Width {0}
	# set_component_parameter_value MPLL_C0_Override_mhz {1600.0}
	# set_component_parameter_value MPLL_C1_Override_mhz {800.0}
	# set_component_parameter_value MPLL_C2_Override_mhz {1066.67}
	# set_component_parameter_value MPLL_C3_Override_mhz {400.0}
	# set_component_parameter_value MPLL_Clock_Source {0}
	# set_component_parameter_value MPLL_Override {0}
	# set_component_parameter_value MPLL_VCO_Override_mhz {3200.0}
	# set_component_parameter_value MPU_Events_Enable {0}
	# set_component_parameter_value MPU_clk_ccu_div {1}
	# set_component_parameter_value MPU_clk_freq_override_mhz {1066.67}
	# set_component_parameter_value MPU_clk_override {0}
	# set_component_parameter_value MPU_clk_periph_div {1}
	# set_component_parameter_value MPU_clk_src_override {2}
	# set_component_parameter_value MPU_core01_src_override {1}
	# set_component_parameter_value MPU_core0_freq_override_mhz {1033.33}
	# set_component_parameter_value MPU_core1_freq_override_mhz {800.0}
	# set_component_parameter_value MPU_core23_src_override {0}
	# set_component_parameter_value MPU_core2_freq_override_mhz {1600.0}
	# set_component_parameter_value MPU_core3_freq_override_mhz {1600.0}
	# set_component_parameter_value NAND_Mode {N/A}
	# set_component_parameter_value NAND_PinMuxing {Unused}
	# set_component_parameter_value NOC_clk_cs_debug_div {4}
	# set_component_parameter_value NOC_clk_cs_div {1}
	# set_component_parameter_value NOC_clk_cs_trace_div {4}
	# set_component_parameter_value NOC_clk_free_l4_div {4}
	# set_component_parameter_value NOC_clk_periph_l4_div {2}
	# set_component_parameter_value NOC_clk_phy_div {4}
	# set_component_parameter_value NOC_clk_slow_l4_div {4}
	# set_component_parameter_value NOC_clk_src_select {3}
	# set_component_parameter_value PLL_CLK0 {Unused}
	# set_component_parameter_value PLL_CLK1 {Unused}
	# set_component_parameter_value PLL_CLK2 {Unused}
	# set_component_parameter_value PLL_CLK3 {Unused}
	# set_component_parameter_value PLL_CLK4 {Unused}
	# set_component_parameter_value PPLL_C0_Override_mhz {1600.0}
	# set_component_parameter_value PPLL_C1_Override_mhz {800.0}
	# set_component_parameter_value PPLL_C2_Override_mhz {1066.67}
	# set_component_parameter_value PPLL_C3_Override_mhz {400.0}
	# set_component_parameter_value PPLL_Clock_Source {0}
	# set_component_parameter_value PPLL_Override {0}
	# set_component_parameter_value PPLL_VCO_Override_mhz {3200.0}
	# set_component_parameter_value Periph_clk_emac0_sel {50}
	# set_component_parameter_value Periph_clk_emac1_sel {50}
	# set_component_parameter_value Periph_clk_emac2_sel {50}
	# set_component_parameter_value Periph_clk_override {0}
	# set_component_parameter_value Periph_emac_ptp_freq_override {400.0}
	# set_component_parameter_value Periph_emac_ptp_src_override {7}
	# set_component_parameter_value Periph_emaca_src_override {7}
	# set_component_parameter_value Periph_emacb_src_override {7}
	# set_component_parameter_value Periph_gpio_freq_override {400.0}
	# set_component_parameter_value Periph_gpio_src_override {3}
	# set_component_parameter_value Periph_psi_freq_override {500.0}
	# set_component_parameter_value Periph_psi_src_override {7}
	# set_component_parameter_value Periph_usb_freq_override {20.0}
	# set_component_parameter_value Periph_usb_src_override {3}
	# set_component_parameter_value Pwr_a55_core0_1_on {1}
	# set_component_parameter_value Pwr_a76_core2_on {1}
	# set_component_parameter_value Pwr_a76_core3_on {1}
	# set_component_parameter_value Pwr_boot_core_sel {0}
	# set_component_parameter_value Pwr_cpu_app_select {0}
	# set_component_parameter_value Pwr_mpu_l3_cache_size {2}
	# set_component_parameter_value Rst_h2f_cold_en {0}
	# set_component_parameter_value Rst_hps_warm_en {0}
	# set_component_parameter_value Rst_sdm_wd_config {0}
	# set_component_parameter_value Rst_watchdog_en {0}
	# set_component_parameter_value SDMMC_Mode {N/A}
	# set_component_parameter_value SDMMC_PinMuxing {Unused}
	# set_component_parameter_value SPIM0_Mode {N/A}
	# set_component_parameter_value SPIM0_PinMuxing {Unused}
	# set_component_parameter_value SPIM1_Mode {N/A}
	# set_component_parameter_value SPIM1_PinMuxing {Unused}
	# set_component_parameter_value SPIS0_Mode {N/A}
	# set_component_parameter_value SPIS0_PinMuxing {Unused}
	# set_component_parameter_value SPIS1_Mode {N/A}
	# set_component_parameter_value SPIS1_PinMuxing {Unused}
	# set_component_parameter_value STM_Enable {0}
	# set_component_parameter_value TPIU_Select {HPS Clock Manager}
	# set_component_parameter_value TRACE_Mode {N/A}
	# set_component_parameter_value TRACE_PinMuxing {Unused}
	# set_component_parameter_value UART0_Mode {N/A}
	# set_component_parameter_value UART0_PinMuxing {Unused}
	# set_component_parameter_value UART1_Mode {N/A}
	# set_component_parameter_value UART1_PinMuxing {Unused}
	# set_component_parameter_value USB0_Mode {N/A}
	# set_component_parameter_value USB0_PinMuxing {Unused}
	# set_component_parameter_value USB1_Mode {N/A}
	# set_component_parameter_value USB1_PinMuxing {Unused}
	# set_component_parameter_value User0_clk_enable {0}
	# set_component_parameter_value User0_clk_freq {500.0}
	# set_component_parameter_value User0_clk_src_select {7}
	# set_component_parameter_value User1_clk_enable {0}
	# set_component_parameter_value User1_clk_freq {500.0}
	# set_component_parameter_value User1_clk_src_select {7}
	# set_component_parameter_value eosc1_clk_mhz {25.0}
	# set_component_parameter_value f2s_SMMU {0}
	# set_component_parameter_value f2s_address_width {40}
	# set_component_parameter_value f2s_data_width {0}
	# set_component_parameter_value f2s_mode {acelite}
	# set_component_parameter_value f2sdram_address_width {40}
	# set_component_parameter_value f2sdram_data_width {0}
	# set_component_parameter_value hps_ioa10_opd_en {0}
	# set_component_parameter_value hps_ioa11_opd_en {0}
	# set_component_parameter_value hps_ioa12_opd_en {0}
	# set_component_parameter_value hps_ioa13_opd_en {0}
	# set_component_parameter_value hps_ioa14_opd_en {0}
	# set_component_parameter_value hps_ioa15_opd_en {0}
	# set_component_parameter_value hps_ioa16_opd_en {0}
	# set_component_parameter_value hps_ioa17_opd_en {0}
	# set_component_parameter_value hps_ioa18_opd_en {0}
	# set_component_parameter_value hps_ioa19_opd_en {0}
	# set_component_parameter_value hps_ioa1_opd_en {0}
	# set_component_parameter_value hps_ioa20_opd_en {0}
	# set_component_parameter_value hps_ioa21_opd_en {0}
	# set_component_parameter_value hps_ioa22_opd_en {0}
	# set_component_parameter_value hps_ioa23_opd_en {0}
	# set_component_parameter_value hps_ioa24_opd_en {0}
	# set_component_parameter_value hps_ioa2_opd_en {0}
	# set_component_parameter_value hps_ioa3_opd_en {0}
	# set_component_parameter_value hps_ioa4_opd_en {0}
	# set_component_parameter_value hps_ioa5_opd_en {0}
	# set_component_parameter_value hps_ioa6_opd_en {0}
	# set_component_parameter_value hps_ioa7_opd_en {0}
	# set_component_parameter_value hps_ioa8_opd_en {0}
	# set_component_parameter_value hps_ioa9_opd_en {0}
	# set_component_parameter_value hps_iob10_opd_en {0}
	# set_component_parameter_value hps_iob11_opd_en {0}
	# set_component_parameter_value hps_iob12_opd_en {0}
	# set_component_parameter_value hps_iob13_opd_en {0}
	# set_component_parameter_value hps_iob14_opd_en {0}
	# set_component_parameter_value hps_iob15_opd_en {0}
	# set_component_parameter_value hps_iob16_opd_en {0}
	# set_component_parameter_value hps_iob17_opd_en {0}
	# set_component_parameter_value hps_iob18_opd_en {0}
	# set_component_parameter_value hps_iob19_opd_en {0}
	# set_component_parameter_value hps_iob1_opd_en {0}
	# set_component_parameter_value hps_iob20_opd_en {0}
	# set_component_parameter_value hps_iob21_opd_en {0}
	# set_component_parameter_value hps_iob22_opd_en {0}
	# set_component_parameter_value hps_iob23_opd_en {0}
	# set_component_parameter_value hps_iob24_opd_en {0}
	# set_component_parameter_value hps_iob2_opd_en {0}
	# set_component_parameter_value hps_iob3_opd_en {0}
	# set_component_parameter_value hps_iob4_opd_en {0}
	# set_component_parameter_value hps_iob5_opd_en {0}
	# set_component_parameter_value hps_iob6_opd_en {0}
	# set_component_parameter_value hps_iob7_opd_en {0}
	# set_component_parameter_value hps_iob8_opd_en {0}
	# set_component_parameter_value hps_iob9_opd_en {0}
	# set_component_project_property HIDE_FROM_IP_CATALOG {false}
	# save_component
	# load_instantiation intel_agilex_5_soc_0
	# remove_instantiation_interfaces_and_ports
	# add_instantiation_interface h2f_reset reset OUTPUT
	# set_instantiation_interface_parameter_value h2f_reset associatedClock {}
	# set_instantiation_interface_parameter_value h2f_reset associatedDirectReset {}
	# set_instantiation_interface_parameter_value h2f_reset associatedResetSinks {none}
	# set_instantiation_interface_parameter_value h2f_reset synchronousEdges {NONE}
	# add_instantiation_interface_port h2f_reset h2f_reset_reset_n reset_n 1 STD_LOGIC Output
	# add_instantiation_interface emac_ptp_clk clock INPUT
	# set_instantiation_interface_parameter_value emac_ptp_clk clockRate {0}
	# set_instantiation_interface_parameter_value emac_ptp_clk externallyDriven {false}
	# set_instantiation_interface_parameter_value emac_ptp_clk ptfSchematicName {}
	# add_instantiation_interface_port emac_ptp_clk emac_ptp_clk_clk clk 1 STD_LOGIC Input
	# add_instantiation_interface emac_timestamp_clk clock INPUT
	# set_instantiation_interface_parameter_value emac_timestamp_clk clockRate {0}
	# set_instantiation_interface_parameter_value emac_timestamp_clk externallyDriven {false}
	# set_instantiation_interface_parameter_value emac_timestamp_clk ptfSchematicName {}
	# add_instantiation_interface_port emac_timestamp_clk emac_timestamp_clk_clk clk 1 STD_LOGIC Input
	# add_instantiation_interface emac_timestamp_data conduit INPUT
	# set_instantiation_interface_parameter_value emac_timestamp_data associatedClock {}
	# set_instantiation_interface_parameter_value emac_timestamp_data associatedReset {}
	# set_instantiation_interface_parameter_value emac_timestamp_data prSafe {false}
	# add_instantiation_interface_port emac_timestamp_data emac_timestamp_data_data_in data_in 64 STD_LOGIC_VECTOR Input
	# add_instantiation_interface emac0_app_rst reset OUTPUT
	# set_instantiation_interface_parameter_value emac0_app_rst associatedClock {}
	# set_instantiation_interface_parameter_value emac0_app_rst associatedDirectReset {}
	# set_instantiation_interface_parameter_value emac0_app_rst associatedResetSinks {none}
	# set_instantiation_interface_parameter_value emac0_app_rst synchronousEdges {NONE}
	# add_instantiation_interface_port emac0_app_rst emac0_app_rst_reset_n reset_n 1 STD_LOGIC Output
	# add_instantiation_interface emac0 conduit INPUT
	# set_instantiation_interface_parameter_value emac0 associatedClock {}
	# set_instantiation_interface_parameter_value emac0 associatedReset {}
	# set_instantiation_interface_parameter_value emac0 prSafe {false}
	# add_instantiation_interface_port emac0 emac0_mac_tx_clk_o mac_tx_clk_o 1 STD_LOGIC Output
	# add_instantiation_interface_port emac0 emac0_mac_rx_clk mac_rx_clk 1 STD_LOGIC Input
	# add_instantiation_interface_port emac0 emac0_mac_rst_tx_n mac_rst_tx_n 1 STD_LOGIC Output
	# add_instantiation_interface_port emac0 emac0_mac_rst_rx_n mac_rst_rx_n 1 STD_LOGIC Output
	# add_instantiation_interface_port emac0 emac0_mac_txen mac_txen 1 STD_LOGIC Output
	# add_instantiation_interface_port emac0 emac0_mac_txer mac_txer 1 STD_LOGIC Output
	# add_instantiation_interface_port emac0 emac0_mac_rxdv mac_rxdv 1 STD_LOGIC Input
	# add_instantiation_interface_port emac0 emac0_mac_rxer mac_rxer 1 STD_LOGIC Input
	# add_instantiation_interface_port emac0 emac0_mac_rxd mac_rxd 8 STD_LOGIC_VECTOR Input
	# add_instantiation_interface_port emac0 emac0_mac_col mac_col 1 STD_LOGIC Input
	# add_instantiation_interface_port emac0 emac0_mac_crs mac_crs 1 STD_LOGIC Input
	# add_instantiation_interface_port emac0 emac0_mac_speed mac_speed 3 STD_LOGIC_VECTOR Output
	# add_instantiation_interface_port emac0 emac0_mac_txd_o mac_txd_o 8 STD_LOGIC_VECTOR Output
	# save_instantiation
    
    add_component_param "intel_gmii_to_rgmii_converter intel_gmii_to_rgmii_converter_0 
                    IP_FILE_PATH ip/$subsys_name/intel_gmii_to_rgmii_converter_0.ip 
                    RX_PIPELINE_DEPTH 5
                    TX_PIPELINE_DEPTH 2
                    "
    
	# add_component intel_gmii_to_rgmii_converter_0 ip/$subsys_name/intel_gmii_to_rgmii_converter_0.ip intel_gmii_to_rgmii_converter intel_gmii_to_rgmii_converter_0 1.1.0
	# load_component intel_gmii_to_rgmii_converter_0
	# set_component_parameter_value ADVANCED_MODE {0}
	# set_component_parameter_value RX_PIPELINE_DEPTH {5}
	# set_component_parameter_value TX_PIPELINE_DEPTH {2}
	# set_component_project_property HIDE_FROM_IP_CATALOG {false}
	# save_component
	# load_instantiation intel_gmii_to_rgmii_converter_0
	# remove_instantiation_interfaces_and_ports
	# add_instantiation_interface hps_gmii conduit INPUT
	# set_instantiation_interface_parameter_value hps_gmii associatedClock {}
	# set_instantiation_interface_parameter_value hps_gmii associatedReset {}
	# set_instantiation_interface_parameter_value hps_gmii prSafe {false}
	# add_instantiation_interface_port hps_gmii hps_gmii_mac_tx_clk_o mac_tx_clk_o 1 STD_LOGIC Input
	# add_instantiation_interface_port hps_gmii hps_gmii_mac_rst_tx_n mac_rst_tx_n 1 STD_LOGIC Input
	# add_instantiation_interface_port hps_gmii hps_gmii_mac_rst_rx_n mac_rst_rx_n 1 STD_LOGIC Input
	# add_instantiation_interface_port hps_gmii hps_gmii_mac_txd_o mac_txd_o 8 STD_LOGIC_VECTOR Input
	# add_instantiation_interface_port hps_gmii hps_gmii_mac_txen mac_txen 1 STD_LOGIC Input
	# add_instantiation_interface_port hps_gmii hps_gmii_mac_txer mac_txer 1 STD_LOGIC Input
	# add_instantiation_interface_port hps_gmii hps_gmii_mac_speed mac_speed 3 STD_LOGIC_VECTOR Input
	# add_instantiation_interface_port hps_gmii hps_gmii_mac_tx_clk_i mac_tx_clk_i 1 STD_LOGIC Output
	# add_instantiation_interface_port hps_gmii hps_gmii_mac_rx_clk mac_rx_clk 1 STD_LOGIC Output
	# add_instantiation_interface_port hps_gmii hps_gmii_mac_rxdv mac_rxdv 1 STD_LOGIC Output
	# add_instantiation_interface_port hps_gmii hps_gmii_mac_rxer mac_rxer 1 STD_LOGIC Output
	# add_instantiation_interface_port hps_gmii hps_gmii_mac_rxd mac_rxd 8 STD_LOGIC_VECTOR Output
	# add_instantiation_interface_port hps_gmii hps_gmii_mac_col mac_col 1 STD_LOGIC Output
	# add_instantiation_interface_port hps_gmii hps_gmii_mac_crs mac_crs 1 STD_LOGIC Output
	# add_instantiation_interface phy_rgmii conduit INPUT
	# set_instantiation_interface_parameter_value phy_rgmii associatedClock {}
	# set_instantiation_interface_parameter_value phy_rgmii associatedReset {}
	# set_instantiation_interface_parameter_value phy_rgmii prSafe {false}
	# add_instantiation_interface_port phy_rgmii phy_rgmii_rgmii_rx_clk rgmii_rx_clk 1 STD_LOGIC Input
	# add_instantiation_interface_port phy_rgmii phy_rgmii_rgmii_rxd rgmii_rxd 4 STD_LOGIC_VECTOR Input
	# add_instantiation_interface_port phy_rgmii phy_rgmii_rgmii_rx_ctl rgmii_rx_ctl 1 STD_LOGIC Input
	# add_instantiation_interface_port phy_rgmii phy_rgmii_rgmii_tx_clk rgmii_tx_clk 1 STD_LOGIC Output
	# add_instantiation_interface_port phy_rgmii phy_rgmii_rgmii_txd rgmii_txd 4 STD_LOGIC_VECTOR Output
	# add_instantiation_interface_port phy_rgmii phy_rgmii_rgmii_tx_ctl rgmii_tx_ctl 1 STD_LOGIC Output
	# add_instantiation_interface pll_250m_tx_clock clock INPUT
	# set_instantiation_interface_parameter_value pll_250m_tx_clock clockRate {0}
	# set_instantiation_interface_parameter_value pll_250m_tx_clock externallyDriven {false}
	# set_instantiation_interface_parameter_value pll_250m_tx_clock ptfSchematicName {}
	# add_instantiation_interface_port pll_250m_tx_clock pll_250m_tx_clock_clk clk 1 STD_LOGIC Input
	# add_instantiation_interface pll_125m_tx_clock clock INPUT
	# set_instantiation_interface_parameter_value pll_125m_tx_clock clockRate {0}
	# set_instantiation_interface_parameter_value pll_125m_tx_clock externallyDriven {false}
	# set_instantiation_interface_parameter_value pll_125m_tx_clock ptfSchematicName {}
	# add_instantiation_interface_port pll_125m_tx_clock pll_125m_tx_clock_clk clk 1 STD_LOGIC Input
	# add_instantiation_interface pll_25m_clock clock INPUT
	# set_instantiation_interface_parameter_value pll_25m_clock clockRate {0}
	# set_instantiation_interface_parameter_value pll_25m_clock externallyDriven {false}
	# set_instantiation_interface_parameter_value pll_25m_clock ptfSchematicName {}
	# add_instantiation_interface_port pll_25m_clock pll_25m_clock_clk clk 1 STD_LOGIC Input
	# add_instantiation_interface pll_2_5m_clock clock INPUT
	# set_instantiation_interface_parameter_value pll_2_5m_clock clockRate {0}
	# set_instantiation_interface_parameter_value pll_2_5m_clock externallyDriven {false}
	# set_instantiation_interface_parameter_value pll_2_5m_clock ptfSchematicName {}
	# add_instantiation_interface_port pll_2_5m_clock pll_2_5m_clock_clk clk 1 STD_LOGIC Input
	# add_instantiation_interface locked_pll_250m_tx conduit INPUT
	# set_instantiation_interface_parameter_value locked_pll_250m_tx associatedClock {}
	# set_instantiation_interface_parameter_value locked_pll_250m_tx associatedReset {}
	# set_instantiation_interface_parameter_value locked_pll_250m_tx prSafe {false}
	# add_instantiation_interface_port locked_pll_250m_tx locked_pll_250m_tx_export export 1 STD_LOGIC Input
	# add_instantiation_interface peri_reset reset INPUT
	# set_instantiation_interface_parameter_value peri_reset associatedClock {}
	# set_instantiation_interface_parameter_value peri_reset synchronousEdges {NONE}
	# add_instantiation_interface_port peri_reset peri_reset_reset reset 1 STD_LOGIC Input
	# add_instantiation_interface peri_clock clock INPUT
	# set_instantiation_interface_parameter_value peri_clock clockRate {0}
	# set_instantiation_interface_parameter_value peri_clock externallyDriven {false}
	# set_instantiation_interface_parameter_value peri_clock ptfSchematicName {}
	# add_instantiation_interface_port peri_clock peri_clock_clk clk 1 STD_LOGIC Input
	# save_instantiation
    
    # add_component_param "altera_iopll iopll_0 
                # IP_FILE_PATH ip/$subsys_name/iopll_0.ip 
                # "
	add_component iopll_0 ip/$subsys_name/iopll_0.ip altera_iopll iopll_0 19.3.1
	load_component iopll_0
	set_component_parameter_value gui_active_clk {0}
	set_component_parameter_value gui_c_cnt_in_src0 {c_m_cnt_in_src_ph_mux_clk}
	set_component_parameter_value gui_c_cnt_in_src1 {c_m_cnt_in_src_ph_mux_clk}
	set_component_parameter_value gui_c_cnt_in_src2 {c_m_cnt_in_src_ph_mux_clk}
	set_component_parameter_value gui_c_cnt_in_src3 {c_m_cnt_in_src_ph_mux_clk}
	set_component_parameter_value gui_c_cnt_in_src4 {c_m_cnt_in_src_ph_mux_clk}
	set_component_parameter_value gui_c_cnt_in_src5 {c_m_cnt_in_src_ph_mux_clk}
	set_component_parameter_value gui_c_cnt_in_src6 {c_m_cnt_in_src_ph_mux_clk}
	set_component_parameter_value gui_c_cnt_in_src7 {c_m_cnt_in_src_ph_mux_clk}
	set_component_parameter_value gui_c_cnt_in_src8 {c_m_cnt_in_src_ph_mux_clk}
	set_component_parameter_value gui_cal_code_hex_file {iossm.hex}
	set_component_parameter_value gui_cal_converge {0}
	set_component_parameter_value gui_cal_error {cal_clean}
	set_component_parameter_value gui_cascade_counter0 {0}
	set_component_parameter_value gui_cascade_counter1 {0}
	set_component_parameter_value gui_cascade_counter10 {0}
	set_component_parameter_value gui_cascade_counter11 {0}
	set_component_parameter_value gui_cascade_counter12 {0}
	set_component_parameter_value gui_cascade_counter13 {0}
	set_component_parameter_value gui_cascade_counter14 {0}
	set_component_parameter_value gui_cascade_counter15 {0}
	set_component_parameter_value gui_cascade_counter16 {0}
	set_component_parameter_value gui_cascade_counter17 {0}
	set_component_parameter_value gui_cascade_counter2 {0}
	set_component_parameter_value gui_cascade_counter3 {0}
	set_component_parameter_value gui_cascade_counter4 {0}
	set_component_parameter_value gui_cascade_counter5 {0}
	set_component_parameter_value gui_cascade_counter6 {0}
	set_component_parameter_value gui_cascade_counter7 {0}
	set_component_parameter_value gui_cascade_counter8 {0}
	set_component_parameter_value gui_cascade_counter9 {0}
	set_component_parameter_value gui_cascade_outclk_index {5}
	set_component_parameter_value gui_clk_bad {0}
	set_component_parameter_value gui_clock_name_global {0}
	set_component_parameter_value gui_clock_name_string0 {outclk0}
	set_component_parameter_value gui_clock_name_string1 {outclk1}
	set_component_parameter_value gui_clock_name_string10 {outclk10}
	set_component_parameter_value gui_clock_name_string11 {outclk11}
	set_component_parameter_value gui_clock_name_string12 {outclk12}
	set_component_parameter_value gui_clock_name_string13 {outclk13}
	set_component_parameter_value gui_clock_name_string14 {outclk14}
	set_component_parameter_value gui_clock_name_string15 {outclk15}
	set_component_parameter_value gui_clock_name_string16 {outclk16}
	set_component_parameter_value gui_clock_name_string17 {outclk17}
	set_component_parameter_value gui_clock_name_string2 {outclk2}
	set_component_parameter_value gui_clock_name_string3 {outclk3}
	set_component_parameter_value gui_clock_name_string4 {outclk4}
	set_component_parameter_value gui_clock_name_string5 {outclk5}
	set_component_parameter_value gui_clock_name_string6 {outclk6}
	set_component_parameter_value gui_clock_name_string7 {outclk7}
	set_component_parameter_value gui_clock_name_string8 {outclk8}
	set_component_parameter_value gui_clock_name_string9 {outclk9}
	set_component_parameter_value gui_clock_to_compensate {0}
	set_component_parameter_value gui_debug_mode {0}
	set_component_parameter_value gui_divide_factor_c0 {6}
	set_component_parameter_value gui_divide_factor_c1 {6}
	set_component_parameter_value gui_divide_factor_c10 {6}
	set_component_parameter_value gui_divide_factor_c11 {6}
	set_component_parameter_value gui_divide_factor_c12 {6}
	set_component_parameter_value gui_divide_factor_c13 {6}
	set_component_parameter_value gui_divide_factor_c14 {6}
	set_component_parameter_value gui_divide_factor_c15 {6}
	set_component_parameter_value gui_divide_factor_c16 {6}
	set_component_parameter_value gui_divide_factor_c17 {6}
	set_component_parameter_value gui_divide_factor_c2 {6}
	set_component_parameter_value gui_divide_factor_c3 {6}
	set_component_parameter_value gui_divide_factor_c4 {6}
	set_component_parameter_value gui_divide_factor_c5 {6}
	set_component_parameter_value gui_divide_factor_c6 {6}
	set_component_parameter_value gui_divide_factor_c7 {6}
	set_component_parameter_value gui_divide_factor_c8 {6}
	set_component_parameter_value gui_divide_factor_c9 {6}
	set_component_parameter_value gui_divide_factor_n {1}
	set_component_parameter_value gui_dps_cntr {C0}
	set_component_parameter_value gui_dps_dir {Positive}
	set_component_parameter_value gui_dps_num {1}
	set_component_parameter_value gui_dsm_out_sel {1st_order}
	set_component_parameter_value gui_duty_cycle0 {50.0}
	set_component_parameter_value gui_duty_cycle1 {50.0}
	set_component_parameter_value gui_duty_cycle10 {50.0}
	set_component_parameter_value gui_duty_cycle11 {50.0}
	set_component_parameter_value gui_duty_cycle12 {50.0}
	set_component_parameter_value gui_duty_cycle13 {50.0}
	set_component_parameter_value gui_duty_cycle14 {50.0}
	set_component_parameter_value gui_duty_cycle15 {50.0}
	set_component_parameter_value gui_duty_cycle16 {50.0}
	set_component_parameter_value gui_duty_cycle17 {50.0}
	set_component_parameter_value gui_duty_cycle2 {50.0}
	set_component_parameter_value gui_duty_cycle3 {50.0}
	set_component_parameter_value gui_duty_cycle4 {50.0}
	set_component_parameter_value gui_duty_cycle5 {50.0}
	set_component_parameter_value gui_duty_cycle6 {50.0}
	set_component_parameter_value gui_duty_cycle7 {50.0}
	set_component_parameter_value gui_duty_cycle8 {50.0}
	set_component_parameter_value gui_duty_cycle9 {50.0}
	set_component_parameter_value gui_en_adv_params {0}
	set_component_parameter_value gui_en_dps_ports {0}
	set_component_parameter_value gui_en_extclkout_ports {0}
	set_component_parameter_value gui_en_iossm_reconf {0}
	set_component_parameter_value gui_en_lvds_ports {Disabled}
	set_component_parameter_value gui_en_periphery_ports {0}
	set_component_parameter_value gui_en_phout_ports {0}
	set_component_parameter_value gui_en_reconf {0}
	set_component_parameter_value gui_enable_cascade_in {0}
	set_component_parameter_value gui_enable_cascade_out {0}
	set_component_parameter_value gui_enable_mif_dps {0}
	set_component_parameter_value gui_enable_output_counter_cascading {0}
	set_component_parameter_value gui_enable_permit_cal {0}
	set_component_parameter_value gui_enable_upstream_out_clk {0}
	set_component_parameter_value gui_existing_mif_file_path {~/pll.mif}
	set_component_parameter_value gui_extclkout_0_source {C0}
	set_component_parameter_value gui_extclkout_1_source {C0}
	set_component_parameter_value gui_extclkout_source {C0}
	set_component_parameter_value gui_feedback_clock {Global Clock}
	set_component_parameter_value gui_fix_vco_frequency {0}
	set_component_parameter_value gui_fixed_vco_frequency {600.0}
	set_component_parameter_value gui_fixed_vco_frequency_ps {1667.0}
	set_component_parameter_value gui_frac_multiply_factor {1.0}
	set_component_parameter_value gui_fractional_cout {32}
	set_component_parameter_value gui_include_iossm {0}
	set_component_parameter_value gui_location_type {I/O Bank}
	set_component_parameter_value gui_lock_setting {Low Lock Time}
	set_component_parameter_value gui_mif_config_name {unnamed}
	set_component_parameter_value gui_mif_gen_options {Generate New MIF File}
	set_component_parameter_value gui_multiply_factor {6}
	set_component_parameter_value gui_new_mif_file_path {~/pll.mif}
	set_component_parameter_value gui_number_of_clocks {4}
	set_component_parameter_value gui_operation_mode {direct}
	set_component_parameter_value gui_output_clock_frequency0 {250.0}
	set_component_parameter_value gui_output_clock_frequency1 {125.0}
	set_component_parameter_value gui_output_clock_frequency10 {100.0}
	set_component_parameter_value gui_output_clock_frequency11 {100.0}
	set_component_parameter_value gui_output_clock_frequency12 {100.0}
	set_component_parameter_value gui_output_clock_frequency13 {100.0}
	set_component_parameter_value gui_output_clock_frequency14 {100.0}
	set_component_parameter_value gui_output_clock_frequency15 {100.0}
	set_component_parameter_value gui_output_clock_frequency16 {100.0}
	set_component_parameter_value gui_output_clock_frequency17 {100.0}
	set_component_parameter_value gui_output_clock_frequency2 {25.0}
	set_component_parameter_value gui_output_clock_frequency3 {2.5}
	set_component_parameter_value gui_output_clock_frequency4 {100.0}
	set_component_parameter_value gui_output_clock_frequency5 {100.0}
	set_component_parameter_value gui_output_clock_frequency6 {100.0}
	set_component_parameter_value gui_output_clock_frequency7 {100.0}
	set_component_parameter_value gui_output_clock_frequency8 {100.0}
	set_component_parameter_value gui_output_clock_frequency9 {100.0}
	set_component_parameter_value gui_output_clock_frequency_ps0 {4000.0}
	set_component_parameter_value gui_output_clock_frequency_ps1 {8000.0}
	set_component_parameter_value gui_output_clock_frequency_ps10 {10000.0}
	set_component_parameter_value gui_output_clock_frequency_ps11 {10000.0}
	set_component_parameter_value gui_output_clock_frequency_ps12 {10000.0}
	set_component_parameter_value gui_output_clock_frequency_ps13 {10000.0}
	set_component_parameter_value gui_output_clock_frequency_ps14 {10000.0}
	set_component_parameter_value gui_output_clock_frequency_ps15 {10000.0}
	set_component_parameter_value gui_output_clock_frequency_ps16 {10000.0}
	set_component_parameter_value gui_output_clock_frequency_ps17 {10000.0}
	set_component_parameter_value gui_output_clock_frequency_ps2 {40000.0}
	set_component_parameter_value gui_output_clock_frequency_ps3 {400000.0}
	set_component_parameter_value gui_output_clock_frequency_ps4 {10000.0}
	set_component_parameter_value gui_output_clock_frequency_ps5 {10000.0}
	set_component_parameter_value gui_output_clock_frequency_ps6 {10000.0}
	set_component_parameter_value gui_output_clock_frequency_ps7 {10000.0}
	set_component_parameter_value gui_output_clock_frequency_ps8 {10000.0}
	set_component_parameter_value gui_output_clock_frequency_ps9 {10000.0}
	set_component_parameter_value gui_parameter_table_hex_file {seq_params_sim.hex}
	set_component_parameter_value gui_phase_shift0 {0.0}
	set_component_parameter_value gui_phase_shift1 {0.0}
	set_component_parameter_value gui_phase_shift10 {0.0}
	set_component_parameter_value gui_phase_shift11 {0.0}
	set_component_parameter_value gui_phase_shift12 {0.0}
	set_component_parameter_value gui_phase_shift13 {0.0}
	set_component_parameter_value gui_phase_shift14 {0.0}
	set_component_parameter_value gui_phase_shift15 {0.0}
	set_component_parameter_value gui_phase_shift16 {0.0}
	set_component_parameter_value gui_phase_shift17 {0.0}
	set_component_parameter_value gui_phase_shift2 {0.0}
	set_component_parameter_value gui_phase_shift3 {0.0}
	set_component_parameter_value gui_phase_shift4 {0.0}
	set_component_parameter_value gui_phase_shift5 {0.0}
	set_component_parameter_value gui_phase_shift6 {0.0}
	set_component_parameter_value gui_phase_shift7 {0.0}
	set_component_parameter_value gui_phase_shift8 {0.0}
	set_component_parameter_value gui_phase_shift9 {0.0}
	set_component_parameter_value gui_phase_shift_deg0 {0.0}
	set_component_parameter_value gui_phase_shift_deg1 {0.0}
	set_component_parameter_value gui_phase_shift_deg10 {0.0}
	set_component_parameter_value gui_phase_shift_deg11 {0.0}
	set_component_parameter_value gui_phase_shift_deg12 {0.0}
	set_component_parameter_value gui_phase_shift_deg13 {0.0}
	set_component_parameter_value gui_phase_shift_deg14 {0.0}
	set_component_parameter_value gui_phase_shift_deg15 {0.0}
	set_component_parameter_value gui_phase_shift_deg16 {0.0}
	set_component_parameter_value gui_phase_shift_deg17 {0.0}
	set_component_parameter_value gui_phase_shift_deg2 {0.0}
	set_component_parameter_value gui_phase_shift_deg3 {0.0}
	set_component_parameter_value gui_phase_shift_deg4 {0.0}
	set_component_parameter_value gui_phase_shift_deg5 {0.0}
	set_component_parameter_value gui_phase_shift_deg6 {0.0}
	set_component_parameter_value gui_phase_shift_deg7 {0.0}
	set_component_parameter_value gui_phase_shift_deg8 {0.0}
	set_component_parameter_value gui_phase_shift_deg9 {0.0}
	set_component_parameter_value gui_phout_division {1}
	set_component_parameter_value gui_pll_auto_reset {0}
	set_component_parameter_value gui_pll_bandwidth_preset {Low}
	set_component_parameter_value gui_pll_cal_done {0}
	set_component_parameter_value gui_pll_cascading_mode {adjpllin}
	set_component_parameter_value gui_pll_freqcal_en {1}
	set_component_parameter_value gui_pll_freqcal_req_flag {1}
	set_component_parameter_value gui_pll_m_cnt_in_src {c_m_cnt_in_src_ph_mux_clk}
	set_component_parameter_value gui_pll_mode {Integer-N PLL}
	set_component_parameter_value gui_pll_tclk_mux_en {0}
	set_component_parameter_value gui_pll_tclk_sel {pll_tclk_m_src}
	set_component_parameter_value gui_pll_type {S10_Simple}
	set_component_parameter_value gui_pll_vco_freq_band_0 {pll_freq_clk0_band18}
	set_component_parameter_value gui_pll_vco_freq_band_1 {pll_freq_clk1_band18}
	set_component_parameter_value gui_prot_mode {UNUSED}
	set_component_parameter_value gui_ps_units0 {ps}
	set_component_parameter_value gui_ps_units1 {ps}
	set_component_parameter_value gui_ps_units10 {ps}
	set_component_parameter_value gui_ps_units11 {ps}
	set_component_parameter_value gui_ps_units12 {ps}
	set_component_parameter_value gui_ps_units13 {ps}
	set_component_parameter_value gui_ps_units14 {ps}
	set_component_parameter_value gui_ps_units15 {ps}
	set_component_parameter_value gui_ps_units16 {ps}
	set_component_parameter_value gui_ps_units17 {ps}
	set_component_parameter_value gui_ps_units2 {ps}
	set_component_parameter_value gui_ps_units3 {ps}
	set_component_parameter_value gui_ps_units4 {ps}
	set_component_parameter_value gui_ps_units5 {ps}
	set_component_parameter_value gui_ps_units6 {ps}
	set_component_parameter_value gui_ps_units7 {ps}
	set_component_parameter_value gui_ps_units8 {ps}
	set_component_parameter_value gui_ps_units9 {ps}
	set_component_parameter_value gui_refclk1_frequency {100.0}
	set_component_parameter_value gui_refclk_might_change {0}
	set_component_parameter_value gui_refclk_switch {0}
	set_component_parameter_value gui_reference_clock_frequency {100.0}
	set_component_parameter_value gui_reference_clock_frequency_ps {10000.0}
	set_component_parameter_value gui_simulation_type {0}
	set_component_parameter_value gui_skip_sdc_generation {0}
	set_component_parameter_value gui_switchover_delay {0}
	set_component_parameter_value gui_switchover_mode {Automatic Switchover}
	set_component_parameter_value gui_use_NDFB_modes {0}
	set_component_parameter_value gui_use_coreclk {0}
	set_component_parameter_value gui_use_locked {1}
	set_component_parameter_value gui_use_logical {0}
	set_component_parameter_value gui_user_base_address {0}
	set_component_parameter_value gui_usr_device_speed_grade {1}
	set_component_parameter_value gui_vco_frequency {600.0}
	set_component_parameter_value hp_qsys_scripting_mode {0}
	set_component_parameter_value system_info_device_iobank_rev {}
	set_component_project_property HIDE_FROM_IP_CATALOG {false}
	save_component
	load_instantiation iopll_0
	remove_instantiation_interfaces_and_ports
	set_instantiation_assignment_value embeddedsw.dts.compatible {altr,pll}
	set_instantiation_assignment_value embeddedsw.dts.group {clock}
	set_instantiation_assignment_value embeddedsw.dts.vendor {altr}
	add_instantiation_interface refclk clock INPUT
	set_instantiation_interface_parameter_value refclk clockRate {100000000}
	set_instantiation_interface_parameter_value refclk externallyDriven {false}
	set_instantiation_interface_parameter_value refclk ptfSchematicName {}
	set_instantiation_interface_assignment_value refclk ui.blockdiagram.direction {input}
	add_instantiation_interface_port refclk refclk clk 1 STD_LOGIC Input
	add_instantiation_interface locked conduit INPUT
	set_instantiation_interface_parameter_value locked associatedClock {}
	set_instantiation_interface_parameter_value locked associatedReset {}
	set_instantiation_interface_parameter_value locked prSafe {false}
	set_instantiation_interface_assignment_value locked ui.blockdiagram.direction {output}
	add_instantiation_interface_port locked locked export 1 STD_LOGIC Output
	add_instantiation_interface reset reset INPUT
	set_instantiation_interface_parameter_value reset associatedClock {}
	set_instantiation_interface_parameter_value reset synchronousEdges {NONE}
	set_instantiation_interface_assignment_value reset ui.blockdiagram.direction {input}
	add_instantiation_interface_port reset rst reset 1 STD_LOGIC Input
	add_instantiation_interface outclk0 clock OUTPUT
	set_instantiation_interface_parameter_value outclk0 associatedDirectClock {}
	set_instantiation_interface_parameter_value outclk0 clockRate {250000000}
	set_instantiation_interface_parameter_value outclk0 clockRateKnown {true}
	set_instantiation_interface_parameter_value outclk0 externallyDriven {false}
	set_instantiation_interface_parameter_value outclk0 ptfSchematicName {}
	set_instantiation_interface_assignment_value outclk0 ui.blockdiagram.direction {output}
	set_instantiation_interface_sysinfo_parameter_value outclk0 clock_rate {250000000}
	add_instantiation_interface_port outclk0 outclk_0 clk 1 STD_LOGIC Output
	add_instantiation_interface outclk1 clock OUTPUT
	set_instantiation_interface_parameter_value outclk1 associatedDirectClock {}
	set_instantiation_interface_parameter_value outclk1 clockRate {125000000}
	set_instantiation_interface_parameter_value outclk1 clockRateKnown {true}
	set_instantiation_interface_parameter_value outclk1 externallyDriven {false}
	set_instantiation_interface_parameter_value outclk1 ptfSchematicName {}
	set_instantiation_interface_assignment_value outclk1 ui.blockdiagram.direction {output}
	set_instantiation_interface_sysinfo_parameter_value outclk1 clock_rate {125000000}
	add_instantiation_interface_port outclk1 outclk_1 clk 1 STD_LOGIC Output
	add_instantiation_interface outclk2 clock OUTPUT
	set_instantiation_interface_parameter_value outclk2 associatedDirectClock {}
	set_instantiation_interface_parameter_value outclk2 clockRate {25000000}
	set_instantiation_interface_parameter_value outclk2 clockRateKnown {true}
	set_instantiation_interface_parameter_value outclk2 externallyDriven {false}
	set_instantiation_interface_parameter_value outclk2 ptfSchematicName {}
	set_instantiation_interface_assignment_value outclk2 ui.blockdiagram.direction {output}
	set_instantiation_interface_sysinfo_parameter_value outclk2 clock_rate {25000000}
	add_instantiation_interface_port outclk2 outclk_2 clk 1 STD_LOGIC Output
	add_instantiation_interface outclk3 clock OUTPUT
	set_instantiation_interface_parameter_value outclk3 associatedDirectClock {}
	set_instantiation_interface_parameter_value outclk3 clockRate {2500000}
	set_instantiation_interface_parameter_value outclk3 clockRateKnown {true}
	set_instantiation_interface_parameter_value outclk3 externallyDriven {false}
	set_instantiation_interface_parameter_value outclk3 ptfSchematicName {}
	set_instantiation_interface_assignment_value outclk3 ui.blockdiagram.direction {output}
	set_instantiation_interface_sysinfo_parameter_value outclk3 clock_rate {2500000}
	add_instantiation_interface_port outclk3 outclk_3 clk 1 STD_LOGIC Output
	save_instantiation
    
    
    
    
    add_component_param "altera_reset_bridge reset_in 
            IP_FILE_PATH ip/$subsys_name/reset_in.ip 
            SYNC_RESET 0
            NUM_RESET_OUTPUTS 1
            "
    
	# add_component reset_in ip/$subsys_name/reset_in.ip altera_reset_bridge reset_in 19.2.0
	# load_component reset_in
	# set_component_parameter_value ACTIVE_LOW_RESET {0}
	# set_component_parameter_value NUM_RESET_OUTPUTS {1}
	# set_component_parameter_value SYNCHRONOUS_EDGES {deassert}
	# set_component_parameter_value SYNC_RESET {0}
	# set_component_parameter_value USE_RESET_REQUEST {0}
	# set_component_project_property HIDE_FROM_IP_CATALOG {false}
	# save_component
	# load_instantiation reset_in
	# remove_instantiation_interfaces_and_ports
	# add_instantiation_interface clk clock INPUT
	# set_instantiation_interface_parameter_value clk clockRate {0}
	# set_instantiation_interface_parameter_value clk externallyDriven {false}
	# set_instantiation_interface_parameter_value clk ptfSchematicName {}
	# add_instantiation_interface_port clk clk clk 1 STD_LOGIC Input
	# add_instantiation_interface in_reset reset INPUT
	# set_instantiation_interface_parameter_value in_reset associatedClock {clk}
	# set_instantiation_interface_parameter_value in_reset synchronousEdges {DEASSERT}
	# add_instantiation_interface_port in_reset in_reset reset 1 STD_LOGIC Input
	# add_instantiation_interface out_reset reset OUTPUT
	# set_instantiation_interface_parameter_value out_reset associatedClock {clk}
	# set_instantiation_interface_parameter_value out_reset associatedDirectReset {in_reset}
	# set_instantiation_interface_parameter_value out_reset associatedResetSinks {in_reset}
	# set_instantiation_interface_parameter_value out_reset synchronousEdges {DEASSERT}
	# add_instantiation_interface_port out_reset out_reset reset 1 STD_LOGIC Output
	# save_instantiation

	# add wirelevel expressions

	# preserve ports for debug

	# add the connections
	# add_connection clock_in.out_clk/intel_agilex_5_soc_0.emac_ptp_clk
	# set_connection_parameter_value clock_in.out_clk/intel_agilex_5_soc_0.emac_ptp_clk clockDomainSysInfo {-1}
	# set_connection_parameter_value clock_in.out_clk/intel_agilex_5_soc_0.emac_ptp_clk clockRateSysInfo {100000000.0}
	# set_connection_parameter_value clock_in.out_clk/intel_agilex_5_soc_0.emac_ptp_clk clockResetSysInfo {}
	# set_connection_parameter_value clock_in.out_clk/intel_agilex_5_soc_0.emac_ptp_clk resetDomainSysInfo {-1}
	# add_connection clock_in.out_clk/intel_agilex_5_soc_0.emac_timestamp_clk
	# set_connection_parameter_value clock_in.out_clk/intel_agilex_5_soc_0.emac_timestamp_clk clockDomainSysInfo {-1}
	# set_connection_parameter_value clock_in.out_clk/intel_agilex_5_soc_0.emac_timestamp_clk clockRateSysInfo {100000000.0}
	# set_connection_parameter_value clock_in.out_clk/intel_agilex_5_soc_0.emac_timestamp_clk clockResetSysInfo {}
	# set_connection_parameter_value clock_in.out_clk/intel_agilex_5_soc_0.emac_timestamp_clk resetDomainSysInfo {-1}
    
    connect " clock_in.out_clk intel_gmii_to_rgmii_converter_0.peri_clock
              clock_in.out_clk iopll_0.refclk
              clock_in.out_clk reset_in.clk
              iopll_0.outclk0 intel_gmii_to_rgmii_converter_0.pll_250m_tx_clock
              iopll_0.outclk1 intel_gmii_to_rgmii_converter_0.pll_125m_tx_clock
              iopll_0.outclk2 intel_gmii_to_rgmii_converter_0.pll_25m_clock
              iopll_0.outclk3 intel_gmii_to_rgmii_converter_0.pll_2_5m_clock
              iopll_0.locked intel_gmii_to_rgmii_converter_0.locked_pll_250m_tx
              reset_in.out_reset intel_gmii_to_rgmii_converter_0.peri_reset
              reset_in.out_reset iopll_0.reset
            "
    
    
	# add_connection clock_in.out_clk/intel_gmii_to_rgmii_converter_0.peri_clock
	# set_connection_parameter_value clock_in.out_clk/intel_gmii_to_rgmii_converter_0.peri_clock clockDomainSysInfo {-1}
	# set_connection_parameter_value clock_in.out_clk/intel_gmii_to_rgmii_converter_0.peri_clock clockRateSysInfo {100000000.0}
	# set_connection_parameter_value clock_in.out_clk/intel_gmii_to_rgmii_converter_0.peri_clock clockResetSysInfo {}
	# set_connection_parameter_value clock_in.out_clk/intel_gmii_to_rgmii_converter_0.peri_clock resetDomainSysInfo {-1}
	# add_connection clock_in.out_clk/iopll_0.refclk
	# set_connection_parameter_value clock_in.out_clk/iopll_0.refclk clockDomainSysInfo {-1}
	# set_connection_parameter_value clock_in.out_clk/iopll_0.refclk clockRateSysInfo {100000000.0}
	# set_connection_parameter_value clock_in.out_clk/iopll_0.refclk clockResetSysInfo {}
	# set_connection_parameter_value clock_in.out_clk/iopll_0.refclk resetDomainSysInfo {-1}
	# add_connection clock_in.out_clk/reset_in.clk
	# set_connection_parameter_value clock_in.out_clk/reset_in.clk clockDomainSysInfo {-1}
	# set_connection_parameter_value clock_in.out_clk/reset_in.clk clockRateSysInfo {100000000.0}
	# set_connection_parameter_value clock_in.out_clk/reset_in.clk clockResetSysInfo {}
	# set_connection_parameter_value clock_in.out_clk/reset_in.clk resetDomainSysInfo {-1}
    
	# add_connection intel_agilex_5_soc_0.emac0_app_rst/intel_gmii_to_rgmii_converter_0.peri_reset
	# set_connection_parameter_value intel_agilex_5_soc_0.emac0_app_rst/intel_gmii_to_rgmii_converter_0.peri_reset clockDomainSysInfo {-1}
	# set_connection_parameter_value intel_agilex_5_soc_0.emac0_app_rst/intel_gmii_to_rgmii_converter_0.peri_reset clockResetSysInfo {}
	# set_connection_parameter_value intel_agilex_5_soc_0.emac0_app_rst/intel_gmii_to_rgmii_converter_0.peri_reset resetDomainSysInfo {-1}
	# add_connection intel_agilex_5_soc_0.emac0_app_rst/iopll_0.reset
	# set_connection_parameter_value intel_agilex_5_soc_0.emac0_app_rst/iopll_0.reset clockDomainSysInfo {-1}
	# set_connection_parameter_value intel_agilex_5_soc_0.emac0_app_rst/iopll_0.reset clockResetSysInfo {}
	# set_connection_parameter_value intel_agilex_5_soc_0.emac0_app_rst/iopll_0.reset resetDomainSysInfo {-1}
	# add_connection intel_gmii_to_rgmii_converter_0.hps_gmii/intel_agilex_5_soc_0.emac0
	# set_connection_parameter_value intel_gmii_to_rgmii_converter_0.hps_gmii/intel_agilex_5_soc_0.emac0 endPort {}
	# set_connection_parameter_value intel_gmii_to_rgmii_converter_0.hps_gmii/intel_agilex_5_soc_0.emac0 endPortLSB {0}
	# set_connection_parameter_value intel_gmii_to_rgmii_converter_0.hps_gmii/intel_agilex_5_soc_0.emac0 startPort {}
	# set_connection_parameter_value intel_gmii_to_rgmii_converter_0.hps_gmii/intel_agilex_5_soc_0.emac0 startPortLSB {0}
	# set_connection_parameter_value intel_gmii_to_rgmii_converter_0.hps_gmii/intel_agilex_5_soc_0.emac0 width {0}
	# add_connection iopll_0.locked/intel_gmii_to_rgmii_converter_0.locked_pll_250m_tx
	# set_connection_parameter_value iopll_0.locked/intel_gmii_to_rgmii_converter_0.locked_pll_250m_tx endPort {}
	# set_connection_parameter_value iopll_0.locked/intel_gmii_to_rgmii_converter_0.locked_pll_250m_tx endPortLSB {0}
	# set_connection_parameter_value iopll_0.locked/intel_gmii_to_rgmii_converter_0.locked_pll_250m_tx startPort {}
	# set_connection_parameter_value iopll_0.locked/intel_gmii_to_rgmii_converter_0.locked_pll_250m_tx startPortLSB {0}
	# set_connection_parameter_value iopll_0.locked/intel_gmii_to_rgmii_converter_0.locked_pll_250m_tx width {0}
	# add_connection iopll_0.outclk0/intel_gmii_to_rgmii_converter_0.pll_250m_tx_clock
	# set_connection_parameter_value iopll_0.outclk0/intel_gmii_to_rgmii_converter_0.pll_250m_tx_clock clockDomainSysInfo {-1}
	# set_connection_parameter_value iopll_0.outclk0/intel_gmii_to_rgmii_converter_0.pll_250m_tx_clock clockRateSysInfo {250000000.0}
	# set_connection_parameter_value iopll_0.outclk0/intel_gmii_to_rgmii_converter_0.pll_250m_tx_clock clockResetSysInfo {}
	# set_connection_parameter_value iopll_0.outclk0/intel_gmii_to_rgmii_converter_0.pll_250m_tx_clock resetDomainSysInfo {-1}
	# add_connection iopll_0.outclk1/intel_gmii_to_rgmii_converter_0.pll_125m_tx_clock
	# set_connection_parameter_value iopll_0.outclk1/intel_gmii_to_rgmii_converter_0.pll_125m_tx_clock clockDomainSysInfo {-1}
	# set_connection_parameter_value iopll_0.outclk1/intel_gmii_to_rgmii_converter_0.pll_125m_tx_clock clockRateSysInfo {125000000.0}
	# set_connection_parameter_value iopll_0.outclk1/intel_gmii_to_rgmii_converter_0.pll_125m_tx_clock clockResetSysInfo {}
	# set_connection_parameter_value iopll_0.outclk1/intel_gmii_to_rgmii_converter_0.pll_125m_tx_clock resetDomainSysInfo {-1}
	# add_connection iopll_0.outclk2/intel_gmii_to_rgmii_converter_0.pll_25m_clock
	# set_connection_parameter_value iopll_0.outclk2/intel_gmii_to_rgmii_converter_0.pll_25m_clock clockDomainSysInfo {-1}
	# set_connection_parameter_value iopll_0.outclk2/intel_gmii_to_rgmii_converter_0.pll_25m_clock clockRateSysInfo {25000000.0}
	# set_connection_parameter_value iopll_0.outclk2/intel_gmii_to_rgmii_converter_0.pll_25m_clock clockResetSysInfo {}
	# set_connection_parameter_value iopll_0.outclk2/intel_gmii_to_rgmii_converter_0.pll_25m_clock resetDomainSysInfo {-1}
	# add_connection iopll_0.outclk3/intel_gmii_to_rgmii_converter_0.pll_2_5m_clock
	# set_connection_parameter_value iopll_0.outclk3/intel_gmii_to_rgmii_converter_0.pll_2_5m_clock clockDomainSysInfo {-1}
	# set_connection_parameter_value iopll_0.outclk3/intel_gmii_to_rgmii_converter_0.pll_2_5m_clock clockRateSysInfo {2500000.0}
	# set_connection_parameter_value iopll_0.outclk3/intel_gmii_to_rgmii_converter_0.pll_2_5m_clock clockResetSysInfo {}
	# set_connection_parameter_value iopll_0.outclk3/intel_gmii_to_rgmii_converter_0.pll_2_5m_clock resetDomainSysInfo {-1}
	# add_connection reset_in.out_reset/intel_gmii_to_rgmii_converter_0.peri_reset
	# set_connection_parameter_value reset_in.out_reset/intel_gmii_to_rgmii_converter_0.peri_reset clockDomainSysInfo {-1}
	# set_connection_parameter_value reset_in.out_reset/intel_gmii_to_rgmii_converter_0.peri_reset clockResetSysInfo {}
	# set_connection_parameter_value reset_in.out_reset/intel_gmii_to_rgmii_converter_0.peri_reset resetDomainSysInfo {-1}
	# add_connection reset_in.out_reset/iopll_0.reset
	# set_connection_parameter_value reset_in.out_reset/iopll_0.reset clockDomainSysInfo {-1}
	# set_connection_parameter_value reset_in.out_reset/iopll_0.reset clockResetSysInfo {}
	# set_connection_parameter_value reset_in.out_reset/iopll_0.reset resetDomainSysInfo {-1}

	# add the exports
    
    export clock_in in_clk clk
    export reset_in in_reset reset
    export intel_gmii_to_rgmii_converter_0 phy_rgmii phy_rgmii
    export intel_gmii_to_rgmii_converter_0 hps_gmii hps_gmii
    
    
	# set_interface_property clk EXPORT_OF clock_in.in_clk
	# set_interface_property reset EXPORT_OF reset_in.in_reset
	# set_interface_property phy_rgmii EXPORT_OF intel_gmii_to_rgmii_converter_0.phy_rgmii
	# set_interface_property hps_gmii EXPORT_OF intel_gmii_to_rgmii_converter_0.hps_gmii


	# set values for exposed HDL parameters

	# set the the module properties
	# set_module_property BONUS_DATA {<?xml version="1.0" encoding="UTF-8"?>
# <bonusData>
 # <element __value="clock_in">
  # <datum __value="_sortIndex" value="0" type="int" />
 # </element>
 # <element __value="intel_agilex_5_soc_0">
  # <datum __value="_sortIndex" value="4" type="int" />
 # </element>
 # <element __value="intel_gmii_to_rgmii_converter_0">
  # <datum __value="_sortIndex" value="3" type="int" />
 # </element>
 # <element __value="iopll_0">
  # <datum __value="_sortIndex" value="2" type="int" />
 # </element>
 # <element __value="reset_in">
  # <datum __value="_sortIndex" value="1" type="int" />
 # </element>
# </bonusData>

	# set_module_property FILE {$subsys_name.qsys}
	# set_module_property GENERATION_ID {0x00000000}
	# set_module_property NAME {$subsys_name}

	# save the system
	sync_sysinfo_parameters
	save_system ${subsys_name}.qsys
#}

#proc do_set_exported_interface_sysi#nfo_parameters {} {
#}

# create all the systems, from bottom up
#do_create_bbb 
# set system info parameters on exported interface, from bottom up
#do_set_exported_interface_sysinfo_parameters
