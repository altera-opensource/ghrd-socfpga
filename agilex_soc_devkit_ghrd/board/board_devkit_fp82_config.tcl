#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2022 Intel Corporation.
#
#****************************************************************************
#
# This script hosts board requirements and Quartus settings for the Agilex SoC Devkit board.
#
#****************************************************************************

## Indicate the Pins Availablility for boards
#  Set available if there is
#  Peripheral pins (LEDs, DIPSW, Push Button)
set isPeriph_pins_available 1
set isSgpio_pins_available  1
set isPCIE_pins_available 1
set isETILE_pins_available 1

## Set IO Widths
set fpga_led_pio_width 4
set fpga_dipsw_pio_width 0
set fpga_button_pio_width 0

#devkit uses the DDR4 HiLo based on x16 components. By JEDEC spec, DDR4 x16 components doesn't requires emif_hps_mem_mem_bg[1]
set hps_emif_bank_gp_default_width 1

# Quartus settings for SDMIOs
proc config_sdmio {} {
source ./arguments_solver.tcl
if {$config_scheme != "AVST X8"} {
    set_global_assignment -name USE_HPS_COLD_RESET SDM_IO12
    set_global_assignment -name USE_CONF_DONE SDM_IO11
} else {
	set_global_assignment -name USE_HPS_COLD_RESET SDM_IO9
    set_global_assignment -name USE_CONF_DONE SDM_IO5
}
}

# Quartus settings for Power Management
proc config_pwrmgt {} {
    global board_pwrmgt
    if {$board_pwrmgt == "linear"} {
        # Linear tech
        set_global_assignment -name INI_VARS "ASM_ENABLE_ADVANCED_DEVICES=ON;"
        set_global_assignment -name VID_OPERATION_MODE "PMBUS MASTER"
        set_global_assignment -name USE_PWRMGT_SCL SDM_IO0
        set_global_assignment -name USE_PWRMGT_SDA SDM_IO16
		set_global_assignment -name PWRMGT_BUS_SPEED_MODE "400 KHZ"
        set_global_assignment -name PWRMGT_SLAVE_DEVICE_TYPE LTC3888
		set_global_assignment -name NUMBER_OF_SLAVE_DEVICE 1
        set_global_assignment -name PWRMGT_SLAVE_DEVICE0_ADDRESS 55
        set_global_assignment -name PWRMGT_VOLTAGE_OUTPUT_FORMAT "LINEAR FORMAT"
        set_global_assignment -name PWRMGT_LINEAR_FORMAT_N "-12"
        set_global_assignment -name PWRMGT_TRANSLATED_VOLTAGE_VALUE_UNIT VOLTS
		set_global_assignment -name PWRMGT_PAGE_COMMAND_ENABLE ON
		set_global_assignment -name PWRMGT_PAGE_COMMAND_PAYLOAD 0

    } 
}
