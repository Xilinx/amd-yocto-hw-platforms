
#Beta devices not enabled.  

xhub::refresh_catalog [xhub::get_xstores Vivado_example_project]

set proj_name project_1
set proj_dir ./hw_project
set output_dir outputs
set board zcu104

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
	        
create_project $proj_name $proj_dir/$proj_name -part xczu7ev-ffvc1156-2-e
set_property board_part xilinx.com:$board:part0:* [current_project]
create_bd_design "MPSoC_ext_platform" -mode batch
instantiate_example_design -template xilinx.com:design:MPSoC_ext_platform:1.0 -design MPSoC_ext_platform -options { Clock_Options.VALUE {clk_out1 100.000 0 false clk_out2 200.000 1 true clk_out3 400.000 2 false} Include_DDR.VALUE false}

update_compile_order -fileset sources_1
        
save_bd_design
validate_bd_design
file mkdir $proj_dir/$proj_name/$output_dir

set outputs_dir $proj_dir/$proj_name/$output_dir

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

launch_runs synth_1 -jobs $jobs
wait_on_run synth_1
    
launch_runs impl_1 -to_step write_bitstream
            
wait_on_run impl_1
        
open_run impl_1        
write_hw_platform -force -include_bit -file $outputs_dir/${proj_name}.xsa
validate_hw_platform -verbose $outputs_dir/${proj_name}.xsa
            
exit
        
