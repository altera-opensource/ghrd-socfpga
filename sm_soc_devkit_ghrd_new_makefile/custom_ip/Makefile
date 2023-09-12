########################################################################
# copyright
#
#
########################################################################


################## USER TOPLEVEL CONFIGURATION ##########################
#
#   CUSTOM_IP :
#       - 0: disable
#       - 1: enable [default]
#
#########################################################################


MAKE  := make
PWD   := $(shell pwd)
EMPTY :=


PROJECT_ROOT       :=  $(PWD)/../
GHRD_CONFIG_FILE   :=  $(PROJECT_ROOT)/build/config.custom_ip
GHRD_HELP_FILE     :=  $(PROJECT_ROOT)/build/help.custome_ip
GHRD_SCRIPT_FILE   :=  $(PROJECT_ROOT)/scripts/config_parzer.awk

.PHONY: all
all:
	$(shell echo)

.PHONY: config
config:
	@awk -v config_file=$(GHRD_CONFIG_FILE) -v help_file=$(GHRD_HELP_FILE) -f $(GHRD_SCRIPT_FILE) Makefile

