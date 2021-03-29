################################################
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2017-2020 Intel Corporation.
#
################################################
#
# Makefile to Manage Quartus Prime Pro / QSys Design
#
################################################

SHELL := /bin/bash

.SECONDEXPANSION:
.SUFFIXES:
.DELETE_ON_ERROR:

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

# Convert upper case string to lower case string
lc = $(subst A,a,$(subst B,b,$(subst C,c,$(subst D,d,$(subst E,e,$(subst F,f,$(subst G,g,$(subst H,h,$(subst I,i,$(subst J,j,$(subst K,k,$(subst L,l,$(subst M,m,$(subst N,n,$(subst O,o,$(subst P,p,$(subst Q,q,$(subst R,r,$(subst S,s,$(subst T,t,$(subst U,u,$(subst V,v,$(subst W,w,$(subst X,x,$(subst Y,y,$(subst Z,z,$1))))))))))))))))))))))))))

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

ifneq ($(shell $(WHICH) armclang 2>/dev/null),)
HAVE_ARMCLANG := 1
endif

ifeq ($(HAVE_QUARTUS),1)
HAVE_QSYS := 1
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
# Dependency
INTEL_CUSTOM_IP_TARBALL = "intel_custom_ip_20210323_04233.tar.gz"
INTEL_CUSTOM_IP_LINK = "https://releases.rocketboards.org/release/intel_custom_ip/$(INTEL_CUSTOM_IP_TARBALL)"

# Family and Device
# QUARTUS_DEVICE to Board Revision Mapping

QUARTUS_DEVICE_FAMILY := Stratix\ 10
# For Silicon Rev B0, use:
#QUARTUS_DEVICE ?= 1SX280LU2F50E2VGS1
# REV Silicon Rev C1, use:
#QUARTUS_DEVICE ?= 1SX280LU2F50E2VGS3
# REV Final Production Silicon, use:
QUARTUS_DEVICE ?= 1SX280LU2F50E2VG
# FGI board device
#QUARTUS_DEVICE ?= 1SX280LU2F50E2VGS2
# Htile S10 Devkit
# QUARTUS_DEVICE ?= 1SX280HU2F50E1VGAS
# QUARTUS_DEVICE ?= 1SX280HU1F50E2VG

BOARD_TYPE ?= devkit
# Valid DAUGTHER_CARD Values: devkit_dc1, devkit_dc3, devkit_dc4, pe_dc1, pe_dc2, pe_dc6,
#  pe_dc9,, pe_dc10, pe_dc11, pe_dc12, pe_dc13, pe_nand, pe_sdmm
DAUGHTER_CARD ?= devkit_dc1
# System initilization mode: fpga, hps
BOOTS_FIRST ?= hps
# HPS JTAG MODE: combined, separate
HPS_JTAG_MODE ?= combined
# Board Revision: A0, A1
BOARD_REV ?= A1
# Enable HPS EMIF ECC: 0, 1
ENABLE_HPS_EMIF_ECC ?= 1
# Enable Watchdog Reset: 0, 1
ENABLE_WATCHDOG_RST ?= 1
# Supported watchdog reset action: cold, warm, remote_update
WATCHDOG_RST_ACTION ?= cold

## Enable only one of the below at a time. Work in progress to enable them at once.
#
# Enable SGMII (1GbE, 100MbE, 10MbE) design (HPS EMAC + 1G/2.5G/5G/10G Multi-Rate Ethernet PHY Intel FPGA IP).
HPS_ENABLE_SGMII ?= 0
# Enable 10GbE 1588 Design. (Low Latency Ethernet 10G MAC Intel FPGA IP + 1G/2.5G/5G/10G Multi-Rate Ethernet PHY Intel FPGA IP). PTPv2 2-Step enabled.
HPS_ENABLE_10GbE ?= 0
# Enable PCIE Design.
ENABLE_PCIE ?= 0
# Enable Partial Reconfiguration Design.
ENABLE_PARTIAL_RECONFIGURATION ?= 0

ifneq ($(QUARTUS_DEVICE_FAMILY),)
QUARTUS_TCL_ARGS += devicefamily $(QUARTUS_DEVICE_FAMILY)
QSYS_TCL_CMDS += set devicefamily $(QUARTUS_DEVICE_FAMILY);

