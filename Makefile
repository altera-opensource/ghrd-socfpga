THIS_MK_ABSPATH := $(abspath $(lastword $(MAKEFILE_LIST)))
THIS_MK_DIR := $(dir $(THIS_MK_ABSPATH))

# Enable pipefail for all commands
SHELL=/bin/bash -o pipefail

# Enable second expansion
.SECONDEXPANSION:

# Clear all built in suffixes
.SUFFIXES:

NOOP :=
SPACE := $(NOOP) $(NOOP)
COMMA := ,
HOSTNAME := $(shell hostname)
WHICH            := which

##############################################################################
# Environment check
##############################################################################


##############################################################################
# Configuration
##############################################################################
WORK_ROOT := $(abspath $(THIS_MK_DIR)/work)
INSTALL_RELATIVE_ROOT ?= install
INSTALL_ROOT ?= $(abspath $(THIS_MK_DIR)/$(INSTALL_RELATIVE_ROOT))

PYTHON3 ?= python3
VENV_PY := venv/bin/python
VENV_PIP := venv/bin/pip
ifneq ($(https_proxy),)
PIP_PROXY := --proxy $(https_proxy)
else
PIP_PROXY :=
endif
VENV_PIP_INSTALL := $(VENV_PIP) install $(PIP_PROXY) --timeout 90
##############################################################################

##############################################################################
# Set default goal before any targets. The default goal here is "test"
##############################################################################
DEFAULT_TARGET := test

.DEFAULT_GOAL := default
.PHONY: default
default: $(DEFAULT_TARGET)

##############################################################################
# Makefile starts here
##############################################################################


###############################################################################
#                          UTILITY TARGETS
###############################################################################
# Deep clean using git
.PHONY: dev-clean
dev-clean :
	git clean -dfx --exclude=/.vscode --exclude=.lfsconfig

# Using git
.PHONY: dev-update
dev-update :
	git pull
	git submodule update --init --recursive

.PHONY: clean
clean:
	git clean -dfx --exclude=/.vscode --exclude=.lfsconfig --exclude=venv

# Prep workspace
venv:
	$(PYTHON3) -m venv venv
	$(VENV_PIP_INSTALL) --upgrade pip
	$(VENV_PIP_INSTALL) -r requirements.txt

.PHONY: prepare-tools
prepare-tools : venv

###############################################################################
#                          Design Targets
###############################################################################
%/output_files:
	mkdir -p $@

$(INSTALL_ROOT) $(INSTALL_ROOT)/designs $(INSTALL_ROOT)/not_shipped:
	mkdir -p $@

# Legal parameterizations
# agilex5_devkit_soc_ghrd (oobe dc)	make BOARD_TYPE=DK-A5E065BB32AES1 DEVICE=A5ED065BB32AE6SR0 HPS_EMIF_EN=1 HPS_EMIF_MEM_CLK_FREQ_MHZ=800 HPS_EMIF_REF_CLK_FREQ_MHZ=100 generate_from_tcl sof
# agilex5_devkit_soc_debug2	make BOARD_TYPE=DK-A5E065BB32AES1 DAUGHTER_CARD=debug2 DEVICE=A5ED065BB32AE6SR0 HPS_EMIF_EN=1 HPS_EMIF_MEM_CLK_FREQ_MHZ=800 HPS_EMIF_REF_CLK_FREQ_MHZ=100 generate_from_tcl sof
# agilex5_devkit_soc_emmc	make BOARD_TYPE=DK-A5E065BB32AES1 DEVICE=A5ED065BB32AE6SR0 HPS_EMIF_MEM_CLK_FREQ_MHZ=800 HPS_EMIF_REF_CLK_FREQ_MHZ=100 DAUGHTER_CARD=devkit_dc_emmc generate_from_tcl sof
# agilex5_devkit_soc_nand	make BOARD_TYPE=DK-A5E065BB32AES1 DEVICE=A5ED065BB32AE6SR0 DAUGHTER_CARD=devkit_dc_nand HPS_EMIF_MEM_CLK_FREQ_MHZ=800 HPS_EMIF_REF_CLK_FREQ_MHZ=100 generate_from_tcl sof
# agilex5_devkit_soc_tsn_cfg2	make BOARD_TYPE=DK-A5E065BB32AES1 DEVICE=A5ED065BB32AE6SR0 DAUGHTER_CARD=devkit_dc_oobe HPS_EMIF_EN=1 HPS_EMIF_MEM_CLK_FREQ_MHZ=800 HPS_EMIF_REF_CLK_FREQ_MHZ=100 SUB_FPGA_RGMII_EN=1 generate_from_tcl sof
# agilex5_devkit_soc_tsn_cfg2_fpga_1st	make BOARD_TYPE=DK-A5E065BB32AES1 DEVICE=A5ED065BB32AE6SR0 DAUGHTER_CARD=devkit_dc_oobe HPS_EMIF_EN=1 HPS_EMIF_MEM_CLK_FREQ_MHZ=800 HPS_EMIF_REF_CLK_FREQ_MHZ=100 SUB_FPGA_RGMII_EN=1 INITIALIZATION_FIRST=fpga generate_from_tcl sof
# agilex5_modular_soc_ghrd	make BOARD_TYPE=MK-A5E065BB32AES1 DEVICE=A5ED065BB32AE6SR0 DAUGHTER_CARD=mod_som HPS_EMIF_EN=1 HPS_EMIF_MEM_CLK_FREQ_MHZ=800 HPS_EMIF_REF_CLK_FREQ_MHZ=150 generate_from_tcl sof

