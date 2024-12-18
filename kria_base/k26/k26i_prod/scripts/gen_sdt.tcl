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

sdtgen set_dt_param -debug enable
sdtgen set_dt_param -dir ./hw_project_sdt
sdtgen set_dt_param -xsa $xsa_path
sdtgen set_dt_param -board_dts zynqmp-sm-k26-reva
sdtgen generate_sdt
sdtgen copy_hw_files
