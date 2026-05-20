# Copyright (C) 2024, Advanced Micro Devices, Inc.
# SPDX-License-Identifier: Apache-2.0

RM = rm -rf
VIVADO = $(XILINX_VIVADO)/bin/vivado
SDTGEN = $(XILINX_VIVADO)/bin/sdtgen

JOBS ?= 1
PROJ_NAME ?= vck190_extensible_platform

VIV_PRJ_DIR = hw_project/$(PROJ_NAME)/outputs
SDT_PRJ_DIR = hw_project_sdt
VIV_SCRIPTS_DIR = scripts

VIV_XSA = $(VIV_PRJ_DIR)/$(PROJ_NAME).xsa
VIV_SRC = $(VIV_SCRIPTS_DIR)/main.tcl
SDTGEN_SRC = $(VIV_SCRIPTS_DIR)/gen_sdt.tcl

VCK190_BASE_DIR = ../Vitis_Embedded_Platform_Source/Xilinx_Official_Platforms/vck190_base
BASE_XSA = $(VCK190_BASE_DIR)/hw/build/hw.xsa
SEG_CONFIG_SCRIPT = $(VIV_SCRIPTS_DIR)/enable_segmented_config.sh

.PHONY: help
help:
	@echo 'Usage:'
	@echo ''
	@echo '  make xsa'
	@echo '    Generate vck190 extensible ced platform.'
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
	#$(VIVADO) -mode batch -notrace -source $(VIV_SRC) -tclargs -jobs $(JOBS) -proj_name $(PROJ_NAME)
	$(SEG_CONFIG_SCRIPT)
	$(MAKE) -C $(VCK190_BASE_DIR) xsa
	mkdir -p $(VIV_PRJ_DIR)
	cp -f $(BASE_XSA) $@

sdt:
	$(SDTGEN) $(SDTGEN_SRC) -xsa_name $(PROJ_NAME)

.PHONY: clean
clean:
	$(RM) $(VIV_PRJ_DIR) $(SDT_PRJ_DIR) vivado* .Xil *dynamic* *.log *.xpe

