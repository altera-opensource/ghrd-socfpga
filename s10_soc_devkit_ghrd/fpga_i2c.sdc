#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2021-2021 Intel Corporation.
#
#****************************************************************************
#
# Sample SDC for S10 GHRD. Targeting FPGA I2C.
#
#****************************************************************************

set_false_path -to [get_ports {fpga_i2c_scl fpga_i2c_sda}]
set_false_path -from [get_ports {fpga_i2c_scl fpga_i2c_sda}]