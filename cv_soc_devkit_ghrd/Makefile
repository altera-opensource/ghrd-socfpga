################################################
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2013-2020 Intel Corporation.
#
################################################
#
# Makefile to Manage Quartus Prime Pro / Platform Designer Design
#
################################################

SHELL := /bin/bash

.SUFFIXES: # Delete the default suffixes

################################################
# Tools

CAT := cat
CD := cd
CHMOD := chmod
CP := cp -rf
ECHO := echo
DATE := date
FIND := find
GREP := grep
HEAD := head
MKDIR := mkdir -p
MV := mv
RM := rm -rf
SED := sed
TAR := tar
TOUCH := touch
WHICH := which

# Helpful Macros
SPACE := $(empty) $(empty)

ifndef COMSPEC
ifdef ComSpec
COMSPEC = $(ComSpec)
endif # ComSpec
endif # COMSPEC

ifdef COMSPEC # if Windows OS
IS_WINDOWS_HOST := 1
endif

ifeq ($(IS_WINDOWS_HOST),1)
ifneq ($(shell $(WHICH) cygwin1.dll 2>/dev/null),)
IS_CYGWIN_HOST := 1
endif
endif

ifneq ($(shell $(WHICH) quartus 2>/dev/null),)
HAVE_QUARTUS := 1
endif

ifeq ($(HAVE_QUARTUS),1)
HAVE_QSYS := 1
endif

#<unused>
#ifneq ($(shell $(WHICH) quartus_pgm 2>/dev/null),)
#HAVE_QUARTUS_PGM := 1
#endif

################################################

################################################
#
# Design Settings
#  If you change and design settings, you need 
#  to run "make scrub_clean" followed by
#  "make generate_from_tcl" for the settings
#  to be applied
#

####
# Enable PCIe
ENABLE_PCIE ?= 0
ifeq ($(ENABLE_PCIE),1)
QUARTUS_TCL_ARGS += fpga_pcie 1
QSYS_TCL_CMDS += set fpga_pcie 1;
endif
# Merge QSYS_TCL_CMDS into a single QSys arg
ifneq ($(QSYS_TCL_CMDS),)
QSYS_TCL_ARGS += --cmd="$(QSYS_TCL_CMDS)"
endif


#
# End of Design Settings
#
################################################
.PHONY: default
default: help
################################################

################################################
.PHONY: all
ifeq ($(HAVE_QUARTUS),1)
all: sof rbf
endif
################################################

################################################
# Target Stamping

ifeq ($(QUARTUS_ROOTDIR),)
$(warning WARNING: QUARTUS_ROOTDIR not set)
endif

QUARTUS_VERSION = $(if $(wildcard $(QUARTUS_ROOTDIR)/version.txt),$(shell $(CAT) $(QUARTUS_ROOTDIR)/version.txt 2>/dev/null | $(GREP) Version | $(HEAD) -n1 | $(SED) -e 's,^Version[: \t=]*\([0-9.]*\).*,\1,g' 2>/dev/null))

define get_stamp_dir
stamp$(if $(QUARTUS_VERSION),/$(QUARTUS_VERSION))
endef

define get_stamp_target
$(get_stamp_dir)$(if $1,/$1.stamp,$(error ERROR: Arg 1 missing to $0 function))
endef

define stamp_target
@$(MKDIR) $(@D)
@$(TOUCH) $@
endef

.PHONY: clean
clean:
	@$(ECHO) "Cleaning stamp files (which will trigger rebuild)"
	@$(RM) $(get_stamp_dir)
	@$(ECHO) " TIP: Use 'make scrub_clean' to get a deeper clean"
################################################

################################################
# Archiving & Cleaning your QuartusII/QSys Project

AR_TIMESTAMP := $(if $(QUARTUS_VERSION),$(subst .,_,$(QUARTUS_VERSION))_)$(subst $(SPACE),,$(shell $(DATE) +%m%d%Y_%k%M%S))

AR_DIR := tgz
AR_FILE := $(AR_DIR)/$(basename $(firstword $(wildcard *.qpf)))_$(AR_TIMESTAMP).tar.gz

