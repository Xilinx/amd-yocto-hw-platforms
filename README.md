# amd-yocto-hw-platforms

## Introduction

This repository generates base hardware projects and SDT files for kria and eval boards that Yocto supports, as well as some OOB hardware projects and SDT for Yocto-supported eval boards.

## Instructions

This repo contains submodules. To clone this repo, run:

```
git clone --recursive https://github.com/Xilinx/amd-yocto-hw-platforms.git
```

## Contents

This repository supports the following platforms and their respective examples:

1. Eval Boards
    1. zcu104_base
    2. vek280_base
2. Kria
    1. k26
        1. k26_base
        2. k26_prod
        3. kv260_base
        4. kr260_base
    2. k24
        1. k24c_base
        2. k24i_prod
        3. kd240_base
3. Eval Board Examples
    1. zcu104_pl_vcu_extensible	(Extensible Platform with VCU in PL)
    2. vek280_bram_gpio		(Segmented Platform with AXI_GPIO and BRAM in PL )
    3. vek280_oob_platform		(Segmented Extensible Platform with AIE and VDU in PL)
    4. vek280_aie_vdu_example		(Example to build AIE design and App with vek280_oob_platform using Vitis Tools)

## Required Tools

This repo requires vivado tools to build the hardware projects and SDT files.

```
source <vivado-install-path>/settings64.sh
```

## Build Instructions

cd to specific target directory and run make all

Example:

```
cd eval_board_base/vek280_base
make all
```

Note:Refer make help in specific directory for more information.

## License

Copyright (C) 2024, Advanced Micro Devices, Inc.
SPDX-License-Identifier: Apache-2.0

