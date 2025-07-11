# Copyright (C) 2024, Advanced Micro Devices, Inc.
# SPDX-License-Identifier: Apache-2.0

include platform.mk

RM = rm -rf
VIVADO = $(XILINX_VIVADO)/bin/vivado
SDTGEN = $(XILINX_VIVADO)/bin/sdtgen
BOOTGEN = $(XILINX_VIVADO)/bin/bootgen

JOBS ?= 1
PROJ_NAME ?= vek385_base

VIV_PRJ_DIR = hw_project
SDT_PRJ_DIR = hw_project_sdt
PDI_FILE = $(SDT_PRJ_DIR)/*boot.pdi
VIV_SCRIPTS_DIR = scripts

VIV_XSA = $(VIV_PRJ_DIR)/*.xsa
VIV_SRC = $(VIV_SCRIPTS_DIR)/main.tcl
SDTGEN_SRC = $(VIV_SCRIPTS_DIR)/gen_sdt.tcl

# Clone the System Device-tree source
get_sdt_source:
	if [ ! -d "./system-device-tree-xlnx" ];then \
		git clone https://gitenterprise.xilinx.com/decoupling/system-device-tree-xlnx.git; \
	fi
	cd system-device-tree-xlnx && git checkout 2025.1.1 && git pull && git log -n1 --pretty=oneline;

.PHONY: help
help:
	@echo 'Usage:'
	@echo ''
	@echo '  make xsa'
	@echo '    Generate vek385 base XSA.'
	@echo '  make sdt'
	@echo '    Generate the SDT files from XSA'
	@echo '  make all'
	@echo '    This will generate both XSA and SDT'
	@echo 'Note you can pass Args JOBS and PROJ_NAME'
	@echo ''

.PHONY: all
all: xsa sdt checkpdi

xsa: $(VIV_XSA)
$(VIV_XSA): $(VIV_SRC)
	$(VIVADO) -mode batch -notrace -source $(VIV_SRC) -tclargs -jobs $(JOBS) -proj_name $(PROJ_NAME)

sdt:get_sdt_source
	$(SDTGEN) $(SDTGEN_SRC) -xsa_name $(PROJ_NAME)

GOLDEN_UNIQUE_ID := $(shell basename $(VIV_PRJ_DIR)/$(PROJ_NAME)/$(PROJ_NAME).srcs/utils_1/imports/vek385_golden_ncr/vek385_*.ncr .ncr | cut -d "_" -f3 )
PDI_UNIQUE_ID := $(shell $(BOOTGEN) -arch versal_2ve_2vm -read $(PDI_FILE) | grep 0x18700000 | grep unique | cut -d ":" -f3 | tr -d ' ')

checkpdi:
	$(info PDI_UNIQUE_ID:$(PDI_UNIQUE_ID))
	$(info GOLDEN_UNIQUE_ID:$(GOLDEN_UNIQUE_ID))
ifeq (${PDI_UNIQUE_ID},${GOLDEN_UNIQUE_ID})
	$(info UNIQUE ID MATCHED)
else
	$(error UNIQUE ID DID NOT MATCH)
endif


.PHONY: clean
clean:
	$(RM) $(VIV_PRJ_DIR) $(SDT_PRJ_DIR) vivado* .Xil *dynamic* *.log *.xpe

