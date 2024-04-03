#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2020 Intel Corporation.
#
#****************************************************************************
#
#use this tcl script to perform a reset assertion & deassertion to the whole design system for AGILEX GHRD
#the reset assertion and deassertion here are done via ISSP(In System Source & Probe) after device is programmed successfully
#
#****************************************************************************

set issp [lindex [get_service_paths issp] 0]
set issp_m [claim_service issp $issp claimGroup]

set current_source_data [issp_read_source_data $issp_m]
puts "src_reset_n value: $current_source_data"
#assert reset
puts "assert src_reset_n via issp"
set source_data 0x0
issp_write_source_data $issp_m $source_data
set current_source_data [issp_read_source_data $issp_m]
puts "src_reset_n value: $current_source_data"
after 500
puts "deassert src_reset_n via issp"
#deassert reset
set source_data 0x1
issp_write_source_data $issp_m $source_data
set current_source_data [issp_read_source_data $issp_m]
puts "src_reset_n value: $current_source_data"

close_service issp $issp_m
puts "\nInfo: Closed ISSP Service\n\n"