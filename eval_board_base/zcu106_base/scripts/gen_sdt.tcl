# Copyright (C) 2024, Advanced Micro Devices, Inc.
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
set_dt_param -board_dts zynqmp-zcu106-rev1.0
generate_sdt
