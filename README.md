# amd-yocto-hw-platforms

## Introduction

This repository generates base hardware projects and SDT files for kria and eval boards that Yocto supports, as well as some OOB hardware projects and SDT for Yocto-supported eval boards.

## Instructions

This repo contains submodules. To clone this repo, run:

```
git clone --recursive https://github.com/Xilinx/amd-yocto-hw-platforms.git
```

## Contents

The following platforms are supported:

1. Eval Boards
    1. zcu104
    2. vek280
2. Kria
    1. k26
        1. k26_base
        2. k26_prod
        3. kv260 starterkit
        4. kr260_starterkit
    2. k24
        1. k24_base
        2. k24_prod
        3. kd240_starterkit

## Required Tools

This repo requires vivado and vitis tools to build the hardware projects and SDT files.

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

