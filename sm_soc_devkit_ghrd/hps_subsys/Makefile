########################################################################
# copyright
#
#
########################################################################


################## USER TOPLEVEL CONFIGURATION ##########################
#
# <-
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


MAKE  := make
PWD   := $(shell pwd)
EMPTY :=


PROJECT_ROOT       :=  $(PWD)/../
GHRD_CONFIG_FILE   :=  $(PROJECT_ROOT)/build/config.hps_subsys
GHRD_HELP_FILE     :=  $(PROJECT_ROOT)/build/help.hps_subsys
GHRD_SCRIPT_FILE   :=  $(PROJECT_ROOT)/scripts/config_parzer.awk

.PHONY: all
all:
	$(shell echo)
	qsys-script --quartus-project=./ghrd_a5ed065bb32ae5sr0.qpf --rev=ghrd_a5ed065bb32ae5sr0 --script=./construct_subsys_hps.tcl

.PHONY: config
config:
	@awk -v config_file=$(GHRD_CONFIG_FILE) -v help_file=$(GHRD_HELP_FILE) -f $(GHRD_SCRIPT_FILE) Makefile

