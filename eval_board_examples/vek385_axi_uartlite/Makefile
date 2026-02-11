# Copyright (C) 2024, Advanced Micro Devices, Inc.
# SPDX-License-Identifier: Apache-2.0

RM = rm -rf
VIVADO = $(XILINX_VIVADO)/bin/vivado
SDTGEN = $(XILINX_VIVADO)/bin/sdtgen
LOPPER = $(XILINX_VIVADO)/bin/lopper
BOOTGEN = $(XILINX_VIVADO)/bin/bootgen
DTC = $(XILINX_VIVADO)/bin/dtc

JOBS ?= 1
PROJ_NAME ?= vek385_bram_gpio_timer
FWDIR = $(PROJ_NAME)-fw

VIV_PRJ_DIR = hw_project
SDT_PRJ_DIR = hw_project_sdt
PDI_FILE = $(SDT_PRJ_DIR)/$(PROJ_NAME)_boot.pdi
PLD_PDI = $(SDT_PRJ_DIR)/$(PROJ_NAME)_pld.pdi
VIV_SCRIPTS_DIR = scripts

VIV_XSA = $(VIV_PRJ_DIR)/*.xsa
VIV_SRC = $(VIV_SCRIPTS_DIR)/main.tcl
SDTGEN_SRC = $(VIV_SCRIPTS_DIR)/gen_sdt.tcl


.PHONY: help
help:
	@echo 'Usage:'
	@echo ''
	@echo '  make xsa'
	@echo '    Generate vek385 PL XSA.'
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

GOLDEN_UNIQUE_ID := $(shell basename $(XILINX_VIVADO)/data/xhub/ced/XilinxCEDStore/ced/Xilinx/IPI/Versal_gen2_platform/vek385_golden_ncr/vek385_*.ncr .ncr | cut -d "_" -f3 )
PDI_UNIQUE_ID := $(shell $(BOOTGEN) -arch versal_2ve_2vm -read $(PDI_FILE) | grep 0x18700000 | grep unique | cut -d ":" -f3 | tr -d ' ')

checkpdi:
	$(info PDI_UNIQUE_ID:$(PDI_UNIQUE_ID))
	$(info GOLDEN_UNIQUE_ID:$(GOLDEN_UNIQUE_ID))
ifeq (${PDI_UNIQUE_ID},${GOLDEN_UNIQUE_ID})
	$(info UNIQUE ID MATCHED)
else
	$(error UNIQUE ID DID NOT MATCH)
endif


.PHONY: gen_overlay
gen_overlay: copy_files run_lopper run_dtc

run_lopper:
	LOPPER_DTC_FLAGS="-b 0 -@" $(LOPPER) --enhanced -O $(FWDIR) -f $(SDT_PRJ_DIR)/system-top.dts -- xlnx_overlay_dt cortexa78_0 full

run_dtc:
	$(DTC) -I dts -O dtb -o $(FWDIR)/pl.dtbo $(FWDIR)/pl.dtsi

copy_files:
	mkdir -p $(FWDIR)
	cp -rf $(PLD_PDI) $(FWDIR)
	cp -rf $(VIV_SCRIPTS_DIR)/shell.json $(FWDIR)


.PHONY: clean
clean:
	$(RM) $(VIV_PRJ_DIR) $(SDT_PRJ_DIR) $(FWDIR) vivado* .Xil *dynamic* *.log *.xpe