ALL_TARGET_ALL_NAMES :=
ALL_TARGET_STEM_NAMES :=

# create_ghrd_target
# $(1) - Base directory name. i.e. agilex5_soc_devkit_ghrd
# $(2) - Target name. i.e. a5ed065es-premium-devkit-oobe-baseline. Format is <devkit>-<daughter_card>-<name>
# $(3) - Revision name. i.e. ghrd_a5ed065bb32ae6sr0
# $(4) - Config options. i.e. BOARD_TYPE=DK-A5E065BB32AES1 DEVICE=A5ED065BB32AE6SR0 HPS_EMIF_EN=1 HPS_EMIF_MEM_CLK_FREQ_MHZ=800 HPS_EMIF_REF_CLK_FREQ_MHZ=100
define create_ghrd_target

.PHONY: $(strip $(2))-generate-design
$(strip $(2))-generate-design: prepare-tools | $(strip $(1))/output_files
	$(MAKE) -C $(strip $(1)) config
	$(MAKE) -C $(strip $(1)) $(4) generate_from_tcl

.PHONY: $(strip $(2))-prep
$(strip $(2))-prep: | $(strip $(1))/output_files
	cd $(strip $(1)) && quartus_ipgenerate $(strip $(3)) -c $(strip $(3)) --synthesis=verilog

.PHONY: $(strip $(2))-build
$(strip $(2))-build: | $(strip $(1))/output_files
	cd $(strip $(1)) && quartus_syn $(strip $(3))
	cd $(strip $(1)) && quartus_fit $(strip $(3)) --plan --place
	cd $(strip $(1)) && quartus_cdb $(strip $(3)) --back_annotate --pin
	cd $(strip $(1)) && quartus_fit $(strip $(3))
	cd $(strip $(1)) && quartus_asm $(strip $(3))
	cd $(strip $(1)) && quartus_sta $(strip $(3)) --mode=finalize

.PHONY: $(strip $(2))-sw-build
$(strip $(2))-sw-build:

.PHONY: $(strip $(2))-test
$(strip $(2))-test:

.PHONY: $(strip $(2))-install-sof
$(strip $(2))-install-sof: | $(INSTALL_ROOT)/designs
	cp -f $(strip $(1))/output_files/$(strip $(3)).sof $(INSTALL_ROOT)/designs/$(subst -,_,$(strip $(2))).sof

.PHONY: $(strip $(2))-package-design
$(strip $(2))-package-design: | $(INSTALL_ROOT)/designs
	cd $(strip $(1)) && zip -r $(INSTALL_ROOT)/designs/$(subst -,_,$(strip $(2))).zip * -x .gitignore "output_files/*" "qdb/*" "dni/*" "tmp-clearbox/*"

