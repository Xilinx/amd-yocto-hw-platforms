create_bd_cell -type ip -vlnv xilinx.com:ip:vcu:1.2 vcu_0
set_property -dict [list \
  CONFIG.ENC_BUFFER_EN {true} \
  CONFIG.ENC_BUFFER_MANUAL_OVERRIDE {1} \
  CONFIG.ENC_BUFFER_SIZE {2140} \
  CONFIG.ENC_CODING_TYPE {1} \
] [get_bd_cells vcu_0]
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


