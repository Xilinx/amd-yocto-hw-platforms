# Copyright (C) 2024, Advanced Micro Devices, Inc.
# SPDX-License-Identifier: Apache-2.0

xhub::refresh_catalog [xhub::get_xstores Vivado_example_project]

set proj_name project_1
set proj_dir ./hw_project
set output_dir outputs
set board vek280

# parse arguments
for { set i 0 } { $i < $argc } { incr i } {
  # proj name
  if { [lindex $argv $i] == "-proj_name" } {
    incr i
    set proj_name [lindex $argv $i]
  }
  # jobs
  if { [lindex $argv $i] == "-jobs" } {
    incr i
    set jobs [lindex $argv $i]
  }
 }

#startegy for 2025.1_async, once ceds merged to store then update below with ced install commands
set_param board.repoPaths {/proj/xbuilds/2025.2_daily_latest/installs/lin64/2025.2/data/xhub/boards/XilinxBoardStore}
set_param ced.repoPaths {/proj/xbuilds/2025.2_daily_latest/installs/lin64/2025.2/data/xhub/ced/XilinxCEDStore}

create_project $proj_name $proj_dir/$proj_name -part xcve2802-vsvh1760-2MP-e-S
set_property board_part xilinx.com:$board:part0:* [current_project]
create_bd_design "versal_gen1_platform" -mode batch
instantiate_example_design -template xilinx.com:design:versal_gen1_platform:1.1 -design versal_gen1_platform

update_compile_order -fileset sources_1

save_bd_design
validate_bd_design
file mkdir $proj_dir/$proj_name/$output_dir

set outputs_dir $proj_dir/$proj_name/$output_dir

set fd [open $outputs_dir/README.hw w] 

puts $fd "##########################################################################"
puts $fd "This is a brief document containing design specific details for : ${board}"
puts $fd "This is auto-generated readme created @ [clock format [clock seconds] -format {%a %b %d %H:%M:%S %Z %Y}]"
puts $fd "##########################################################################"

set board_part [get_board_parts [current_board_part -quiet]]
if { $board_part != ""} {
	puts $fd "BOARD: $board_part"
}

set design_name [get_property NAME [get_bd_designs]]
puts $fd "BLOCK DESIGN: $design_name"


set columns {%40s%30s%15s%50s}
puts $fd [string repeat - 150]
puts $fd [format $columns "MODULE INSTANCE NAME" "IP TYPE" "IP VERSION" "IP"]
puts $fd [string repeat - 150]

foreach ip [get_ips] {
	set catlg_ip [get_ipdefs -all [get_property IPDEF $ip]]
	puts $fd [format $columns [get_property NAME $ip] [get_property NAME $catlg_ip] [get_property VERSION $catlg_ip] [get_property VLNV $catlg_ip]]
}

close $fd

launch_runs synth_1 -jobs $jobs
wait_on_run synth_1

launch_runs impl_1 -to_step write_bitstream

wait_on_run impl_1

set_property lock true [get_noc_net_routes -of [get_noc_logical_path -filter initial_boot]]
write_noc_solution -file $outputs_dir/${design_name}_noc_solution.ncr

open_run impl_1
write_hw_platform -fixed -include_bit -file $outputs_dir/${proj_name}.xsa
validate_hw_platform -verbose $outputs_dir/${proj_name}.xsa