.PHONY: $(strip $(2))-all
$(strip $(2))-all:
	$(MAKE) $(strip $(2))-generate-design
	$(MAKE) $(strip $(2))-package-design
	$(MAKE) $(strip $(2))-prep
	$(MAKE) $(strip $(2))-build
	$(MAKE) $(strip $(2))-sw-build
	$(MAKE) $(strip $(2))-test
	$(MAKE) $(strip $(2))-install-sof

ALL_TARGET_STEM_NAMES += $(strip $(2))
ALL_TARGET_ALL_NAMES += $(strip $(2))-all
endef

# create_legacy_ghrd_target
# $(1) - Base directory name. i.e. a10_soc_devkit_ghrd_pro
# $(2) - Target name. i.e. a10-soc-devkit-baseline. Format is <devkit>-<daughter_card>-<name>
# $(3) - Revision name. i.e. ghrd_10as066n2
# $(4) - Config options. i.e. HPS_BOOT_DEVICE=QSPI
define create_legacy_ghrd_target

.PHONY: $(strip $(2))-generate-design
$(strip $(2))-generate-design: prepare-tools | $(strip $(1))/output_files
	$(MAKE) -C $(strip $(1)) $(4) generate_from_tcl

.PHONY: $(strip $(2))-prep
$(strip $(2))-prep: | $(strip $(1))/output_files
	cd $(strip $(1)) && quartus_ipgenerate $(strip $(3)) -c $(strip $(3)) --synthesis=verilog

.PHONY: $(strip $(2))-build
$(strip $(2))-build: | $(strip $(1))/output_files
	cd $(strip $(1)) && quartus_syn $(strip $(3))
	cd $(strip $(1)) && quartus_fit $(strip $(3))
	cd $(strip $(1)) && quartus_asm $(strip $(3))
	cd $(strip $(1)) && quartus_sta $(strip $(3)) --mode=finalize

.PHONY: $(strip $(2))-sw-build
$(strip $(2))-sw-build:

.PHONY: $(strip $(2))-test
$(strip $(2))-test:

.PHONY: $(strip $(2))-install-sof
$(strip $(2))-install-sof: | $(INSTALL_ROOT)/designs
	cp -f $(strip $(1))/output_files/$(strip $(3)).sof $(INSTALL_ROOT)/designs/$(subst -,_,$(strip $(2))).sof

.PHONY: $(strip $(2))-package-design
$(strip $(2))-package-design: | $(INSTALL_ROOT)/designs
	cd $(strip $(1)) && zip -r $(INSTALL_ROOT)/designs/$(subst -,_,$(strip $(2))).zip * -x .gitignore "output_files/*" "qdb/*" "dni/*" "tmp-clearbox/*"

.PHONY: $(strip $(2))-all
$(strip $(2))-all:
	$(MAKE) $(strip $(2))-generate-design
	$(MAKE) $(strip $(2))-package-design
	$(MAKE) $(strip $(2))-prep
	$(MAKE) $(strip $(2))-build
	$(MAKE) $(strip $(2))-sw-build
	$(MAKE) $(strip $(2))-test
	$(MAKE) $(strip $(2))-install-sof

ALL_TARGET_STEM_NAMES += $(strip $(2))
ALL_TARGET_ALL_NAMES += $(strip $(2))-all
endef

# Arria 10
$(eval $(call create_legacy_ghrd_target, a10_soc_devkit_ghrd_pro, a10-soc-devkit-baseline, ghrd_10as066n2))
$(eval $(call create_legacy_ghrd_target, a10_soc_devkit_ghrd_pro, a10-soc-devkit-qspi, ghrd_10as066n2, HPS_BOOT_DEVICE=QSPI))
$(eval $(call create_legacy_ghrd_target, a10_soc_devkit_ghrd_pro, a10-soc-devkit-nand, ghrd_10as066n2, HPS_BOOT_DEVICE=NAND))
$(eval $(call create_legacy_ghrd_target, a10_soc_devkit_ghrd_pro, a10-soc-devkit-pcie-gen2x8, ghrd_10as066n2, ENABLE_PCIE=1))
$(eval $(call create_legacy_ghrd_target, a10_soc_devkit_ghrd_pro, a10-soc-devkit-pr, ghrd_10as066n2, ENABLE_PARTIAL_RECONFIGURATION=1))
$(eval $(call create_legacy_ghrd_target, a10_soc_devkit_ghrd_pro, a10-soc-devkit-sgmii, ghrd_10as066n2, ENABLE_SGMII=1))
$(eval $(call create_legacy_ghrd_target, a10_soc_devkit_ghrd_pro, a10-soc-devkit-tse, ghrd_10as066n2, ENABLE_TSE=1))

