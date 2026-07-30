# Copyright (C) 2026, Advanced Micro Devices, Inc.
# SPDX-License-Identifier: Apache-2.0

RM = rm -rf
VIVADO = $(XILINX_VIVADO)/bin/vivado
SDTGEN = $(XILINX_VIVADO)/bin/sdtgen
BOOTGEN = $(XILINX_VIVADO)/bin/bootgen

JOBS ?= 1
PROJ_NAME ?= vrk165_revb_base
NOC_SOLUTION ?=

VIV_PRJ_DIR = hw_project
SDT_PRJ_DIR = hw_project_sdt
PDI_FILE = $(SDT_PRJ_DIR)/*boot.pdi
VIV_SCRIPTS_DIR = scripts

VIV_XSA = $(VIV_PRJ_DIR)/$(PROJ_NAME)/outputs/*.xsa
VIV_SRC = $(VIV_SCRIPTS_DIR)/main.tcl
SDTGEN_SRC = $(VIV_SCRIPTS_DIR)/gen_sdt.tcl


.PHONY: help
help:
	@echo 'Usage:'
	@echo ''
	@echo '  make xsa'
	@echo '    Generate vrk165 revb base XSA.'
	@echo '  make sdt'
	@echo '    Generate the SDT files from XSA'
	@echo '  make all'
	@echo '    This will generate both XSA and SDT'
	@echo 'Note you can pass Args JOBS, PROJ_NAME and NOC_SOLUTION'
	@echo '  NOC_SOLUTION : path to NOC solution .ncr file (no spaces in path)'
	@echo '  Example: make xsa NOC_SOLUTION=/tmp/edf_base_pl_noc_solution.ncr'
	@echo ''

.PHONY: all
all: xsa sdt

xsa: $(VIV_XSA)
$(VIV_XSA): $(VIV_SRC)
	$(VIVADO) -mode batch -notrace -source $(VIV_SRC) -tclargs -jobs $(JOBS) -proj_name $(PROJ_NAME) $(if $(NOC_SOLUTION),-noc_solution $(NOC_SOLUTION),)

sdt: $(PDI_FILE)
$(PDI_FILE): $(SDTGEN_SRC)
	$(SDTGEN) $(SDTGEN_SRC) -xsa_name $(PROJ_NAME)

checkpdi: xsa sdt
	@echo "compatibility check"; \
	GOLDEN_UNIQUE_ID=$$(basename $(VIV_PRJ_DIR)/$(PROJ_NAME)/$(PROJ_NAME).srcs/utils_1/imports/golden_ncr/vrk165_*.ncr .ncr | grep -o '0x[0-9a-fA-F]\+' ); \
	PDI_UNIQUE_ID=$$($(BOOTGEN) -arch versal -read $(PDI_FILE) | grep 0x18700000 | grep unique | cut -d ":" -f3 | tr -d ' '); \
	echo "PDI_UNIQUE_ID: $$PDI_UNIQUE_ID"; \
	echo "GOLDEN_UNIQUE_ID: $$GOLDEN_UNIQUE_ID"; \
	if [ "$$PDI_UNIQUE_ID" = "$$GOLDEN_UNIQUE_ID" ]; then \
		echo "UNIQUE ID MATCHED"; \
	else \
		echo "ERROR: UNIQUE ID DID NOT MATCH"; \
	fi

.PHONY: clean
clean:
	$(RM) $(VIV_PRJ_DIR) $(SDT_PRJ_DIR) vivado* .Xil *dynamic* *.log *.xpe
