########################################################################
# copyright
#
#
########################################################################


################## USER TOPLEVEL CONFIGURATION ##########################
#
# <-
#   SUB_FPGA_RGMII_EN :
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
SPACE     :=  
SLASH     := /

CURRENT_FOLDER     :=  $(lastword $(subst $(SLASH), $(SPACE),$(PWD)))
PROJECT_ROOT       :=  $(PWD)/../
GHRD_CONFIG_FILE   :=  $(PROJECT_ROOT)/build/config.$(CURRENT_FOLDER)
GHRD_HELP_FILE     :=  $(PROJECT_ROOT)/build/help.$(CURRENT_FOLDER)
GHRD_SCRIPT_FILE   :=  $(PROJECT_ROOT)/scripts/config_parzer.awk


.PHONY: generate_from_tcl
generate_from_tcl:
        ifeq ($(SUB_FPGA_RGMII_EN), $(ENABLE))
	    @qsys-script $(shell echo $(QSYS_ARGS) | sed 's/quartus-project=/quartus-project=..\//g') --script=./construct_subsys_fpga_rgmii.tcl --cmd="$(QSYS_TCL_ARGS)"
        else
	    @echo "$(CURRENT_FOLDER) does not be enabled, skip."
        endif
	@echo "generate_from_tcl for $(CURRENT_FOLDER)!"

.PHONY: config
config:
	@awk -v config_file=$(GHRD_CONFIG_FILE) -v help_file=$(GHRD_HELP_FILE) -f $(GHRD_SCRIPT_FILE) Makefile