# Stratix 10
$(eval $(call create_legacy_ghrd_target, s10_soc_devkit_ghrd, s10-htile-soc-devkit-baseline, ghrd_1sx280hu2f50e1vgas, QUARTUS_DEVICE=1SX280HU2F50E1VGAS BOOTS_FIRST=hps))
$(eval $(call create_legacy_ghrd_target, s10_soc_devkit_ghrd, s10-htile-soc-devkit-sgmii, ghrd_1sx280hu2f50e1vgas, QUARTUS_DEVICE=1SX280HU2F50E1VGAS BOOTS_FIRST=hps HPS_ENABLE_SGMII=1))
$(eval $(call create_legacy_ghrd_target, s10_soc_devkit_ghrd, s10-htile-soc-devkit-pr, ghrd_1sx280hu2f50e1vgas, QUARTUS_DEVICE=1SX280HU2F50E1VGAS BOOTS_FIRST=hps ENABLE_PARTIAL_RECONFIGURATION=1 HPS_ENABLE_SGMII=0))
$(eval $(call create_legacy_ghrd_target, s10_soc_devkit_ghrd, s10-htile-soc-devkit-nand, ghrd_1sx280hu2f50e1vgas, QUARTUS_DEVICE=1SX280HU2F50E1VGAS BOOTS_FIRST=hps DAUGHTER_CARD=devkit_dc_nand))
$(eval $(call create_legacy_ghrd_target, s10_soc_devkit_ghrd, s10-htile-soc-devkit-pcie-gen3x8, ghrd_1sx280hu2f50e1vgas, QUARTUS_DEVICE=1SX280HU2F50E1VGAS BOOTS_FIRST=hps ENABLE_PCIE=1))

# Agilex 7
$(eval $(call create_legacy_ghrd_target, agilex_soc_devkit_ghrd, agilex-fm86-soc-devkit-baseline, ghrd_agfb027r24c2e2v, BOARD_TYPE=devkit_fm86 BOARD_PWRMGT=linear))
$(eval $(call create_legacy_ghrd_target, agilex_soc_devkit_ghrd, agilex-fm87-soc-devkit-c0-baseline, ghrd_agib027r31b1e1vb, BOARD_TYPE=devkit_fm87 BOARD_PWRMGT=linear ENABLE_HPS_EMIF_ECC=1))
$(eval $(call create_legacy_ghrd_target, agilex_soc_devkit_ghrd, agilex-fm87-soc-devkit-baseline, ghrd_agib027r31b1e1v, BOARD_TYPE=devkit_fm87 BOARD_PWRMGT=linear QUARTUS_DEVICE=AGIB027R31B1E1V ENABLE_HPS_EMIF_ECC=1))
$(eval $(call create_legacy_ghrd_target, agilex_soc_devkit_ghrd, agilex-fm87-soc-devkit-qspi, ghrd_agib027r31b1e1vaa, BOARD_TYPE=devkit_fm87 QUARTUS_DEVICE=AGIB027R31B1E1VAA ENABLE_HPS_EMIF_ECC=1))
$(eval $(call create_legacy_ghrd_target, agilex_soc_devkit_ghrd, agf014e-si-devkit-baseline, ghrd_agfb014r24b2e2v, BOARD_TYPE=DK-SI-AGF014E BOARD_PWRMGT=linear))
$(eval $(call create_legacy_ghrd_target, agilex_soc_devkit_ghrd, agf014e-si-devkit-nand, ghrd_agfb014r24b2e2v, BOARD_TYPE=DK-SI-AGF014E BOARD_PWRMGT=linear DAUGHTER_CARD=devkit_dc_nand HPS_ENABLE_SGMII=1))
$(eval $(call create_legacy_ghrd_target, agilex_soc_devkit_ghrd, agf014e-si-devkit-pr, ghrd_agfb014r24b2e2v, BOARD_TYPE=DK-SI-AGF014E BOARD_PWRMGT=linear ENABLE_HPS_EMIF_ECC=1 ENABLE_PARTIAL_RECONFIGURATION=1))

