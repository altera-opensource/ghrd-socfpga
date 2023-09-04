########################################################################
# copyright
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
#       - 0: disable [default]
#       - 1: enable 
#   HPS_EMIF_ECC_EN :
#       - 0: disable [default]
#       - 1: enable 
#   HPS_HBME_EN :
#       - 0: disable [default]
#       - 1: enable 
# ->
#
#########################################################################


MAKE      := make
PWD       := $(shell pwd)
EMPTY     :=
ENABLE    := 1
DISABLE   := 0


PROJECT_ROOT       :=  $(PWD)/../
GHRD_CONFIG_FILE   :=  $(PROJECT_ROOT)/build/config.hps_subsys
GHRD_HELP_FILE     :=  $(PROJECT_ROOT)/build/help.hps_subsys
GHRD_SCRIPT_FILE   :=  $(PROJECT_ROOT)/scripts/config_parzer.awk

.PHONY: generate_from_tcl
generate_from_tcl:
        ifeq ($(HPS_EN), $(ENABLE))
	    @qsys-script --quartus-project=$(PROJECT_ROOT)/ghrd_a5ed065bb32ae5sr0.qpf --rev=ghrd_a5ed065bb32ae5sr0 --script=./construct_subsys_hps.tcl
        else
	    @echo "hps_subsys does not be enabled, skip."
        endif
	@echo "generate_from_tcl for hps_subsys done!"

.PHONY: config
config:
	@awk -v config_file=$(GHRD_CONFIG_FILE) -v help_file=$(GHRD_HELP_FILE) -f $(GHRD_SCRIPT_FILE) Makefile

