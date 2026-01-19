# Copyright (C) 2024, Advanced Micro Devices, Inc.
# SPDX-License-Identifier: Apache-2.0
xhub::refresh_catalog [xhub::get_xstores Vivado_example_project]

set proj_board [get_board_parts "*:zcu104:*" -latest_file_version]
        
set proj_name project_1
set proj_dir ./hw_project
set output_dir outputs
set board zcu104
set device zu7
set rev None
set output {xsa bit}
set xdc_list {xdc/default.xdc xdc/zcu104_vcu_uc2_pll.xdc}
set ip_repo_path {}
set src_repo_path {}
	        
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

#create_project -name $proj_name -force -dir $proj_dir/$proj_name -part [get_property PART_NAME [get_board_parts $proj_board]]
#set_property board_part $proj_board [current_project]
create_project $proj_name $proj_dir/$proj_name -part xczu7ev-ffvc1156-2-e
set_property board_part xilinx.com:$board:part0:* [current_project]
create_bd_design "MPSoC_ext_platform" -mode batch
instantiate_example_design -template xilinx.com:design:MPSoC_ext_platform:1.0 -design MPSoC_ext_platform -options { Include_DDR.VALUE false}
#update_compile_order -fileset sources_1
#
update_compile_order -fileset sources_1

#source pl vdu tcl
source ./scripts/vcu.tcl
assign_bd_address
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
        

set_property platform.board_id $proj_name [current_project]
            
set_property platform.design_intent.datacenter false [current_project]
            
set_property platform.design_intent.embedded true [current_project]
            
set_property platform.design_intent.external_host false [current_project]
            
set_property platform.design_intent.server_managed false [current_project]
            
set_property platform.extensible true [current_project]
            
set_property platform.name $proj_name [current_project]
            
set_property platform.vendor "xilinx" [current_project]
            
set_property platform.version "1.0" [current_project]
            
open_run impl_1        
write_hw_platform -force -include_bit -file $outputs_dir/${proj_name}.xsa
validate_hw_platform -verbose $outputs_dir/${proj_name}.xsa
            
exit
        
