################################################ 
# 
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2020 Intel Corporation.
#
################################################
#
# Makefile to Manage Quartus Prime Pro / QSys Design
#
################################################


################## USER TOPLEVEL CONFIGURATION ##########################
#
# <-
#   BOARD_TYPE:
#       - DK-A5E065BB32AES1: Agilex5 Premium Devkit [default]
#       - MK-A5E065BB32AES1: Agilex5 Modular Devkit
#
#   DEVICE:
#       - A5ED065BB32AE5SR0: 5s FPGA OPN#
#       - A5ED065BB32AE6SR0: 6s FPGA OPN# [default]
#
#   INITIALIZATION_FIRST:
#       - hps: HPS initialization first [default]
#       - fpga: FPGA fabric initialization first
#
#   HPS_JTAG_MODE:
#       - combined: combined mode [default]
#
#
# ->
#
#########################################################################

SHELL := /bin/bash
MAKEFLAGS += --no-print-directory

.SECONDEXPANSION:
.SUFFIXES:
.DELETE_ON_ERROR:


#===============================================
# Tools
#===============================================
MAKE             := make
CAT              := cat
CD               := cd
CHMOD            := chmod
CP               := cp -rf
DATE             := date
ECHO             := echo
FIND             := find
GREP             := grep
HEAD             := head
MKDIR            := mkdir -p
MV               := mv
RM               := rm -rf
SED              := sed
TAR              := tar
TOUCH            := touch
WHICH            := which
PWD              := $(shell pwd)
AWK              := awk
SORT             := sort

#===============================================
# configuration
#===============================================
PROJECT_ROOT                  := $(PWD)
MODULES_FILE                  := build.module
BUILD_DIR                     := build
HELP_TITLE_FILE               := help.title
USER_CONFIG_FILE              := $(BUILD_DIR)/config
GHRD_CONFIG_FILE              := $(PROJECT_ROOT)/build/config.global
GHRD_HELP_FILE                := $(PROJECT_ROOT)/build/help.global
GHRD_SCRIPT_CONFIG_PARZE_FILE := $(PROJECT_ROOT)/scripts/config_parzer.awk
GHRD_SCRIPT_CONFIG_FTM_FILE   := $(PROJECT_ROOT)/scripts/config_fmt.awk


#===============================================
# Quartus
#===============================================
QUARTUS          :=  quartus
QUARTUS_STP      :=  quartus_stp
QUARTUS_SH       :=  quartus_sh
QUARTUS_PFG      :=  quartus_pfg
QUARTUS_PGM      :=  quartus_pgm
QSYS_GENERATE    :=  qsys-generate
QSYS_SCRIPT      :=  qsys-script

# Helpful Macros
SPACE := $(empty) $(empty)

# Convert upper case string to lower case string
lc = $(subst A,a,$(subst B,b,$(subst C,c,$(subst D,d,$(subst E,e,$(subst F,f,$(subst G,g,$(subst H,h,$(subst I,i,$(subst J,j,$(subst K,k,$(subst L,l,$(subst M,m,$(subst N,n,$(subst O,o,$(subst P,p,$(subst Q,q,$(subst R,r,$(subst S,s,$(subst T,t,$(subst U,u,$(subst V,v,$(subst W,w,$(subst X,x,$(subst Y,y,$(subst Z,z,$1))))))))))))))))))))))))))

# load user-specific configuration
ifeq ($(wildcard $(USER_CONFIG_FILE)),)
    $(shell mkdir $(BUILD_DIR))
    $(shell touch $(USER_CONFIG_FILE))
endif

USER_CONFIG := $(shell sed 's/[[:space:]]//g' build/config)
define LOAD_USER_CONFIG
	$(firstword $(subst =, $(SPACE), $1)) := $(word 2, $(subst =, $(SPACE), $1))
endef
$(foreach p, $(USER_CONFIG), $(eval $(call LOAD_USER_CONFIG, $p)))

