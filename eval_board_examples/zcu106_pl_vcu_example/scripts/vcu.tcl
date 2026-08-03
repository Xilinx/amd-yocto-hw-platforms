########################################################################
# PS-e & pre-existing cell base configuration
########################################################################
set_property -dict [list \
  CONFIG.PSU__USE__IRQ1 {1} \
  CONFIG.PSU__USE__S_AXI_GP0 {1} \
  CONFIG.PSU__USE__S_AXI_GP2 {0} \
  CONFIG.PSU__USE__S_AXI_GP3 {1} \
  CONFIG.PSU__USE__S_AXI_GP4 {1} \
] [get_bd_cells ps_e]

set_property CONFIG.PSU__GPIO_EMIO__PERIPHERAL__ENABLE {1} [get_bd_cells ps_e]

set_property CONFIG.PSU__USE__M_AXI_GP1 {1} [get_bd_cells ps_e]

set_property -dict [list \
  CONFIG.PSU__CRF_APB__DPLL_CTRL__FBDIV {64} \
  CONFIG.PSU__CRF_APB__DPLL_TO_LPD_CTRL__DIVISOR0 {3} \
  CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__DIVISOR0 {16} \
  CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__DIVISOR0 {15} \
  CONFIG.PSU__CRF_APB__VPLL_CTRL__FBDIV {71} \
  CONFIG.PSU__CRL_APB__IOPLL_CTRL__DIV2 {0} \
  CONFIG.PSU__CRL_APB__IOPLL_CTRL__FBDIV {45} \
  CONFIG.PSU__CRL_APB__RPLL_CTRL__FBDIV {70} \
  CONFIG.PSU__CRL_APB__RPLL_TO_FPD_CTRL__DIVISOR0 {3} \
  CONFIG.PSU__OVERRIDE__BASIC_CLOCK {1} \
] [get_bd_cells ps_e]

set_property CONFIG.PSU__GPIO_EMIO__PERIPHERAL__IO {92} [get_bd_cells ps_e]

set_property -dict [list \
  CONFIG.NUM_MI {2} \
  CONFIG.NUM_SI {1} \
  CONFIG.NUM_CLKS {2} \
] [get_bd_cells smartconnect_axihpm0fpd]

set_property -dict [list \
  CONFIG.NUM_CLKS {2} \
  CONFIG.NUM_MI {2} \
] [get_bd_cells smartconnect_axifull]

set_property -dict [list \
  CONFIG.NUM_MI {1} \
  CONFIG.NUM_SI {3} \
] [get_bd_cells smartconnect_axifull]

set_property CONFIG.NUM_CLKS {2} [get_bd_cells smartconnect_axifull]


########################################################################
# IP instance creation
########################################################################

# Create instance: vcu_0, and set properties
create_bd_cell -type ip -vlnv xilinx.com:ip:vcu:1.2 vcu_0
set_property -dict [list \
  CONFIG.DEC_CODING_TYPE {1} \
  CONFIG.ENC_BUFFER_B_FRAME {1} \
  CONFIG.ENC_BUFFER_EN {true} \
  CONFIG.ENC_BUFFER_MOTION_VEC_RANGE {1} \
  CONFIG.ENC_CODING_TYPE {1} \
] [get_bd_cells vcu_0]

# Create instance: vcu_ddr4_controller_0
create_bd_cell -type ip -vlnv xilinx.com:ip:vcu_ddr4_controller:1.1 vcu_ddr4_controller_0

# Create instance: smartconnect_0, and set properties
create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0
set_property CONFIG.NUM_MI {2} [get_bd_cells smartconnect_0]
set_property CONFIG.NUM_SI {1} [get_bd_cells smartconnect_0]
set_property CONFIG.NUM_CLKS {2} [get_bd_cells smartconnect_0]

