########################################################################
# copyright
#
#
########################################################################


################## USER TOPLEVEL CONFIGURATION ##########################
#
# <-
#   JTAG_EN :
#       - 0: disable
#       - 1: enable [default]
# ->
#
#########################################################################


MAKE      := make
PWD       := $(shell pwd)
EMPTY     :=
ENABLE    := 1
DISABLE   := 0


PROJECT_ROOT       :=  $(PWD)/../
GHRD_CONFIG_FILE   :=  $(PROJECT_ROOT)/build/config.jtag_subsys
GHRD_HELP_FILE     :=  $(PROJECT_ROOT)/build/help.jtag_subsys
GHRD_SCRIPT_FILE   :=  $(PROJECT_ROOT)/scripts/config_parzer.awk

.PHONY: generate_from_tcl
generate_from_tcl:
        ifeq ($(JTAG_EN), $(ENABLE))
	    @qsys-script $(shell echo $(QSYS_ARGS) | sed 's/quartus-project=/quartus-project=..\//g') --script=./construct_subsys_jtag_master.tcl $(QSYS_TCL_ARGS)
        else
	    @echo "jtag_subsys does not be enabled, skip."
        endif
	@echo "generate_from_tcl for jtag_subsys!"

.PHONY: config
config:
	@awk -v config_file=$(GHRD_CONFIG_FILE) -v help_file=$(GHRD_HELP_FILE) -f $(GHRD_SCRIPT_FILE) Makefile

