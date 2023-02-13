# TCL File Generated by Component Editor 21.4
# Wed Apr 13 16:46:20 IST 2022
# DO NOT MODIFY


# 
# etile_tod "Etile tod subsystem conduits" v1.0.0
# Intel Corporation 2022.04.13.16:46:20
# 
# 

# 
# request TCL package from ACDS 21.4
# 
package require -exact qsys 21.4


#
# module eth_tod_distributor
#
set_module_property DESCRIPTION ""
set_module_property NAME eth_tod_distributor
set_module_property VERSION 1.0.1
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP "Example Designs/Ethernet/Misc"
set_module_property AUTHOR "Intel Corporation"
set_module_property DISPLAY_NAME "Etile tod subsystem conduits"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK true
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false
set_module_property LOAD_ELABORATION_LIMIT 0
set_module_property ELABORATION_CALLBACK elaborate

#
# file sets
#
add_fileset synthesis_fileset QUARTUS_SYNTH "" ""
set_fileset_property synthesis_fileset TOP_LEVEL eth_tod_distributor
set_fileset_property synthesis_fileset ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property synthesis_fileset ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file eth_tod_distributor.v VERILOG PATH eth_tod_distributor.v TOP_LEVEL_FILE

add_fileset sim_verilog_fileset SIM_VERILOG "" ""
set_fileset_property sim_verilog_fileset TOP_LEVEL eth_tod_distributor
set_fileset_property sim_verilog_fileset ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property sim_verilog_fileset ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file eth_tod_distributor.v VERILOG PATH eth_tod_distributor.v TOP_LEVEL_FILE

add_fileset sim_vhdl_fileset SIM_VHDL "" ""
set_fileset_property sim_vhdl_fileset TOP_LEVEL eth_tod_distributor
set_fileset_property sim_vhdl_fileset ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property sim_vhdl_fileset ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file eth_tod_distributor.v VERILOG PATH eth_tod_distributor.v TOP_LEVEL_FILE

#
# parameters
#

add_parameter OUTPUT_PORT_SIZE INTEGER 4
set_parameter_property OUTPUT_PORT_SIZE AFFECTS_ELABORATION true
set_parameter_property OUTPUT_PORT_SIZE DESCRIPTION {Number of output ports}
set_parameter_property OUTPUT_PORT_SIZE DISPLAY_NAME {Number of output ports}
set_parameter_property OUTPUT_PORT_SIZE HDL_PARAMETER true
set_parameter_property OUTPUT_PORT_SIZE ALLOWED_RANGES "2:16"


#
# connection point tod_in
#
add_interface tod_in conduit end
set_interface_property tod_in associatedClock ""
set_interface_property tod_in associatedReset ""
set_interface_property tod_in ENABLED true
set_interface_property tod_in EXPORT_OF ""
set_interface_property tod_in PORT_NAME_MAP ""
set_interface_property tod_in CMSIS_SVD_VARIABLES ""
set_interface_property tod_in SVD_ADDRESS_GROUP ""
set_interface_property tod_in IPXACT_REGISTER_MAP_VARIABLES ""

add_interface_port tod_in tod_in data Input 96



proc elaborate {} {
    set OUTPUT_PORT_SIZE  [get_parameter_value OUTPUT_PORT_SIZE]
	for {set i 0} {$i<$OUTPUT_PORT_SIZE} {incr i} {

    #
    # connection point tod_out1
    #
    add_interface tod_out$i conduit end
    set_interface_property tod_out$i associatedClock ""
    set_interface_property tod_out$i associatedReset ""
    set_interface_property tod_out$i ENABLED true
    set_interface_property tod_out$i EXPORT_OF ""
    set_interface_property tod_out$i PORT_NAME_MAP ""
    set_interface_property tod_out$i CMSIS_SVD_VARIABLES ""
    set_interface_property tod_out$i SVD_ADDRESS_GROUP ""
    set_interface_property tod_out$i IPXACT_REGISTER_MAP_VARIABLES ""

    #add_interface_port tod_out$i tod_out\[$i\] data Output 96
    add_interface_port tod_out$i tod_out$i data Output 96
   }
}