# Create instance: clk_wiz_1, and set properties
create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_1
set_property -dict [list CONFIG.PRIM_IN_FREQ.VALUE_SRC USER] [get_bd_cells clk_wiz_1]
set_property -dict [list \
  CONFIG.CLKIN1_JITTER_PS {33.330} \
  CONFIG.CLKIN1_UI_JITTER {33.330} \
  CONFIG.CLKIN2_JITTER_PS {100.000} \
  CONFIG.CLKIN2_UI_JITTER {100.000} \
  CONFIG.CLKOUT1_DRIVES {Buffer} \
  CONFIG.CLKOUT1_JITTER {131.368} \
  CONFIG.CLKOUT1_PHASE_ERROR {81.700} \
  CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {33.333} \
  CONFIG.CLKOUT2_DRIVES {Buffer} \
  CONFIG.CLKOUT2_JITTER {85.457} \
  CONFIG.CLKOUT2_PHASE_ERROR {81.700} \
  CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {331.000} \
  CONFIG.CLKOUT2_USED {true} \
  CONFIG.CLKOUT3_DRIVES {Buffer} \
  CONFIG.CLKOUT4_DRIVES {Buffer} \
  CONFIG.CLKOUT5_DRIVES {Buffer} \
  CONFIG.CLKOUT6_DRIVES {Buffer} \
  CONFIG.CLKOUT7_DRIVES {Buffer} \
  CONFIG.JITTER_OPTIONS {PS} \
  CONFIG.MMCM_CLKFBOUT_MULT_F {13.250} \
  CONFIG.MMCM_CLKIN1_PERIOD {3.333} \
  CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
  CONFIG.MMCM_CLKOUT0_DIVIDE_F {39.750} \
  CONFIG.MMCM_CLKOUT1_DIVIDE {4} \
  CONFIG.MMCM_DIVCLK_DIVIDE {3} \
  CONFIG.MMCM_REF_JITTER2 {0.010} \
  CONFIG.NUM_OUT_CLKS {2} \
  CONFIG.PRIM_IN_FREQ {300.000} \
  CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
  CONFIG.SECONDARY_SOURCE {Single_ended_clock_capable_pin} \
  CONFIG.USE_PHASE_ALIGNMENT {true} \
  CONFIG.USE_RESET {false} \
] [get_bd_cells clk_wiz_1]

# Create instance: proc_sys_reset_3
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_3

# Create instance: smartconnect_1, and set properties
create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_1
set_property CONFIG.NUM_SI {1} [get_bd_cells smartconnect_1]

# Create instance: smartconnect_2, and set properties
create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_2
set_property CONFIG.NUM_SI {1} [get_bd_cells smartconnect_2]

# Create instance: smartconnect_3, and set properties
create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_3
set_property -dict [list \
  CONFIG.NUM_CLKS {2} \
  CONFIG.NUM_MI {2} \
  CONFIG.NUM_SI {1} \
] [get_bd_cells smartconnect_3]

# Create instance: smartconnect_4, and set properties
create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_4
set_property -dict [list \
  CONFIG.NUM_CLKS {2} \
  CONFIG.NUM_MI {2} \
  CONFIG.NUM_SI {1} \
  CONFIG.STRATEGY {PERFORMANCE} \
] [get_bd_cells smartconnect_4]

# Create instance: smartconnect_5, and set properties
create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_5
set_property CONFIG.NUM_SI {1} [get_bd_cells smartconnect_5]

# Create instance: proc_sys_reset_4
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_4

# Create instance: ilconstant_0, and set properties
create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconstant:1.0 ilconstant_0
set_property CONFIG.CONST_VAL {0} [get_bd_cells ilconstant_0]

# Create instance: ilslice_0, and set properties
create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice:1.0 ilslice_0
set_property CONFIG.DIN_WIDTH {92} [get_bd_cells ilslice_0]

########################################################################
# External interface ports
########################################################################
make_bd_intf_pins_external  [get_bd_intf_pins clk_wiz_1/CLK_IN1_D]
set_property name si570_user [get_bd_intf_ports CLK_IN1_D_0]

make_bd_intf_pins_external  [get_bd_intf_pins vcu_ddr4_controller_0/c0_sys]

make_bd_intf_pins_external  [get_bd_intf_pins vcu_ddr4_controller_0/C0_DDR4]
set_property name C0_DDR4 [get_bd_intf_ports C0_DDR4_0]

########################################################################
# Interface connections
########################################################################
connect_bd_intf_net [get_bd_intf_pins ps_e/S_AXI_HPC0_FPD] [get_bd_intf_pins smartconnect_0/M00_AXI]
connect_bd_intf_net [get_bd_intf_pins vcu_0/M_AXI_MCU] [get_bd_intf_pins smartconnect_0/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins smartconnect_0/M01_AXI] [get_bd_intf_pins vcu_ddr4_controller_0/S_AXI_PORT2]

connect_bd_intf_net [get_bd_intf_pins smartconnect_axihpm0fpd/M01_AXI] [get_bd_intf_pins vcu_0/S_AXI_LITE]
connect_bd_net [get_bd_pins smartconnect_axihpm0fpd/aclk1] [get_bd_pins clk_wiz_0/clk_out1]
connect_bd_intf_net [get_bd_intf_pins smartconnect_1/S00_AXI] [get_bd_intf_pins vcu_0/M_AXI_ENC0]
connect_bd_intf_net [get_bd_intf_pins smartconnect_1/M00_AXI] [get_bd_intf_pins ps_e/S_AXI_HP2_FPD]

connect_bd_intf_net [get_bd_intf_pins vcu_0/M_AXI_ENC1] [get_bd_intf_pins smartconnect_2/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins smartconnect_2/M00_AXI] [get_bd_intf_pins ps_e/S_AXI_HP1_FPD]