QUARTUS_TCL_ARGS += project_name ghrd_$(call lc,$(QUARTUS_DEVICE))
QSYS_TCL_CMDS += set project_name ghrd_$(call lc,$(QUARTUS_DEVICE));
endif

ifneq ($(QUARTUS_DEVICE),)
QUARTUS_TCL_ARGS += device $(QUARTUS_DEVICE)
QSYS_TCL_CMDS += set device $(QUARTUS_DEVICE);
endif

ifneq ($(BOARD_TYPE),)
QUARTUS_TCL_ARGS += board $(BOARD_TYPE)
QSYS_TCL_CMDS += set board $(BOARD_TYPE);
endif

ifneq ($(HPS_EMIF_TYPE),)
QUARTUS_TCL_ARGS += hps_emif_type $(HPS_EMIF_TYPE)
QSYS_TCL_CMDS += set hps_emif_type $(HPS_EMIF_TYPE);
endif

QUARTUS_TCL_ARGS += hps_emif_ecc_en $(ENABLE_HPS_EMIF_ECC)
QSYS_TCL_CMDS += set hps_emif_ecc_en $(ENABLE_HPS_EMIF_ECC);

ifneq ($(BOARD_REV),)
QUARTUS_TCL_ARGS += board_rev $(BOARD_REV)
QSYS_TCL_CMDS += set board_rev $(BOARD_REV);
endif

# Valid BOOTS_FIRST Values: fpga or hps
ifneq ($(BOOTS_FIRST),)
QUARTUS_TCL_ARGS += sys_initialization $(BOOTS_FIRST)
QSYS_TCL_CMDS += set sys_initialization $(BOOTS_FIRST);
endif


ifeq ($(HPS_JTAG_MODE),separate)
QUARTUS_TCL_ARGS += hps_dap_mode 1
endif
ifeq ($(HPS_JTAG_MODE),combined)
QUARTUS_TCL_ARGS += hps_dap_mode 2
endif
ifeq ($(HPS_JTAG_MODE),disabled)
QUARTUS_TCL_ARGS += hps_dap_mode 0
endif

QSYS_TCL_CMDS += set watchdog_rst_en $(ENABLE_WATCHDOG_RST);

ifeq ($(WATCHDOG_RST_ACTION),cold)
QSYS_TCL_CMDS += set watchdog_rst_act 0;
endif
ifeq ($(WATCHDOG_RST_ACTION),warm)
QSYS_TCL_CMDS += set watchdog_rst_act 1;
endif
ifeq ($(WATCHDOG_RST_ACTION),remote_update)
QSYS_TCL_CMDS += set watchdog_rst_act 2;
endif

ENABLE_SIGNALTAP_CROSS_TRIGGER ?= 0
ifeq ($(ENABLE_SIGNALTAP_CROSS_TRIGGER),1)
QUARTUS_TCL_ARGS += cross_trigger_en 1
QSYS_TCL_CMDS += set cross_trigger_en 1;
endif

HPS_SGMII_COUNT ?= 2
ifeq ($(HPS_ENABLE_SGMII),1)
QUARTUS_TCL_ARGS += hps_mge_en 1
QSYS_TCL_CMDS += set hps_mge_en 1;
QUARTUS_TCL_ARGS += sgmii_count $(HPS_SGMII_COUNT)
QSYS_TCL_CMDS += set sgmii_count $(HPS_SGMII_COUNT);
endif

####
# Enable 10GbE
ifeq ($(HPS_ENABLE_10GbE),1)
QUARTUS_TCL_ARGS += hps_mge_10gbe_1588_en 1
QSYS_TCL_CMDS += set hps_mge_10gbe_1588_en 1;
endif

####
# Enable PCIe
PCIE_GEN ?= 3
PCIE_COUNT ?= 8
ifeq ($(ENABLE_PCIE),1)
QUARTUS_TCL_ARGS += fpga_pcie 1 pcie_f2h 1 pcie_hptxs 1 pcie_gen $(PCIE_GEN) pcie_count $(PCIE_COUNT)
QSYS_TCL_CMDS += set fpga_pcie 1; set pcie_f2h 1; set pcie_hptxs 1; set pcie_gen $(PCIE_GEN); set pcie_count $(PCIE_COUNT);
endif

####
# Quartus Partial Reconfiguration
ENABLE_PARTIAL_RECONFIGURATION_TESTING ?= 0