# Agilex 9
$(eval $(call create_legacy_ghrd_target, agilex_soc_devkit_ghrd, agilex-fp82-soc-devkit-baseline, ghrd_agmf039r47a1e2vr0, BOARD_TYPE=devkit_fp82 CONFIG_SCHEME="AVST\ X8" BOARD_PWRMGT=linear ENABLE_HPS_EMIF_ECC=0 ENABLE_WATCHDOG_RST=0 ))

# Agilex 5 E-Series
$(eval $(call create_ghrd_target, agilex5_soc_devkit_ghrd, a5ed065es-premium-devkit-oobe-baseline, ghrd_a5ed065bb32ae6sr0, BOARD_TYPE=DK-A5E065BB32AES1 DAUGHTER_CARD=devkit_dc_oobe DEVICE=A5ED065BB32AE6SR0 HPS_EMIF_EN=1 HPS_EMIF_MEM_CLK_FREQ_MHZ=800 HPS_EMIF_REF_CLK_FREQ_MHZ=100))
$(eval $(call create_ghrd_target, agilex5_soc_devkit_ghrd, a5ed065es-premium-devkit-debug2-baseline, ghrd_a5ed065bb32ae6sr0, BOARD_TYPE=DK-A5E065BB32AES1 DAUGHTER_CARD=debug2 DEVICE=A5ED065BB32AE6SR0 HPS_EMIF_EN=1 HPS_EMIF_MEM_CLK_FREQ_MHZ=800 HPS_EMIF_REF_CLK_FREQ_MHZ=100))
$(eval $(call create_ghrd_target, agilex5_soc_devkit_ghrd, a5ed065es-premium-devkit-emmc-baseline, ghrd_a5ed065bb32ae6sr0, BOARD_TYPE=DK-A5E065BB32AES1 DAUGHTER_CARD=devkit_dc_emmc DEVICE=A5ED065BB32AE6SR0 HPS_EMIF_MEM_CLK_FREQ_MHZ=800 HPS_EMIF_REF_CLK_FREQ_MHZ=100))
$(eval $(call create_ghrd_target, agilex5_soc_devkit_ghrd, a5ed065es-premium-devkit-nand-baseline, ghrd_a5ed065bb32ae6sr0, BOARD_TYPE=DK-A5E065BB32AES1 DEVICE=A5ED065BB32AE6SR0 DAUGHTER_CARD=devkit_dc_nand HPS_EMIF_MEM_CLK_FREQ_MHZ=800 HPS_EMIF_REF_CLK_FREQ_MHZ=100))
$(eval $(call create_ghrd_target, agilex5_soc_devkit_ghrd, a5ed065es-premium-devkit-oobe-tsn_cfg2, ghrd_a5ed065bb32ae6sr0, BOARD_TYPE=DK-A5E065BB32AES1 DEVICE=A5ED065BB32AE6SR0 DAUGHTER_CARD=devkit_dc_oobe HPS_EMIF_EN=1 HPS_EMIF_MEM_CLK_FREQ_MHZ=800 HPS_EMIF_REF_CLK_FREQ_MHZ=100 SUB_FPGA_RGMII_EN=1))
$(eval $(call create_ghrd_target, agilex5_soc_devkit_ghrd, a5ed065es-premium-devkit-oobe-tsn_cfg2_fpga_1st, ghrd_a5ed065bb32ae6sr0, BOARD_TYPE=DK-A5E065BB32AES1 DEVICE=A5ED065BB32AE6SR0 DAUGHTER_CARD=devkit_dc_oobe HPS_EMIF_EN=1 HPS_EMIF_MEM_CLK_FREQ_MHZ=800 HPS_EMIF_REF_CLK_FREQ_MHZ=100 SUB_FPGA_RGMII_EN=1 INITIALIZATION_FIRST=fpga))
$(eval $(call create_ghrd_target, agilex5_soc_devkit_ghrd, a5ed065es-modular-devkit-som-baseline, ghrd_a5ed065bb32ae6sr0, BOARD_TYPE=MK-A5E065BB32AES1 DEVICE=A5ED065BB32AE6SR0 DAUGHTER_CARD=mod_som HPS_EMIF_EN=1 HPS_EMIF_MEM_CLK_FREQ_MHZ=800 HPS_EMIF_REF_CLK_FREQ_MHZ=150))

