################################################
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2014-2020 Intel Corporation.
#
################################################
#
# Makefile to Manage Quartus Prime Pro / QSys Design
#
################################################

SHELL := /bin/bash

.SECONDEXPANSION:
.SUFFIXES:

################################################
# Tools

CAT := cat
CD := cd
CHMOD := chmod
CP := cp -rf
DATE := date
ECHO := echo
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

ifeq ($(QUARTUS_EDITION_OVERRIDE),pro)
HAVE_QUARTUS_PRO := 1
endif

ifeq ($(QUARTUS_EDITION_OVERRIDE),)
ifneq ($(QUARTUS_ROOTDIR),)

QUARTUS_EDITION := $(shell $(CAT) $(QUARTUS_ROOTDIR)/version.txt 2>/dev/null | $(GREP) '^Edition=' | $(HEAD) -n1 | $(SED) -e 's,^Edition=*\([0-9a-zA-Z]*\).*,\1,g' 2>/dev/null)

ifeq ($(QUARTUS_EDITION),pro)
HAVE_QUARTUS_PRO := 1
endif # QUARTUS_EDITION==pro

endif # QUARTUS_ROOTDIR==<empty_string>
endif # QUARTUS_EDITION_OVERRIDE==<empty_string>

endif # HAVE_QUARTUS==1

ifeq ($(HAVE_QUARTUS),1)
HAVE_QSYS := 1
endif

ifeq ($(HAVE_QUARTUS_PRO),1)
# QSys Classic not supported with Quartus Pro. QSys Pro must be
# used with Quartus Pro
HAVE_QSYS_PRO := 1
endif

ifeq ($(HAVE_QUARTUS_PRO),1)
$(error ERROR: This build is not supported with Quartus Pro)
endif

ifeq ($(HAVE_QSYS_PRO),1)
$(error ERROR: This build is not supported with QSys Pro)
endif

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
# Family and Device
# QUARTUS_DEVICE to Board Revision Mapping
#   Rev A Board: 10AS066N2F40I2SGES  [SoCEDS v15.1]
#   Rev B Board: 10AS066N3F40E2SGE2  [SoCEDS v15.1.1]
#   Rev C Board: 10AS066N3F40E2SG    [>= SoCEDS v16.0]

QUARTUS_DEVICE_FAMILY := Arria\ 10
QUARTUS_DEVICE ?= 10AS066N3F40E2SG
BOARD_REV ?= C

ifneq ($(QUARTUS_DEVICE_FAMILY),)
QUARTUS_TCL_ARGS += devicefamily $(QUARTUS_DEVICE_FAMILY)
QSYS_TCL_CMDS += set devicefamily $(QUARTUS_DEVICE_FAMILY);
endif

ifneq ($(QUARTUS_DEVICE),)
QUARTUS_TCL_ARGS += device $(QUARTUS_DEVICE)
QSYS_TCL_CMDS += set device $(QUARTUS_DEVICE);
endif

ifneq ($(BOARD_REV),)
QUARTUS_TCL_ARGS += board_rev $(BOARD_REV)
QSYS_TCL_CMDS += set board_rev $(BOARD_REV);
endif


####
ifeq ($(HAVE_QSYS_PRO),1)
QUARTUS_TCL_ARGS += qsys_pro $(HAVE_QSYS_PRO)
QSYS_TCL_CMDS += set qsys_pro $(HAVE_QSYS_PRO);
endif


####
# hps_sdram: input of memory device FBGA code to identify EMIF configuration for targeted memory. 
#   D9RPL = "MT41K512M16TNA-107" DDR3 Dual Ranks at 800MHz,
#   D9PZN = "MT41J256M16HA-093" DDR3 Single Rank at 1066MHz,
#   D9RGX = "MT40A256M16HA-093E:A" DDR4 Single Rank at 1066MHzx

HPS_SDRAM_SETTING ?= D9RGX
ifneq ($(HPS_SDRAM_SETTING),)
QUARTUS_TCL_ARGS += hps_sdram $(HPS_SDRAM_SETTING)
QSYS_TCL_CMDS += set hps_sdram $(HPS_SDRAM_SETTING);
endif


####
# Enable HPS_SDRAM ECC
ENABLE_HPS_SDRAM_ECC ?= 0
QUARTUS_TCL_ARGS += hps_sdram_ecc $(ENABLE_HPS_SDRAM_ECC)
QSYS_TCL_CMDS += set hps_sdram_ecc $(ENABLE_HPS_SDRAM_ECC);


