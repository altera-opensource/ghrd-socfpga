#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2018-2020 Intel Corporation.
#
#****************************************************************************
# 
# avmm_feedthough_bridge "simple AVMM Feedthough Bridge" v1.0
#
#****************************************************************************

package require -exact qsys 18.0


# 
# module avmm_feedthough_bridge
# 
set_module_property DESCRIPTION "Simple AVMM Feed Through Bridge"
set_module_property NAME avmm_feedthough_bridge
set_module_property VERSION 1.0.0
set_module_property GROUP "Example Designs/Misc"
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR "Intel Corporation"
set_module_property DISPLAY_NAME "AVMM Feed Through Bridge"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false
set_module_property ELABORATION_CALLBACK  elaboration


# 
# file sets
#
add_fileset             synthesis_fileset       QUARTUS_SYNTH       proc_add_source_file 
set_fileset_property    synthesis_fileset       TOP_LEVEL           avmm_feedthough_bridge

add_fileset             sim_verilog_fileset     SIM_VERILOG         proc_add_source_file
set_fileset_property    sim_verilog_fileset     TOP_LEVEL           avmm_feedthough_bridge 

add_fileset             sim_vhdl_fileset        SIM_VHDL            proc_add_source_file
set_fileset_property    sim_vhdl_fileset        TOP_LEVEL           avmm_feedthough_bridge 

proc proc_add_source_file { entity_name } {
add_fileset_file        avmm_feedthough_bridge.v                   VERILOG        PATH     "avmm_feedthough_bridge.v"
}

# 
# parameters
# 

add_parameter ADDRESS_WIDTH INTEGER 32
set_parameter_property ADDRESS_WIDTH AFFECTS_ELABORATION true
set_parameter_property ADDRESS_WIDTH DESCRIPTION {Width of the address signal}
set_parameter_property ADDRESS_WIDTH DISPLAY_NAME {Avalon-MM  Address Width}
set_parameter_property ADDRESS_WIDTH HDL_PARAMETER true
set_parameter_property ADDRESS_WIDTH ALLOWED_RANGES "1:64"

add_parameter DATA_WIDTH INTEGER 32
set_parameter_property DATA_WIDTH AFFECTS_ELABORATION true
set_parameter_property DATA_WIDTH DESCRIPTION {Width of the data signal}
set_parameter_property DATA_WIDTH DISPLAY_NAME {Avalon-MM  Data Width}
set_parameter_property DATA_WIDTH HDL_PARAMETER true
set_parameter_property DATA_WIDTH ALLOWED_RANGES "1:32000"

# add_parameter USE_READDATAVALID INTEGER 0
# set_parameter_property USE_READDATAVALID AFFECTS_ELABORATION true
# set_parameter_property USE_READDATAVALID DESCRIPTION {Enable the readdatavalid signal}
# set_parameter_property USE_READDATAVALID DISPLAY_NAME {Use readdatavalid}
# set_parameter_property USE_READDATAVALID ALLOWED_RANGES {"1" "0"}
# set_parameter_property USE_READDATAVALID HDL_PARAMETER false

add_parameter USE_WAITREQUEST INTEGER 0
set_parameter_property USE_WAITREQUEST AFFECTS_ELABORATION true
set_parameter_property USE_WAITREQUEST DESCRIPTION {Enable the waitrequest signal}
set_parameter_property USE_WAITREQUEST DISPLAY_NAME {Use waitrequest}
set_parameter_property USE_WAITREQUEST ALLOWED_RANGES {"1" "0"}
set_parameter_property USE_WAITREQUEST HDL_PARAMETER false

add_parameter READLATENCY INTEGER 0
set_parameter_property READLATENCY AFFECTS_ELABORATION true
set_parameter_property READLATENCY ALLOWED_RANGES "0:32000"
set_parameter_property READLATENCY DESCRIPTION {Avalon-MM readLatency interface property}
set_parameter_property READLATENCY DISPLAY_NAME {readLatency}
set_parameter_property READLATENCY HDL_PARAMETER false

add_parameter WRITE_WAIT INTEGER 0
set_parameter_property WRITE_WAIT AFFECTS_ELABORATION true
set_parameter_property WRITE_WAIT HDL_PARAMETER false
set_parameter_property WRITE_WAIT ALLOWED_RANGES "0:32000"