AR_REGEX += \
	Makefile ip readme.txt ds5 README.md license.txt\
	altera_avalon* *.qpf *.qsf *.sdc *.v *.sv *.vhd *.qsys *.tcl *.terp *.stp \
	*.sed quartus.ini *.sof *.rbf *.sopcinfo *.jdi \
	output_files/*.sof  output_files/*.rbf \
	hps_isw_handoff */*.svd */synthesis/*.svd */synth/*.svd *.xml

AR_FILTER_OUT += %_tb.qsys
################################################



################################################
# Build QuartusII/QSys Project
#

#############
# QSys
#CUSTOM_IP_DIR = $(shell pwd)/custom_ip/**/*

QSYS_FILE := soc_system.qsys
#QSYS_FILE := $(firstword $(wildcard *top*.qsys) $(wildcard *main*.qsys) $(wildcard *soc*.qsys) $(wildcard *.qsys))
#ifeq ($(QSYS_FILE),)
#$(error ERROR: QSYS_FILE *.qsys file not set and could not be discovered)
#endif
QSYS_DEPS += $(wildcard *.qsys)
QSYS_BASE := $(basename $(QSYS_FILE))
QSYS_QIP := $(wildard $(QSYS_BASE)/synthesis/$(QSYS_BASE).qip) $(wildcard $(QSYS_BASE)/$(QSYS_BASE).qip)
QSYS_SOPCINFO := $(QSYS_BASE).sopcinfo
QSYS_STAMP := $(call get_stamp_target,qsys)

#QSYS_ARGS += --search-path="$(CUSTOM_IP_DIR),$$"

# Under cygwin, ensure TMP env variable is not a cygwin style path
# before calling ip-generate
ifeq ($(IS_CYGWIN_HOST),1)
ifneq ($(shell $(WHICH) cygpath 2>/dev/null),)
SET_QSYS_GENERATE_ENV = TMP="$(shell cygpath -m "$(TMP)")"
endif
endif

.PHONY: qsys_compile
qsys_compile: $(QSYS_STAMP)

ifeq ($(HAVE_QSYS),1)
$(QSYS_SOPCINFO) $(QSYS_QIP): $(QSYS_STAMP)
endif

$(QSYS_STAMP): $(QSYS_DEPS)
	$(SET_QSYS_GENERATE_ENV) qsys-generate $(QSYS_FILE) --synthesis=VERILOG $(QSYS_ARGS) $(QSYS_GENERATE_ARGS)
	$(stamp_target)

HELP_TARGETS += qsys_edit

qsys_edit.HELP := Launch Platform Designer GUI
ifneq ($(HAVE_QSYS),1)
qsys_edit.HELP := $(qsys_edit.HELP) (Install Quartus Prime Standard Software to enable)
endif

.PHONY: qsys_edit
qsys_edit:
	qsys-edit $(QSYS_FILE) $(QSYS_ARGS) &


SCRUB_CLEAN_FILES += $(wildcard .qsys_edit)

ifeq ($(HAVE_QSYS),1)
SCRUB_CLEAN_FILES += $(QSYS_QIP) $(QSYS_SOPCINFO) $(QSYS_BASE)
endif

#############
# Quartus Prime Standard

#QUARTUS_QPF := $(firstword $(wildcard *.qpf))
QUARTUS_QPF := soc_system.qpf
ifeq ($(QUARTUS_QPF),)
$(error ERROR: QUARTUS_QPF *.qpf file not set and could not be discovered)
endif
QUARTUS_QSF := $(patsubst %.qpf,%.qsf,$(QUARTUS_QPF))
QUARTUS_BASE := $(basename $(QUARTUS_QPF))
QUARTUS_HDL_SOURCE := $(wildcard *.v *.sv *.vhd)
QUARTUS_MISC_SOURCE := $(wildcard *.stp *.sdc)

QUARTUS_PIN_ASSIGNMENTS_STAMP := $(call get_stamp_target,quartus_pin_assignments)
QUARTUS_DEPS += $(QUARTUS_QPF) $(QUARTUS_QSF) $(QUARTUS_HDL_SOURCE) $(QUARTUS_MISC_SOURCE) $(QSYS_STAMP) $(QSYS_QIP) $(QUARTUS_PIN_ASSIGNMENTS_STAMP)

