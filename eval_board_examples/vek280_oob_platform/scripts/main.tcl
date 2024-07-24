# Copyright (C) 2024, Advanced Micro Devices, Inc.
# SPDX-License-Identifier: Apache-2.0

set proj_board [get_board_parts "*:vek280:*" -latest_file_version]
        
set proj_name project_1
set proj_dir ./hw_project
set output_dir outputs
set board vek280
set output_dir outputs
set xdc_list {xdc/default.xdc}
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

set_param project.enableSocBootFlow true

create_project -name $proj_name -force -dir $proj_dir/$proj_name -part [get_property PART_NAME [get_board_parts $proj_board]]
set_property board_part $proj_board [current_project]

import_files -fileset constrs_1 $xdc_list
        

set_property ip_repo_paths $ip_repo_path [current_project] 
update_ip_catalog
    
# Create block diagram design and set as current design
set design_name $proj_name
create_bd_design $proj_name
current_bd_design $proj_name

# Set current bd instance as root of current design
set parentCell [get_bd_cells /]
set parentObj [get_bd_cells $parentCell]
current_bd_instance $parentObj
        
source ./scripts/config_bd.tcl
    
save_bd_design
    
assign_bd_address
        

make_wrapper -files [get_files ${proj_dir}/${proj_name}/${proj_name}.srcs/sources_1/bd/$proj_name/${proj_name}.bd] -top
import_files -force -norecurse ${proj_dir}/${proj_name}/${proj_name}.srcs/sources_1/bd/$proj_name/hdl/${proj_name}_wrapper.v
update_compile_order
set_property segmented_configuration true [current_project]
set_property top ${proj_name}_wrapper [current_fileset]
update_compile_order -fileset sources_1
        

save_bd_design
validate_bd_design
generate_target all [get_files ${proj_dir}/${proj_name}/${proj_name}.srcs/sources_1/bd/$proj_name/${proj_name}.bd]

#enable segmented configuration
set_property platform.pre_create_project_tcl_hook     "./scripts/enable_soc_boot_flow_prj.tcl"  [current_project]

file mkdir ${proj_dir}/${proj_name}/$output_dir
set outputs_dir ${proj_dir}/${proj_name}/$output_dir

set fd [open $outputs_dir/README.hw w] 

puts $fd "##########################################################################"
puts $fd "This is a brief document containing design specific details for : ${board}"
puts $fd "This is auto-generated by Petalinux ref-design builder created @ [clock format [clock seconds] -format {%a %b %d %H:%M:%S %Z %Y}]"
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

    
set_property synth_checkpoint_mode Hierarchical [get_files ${proj_dir}/${proj_name}/${proj_name}.srcs/sources_1/bd/$proj_name/${proj_name}.bd]
launch_runs synth_1 -jobs 32
wait_on_run synth_1
    
launch_runs impl_1 -to_step write_device_image

wait_on_run impl_1
                       

set files [glob ${proj_dir}/${proj_name}/${proj_name}.runs/impl_1/*.rcdo ${proj_dir}/${proj_name}/${proj_name}.runs/impl_1/*.rnpi ${proj_dir}/${proj_name}/${proj_name}.runs/impl_1/*.pdi] 
foreach fl $files {
    set newfl [string map {_wrapper {}} [file tail $fl]]
    file copy $fl $outputs_dir/$newfl
}
                       
file copy -force ${proj_dir}/${proj_name}/${proj_name}.runs/impl_1/gen_files ./$outputs_dir/
file copy -force ${proj_dir}/${proj_name}/${proj_name}.runs/impl_1/static_files ./$outputs_dir/
        
set_property platform.board_id $proj_name [current_project]
            
set_property platform.default_output_type "hw_export" [current_project]
            
set_property platform.design_intent.datacenter false [current_project]
            
set_property platform.design_intent.embedded true [current_project]
            
set_property platform.design_intent.external_host false [current_project]
            
set_property platform.design_intent.server_managed false [current_project]
            
set_property platform.extensible true [current_project]
            
set_property platform.name $proj_name [current_project]
            
set_property platform.platform_state "pre_synth" [current_project]
            
set_property platform.vendor "xilinx" [current_project]
            
set_property platform.version "1.0" [current_project]
            
open_run impl_1        
write_hw_platform -force -include_bit -file $outputs_dir/${proj_name}.xsa
validate_hw_platform -verbose $outputs_dir/${proj_name}.xsa
            
exit
        
