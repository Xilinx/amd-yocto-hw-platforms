# Copyright (C) 2024, Advanced Micro Devices, Inc.
# SPDX-License-Identifier: Apache-2.0

# parse arguments
for { set i 0 } { $i < $argc } { incr i } {
  # xsa path
  if { [lindex $argv $i] == "-xsa_path" } {
    incr i
    set xsa_path [lindex $argv $i]
  }
}

 set_dt_param -debug enable
 set_dt_param -dir ./hw_project_sdt
 set_dt_param -xsa $xsa_path
 set_dt_param -board_dts versal-vek280-revb
 generate_sdt
