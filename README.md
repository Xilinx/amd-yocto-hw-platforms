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

1. Eval Boards Base
    1. zcu104_base
    2. vek280_base
    3. vck190_base
    4. vek385_base
    5. vek385_revb_base
    6. vmk180_base
    7. vm-p-m1369-00_base
    8. vpk120_base
    9. vrk160_base
    10. zc702_base
    11. zcu102_base
    12. v80_base
    13. zcu106_base
    14. zcu111_base
    15. zcu208_base
2. Kria Base
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
    1. zcu104_pl_vcu_extensible		(Extensible Platform with VCU in PL)
    2. vck190_extensible_platform	(Segmented Extensible Platform with AIE in PL)
    3. vek280_extensible_platform	(Segmented Extensible Platform with AIE in PL)
    4. vek280_pl_vdu_example		(Segemented PL VDU example)
    5. vek385_bram_gpio_timer		(Segmented Platform with AXI_GPIO and BRAM in PL)
    6. aie_gmio_example			(Example to build AIE design and App with vck190/vek280 extensible platform using Vitis Tools)

## Required Tools

This repo requires vivado tools to build the hardware projects and SDT files.

```
source <vivado-install-path>/settings64.sh
```

## Build Instructions

cd to specific target directory and run make all JOBS=<No of jobs>

Example:

```
cd eval_board_base/vek280_base
make all
```

Note:Refer make help in specific directory for more information.  
Note:Refer UG904 for JOBS and TCL option for threads https://docs.amd.com/r/en-US/ug904-vivado-implementation

## License

Copyright (C) 2024, Advanced Micro Devices, Inc.
SPDX-License-Identifier: Apache-2.0