ifeq ($(ENABLE_PARTIAL_RECONFIGURATION),1)
QUARTUS_TCL_ARGS += pr_enable $(ENABLE_PARTIAL_RECONFIGURATION) 
QSYS_TCL_CMDS += set pr_enable $(ENABLE_PARTIAL_RECONFIGURATION);
QSYS_TCL_CMDS += set freeze_ack_dly_enable $(ENABLE_PARTIAL_RECONFIGURATION_TESTING);

# Add all named PR partitions
QUARTUS_PARTITIONS += pr_partition_0

endif # ENABLE_PARTIAL_RECONFIGURATION == 1
#### 

ifneq ($(DAUGHTER_CARD),)
QUARTUS_TCL_ARGS += daughter_card $(DAUGHTER_CARD)
QSYS_TCL_CMDS += set daughter_card $(DAUGHTER_CARD);
endif

ifeq ($(BOARD_TYPE),pe)

QUARTUS_TCL_ARGS += h2f_f2h_loopback_en 1
QSYS_TCL_CMDS += set h2f_f2h_loopback_en 1;
QUARTUS_TCL_ARGS += hps_peri_irq_loopback_en 1 
QSYS_TCL_CMDS += set hps_peri_irq_loopback_en 1;
QUARTUS_TCL_ARGS += fpga_peripheral_en 0 
QSYS_TCL_CMDS += set fpga_peripheral_en 0;

QUARTUS_TCL_ARGS += f2sdram0_width 3
QSYS_TCL_CMDS += set f2sdram0_width 3;
QUARTUS_TCL_ARGS += f2sdram1_width 3
QSYS_TCL_CMDS += set f2sdram1_width 3;
QUARTUS_TCL_ARGS += f2sdram2_width 3
QSYS_TCL_CMDS += set f2sdram2_width 3;
QUARTUS_TCL_ARGS += hps_emif_en 1
QSYS_TCL_CMDS += set hps_emif_en 1;

QUARTUS_TCL_ARGS += h2f_width 64 
QSYS_TCL_CMDS += set h2f_width 64;
QUARTUS_TCL_ARGS += f2h_width 64 
QSYS_TCL_CMDS += set f2h_width 64;
QUARTUS_TCL_ARGS += h2f_user_clk_en 1
QSYS_TCL_CMDS += set h2f_user_clk_en 1;
else

QUARTUS_TCL_ARGS += h2f_f2h_loopback_en 0
QSYS_TCL_CMDS += set h2f_f2h_loopback_en 0;
QUARTUS_TCL_ARGS += hps_peri_irq_loopback_en 0 
QSYS_TCL_CMDS += set hps_peri_irq_loopback_en 0;
QUARTUS_TCL_ARGS += hps_emif_en 1 
QSYS_TCL_CMDS += set hps_emif_en 1;

endif


#
# End of Design Settings
#


# Merge QSYS_TCL_CMDS into a single QSys arg
ifneq ($(QSYS_TCL_CMDS),)
QSYS_TCL_ARGS += --cmd="$(QSYS_TCL_CMDS)"
endif
################################################



################################################
.PHONY: default
default: help
################################################

################################################
.PHONY: all
all:

ifeq ($(HAVE_QUARTUS),1)
all: sof
ifeq ($(ENABLE_PARTIAL_RECONFIGURATION),1)
all: pr_rbf
endif
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
# Checking for the existence of intel custom ip
INTEL_CUSTOM_IP_DIR = intel_custom_ip
INTEL_CUSTOM_IP_DIR_TARGET = $(INTEL_CUSTOM_IP_DIR)-$(wildcard $(INTEL_CUSTOM_IP_DIR))
INTEL_CUSTOM_IP_DIR_PRESENT = $(INTEL_CUSTOM_IP_DIR)-$(INTEL_CUSTOM_IP_DIR)
INTEL_CUSTOM_IP_DIR_ABSENT = $(INTEL_CUSTOM_IP_DIR)-

$(INTEL_CUSTOM_IP_DIR_PRESENT):
	@echo "Folder $(INTEL_CUSTOM_IP_DIR) exists. Compilation will proceed with local directory"

