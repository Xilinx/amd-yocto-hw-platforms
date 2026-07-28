# amd-yocto-hw-platforms

> - **For a specific release**, check out the corresponding release tag, for example:
>   ```
>   git clone --recursive https://github.com/Xilinx/amd-yocto-hw-platforms.git
>   cd amd-yocto-hw-platforms
>   git checkout <release-tag>
>   git submodule update --init --recursive
>   ```
>   Run `git tag` to list all available release tags, and replace `<release-tag>`
>   with the tag you want to use (for example, `xilinx_v2026.1`).

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
    1. scu200_base
    2. scu200_revb_base
    3. scu200_zephyr_32bit
    4. scu35_base
    5. sp701_base
    6. vck190_base
    7. ve-p-a1225-00-psxc-seio
    8. vek280_base
    9. vek385_base
    10. vek385_revb_base
    11. vek386_base
    12. vhk158_base
    13. vm-p-a2112-x-prc-11_base
    14. vm-p-m1369-00_base
    15. vmk180_base
    16. vmk365_base
    17. vn-p-b2197-x-prc-07_base
    18. vn-p-b2197-x-prc-09_base
    19. vp-p-c3340-x-prc-01_base
    20. vpk120_base
    21. vpk180_base
    22. vpk360_base
    23. vrk160_base
    24. vrk165_base
    25. zc702_base
    26. zc706_base
    27. zcu102_base
    28. zcu104_base
    29. zcu106_base
    30. zcu111_base
    31. zcu208_base
    32. zcu216_base
2. Kria Base
    1. k26
        1. k26c_base
        2. k26i_prod
        3. kv260_base
        4. kr260_base
    2. k24
        1. k24c_base
        2. k24c_prod
        3. k24i_prod
        4. kd240_base
3. Eval Board Examples
    1. aie_gmio_example			(Example to build AIE design and App with vck190/vek280 extensible platform using Vitis Tools)
    2. vck190_extensible_platform	(Segmented Extensible Platform with AIE in PL)
    3. vek280_extensible_platform	(Segmented Extensible Platform with AIE in PL)
    4. vek280_pl_vdu_example		(Segmented PL VDU example)
    5. vek385_axi_uartlite		(Segmented Platform with AXI UART Lite in PL)
    6. vek385_extensible_platform	(Segmented Extensible Platform)
    7. vek385_pl_gpio_bram		(Segmented Platform with AXI_GPIO and BRAM in PL)
    8. vek385_reva_extensible_platform	(Rev A Segmented Extensible Platform)
    9. vek385_revb_pl_gpio_bram		(Rev B Segmented Platform with AXI_GPIO and BRAM in PL)
    10. vek386_pl_gpio_bram		(Segmented Platform with AXI_GPIO and BRAM in PL)
    11. vpk360_pl_gpio_bram		(Segmented Platform with AXI_GPIO and BRAM in PL)
    12. vrk160_extensible_platform	(Segmented Extensible Platform)
    13. zcu104_pl_vcu_example		(PL VCU example)
    14. zcu104_pl_vcu_extensible	(Extensible Platform with VCU in PL)
    15. zcu106_pl_vcu_example		(PL VCU example)
    16. zcu111_pl_ip_example		(PL IP example)

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