####
# Enable Fast Trace (16bit trace through fpga core)
HPS_ENABLE_16BIT_TRACE ?= 0
ifeq ($(HPS_ENABLE_16BIT_TRACE),1)
QUARTUS_TCL_ARGS += fast_trace 1
QSYS_TCL_CMDS += set fast_trace 1;
endif


####
# Enable SGMII
HPS_ENABLE_SGMII ?= 0
HPS_SGMII_COUNT ?= 2
ifeq ($(HPS_ENABLE_SGMII),1)
QUARTUS_TCL_ARGS += hps_sgmii 1 sgmii_count $(HPS_SGMII_COUNT)
QSYS_TCL_CMDS += set hps_sgmii 1; set sgmii_count $(HPS_SGMII_COUNT);
endif


####
# hps_boot_device: select which pins the dedicated io will boot from
#   SDMMC = Boot from SD/MMC
#   QSPI  = Boot from QSPI
#   NAND  = Boot from NAND
HPS_BOOT_DEVICE ?= SDMMC
ifneq ($(HPS_BOOT_DEVICE),)
QUARTUS_TCL_ARGS += boot_device $(HPS_BOOT_DEVICE)
QSYS_TCL_CMDS += set boot_device $(HPS_BOOT_DEVICE);
endif

####
# Boot Selection override
# To override the Boot Select pins by the fgpa image,
# set the variable, BSEL, to one of the following integers:
# 	0 - RESERVED 
# 	1 - FPGA 
# 	2 - NAND Flash (1.8v) 
# 	3 - NAND Flash (3.0v) 
# 	4 - SD/MMC External Transceiver (1.8v) 
# 	5 - SD/MMC Internal Transceiver (3.0v) 
# 	6 - Quad SPI Flash (1.8v) 
# 	7 - Quad SPI Flash (3.0v)

ifneq ($(BSEL),)
QSYS_TCL_CMDS += set bsel $(BSEL);
endif

####
# Enable Early IO Release
ENABLE_EARLY_IO_RELEASE ?= 1
ifeq ($(ENABLE_EARLY_IO_RELEASE),1)
QUARTUS_TCL_ARGS += early_io_release 1
QSYS_TCL_CMDS += set early_io_release 1;
QUARTUS_CPF_ENABLE_SPLIT_RBF := 1
else
QUARTUS_CPF_ENABLE_SPLIT_RBF := 0
endif

####
# Enable PCIe
ENABLE_PCIE ?= 0
ifeq ($(ENABLE_PCIE),1)
QUARTUS_TCL_ARGS += fpga_pcie 1
QSYS_TCL_CMDS += set fpga_pcie 1;
endif

####
# Add SPIM0 to the FPGA. This is useful for testing
# the SPIM IP on the A10 dev kit in loopback mode
# since SPIM1 is connected to the Max V.
# SPIM1 will not be affected by this change.
# 1 is enabled
# 0 is disabled
SPIM0_EN ?= 0
ifeq ($(SPIM0_EN),1)
QSYS_TCL_CMDS += set spim0_en $(SPIM0_EN);
endif

####
# HPS Secure Boot

ENABLE_ENCRYPTION ?= 0
ENCRYPTION_KEY_FILE := encrypt.key
ENCRYPTION_KEY := key1

# Merge QSYS_TCL_CMDS into a single QSys arg
ifneq ($(QSYS_TCL_CMDS),)
QSYS_TCL_ARGS += --cmd="$(QSYS_TCL_CMDS)"
endif


#
# End of Design Settings
#
################################################




################################################
.PHONY: default
default: help
################################################

################################################
.PHONY: all
ifeq ($(HAVE_QUARTUS),1)
all: rbf sof

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

SOFTWARE_DIR := software
BOOTLOADER_DIR := $(SOFTWARE_DIR)/bootloader
BOOTLOADER_EXT_CFG_DIR := $(SOFTWARE_DIR)/bootloader_ext_cfg