add_parameter READ_WAIT INTEGER 1
set_parameter_property READ_WAIT AFFECTS_ELABORATION true
set_parameter_property READ_WAIT HDL_PARAMETER false
set_parameter_property READ_WAIT ALLOWED_RANGES "0:32000"

# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""
set_interface_property clock IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port clock clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""
set_interface_property reset IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port reset reset reset Input 1



# 
# display items
# 

# ------------------------------------------------------------------------------
# Elaboration Callback
# ------------------------------------------------------------------------------
proc elaboration {} {

   # 
   # connection point s0
   # 
   add_interface s0 avalon end
   set_interface_property s0 addressUnits WORDS
   set_interface_property s0 associatedClock clock
   set_interface_property s0 associatedReset reset
   set_interface_property s0 bitsPerSymbol 8
   set_interface_property s0 bridgedAddressOffset ""
   set_interface_property s0 bridgesToMaster "m0"
   set_interface_property s0 burstOnBurstBoundariesOnly false
   set_interface_property s0 burstcountUnits WORDS
   set_interface_property s0 explicitAddressSpan 0
#   set_interface_property s0 holdTime 0
   set_interface_property s0 linewrapBursts false
   set_interface_property s0 maximumPendingReadTransactions 0
   set_interface_property s0 maximumPendingWriteTransactions 0
   set_interface_property s0 minimumResponseLatency 1
   set_interface_property s0 readLatency [get_parameter_value READLATENCY]
   set_interface_property s0 readWaitTime [get_parameter_value READ_WAIT]
#   set_interface_property s0 setupTime 0
   set_interface_property s0 timingUnits Cycles
   set_interface_property s0 waitrequestAllowance 0
   set_interface_property s0 writeWaitTime [get_parameter_value WRITE_WAIT]
   set_interface_property s0 ENABLED true
   
   add_interface_port s0 s0_addr address Input [get_parameter_value ADDRESS_WIDTH]
   add_interface_port s0 s0_read read Input 1
   add_interface_port s0 s0_write write Input 1
   add_interface_port s0 s0_writedata writedata Input [get_parameter_value DATA_WIDTH]
   add_interface_port s0 s0_readdata readdata Output [get_parameter_value DATA_WIDTH]
   add_interface_port s0 s0_waitrequest waitrequest Output 1
#    if { [get_parameter_value USE_READDATAVALID]} {
# #      set_port_property s0_readdatavalid termination true
#       add_interface_port s0 s0_readdatavalid readdatavalid Output 1
#    }
   if { [get_parameter_value USE_WAITREQUEST] == 0} {
      set_port_property s0_waitrequest termination true
   }

   # 
   # connection point m0
   # 
   add_interface m0 avalon start
   set_interface_property m0 addressUnits WORDS
   set_interface_property m0 associatedClock clock
   set_interface_property m0 associatedReset reset
   set_interface_property m0 bitsPerSymbol 8
   set_interface_property m0 burstOnBurstBoundariesOnly false
   set_interface_property m0 burstcountUnits WORDS
   set_interface_property m0 maximumPendingReadTransactions 0
   set_interface_property m0 maximumPendingWriteTransactions 0
   set_interface_property m0 minimumResponseLatency 1
   set_interface_property m0 readLatency [get_parameter_value READLATENCY]
   set_interface_property m0 readWaitTime [get_parameter_value READ_WAIT]
   set_interface_property m0 timingUnits Cycles
   set_interface_property m0 waitrequestAllowance 0
   set_interface_property m0 writeWaitTime [get_parameter_value WRITE_WAIT]
   set_interface_property m0 ENABLED true
   
   add_interface_port m0 m0_addr address Output [get_parameter_value ADDRESS_WIDTH]
   add_interface_port m0 m0_read read Output 1
   add_interface_port m0 m0_write write Output 1
   add_interface_port m0 m0_writedata writedata Output [get_parameter_value DATA_WIDTH]
   add_interface_port m0 m0_readdata readdata Input [get_parameter_value DATA_WIDTH]
   add_interface_port m0 m0_waitrequest waitrequest Input 1
#   if { [get_parameter_value USE_READDATAVALID] == 0} {
#      #set_port_property m0_readdatavalid termination true
#      #set_port_property m0_readdatavalid termination_value 0
#      add_interface_port m0 m0_readdatavalid readdatavalid Input 1
#   }
   if { [get_parameter_value USE_WAITREQUEST] == 0} {
      set_port_property m0_waitrequest termination true
      set_port_property m0_waitrequest termination_value 0
   }
    
}





