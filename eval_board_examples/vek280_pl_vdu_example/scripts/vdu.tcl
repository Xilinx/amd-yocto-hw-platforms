create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0
set_property CONFIG.NUM_SI {1} [get_bd_cells smartconnect_0]
set_property -dict [list \
  CONFIG.NUM_CLKS {1} \
  CONFIG.NUM_MI {2} \
  CONFIG.NUM_SI {1} \
] [get_bd_cells smartconnect_0]
create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wizard:1.0 clk_wizard_0
set_property -dict [list \
  CONFIG.CLKOUT_REQUESTED_OUT_FREQUENCY {100.000,300.000,100.000,100.000,100.000,100.000,100.000} \
  CONFIG.CLKOUT_USED {true,true,false,false,false,false,false} \
  CONFIG.USE_RESET {true} \
] [get_bd_cells clk_wizard_0]
set_property CONFIG.RESET_TYPE {ACTIVE_LOW} [get_bd_cells clk_wizard_0]
connect_bd_net [get_bd_pins CIPS_0/pl0_ref_clk] [get_bd_pins clk_wizard_0/clk_in1]
connect_bd_net [get_bd_pins CIPS_0/pl0_resetn] [get_bd_pins clk_wizard_0/resetn]
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0
proc create_hier_cell_vdu { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_vdu() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI4

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI5

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI6

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI7

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI8

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI


  # Create pins
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type clk mcu_dec_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn
  create_bd_pin -dir I -type clk ref_clk
  create_bd_pin -dir O -type intr vdu_host_interrupt0
  create_bd_pin -dir O -type intr vdu_host_interrupt1
  create_bd_pin -dir O -type intr vdu_host_interrupt2
  create_bd_pin -dir O -type intr vdu_host_interrupt3

  # Create instance: vdu_0, and set properties
  set vdu_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:vdu:2.* vdu_0 ]
  set_property -dict [list \
  CONFIG.CORE_CLK {800} \
  CONFIG.NO_OF_DEC_INSTANCES {3} \
  ] $vdu_0
  

      # Create instance: smartconnect_vdu, and set properties
  set smartconnect_vdu [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.* smartconnect_vdu ]
  set_property CONFIG.NUM_SI {1} $smartconnect_vdu


  # Create instance: axi_register_slice_vdu_0, and set properties
  set axi_register_slice_vdu_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.* axi_register_slice_vdu_0 ]

  # Create instance: axi_register_slice_vdu_1, and set properties
  set axi_register_slice_vdu_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.* axi_register_slice_vdu_1 ]

  # Create instance: axi_register_slice_vdu_2, and set properties
  set axi_register_slice_vdu_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.* axi_register_slice_vdu_2 ]

  # Create instance: axi_register_slice_vdu_3, and set properties
  set axi_register_slice_vdu_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.* axi_register_slice_vdu_3 ]

  # Create instance: axi_register_slice_vdu_4, and set properties
  set axi_register_slice_vdu_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.* axi_register_slice_vdu_4 ]

  # Create instance: axi_register_slice_vdu_5, and set properties
  set axi_register_slice_vdu_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.* axi_register_slice_vdu_5 ]

  # Create instance: axi_register_slice_vdu_6, and set properties
  set axi_register_slice_vdu_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.* axi_register_slice_vdu_6 ]

  # Create instance: axi_register_slice_vdu_7, and set properties
  set axi_register_slice_vdu_7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.* axi_register_slice_vdu_7 ]

  # Create instance: axi_register_slice_vdu_8, and set properties
  set axi_register_slice_vdu_8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.* axi_register_slice_vdu_8 ]

  # Create instance: axi_gpio_vdu, and set properties
  set axi_gpio_vdu [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.* axi_gpio_vdu ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_DOUT_DEFAULT {0x00000001} \
    CONFIG.C_GPIO_WIDTH {1} \
  ] $axi_gpio_vdu


  # Create interface connections
  connect_bd_intf_net -intf_net axi_register_slice_vdu_0_M_AXI [get_bd_intf_pins M_AXI] [get_bd_intf_pins axi_register_slice_vdu_0/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_vdu_1_M_AXI [get_bd_intf_pins M_AXI1] [get_bd_intf_pins axi_register_slice_vdu_1/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_vdu_2_M_AXI [get_bd_intf_pins M_AXI2] [get_bd_intf_pins axi_register_slice_vdu_2/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_vdu_3_M_AXI [get_bd_intf_pins M_AXI3] [get_bd_intf_pins axi_register_slice_vdu_3/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_vdu_4_M_AXI [get_bd_intf_pins M_AXI4] [get_bd_intf_pins axi_register_slice_vdu_4/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_vdu_5_M_AXI [get_bd_intf_pins M_AXI5] [get_bd_intf_pins axi_register_slice_vdu_5/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_vdu_6_M_AXI [get_bd_intf_pins M_AXI6] [get_bd_intf_pins axi_register_slice_vdu_6/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_vdu_7_M_AXI [get_bd_intf_pins M_AXI7] [get_bd_intf_pins axi_register_slice_vdu_7/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_vdu_8_M_AXI [get_bd_intf_pins M_AXI8] [get_bd_intf_pins axi_register_slice_vdu_8/M_AXI]
  connect_bd_intf_net -intf_net ctrl_smc_M03_AXI [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins vdu_0/S_AXI_LITE]
  connect_bd_intf_net -intf_net ctrl_smc_M04_AXI [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_gpio_vdu/S_AXI]
  connect_bd_intf_net -intf_net smartconnect_vdu_M00_AXI [get_bd_intf_pins smartconnect_vdu/M00_AXI] [get_bd_intf_pins axi_register_slice_vdu_8/S_AXI]
  connect_bd_intf_net -intf_net vdu_0_M_AXI_DEC0_0 [get_bd_intf_pins vdu_0/M_AXI_DEC0_0] [get_bd_intf_pins axi_register_slice_vdu_0/S_AXI]
  connect_bd_intf_net -intf_net vdu_0_M_AXI_DEC0_1 [get_bd_intf_pins vdu_0/M_AXI_DEC0_1] [get_bd_intf_pins axi_register_slice_vdu_1/S_AXI]
  connect_bd_intf_net -intf_net vdu_0_M_AXI_DEC1_0 [get_bd_intf_pins vdu_0/M_AXI_DEC1_0] [get_bd_intf_pins axi_register_slice_vdu_2/S_AXI]
  connect_bd_intf_net -intf_net vdu_0_M_AXI_DEC1_1 [get_bd_intf_pins axi_register_slice_vdu_3/S_AXI] [get_bd_intf_pins vdu_0/M_AXI_DEC1_1]
  connect_bd_intf_net -intf_net vdu_0_M_AXI_DEC2_0 [get_bd_intf_pins axi_register_slice_vdu_4/S_AXI] [get_bd_intf_pins vdu_0/M_AXI_DEC2_0]
  connect_bd_intf_net -intf_net vdu_0_M_AXI_DEC2_1 [get_bd_intf_pins axi_register_slice_vdu_5/S_AXI] [get_bd_intf_pins vdu_0/M_AXI_DEC2_1]
  connect_bd_intf_net -intf_net vdu_0_M_AXI_DEC3_0 [get_bd_intf_pins axi_register_slice_vdu_6/S_AXI] [get_bd_intf_pins vdu_0/M_AXI_DEC3_0]
  connect_bd_intf_net -intf_net vdu_0_M_AXI_DEC3_1 [get_bd_intf_pins axi_register_slice_vdu_7/S_AXI] [get_bd_intf_pins vdu_0/M_AXI_DEC3_1]
  connect_bd_intf_net -intf_net vdu_0_M_AXI_MCU [get_bd_intf_pins smartconnect_vdu/S00_AXI] [get_bd_intf_pins vdu_0/M_AXI_MCU]

  # Create port connections
  connect_bd_net -net axi_gpio_vdu_gpio_io_o  [get_bd_pins axi_gpio_vdu/gpio_io_o] \
  [get_bd_pins vdu_0/vdu_resetn]
  connect_bd_net -net clk_wizard_0_clk_out1  [get_bd_pins s_axi_aclk] \
  [get_bd_pins axi_gpio_vdu/s_axi_aclk] \
  [get_bd_pins vdu_0/s_axi_lite_aclk] \
  
  
  connect_bd_net -net clk_wizard_0_clk_out2   [get_bd_pins mcu_dec_axi_aclk] \
  [get_bd_pins vdu_0/m_axi_mcu_aclk] \
  [get_bd_pins vdu_0/m_axi_dec_aclk] \
  [get_bd_pins axi_register_slice_vdu_0/aclk] \
  [get_bd_pins axi_register_slice_vdu_1/aclk] \
  [get_bd_pins axi_register_slice_vdu_8/aclk] \
  [get_bd_pins axi_register_slice_vdu_5/aclk] \
  [get_bd_pins axi_register_slice_vdu_7/aclk] \
  [get_bd_pins axi_register_slice_vdu_6/aclk] \
  [get_bd_pins axi_register_slice_vdu_4/aclk] \
  [get_bd_pins axi_register_slice_vdu_2/aclk] \
  [get_bd_pins axi_register_slice_vdu_3/aclk] \
  [get_bd_pins smartconnect_vdu/aclk]

  connect_bd_net -net ref_clk_1  [get_bd_pins ref_clk] \
  [get_bd_pins vdu_0/ref_clk]
  connect_bd_net -net rst_clk_wizard_0_100M_peripheral_aresetn  [get_bd_pins s_axi_aresetn] \
  [get_bd_pins axi_gpio_vdu/s_axi_aresetn] \
  [get_bd_pins axi_register_slice_vdu_0/aresetn] \
  [get_bd_pins axi_register_slice_vdu_1/aresetn] \
  [get_bd_pins axi_register_slice_vdu_8/aresetn] \
  [get_bd_pins axi_register_slice_vdu_5/aresetn] \
  [get_bd_pins axi_register_slice_vdu_7/aresetn] \
  [get_bd_pins axi_register_slice_vdu_6/aresetn] \
  [get_bd_pins axi_register_slice_vdu_4/aresetn] \
  [get_bd_pins axi_register_slice_vdu_2/aresetn] \
  [get_bd_pins axi_register_slice_vdu_3/aresetn] \
  [get_bd_pins smartconnect_vdu/aresetn]
  connect_bd_net -net vdu_0_vdu_host_interrupt0  [get_bd_pins vdu_0/vdu_host_interrupt0] \
  [get_bd_pins vdu_host_interrupt0]
  connect_bd_net -net vdu_0_vdu_host_interrupt1  [get_bd_pins vdu_0/vdu_host_interrupt1] \
  [get_bd_pins vdu_host_interrupt1]
  connect_bd_net -net vdu_0_vdu_host_interrupt2  [get_bd_pins vdu_0/vdu_host_interrupt2] \
  [get_bd_pins vdu_host_interrupt2]
  connect_bd_net -net vdu_0_vdu_host_interrupt3  [get_bd_pins vdu_0/vdu_host_interrupt3] \
  [get_bd_pins vdu_host_interrupt3]

  # Restore current instance
  current_bd_instance $oldCurInst
}
create_hier_cell_vdu [current_bd_instance .] vdu
connect_bd_net [get_bd_pins clk_wizard_0/clk_out1] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
connect_bd_net [get_bd_pins vdu/s_axi_aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
connect_bd_net [get_bd_pins smartconnect_0/aclk] [get_bd_pins clk_wizard_0/clk_out2]
connect_bd_net [get_bd_pins smartconnect_0/aresetn] [get_bd_pins proc_sys_reset_0/interconnect_aresetn]
connect_bd_intf_net [get_bd_intf_pins smartconnect_0/M00_AXI] -boundary_type upper [get_bd_intf_pins vdu/S_AXI_LITE]
connect_bd_intf_net [get_bd_intf_pins smartconnect_0/M01_AXI] -boundary_type upper [get_bd_intf_pins vdu/S_AXI]
connect_bd_intf_net [get_bd_intf_pins CIPS_0/M_AXI_FPD] [get_bd_intf_pins smartconnect_0/S00_AXI]
disconnect_bd_net /ilconstant_0_dout [get_bd_pins CIPS_0/m_axi_fpd_aclk]
connect_bd_net [get_bd_pins CIPS_0/m_axi_fpd_aclk] [get_bd_pins clk_wizard_0/clk_out1]
delete_bd_objs [get_bd_nets clk_wizard_0_clk_out2]
connect_bd_net [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins CIPS_0/pl0_resetn]
connect_bd_net [get_bd_pins vdu/vdu_host_interrupt0] [get_bd_pins CIPS_0/pl_ps_irq0]
connect_bd_net [get_bd_pins vdu/vdu_host_interrupt1] [get_bd_pins CIPS_0/pl_ps_irq1]
connect_bd_net [get_bd_pins vdu/vdu_host_interrupt2] [get_bd_pins CIPS_0/pl_ps_irq2]
connect_bd_net [get_bd_pins vdu/vdu_host_interrupt3] [get_bd_pins CIPS_0/pl_ps_irq3]
connect_bd_net [get_bd_pins vdu/s_axi_aclk] [get_bd_pins clk_wizard_0/clk_out1]
connect_bd_net [get_bd_pins vdu/mcu_dec_axi_aclk] [get_bd_pins clk_wizard_0/clk_out2]
connect_bd_net [get_bd_pins smartconnect_0/aclk] [get_bd_pins clk_wizard_0/clk_out1]
connect_bd_net [get_bd_pins vdu/ref_clk] [get_bd_pins CIPS_0/pl0_ref_clk]
set_property CONFIG.NUM_SI {9} [get_bd_cells aggr_noc]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins vdu/M_AXI] [get_bd_intf_pins aggr_noc/S00_AXI]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins vdu/M_AXI1] [get_bd_intf_pins aggr_noc/S01_AXI]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins vdu/M_AXI2] [get_bd_intf_pins aggr_noc/S02_AXI]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins vdu/M_AXI3] [get_bd_intf_pins aggr_noc/S03_AXI]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins vdu/M_AXI4] [get_bd_intf_pins aggr_noc/S04_AXI]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins vdu/M_AXI5] [get_bd_intf_pins aggr_noc/S05_AXI]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins vdu/M_AXI6] [get_bd_intf_pins aggr_noc/S06_AXI]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins vdu/M_AXI7] [get_bd_intf_pins aggr_noc/S07_AXI]
connect_bd_net [get_bd_pins aggr_noc/aclk0] [get_bd_pins clk_wizard_0/clk_out2]
set_property -dict [list CONFIG.CONNECTIONS {M00_INI {read_bw {500} write_bw {500} }}] [get_bd_intf_pins /aggr_noc/S00_AXI]
set_property -dict [list CONFIG.CONNECTIONS {M01_INI {read_bw {500} write_bw {500} } M00_INI {read_bw {500} write_bw {500} }}] [get_bd_intf_pins /aggr_noc/S01_AXI]
set_property -dict [list CONFIG.CONNECTIONS {M02_INI {read_bw {500} write_bw {500} } M00_INI {read_bw {500} write_bw {500} }}] [get_bd_intf_pins /aggr_noc/S02_AXI]
set_property -dict [list CONFIG.CONNECTIONS {M02_INI {read_bw {500} write_bw {500} } M00_INI {read_bw {500} write_bw {500} }}] [get_bd_intf_pins /aggr_noc/S03_AXI]
set_property -dict [list CONFIG.CONNECTIONS {M03_INI {read_bw {500} write_bw {500} } M00_INI {read_bw {500} write_bw {500} }}] [get_bd_intf_pins /aggr_noc/S04_AXI]
set_property -dict [list CONFIG.CONNECTIONS {M03_INI {read_bw {500} write_bw {500} } M00_INI {read_bw {500} write_bw {500} }}] [get_bd_intf_pins /aggr_noc/S05_AXI]
set_property -dict [list CONFIG.CONNECTIONS {M00_INI {read_bw {500} write_bw {500} }}] [get_bd_intf_pins /aggr_noc/S06_AXI]
set_property -dict [list CONFIG.CONNECTIONS {M00_INI {read_bw {500} write_bw {500} }}] [get_bd_intf_pins /aggr_noc/S07_AXI]
set_property -dict [list CONFIG.CONNECTIONS {M04_INI {read_bw {500} write_bw {500} } M00_INI {read_bw {500} write_bw {500} }}] [get_bd_intf_pins /aggr_noc/S06_AXI]
set_property -dict [list CONFIG.CONNECTIONS {M04_INI {read_bw {500} write_bw {500} } M00_INI {read_bw {500} write_bw {500} }}] [get_bd_intf_pins /aggr_noc/S07_AXI]
set_property -dict [list CONFIG.CONNECTIONS {M01_INI {read_bw {500} write_bw {500} } M03_INI {read_bw {500} write_bw {500} } M00_INI {read_bw {500} write_bw {500} }}] [get_bd_intf_pins /aggr_noc/S08_AXI]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins vdu/M_AXI8] [get_bd_intf_pins aggr_noc/S08_AXI]