# update user-specific configuration
USER_CONFIG_UPDATE :=
define UPDATE_USER_CONFIG
	$(firstword $(subst =, $(SPACE), $1)) := $$($(firstword $(subst =, $(SPACE), $1)))
	USER_CONFIG_UPDATE += $(firstword $(subst =, $(SPACE), $1))=$$($(firstword $(subst =, $(SPACE), $1)))
endef
$(foreach p, $(USER_CONFIG), $(eval $(call UPDATE_USER_CONFIG, $p)))

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
HAVE_C_COMPILER := 1
else ifneq ($(shell $(WHICH) aarch64-none-linux-gnu-gcc 2>/dev/null),)
HAVE_C_COMPILER := 1
CROSS_COMPILE ?= "aarch64-none-linux-gnu-"
else ifneq ($(shell $(WHICH) aarch64-linux-gnu-gcc 2>/dev/null),)
HAVE_C_COMPILER := 1
CROSS_COMPILE ?= "aarch64-linux-gnu-"
endif

ifeq ($(HAVE_QUARTUS),1)
HAVE_QSYS := 1
endif

################################################
# Prefix Settings
#  Following section defines/derives parameters
#  that is not parameterizable via command line 
#  
################################################
# Dependency
#INTEL_CUSTOM_IP_TARBALL = "intel_custom_ip_20210323_04233.tar.gz"
#INTEL_CUSTOM_IP_LINK = "https://releases.rocketboards.org/release/intel_custom_ip/$(INTEL_CUSTOM_IP_TARBALL)"

OCM_MEMSIZE ?= 262144
F2S_DATA_WIDTH ?= 256-bit
#RESET_WATCHDOG_EN ?= 1

# User Settings
# Valid BOARD_TYPE: hidden, cvr
###BOARD_TYPE ?= DK-A5E065BB32AES1
#Loading board configuration
#include board/board_$(BOARD_TYPE)_make_config.inc



# Construct internal/non-parameterizable variables 
QUARTUS_TCL_ARGS_INTERNAL += ocm_memsize $(OCM_MEMSIZE)
QSYS_TCL_CMDS_INTERNAL += set ocm_memsize $(OCM_MEMSIZE);

QUARTUS_TCL_ARGS += $(QUARTUS_TCL_ARGS_INTERNAL)
QSYS_TCL_CMDS += $(QSYS_TCL_CMDS_INTERNAL)

# System initilization mode: fpga, hps
INITIALIZATION_FIRST ?= hps

# HPS JTAG MODE: combined, separate
HPS_JTAG_MODE ?= combined

# Option to enable Hard Processor System
SUB_HPS_EN ?= 1

# HPS EMIF Enabled: 0, 1
HPS_EMIF_EN ?= 0

# HPS EMIF ECC: 0, 1
ENABLE_HPS_EMIF_ECC ?= 0

# Default Assignment (Do not modify)
DEVICE_FAMILY := Agilex5
#SM
DEVICE ?= A5ED065BB32AE5SR0

# Board Power Management. temporary set power management IC type here, till an alternative is made available for Agilex5 devkit

PROJECT_NAME ?= ghrd_$(call lc,$(DEVICE))
 
BOARD_PWRMGT ?= linear
# Publicly Available DC: devkit_dc_oobe, devkit_dc_nand, devkit_dc_emmc
DAUGHTER_CARD ?= devkit_dc_oobe

# HPS JTAG MODE: combined, separate
HPS_JTAG_MODE ?= combined
# Option to enable Hard Processor System
SUB_HPS_EN ?= 1
F2S_DATA_WIDTH ?= 0
# HPS EMIF Enabled: 0, 1
HPS_EMIF_EN ?= 0
# HPS EMIF ECC is not support for REVA Agilex
ENABLE_HPS_EMIF_ECC ?= 0

SUB_FPGA_RGMII_EN ?= 0

ifneq ($(DEVICE_FAMILY),)
QUARTUS_TCL_ARGS += device_family $(DEVICE_FAMILY)
QSYS_TCL_CMDS += set device_family $(DEVICE_FAMILY);

QUARTUS_TCL_ARGS += project_name $(PROJECT_NAME)
QSYS_TCL_CMDS += set project_name $(PROJECT_NAME);
endif

