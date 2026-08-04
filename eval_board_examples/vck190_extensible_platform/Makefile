# Copyright (C) 2024, Advanced Micro Devices, Inc.
# SPDX-License-Identifier: Apache-2.0

RM = rm -rf
VIVADO = $(XILINX_VIVADO)/bin/vivado
SDTGEN = $(XILINX_VIVADO)/bin/sdtgen

JOBS ?= 1
PROJ_NAME ?= vck190_extensible_platform
NOC_SOLUTION ?=

VIV_PRJ_DIR = hw_project/$(PROJ_NAME)/outputs
SDT_PRJ_DIR = hw_project_sdt
VIV_SCRIPTS_DIR = scripts

VIV_XSA = $(VIV_PRJ_DIR)/$(PROJ_NAME).xsa
HW_EMU_XSA = $(VIV_PRJ_DIR)/hw_emu/$(PROJ_NAME)_hw_emu.xsa
VIV_SRC = $(VIV_SCRIPTS_DIR)/main.tcl
SDTGEN_SRC = $(VIV_SCRIPTS_DIR)/gen_sdt.tcl

.PHONY: help
help:
	@echo 'Usage:'
	@echo ''
	@echo '  make xsa'
	@echo '    Generate vck190 extensible ced platform (hardware XSA + hw_emu XSA).'
	@echo '  make sdt'
	@echo '    Generate the SDT files from XSA'
	@echo '  make all'
	@echo '    This will generate both XSA and SDT'
	@echo 'Note you can pass Args JOBS, PROJ_NAME and NOC_SOLUTION'
	@echo '  NOC_SOLUTION : path to NOC solution .ncr file (no spaces in path)'
	@echo '  Example: make xsa NOC_SOLUTION=/tmp/vitis_design_noc_solution.ncr'
	@echo ''

.PHONY: all
all: xsa sdt

xsa: $(VIV_XSA)
$(VIV_XSA): $(VIV_SRC)
	$(VIVADO) -mode batch -notrace -source $(VIV_SRC) -tclargs -jobs $(JOBS) -proj_name $(PROJ_NAME) $(if $(NOC_SOLUTION),-noc_solution $(NOC_SOLUTION),)

sdt:
	$(SDTGEN) $(SDTGEN_SRC) -xsa_name $(PROJ_NAME)

.PHONY: clean
clean:
	$(RM) $(VIV_PRJ_DIR) $(SDT_PRJ_DIR) vivado* .Xil *dynamic* *.log *.xpe

