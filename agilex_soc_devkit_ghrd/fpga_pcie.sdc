#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2020 Intel Corporation.
#
#****************************************************************************
#
# Sample SDC for Agilex GHRD. Targeting PCIE component.
#
#****************************************************************************

# Clock Group
# create_clock -name PCIE_REFCLK -period 10 [get_ports pcie_refclk_100]
derive_clock_uncertainty

set_false_path -from [ get_ports {pcie_hip_npor_pin_perst}]

set_false_path -from {soc_inst|*|axi_bridge_for_acp_128_inst|csr_*} -to {soc_inst|s10_hps|altera_stratix10_hps_inst|*}