$(INTEL_CUSTOM_IP_DIR_ABSENT):
	@echo "Folder $(INTEL_CUSTOM_IP_DIR) does not exist."
	@echo "Proceed to copy for link $(INTEL_CUSTOM_IP_LINK)"
	#if `wget $ -O $(INTEL_CUSTOM_IP_TARBALL) --tries=5 $(INTEL_CUSTOM_IP_LINK)`; then echo "Success"; else echo "Failed" && exit 1; fi
	if `curl $ -o $(INTEL_CUSTOM_IP_TARBALL) -m 90 $(INTEL_CUSTOM_IP_LINK)`; then echo "Success"; else echo "Failed to download $(INTEL_CUSTOM_IP_TARBALL)" && exit 1; fi
	#Temporary using CP.
	#cp -f /p/psg/swip/w/khawkhai/git/ghrd_custom_ip/$(INTEL_CUSTOM_IP_TARBALL) .
	echo "$(INTEL_CUSTOM_IP_TARBALL) copied"
	#Untar $(INTEL_CUSTOM_IP_TARBALL) 
	tar -xzf $(INTEL_CUSTOM_IP_TARBALL)

################################################

################################################
# Archiving & Cleaning your QuartusII/QSys Project

AR_TIMESTAMP := $(if $(QUARTUS_VERSION),$(subst .,_,$(QUARTUS_VERSION))_)$(subst $(SPACE),,$(shell $(DATE) +%m%d%Y_%k%M%S))

AR_DIR := tgz
AR_FILE := $(AR_DIR)/$(basename $(firstword $(wildcard *.qpf)))_$(AR_TIMESTAMP).tar.gz

SOFTWARE_DIR := software

