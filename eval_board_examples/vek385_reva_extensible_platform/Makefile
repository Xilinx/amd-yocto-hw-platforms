# Copyright (C) 2024, Advanced Micro Devices, Inc.
# SPDX-License-Identifier: Apache-2.0

RM = rm -rf

JOBS ?= 1
PROJ_NAME ?= vek385_reva_extensible_platform
PRE_SYNTH ?= FALSE

VEK385_BASE_DIR = $(abspath ../Vitis_Embedded_Platform_Source/Xilinx_Official_Platforms/vek385_base_reva)
BASE_XSA = $(VEK385_BASE_DIR)/hw/build/hw.xsa

VIV_PRJ_DIR = hw_project/$(PROJ_NAME)/outputs
VIV_XSA = $(VIV_PRJ_DIR)/$(PROJ_NAME).xsa

.PHONY: help
help:
	@echo 'Usage:'
	@echo ''
	@echo '  make xsa'
	@echo '    Build the vek385 reva XSA by delegating to vek385_base (make xsa)'
	@echo '    and install it as $(VIV_XSA).'
	@echo '  make all'
	@echo '    This will generate XSA.'
	@echo ''
	@echo 'Args:'
	@echo '  PROJ_NAME   Output XSA basename in $(VIV_PRJ_DIR)/ (default: vek385_reva_extensible_platform).'
	@echo '  PRE_SYNTH   Forwarded to vek385_base (TRUE for pre-synth XSA, default: FALSE).'
	@echo '  JOBS        Currently unused; vek385_base controls Vivado -jobs internally.'
	@echo ''
	@echo '  make clean'
	@echo '    Remove local hw_project and Vivado scratch files only.'
	@echo '    To also clean the shared vek385_base build tree, run:'
	@echo '      make -C $(VEK385_BASE_DIR) clean'

.PHONY: all
all: xsa

.PHONY: xsa
xsa: $(VIV_XSA)

$(VIV_XSA): $(BASE_XSA)
	mkdir -p $(VIV_PRJ_DIR)
	cp -f $(BASE_XSA) $@

$(BASE_XSA): FORCE
	$(MAKE) -C $(VEK385_BASE_DIR) xsa PRE_SYNTH=$(PRE_SYNTH)

.PHONY: FORCE
FORCE:

.PHONY: clean
clean:
	$(RM) $(VIV_PRJ_DIR) vivado* .Xil *dynamic* *.log *.xpe
