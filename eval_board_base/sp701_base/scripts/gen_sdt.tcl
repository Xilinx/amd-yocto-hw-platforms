# Copyright (C) 2025, Advanced Micro Devices, Inc.
# SPDX-License-Identifier: Apache-2.0

# parse arguments
for { set i 0 } { $i < $argc } { incr i } {
  # xsa name
  if { [lindex $argv $i] == "-xsa_name" } {
    incr i
    set xsa_name [lindex $argv $i]
  }
}

set xsa_path ./hw_project/$xsa_name/outputs/$xsa_name.xsa

set_dt_param -debug enable
set_dt_param -dir ./hw_project_sdt
set_dt_param -xsa $xsa_path
set_dt_param -board_dts sp701-rev1.0
set_dt_param -user_dts ./dts/xilinx-mbv64-sp701.dtsi
generate_sdt