AR_REGEX += \
	Makefile custom_ip $(INTEL_CUSTOM_IP_DIR) ip/*/*.ip *.txt ds5 software README.md license.txt \
	altera_avalon* *.sdc *.v *.sv *.vhd *.qsys *.tcl *.terp *.stp *.mk board \
	*.hex *.sed quartus.ini output_files/*.sof output_files/*.rbf output_files/*.pmsf output_files/*handoff* *.sopcinfo */*.sopcinfo *.jdi \
	hps_isw_handoff handoff.bin */*.svd */synthesis/*.svd */synth/*.svd *.dts *.dtb *.xml \
	patches

AR_FILTER_OUT += %_tb.qsys
################################################


################################################
# Build QuartusII/QSys Project
#

#############
# QSys
QSYS_FILE_TOP := qsys_top.qsys
QSYS_FILE_TOP ?= $(firstword $(wildcard *top*.qsys) $(wildcard ghrd*.qsys) $(wildcard *main*.qsys) $(wildcard *soc*.qsys) $(wildcard *.qsys))

OTHER_QSYS_FILES :=

QSYS_FILES += $(QSYS_FILE_TOP) $(OTHER_QSYS_FILES)

ifeq ($(QSYS_FILE_TOP),)
$(error ERROR: QSYS_FILE_TOP *.qsys file not set and could not be discovered)
endif

QSYS_DEPS += $(sort $(QSYS_FILES) $(filter-out pr_%.qsys,$(wildcard *.qsys)))

QSYS_BASE_TOP := $(basename $(QSYS_FILE_TOP))
QSYS_GEN_DIRS := $(foreach qsys_file,$(QSYS_FILES),$(dir $(qsys_file))$(notdir $(basename $(qsys_file))))

QSYS_QIP_FILES := $(foreach qsys_file,$(QSYS_FILES),$(dir $(qsys_file))$(notdir $(basename $(qsys_file)))/$(basename $(notdir $(qsys_file))).qip)

QSYS_SOPCINFO := $(QSYS_BASE_TOP)/$(QSYS_BASE_TOP).sopcinfo
QSYS_STAMP := $(foreach qsys_file,$(QSYS_FILES),$(call get_stamp_target,$(qsys_file).qsys_gen))

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
	@if [ ! -f "$@" ]; then echo "ERROR: $@ not generated" && false; fi
	$(stamp_target)
endif

QSYS_ARGS += --quartus-project=$(QUARTUS_QPF)
QSYS_ARGS += --rev=$(QUARTUS_BASE_REVISION)
#QSYS_GENERATE_ARGS = $(QSYS_ARGS)
QSYS_GENERATE_ARGS = --quartus-project=$(QUARTUS_QPF)
QSYS_GENERATE_ARGS += --clear-output-directory

$(QSYS_STAMP): $(get_stamp_dir)/%.qsys_gen.stamp: % $(QSYS_DEPS) $(INTEL_CUSTOM_IP_DIR_TARGET)
	$(SET_QSYS_GENERATE_ENV) qsys-generate $(QSYS_GENERATE_ARGS) --rev=$(QUARTUS_BASE_REVISION) $< --upgrade-ip-cores
	$(SET_QSYS_GENERATE_ENV) qsys-script --qpf=none --script=update_sysid.tcl --system-file=$<
	$(SET_QSYS_GENERATE_ENV) qsys-generate $(QSYS_GENERATE_ARGS) --rev=$(QUARTUS_BASE_REVISION) $< --synthesis=VERILOG
	$(stamp_target)

HELP_TARGETS += qsys_edit

qsys_edit.HELP := Launch Platform Designer GUI
ifneq ($(HAVE_QSYS),1)
qsys_edit.HELP := $(qsys_edit.HELP) (Install Quartus Prime Software to enable)
endif

.PHONY: qsys_edit
qsys_edit:
	qsys-edit $(QSYS_ARGS) $(QSYS_FILE_TOP) &

SCRUB_CLEAN_FILES += $(wildcard .qsys_edit)

ifeq ($(HAVE_QSYS),1)
SCRUB_CLEAN_FILES += $(QSYS_QIP_FILES) $(QSYS_SOPCINFO) $(QSYS_GEN_DIRS)
endif

#############
# Quartus Prime

QUARTUS_QPF := ghrd_$(call lc,$(QUARTUS_DEVICE)).qpf

ifeq ($(QUARTUS_QPF),)
$(error ERROR: QUARTUS_QPF *.qpf file not set and could not be discovered)
endif
QUARTUS_BASE := $(basename $(QUARTUS_QPF))
QUARTUS_HDL_SOURCE := $(wildcard *.v *.sv *.vhd)
QUARTUS_MISC_SOURCE := $(wildcard *.stp *.sdc)
QUARTUS_BASE_REVISION := $(QUARTUS_BASE)
QUARTUS_QSF := $(QUARTUS_BASE_REVISION).qsf

AR_REGEX += $(QUARTUS_QPF) $(QUARTUS_QSF)

QUARTUS_DEPS += $(QUARTUS_QSF) $(QUARTUS_HDL_SOURCE) $(QUARTUS_MISC_SOURCE) $(QSYS_STAMP) $(QSYS_QIP_FILES)

QUARTUS_OUTPUT_DIR := output_files
QUARTUS_SOF := $(QUARTUS_OUTPUT_DIR)/$(QUARTUS_BASE).sof
QUARTUS_SOF_WITH_HPS_DEBUG := $(patsubst %.sof,%_hps_debug.sof,$(QUARTUS_SOF))
QUARTUS_RBF := $(patsubst %.sof,%.rbf,$(QUARTUS_SOF_WITH_HPS))
QUARTUS_STAMP := $(call get_stamp_target,quartus)

.PHONY: quartus_compile
quartus_compile: $(QUARTUS_STAMP) $(INTEL_CUSTOM_IP_DIR_TARGET)

ifeq ($(HAVE_QUARTUS),1)
$(QUARTUS_SOF): $(QUARTUS_STAMP)
endif

$(QUARTUS_STAMP): $(QUARTUS_DEPS)
	quartus_stp $(QUARTUS_BASE) -c $(QUARTUS_BASE_REVISION)
	quartus_sh --flow compile $(QUARTUS_QPF) -c $(QUARTUS_BASE_REVISION)
	$(stamp_target)

HELP_TARGETS += quartus_edit
quartus_edit.HELP := Launch Quartus Prime GUI

ifneq ($(HAVE_QUARTUS),1)
quartus_edit.HELP := $(quartus_edit.HELP) (Install Quartus Prime Software to enable)
endif

.PHONY: quartus_edit
quartus_edit:
	quartus $(QUARTUS_QPF) &

HELP_TARGETS += sof
sof.HELP := QSys generate & Quartus compile this design
ifneq ($(HAVE_QUARTUS),1)
sof.HELP := $(sof.HELP) (Install Quartus Prime Software to enable)
endif

BATCH_TARGETS += sof

.PHONY: sof
sof: $(QUARTUS_SOF)

ifeq ($(HAVE_ARMCLANG),1)
sof:  $(QUARTUS_SOF_WITH_HPS_DEBUG)
endif


# Partial Reconfig RBF build flow
ifeq ($(ENABLE_PARTIAL_RECONFIGURATION),1)

QUARTUS_PR_REVISIONS += alternate_persona

QUARTUS_PR_RBF := $(strip \
   $(foreach revision,$(QUARTUS_BASE_REVISION) $(QUARTUS_PR_REVISIONS),\
      $(foreach partition,$(QUARTUS_PARTITIONS),\
          $(QUARTUS_OUTPUT_DIR)/$(revision).$(partition).rbf)))

QUARTUS_PMSF := $(patsubst %.rbf,%.pmsf,$(QUARTUS_PR_RBF))

endif

#####################


#####################
QUARTUS_BASE_QDB := base_static.qdb
SCRUB_CLEAN_FILES += $(QUARTUS_BASE_QDB)

.PHONY: qdb
qdb: $(QUARTUS_BASE_QDB)

$(QUARTUS_BASE_QDB): $(QUARTUS_STAMP)
	quartus_cdb $(QUARTUS_QPF) -c $(QUARTUS_BASE_REVISION) --export_partition root_partition --snapshot final --preserve_sdc --file $@

QSYS_SUBSYS_PR := pr_r0_per
QUARTUS_PR_REVISION := alternate_persona
AR_REGEX += $(QUARTUS_PR_REVISION).qsf
ifeq ($(ENABLE_PARTIAL_RECONFIGURATION),1)
PARTITION_NAME := pr_partition_0
PARTITION_REGION_HIER := "soc_inst|pr_region_0"


.PHONY: quartus_generate_pr_qsf
quartus_generate_pr_qsf: create_pr_revision.tcl
	quartus_sh --script=$< -projectname $(QUARTUS_BASE) -revision $(QUARTUS_BASE_REVISION) -pr_revision $(QUARTUS_PR_REVISION) -pr_partition $(QSYS_SUBSYS_PR) -pr_hierarchy $(PARTITION_REGION_HIER)

.PHONY: qsys_generate_pr_qsys
qsys_generate_pr_qsys: $(QSYS_SUBSYS_PR).qsys

$(QSYS_SUBSYS_PR).qsys: %.qsys: construct_subsys_pr_region.tcl $(QUARTUS_PR_REVISION).qsf
	qsys-script --script=$< --quartus-project=$(QUARTUS_BASE) --rev=$(QUARTUS_PR_REVISION) --cmd="set device $(QUARTUS_DEVICE); set sub_qsys_pr $(QSYS_SUBSYS_PR); set pr_persona 1"
	$(stamp_target)

$(QSYS_SUBSYS_PR)/$(QSYS_SUBSYS_PR).qip: $(QSYS_SUBSYS_PR).qsys
	$(SET_QSYS_GENERATE_ENV) qsys-generate $(QSYS_GENERATE_ARGS) --rev=$(QUARTUS_PR_REVISION) $< --upgrade-ip-cores
	$(SET_QSYS_GENERATE_ENV) qsys-script --qpf=none --script=update_sysid.tcl --system-file=$<
	$(SET_QSYS_GENERATE_ENV) qsys-generate $(QSYS_GENERATE_ARGS) --rev=$(QUARTUS_PR_REVISION) $< --synthesis=VERILOG
	@if [ ! -f "$@" ]; then echo "ERROR: $@ not generated"; false; fi

$(QUARTUS_OUTPUT_DIR)/$(QUARTUS_PR_REVISION).$(PARTITION_NAME).pmsf: %.pmsf: $(QUARTUS_BASE_QDB) $(QSYS_SUBSYS_PR)/$(QSYS_SUBSYS_PR).qip
	quartus_sh --flow compile $(QUARTUS_QPF) -c $(QUARTUS_PR_REVISION)
	@if [ ! -f "$@" ]; then echo "ERROR: $@ not generated"; false; fi

$(QUARTUS_OUTPUT_DIR)/$(QUARTUS_BASE_REVISION).$(PARTITION_NAME).pmsf: $(QUARTUS_SOF)

endif

# MGE 1GbE Constraint
ifeq ($(HPS_ENABLE_SGMII),1)
.PHONY: quartus_add_post_mge_sdc
quartus_add_post_mge_sdc: $(QSYS_FILE_TOP)
	$(SET_QSYS_GENERATE_ENV) quartus_sh --script=add_sdc_post_qsys.tcl -projectname $(QUARTUS_BASE) -hps_enable_sgmii $(HPS_ENABLE_SGMII)
endif

# MGE 10GbE 1588 build flow
ifeq ($(HPS_ENABLE_10GbE),1)
QSYS_SUBSYS_MGE_10GbE := subsys_10gbe_addr_decoder

.PHONY: qsys_generate_mge_10gbe_qsys
qsys_generate_mge_10gbe_qsys: $(QSYS_SUBSYS_MGE_10GbE).qsys

$(QSYS_SUBSYS_MGE_10GbE).qsys: construct_subsys_10gbe_addr_decoder.tcl $(QUARTUS_BASE_REVISION).qsf
	$(SET_QSYS_GENERATE_ENV) qsys-script --script=$< --quartus-project=$(QUARTUS_BASE) --rev=$(QUARTUS_BASE_REVISION) --cmd="set device $(QUARTUS_DEVICE); set device_family $(QUARTUS_DEVICE_FAMILY);"
	$(stamp_target)

$(QSYS_SUBSYS_MGE_10GbE)/$(QSYS_SUBSYS_MGE_10GbE).qip: $(QSYS_SUBSYS_MGE_10GbE).qsys
	$(SET_QSYS_GENERATE_ENV) qsys-generate $(QSYS_GENERATE_ARGS) --quartus-project=$(QUARTUS_BASE) --rev=$(QUARTUS_BASE_REVISION) $< --synthesis=VERILOG
	@if [ ! -f "$@" ]; then echo "ERROR: $@ not generated"; false; fi

.PHONY: quartus_add_post_mge_10GbE_1588_sdc
quartus_add_post_mge_10GbE_1588_sdc: $(QSYS_FILE_TOP)
	$(SET_QSYS_GENERATE_ENV) quartus_sh --script=add_sdc_post_qsys.tcl -projectname $(QUARTUS_BASE) -hps_enable_10gbe $(HPS_ENABLE_10GbE)

endif

#####################
SPL_DEBUG_GEN_HEX_DEPS += software/hps_debug/hps_debug.S software/hps_debug/Makefile software/hps_debug/scatter.scat

software/hps_debug/hps_debug.ihex: $(SPL_DEBUG_GEN_HEX_DEPS)
	$(MAKE) -C software/hps_debug

$(QUARTUS_SOF_WITH_HPS_DEBUG): $(QUARTUS_SOF) software/hps_debug/hps_debug.ihex
	@$(MKDIR) $(@D)
	quartus_pfg -c -o hps_path=software/hps_debug/hps_debug.ihex $< $@

.PHONY: pr_rbf
pr_rbf: $(QUARTUS_PR_RBF)

$(QUARTUS_PR_RBF): %.rbf: %.pmsf
	quartus_pfg -c $< $@


ifeq ($(HAVE_QUARTUS),1)
SCRUB_CLEAN_FILES += $(QUARTUS_SOF) $(QUARTUS_SOF_WITH_HPS) $(QUARTUS_SOF_WITH_HPS_DEBUG) $(QUARTUS_RBF) $(QUARTUS_JIC) $(QUARTUS_OUTPUT_DIR)
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

QUARTUS_TCL_ARGS += qsys_name $(patsubst %.qsys,%,$(QSYS_FILE_TOP))

.PHONY: quartus_generate_top
ifneq ($(QUARTUS_TOP_GEN),)
quartus_generate_top: $(QUARTUS_TOP_GEN)
	@$(RM) *_top.v
	quartus_sh --script=$< $(QUARTUS_TCL_ARGS)
else
quartus_generate_top:
	@$(ECHO) "Make target '$@' is not supported for this design"
endif

QSYS_GEN_QSYS_DEPS += quartus_generate_qsf_qpf

.PHONY: qsys_generate_qsys
ifneq ($(QSYS_QSYS_GEN),)
qsys_generate_qsys: $(QSYS_QSYS_GEN) $(QSYS_GEN_QSYS_DEPS) $(INTEL_CUSTOM_IP_DIR_TARGET)
	@$(RM) $(QSYS_FILE_TOP)
	qsys-script $(QSYS_ARGS) --script=$< $(QSYS_TCL_ARGS)
	# MGE 1GbE Constraint
ifeq ($(HPS_ENABLE_SGMII),1)
	$(MAKE) quartus_add_post_mge_sdc
endif
ifeq ($(HPS_ENABLE_10GbE),1)
	$(MAKE) quartus_add_post_mge_10GbE_1588_sdc
endif
	$(stamp_target)
else
qsys_generate_qsys:
	@$(ECHO) "Make target '$@' is not supported for this design"
endif

HELP_TARGETS += generate_from_tcl
generate_from_tcl.HELP := Generate the Quartus Project source files from tcl script source

.PHONY: generate_from_tcl
generate_from_tcl: $(INTEL_CUSTOM_IP_DIR_TARGET)
	$(MAKE) -s scrub_clean_all
	$(MAKE) quartus_generate_qsf_qpf quartus_generate_top qsys_generate_qsys
ifeq ($(ENABLE_PARTIAL_RECONFIGURATION),1)
	$(MAKE) quartus_generate_pr_qsf qsys_generate_pr_qsys
endif
ifeq ($(HPS_ENABLE_10GbE),1)
	$(MAKE) qsys_generate_mge_10gbe_qsys
endif
################################################


################################################
# Quartus Programming
QUARTUS_PGM_STAMP := $(call get_stamp_target,quartus_pgm)

# set this correctly for your board. If not set, assume the first board
# is your board
CLOSE_PARENTHESIS = )
BOARD_CABLE ?= $(shell jtagconfig | head -n1 | sed -e 's,[0-9]*[$(CLOSE_PARENTHESIS)][ \t]*,,')

# Default to 1 since this is the most common setting
BOARD_DEVICE_INDEX ?= 1


# issp_reset.tcl is required because of the issue described in CASE:487915
define quartus_pgm_sof
jtagconfig
quartus_pgm --mode=jtag $(if $(BOARD_CABLE),--cable="$(BOARD_CABLE)") --operation=p\;$1$(if $(BOARD_DEVICE_INDEX),"@$(BOARD_DEVICE_INDEX)")
jtagconfig $(if $(BOARD_CABLE),-c "$(BOARD_CABLE)") -n
system-console --script=issp_reset.tcl
endef

################################################


################################################
# Clean-up and Archive

AR_FILES += $(filter-out $(AR_FILTER_OUT),$(wildcard $(AR_REGEX)))

CLEAN_FILES += $(filter-out $(AR_DIR) $(AR_FILES) ip,$(wildcard *))

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
QSYS_GEN_FILES += $(filter-out $(wildcard ip/*/*.ip), $(wildcard ip/*/*))
SCRUB_CLEAN_FILES += $(QSYS_GEN_FILES)

HELP_TARGETS += scrub_clean
scrub_clean.HELP := Restore design to its barebones state

.PHONY: scrub scrub_clean
scrub scrub_clean:
	$(FIND) $(SOFTWARE_DIR) \( -name '*.o' -o -name '.depend*' -o -name '*.d' -o -name '*.dep' -o -name '*.objdump' -o -name '*.axf' \) -delete || true
	$(if $(strip $(wildcard $(SCRUB_CLEAN_FILES))),$(RM) $(wildcard $(SCRUB_CLEAN_FILES)),@$(ECHO) "You're already as clean as it gets!")

##scrub_clean_all -> clean all included qpf, qsf and qsys
.PHONY: scrub_clean_all
SCRUB_CLEAN_ALL_FILES += $(SCRUB_CLEAN_FILES)
SCRUB_CLEAN_ALL_FILES += ip/ *.qpf *.qsf *.qsys *.v *.sv
scrub_clean_all:
	$(FIND) $(SOFTWARE_DIR) \( -name '*.o' -o -name '.depend*' -o -name '*.d' -o -name '*.dep' \) -delete || true
	$(if $(strip $(wildcard $(SCRUB_CLEAN_ALL_FILES))),$(RM) $(wildcard $(SCRUB_CLEAN_ALL_FILES)),@$(ECHO) "You're already as clean as it gets!")

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
	@$(ECHO) "* Manage Quartus Prime / Platform Designer Design    *"
	@$(ECHO) "*                                                    *"
	@$(ECHO) "*     Copyright (c) 2017                             *"
	@$(ECHO) "*     All Rights Reserved                            *"
	@$(ECHO) "*                                                    *"
	@$(ECHO) "******************************************************"
	@$(ECHO) ""

.PHONY: help-fini
help-fini:
	@$(ECHO) "*********************"

################################################
