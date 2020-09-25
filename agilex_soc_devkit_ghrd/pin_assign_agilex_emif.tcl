#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2020 Intel Corporation.
#
#****************************************************************************
#
# This file contains pin assignments of EMIF port to suite different boards
# Currently planned board of support are AGILEX SoC devkit and PE Board revC

# Pin Support Matrix for AGILEX SoC Devkit
# note that we have to perform a logical remapping of pins to support the HPS hard pinout.
# The DQ* Bits within each byte lane can be swizzled between the DevKit and UDV.  This has no impact on GHRD.  The GHRD can just use the example design/pinout below.                                   
#
#****************************************************************************

## --------------------------
# "pin_matrix" is set in "board_${board}_pin_assignment_table.tcl"
## --------------------------

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
