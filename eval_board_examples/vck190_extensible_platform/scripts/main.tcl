# Copyright (C) 2024, Advanced Micro Devices, Inc.
# SPDX-License-Identifier: Apache-2.0

xhub::refresh_catalog [xhub::get_xstores Vivado_example_project]

set proj_name project_1
set proj_dir ./hw_project
set output_dir outputs
set board vck190
variable design_name
set design_name vitis_design

set noc_solution ""

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
  # noc solution file path
  if { [lindex $argv $i] == "-noc_solution" } {
    incr i
    set noc_solution [lindex $argv $i]
  }
 }

create_project $proj_name $proj_dir/$proj_name -part xcvc1902-vsva2197-2MP-e-S
set_property board_part xilinx.com:$board:part0:* [current_project]
set_property segmented_configuration true [current_project]

# Emulation (hw_emu) prerequisite: Versal requires the TLM sim model.
# Simulator defaults to XSim (Vivado built-in); no target_simulator override needed.
set_property PREFERRED_SIM_MODEL "tlm" [current_project]

create_bd_design $design_name -mode batch
instantiate_example_design -template xilinx.com:design:base_ext_platform:1.0 -design $design_name

update_compile_order -fileset sources_1
        
save_bd_design
if { $noc_solution ne "" } {
  puts "INFO: Reading NOC solution from: $noc_solution"
  read_noc_solution $noc_solution
}

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

# ---- Emulation (hw_emu) XSA ----
# Generated before synthesis: the hw_emu platform only needs the block design
# simulation model, not implementation. Mirrors the vck190_base flow.
generate_target all [get_files -norecurse ${design_name}.bd]
update_compile_order -fileset sources_1
# If the NoC switch network (xlnoc.bd) is not auto-generated for sim, uncomment:
#generate_switch_network_for_noc
update_compile_order -fileset sim_1
launch_simulation -scripts_only
launch_simulation -step compile
launch_simulation -step elaborate
file mkdir $outputs_dir/hw_emu
write_hw_platform -hw_emu -force $outputs_dir/hw_emu/${proj_name}_hw_emu.xsa
validate_hw_platform -verbose $outputs_dir/hw_emu/${proj_name}_hw_emu.xsa

launch_runs synth_1 -jobs $jobs
wait_on_run synth_1
    
launch_runs impl_1 -to_step write_bitstream
            
wait_on_run impl_1

open_run impl_1

set_property lock true [get_noc_net_routes -of [get_noc_logical_path -filter {initial_boot == 1}]]
set_property lock true [get_noc_net_routes -of [get_noc_logical_paths -of [get_noc_logical_instances *N?U128*]]]

write_noc_solution -file $outputs_dir/${design_name}_noc_solution.ncr

write_hw_platform -hw -force $outputs_dir/${proj_name}.xsa
validate_hw_platform -verbose $outputs_dir/${proj_name}.xsa
