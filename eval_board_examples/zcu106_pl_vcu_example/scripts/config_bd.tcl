# Copyright (C) 2024, Advanced Micro Devices, Inc.
# SPDX-License-Identifier: Apache-2.0

xhub::refresh_catalog [xhub::get_xstores Vivado_example_project]

set proj_name zcu106
set proj_dir ./hw_project
set output_dir outputs
set board zcu106

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
instantiate_example_design -template xilinx.com:design:MPSoC_ext_platform:1.0 -design MPSoC_ext_platform -options { Include_DDR.VALUE false}
update_compile_order -fileset sources_1

#source pl vdu tcl
#source ./scripts/vdu.tcl

create_bd_cell -type ip -vlnv xilinx.com:ip:vcu:1.2 vcu_0
set_property -dict [list \
  CONFIG.PSU__SAXIGP4__DATA_WIDTH {32} \
  CONFIG.PSU__USE__S_AXI_GP0 {1} \
  CONFIG.PSU__USE__S_AXI_GP1 {1} \
  CONFIG.PSU__USE__S_AXI_GP2 {1} \
  CONFIG.PSU__USE__S_AXI_GP3 {1} \
  CONFIG.PSU__USE__S_AXI_GP4 {1} \
] [get_bd_cells ps_e]

connect_bd_intf_net [get_bd_intf_pins vcu_0/M_AXI_ENC0] [get_bd_intf_pins ps_e/S_AXI_HPC0_FPD]
connect_bd_intf_net [get_bd_intf_pins vcu_0/M_AXI_ENC1] [get_bd_intf_pins ps_e/S_AXI_HPC1_FPD]
connect_bd_intf_net [get_bd_intf_pins vcu_0/M_AXI_DEC0] [get_bd_intf_pins ps_e/S_AXI_HP0_FPD]
connect_bd_intf_net [get_bd_intf_pins vcu_0/M_AXI_DEC1] [get_bd_intf_pins ps_e/S_AXI_HP1_FPD]
connect_bd_intf_net [get_bd_intf_pins vcu_0/M_AXI_MCU] [get_bd_intf_pins ps_e/S_AXI_HP2_FPD]

connect_bd_net [get_bd_pins vcu_0/vcu_host_interrupt] [get_bd_pins axi_intc_0/intr]
set_property CONFIG.NUM_MI {2} [get_bd_cells smartconnect_axilite]
connect_bd_net [get_bd_pins ps_e/saxihp2_fpd_aclk] [get_bd_pins ps_e/saxihpc0_fpd_aclk]
connect_bd_net [get_bd_pins ps_e/saxihpc0_fpd_aclk] [get_bd_pins clk_wiz_0/clk_out2]
connect_bd_net [get_bd_pins ps_e/saxihpc1_fpd_aclk] [get_bd_pins clk_wiz_0/clk_out2]
connect_bd_net [get_bd_pins ps_e/saxihp0_fpd_aclk] [get_bd_pins clk_wiz_0/clk_out2]
connect_bd_net [get_bd_pins ps_e/saxihp1_fpd_aclk] [get_bd_pins clk_wiz_0/clk_out2]
connect_bd_net [get_bd_pins vcu_0/s_axi_lite_aclk] [get_bd_pins clk_wiz_0/clk_out2]
connect_bd_net [get_bd_pins vcu_0/vcu_resetn] [get_bd_pins proc_sys_reset_1/peripheral_aresetn]

set_property -dict [list \
  CONFIG.CLKOUT4_JITTER {144.570} \
  CONFIG.CLKOUT4_PHASE_ERROR {87.180} \
  CONFIG.CLKOUT4_REQUESTED_OUT_FREQ {33.333} \
  CONFIG.CLKOUT4_USED {true} \
  CONFIG.MMCM_CLKOUT3_DIVIDE {36} \
  CONFIG.NUM_OUT_CLKS {4} \
] [get_bd_cells clk_wiz_0]
connect_bd_net [get_bd_pins clk_wiz_0/clk_out4] [get_bd_pins vcu_0/pll_ref_clk]
connect_bd_net [get_bd_pins vcu_0/m_axi_mcu_aclk] [get_bd_pins clk_wiz_0/clk_out2]
connect_bd_net [get_bd_pins vcu_0/m_axi_enc_aclk] [get_bd_pins clk_wiz_0/clk_out2]
connect_bd_net [get_bd_pins vcu_0/m_axi_dec_aclk] [get_bd_pins clk_wiz_0/clk_out2]
connect_bd_intf_net [get_bd_intf_pins smartconnect_axilite/M01_AXI] [get_bd_intf_pins vcu_0/S_AXI_LITE]

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

open_run impl_1


set_property platform.board_id $proj_name [current_project]
            
set_property platform.design_intent.datacenter false [current_project]
            
set_property platform.design_intent.embedded true [current_project]
            
set_property platform.design_intent.external_host false [current_project]
            
set_property platform.design_intent.server_managed false [current_project]
            
set_property platform.extensible true [current_project]
            
set_property platform.name $proj_name [current_project]
            
set_property platform.vendor "xilinx" [current_project]
            
set_property platform.version "1.0" [current_project]

set_property platform.platform_state {impl} [current_project]

set_property platform.uses_pr {true} [current_project]


write_hw_platform -hw -force $outputs_dir/${proj_name}.xsa
validate_hw_platform -verbose $outputs_dir/${proj_name}.xsa