ifneq ($(DEVICE),)
QUARTUS_TCL_ARGS += device $(DEVICE)
QSYS_TCL_CMDS += set device $(DEVICE);
endif

ifneq ($(BOARD_TYPE),)
QUARTUS_TCL_ARGS += board $(BOARD_TYPE)
QSYS_TCL_CMDS += set board $(BOARD_TYPE);
endif

ifneq ($(BOARD_PWRMGT),)
QUARTUS_TCL_ARGS += board_pwrmgt $(BOARD_PWRMGT)
QSYS_TCL_CMDS += set board_pwrmgt $(BOARD_PWRMGT);
endif

ifneq ($(SUB_FPGA_RGMII_EN),)
QUARTUS_TCL_ARGS += sub_fpga_rgmii_en $(SUB_FPGA_RGMII_EN)
QSYS_TCL_CMDS += set sub_fpga_rgmii_en $(SUB_FPGA_RGMII_EN);
endif

ifneq ($(INITIALIZATION_FIRST),)
QUARTUS_TCL_ARGS += initialization_first $(INITIALIZATION_FIRST)
QSYS_TCL_CMDS += set initialization_first $(INITIALIZATION_FIRST);
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

ENABLE_SIGNALTAP_CROSS_TRIGGER := 0
ifeq ($(ENABLE_SIGNALTAP_CROSS_TRIGGER),1)
QUARTUS_TCL_ARGS += cross_trigger_en 1
QSYS_TCL_CMDS += set cross_trigger_en 1;
endif

ifneq ($(DAUGHTER_CARD),)
QUARTUS_TCL_ARGS += daughter_card $(DAUGHTER_CARD)
QSYS_TCL_CMDS += set daughter_card $(DAUGHTER_CARD);
endif

ifneq ($(SUB_DEBUG_EN),)
QUARTUS_TCL_ARGS += sub_debug_en $(SUB_DEBUG_EN)
QSYS_TCL_CMDS += set sub_debug_en $(SUB_DEBUG_EN);
endif

ifneq ($(SUB_PERI_EN),)
QUARTUS_TCL_ARGS += sub_peri_en $(SUB_PERI_EN)
QSYS_TCL_CMDS += set sub_peri_en $(SUB_PERI_EN);
endif

ifneq ($(FPGA_DATA_MOVER_EN),)
QUARTUS_TCL_ARGS += fpga_data_mover_en $(FPGA_DATA_MOVER_EN)
QSYS_TCL_CMDS += set fpga_data_mover_en $(FPGA_DATA_MOVER_EN);
endif

ifneq ($(HPS_CLK_SOURCE),)
QUARTUS_TCL_ARGS += hps_clk_source $(HPS_CLK_SOURCE)
QSYS_TCL_CMDS += set hps_clk_source $(HPS_CLK_SOURCE);
endif

QUARTUS_TCL_ARGS += hps_emif_en $(HPS_EMIF_EN)
QSYS_TCL_CMDS += set hps_emif_en $(HPS_EMIF_EN);
QUARTUS_TCL_ARGS += hps_emif_ecc_en $(HPS_EMIF_ECC_EN)
QSYS_TCL_CMDS += set hps_emif_ecc_en $(HPS_EMIF_ECC_EN);

ifneq ($(HPS_EMIF_MEM_CLK_FREQ_MHZ),)
QUARTUS_TCL_ARGS += hps_emif_mem_clk_freq_mhz $(HPS_EMIF_MEM_CLK_FREQ_MHZ)
QSYS_TCL_CMDS += set hps_emif_mem_clk_freq_mhz $(HPS_EMIF_MEM_CLK_FREQ_MHZ);
endif

ifneq ($(HPS_EMIF_REF_CLK_FREQ_MHZ),)
QUARTUS_TCL_ARGS += hps_emif_ref_clk_freq_mhz $(HPS_EMIF_REF_CLK_FREQ_MHZ)
QSYS_TCL_CMDS += set hps_emif_ref_clk_freq_mhz $(HPS_EMIF_REF_CLK_FREQ_MHZ);
endif

