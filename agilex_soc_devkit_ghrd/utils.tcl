#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2017-2020 Intel Corporation.
#
#****************************************************************************
#
# This file contail TCL procedures as ultilities for Lego based GHRD creation
# Kindly source this file for Lego blocks creation

# --- Procedure to add component together with parameterization --- #
# <arg> means to have <component name> <given instance name>, <ip file path label> <ip file path>, followed by <parameter> <value> pairs
#
#****************************************************************************

proc add_component_param {args} {
    set lpos 0
    set length [llength $args]
    # puts "Length of argument: $length"
    # puts "LIST become $args"

    #array set arg $args
    #set argss [array get arg]
    #puts "... $argss"
#regsub -all "({) (})" $args "" stripped
#puts "stripped LIST become $stripped"

set splitted [split $args { }]    
set length [llength [list $splitted]]
# puts "Length of splitted argument: $length"

if {[llength $args] == 1} {set arguments [lindex $args 0]}
# puts "stripped LIST become $arguments"
# set length [llength $arguments]
# puts "Length of stripped: $length"

# Retrieve the first arg as component name
set component_type [lindex $arguments 0]
set arguments [lreplace $arguments 0 0]
# puts "1st arguments become $arguments"
# puts "Component Type: $component_type"

# Retrieve the 2nd arg as instance name
set instance_name [lindex $arguments 0]
set arguments [lreplace $arguments 0 0]
# puts "2nd arguments become $arguments"
# puts "Instance Name: $instance_name"

# Retrieve the 4th arg as ip file path, 3rd arg as it is just label
set ip_file_path [lindex $arguments 1]
for {set i 0} {$i < 2} {incr i} {
set arguments [lreplace $arguments 0 0]
}
# puts "4th arguments become $arguments"
# puts "IP File Path: $ip_file_path"

# Add component instance into design
add_component $instance_name $ip_file_path $component_type
# add_component ILC ip/ghrd_10as066n2/ghrd_10as066n2_ILC.ip interrupt_latency_counter ILC
# add_component clk_100 ip/$qsys_name/clk_100.ip altera_clock_bridge clk_100_inst

# Load component instance into design for parameterization setup
load_component $instance_name

# puts "Final arguments become $arguments"

# puts "3rd arguments become $arguments"
# Check if parameter->value pairs matched
set parameter ""
set value ""
if {[llength $arguments]%2 == 0} {
    foreach item $arguments {
        if {$lpos %2 == 0} {
            set parameter $item
            puts "Param:\[$item\]"
        } else {
            set value $item
            puts "Value:\[$item\]"
        }
        if {$lpos %2 == 1} {set_component_parameter_value $parameter $value}
        incr lpos
    }
    #Save component instance after parameterization
    save_component
    return 0
  } else {
  puts "\[Component: $component_type\]Inserted parameter->value pair has ODD arguments, please verify correntness."
  }
}

# --- Procedure to modify only component instance parameters --- #
# Component instance must be already instantiated into qsys system before this procedure is called 
# <arg> means to have <given instance name> followed by <parameter> <value> pairs
proc set_component_param {args} {
    set lpos 0
    set length [llength $args]
    puts "Length of argument: $length"
    # puts "LIST become $args"

    # Retrieve fresh argument from sourcing TCL to get all elements
    if {[llength $args] == 1} {set arguments [lindex $args 0]}

    # puts "stripped LIST become $arguments"
    set length [llength $arguments]
    # puts "Length of stripped: $length"

    # Retrieve the 1st arg as instance name
    set instance_name [lindex $arguments 0]
    set arguments [lreplace $arguments 0 0]
    puts "Instance Name: $instance_name"

    # Load component instance into design for parameterization setup
    load_component $instance_name
    
    # Check if parameter->value pairs matched
    set parameter ""
    set value ""
    if {[llength $arguments]%2 == 0} {
        foreach item $arguments {
            if {$lpos %2 == 0} {
                set parameter $item
                puts "Param:\[$item\]"
            } else {
                set value $item
                puts "Value:\[$item\]"
            }
        if {$lpos %2 == 1} {set_component_parameter_value $parameter $value}
        incr lpos
        }
    #Save component instance after parameterization
    save_component
    return 0
    } else {
        puts "\[Instance: $instance_name\]Inserted parameter->value pair has ODD arguments, please verify correntness."
    }
}