QUARTUS_SOF := output_files/$(QUARTUS_BASE).sof
QUARTUS_STAMP := $(call get_stamp_target,quartus)

.PHONY: quartus_compile
quartus_compile: $(QUARTUS_STAMP)

ifeq ($(HAVE_QUARTUS),1)
$(QUARTUS_SOF): $(QUARTUS_STAMP)
endif

$(QUARTUS_PIN_ASSIGNMENTS_STAMP): $(QSYS_STAMP)
	quartus_map $(QUARTUS_QPF)
	quartus_cdb --merge $(QUARTUS_QPF)
	$(MAKE) quartus_apply_tcl_pin_assignments QUARTUS_ENABLE_PIN_ASSIGNMENTS_APPLY=1
	$(stamp_target)

#######
# we need to recursively call this makefile to
# apply *_pin_assignments.tcl script because the
# pin_assignment.tcl files may not exist yet
# when makefile was originally called

ifeq ($(QUARTUS_ENABLE_PIN_ASSIGNMENTS_APPLY),1)

QUARTUS_TCL_PIN_ASSIGNMENTS = $(wildcard $(QSYS_BASE)/synthesis/submodules/*_pin_assignments.tcl) $(wildcard $(QSYS_BASE)/synth/submodules/*_pin_assignments.tcl)
QUARTUS_TCL_PIN_ASSIGNMENTS_APPLY_TARGETS = $(patsubst %,quartus_apply_tcl-%,$(QUARTUS_TCL_PIN_ASSIGNMENTS))

.PHONY: quartus_apply_tcl_pin_assignments
quartus_apply_tcl_pin_assignments: $(QUARTUS_TCL_PIN_ASSIGNMENTS_APPLY_TARGETS)

.PHONY: $(QUARTUS_TCL_PIN_ASSIGNMENTS_APPLY_TARGETS)
$(QUARTUS_TCL_PIN_ASSIGNMENTS_APPLY_TARGETS): quartus_apply_tcl-%: %
	@$(ECHO) "Applying $<... to $(QUARTUS_QPF)..."
	quartus_sta -t $< $(QUARTUS_QPF)

endif # QUARTUS_ENABLE_PIN_ASSIGNMENTS_APPLY == 1
######

$(QUARTUS_STAMP): $(QUARTUS_DEPS)
	quartus_stp $(QUARTUS_BASE)
	quartus_sh --flow compile $(QUARTUS_QPF)
	$(stamp_target)

HELP_TARGETS += quartus_edit
quartus_edit.HELP := Launch Quartus Prime Standard GUI

ifneq ($(HAVE_QUARTUS),1)
quartus_edit.HELP := $(quartus_edit.HELP) (Install Quartus Prime Standard Software to enable)
endif


.PHONY: quartus_edit
quartus_edit:
	quartus $(QUARTUS_QPF) &

HELP_TARGETS += sof
sof.HELP := QSys generate & Quartus compile this design
ifneq ($(HAVE_QUARTUS),1)
sof.HELP := $(sof.HELP) (Install Quartus Prime Standard Software to enable)
endif

BATCH_TARGETS += sof

.PHONY: sof
sof: $(QUARTUS_SOF)


QUARTUS_RBF := $(patsubst %.sof,%.rbf,$(QUARTUS_SOF))
#
# This converts the sof into compressed, unencrypted
# raw binary format corresponding to MSEL value of 8
# in the FPGAMGRREGS_STAT register. If you read the
# the whole register, it should be 0x50.
#
# CVSoC DevBoard SW1 MSEL should be set to up,down,up,down,up,up
#

ifeq ($(HAVE_QUARTUS),1)
$(QUARTUS_RBF): $(QUARTUS_STAMP)
endif

QUARTUS_CPF_ENABLE_COMPRESSION ?= 1
ifeq ($(QUARTUS_CPF_ENABLE_COMPRESSION),1)
QUARTUS_CPF_ARGS += -o bitstream_compression=on
endif

$(QUARTUS_RBF): %.rbf: %.sof
	quartus_cpf -c $(QUARTUS_CPF_ARGS) $< $@

.PHONY: rbf
rbf: $(QUARTUS_RBF)

.PHONY: create_rbf
create_rbf:
	quartus_cpf -c $(QUARTUS_CPF_ARGS) $(QUARTUS_SOF) $(QUARTUS_RBF)


ifeq ($(HAVE_QUARTUS),1)
SCRUB_CLEAN_FILES += $(QUARTUS_SOF) $(QUARTUS_RBF) output_files hps_isw_handoff
endif

################################################


################################################
# QSYS/Quartus Project Generation
#  - we don't run this generation step automatically because
#    it will destroy any changes and/or customizations that
#    you've made to your qsys or your quartus project
#
QSYS_QSYS_GEN := $(firstword $(wildcard create_*_qsys.tcl))
QUARTUS_TOP_GEN := $(firstword $(wildcard create_*_top.tcl))
QUARTUS_QSF_QPF_GEN := $(firstword $(wildcard create_*_quartus.tcl))

.PHONY: quartus_generate_qsf_qpf
ifneq ($(QUARTUS_QSF_QPF_GEN),)
quartus_generate_qsf_qpf: $(QUARTUS_QSF_QPF_GEN)
	$(RM) $(QUARTUS_QSF) $(QUARTUS_QPF)
	quartus_sh --script=$< $(QUARTUS_TCL_ARGS)
else
quartus_generate_qsf_qpf:
	@$(ECHO) "Make target '$@' is not supported for this design"
endif

.PHONY: quartus_generate_top
ifneq ($(QUARTUS_TOP_GEN),)
quartus_generate_top: $(QUARTUS_TOP_GEN)
	@$(RM) *_top.v
	quartus_sh --script=$< $(QUARTUS_TCL_ARGS)
else
quartus_generate_top:
	@$(ECHO) "Make target '$@' is not supported for this design"
endif

.PHONY: qsys_generate_qsys
ifneq ($(QSYS_QSYS_GEN),)

# Note that this target has a strange & known issue
# that requires the Stratix V device family to be installed.
# If the stratix V device family is not installed then the target
# will hang. This issue will hopefully be resolved in a future
# version of quartus/qsys.

qsys_generate_qsys: $(QSYS_QSYS_GEN)
	$(RM) $(QSYS_FILE)
	qsys-script $(QSYS_ARGS) --script=$< $(QSYS_TCL_ARGS)
else
qsys_generate_qsys:
	@$(ECHO) "Make target '$@' is not supported for this design"
endif

HELP_TARGETS += generate_from_tcl
generate_from_tcl.HELP := Generate the Quartus Project source files from tcl script source

.PHONY: generate_from_tcl
generate_from_tcl:
	$(MAKE) -s scrub_clean
	$(MAKE) quartus_generate_qsf_qpf quartus_generate_top qsys_generate_qsys

################################################


################################################
# Quartus Programming
QUARTUS_PGM_STAMP := $(call get_stamp_target,quartus_pgm)

# set these for your board
# BOARD_CABLE =

# FPGA Board Device Index. Default to 2 since this is the most
#  common setting for dev board
# For SoCKIT board, this should be set to 1
BOARD_DEVICE_INDEX ?= 2

define quartus_pgm_sof
jtagconfig
quartus_pgm --mode=jtag $(if $(BOARD_CABLE),--cable="$(BOARD_CABLE)") --operation=p\;$1$(if $(BOARD_DEVICE_INDEX),"@$(BOARD_DEVICE_INDEX)")
jtagconfig $(if $(BOARD_CABLE),-c "$(BOARD_CABLE)") -n
endef

.PHONY: pgm
pgm: $(QUARTUS_PGM_STAMP)

$(QUARTUS_PGM_STAMP): $(QUARTUS_SOF)
	$(call quartus_pgm_sof,$<)
	$(stamp_target)

HELP_TARGETS += program_fpga
program_fpga.HELP := Quartus program sof to your attached dev board

.PHONY: program_fpga
program_fpga:
	$(call quartus_pgm_sof,$(QUARTUS_SOF))

# GHRD HPS Reset Targets
ifneq ($(wildcard ghrd_reset.tcl),)
# use the already programmed fpga to reset the hps
HPS_RESET_TARGETS := hps_cold_reset hps_warm_reset hps_debug_reset

.PHONY: $(HPS_RESET_TARGETS)
$(HPS_RESET_TARGETS): hps_%_reset:
	quartus_stp --script=ghrd_reset.tcl $(if $(BOARD_CABLE),--cable-name "$(BOARD_CABLE)") $(if $(BOARD_DEVICE_INDEX),--device-index "$(BOARD_DEVICE_INDEX)") --$*-reset
endif

################################################

################################################
# Clean-up and Archive

AR_FILES += $(filter-out $(AR_FILTER_OUT),$(wildcard $(AR_REGEX)))

CLEAN_FILES += $(filter-out $(AR_DIR) $(AR_FILES),$(wildcard *))

HELP_TARGETS += tgz
tgz.HELP := Create a tarball with the barebones source files that comprise this design

.PHONY: tarball tgz
tarball tgz: $(AR_FILE)

$(AR_FILE):
	@$(MKDIR) $(@D)
	@$(if $(wildcard $(@D)/*.tar.gz),$(MKDIR) $(@D)/.archive;$(MV) $(@D)/*.tar.gz $(@D)/.archive)
	@$(ECHO) "Generating $@..."
	@$(TAR) -czf $@ $(AR_FILES)

SCRUB_CLEAN_FILES += $(CLEAN_FILES)

HELP_TARGETS += scrub_clean
scrub_clean.HELP := Restore design to its barebones state

.PHONY: scrub scrub_clean
scrub scrub_clean:
	$(if $(strip $(wildcard $(SCRUB_CLEAN_FILES))),$(RM) $(wildcard $(SCRUB_CLEAN_FILES)),@$(ECHO) "You're already as clean as it gets!")

.PHONY: tgz_scrub_clean
tgz_scrub_clean:
	$(FIND) $(SOFTWARE_DIR) \( -name '*.o' -o -name '.depend*' -o -name '*.d' -o -name '*.dep' \) -delete || true
	$(MAKE) tgz AR_FILE=$(AR_FILE)
	$(MAKE) -s scrub_clean
	$(TAR) -xzf $(AR_FILE)

################################################


################################################
# Running Batch Jobs
ifneq ($(BATCH_TARGETS),)

BATCH_DIR := $(if $(TMP),$(TMP)/)batch/$(AR_TIMESTAMP)

.PHONY: $(patsubst %,batch-%,$(BATCH_TARGETS))
$(patsubst %,batch-%,$(BATCH_TARGETS)): batch-%: $(AR_FILE)
	@$(RM) $(BATCH_DIR)
	@$(MKDIR) $(BATCH_DIR)
	$(CP) $< $(BATCH_DIR)
	$(CD) $(BATCH_DIR) && $(TAR) -xzf $(notdir $<) && $(CHMOD) -R 755 *
	$(MAKE) -C $(BATCH_DIR) $*

endif # BATCH_TARGETS != <empty>
################################################


################################################
# Help system

HELP_TARGETS += help
help.HELP := Displays this info (i.e. the available targets)

.PHONY: help
help: help-init help-targets help-fini

HELP_TARGETS_X := $(patsubst %,help-%,$(sort $(HELP_TARGETS)))
.PHONY: $(HELP_TARGETS_X)
help-targets: $(HELP_TARGETS_X)
$(HELP_TARGETS_X): help-%:
	@$(ECHO) "*********************"
	@$(ECHO) "* Target: $*"
	@$(ECHO) "*   $($*.HELP)"

.PHONY: help-init
help-init:
	@$(ECHO) "***************************************************************"
	@$(ECHO) "*                                                             *"
	@$(ECHO) "* Manage Quartus Prime Standard / Platform Designer design    *"
	@$(ECHO) "*                                                             *"
	@$(ECHO) "*     Copyright (c) 2020                                      *"
	@$(ECHO) "*     All Rights Reserved                                     *"
	@$(ECHO) "*                                                             *"
	@$(ECHO) "***************************************************************"
	@$(ECHO) ""

.PHONY: help-fini
help-fini:
	@$(ECHO) "*********************"

################################################
