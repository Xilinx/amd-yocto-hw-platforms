# Copyright (C) 2024, Advanced Micro Devices, Inc.
# SPDX-License-Identifier: Apache-2.0

include platform.mk

.PHONY: help
help:
	@echo 'Usage:'
	@echo ''
	@echo '  make xsa'
	@echo '    Generate vek280 aie vdu example using vitis flow.'
	@echo '  make sdt'
	@echo '    Generate the SDT files from XSA'
	@echo '  make all'
	@echo '    This will generate both XSA and SDT'
	@echo 'Note Need to mandatory export SYSROOT BASE_XSA'
	@echo 'Note you need to have vitis aie license to build this app'
	@echo ''

ifndef BASE_XSA
$(error export BASE_XSA pointing xsa generated using vek280_oob_platform)
endif

ifndef SYSROOT
$(error  Download common tar from AMD downloads and install sdk.sh and export SYSROOT pointing platform specific sysroot)
endif

ifndef XILINX_VITIS
$(error Please source the vitis tools to continue)
endif

.PHONY: all
all: xsa sdt

xsa:
	$(MAKE) -C $(XGEMM_DIR) AIEARCH=$(AIEARCH)

sdt:
	$(SDTGEN) $(SDTGEN_SRC) -xsa_path $(XSA_PATH)

.PHONY: clean
clean:
	$(MAKE) clean -C $(PFMS_DIR)
	$(MAKE) clean -C $(XGEMM_DIR)
	$(RM) $(SDT_PRJ_DIR)

