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
#       - 0: disable
#       - 1: enable [default] 
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
	    @qsys-script $(shell echo $(QSYS_ARGS) | sed 's/quartus-project=/quartus-project=..\//g') --script=./construct_subsys_hps.tcl \
            $(shell echo "" | awk -v qsys_tcl_args=$(QSYS_TCL_ARGS) -v prjroot=$(PROJECT_ROOT) '{split(qsys_tcl_args, a, "=");printf("%s=\"%s;set prjroot %s\"", a[1], a[2], prjroot)}')
        else
	    @echo "hps_subsys does not be enabled, skip."
        endif
	@echo "generate_from_tcl for hps_subsys done!"

.PHONY: config
config:
	@awk -v config_file=$(GHRD_CONFIG_FILE) -v help_file=$(GHRD_HELP_FILE) -f $(GHRD_SCRIPT_FILE) Makefile

