########################################################################
# copyright
#
#
########################################################################


################## USER TOPLEVEL CONFIGURATION ##########################
#
#   JTAG_EN :
#       - 0: disable
#       - 1: enable [default]
#
#########################################################################


MAKE  := make
PWD   := $(shell pwd)
EMPTY :=


PROJECT_ROOT       :=  $(PWD)/../
GHRD_CONFIG_FILE   :=  $(PROJECT_ROOT)/build/config.jtag_subsys
GHRD_HELP_FILE     :=  $(PROJECT_ROOT)/build/help.jtag_subsys
GHRD_SCRIPT_FILE   :=  $(PROJECT_ROOT)/scripts/config_parzer.awk

.PHONY: all
all:
	qsys-script --quartus-project=./ghrd_a5ed065bb32ae5sr0.qpf --rev=ghrd_a5ed065bb32ae5sr0 --script=./construct_subsys_hps.tcl

.PHONY: config
config:
	@awk -v config_file=$(GHRD_CONFIG_FILE) -v help_file=$(GHRD_HELP_FILE) -f $(GHRD_SCRIPT_FILE) Makefile