ifneq ($(SUB_HPS_EN),)
QUARTUS_TCL_ARGS += sub_hps_en $(SUB_HPS_EN) f2s_data_width $(F2S_DATA_WIDTH)
QSYS_TCL_CMDS += set sub_hps_en $(SUB_HPS_EN); set f2s_data_width $(F2S_DATA_WIDTH);
endif

ifneq ($(RESET_WATCHDOG_EN),)
QUARTUS_TCL_ARGS += reset_watchdog_en $(RESET_WATCHDOG_EN)
QSYS_TCL_CMDS += set reset_watchdog_en $(RESET_WATCHDOG_EN);
endif

ifneq ($(RESET_HPS_WARM_EN),)
QUARTUS_TCL_ARGS += reset_hps_warm_en $(RESET_HPS_WARM_EN)
QSYS_TCL_CMDS += set reset_hps_warm_en $(RESET_HPS_WARM_EN);
endif

ifneq ($(RESET_H2F_COLD_EN),)
QUARTUS_TCL_ARGS += reset_h2f_cold_en $(RESET_H2F_COLD_EN)
QSYS_TCL_CMDS += set reset_h2f_cold_en $(RESET_H2F_COLD_EN);
endif

ifneq ($(RESET_SDM_WATCHDOG_CFG),)
QUARTUS_TCL_ARGS += reset_sdm_watchdog_cfg $(RESET_SDM_WATCHDOG_CFG)
QSYS_TCL_CMDS += set reset_sdm_watchdog_cfg $(RESET_SDM_WATCHDOG_CFG);
endif

ifneq ($(F2S_ADDRESS_WIDTH),)
QUARTUS_TCL_ARGS += f2s_address_width $(F2S_ADDRESS_WIDTH)
QSYS_TCL_CMDS += set f2s_address_width $(F2S_ADDRESS_WIDTH);
endif

ifneq ($(F2SDRAM_DATA_WIDTH),)
QUARTUS_TCL_ARGS += f2sdram_width $(F2SDRAM_DATA_WIDTH)
QSYS_TCL_CMDS += set f2sdram_width $(F2SDRAM_DATA_WIDTH);
endif

ifneq ($(F2SDRAM_ADDR_WIDTH),)
QUARTUS_TCL_ARGS += f2sdram_addr_width  $(F2SDRAM_ADDR_WIDTH)
QSYS_TCL_CMDS += set f2sdram_addr_width $(F2SDRAM_ADDR_WIDTH);
endif

ifneq ($(H2F_WIDTH),)
QUARTUS_TCL_ARGS += h2f_width $(H2F_WIDTH)
QSYS_TCL_CMDS += set h2f_width $(H2F_WIDTH);
endif

ifneq ($(H2F_ADDR_WIDTH),)
QUARTUS_TCL_ARGS += h2f_addr_width $(H2F_ADDR_WIDTH)
QSYS_TCL_CMDS += set h2f_addr_width $(H2F_ADDR_WIDTH);
endif

ifneq ($(LWH2F_WIDTH),)
QUARTUS_TCL_ARGS += lwh2f_width $(LWH2F_WIDTH)
QSYS_TCL_CMDS += set lwh2f_width $(LWH2F_WIDTH);
endif

ifneq ($(LWH2F_ADDR_WIDTH),)
QUARTUS_TCL_ARGS += lwh2f_addr_width $(LWH2F_ADDR_WIDTH)
QSYS_TCL_CMDS += set lwh2f_addr_width $(LWH2F_ADDR_WIDTH);
endif

ifneq ($(PWR_MPU_L3_CACHE_SIZE),)
QUARTUS_TCL_ARGS += pwr_mpu_l3_cache_size $(PWR_MPU_L3_CACHE_SIZE)
QSYS_TCL_CMDS += set pwr_mpu_l3_cache_size $(PWR_MPU_L3_CACHE_SIZE);
endif

