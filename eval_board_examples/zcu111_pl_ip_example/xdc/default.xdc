# Copyright (C) 2024, Advanced Micro Devices, Inc.
# SPDX-License-Identifier: Apache-2.0

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]

# Clocks
# 100MHz board clock
set_property IOSTANDARD LVDS  [get_ports sys_diff_clock_clk_n]
set_property IOSTANDARD LVDS  [get_ports sys_diff_clock_clk_p]
set_property PACKAGE_PIN AN15 [get_ports sys_diff_clock_clk_n]
set_property PACKAGE_PIN AM15 [get_ports sys_diff_clock_clk_p]

# Inputs
set_property IOSTANDARD LVCMOS18 [get_ports ext_reset]
set_property PACKAGE_PIN AW3     [get_ports ext_reset]

# Status
set_property IOSTANDARD LVCMOS18  [get_ports led_bits[0]]
set_property PACKAGE_PIN AR13     [get_ports led_bits[0]]
set_property IOSTANDARD LVCMOS18  [get_ports led_bits[1]]
set_property PACKAGE_PIN AP13     [get_ports led_bits[1]]
set_property IOSTANDARD LVCMOS18  [get_ports led_bits[2]]
set_property PACKAGE_PIN AR16     [get_ports led_bits[2]]
set_property IOSTANDARD LVCMOS18  [get_ports led_bits[3]]
set_property PACKAGE_PIN AP16     [get_ports led_bits[3]]
set_property IOSTANDARD LVCMOS18  [get_ports led_bits[4]]
set_property PACKAGE_PIN AP15     [get_ports led_bits[4]]