k-test:
	$(MAKE) a10-soc-devkit-baseline-all
	$(MAKE) s10-htile-soc-devkit-baseline-all
	$(MAKE) agilex-fm86-soc-devkit-baseline-all

###############################################################################
#                          Toplevel Targets
###############################################################################

.PHONY: prep
prep: prepare-tools

.PHONY: pre-prep
pre-prep:

.PHONY: package-designs
package-designs: $(addsuffix -package-designs,$(ALL_TARGET_STEM_NAMES))

.PHONY: sim
sim:

###############################################################################
#                          SW Targets
###############################################################################

agilex5_soc_devkit_ghrd/software/hps_debug/hps_wipe.ihex:
	cd agilex5_soc_devkit_ghrd/software/hps_debug && ./build.sh

###############################################################################
#                           FSBL insertion into SOF
###############################################################################
# $(1) - Base directory name. i.e. agilex5_soc_devkit_ghrd
# $(2) - Target name. i.e. a5ed065es-premium-devkit-oobe-baseline. Format is <devkit>-<daughter_card>-<name>
# $(3) - Revision name. i.e. ghrd_a5ed065bb32ae6sr0
# $(4) - Source hex file i.e. agilex5_soc_devkit_ghrd/software/hps_debug/hps_wipe.ihex
# $(5) - target SOF basename suffix (i.e. hps_debug)
define create_fsbl_insertion_target

# Add this SW target as a dependency to the SW build target
$(strip $(2))-sw-build : $(strip $(4))

# Create the debug SOF specific SOFs using the hps_debug SW
$(strip $(1))/output_files/$(strip $(3))_$(strip $(5)).sof : $(strip $(1))/output_files/$(strip $(3)).sof $(strip $(4))
	quartus_pfg -c -o hps_path=$(strip $(4)) $(strip $(1))/output_files/$(strip $(3)).sof $(strip $(1))/output_files/$(strip $(3))_$(strip $(5)).sof

$(strip $(2))-$(strip $(5))-install-sof : $(strip $(1))/output_files/$(strip $(3))_$(strip $(5)).sof | $(INSTALL_ROOT)
	cp -f $(strip $(1))/output_files/$(strip $(3))_$(strip $(5)).sof $(INSTALL_ROOT)/designs/$(subst -,_,$(strip $(2)))_$(subst -,_,$(strip $(5))).sof

# Link the FSBL inserted SOF to the base SOF install recipe
$(strip $(2))-install-sof : $(strip $(2))-$(strip $(5))-install-sof

endef

# Create the HPS Debug SOF
$(eval $(call create_fsbl_insertion_target, agilex5_soc_devkit_ghrd, a5ed065es-premium-devkit-oobe-baseline, ghrd_a5ed065bb32ae6sr0, agilex5_soc_devkit_ghrd/software/hps_debug/hps_wipe.ihex, hps_debug))

###############################################################################
#                          Style Checks
###############################################################################

# Include not_shipped Makefile if present
-include not_shipped/Makefile.mk

###############################################################################
#                                HELP
###############################################################################
.PHONY: help
help:
	$(info GHRD Build)
	$(info ----------------)
	$(info ALL Targets         : $(ALL_TARGET_ALL_NAMES))
	$(info Stem names          : $(ALL_TARGET_STEM_NAMES))