ifneq ($(PWR_A55_CORE0_1_ON),)
QUARTUS_TCL_ARGS += pwr_a55_core0_1_on $(PWR_A55_CORE0_1_ON)
QSYS_TCL_CMDS += set pwr_a55_core0_1_on $(PWR_A55_CORE0_1_ON);
endif

ifneq ($(PWR_A76_CORE2_ON),)
QUARTUS_TCL_ARGS += pwr_a76_core2_on $(PWR_A76_CORE2_ON)
QSYS_TCL_CMDS += set pwr_a76_core2_on $(PWR_A76_CORE2_ON);
endif

ifneq ($(PWR_A76_CORE3_ON),)
QUARTUS_TCL_ARGS += pwr_a76_core3_on $(PWR_A76_CORE3_ON)
QSYS_TCL_CMDS += set pwr_a76_core3_on $(PWR_A76_CORE3_ON);
endif

ifneq ($(PWR_BOOT_CORE_SEL),)
QUARTUS_TCL_ARGS += pwr_boot_core_sel $(PWR_BOOT_CORE_SEL)
QSYS_TCL_CMDS += set pwr_boot_core_sel $(PWR_BOOT_CORE_SEL);
endif

ifneq ($(HPS_F2H_IRQ_EN),)
QUARTUS_TCL_ARGS += hps_f2h_irq_en $(HPS_F2H_IRQ_EN)
QSYS_TCL_CMDS += set hps_f2h_irq_en $(HPS_F2H_IRQ_EN);
endif


# EMIF Topology settings, applies only if HPS-EMIF(EMIF_AXI_Enable) is enabled. Set this according to your ddr settings.
#--------------------------------------------
#  HPS IP                       EMIF IP      
#--------------------------------------------
#0:1x16 bit                     HPS_EMIF_1x16
#1:1x32 bit (default)           HPS_EMIF_1x32
#2:2x16 bit - single IO96B
#3:2x16 bit - dual IO96B
#4:2x32 bit                     HPS_EMIF_2x32
#5:4x16 bit
ifeq ($(HPS_EMIF_TOPOLOGY),0)
QUARTUS_TCL_ARGS += emif_topology 0
QSYS_TCL_CMDS += set emif_topology 0;
QUARTUS_TCL_ARGS += hps_emif_topology 1x16
QSYS_TCL_CMDS += set hps_emif_topology 1x16;
else ifeq ($(HPS_EMIF_TOPOLOGY),1)
#default
QUARTUS_TCL_ARGS += emif_topology 1 
QSYS_TCL_CMDS += set emif_topology 1;
QUARTUS_TCL_ARGS += hps_emif_topology 1x32
QSYS_TCL_CMDS += set hps_emif_topology 1x32;
else ifeq ($(HPS_EMIF_TOPOLOGY),2)
QUARTUS_TCL_ARGS += emif_topology 2 
QSYS_TCL_CMDS += set emif_topology 2;
QUARTUS_TCL_ARGS += hps_emif_topology 2x16
QSYS_TCL_CMDS += set hps_emif_topology 2x16;
else ifeq ($(HPS_EMIF_TOPOLOGY),4)
QUARTUS_TCL_ARGS += emif_topology 4 
QSYS_TCL_CMDS += set emif_topology 4;
QUARTUS_TCL_ARGS += hps_emif_topology 2x32
QSYS_TCL_CMDS += set hps_emif_topology 2x32;
else ifeq ($(HPS_EMIF_TOPOLOGY),5)
QUARTUS_TCL_ARGS += emif_topology 5 
QSYS_TCL_CMDS += set emif_topology 5;
QUARTUS_TCL_ARGS += hps_emif_topology 4x16
QSYS_TCL_CMDS += set hps_emif_topology 4x16;
endif

ifeq ($(HPS_EMIF_EN),0)
QUARTUS_TCL_ARGS += f2h_width 0
QSYS_TCL_CMDS += set f2h_width 0;
endif

QSYS_TCL_CMDS += set prjroot $(PROJECT_ROOT);
QUARTUS_TCL_ARGS += prjroot $(PROJECT_ROOT)


