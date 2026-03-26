# Copyright (C) 2026, Advanced Micro Devices, Inc.
# SPDX-License-Identifier: Apache-2.0
xhub::refresh_catalog [xhub::get_xstores Vivado_example_project]

set proj_board [get_board_parts "*:zcu111:*" -latest_file_version]
        
set proj_name zcu111_pl_ip_example
set proj_dir ./hw_project
set output_dir outputs
set board zcu111
set board_part xilinx.com:$board:part0:2.0
set device xczu28dr-ffvg1517-2-e
#set rev None
set my_design_name MPSoC_ext_platform
set ced_template xilinx.com:design:MPSoC_ext_platform:1.0
#set output {xsa bit}
#set xdc_list {xdc/default.xdc}
#set ip_repo_path {}
#set src_repo_path {}
	        
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


create_project $proj_name $proj_dir/$proj_name -part $device
set_property board_part $board_part [current_project]
create_bd_design $my_design_name -mode batch
instantiate_example_design -template $ced_template -design $my_design_name -options { Include_DDR.VALUE false}
#
update_compile_order -fileset sources_1

set_property  ip_repo_paths  ./local_repo [current_project]
update_ip_catalog

puts "INFO: source ./scripts/pl_ip.tcl"
source ./scripts/pl_ip.tcl

puts "INFO: create_pl_ip_blocks ${proj_dir}/${proj_name}"
create_pl_ip_blocks ${proj_dir}/${proj_name}

assign_bd_address
save_bd_design
validate_bd_design

# Remove the auto generated wrapper and create/add a new one
remove_files  ${proj_dir}/${proj_name}/${proj_name}.srcs/sources_1/imports/hdl/${my_design_name}_wrapper.v
file delete -force ${proj_dir}/${proj_name}/${proj_name}.srcs/sources_1/imports/hdl/${my_design_name}_wrapper.v
make_wrapper -files [get_files ${proj_dir}/${proj_name}/${proj_name}.srcs/sources_1/bd/${my_design_name}/${my_design_name}.bd] -top
add_files -norecurse ${proj_dir}/${proj_name}/${proj_name}.gen/sources_1/bd/${my_design_name}/hdl/${my_design_name}_wrapper.v
update_compile_order -fileset sources_1

add_files -fileset constrs_1 -norecurse ${proj_dir}/../xdc/default.xdc
import_files -fileset constrs_1 ${proj_dir}/../xdc/default.xdc


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

set my_design_name [get_property NAME [get_bd_designs]]
puts $fd "BLOCK DESIGN: ${my_design_name}" 


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
        
open_run impl_1        
write_hw_platform -force -include_bit -file $outputs_dir/${proj_name}.xsa
validate_hw_platform -verbose $outputs_dir/${proj_name}.xsa
            
exit
        