connect_bd_intf_net [get_bd_intf_pins vcu_0/M_AXI_DEC0] [get_bd_intf_pins smartconnect_3/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins smartconnect_3/M00_AXI] [get_bd_intf_pins vcu_ddr4_controller_0/S_AXI_PORT0]
connect_bd_intf_net [get_bd_intf_pins smartconnect_3/M01_AXI] [get_bd_intf_pins smartconnect_axifull/S01_AXI]

connect_bd_intf_net [get_bd_intf_pins vcu_0/M_AXI_DEC1] [get_bd_intf_pins smartconnect_4/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins smartconnect_axifull/S02_AXI] [get_bd_intf_pins smartconnect_4/M00_AXI]
connect_bd_intf_net [get_bd_intf_pins smartconnect_4/M01_AXI] [get_bd_intf_pins vcu_ddr4_controller_0/S_AXI_PORT1]

connect_bd_intf_net [get_bd_intf_pins ps_e/M_AXI_HPM1_FPD] [get_bd_intf_pins smartconnect_5/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins smartconnect_5/M00_AXI] [get_bd_intf_pins vcu_ddr4_controller_0/S_AXI_PORT3]

########################################################################
# Clock & reset net connections
########################################################################
connect_bd_net [get_bd_pins clk_wiz_1/clk_out1] [get_bd_pins vcu_0/pll_ref_clk]

connect_bd_net [get_bd_pins clk_wiz_1/clk_out2] [get_bd_pins proc_sys_reset_3/slowest_sync_clk]
connect_bd_net [get_bd_pins proc_sys_reset_3/ext_reset_in] [get_bd_pins ps_e/pl_resetn0]
connect_bd_net [get_bd_pins proc_sys_reset_3/dcm_locked] [get_bd_pins clk_wiz_1/locked]
connect_bd_net [get_bd_pins smartconnect_0/aclk] [get_bd_pins clk_wiz_1/clk_out2]
connect_bd_net [get_bd_pins vcu_0/m_axi_mcu_aclk] [get_bd_pins clk_wiz_1/clk_out2]
connect_bd_net [get_bd_pins vcu_0/m_axi_enc_aclk] [get_bd_pins clk_wiz_1/clk_out2]
connect_bd_net [get_bd_pins vcu_0/m_axi_dec_aclk] [get_bd_pins clk_wiz_1/clk_out2]
connect_bd_net [get_bd_pins proc_sys_reset_3/interconnect_aresetn] [get_bd_pins smartconnect_0/aresetn]

connect_bd_net [get_bd_pins vcu_0/s_axi_lite_aclk] [get_bd_pins clk_wiz_0/clk_out1]

connect_bd_net [get_bd_pins smartconnect_1/aclk] [get_bd_pins clk_wiz_1/clk_out2]
connect_bd_net [get_bd_pins smartconnect_1/aresetn] [get_bd_pins proc_sys_reset_3/interconnect_aresetn]

connect_bd_net [get_bd_pins smartconnect_2/aclk] [get_bd_pins clk_wiz_1/clk_out2]
connect_bd_net [get_bd_pins smartconnect_2/aresetn] [get_bd_pins proc_sys_reset_3/interconnect_aresetn]

connect_bd_net [get_bd_pins smartconnect_3/aclk] [get_bd_pins clk_wiz_1/clk_out2]
connect_bd_net [get_bd_pins smartconnect_3/aresetn] [get_bd_pins proc_sys_reset_3/interconnect_aresetn]
connect_bd_net [get_bd_pins smartconnect_3/aclk1] [get_bd_pins vcu_ddr4_controller_0/phy_Clk]

connect_bd_net [get_bd_pins smartconnect_4/aclk] [get_bd_pins clk_wiz_1/clk_out2]
connect_bd_net [get_bd_pins smartconnect_4/aclk1] [get_bd_pins vcu_ddr4_controller_0/phy_Clk]
connect_bd_net [get_bd_pins smartconnect_4/aresetn] [get_bd_pins proc_sys_reset_3/interconnect_aresetn]

connect_bd_net [get_bd_pins vcu_ddr4_controller_0/phy_Clk] [get_bd_pins vcu_ddr4_controller_0/S_Axi_Clk]
connect_bd_net [get_bd_pins proc_sys_reset_4/slowest_sync_clk] [get_bd_pins vcu_ddr4_controller_0/phy_Clk]
connect_bd_net [get_bd_pins proc_sys_reset_4/ext_reset_in] [get_bd_pins ps_e/pl_resetn0]
connect_bd_net [get_bd_pins smartconnect_0/aclk1] [get_bd_pins vcu_ddr4_controller_0/phy_Clk]
connect_bd_net [get_bd_pins proc_sys_reset_4/interconnect_aresetn] [get_bd_pins smartconnect_5/aresetn]
connect_bd_net [get_bd_pins smartconnect_5/aclk] [get_bd_pins vcu_ddr4_controller_0/phy_Clk]