### End of Design Settings ###


# Merge QSYS_TCL_CMDS into a single QSys arg
ifneq ($(QSYS_TCL_CMDS),)
QSYS_TCL_ARGS += $(QSYS_TCL_CMDS)
endif
#QSYS_TCL_ARGS += --cmd="$(QSYS_TCL_CMDS)"

#===============================================
# Building modules control
#===============================================
MODULES := $(shell cat $(MODULES_FILE))
MODULE_BUILD := $(foreach n, $(MODULES), $(n).build)

$(MODULE_BUILD): quartus_generate_qsf_qpf 
	@$(MAKE) QSYS_ARGS='$(QSYS_ARGS)' QSYS_TCL_ARGS='$(QSYS_TCL_ARGS)' USER_CONFIG='$(USER_CONFIG_UPDATE)' $(USER_CONFIG_UPDATE) -C $(subst .build,,$@) generate_from_tcl

.PHONY: generate_submodule
generate_submodule: $(MODULE_BUILD)
	@$(MAKE) quartus_generate_top

#===============================================
# Config
#===============================================
MODULE_CONFIG := $(foreach n, $(MODULES), $(n).config)

.PHONY: $(MODULE_CONFIG)
$(MODULE_CONFIG) :
	@$(MAKE) -C $(subst .config,,$@) config

config: $(MODULE_CONFIG)
	$(shell awk -v config_file=$(GHRD_CONFIG_FILE) -v help_file=$(GHRD_HELP_FILE) -f $(GHRD_SCRIPT_CONFIG_PARZE_FILE) $(firstword $(MAKEFILE_LIST)))
	@$(CAT) $(wildcard build/config.*) > build/config
	@$(SED) -i '/^\s*$$/d' build/config
	@$(RM) -rf build/config.*
	@echo "usage       : make <param>=<value> ... module"
	@echo "example     : make BOARD_TYPE=pcie_devkit all"
	@echo "parameters  :"
	$(eval $(call get_help_modules, $(wildcard build/help.*)))
	@cat $(sort $(help_modules)) > build/help
	@sed -i '/^\s*$$/d' build/help
	@awk '{print $$0}'  build/help


################################################
.PHONY: default
default: help
################################################

.PHONY: all
all:

ifeq ($(HAVE_QUARTUS),1)
all: generate_from_tcl sof
endif

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
#INTEL_CUSTOM_IP_DIR = intel_custom_ip
#INTEL_CUSTOM_IP_DIR_TARGET = $(INTEL_CUSTOM_IP_DIR)-$(wildcard $(INTEL_CUSTOM_IP_DIR))
#INTEL_CUSTOM_IP_DIR_PRESENT = $(INTEL_CUSTOM_IP_DIR)-$(INTEL_CUSTOM_IP_DIR)
#INTEL_CUSTOM_IP_DIR_ABSENT = $(INTEL_CUSTOM_IP_DIR)-
#
#$(INTEL_CUSTOM_IP_DIR_PRESENT):
#	@echo "Folder $(INTEL_CUSTOM_IP_DIR) exists. Compilation will proceed with local directory"
#
#$(INTEL_CUSTOM_IP_DIR_ABSENT):
#	@echo "Folder $(INTEL_CUSTOM_IP_DIR) does not exist."
#	@echo "Proceed to copy for link $(INTEL_CUSTOM_IP_LINK)"
##if `wget $ -O $(INTEL_CUSTOM_IP_TARBALL) --tries=5 $(INTEL_CUSTOM_IP_LINK)`; then echo "Success"; else echo "Failed" && exit 1; fi
#	if `curl $ -o $(INTEL_CUSTOM_IP_TARBALL) -m 90 -L $(INTEL_CUSTOM_IP_LINK)`; then echo "Success"; else echo "Failed to download $(INTEL_CUSTOM_IP_TARBALL)" && exit 1; fi
#	@echo "$(INTEL_CUSTOM_IP_TARBALL) copied"
##Untar $(INTEL_CUSTOM_IP_TARBALL)
#	tar -xzf $(INTEL_CUSTOM_IP_TARBALL)

