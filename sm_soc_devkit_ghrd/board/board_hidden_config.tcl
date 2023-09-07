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
set isPCIE_pins_available 1
set isETILE_pins_available 1

## Set IO Widths
set fpga_led_pio_width 4
set fpga_dipsw_pio_width 4
set fpga_button_pio_width 4

#devkit uses the DDR4 HiLo based on x16 components. By JEDEC spec, DDR4 x16 components doesn't requires emif_hps_mem_mem_bg[1]
set hps_emif_bank_gp_default_width 1

# Quartus settings for miscellaneous
#proc config_misc {} {
    #set_global_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON
#    set_instance_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON -to AK1
#    set_instance_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON -to AL4
#    set_instance_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON -to AP1
#    set_instance_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON -to AR4
#    set_instance_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON -to AV1
#    set_instance_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON -to AW4
#    set_instance_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON -to BB1
#    set_instance_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON -to BC4
#    set_instance_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON -to BG4
#    set_instance_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON -to BK1
#    set_instance_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON -to BL4
#    set_instance_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON -to BP1
#    set_instance_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON -to BR4
#    set_instance_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON -to BV1
#    set_instance_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON -to BW4
#}

# Quartus settings for SDMIOs
proc config_sdmio {} {
    set_global_assignment -name USE_HPS_COLD_RESET SDM_IO11
    set_global_assignment -name USE_CONF_DONE SDM_IO16
}

# Quartus settings for Power Management
proc config_pwrmgt {} {
    global board_pwrmgt
    if {$board_pwrmgt == "linear"} {
        # Linear tech
        set_global_assignment -name INI_VARS "ASM_ENABLE_ADVANCED_DEVICES=ON;"
        set_global_assignment -name VID_OPERATION_MODE "PMBUS MASTER"
        set_global_assignment -name USE_PWRMGT_SCL SDM_IO0
        set_global_assignment -name USE_PWRMGT_SDA SDM_IO12
        set_global_assignment -name PWRMGT_BUS_SPEED_MODE "400 KHZ"
        set_global_assignment -name PWRMGT_PAGE_COMMAND_ENABLE ON
        set_global_assignment -name PWRMGT_SLAVE_DEVICE_TYPE OTHER
        set_global_assignment -name PWRMGT_SLAVE_DEVICE0_ADDRESS 42
        set_global_assignment -name PWRMGT_SLAVE_DEVICE1_ADDRESS 43
        set_global_assignment -name PWRMGT_SLAVE_DEVICE2_ADDRESS 44
        set_global_assignment -name PWRMGT_SLAVE_DEVICE3_ADDRESS 00
        set_global_assignment -name PWRMGT_SLAVE_DEVICE4_ADDRESS 00
        set_global_assignment -name PWRMGT_SLAVE_DEVICE5_ADDRESS 00
        set_global_assignment -name PWRMGT_SLAVE_DEVICE6_ADDRESS 00
        set_global_assignment -name PWRMGT_SLAVE_DEVICE7_ADDRESS 00
        set_global_assignment -name PWRMGT_PAGE_COMMAND_ENABLE ON
        set_global_assignment -name PWRMGT_VOLTAGE_OUTPUT_FORMAT "LINEAR FORMAT"
        set_global_assignment -name PWRMGT_LINEAR_FORMAT_N "-12"
        set_global_assignment -name PWRMGT_TRANSLATED_VOLTAGE_VALUE_UNIT VOLTS
    } else {
        # Enpirion
        set_global_assignment -name INI_VARS "ASM_ENABLE_ADVANCED_DEVICES=ON;"
        set_global_assignment -name VID_OPERATION_MODE "PMBUS MASTER"
        set_global_assignment -name USE_PWRMGT_SCL SDM_IO0
        set_global_assignment -name USE_PWRMGT_SDA SDM_IO12
        set_global_assignment -name PWRMGT_BUS_SPEED_MODE "100 KHZ"
        set_global_assignment -name PWRMGT_PAGE_COMMAND_ENABLE ON
        set_global_assignment -name PWRMGT_SLAVE_DEVICE_TYPE ED8401
        set_global_assignment -name PWRMGT_SLAVE_DEVICE0_ADDRESS 42
        set_global_assignment -name PWRMGT_SLAVE_DEVICE1_ADDRESS 00
        set_global_assignment -name PWRMGT_SLAVE_DEVICE2_ADDRESS 00
        set_global_assignment -name PWRMGT_SLAVE_DEVICE3_ADDRESS 00
        set_global_assignment -name PWRMGT_SLAVE_DEVICE4_ADDRESS 00
        set_global_assignment -name PWRMGT_SLAVE_DEVICE5_ADDRESS 00
        set_global_assignment -name PWRMGT_SLAVE_DEVICE6_ADDRESS 00
        set_global_assignment -name PWRMGT_SLAVE_DEVICE7_ADDRESS 00
        set_global_assignment -name PWRMGT_PAGE_COMMAND_ENABLE OFF
        set_global_assignment -name PWRMGT_VOLTAGE_OUTPUT_FORMAT "LINEAR FORMAT"
        set_global_assignment -name PWRMGT_LINEAR_FORMAT_N "-13"
        set_global_assignment -name PWRMGT_TRANSLATED_VOLTAGE_VALUE_UNIT VOLTS
    }
}
