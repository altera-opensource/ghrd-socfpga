#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2018-2020 Intel Corporation.
#
#****************************************************************************
#
# Sample SDC for custom_reset_synchronizer
# 
#****************************************************************************

#these constraints cut the asynchronous clear path into both pipelines inside the synchronizer block
#set_false_path -to [get_pins -compatibility_mode -nocase -nowarn *|reset_sync_block|synchronizer_reg*|aclr]
#set_false_path -to [get_pins -compatibility_mode -nocase -nowarn *|reset_sync_block|output_pipeline_reg*|aclr]

#these constraints cut the synchronous clear path into both pipelines inside the synchronizer block
#set_false_path -to [get_pins -compatibility_mode -nocase -nowarn *|reset_sync_block|synchronizer_reg*|sclr]
#set_false_path -to [get_pins -compatibility_mode -nocase -nowarn *|reset_sync_block|output_pipeline_reg*|sclr]

#Since the synchronizer will resync the reset input we are cutting the input reset into the resync register.
set_false_path -to [get_pins -compatibility_mode -nocase -nowarn *|reset_sync_block*|synchronizer_reg*]
