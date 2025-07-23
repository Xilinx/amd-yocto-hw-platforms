# Copyright (C) 2024, Advanced Micro Devices, Inc.
# SPDX-License-Identifier: Apache-2.0

RM = rm -rf
VIVADO = $(XILINX_VIVADO)/bin/vivado
SDTGEN = $(XILINX_VIVADO)/bin/sdtgen
BOOTGEN = $(XILINX_VIVADO)/bin/bootgen

JOBS ?= 1
PROJ_NAME ?= vrk165_base

VIV_PRJ_DIR = hw_project
SDT_PRJ_DIR = hw_project_sdt
PDI_FILE = $(SDT_PRJ_DIR)/*boot.pdi
VIV_SCRIPTS_DIR = scripts

VIV_XSA = $(VIV_PRJ_DIR)/*.xsa
VIV_SRC = $(VIV_SCRIPTS_DIR)/main.tcl
SDTGEN_SRC = $(VIV_SCRIPTS_DIR)/gen_sdt.tcl

.PHONY: help
help:
	@echo 'Usage:'
	@echo ''
	@echo '  make xsa'
	@echo '    Generate vrk165 base XSA.'
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

sdt:
	$(SDTGEN) $(SDTGEN_SRC) -xsa_name $(PROJ_NAME)

GOLDEN_UNIQUE_ID := $(shell basename $(VIV_PRJ_DIR)/$(PROJ_NAME)/$(PROJ_NAME).srcs/utils_1/imports/golden_ncr/vrk165_*.ncr .ncr | cut -d "_" -f3 )
PDI_UNIQUE_ID := $(shell $(BOOTGEN) -arch versal -read $(PDI_FILE) | grep 0x18700000 | grep unique | cut -d ":" -f3 | tr -d ' ')

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

