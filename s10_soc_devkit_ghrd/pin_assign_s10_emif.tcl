#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2017-2020 Intel Corporation.
#
#****************************************************************************
#
# This file contains pin assignments of EMIF port to suite different boards
# Currently planned board of support are S10 SoC devkit, PE Board revC, klamath, atso12 and ashfield
#
#****************************************************************************


set emif_name "emif_hps"

set emif_pin_assignement_file "./board/emif_pin_assignment_table_${board}.tcl"
if {[file exist $emif_pin_assignement_file]} {
    source $emif_pin_assignement_file
} else {
    error "$emif_pin_assignement_file not exist!! Please make sure the board settings files are included in folder ./board/"
}

if {$hps_emif_en} {
   set ranks r1
   set width $hps_emif_width
   set ecc   $hps_emif_ecc_en

   if {$ecc} {
      incr width 8
   }

   set key "x${width}_$ranks"

   # Search for key in the first line
   set key_line [lindex $pin_matrix 0]
   set idx [lsearch $key_line $key]
   
   if {$idx < 0} {
      error "Could not locate configuration $key for EMIF generation"
   }

   set mem_type_idx [lsearch $key_line "MEM"]

   if {$mem_type_idx < 0} {
      error "Could not locate memory type specifier in pinout matrix for EMIF generation"
   }

   puts "key = $key"
   puts "board = $board"
   puts "mem_type = $hps_emif_type"

   # Now add all items
   set skip_first 1
   foreach key_line $pin_matrix {
      if {$skip_first} {
         set skip_first 0
      } else {
         set pin [lindex $key_line $idx]
         set mem_type [lindex $key_line $mem_type_idx]

         if {$pin != "unused" && (($mem_type == $hps_emif_type) || ($mem_type == "both"))} {
            set_location_assignment $pin -to [lindex $key_line 0]
            puts "Setting: set_location_assignment $pin -to [lindex $key_line 0]"
         }
      }
   }
}