AR_REGEX += \
	Makefile ip readme.txt ds5 README.md license.txt\
	altera_avalon* *.qpf *.qsf *.sdc *.v *.sv *.vhd *.qsys *.tcl *.terp *.stp *.mk \
	*.sed quartus.ini *.sof *.rbf *.sopcinfo *.jdi \
	output_files/*.sof output_files/*.rbf \
	hps_isw_handoff */*.svd */synthesis/*.svd */synth/*.svd *.dts *.dtb *.xml


AR_FILTER_OUT += %_tb.qsys
################################################



################################################
# Build QuartusII/QSys Project
#

#############
# QSys
#CUSTOM_IP_DIR = $(shell pwd)/custom_ip/**/*

QSYS_FILE_TOP := ghrd_10as066n2.qsys
#QSYS_FILE_TOP := $(firstword $(wildcard *top*.qsys) $(wildcard ghrd*.qsys) $(wildcard *main*.qsys) $(wildcard *soc*.qsys) $(wildcard *.qsys))

OTHER_QSYS_FILES :=

QSYS_FILES += $(QSYS_FILE_TOP) $(OTHER_QSYS_FILES)

ifeq ($(QSYS_FILE_TOP),)
$(error ERROR: QSYS_FILE_TOP *.qsys file not set and could not be discovered)
endif

QSYS_DEPS += $(sort $(QSYS_FILES) $(wildcard *.qsys))

QSYS_BASE_TOP := $(basename $(QSYS_FILE_TOP))
QSYS_GEN_DIRS := $(foreach qsys_file,$(QSYS_FILES),$(dir $(qsys_file))$(notdir $(basename $(qsys_file))))

ifneq ($(HAVE_QUARTUS_PRO),1)
QSYS_QIP_FILES := $(foreach qsys_file,$(QSYS_FILES),$(dir $(qsys_file))$(notdir $(basename $(qsys_file)))/synthesis/$(basename $(notdir $(qsys_file))).qip)
else
QSYS_QIP_FILES := $(foreach qsys_file,$(QSYS_FILES),$(dir $(qsys_file))$(notdir $(basename $(qsys_file)))/$(basename $(notdir $(qsys_file))).qip)
endif

QSYS_SOPCINFO := $(QSYS_BASE_TOP).sopcinfo
QSYS_STAMP := $(foreach qsys_file,$(QSYS_FILES),$(call get_stamp_target,$(qsys_file).qsys_gen))

#QSYS_ARGS += --search-path="$(CUSTOM_IP_DIR),$$"
# Under cygwin, ensure TMP env variable is not a cygwin style path
# before calling qsys-generate
ifeq ($(IS_CYGWIN_HOST),1)
ifneq ($(shell $(WHICH) cygpath 2>/dev/null),)
SET_QSYS_GENERATE_ENV = TMP="$(shell cygpath -m "$(TMP)")"
endif
endif

.PHONY: qsys_compile
qsys_compile: $(QSYS_STAMP)

ifeq ($(HAVE_QSYS),1)
$(QSYS_SOPCINFO) $(QSYS_QIP_FILES): $(QSYS_STAMP)
endif

ifeq ($(HAVE_QSYS_PRO),1)
QSYS_ARGS += --pro
QSYS_ARGS += --quartus-project=$(QUARTUS_QPF)
QSYS_ARGS += --rev=$(QUARTUS_BASE_REVISION)
QSYS_GENERATE_ARGS += --pro
endif

$(QSYS_STAMP): $(get_stamp_dir)/%.qsys_gen.stamp: % $(QSYS_DEPS)
	$(SET_QSYS_GENERATE_ENV) qsys-generate $(QSYS_GENERATE_ARGS) $< --upgrade-ip-cores $(QSYS_ARGS)
	$(SET_QSYS_GENERATE_ENV) qsys-generate $(QSYS_GENERATE_ARGS) $< --synthesis=VERILOG $(QSYS_ARGS)
	$(stamp_target)

HELP_TARGETS += qsys_edit

qsys_edit.HELP := Launch Platform Designer GUI
ifneq ($(HAVE_QSYS),1)
qsys_edit.HELP := $(qsys_edit.HELP) (Install Quartus Prime Standard Software to enable)
endif

.PHONY: qsys_edit
qsys_edit:
	qsys-edit $(QSYS_FILE_TOP) $(QSYS_ARGS) &


SCRUB_CLEAN_FILES += $(wildcard .qsys_edit)

ifeq ($(HAVE_QSYS),1)
SCRUB_CLEAN_FILES += $(QSYS_QIP_FILES) $(QSYS_SOPCINFO) $(QSYS_GEN_DIRS)
endif

