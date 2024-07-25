# Copyright (C) 2024, Advanced Micro Devices, Inc.
# SPDX-License-Identifier: Apache-2.0

.EXPORT_ALL_VARIABLES:

#TOOLS
VIVADO  = $(XILINX_VIVADO)/bin/vivado
XSCT    = $(XILINX_VITIS)/bin/xsct
RM = rm -rf

#PFM DIR VARIABLES
PFMS_DIR = $(PWD)/plnx-aie-examples/platforms
BASE_PLATFORM = $(PFMS_DIR)/base

#APP VARIABLES
XGEMM_DIR = $(PWD)/plnx-aie-examples/designs/xgemm-gmio
AIEARCH ?= aie-ml

VIV_SCRIPTS_DIR = scripts
XSCT_SRC = $(VIV_SCRIPTS_DIR)/gen_sdt.tcl
SDT_PRJ_DIR = hw_project_sdt

#Hw artifacts
XSA_DIR = $(PWD)/plnx-aie-examples/designs/xgemm-gmio/hw
XSA_PATH ?= $(XSA_DIR)/hw.xsa
