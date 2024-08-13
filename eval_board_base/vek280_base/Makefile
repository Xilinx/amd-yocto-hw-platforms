# Copyright (C) 2024, Advanced Micro Devices, Inc.
# SPDX-License-Identifier: Apache-2.0

RM = rm -rf
VIVADO = $(XILINX_VIVADO)/bin/vivado
XSCT = $(XILINX_VIVADO)/xsct-trim/bin/xsct

JOBS ?= 8
PROJ_NAME ?= vek280_base_seg

VIV_PRJ_DIR = hw_project
SDT_PRJ_DIR = hw_project_sdt
VIV_SCRIPTS_DIR = scripts

VIV_XSA = $(VIV_PRJ_DIR)/*.xsa
VIV_SRC = $(VIV_SCRIPTS_DIR)/main.tcl
XSCT_SRC = $(VIV_SCRIPTS_DIR)/gen_sdt.tcl

.PHONY: help
help:
	@echo 'Usage:'
	@echo ''
	@echo '  make xsa'
	@echo '    Generate vek280 base segmented xsa.'
	@echo '  make sdt'
	@echo '    Generate the SDT files from XSA'
	@echo '  make all'
	@echo '    This will generate both XSA and SDT'
	@echo 'Note you can pass Args JOBS and PROJ_NAME'
	@echo ''

.PHONY: all
all: xsa sdt

xsa: $(VIV_XSA)
$(VIV_XSA): $(VIV_SRC)
	$(VIVADO) -mode batch -notrace -source $(VIV_SRC) -tclargs -jobs $(JOBS) -proj_name $(PROJ_NAME)

sdt:
	$(XSCT) $(XSCT_SRC) -xsa_name $(PROJ_NAME)

.PHONY: clean
clean:
	$(RM) $(VIV_PRJ_DIR) $(SDT_PRJ_DIR) vivado* .Xil *dynamic* *.log *.xpe

