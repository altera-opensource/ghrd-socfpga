#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2016-2020 Intel Corporation.
#
#****************************************************************************
#
# This script generates the Partial Reconfiguration Revision for the PR GHRD.
# To execute this script using quartus_sh for generating PR revision QSF accordingly
#   quartus_sh --script=create_pr_revision.tcl -projectname $(QUARTUS_BASE) -revision $(QUARTUS_BASE_REVISION) -pr_revision $(PR_REV) -pr_partition $(QSYS_SUBSYS_PR)
#
#****************************************************************************

package require cmdline

source ./design_config.tcl

set devicefamily $DEVICE_FAMILY
set device $FPGA_DEVICE
set project_name $QUARTUS_NAME
# set pr_partition $PR_PARTITION

set options {\
    { "projectname.arg" "" "Project name" } \
    { "revision.arg" "" "Revision name" } \
    { "pr_revision.arg" "" "PR Revision name" } \
    { "revision_type.arg" "" "Revision type" } \
    { "pr_partition.arg" "" "PR Partition name" }
}
array set opts [::cmdline::getoptions quartus(args) $options]

if {[project_exists $opts(projectname)]} {
    if {[string equal "" $opts(revision)]} {
        project_open $opts(projectname) -current_revision
    } else {
        project_open $opts(projectname) -revision $opts(revision)
    }
} else {
    post_message -type error "Project $opts(projectname) does not exist"
    exit
}
set base_revision $opts(revision)
set pr_revision $opts(pr_revision)
set revision_type $opts(revision_type)
set pr_partition $opts(pr_partition)

################################################################################
# Partial Reconfiguration System
################################################################################
namespace eval create_pr_revision {
################################################################################
# Core procs
################################################################################

################################################################################
# Usage:    
#   create_pr_revision::create_revision -reconfigurable <new-revision> <base-revision>
################################################################################
proc create_revision { typeopt revision base } {
  global devicefamily
  global device
  global project_name
  global pr_partition

    # Error checking
    if {![::revision_exists $base]} {
        ::post_message -type error "Revision \"$base\" does not exist. Specify a valid base revision for the project."
        return 0
    }

    if [::revision_exists $revision] {
        ::post_message -type error "Revision \"$revision\" already exist. Specify a new reconfigurable revision for the project."
        return 0
    }

    # Option processing
    set type {}
    if {$typeopt == "-implementation"} {
    set type "PR_IMPL"
    } else {
            ::post_message -type error "Invalid project revision type \"$type\" specified."
            return 0
    }
    
    if {$typeopt == "-implementation"} {
    # Extract the reconfigurable partitions from the base revision
    set curr_revision [get_current_revision]
    ::set_current_revision $base

    ::create_revision -based_on $base -set_current $revision

    set_global_assignment -name REVISION_TYPE PR_IMPL
    set_instance_assignment -name QDB_FILE_PARTITION base_static.qdb -to |
    set_global_assignment -name ENABLE_SIGNALTAP OFF
    set_instance_assignment -name ENTITY_REBINDING $pr_partition -to soc_inst|pr_region_0
    }
}
}

create_pr_revision::create_revision -implementation $pr_revision $base_revision