# --- Procedure to add instance together with parameterization --- #
# <arg> means to have <component name> <given instance name> followed by <parameter> <value> pairs
proc add_instance_param {args} {
    set lpos 0
    set length [llength $args]
    # puts "Length of argument: $length"
    # puts "LIST become $args"

    #array set arg $args
    #set argss [array get arg]
    #puts "... $argss"
#regsub -all "({) (})" $args "" stripped
#puts "stripped LIST become $stripped"

#set splitted [split $args { }]    
#set length [llength [list $splitted]]
#puts "Length of splitted argument: $length"

if {[llength $args] == 1} {set arguments [lindex $args 0]}
# puts "stripped LIST become $arguments"
set length [llength $arguments]
# puts "Length of stripped: $length"

# Retrieve the first arg as component name
set component_name [lindex $arguments 0]
set arguments [lreplace $arguments 0 0]
# puts "1st arguments become $arguments"
# puts "Component Name: $component_name"

# Retrieve the 2nd arg as instance name
set instance_name [lindex $arguments 0]
set arguments [lreplace $arguments 0 0]
# puts "2nd arguments become $arguments"
# puts "Instance Name: $instance_name"

# Add component instance into design
add_instance $instance_name $component_name

# puts "3rd arguments become $arguments"
# Check if parameter->value pairs matched
set parameter ""
set value ""
if {[llength $arguments]%2 == 0} {
    foreach item $arguments {
        if {$lpos %2 == 0} {
            set parameter $item
            puts "Param:\[$item\]"
        } else {
            set value $item
            puts "Value:\[$item\]"
        }
        if {$lpos %2 == 1} {set_instance_parameter_value $instance_name $parameter $value}
        incr lpos
    }
    return 0

  } else {
  puts "\[Component: $component_name\]Inserted parameter->value pair has ODD arguments, please verify correntness."
  }
}


# --- Procedure to modify only instance parameters --- #
# Instance must be already instantiated into qsys system before this procedure is called 
# <arg> means to have <given instance name> followed by <parameter> <value> pairs
proc set_instance_param {args} {
    set lpos 0
    set length [llength $args]
    puts "Length of argument: $length"
    # puts "LIST become $args"

    # Retrieve fresh argument from sourcing TCL to get all elements
    if {[llength $args] == 1} {set arguments [lindex $args 0]}

    # puts "stripped LIST become $arguments"
    set length [llength $arguments]
    # puts "Length of stripped: $length"

    # Retrieve the 1st arg as instance name
    set instance_name [lindex $arguments 0]
    set arguments [lreplace $arguments 0 0]
    puts "Instance Name: $instance_name"

    # Check if parameter->value pairs matched
    set parameter ""
    set value ""
    if {[llength $arguments]%2 == 0} {
        foreach item $arguments {
            if {$lpos %2 == 0} {
                set parameter $item
                puts "Param:\[$item\]"
            } else {
                set value $item
                puts "Value:\[$item\]"
            }
        if {$lpos %2 == 1} {set_instance_parameter_value $instance_name $parameter $value}
        incr lpos
        }
    return 0

    } else {
        puts "\[Instance: $instance_name\]Inserted parameter->value pair has ODD arguments, please verify correntness."
    }
}


# --- Procedure to establish connection between two instances ports --- #
# <arg> means to have <source port> and <destination port> pairs
proc connect {args} {
    set lpos 0
    set length [llength $args]
    puts "Length of argument: $length"
    # puts "LIST become $args"

    # Retrieve fresh argument from sourcing TCL to get all elements
    if {[llength $args] == 1} {set arguments [lindex $args 0]}

    # puts "stripped LIST become $arguments"
    set length [llength $arguments]
    # puts "Length of stripped: $length"

    # Check if parameter->value pairs matched
    set parameter ""
    set value ""
    if {[llength $arguments]%2 == 0} {
        foreach item $arguments {
            if {$lpos %2 == 0} {
                set src $item
                puts "From:\[$item\]"
            } else {
                set dst $item
                puts "connect To:\[$item\]"
            }
            if {$lpos %2 == 1} {add_connection $src $dst}
            incr lpos
        }
        return 0

    } else {
        puts "\[Intended connections has Odd pair of source --> destination. Please verify correntness."
    }
}


# --- Procedure to establish connection between two instances ports with base address --- #
# <arg> means to have <source port>, <destination port> and <base address offset> 
proc connect_map {args} {
    set lpos 0
    set length [llength $args]
    puts "Length of argument: $length"
   # puts "LIST become $args"

    # Retrieve fresh argument from sourcing TCL to get all elements
    if {[llength $args] == 1} {set arguments [lindex $args 0]}

    #puts "stripped LIST become $arguments"
    set length [llength $arguments]
    puts "Length of arguments: $length"

    # Check if parameter->value pairs matched
    set parameter ""
    set value ""
    if {[llength $arguments]%3 == 0} {
    #foreach item $arguments {
    #   if {$lpos %2 == 0} {
    #       set src $item
    #       puts "From:\[$item\]"
    #   } else {
    #       set dst $item
    #       puts "connect To:\[$item\]"
    #   }
    #   if {$lpos %2 == 1} {add_connection $src $dst}
    #   incr lpos
    #}
        foreach {src dest offset} $arguments {
            add_connection $src $dest
            set_connection_parameter_value $src/$dest baseAddress $offset
        }
    return 0

    } else {
        puts "\[Intended connections has Odd pair of source --> destination. Please verify correntness."
    }
}

# --- Procedure to export instance port --- #
# EXPORT procedure set to export instances port to the top level of Qsys design
# Argument means to have <instance name> <port name> and <export port name> pairs
proc export {instance port name} {
    set_interface_property $name EXPORT_OF ${instance}.${port}
}

proc wsplit {str sepStr} {
    split [string map [list $sepStr \0] $str] \0]
}