connect_bd_net [get_bd_pins vcu_ddr4_controller_0/phy_sRst] [get_bd_pins vcu_ddr4_controller_0/S_Axi_Rst]
connect_bd_net [get_bd_pins ilconstant_0/dout] [get_bd_pins vcu_ddr4_controller_0/sys_rst]

########################################################################
# Clock source rewiring
#
# These calls override earlier automatic clock assignments on ps_e's
# AXI-HP/HPM ports, moving them from clk_wiz_0 onto clk_wiz_1, and
# finally re-pointing maxihpm1_fpd_aclk at the DDR4 controller's own
# phy_Clk. The relative order below is required: a pin's existing net
# must be disconnected before it can be reconnected to a new source,
# and maxihpm1_fpd_aclk must be connected to clk_wiz_1/clk_out2 before
# that connection can later be disconnected and replaced.
########################################################################
disconnect_bd_net /clk_wiz_0_clk_out2 [get_bd_pins ps_e/saxihp3_fpd_aclk]
connect_bd_net [get_bd_pins ps_e/saxihp3_fpd_aclk] [get_bd_pins clk_wiz_1/clk_out2]
connect_bd_net [get_bd_pins ps_e/saxihp2_fpd_aclk] [get_bd_pins clk_wiz_1/clk_out2]
connect_bd_net [get_bd_pins ps_e/saxihp1_fpd_aclk] [get_bd_pins clk_wiz_1/clk_out2]
connect_bd_net [get_bd_pins ps_e/saxihpc0_fpd_aclk] [get_bd_pins clk_wiz_1/clk_out2]

connect_bd_net [get_bd_pins ps_e/maxihpm1_fpd_aclk] [get_bd_pins clk_wiz_1/clk_out2]
connect_bd_net [get_bd_pins smartconnect_axifull/aclk1] [get_bd_pins clk_wiz_1/clk_out2]
disconnect_bd_net /clk_wiz_1_clk_out2 [get_bd_pins ps_e/maxihpm1_fpd_aclk]
connect_bd_net [get_bd_pins ps_e/maxihpm1_fpd_aclk] [get_bd_pins vcu_ddr4_controller_0/phy_Clk]

########################################################################
# Misc / control connections
########################################################################
connect_bd_net [get_bd_pins vcu_0/vcu_host_interrupt] [get_bd_pins ps_e/pl_ps_irq1]

connect_bd_net [get_bd_pins ilslice_0/Din] [get_bd_pins ps_e/emio_gpio_o]
connect_bd_net [get_bd_pins ilslice_0/Dout] [get_bd_pins vcu_0/vcu_resetn]

########################################################################
# Interconnect performance strategy
########################################################################
set_property CONFIG.STRATEGY {PERFORMANCE} [get_bd_cells smartconnect_0]
set_property CONFIG.STRATEGY {PERFORMANCE} [get_bd_cells smartconnect_1]
set_property CONFIG.STRATEGY {PERFORMANCE} [get_bd_cells smartconnect_2]
set_property CONFIG.STRATEGY {PERFORMANCE} [get_bd_cells smartconnect_3]
set_property CONFIG.STRATEGY {PERFORMANCE} [get_bd_cells smartconnect_4]
set_property CONFIG.STRATEGY {PERFORMANCE} [get_bd_cells smartconnect_axihpm0fpd ]
set_property CONFIG.STRATEGY {PERFORMANCE} [get_bd_cells smartconnect_axifull ]

########################################################################
# Address map
########################################################################
assign_bd_address
set_property offset 0x4800000000 [get_bd_addr_segs {vcu_0/DecData0/SEG_vcu_ddr4_controller_0_Reg}]
set_property range 2G [get_bd_addr_segs {vcu_0/DecData0/SEG_vcu_ddr4_controller_0_Reg}]
set_property offset 0x4800000000 [get_bd_addr_segs {ps_e/Data/SEG_vcu_ddr4_controller_0_Reg}]
set_property range 2G [get_bd_addr_segs {ps_e/Data/SEG_vcu_ddr4_controller_0_Reg}]
set_property offset 0x4800000000 [get_bd_addr_segs {vcu_0/DecData1/SEG_vcu_ddr4_controller_0_Reg}]
set_property range 2G [get_bd_addr_segs {vcu_0/DecData1/SEG_vcu_ddr4_controller_0_Reg}]
set_property offset 0x4800000000 [get_bd_addr_segs {vcu_0/Code/SEG_vcu_ddr4_controller_0_Reg}]
set_property range 2G [get_bd_addr_segs {vcu_0/Code/SEG_vcu_ddr4_controller_0_Reg}]