#############
# Quartus Prime Standard

QUARTUS_QPF := ghrd_10as066n2.qpf
ifeq ($(QUARTUS_QPF),)
$(error ERROR: QUARTUS_QPF *.qpf file not set and could not be discovered)
endif
QUARTUS_BASE := $(basename $(QUARTUS_QPF))
QUARTUS_HDL_SOURCE := $(wildcard *.v *.sv *.vhd)
QUARTUS_MISC_SOURCE := $(wildcard *.stp *.sdc)
QUARTUS_BASE_REVISION := $(QUARTUS_BASE)
QUARTUS_QSF := $(QUARTUS_BASE_REVISION).qsf

QUARTUS_DEPS += $(QUARTUS_QPF) $(QUARTUS_QSF) $(QUARTUS_HDL_SOURCE) $(QUARTUS_MISC_SOURCE) $(QSYS_STAMP) $(QSYS_QIP_FILES)

QUARTUS_OUTPUT_DIR := output_files
QUARTUS_SOF := $(QUARTUS_OUTPUT_DIR)/$(QUARTUS_BASE).sof
QUARTUS_STAMP := $(call get_stamp_target,quartus)

.PHONY: quartus_compile
quartus_compile: $(QUARTUS_STAMP)

ifeq ($(HAVE_QUARTUS),1)
$(QUARTUS_SOF): $(QUARTUS_STAMP)
endif

$(QUARTUS_STAMP): $(QUARTUS_DEPS)
	quartus_stp $(QUARTUS_BASE) -c $(QUARTUS_BASE_REVISION)
	quartus_sh --flow compile $(QUARTUS_QPF) -c $(QUARTUS_BASE_REVISION)
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

#
# This converts the sof into compressed, unencrypted 
# raw binary format
#
ifeq ($(QUARTUS_CPF_ENABLE_SPLIT_RBF),1)

QUARTUS_CPF_ARGS += --hps

ifeq ($(ENABLE_ENCRYPTION),1)
QUARTUS_CORE_RBF := $(patsubst %.sof,%-encrypted.core.rbf,$(QUARTUS_SOF))
QUARTUS_PERIPH_RBF := $(patsubst %.sof,%-encrypted.periph.rbf,$(QUARTUS_SOF))
else # if encryption not enabled
QUARTUS_CORE_RBF := $(patsubst %.sof,%.core.rbf,$(QUARTUS_SOF))
QUARTUS_PERIPH_RBF := $(patsubst %.sof,%.periph.rbf,$(QUARTUS_SOF))
endif # ENABLE_ENCRYPTION == 1

QUARTUS_RBF := $(QUARTUS_CORE_RBF) $(QUARTUS_PERIPH_RBF)

else # if split rbf not enabled

ifeq ($(ENABLE_ENCRYPTION),1)
QUARTUS_RBF := $(patsubst %.sof,%-encrypted.rbf,$(QUARTUS_SOF))
else # if encryption not enabled
QUARTUS_RBF := $(patsubst %.sof,%.rbf,$(QUARTUS_SOF))
endif # ENABLE_ENCRYPTION == 1

endif # QUARTUS_CPF_ENABLE_SPLIT_RBF == 1

#####################

ifeq ($(ENABLE_ENCRYPTION),1)
QUARTUS_CPF_ENABLE_COMPRESSION := 0
QUARTUS_CPF_ENCRYPT_ARGS := --key "$(BOOTLOADER_DIR)/$(ENCRYPTION_KEY_FILE):$(ENCRYPTION_KEY)"
QUARTUS_CPF_DEPS += $(BOOTLOADER_DIR)/$(ENCRYPTION_KEY_FILE)
QUARTUS_CPF_ARGS += $(QUARTUS_CPF_ENCRYPT_ARGS)
endif

QUARTUS_CPF_ENABLE_COMPRESSION ?= 1
ifeq ($(QUARTUS_CPF_ENABLE_COMPRESSION),1)
QUARTUS_CPF_ARGS += -o bitstream_compression=on
endif

#######
# ENCRYPTION Sanity Checks
ifeq ($(ENABLE_ENCRYPTION),1)
ifeq ($(QUARTUS_CPF_ENABLE_COMPRESSION),1)
$(error ERROR: ENCRYPTION and COMPRESSION cannot be enabled simultaneously)
endif
ifeq ($(IS_WINDOWS_HOST),1)
$(error ERROR: Bootloader Encryption is not supported on Windows Host)
endif
endif
#######

