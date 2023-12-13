######################################################################### 
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2020 Intel Corporation.
#
########################################################################


################## USER TOPLEVEL CONFIGURATION ##########################
#
# <-
#
#   SUB_HPS_EN:
#       - 0: disable
#       - 1: enable [default]
#
#   DAUGHTER_CARD:
#      - devkit_dc_oobe: Out-of-Box Experience HPS Daughter Card [default]
#      - devkit_dc_nand: HPS Daugther Card with NAND 
#      - devkit_dc_emmc: HPS Daughter Card with eMMC
#      - debug2: HPS Daughter Card with debug2
#      - tsn_aic0 : HPS Daughter Card with TSN Config 1
#
#   HPS_EMIF_EN :
#       - 0: disable
#       - 1: enable [default] 
#
#   HPS_EMIF_WIDTH:
#       - 0: 1x16           (Not supported)
#       - 1: 1x32 [default] (Supported)
#       - 2: 2x16 bit - single IO96B (Not supported)
#       - 3: 2x16 bit - dual IO96B (Not supported)
#       - 4: 2x32 bit (Not supported)
#       - 5: 4x16 bit (Not supported)
#
#   HPS_EMIF_MEM_CLK_FREQ_MHZ:
#       - 800: 800Mhz
#       - 933: 933Mhz [default]
#       - 1066: 1066Mhz
#       - 1200: 1200Mhz
#
#   HPS_EMIF_REF_CLK_FREQ_MHZ:
#       - 100: 100Mhz
#       - 116.625: 116.625Mhz [default]
#
#   HPS_EMIF_ECC_EN :
#       - 0: disable [default]
#       - 1: enable 
#
#   HPS_CLK_SOURCE:
#      - 0: HPS External Oscillator [default]
#      - 1: FPGA Free Clock
#
#   RESET_WATCHDOG_EN:
#       - 0: disable [default]
#       - 1: enable
#
#   RESET_HPS_WARM_EN :
#       - 0: disable [default]
#       - 1: enable 
#
#   RESET_H2F_COLD_EN :
#       - 0: disable [default]
#       - 1: enable 
#
#   RESET_SDM_WATCHDOG_CFG :
#       - 0: HPS Cold Reset [default]
#       - 1: HPS Warm Reset
#       - 2: Trigger Remote Update
#
##demo:
##  hps_other_var0 :
##      - val00: val00_description [default]
##      - val01: val01_description
##  hps_other_var1 :
##      - val10: val10_description [default]
##      - val11: val11_description
#
# ->
#
#########################################################################


MAKE      := make
PWD       := $(shell pwd)
EMPTY     :=
ENABLE    := 1
DISABLE   := 0
SPACE     :=  
SLASH     := /
EQ        := =

CURRENT_FOLDER     :=  $(lastword $(subst $(SLASH), $(SPACE),$(PWD)))
PROJECT_ROOT       :=  $(PWD)/../
GHRD_CONFIG_FILE   :=  $(PROJECT_ROOT)/build/config.$(CURRENT_FOLDER)
GHRD_HELP_FILE     :=  $(PROJECT_ROOT)/build/help.$(CURRENT_FOLDER)
GHRD_SCRIPT_FILE   :=  $(PROJECT_ROOT)/scripts/config_parzer.awk


QSYS_ARGS_SUB := $(QSYS_ARGS)
QSYS_TCL_ARGS_SUB := $(QSYS_TCL_ARGS)

define filter_userval
$(strip $(foreach param, $(USER_CONFIG), $(if $(findstring $(strip $1),$(param)), $(param),$(EMPTY))))
endef

define append_args
    QSYS_TCL_ARGS_SUB += set $(word 1, $(subst $(EQ), $(EMPTY), $(call filter_userval,$1))) $(word 2, $(subst $(EQ), $(EMPTY), $(call filter_userval,$1)));
endef

#demo:
#ifneq ($(USER_CONFIG),)
#    $(eval $(call append_args, hps_other_var0))
#    $(eval $(call append_args, hps_other_var1))
#endif

ifeq ($(SUB_HPS_EN), $(DISABLE))
  ifeq ($(DAUGHTER_CARD),)
    SUB_HPS_EN=$(ENABLE)
    $(shell echo "force SUB_HPS_EN=1 because DAUGHTER_CARD is not set")
  endif

  ifeq ($(DAUGHTER_CARD),none)
    SUB_HPS_EN=$(ENABLE)
    $(shell echo "force SUB_HPS_EN=1 because DAUGHTER_CARD is none")
  endif
endif

.PHONY: generate_from_tcl
generate_from_tcl:
ifeq ($(SUB_HPS_EN), $(ENABLE))
	@qsys-script $(shell echo $(QSYS_ARGS) | sed 's/quartus-project=/quartus-project=..\//g') --script=./construct_subsys_hps.tcl --cmd="$(QSYS_TCL_ARGS_SUB)"
	@echo "compilation for from_tcl for $(CURRENT_FOLDER) done!"
else
	@echo "$(CURRENT_FOLDER) does not be enabled, skip."
endif

.PHONY: config
config:
	@awk -v config_file=$(GHRD_CONFIG_FILE) -v help_file=$(GHRD_HELP_FILE) -f $(GHRD_SCRIPT_FILE) Makefile

