#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2017-2020 Intel Corporation.
#
#****************************************************************************
#
# This file define the EMIF Pin location devkit board.
#
#****************************************************************************
# Pin Support Matrix for S10 SoC Devkit
# note that we have to perform a logical remapping of pins to support the HPS hard pinout.
#
# HPS Ordering    HiLo Ordering
# 2L.0  DQS4      DQS2
# 2L.1  DQS5      DQS1
# 2L.2  DQS6      DQS3
# 2L.3  DQS7      DQS0
# 2M.0  AC
# 2M.1  AC
# 2M.2  AC
# 2M.3  ECC       DQS8
# 2N.0  DQS0      DQS7
# 2N.1  DQS1      DQS5
# 2N.2  DQS2      DQS6
# 2N.3  DQS3      DQS4

set pin_matrix [ list \
      [ list "NAME"                                "MEM"       "LOC"                  "x16_r1"   "x24_r1"   "x32_r1"   "x40_r1"   "x64_r1"   "x72_r1"   ] \
      [ list "${emif_name}_pll_ref_clk"            "both"      "PIN_M35"              "PIN_M35"  "PIN_M35"  "PIN_M35"  "PIN_M35"  "PIN_M35"  "PIN_M35"  ] \
      [ list "${emif_name}_oct_oct_rzqin"          "both"      "PIN_P34"              "PIN_P34"  "PIN_P34"  "PIN_P34"  "PIN_P34"  "PIN_P34"  "PIN_P34"  ] \
      [ list "${emif_name}_mem_mem_a[0]"           "ddr4"      "PIN_K38"              "PIN_K38"  "PIN_K38"  "PIN_K38"  "PIN_K38"  "PIN_K38"  "PIN_K38"  ] \
      [ list "${emif_name}_mem_mem_a[1]"           "ddr4"      "PIN_L37"              "PIN_L37"  "PIN_L37"  "PIN_L37"  "PIN_L37"  "PIN_L37"  "PIN_L37"  ] \
      [ list "${emif_name}_mem_mem_a[2]"           "ddr4"      "PIN_M37"              "PIN_M37"  "PIN_M37"  "PIN_M37"  "PIN_M37"  "PIN_M37"  "PIN_M37"  ] \
      [ list "${emif_name}_mem_mem_a[3]"           "ddr4"      "PIN_M38"              "PIN_M38"  "PIN_M38"  "PIN_M38"  "PIN_M38"  "PIN_M38"  "PIN_M38"  ] \
      [ list "${emif_name}_mem_mem_a[4]"           "ddr4"      "PIN_J39"              "PIN_J39"  "PIN_J39"  "PIN_J39"  "PIN_J39"  "PIN_J39"  "PIN_J39"  ] \
      [ list "${emif_name}_mem_mem_a[5]"           "ddr4"      "PIN_J38"              "PIN_J38"  "PIN_J38"  "PIN_J38"  "PIN_J38"  "PIN_J38"  "PIN_J38"  ] \
      [ list "${emif_name}_mem_mem_a[6]"           "ddr4"      "PIN_K39"              "PIN_K39"  "PIN_K39"  "PIN_K39"  "PIN_K39"  "PIN_K39"  "PIN_K39"  ] \
      [ list "${emif_name}_mem_mem_a[7]"           "ddr4"      "PIN_L39"              "PIN_L39"  "PIN_L39"  "PIN_L39"  "PIN_L39"  "PIN_L39"  "PIN_L39"  ] \
      [ list "${emif_name}_mem_mem_a[8]"           "ddr4"      "PIN_P37"              "PIN_P37"  "PIN_P37"  "PIN_P37"  "PIN_P37"  "PIN_P37"  "PIN_P37"  ] \
      [ list "${emif_name}_mem_mem_a[9]"           "ddr4"      "PIN_R37"              "PIN_R37"  "PIN_R37"  "PIN_R37"  "PIN_R37"  "PIN_R37"  "PIN_R37"  ] \
      [ list "${emif_name}_mem_mem_a[10]"          "ddr4"      "PIN_N37"              "PIN_N37"  "PIN_N37"  "PIN_N37"  "PIN_N37"  "PIN_N37"  "PIN_N37"  ] \
      [ list "${emif_name}_mem_mem_a[11]"          "ddr4"      "PIN_P38"              "PIN_P38"  "PIN_P38"  "PIN_P38"  "PIN_P38"  "PIN_P38"  "PIN_P38"  ] \
      [ list "${emif_name}_mem_mem_a[12]"          "ddr4"      "PIN_P35"              "PIN_P35"  "PIN_P35"  "PIN_P35"  "PIN_P35"  "PIN_P35"  "PIN_P35"  ] \
      [ list "${emif_name}_mem_mem_a[13]"          "ddr4"      "PIN_K36"              "PIN_K36"  "PIN_K36"  "PIN_K36"  "PIN_K36"  "PIN_K36"  "PIN_K36"  ] \
      [ list "${emif_name}_mem_mem_a[14]"          "ddr4"      "PIN_K37"              "PIN_K37"  "PIN_K37"  "PIN_K37"  "PIN_K37"  "PIN_K37"  "PIN_K37"  ] \
      [ list "${emif_name}_mem_mem_a[15]"          "ddr4"      "PIN_N36"              "PIN_N36"  "PIN_N36"  "PIN_N36"  "PIN_N36"  "PIN_N36"  "PIN_N36"  ] \
      [ list "${emif_name}_mem_mem_a[16]"          "ddr4"      "PIN_P36"              "PIN_P36"  "PIN_P36"  "PIN_P36"  "PIN_P36"  "PIN_P36"  "PIN_P36"  ] \
      [ list "${emif_name}_mem_mem_act_n[0]"       "ddr4"      "PIN_H38"              "PIN_H38"  "PIN_H38"  "PIN_H38"  "PIN_H38"  "PIN_H38"  "PIN_H38"  ] \
      [ list "${emif_name}_mem_mem_alert_n[0]"     "ddr4"      "PIN_A38"              "PIN_A38"  "PIN_A38"  "PIN_A38"  "PIN_A38"  "PIN_A38"  "PIN_A38"  ] \
      [ list "${emif_name}_mem_mem_ba[0]"          "ddr4"      "PIN_L36"              "PIN_L36"  "PIN_L36"  "PIN_L36"  "PIN_L36"  "PIN_L36"  "PIN_L36"  ] \
      [ list "${emif_name}_mem_mem_ba[1]"          "ddr4"      "PIN_T35"              "PIN_T35"  "PIN_T35"  "PIN_T35"  "PIN_T35"  "PIN_T35"  "PIN_T35"  ] \
      [ list "${emif_name}_mem_mem_bg[0]"          "ddr4"      "PIN_R36"              "PIN_R36"  "PIN_R36"  "PIN_R36"  "PIN_R36"  "PIN_R36"  "PIN_R36"  ] \
      [ list "${emif_name}_mem_mem_ck[0]"          "ddr4"      "PIN_F39"              "PIN_F39"  "PIN_F39"  "PIN_F39"  "PIN_F39"  "PIN_F39"  "PIN_F39"  ] \
      [ list "${emif_name}_mem_mem_ck_n[0]"        "ddr4"      "PIN_G39"              "PIN_G39"  "PIN_G39"  "PIN_G39"  "PIN_G39"  "PIN_G39"  "PIN_G39"  ] \
      [ list "${emif_name}_mem_mem_cke[0]"         "ddr4"      "PIN_L40"              "PIN_L40"  "PIN_L40"  "PIN_L40"  "PIN_L40"  "PIN_L40"  "PIN_L40"  ] \
      [ list "${emif_name}_mem_mem_cs_n[0]"        "ddr4"      "PIN_G38"              "PIN_G38"  "PIN_G38"  "PIN_G38"  "PIN_G38"  "PIN_G38"  "PIN_G38"  ] \
      [ list "${emif_name}_mem_mem_odt[0]"         "ddr4"      "PIN_G40"              "PIN_G40"  "PIN_G40"  "PIN_G40"  "PIN_G40"  "PIN_G40"  "PIN_G40"  ] \
      [ list "${emif_name}_mem_mem_par[0]"         "ddr4"      "PIN_H40"              "PIN_H40"  "PIN_H40"  "PIN_H40"  "PIN_H40"  "PIN_H40"  "PIN_H40"  ] \
      [ list "${emif_name}_mem_mem_reset_n[0]"     "ddr4"      "PIN_E40"              "PIN_E40"  "PIN_E40"  "PIN_E40"  "PIN_E40"  "PIN_E40"  "PIN_E40"  ] \
      [ list "${emif_name}_mem_mem_a[0]"           "ddr3"      "PIN_K38"              "PIN_K38"  "PIN_K38"  "PIN_K38"  "PIN_K38"  "PIN_K38"  "PIN_K38"  ] \
      [ list "${emif_name}_mem_mem_a[1]"           "ddr3"      "PIN_L37"              "PIN_L37"  "PIN_L37"  "PIN_L37"  "PIN_L37"  "PIN_L37"  "PIN_L37"  ] \
      [ list "${emif_name}_mem_mem_a[2]"           "ddr3"      "PIN_M37"              "PIN_M37"  "PIN_M37"  "PIN_M37"  "PIN_M37"  "PIN_M37"  "PIN_M37"  ] \
      [ list "${emif_name}_mem_mem_a[3]"           "ddr3"      "PIN_M38"              "PIN_M38"  "PIN_M38"  "PIN_M38"  "PIN_M38"  "PIN_M38"  "PIN_M38"  ] \
      [ list "${emif_name}_mem_mem_a[4]"           "ddr3"      "PIN_J39"              "PIN_J39"  "PIN_J39"  "PIN_J39"  "PIN_J39"  "PIN_J39"  "PIN_J39"  ] \
      [ list "${emif_name}_mem_mem_a[5]"           "ddr3"      "PIN_J38"              "PIN_J38"  "PIN_J38"  "PIN_J38"  "PIN_J38"  "PIN_J38"  "PIN_J38"  ] \
      [ list "${emif_name}_mem_mem_a[6]"           "ddr3"      "PIN_K39"              "PIN_K39"  "PIN_K39"  "PIN_K39"  "PIN_K39"  "PIN_K39"  "PIN_K39"  ] \
      [ list "${emif_name}_mem_mem_a[7]"           "ddr3"      "PIN_L39"              "PIN_L39"  "PIN_L39"  "PIN_L39"  "PIN_L39"  "PIN_L39"  "PIN_L39"  ] \
      [ list "${emif_name}_mem_mem_a[8]"           "ddr3"      "PIN_P37"              "PIN_P37"  "PIN_P37"  "PIN_P37"  "PIN_P37"  "PIN_P37"  "PIN_P37"  ] \
      [ list "${emif_name}_mem_mem_a[9]"           "ddr3"      "PIN_R37"              "PIN_R37"  "PIN_R37"  "PIN_R37"  "PIN_R37"  "PIN_R37"  "PIN_R37"  ] \
      [ list "${emif_name}_mem_mem_a[10]"          "ddr3"      "PIN_N37"              "PIN_N37"  "PIN_N37"  "PIN_N37"  "PIN_N37"  "PIN_N37"  "PIN_N37"  ] \
      [ list "${emif_name}_mem_mem_a[11]"          "ddr3"      "PIN_P38"              "PIN_P38"  "PIN_P38"  "PIN_P38"  "PIN_P38"  "PIN_P38"  "PIN_P38"  ] \
      [ list "${emif_name}_mem_mem_a[12]"          "ddr3"      "PIN_P35"              "PIN_P35"  "PIN_P35"  "PIN_P35"  "PIN_P35"  "PIN_P35"  "PIN_P35"  ] \
      [ list "${emif_name}_mem_mem_a[13]"          "ddr3"      "PIN_K36"              "PIN_K36"  "PIN_K36"  "PIN_K36"  "PIN_K36"  "PIN_K36"  "PIN_K36"  ] \
      [ list "${emif_name}_mem_mem_a[14]"          "ddr3"      "PIN_K37"              "PIN_K37"  "PIN_K37"  "PIN_K37"  "PIN_K37"  "PIN_K37"  "PIN_K37"  ] \
      [ list "${emif_name}_mem_mem_ba[0]"          "ddr3"      "PIN_L36"              "PIN_L36"  "PIN_L36"  "PIN_L36"  "PIN_L36"  "PIN_L36"  "PIN_L36"  ] \
      [ list "${emif_name}_mem_mem_ba[1]"          "ddr3"      "PIN_T35"              "PIN_T35"  "PIN_T35"  "PIN_T35"  "PIN_T35"  "PIN_T35"  "PIN_T35"  ] \
      [ list "${emif_name}_mem_mem_ba[2]"          "ddr3"      "PIN_R36"              "PIN_R36"  "PIN_R36"  "PIN_R36"  "PIN_R36"  "PIN_R36"  "PIN_R36"  ] \
      [ list "${emif_name}_mem_mem_cas_n"          "ddr3"      "PIN_L35"              "PIN_L35"  "PIN_L35"  "PIN_L35"  "PIN_L35"  "PIN_L35"  "PIN_L35"  ] \
      [ list "${emif_name}_mem_mem_ck[0]"          "ddr3"      "PIN_F39"              "PIN_F39"  "PIN_F39"  "PIN_F39"  "PIN_F39"  "PIN_F39"  "PIN_F39"  ] \
      [ list "${emif_name}_mem_mem_ck_n[0]"        "ddr3"      "PIN_G39"              "PIN_G39"  "PIN_G39"  "PIN_G39"  "PIN_G39"  "PIN_G39"  "PIN_G39"  ] \
      [ list "${emif_name}_mem_mem_cke[0]"         "ddr3"      "PIN_L40"              "PIN_L40"  "PIN_L40"  "PIN_L40"  "PIN_L40"  "PIN_L40"  "PIN_L40"  ] \
      [ list "${emif_name}_mem_mem_cs_n[0]"        "ddr3"      "PIN_G38"              "PIN_G38"  "PIN_G38"  "PIN_G38"  "PIN_G38"  "PIN_G38"  "PIN_G38"  ] \
      [ list "${emif_name}_mem_mem_odt[0]"         "ddr3"      "PIN_G40"              "PIN_G40"  "PIN_G40"  "PIN_G40"  "PIN_G40"  "PIN_G40"  "PIN_G40"  ] \
      [ list "${emif_name}_mem_mem_ras_n"          "ddr3"      "PIN_P36"              "PIN_P36"  "PIN_P36"  "PIN_P36"  "PIN_P36"  "PIN_P36"  "PIN_P36"  ] \
      [ list "${emif_name}_mem_mem_reset_n"        "ddr3"      "PIN_E40"              "PIN_E40"  "PIN_E40"  "PIN_E40"  "PIN_E40"  "PIN_E40"  "PIN_E40"  ] \
      [ list "${emif_name}_mem_mem_we_n[0]"        "ddr3"      "PIN_D40"              "PIN_D40"  "PIN_D40"  "PIN_D40"  "PIN_D40"  "PIN_D40"  "PIN_D40"  ] \
      [ list "${emif_name}_mem_mem_dqs[0]"         "both"      "PIN_E26"              "PIN_A36"  "PIN_A36"  "PIN_A36"  "PIN_A36"  "PIN_A36"  "PIN_A36"  ] \
      [ list "${emif_name}_mem_mem_dqs[1]"         "both"      "PIN_V28"              "PIN_E36"  "PIN_E36"  "PIN_E36"  "PIN_E36"  "PIN_E36"  "PIN_E36"  ] \
      [ list "${emif_name}_mem_mem_dqs[2]"         "both"      "PIN_T26"              unused     "PIN_R32"  "PIN_G33"  "PIN_G33"  "PIN_G33"  "PIN_G33"  ] \
      [ list "${emif_name}_mem_mem_dqs[3]"         "both"      "PIN_J26"              unused     unused     "PIN_L32"  "PIN_L32"  "PIN_L32"  "PIN_L32"  ] \
      [ list "${emif_name}_mem_mem_dqs[4]"         "both"      "PIN_L32"              unused     unused     unused     "PIN_R32"  "PIN_T26"  "PIN_T26"  ] \
      [ list "${emif_name}_mem_mem_dqs[5]"         "both"      "PIN_E36"              unused     unused     unused     unused     "PIN_V28"  "PIN_V28"  ] \
      [ list "${emif_name}_mem_mem_dqs[6]"         "both"      "PIN_G33"              unused     unused     unused     unused     "PIN_J26"  "PIN_J26"  ] \
      [ list "${emif_name}_mem_mem_dqs[7]"         "both"      "PIN_A36"              unused     unused     unused     unused     "PIN_E26"  "PIN_E26"  ] \
      [ list "${emif_name}_mem_mem_dqs[8]"         "both"      "PIN_R32"              unused     unused     unused     unused     unused     "PIN_R32"  ] \
      [ list "${emif_name}_mem_mem_dqs_n[0]"       "both"      "PIN_F26"              "PIN_A35"  "PIN_A35"  "PIN_A35"  "PIN_A35"  "PIN_A35"  "PIN_A35"  ] \
      [ list "${emif_name}_mem_mem_dqs_n[1]"       "both"      "PIN_V27"              "PIN_F36"  "PIN_F36"  "PIN_F36"  "PIN_F36"  "PIN_F36"  "PIN_F36"  ] \
      [ list "${emif_name}_mem_mem_dqs_n[2]"       "both"      "PIN_R27"              unused     "PIN_T32"  "PIN_G34"  "PIN_G34"  "PIN_G34"  "PIN_G34"  ] \
      [ list "${emif_name}_mem_mem_dqs_n[3]"       "both"      "PIN_K26"              unused     unused     "PIN_L31"  "PIN_L31"  "PIN_L31"  "PIN_L31"  ] \
      [ list "${emif_name}_mem_mem_dqs_n[4]"       "both"      "PIN_L31"              unused     unused     unused     "PIN_T32"  "PIN_R27"  "PIN_R27"  ] \
      [ list "${emif_name}_mem_mem_dqs_n[5]"       "both"      "PIN_F36"              unused     unused     unused     unused     "PIN_V27"  "PIN_V27"  ] \
      [ list "${emif_name}_mem_mem_dqs_n[6]"       "both"      "PIN_G34"              unused     unused     unused     unused     "PIN_K26"  "PIN_K26"  ] \
      [ list "${emif_name}_mem_mem_dqs_n[7]"       "both"      "PIN_A35"              unused     unused     unused     unused     "PIN_F26"  "PIN_F26"  ] \
      [ list "${emif_name}_mem_mem_dqs_n[8]"       "both"      "PIN_T32"              unused     unused     unused     unused     unused     "PIN_T32"  ] \
      [ list "${emif_name}_mem_mem_dm[0]"          "ddr3"      "PIN_E27"              "PIN_C36"  "PIN_C36"  "PIN_C36"  "PIN_C36"  "PIN_C36"  "PIN_C36"  ] \
      [ list "${emif_name}_mem_mem_dm[1]"          "ddr3"      "PIN_V30"              "PIN_D39"  "PIN_D39"  "PIN_D39"  "PIN_D39"  "PIN_D39"  "PIN_D39"  ] \
      [ list "${emif_name}_mem_mem_dm[2]"          "ddr3"      "PIN_N25"              unused     "PIN_U34"  "PIN_F34"  "PIN_F34"  "PIN_F34"  "PIN_F34"  ] \
      [ list "${emif_name}_mem_mem_dm[3]"          "ddr3"      "PIN_L26"              unused     unused     "PIN_J34"  "PIN_J34"  "PIN_J34"  "PIN_J34"  ] \
      [ list "${emif_name}_mem_mem_dm[4]"          "ddr3"      "PIN_J34"              unused     unused     unused     "PIN_U34"  "PIN_N25"  "PIN_N25"  ] \
      [ list "${emif_name}_mem_mem_dm[5]"          "ddr3"      "PIN_D39"              unused     unused     unused     unused     "PIN_V30"  "PIN_V30"  ] \
      [ list "${emif_name}_mem_mem_dm[6]"          "ddr3"      "PIN_F34"              unused     unused     unused     unused     "PIN_L26"  "PIN_L26"  ] \
      [ list "${emif_name}_mem_mem_dm[7]"          "ddr3"      "PIN_C36"              unused     unused     unused     unused     "PIN_E27"  "PIN_E27"  ] \
      [ list "${emif_name}_mem_mem_dm[8]"          "ddr3"      "PIN_U34"              unused     unused     unused     unused     unused     "PIN_U34"  ] \
      [ list "${emif_name}_mem_mem_dbi_n[0]"       "ddr4"      "PIN_E27"              "PIN_C36"  "PIN_C36"  "PIN_C36"  "PIN_C36"  "PIN_C36"  "PIN_C36"  ] \
      [ list "${emif_name}_mem_mem_dbi_n[1]"       "ddr4"      "PIN_V30"              "PIN_D39"  "PIN_D39"  "PIN_D39"  "PIN_D39"  "PIN_D39"  "PIN_D39"  ] \
      [ list "${emif_name}_mem_mem_dbi_n[2]"       "ddr4"      "PIN_N25"              unused     "PIN_U34"  "PIN_F34"  "PIN_F34"  "PIN_F34"  "PIN_F34"  ] \
      [ list "${emif_name}_mem_mem_dbi_n[3]"       "ddr4"      "PIN_L26"              unused     unused     "PIN_J34"  "PIN_J34"  "PIN_J34"  "PIN_J34"  ] \
      [ list "${emif_name}_mem_mem_dbi_n[4]"       "ddr4"      "PIN_J34"              unused     unused     unused     "PIN_U34"  "PIN_N25"  "PIN_N25"  ] \
      [ list "${emif_name}_mem_mem_dbi_n[5]"       "ddr4"      "PIN_D39"              unused     unused     unused     unused     "PIN_V30"  "PIN_V30"  ] \
      [ list "${emif_name}_mem_mem_dbi_n[6]"       "ddr4"      "PIN_F34"              unused     unused     unused     unused     "PIN_L26"  "PIN_L26"  ] \
      [ list "${emif_name}_mem_mem_dbi_n[7]"       "ddr4"      "PIN_C36"              unused     unused     unused     unused     "PIN_E27"  "PIN_E27"  ] \
      [ list "${emif_name}_mem_mem_dbi_n[8]"       "ddr4"      "PIN_U34"              unused     unused     unused     unused     unused     "PIN_U34"  ] \
      [ list "${emif_name}_mem_mem_dq[0]"          "both"      "PIN_G27"              "PIN_A37"  "PIN_A37"  "PIN_A37"  "PIN_A37"  "PIN_A37"  "PIN_A37"  ] \
      [ list "${emif_name}_mem_mem_dq[1]"          "both"      "PIN_C27"              "PIN_B35"  "PIN_B35"  "PIN_B35"  "PIN_B35"  "PIN_B35"  "PIN_B35"  ] \
      [ list "${emif_name}_mem_mem_dq[2]"          "both"      "PIN_B27"              "PIN_D36"  "PIN_D36"  "PIN_D36"  "PIN_D36"  "PIN_D36"  "PIN_D36"  ] \
      [ list "${emif_name}_mem_mem_dq[3]"          "both"      "PIN_F27"              "PIN_B37"  "PIN_B37"  "PIN_B37"  "PIN_B37"  "PIN_B37"  "PIN_B37"  ] \
      [ list "${emif_name}_mem_mem_dq[4]"          "both"      "PIN_C26"              "PIN_B38"  "PIN_B38"  "PIN_B38"  "PIN_B38"  "PIN_B38"  "PIN_B38"  ] \
      [ list "${emif_name}_mem_mem_dq[5]"          "both"      "PIN_B25"              "PIN_C35"  "PIN_C35"  "PIN_C35"  "PIN_C35"  "PIN_C35"  "PIN_C35"  ] \
      [ list "${emif_name}_mem_mem_dq[6]"          "both"      "PIN_D26"              "PIN_C38"  "PIN_C38"  "PIN_C38"  "PIN_C38"  "PIN_C38"  "PIN_C38"  ] \
      [ list "${emif_name}_mem_mem_dq[7]"          "both"      "PIN_D25"              "PIN_C37"  "PIN_C37"  "PIN_C37"  "PIN_C37"  "PIN_C37"  "PIN_C37"  ] \
      [ list "${emif_name}_mem_mem_dq[8]"          "both"      "PIN_U30"              "PIN_H37"  "PIN_H37"  "PIN_H37"  "PIN_H37"  "PIN_H37"  "PIN_H37"  ] \
      [ list "${emif_name}_mem_mem_dq[9]"          "both"      "PIN_T30"              "PIN_E39"  "PIN_E39"  "PIN_E39"  "PIN_E39"  "PIN_E39"  "PIN_E39"  ] \
      [ list "${emif_name}_mem_mem_dq[10]"         "both"      "PIN_T29"              "PIN_F37"  "PIN_F37"  "PIN_F37"  "PIN_F37"  "PIN_F37"  "PIN_F37"  ] \
      [ list "${emif_name}_mem_mem_dq[11]"         "both"      "PIN_U28"              "PIN_E38"  "PIN_E38"  "PIN_E38"  "PIN_E38"  "PIN_E38"  "PIN_E38"  ] \
      [ list "${emif_name}_mem_mem_dq[12]"         "both"      "PIN_V25"              "PIN_D38"  "PIN_D38"  "PIN_D38"  "PIN_D38"  "PIN_D38"  "PIN_D38"  ] \
      [ list "${emif_name}_mem_mem_dq[13]"         "both"      "PIN_U27"              "PIN_D34"  "PIN_D34"  "PIN_D34"  "PIN_D34"  "PIN_D34"  "PIN_D34"  ] \
      [ list "${emif_name}_mem_mem_dq[14]"         "both"      "PIN_V26"              "PIN_D35"  "PIN_D35"  "PIN_D35"  "PIN_D35"  "PIN_D35"  "PIN_D35"  ] \
      [ list "${emif_name}_mem_mem_dq[15]"         "both"      "PIN_U29"              "PIN_E37"  "PIN_E37"  "PIN_E37"  "PIN_E37"  "PIN_E37"  "PIN_E37"  ] \
      [ list "${emif_name}_mem_mem_dq[16]"         "both"      "PIN_U25"              unused     "PIN_T34"  "PIN_H33"  "PIN_H33"  "PIN_H33"  "PIN_H33"  ] \
      [ list "${emif_name}_mem_mem_dq[17]"         "both"      "PIN_T25"              unused     "PIN_R31"  "PIN_E34"  "PIN_E34"  "PIN_E34"  "PIN_E34"  ] \
      [ list "${emif_name}_mem_mem_dq[18]"         "both"      "PIN_P25"              unused     "PIN_U33"  "PIN_F35"  "PIN_F35"  "PIN_F35"  "PIN_F35"  ] \
      [ list "${emif_name}_mem_mem_dq[19]"         "both"      "PIN_N27"              unused     "PIN_T31"  "PIN_J36"  "PIN_J36"  "PIN_J36"  "PIN_J36"  ] \
      [ list "${emif_name}_mem_mem_dq[20]"         "both"      "PIN_L25"              unused     "PIN_R34"  "PIN_G35"  "PIN_G35"  "PIN_G35"  "PIN_G35"  ] \
      [ list "${emif_name}_mem_mem_dq[21]"         "both"      "PIN_R26"              unused     "PIN_U32"  "PIN_J35"  "PIN_J35"  "PIN_J35"  "PIN_J35"  ] \
      [ list "${emif_name}_mem_mem_dq[22]"         "both"      "PIN_P26"              unused     "PIN_V32"  "PIN_H35"  "PIN_H35"  "PIN_H35"  "PIN_H35"  ] \
      [ list "${emif_name}_mem_mem_dq[23]"         "both"      "PIN_M25"              unused     "PIN_P33"  "PIN_H36"  "PIN_H36"  "PIN_H36"  "PIN_H36"  ] \
      [ list "${emif_name}_mem_mem_dq[24]"         "both"      "PIN_M27"              unused     unused     "PIN_K33"  "PIN_K33"  "PIN_K33"  "PIN_K33"  ] \
      [ list "${emif_name}_mem_mem_dq[25]"         "both"      "PIN_L27"              unused     unused     "PIN_K34"  "PIN_K34"  "PIN_K34"  "PIN_K34"  ] \
      [ list "${emif_name}_mem_mem_dq[26]"         "both"      "PIN_G25"              unused     unused     "PIN_M33"  "PIN_M33"  "PIN_M33"  "PIN_M33"  ] \
      [ list "${emif_name}_mem_mem_dq[27]"         "both"      "PIN_H25"              unused     unused     "PIN_N32"  "PIN_N32"  "PIN_N32"  "PIN_N32"  ] \
      [ list "${emif_name}_mem_mem_dq[28]"         "both"      "PIN_H27"              unused     unused     "PIN_K32"  "PIN_K32"  "PIN_K32"  "PIN_K32"  ] \
      [ list "${emif_name}_mem_mem_dq[29]"         "both"      "PIN_K27"              unused     unused     "PIN_N33"  "PIN_N33"  "PIN_N33"  "PIN_N33"  ] \
      [ list "${emif_name}_mem_mem_dq[30]"         "both"      "PIN_H26"              unused     unused     "PIN_N31"  "PIN_N31"  "PIN_N31"  "PIN_N31"  ] \
      [ list "${emif_name}_mem_mem_dq[31]"         "both"      "PIN_F25"              unused     unused     "PIN_M34"  "PIN_M34"  "PIN_M34"  "PIN_M34"  ] \
      [ list "${emif_name}_mem_mem_dq[32]"         "both"      "PIN_K33"              unused     unused     unused     "PIN_T34"  "PIN_U25"  "PIN_U25"  ] \
      [ list "${emif_name}_mem_mem_dq[33]"         "both"      "PIN_K34"              unused     unused     unused     "PIN_R31"  "PIN_T25"  "PIN_T25"  ] \
      [ list "${emif_name}_mem_mem_dq[34]"         "both"      "PIN_M33"              unused     unused     unused     "PIN_U33"  "PIN_P25"  "PIN_P25"  ] \
      [ list "${emif_name}_mem_mem_dq[35]"         "both"      "PIN_N32"              unused     unused     unused     "PIN_T31"  "PIN_N27"  "PIN_N27"  ] \
      [ list "${emif_name}_mem_mem_dq[36]"         "both"      "PIN_K32"              unused     unused     unused     "PIN_R34"  "PIN_L25"  "PIN_L25"  ] \
      [ list "${emif_name}_mem_mem_dq[37]"         "both"      "PIN_N33"              unused     unused     unused     "PIN_U32"  "PIN_R26"  "PIN_R26"  ] \
      [ list "${emif_name}_mem_mem_dq[38]"         "both"      "PIN_N31"              unused     unused     unused     "PIN_V32"  "PIN_P26"  "PIN_P26"  ] \
      [ list "${emif_name}_mem_mem_dq[39]"         "both"      "PIN_M34"              unused     unused     unused     "PIN_P33"  "PIN_M25"  "PIN_M25"  ] \
      [ list "${emif_name}_mem_mem_dq[40]"         "both"      "PIN_H37"              unused     unused     unused     unused     "PIN_U30"  "PIN_U30"  ] \
      [ list "${emif_name}_mem_mem_dq[41]"         "both"      "PIN_E39"              unused     unused     unused     unused     "PIN_T30"  "PIN_T30"  ] \
      [ list "${emif_name}_mem_mem_dq[42]"         "both"      "PIN_F37"              unused     unused     unused     unused     "PIN_T29"  "PIN_T29"  ] \
      [ list "${emif_name}_mem_mem_dq[43]"         "both"      "PIN_E38"              unused     unused     unused     unused     "PIN_U28"  "PIN_U28"  ] \
      [ list "${emif_name}_mem_mem_dq[44]"         "both"      "PIN_D38"              unused     unused     unused     unused     "PIN_V25"  "PIN_V25"  ] \
      [ list "${emif_name}_mem_mem_dq[45]"         "both"      "PIN_D34"              unused     unused     unused     unused     "PIN_U27"  "PIN_U27"  ] \
      [ list "${emif_name}_mem_mem_dq[46]"         "both"      "PIN_D35"              unused     unused     unused     unused     "PIN_V26"  "PIN_V26"  ] \
      [ list "${emif_name}_mem_mem_dq[47]"         "both"      "PIN_E37"              unused     unused     unused     unused     "PIN_U29"  "PIN_U29"  ] \
      [ list "${emif_name}_mem_mem_dq[48]"         "both"      "PIN_H33"              unused     unused     unused     unused     "PIN_M27"  "PIN_M27"  ] \
      [ list "${emif_name}_mem_mem_dq[49]"         "both"      "PIN_E34"              unused     unused     unused     unused     "PIN_L27"  "PIN_L27"  ] \
      [ list "${emif_name}_mem_mem_dq[50]"         "both"      "PIN_F35"              unused     unused     unused     unused     "PIN_G25"  "PIN_G25"  ] \
      [ list "${emif_name}_mem_mem_dq[51]"         "both"      "PIN_J36"              unused     unused     unused     unused     "PIN_H25"  "PIN_H25"  ] \
      [ list "${emif_name}_mem_mem_dq[52]"         "both"      "PIN_G35"              unused     unused     unused     unused     "PIN_H27"  "PIN_H27"  ] \
      [ list "${emif_name}_mem_mem_dq[53]"         "both"      "PIN_J35"              unused     unused     unused     unused     "PIN_K27"  "PIN_K27"  ] \
      [ list "${emif_name}_mem_mem_dq[54]"         "both"      "PIN_H35"              unused     unused     unused     unused     "PIN_H26"  "PIN_H26"  ] \
      [ list "${emif_name}_mem_mem_dq[55]"         "both"      "PIN_H36"              unused     unused     unused     unused     "PIN_F25"  "PIN_F25"  ] \
      [ list "${emif_name}_mem_mem_dq[56]"         "both"      "PIN_A37"              unused     unused     unused     unused     "PIN_G27"  "PIN_G27"  ] \
      [ list "${emif_name}_mem_mem_dq[57]"         "both"      "PIN_B35"              unused     unused     unused     unused     "PIN_C27"  "PIN_C27"  ] \
      [ list "${emif_name}_mem_mem_dq[58]"         "both"      "PIN_D36"              unused     unused     unused     unused     "PIN_B27"  "PIN_B27"  ] \
      [ list "${emif_name}_mem_mem_dq[59]"         "both"      "PIN_B37"              unused     unused     unused     unused     "PIN_F27"  "PIN_F27"  ] \
      [ list "${emif_name}_mem_mem_dq[60]"         "both"      "PIN_B38"              unused     unused     unused     unused     "PIN_C26"  "PIN_C26"  ] \
      [ list "${emif_name}_mem_mem_dq[61]"         "both"      "PIN_C35"              unused     unused     unused     unused     "PIN_B25"  "PIN_B25"  ] \
      [ list "${emif_name}_mem_mem_dq[62]"         "both"      "PIN_C38"              unused     unused     unused     unused     "PIN_D26"  "PIN_D26"  ] \
      [ list "${emif_name}_mem_mem_dq[63]"         "both"      "PIN_C37"              unused     unused     unused     unused     "PIN_D25"  "PIN_D25"  ] \
      [ list "${emif_name}_mem_mem_dq[64]"         "both"      "PIN_T34"              unused     unused     unused     unused     unused     "PIN_T34"  ] \
      [ list "${emif_name}_mem_mem_dq[65]"         "both"      "PIN_R31"              unused     unused     unused     unused     unused     "PIN_R31"  ] \
      [ list "${emif_name}_mem_mem_dq[66]"         "both"      "PIN_U33"              unused     unused     unused     unused     unused     "PIN_U33"  ] \
      [ list "${emif_name}_mem_mem_dq[67]"         "both"      "PIN_T31"              unused     unused     unused     unused     unused     "PIN_T31"  ] \
      [ list "${emif_name}_mem_mem_dq[68]"         "both"      "PIN_R34"              unused     unused     unused     unused     unused     "PIN_R34"  ] \
      [ list "${emif_name}_mem_mem_dq[69]"         "both"      "PIN_U32"              unused     unused     unused     unused     unused     "PIN_U32"  ] \
      [ list "${emif_name}_mem_mem_dq[70]"         "both"      "PIN_V32"              unused     unused     unused     unused     unused     "PIN_V32"  ] \
      [ list "${emif_name}_mem_mem_dq[71]"         "both"      "PIN_P33"              unused     unused     unused     unused     unused     "PIN_P33"  ] \
]