ifeq ($(HAVE_QUARTUS),1)
QUARTUS_RBF_STAMP := $(call get_stamp_target,quartus_rbf)
$(QUARTUS_RBF_STAMP): $(QUARTUS_STAMP)
endif

.PHONY: rbf
rbf: $(QUARTUS_RBF)

$(QUARTUS_RBF): $(QUARTUS_RBF_STAMP)

QUARTUS_CPF_RBF_ARG := $(patsubst %.sof,%.rbf,$(QUARTUS_SOF))
ifeq ($(ENABLE_ENCRYPTION),1)
QUARTUS_CPF_RBF_ARG :=  $(patsubst %.rbf,%-encrypted.rbf,$(QUARTUS_CPF_RBF_ARG))
endif

$(QUARTUS_RBF_STAMP): $(QUARTUS_CPF_DEPS)
	@$(MKDIR) $(dir $(QUARTUS_RBF))
	quartus_cpf --convert $(QUARTUS_CPF_ARGS) $(QUARTUS_SOF) $(QUARTUS_CPF_RBF_ARG)
	$(stamp_target)


ifeq ($(ENABLE_ENCRYPTION),1)
QUARTUS_EKP := $(patsubst %.sof,%.ekp,$(QUARTUS_SOF))
$(QUARTUS_RBF): $(QUARTUS_EKP)
.PHONY: ekp
$(QUARTUS_EKP) ekp: $(QUARTUS_CPF_DEPS)
	quartus_cpf $(QUARTUS_CPF_ENCRYPT_ARGS) $(QUARTUS_SOF) $(QUARTUS_EKP)
endif


ifeq ($(HAVE_QUARTUS),1)
SCRUB_CLEAN_FILES += $(QUARTUS_SOF) $(QUARTUS_RBF) $(QUARTUS_OUTPUT_DIR) hps_isw_handoff $(QUARTUS_EKP)
endif

################################################


################################################
# QSYS/Quartus Project Generation
#  - we don't run this generation step automatically because 
#    it will destroy any changes and/or customizations that 
#    you've made to your qsys, top level hdl or your quartus 
#    project
#
QSYS_QSYS_GEN := $(firstword $(wildcard create_*_qsys.tcl))
QUARTUS_TOP_GEN := $(firstword $(wildcard create_*_top.tcl))
QUARTUS_QSF_QPF_GEN := $(firstword $(wildcard create_*_quartus.tcl))

.PHONY: quartus_generate_qsf_qpf
ifneq ($(QUARTUS_QSF_QPF_GEN),)
quartus_generate_qsf_qpf: $(QUARTUS_QSF_QPF_GEN)
	@$(RM) $(QUARTUS_QSF) $(QUARTUS_QPF)
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

ifeq ($(HAVE_QSYS_PRO),1)
QSYS_GEN_QSYS_DEPS += quartus_generate_qsf_qpf
endif

.PHONY: qsys_generate_qsys
ifneq ($(QSYS_QSYS_GEN),)
qsys_generate_qsys: $(QSYS_QSYS_GEN) $(QSYS_GEN_QSYS_DEPS)
	@$(RM) $(QSYS_FILE_TOP)
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

# set this correctly for your board. If not set, assume the first board
# is your board
CLOSE_PARENTHESIS = )
BOARD_CABLE ?= $(shell jtagconfig | head -n1 | sed -e 's,[0-9]*[$(CLOSE_PARENTHESIS)][ \t]*,,')

# FPGA Board Device Index. Default to 1 since this is the most
#  common setting for a10 dev board
BOARD_DEVICE_INDEX ?= 1

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
################################################

################################################
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
	@$(ECHO) "******************************************************"
	@$(ECHO) "*                                                    *"
	@$(ECHO) "* Manage Quartus Prime Standard / Platform Designer design    *"
	@$(ECHO) "*                                                    *"
	@$(ECHO) "*     Copyright (c) 2016                             *"
	@$(ECHO) "*     All Rights Reserved                            *"
	@$(ECHO) "*                                                    *"
	@$(ECHO) "******************************************************"
	@$(ECHO) ""

.PHONY: help-fini
help-fini:
	@$(ECHO) "*********************"

################################################