################################################

################################################
# Archiving & Cleaning your QuartusII/QSys Project

AR_TIMESTAMP := $(if $(QUARTUS_VERSION),$(subst .,_,$(QUARTUS_VERSION))_)$(subst $(SPACE),,$(shell $(DATE) +%m%d%Y_%k%M%S))

AR_DIR := tgz
AR_FILE := $(AR_DIR)/$(basename $(firstword $(wildcard *.qpf)))_$(AR_TIMESTAMP).tar.gz

SOFTWARE_DIR := software
#custom_ip $(INTEL_CUSTOM_IP_DIR) ip/*/*.ip
AR_REGEX += \
	Makefile *.txt ds5 software custom_ip scripts build build.module fpga_rgmii_subsys ip README.md license.txt \
	altera_avalon* *.sdc *.v *.sv *.vhd *.qsys *.tcl *.terp *.stp *.mk board hps_subsys jtag_subsys peripheral_subsys\
	*.hex *.sed quartus.ini output_files/*.sof output_files/*.rbf output_files/*.pmsf output_files/*handoff* *.sopcinfo */*.sopcinfo *.jdi \
	hps_isw_handoff handoff.bin */*.svd */synthesis/*.svd */synth/*.svd *.dts *.dtb *.xml \
	patches

AR_FILTER_OUT += %_tb.qsys
################################################



################################################
# Build QuartusII/QSys Project
#

#############
# Name the top level QSys file 
QSYS_FILE_TOP := qsys_top.qsys
#QSYS_FILE_TOP ?= $(firstword $(wildcard *top*.qsys) $(wildcard ghrd*.qsys) $(wildcard *main*.qsys) $(wildcard *soc*.qsys) $(wildcard *.qsys))

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

QUARTUS_QPF := $(PROJECT_NAME).qpf

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
	quartus_sh --flow compile $(QUARTUS_QPF) -c $(QUARTUS_BASE_REVISION) -end fitter_place
	quartus_cdb $(QUARTUS_BASE_REVISION) --back_annotate --pin
	quartus_sh --flow compile $(QUARTUS_QPF) -c $(QUARTUS_BASE_REVISION) -resume
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

ifeq ($(HAVE_C_COMPILER),1)
sof:  $(QUARTUS_SOF_WITH_HPS_DEBUG)
endif

QUARTUS_BASE_QDB := base_static.qdb
SCRUB_CLEAN_FILES += $(QUARTUS_BASE_QDB)

SPL_DEBUG_GEN_HEX_DEPS += software/hps_debug/hps_wipe.s software/hps_debug/Makefile

software/hps_debug/hps_wipe.ihex: $(SPL_DEBUG_GEN_HEX_DEPS)
ifneq ($(HAVE_C_COMPILER),1)
	$(error ERROR: No compiler to build hps_wipe.s)
else
	$(MAKE) -C software/hps_debug CROSS_COMPILE=${CROSS_COMPILE}
endif

$(QUARTUS_SOF_WITH_HPS_DEBUG): $(QUARTUS_SOF) software/hps_debug/hps_wipe.ihex
	@$(MKDIR) $(@D)
	quartus_pfg -c -o hps_path=software/hps_debug/hps_wipe.ihex $< $@

$(QUARTUS_PR_RBF): %.rbf: %.pmsf
	quartus_pfg -c $< $@

ifeq ($(HAVE_QUARTUS),1)
SCRUB_CLEAN_FILES += $(QUARTUS_SOF) $(QUARTUS_SOF_WITH_HPS) $(QUARTUS_SOF_WITH_HPS_DEBUG) $(QUARTUS_RBF) $(QUARTUS_JIC) $(QUARTUS_OUTPUT_DIR)
endif

.PHONY: debug_sof
debug_sof: software/hps_debug/hps_wipe.ihex
ifneq ("$(wildcard $(QUARTUS_OUTPUT_DIR)/$(QUARTUS_BASE)*.sof)", "")
	$(info Generating debug version of $(QUARTUS_BASE).sof as $(QUARTUS_BASE)_hps_debug.sof)
	quartus_pfg -c -o hps_path=software/hps_debug/hps_wipe.ihex $(QUARTUS_SOF) $(QUARTUS_SOF_WITH_HPS_DEBUG)
else
	$(error ERROR: Please run "make sof" to create $(QUARTUS_SOF))
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
	@$(ECHO) "quartus_generate_top done!"
else
quartus_generate_top:
	@$(ECHO) "Make target '$@' is not supported for this design"
endif

QSYS_GEN_QSYS_DEPS += quartus_generate_qsf_qpf

#.PHONY: qsys_generate_qsys
#ifneq ($(QSYS_QSYS_GEN),)
#qsys_generate_qsys: $(QSYS_QSYS_GEN) $(QSYS_GEN_QSYS_DEPS) $(INTEL_CUSTOM_IP_DIR_TARGET)
#	@$(RM) $(QSYS_FILE_TOP)
#	qsys-script $(QSYS_ARGS) --script=$< $(QSYS_TCL_ARGS)
#ifeq ($(SUB_HPS_ENABLE_SGMII),1)
#	$(MAKE) quartus_add_post_sgmii_sdc
#endif
#	$(stamp_target)
#else
#qsys_generate_qsys:
#	@$(ECHO) "Make target '$@' is not supported for this design"
#endif

QSYS_TCL_CMDS += set qsys_name $(patsubst %.qsys,%,$(QSYS_FILE_TOP));

.PHONY: qsys_generate_qsys
ifneq ($(QSYS_QSYS_GEN),)
qsys_generate_qsys: $(QSYS_QSYS_GEN) $(INTEL_CUSTOM_IP_DIR_TARGET)
	@$(RM) $(QSYS_FILE_TOP)
	qsys-script $(QSYS_ARGS) --script=$< --cmd="$(QSYS_TCL_ARGS)"
ifeq ($(SUB_HPS_ENABLE_SGMII),1)
	$(MAKE) quartus_add_post_sgmii_sdc
endif
	$(stamp_target)
else
qsys_generate_qsys:
	@$(ECHO) "Make target '$@' is not supported for this design"
endif


HELP_TARGETS += generate_from_tcl
generate_from_tcl.HELP := Generate the Quartus Project and Qsys design files from tcl script source

.PHONY: writeback_user_config
writeback_user_config:
	@$(ECHO) $(USER_CONFIG_UPDATE) > $(BUILD_DIR)/config.tmp
	@$(AWK) -v output=$(USER_CONFIG_FILE) -f $(GHRD_SCRIPT_CONFIG_FTM_FILE)  $(BUILD_DIR)/config.tmp
	@$(RM) -rf $(BUILD_DIR)/config.tmp

.PHONY: generate_from_tcl
generate_from_tcl: writeback_user_config generate_submodule $(INTEL_CUSTOM_IP_DIR_TARGET)
	@$(MAKE) qsys_generate_qsys
	@$(ECHO) "generate_from_tcl done!"

ifeq ($(ENABLE_PARTIAL_RECONFIGURATION),1)
	$(MAKE) quartus_generate_pr_qsf qsys_generate_pr_qsys
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

ifeq ($(ENABLE_PARTIAL_RECONFIGURATION),1)
AR_FILES += $(QUARTUS_BASE_QDB)
endif

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



#===============================================
# Help
#===============================================
define get_help_modules
    help_modules := $1
endef

help:
	@$(ECHO) "Summary of Makefile targets"
	@$(ECHO) "    help              - displays this list"
	@$(ECHO) "    config            - Retrives all variables in Makefile(s) and displays their value."
	@$(ECHO) "    generate_from_tcl - Generate qsys from tcl scripts"
	@$(ECHO) "    sof               - Generate sof based upon the generated qsys files"
	@$(ECHO) "    debug_sof         - Generate debug version sof to boot with arm debugger"
	@$(ECHO) "    all               - Merge of generate_from_tcl and sof"
	@$(ECHO) "    clean             - Cleareance of interim generated compilation files"
