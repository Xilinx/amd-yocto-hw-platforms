# Copyright (C) 2024, Advanced Micro Devices, Inc.
# SPDX-License-Identifier: Apache-2.0

RM = rm -rf
VIVADO = $(XILINX_VIVADO)/bin/vivado
SDTGEN = $(XILINX_VIVADO)/bin/sdtgen
BOOTGEN = $(XILINX_VIVADO)/bin/bootgen

JOBS ?= 1
PROJ_NAME ?= ps_noc_seio_3mc

VIV_PRJ_DIR = ps_noc_seio_3mc
SDT_PRJ_DIR = hw_project_sdt
PDI_FILE = $(SDT_PRJ_DIR)/*boot.pdi
VIV_SCRIPTS_DIR = scripts

VIV_XSA = $(VIV_PRJ_DIR)/*.xsa
XSA_SRC = PVS_APEX_DEV/designs/ssw/psxc_seio
VIV_SRC = run.tcl
SDTGEN_SRC = $(VIV_SCRIPTS_DIR)/gen_sdt.tcl

# Clone the apex xsa sources
get_xsa_source:
	if [ ! -d "./PVS_APEX_DEV" ];then \
		git clone git@gitenterprise.xilinx.com:SSAV/PVS_APEX_DEV.git; \
	fi
	cd PVS_APEX_DEV && git pull && git log -n1 --pretty=oneline;

.PHONY: help
help:
	@echo 'Usage:'
	@echo ''
	@echo '  make xsa'
	@echo '    Generate APEX base XSA.'
	@echo '  make sdt'
	@echo '    Generate the SDT files from XSA'
	@echo '  make all'
	@echo '    This will generate both XSA and SDT'
	@echo 'Note you can pass Args JOBS and PROJ_NAME'
	@echo ''

.PHONY: all
all: xsa sdt

xsa: get_xsa_source
	cd $(XSA_SRC) && $(VIVADO) -mode batch -notrace -source $(VIV_SRC)

sdt:
	$(SDTGEN) $(SDTGEN_SRC) -xsa_path $(XSA_SRC)/$(PROJ_NAME).xsa

.PHONY: clean
clean:
	$(RM) $(XSA_SRC)/$(VIV_PRJ_DIR) $(XSA_SRC)/$(VIV_PRJ_DIR).xsa $(SDT_PRJ_DIR) $(XSA_SRC)/vivado* $(XSA_SRC)/.Xil *dynamic* *.log *.xpe

