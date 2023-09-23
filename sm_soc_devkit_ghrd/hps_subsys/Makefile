######################################################################## # copyright
#
#
########################################################################


################## USER TOPLEVEL CONFIGURATION ##########################
#
# <-
#
#   HPS_EN:
#       - 0: disable
#       - 1: enable [default]
#   HPS_EMIF_EN :
#       - 0: disable
#       - 1: enable [default] 
#   HPS_EMIF_ECC_EN :
#       - 0: disable [default]
#       - 1: enable 
#   HPS_HBME_EN :
#       - 0: disable [default]
#       - 1: enable 
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

.PHONY: generate_from_tcl
generate_from_tcl:
ifeq ($(HPS_EN), $(ENABLE))
	@qsys-script $(shell echo $(QSYS_ARGS) | sed 's/quartus-project=/quartus-project=..\//g') --script=./construct_subsys_hps.tcl --cmd="$(QSYS_TCL_ARGS_SUB)"
	@echo "compilation for from_tcl for $(CURRENT_FOLDER) done!"
else
	@echo "$(CURRENT_FOLDER) does not be enabled, skip."
endif

.PHONY: config
config:
	@awk -v config_file=$(GHRD_CONFIG_FILE) -v help_file=$(GHRD_HELP_FILE) -f $(GHRD_SCRIPT_FILE) Makefile

