# Copyright (C) 2026, Advanced Micro Devices, Inc.
# SPDX-License-Identifier: Apache-2.0

# Hierarchical cell: clocking_block
proc create_hier_cell_clocking_block { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_clocking_block() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_dac_clk_wiz

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_adc_clk_wiz


  # Create pins
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn
  create_bd_pin -dir I -type clk dac_clk_in
  create_bd_pin -dir O -type clk dac_axis_aclk
  create_bd_pin -dir O dac_axis_aresetn
  create_bd_pin -dir O -type clk adc_axis_aclk
  create_bd_pin -dir O adc_axis_aresetn
  create_bd_pin -dir I -type clk adc_clk_in

  # Create instance: clk_wiz_dac, and set properties
  set clk_wiz_dac [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_dac ]
  set_property -dict [list \
    CONFIG.AXI_DRP {false} \
    CONFIG.CLKOUT1_DRIVES {BUFG} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {400.000} \
    CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} \
    CONFIG.PRIM_IN_FREQ {50.000} \
    CONFIG.PRIM_SOURCE {No_buffer} \
    CONFIG.USE_DYN_RECONFIG {true} \
    CONFIG.USE_PHASE_ALIGNMENT {true} \
  ] $clk_wiz_dac


  # Create instance: clk_wiz_adc, and set properties
  set clk_wiz_adc [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_adc ]
  set_property -dict [list \
    CONFIG.AXI_DRP {false} \
    CONFIG.CLKOUT1_DRIVES {BUFG} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {15.625} \
    CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} \
    CONFIG.PRIM_IN_FREQ {15.625} \
    CONFIG.PRIM_SOURCE {No_buffer} \
    CONFIG.USE_DYN_RECONFIG {true} \
    CONFIG.USE_PHASE_ALIGNMENT {true} \
  ] $clk_wiz_adc


  # Create instance: psr_dac_axis_clk, and set properties
  set psr_dac_axis_clk [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 psr_dac_axis_clk ]

  # Create instance: psr_adc_axis_clk, and set properties
  set psr_adc_axis_clk [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 psr_adc_axis_clk ]

  # Create instance: ilconstant_0, and set properties
  set ilconstant_0 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconstant:1.0 ilconstant_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins clk_wiz_adc/s_axi_lite] [get_bd_intf_pins s_axi_adc_clk_wiz]
  connect_bd_intf_net -intf_net ex_design_M03_AXI [get_bd_intf_pins s_axi_dac_clk_wiz] [get_bd_intf_pins clk_wiz_dac/s_axi_lite]

  # Create port connections
  connect_bd_net -net clk_in2_1  [get_bd_pins adc_clk_in] \
  [get_bd_pins clk_wiz_adc/clk_in1]
  connect_bd_net -net clk_wiz_adc0_clk_out1  [get_bd_pins clk_wiz_adc/clk_out1] \
  [get_bd_pins adc_axis_aclk]
  connect_bd_net -net clk_wiz_adc_locked  [get_bd_pins clk_wiz_adc/locked] \
  [get_bd_pins psr_adc_axis_clk/dcm_locked]
  connect_bd_net -net clk_wiz_dac0_clk_out1  [get_bd_pins clk_wiz_dac/clk_out1] \
  [get_bd_pins dac_axis_aclk]
  connect_bd_net -net clk_wiz_dac_locked  [get_bd_pins clk_wiz_dac/locked] \
  [get_bd_pins psr_dac_axis_clk/dcm_locked]
  connect_bd_net -net ex_design_clk_dac0  [get_bd_pins dac_clk_in] \
  [get_bd_pins clk_wiz_dac/clk_in1]
  connect_bd_net -net ilconstant_0_dout  [get_bd_pins ilconstant_0/dout] \
  [get_bd_pins psr_adc_axis_clk/aux_reset_in] \
  [get_bd_pins psr_dac_axis_clk/aux_reset_in]
  connect_bd_net -net psr_adc_axis_clk_peripheral_aresetn  [get_bd_pins psr_adc_axis_clk/peripheral_aresetn] \
  [get_bd_pins adc_axis_aresetn]
  connect_bd_net -net psr_dac_axis_clk_peripheral_aresetn  [get_bd_pins psr_dac_axis_clk/peripheral_aresetn] \
  [get_bd_pins dac_axis_aresetn]
  connect_bd_net -net rst_s_axi_aclk_57M_interconnect_aresetn  [get_bd_pins s_axi_aresetn] \
  [get_bd_pins clk_wiz_dac/s_axi_aresetn] \
  [get_bd_pins clk_wiz_adc/s_axi_aresetn] \
  [get_bd_pins psr_adc_axis_clk/ext_reset_in] \
  [get_bd_pins psr_dac_axis_clk/ext_reset_in]
  connect_bd_net -net s_axi_aclk_1  [get_bd_pins s_axi_aclk] \
  [get_bd_pins clk_wiz_dac/s_axi_aclk] \
  [get_bd_pins clk_wiz_adc/s_axi_aclk]

  connect_bd_net [get_bd_pins clk_wiz_adc/clk_out1] [get_bd_pins psr_adc_axis_clk/slowest_sync_clk]
  connect_bd_net [get_bd_pins clk_wiz_dac/clk_out1] [get_bd_pins psr_dac_axis_clk/slowest_sync_clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: LDPC_block
proc create_hier_cell_SD_FEC_block { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_SD_FEC_block() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_sd_fec

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_CTRL

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_DIN

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_DOUT

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_STATUS


  # Create pins
  create_bd_pin -dir O -type intr interrupt
  create_bd_pin -dir I -type clk core_clk
  create_bd_pin -dir I -type rst reset_n

  # Create instance: sd_fec_0, and set properties
  set sd_fec_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:sd_fec:1.1 sd_fec_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins sd_fec_0/S_AXI] [get_bd_intf_pins s_axi_sd_fec]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins sd_fec_0/S_AXIS_CTRL] [get_bd_intf_pins S_AXIS_CTRL]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins sd_fec_0/S_AXIS_DIN] [get_bd_intf_pins S_AXIS_DIN]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins sd_fec_0/M_AXIS_DOUT] [get_bd_intf_pins M_AXIS_DOUT]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins sd_fec_0/M_AXIS_STATUS] [get_bd_intf_pins M_AXIS_STATUS]

  # Create port connections
  connect_bd_net -net core_clk_0_1  [get_bd_pins core_clk] \
                                    [get_bd_pins sd_fec_0/core_clk] \
                                    [get_bd_pins sd_fec_0/s_axi_aclk] \
                                    [get_bd_pins sd_fec_0/s_axis_ctrl_aclk] \
                                    [get_bd_pins sd_fec_0/s_axis_din_aclk] \
                                    [get_bd_pins sd_fec_0/m_axis_status_aclk] \
                                    [get_bd_pins sd_fec_0/m_axis_dout_aclk]

  connect_bd_net -net sd_fec_0_interrupt  [get_bd_pins sd_fec_0/interrupt] \
  [get_bd_pins interrupt]
  connect_bd_net -net reset_n_0_1  [get_bd_pins reset_n] \
  [get_bd_pins sd_fec_0/reset_n]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Hierarchical cell: rfdc_block
proc create_hier_cell_rfdc_block { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_rfdc_block() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vout00

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 dac0_clk

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin0_01

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 adc0_clk

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:display_usp_rf_data_converter:diff_pins_rtl:1.0 sysref_in

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_rfdc

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_dac_clk_wiz

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_adc_clk_wiz

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s00_axis

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m00_axis


  # Create pins
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn
  create_bd_pin -dir O -type clk s0_axis_aclk
  create_bd_pin -dir O -type rst s0_axis_resetn
  create_bd_pin -dir O -type clk m0_axis_aclk
  create_bd_pin -dir O -type rst m0_axis_resetn
  create_bd_pin -dir O irq

  # Create instance: usp_rf_data_converter_0, and set properties
  set usp_rf_data_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:usp_rf_data_converter:2.6 usp_rf_data_converter_0 ]
  set_property -dict [list \
    CONFIG.ADC0_Band {0} \
    CONFIG.ADC0_Clock_Dist {0} \
    CONFIG.ADC0_Clock_Source {0} \
    CONFIG.ADC0_Link_Coupling {0} \
    CONFIG.ADC0_Multi_Tile_Sync {false} \
    CONFIG.ADC0_Outclk_Freq {15.625} \
    CONFIG.ADC0_PLL_Enable {false} \
    CONFIG.ADC0_Refclk_Freq {2000.000} \
    CONFIG.ADC0_Sampling_Rate {2.0} \
    CONFIG.ADC1_Band {0} \
    CONFIG.ADC224_En {false} \
    CONFIG.ADC225_En {false} \
    CONFIG.ADC226_En {false} \
    CONFIG.ADC227_En {false} \
    CONFIG.ADC2_Band {0} \
    CONFIG.ADC3_Band {0} \
    CONFIG.ADC_Bypass_BG_Cal00 {false} \
    CONFIG.ADC_CalOpt_Mode00 {1} \
    CONFIG.ADC_Data_Type00 {0} \
    CONFIG.ADC_Data_Width00 {8} \
    CONFIG.ADC_Debug {false} \
    CONFIG.ADC_Decimation_Mode00 {1} \
    CONFIG.ADC_Dither00 {true} \
    CONFIG.ADC_Mixer_Mode00 {2} \
    CONFIG.ADC_Mixer_Type00 {0} \
    CONFIG.ADC_Nyquist00 {0} \
    CONFIG.ADC_RTS {false} \
    CONFIG.ADC_Slice00_Enable {true} \
    CONFIG.ADC_Slice02_Enable {false} \
    CONFIG.ADC_Slice10_Enable {false} \
    CONFIG.ADC_Slice12_Enable {false} \
    CONFIG.ADC_Slice20_Enable {false} \
    CONFIG.ADC_Slice22_Enable {false} \
    CONFIG.ADC_Slice30_Enable {false} \
    CONFIG.ADC_Slice32_Enable {false} \
    CONFIG.AMS_Factory_Var {0} \
    CONFIG.Analog_Detection {1} \
    CONFIG.Axiclk_Freq {57.5} \
    CONFIG.Calibration_Freeze {false} \
    CONFIG.Calibration_Time {10} \
    CONFIG.Clock_Forwarding {false} \
    CONFIG.Converter_Setup {1} \
    CONFIG.DAC0_Band {0} \
    CONFIG.DAC0_Clock_Dist {0} \
    CONFIG.DAC0_Clock_Source {4} \
    CONFIG.DAC0_Link_Coupling {0} \
    CONFIG.DAC0_Multi_Tile_Sync {false} \
    CONFIG.DAC0_Outclk_Freq {50.000} \
    CONFIG.DAC0_PLL_Enable {false} \
    CONFIG.DAC0_Refclk_Freq {6400.000} \
    CONFIG.DAC0_Sampling_Rate {6.4} \
    CONFIG.DAC1_Band {0} \
    CONFIG.DAC228_En {false} \
    CONFIG.DAC229_En {false} \
    CONFIG.DAC230_En {false} \
    CONFIG.DAC231_En {false} \
    CONFIG.DAC2_Band {0} \
    CONFIG.DAC3_Band {0} \
    CONFIG.DAC_Data_Type00 {0} \
    CONFIG.DAC_Data_Width00 {16} \
    CONFIG.DAC_Debug {false} \
    CONFIG.DAC_Decoder_Mode00 {0} \
    CONFIG.DAC_Interpolation_Mode00 {1} \
    CONFIG.DAC_Invsinc_Ctrl00 {false} \
    CONFIG.DAC_Mixer_Type00 {0} \
    CONFIG.DAC_Nyquist00 {0} \
    CONFIG.DAC_Output_Current {0} \
    CONFIG.DAC_RTS {false} \
    CONFIG.DAC_Slice00_Enable {true} \
    CONFIG.DAC_Slice01_Enable {false} \
    CONFIG.DAC_Slice02_Enable {false} \
    CONFIG.DAC_Slice03_Enable {false} \
    CONFIG.DAC_Slice10_Enable {false} \
    CONFIG.DAC_Slice11_Enable {false} \
    CONFIG.DAC_Slice12_Enable {false} \
    CONFIG.DAC_Slice13_Enable {false} \
    CONFIG.PRESET {None} \
    CONFIG.RESERVED_3 {110000} \
    CONFIG.RF_Analyzer {1} \
    CONFIG.SCD_SG_minus2 {false} \
    CONFIG.VNC_Include_Fs2_Change {true} \
    CONFIG.VNC_Include_OIS_Change {true} \
    CONFIG.VNC_Testing {false} \
    CONFIG.disable_bg_cal_en {1} \
    CONFIG.mADC_Band {0} \
    CONFIG.mDAC_Band {0} \
    CONFIG.mDAC_Slice00_Enable {false} \
    CONFIG.mDAC_Slice01_Enable {false} \
    CONFIG.mDAC_Slice02_Enable {false} \
    CONFIG.mDAC_Slice03_Enable {false} \
    CONFIG.production_simulation {0} \
    CONFIG.tb_adc_fft {true} \
    CONFIG.tb_dac_fft {true} \
    CONFIG.use_bram {1} \
  ] $usp_rf_data_converter_0


  # Create instance: clocking_block
  create_hier_cell_clocking_block $hier_obj clocking_block

  # Create interface connections
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins usp_rf_data_converter_0/vout00] [get_bd_intf_pins vout00]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins usp_rf_data_converter_0/dac0_clk] [get_bd_intf_pins dac0_clk]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins usp_rf_data_converter_0/vin0_01] [get_bd_intf_pins vin0_01]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins usp_rf_data_converter_0/adc0_clk] [get_bd_intf_pins adc0_clk]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins usp_rf_data_converter_0/sysref_in] [get_bd_intf_pins sysref_in]
  connect_bd_intf_net -intf_net s00_axis_1 [get_bd_intf_pins s00_axis] [get_bd_intf_pins usp_rf_data_converter_0/s00_axis]
  connect_bd_intf_net -intf_net s_axi_1 [get_bd_intf_pins s_axi_rfdc] [get_bd_intf_pins usp_rf_data_converter_0/s_axi]
  connect_bd_intf_net -intf_net s_axi_adc_clk_wiz_1 [get_bd_intf_pins s_axi_adc_clk_wiz] [get_bd_intf_pins clocking_block/s_axi_adc_clk_wiz]
  connect_bd_intf_net -intf_net s_axi_dac_clk_wiz_1 [get_bd_intf_pins s_axi_dac_clk_wiz] [get_bd_intf_pins clocking_block/s_axi_dac_clk_wiz]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_m00_axis [get_bd_intf_pins m00_axis] [get_bd_intf_pins usp_rf_data_converter_0/m00_axis]

  # Create port connections
  connect_bd_net -net Net  [get_bd_pins clocking_block/adc_axis_aclk] \
  [get_bd_pins usp_rf_data_converter_0/m0_axis_aclk] \
  [get_bd_pins m0_axis_aclk]
  connect_bd_net -net Net1  [get_bd_pins clocking_block/dac_axis_aclk] \
  [get_bd_pins usp_rf_data_converter_0/s0_axis_aclk] \
  [get_bd_pins s0_axis_aclk]
  connect_bd_net -net clocking_block_locked  [get_bd_pins clocking_block/dac_axis_aresetn] \
  [get_bd_pins usp_rf_data_converter_0/s0_axis_aresetn]
  [get_bd_pins s0_axis_aresetn]
  connect_bd_net -net clocking_block_locked1  [get_bd_pins clocking_block/adc_axis_aresetn] \
  [get_bd_pins usp_rf_data_converter_0/m0_axis_aresetn]
  [get_bd_pins m0_axis_aresetn]
  connect_bd_net -net s_axi_aclk_1  [get_bd_pins s_axi_aclk] \
  [get_bd_pins usp_rf_data_converter_0/s_axi_aclk] \
  [get_bd_pins clocking_block/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1  [get_bd_pins s_axi_aresetn] \
  [get_bd_pins usp_rf_data_converter_0/s_axi_aresetn] \
  [get_bd_pins clocking_block/s_axi_aresetn]
  connect_bd_net -net usp_rf_data_converter_0_clk_adc0  [get_bd_pins usp_rf_data_converter_0/clk_adc0] \
  [get_bd_pins clocking_block/adc_clk_in]
  connect_bd_net -net usp_rf_data_converter_0_clk_dac0  [get_bd_pins usp_rf_data_converter_0/clk_dac0] \
  [get_bd_pins clocking_block/dac_clk_in]
  connect_bd_net -net usp_rf_data_converter_0_irq  [get_bd_pins usp_rf_data_converter_0/irq] \
  [get_bd_pins irq]

  # Restore current instance
  current_bd_instance $oldCurInst
}


proc create_SD_FEC_exdes_bd_tcl {proj_dir} {
  # Create IP
  puts "Create SD_FEC IP"
  # NOTE: 
  # o To build for uBlaze change Example_Design_PS_Type to MicroBlaze
  # o Disable SDK project build and running manually from script follow updates to design
  create_ip -name sd_fec -vendor xilinx.com -library ip -version 1.1 -module_name sd_fec_gen
  set_property -dict [list CONFIG.Standard "Custom" \
                           CONFIG.LDPC_Decode "true" \
                           CONFIG.LDPC_Decode_Code_Definition "[pwd]/sd_fec_codes/all_code_def.txt" \
                           CONFIG.DIN_Lanes 2 \
                           CONFIG.Include_PS_Example_Design "true" \
                           CONFIG.Example_Design_PS_Type "ZYNQ_UltraScale+_RFSoC" \
                           CONFIG.Include_Encoder "true" \
                           CONFIG.Build_SDK_Project "false"] [get_ips sd_fec_gen]
  open_example_project -in_process -force -dir ./proj_exdes [get_ips sd_fec_gen]
  create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 man_int_slice
  set_property -dict [list CONFIG.DIN_TO {1} CONFIG.DIN_FROM {1} CONFIG.DIN_WIDTH {8} CONFIG.DIN_FROM {1} CONFIG.DOUT_WIDTH {1}] [get_bd_cells man_int_slice]
  connect_bd_net [get_bd_pins man_int_slice/Din] [get_bd_pins gpio_reset/gpio_io_o]
  set_property -dict [list CONFIG.NUM_PORTS {3}] [get_bd_cells concat_int]
  connect_bd_net [get_bd_pins man_int_slice/Dout] [get_bd_pins concat_int/In2]
  update_compile_order -fileset sources_1
  update_compile_order -fileset sim_1
  
  group_bd_cells SD_FEC [get_bd_cells dec_op_probe] \
                        [get_bd_cells src_data_fifo] \
                        [get_bd_cells hard_chan_data_fifo] \
                        [get_bd_cells dec_data_reinterpret] \
                        [get_bd_cells enc_ip_mon] \
                        [get_bd_cells dec_add_keep] \
                        [get_bd_cells sd_fec_enc] \
                        [get_bd_cells dec_ctrl_fifo] \
                        [get_bd_cells hard_data_reg] \
                        [get_bd_cells enc_ctrl_fifo] \
                        [get_bd_cells enc_keep_ctrl_fifo] \
                        [get_bd_cells stats] \
                        [get_bd_cells const_1] \
                        [get_bd_cells enc_op_probe] \
                        [get_bd_cells dec_op_mon] \
                        [get_bd_cells dec_ctrl_reg] \
                        [get_bd_cells data_source] \
                        [get_bd_cells enc_data_reinterpret] \
                        [get_bd_cells dec_ip_probe] \
                        [get_bd_cells enc_add_keep_trim] \
                        [get_bd_cells dec_ctrl_reinterpret] \
                        [get_bd_cells src_data_broadcast] \
                        [get_bd_cells dec_ip_mon] \
                        [get_bd_cells enc_ip_probe] \
                        [get_bd_cells demod] \
                        [get_bd_cells llr_reinterpret] \
                        [get_bd_cells rtc] \
                        [get_bd_cells enc_op_mon] \
                        [get_bd_cells dec_keep_ctrl_fifo] \
                        [get_bd_cells mod_and_chan] \
                        [get_bd_cells chan_ctrl_reg] \
                        [get_bd_cells llr_reshape] \
                        [get_bd_cells enc_ctrl_reinterpret] \
                        [get_bd_cells enc_add_keep] \
                        [get_bd_cells axi_gpio] \
                        [get_bd_cells dec_stat_reinterpret] \
                        [get_bd_cells dec_add_keep_trim] \
                        [get_bd_cells enc_data_fifo] \
                        [get_bd_cells sd_fec_dec] \
                        [get_bd_cells chan_ctrl_fifo] \
                        [get_bd_cells man_int_slice] \
                        [get_bd_cells reset_slice] \
                        [get_bd_cells gpio_reset] \
                        [get_bd_cells concat_int] \
                        [get_bd_cells SD_FEC] \
                        [get_bd_cells rst_clk_wiz_300M]
  
  delete_bd_objs [get_bd_intf_nets zynq_ultra_ps_axi_periph_M00_AXI] \
                 [get_bd_intf_nets zynq_ultra_ps_axi_periph_M01_AXI] \
                 [get_bd_intf_nets zynq_ultra_ps_axi_periph_M02_AXI] \
                 [get_bd_intf_nets zynq_ultra_ps_axi_periph_M03_AXI] \
                 [get_bd_intf_nets zynq_ultra_ps_axi_periph_M04_AXI] \
                 [get_bd_intf_nets zynq_ultra_ps_axi_periph_M05_AXI] \
                 [get_bd_intf_nets zynq_ultra_ps_axi_periph_M06_AXI] \
                 [get_bd_intf_nets zynq_ultra_ps_axi_periph_M07_AXI] \
                 [get_bd_intf_nets zynq_ultra_ps_axi_periph_M08_AXI] \
                 [get_bd_intf_nets zynq_ultra_ps_axi_periph_M09_AXI]
  
  set_property name AXIS_clk [get_bd_pins SD_FEC/ap_clk]
  set_property name AXI_aclk [get_bd_pins SD_FEC/cntrl_aclk]
  set_property name AXI_aresetn [get_bd_pins SD_FEC/ap_rst_n_cntrl_aclk]
  set_property name ext_reset [get_bd_pins SD_FEC/reset]
  set_property name irq [get_bd_cells SD_FEC/concat_int]
  
  create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 SMC
  set_property -dict [list CONFIG.NUM_MI {10} CONFIG.NUM_SI {1}] [get_bd_cells SMC]
  
  set idx 0
  foreach axi {S_AXI S_AXI1 S_AXI2 S_AXI3 s_axi_CNTRL2 s_axi_CNTRL s_axi_CNTRL1 s_axi_CNTRL3 s_axi_CNTRL4 s_axi_CNTRL5} {
    delete_bd_objs [get_bd_intf_nets -of [get_bd_intf_pins SD_FEC/${axi}]]
    connect_bd_intf_net [get_bd_intf_pins /SMC/M[format "%02d" $idx]_AXI] [get_bd_intf_pins /SD_FEC/${axi}]
    incr idx
  }
  
  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins zynq_ultra_ps_axi_periph/M00_AXI] [get_bd_intf_pins SMC/S00_AXI]
  
  delete_bd_objs [get_bd_intf_nets zynq_ultra_ps_axi_periph_M10_AXI]
  connect_bd_intf_net [get_bd_intf_pins axi_intc/s_axi] -boundary_type upper [get_bd_intf_pins zynq_ultra_ps_axi_periph/M01_AXI]
  
  set_property CONFIG.NUM_MI {2} [get_bd_cells zynq_ultra_ps_axi_periph]
  
  move_bd_cells [get_bd_cells SD_FEC] [get_bd_cells SMC]
  
  connect_bd_net [get_bd_pins SD_FEC/AXI_aclk] [get_bd_pins SD_FEC/SMC/aclk]
  connect_bd_net [get_bd_pins SD_FEC/AXI_aresetn] [get_bd_pins SD_FEC/SMC/aresetn]


  move_bd_cells [get_bd_cells SD_FEC] [get_bd_cells clk_wiz] [get_bd_cells rst_clk_wiz_100M]
  move_bd_cells [get_bd_cells /] [get_bd_cells SD_FEC/irq]
  set_property name enc_irq [get_bd_pins SD_FEC/interrupt1]
  set_property name dec_irq [get_bd_pins SD_FEC/interrupt]
  set_property name gpio_irq [get_bd_pins SD_FEC/Dout]
  set_property name clk100 [get_bd_pins SD_FEC/clk_out3]
  set_property name clk100_resetn [get_bd_pins SD_FEC/peripheral_aresetn]

  delete_bd_objs [get_bd_intf_nets SD_FEC/axi_gpio_GPIO]
  delete_bd_objs [get_bd_intf_pins SD_FEC/led_bits]
  create_bd_pin -dir O -from 4 -to 0 SD_FEC/led_bits
  connect_bd_net [get_bd_pins SD_FEC/led_bits] [get_bd_pins SD_FEC/axi_gpio/gpio_io_o]
  
  save_bd_design

  write_bd_tcl -force -no_project_wrapper -no_ip_version -hier_blks /SD_FEC ./${proj_dir}/sd_fec.tcl
  file copy -force ./proj_exdes/sd_fec_gen_ex/helper_ip_repo ./${proj_dir}/
  file copy -force ./proj_exdes/sd_fec_gen_ex/ps_example_placement.xdc ./${proj_dir}/

  close_project

  remove_files  ./${proj_dir}/zcu111_pl_ip_example.srcs/sources_1/ip/sd_fec_gen/sd_fec_gen.xci

  set_property  ip_repo_paths  ${proj_dir}/helper_ip_repo [current_project]
  update_ip_catalog

  source ./${proj_dir}/sd_fec.tcl

  create_hier_cell_SD_FEC . SD_FEC

}

proc create_pl_ip_blocks {proj_dir} {

  create_SD_FEC_exdes_bd_tcl $proj_dir

  set_property CONFIG.NUM_CLKS {2} [get_bd_cells SD_FEC/SMC]
  create_bd_pin -dir I SD_FEC/AXI_clk100
  connect_bd_net [get_bd_pins SD_FEC/AXI_clk100] [get_bd_pins SD_FEC/SMC/aclk1]
  delete_bd_objs [get_bd_pins SD_FEC/clk100] [get_bd_pins SD_FEC/clk100_resetn]


  create_hier_cell_rfdc_block . RFDC
  make_bd_intf_pins_external  [get_bd_intf_pins RFDC/sysref_in] [get_bd_intf_pins RFDC/vin0_01] [get_bd_intf_pins RFDC/adc0_clk] [get_bd_intf_pins RFDC/dac0_clk] [get_bd_intf_pins RFDC/vout00]

  set_property CONFIG.NUM_MI {5} [get_bd_cells smartconnect_axilite]
  connect_bd_intf_net [get_bd_intf_pins smartconnect_axilite/M01_AXI] [get_bd_intf_pins SD_FEC/S00_AXI]
  connect_bd_intf_net [get_bd_intf_pins smartconnect_axilite/M02_AXI] [get_bd_intf_pins RFDC/s_axi_rfdc]
  connect_bd_intf_net [get_bd_intf_pins smartconnect_axilite/M03_AXI] [get_bd_intf_pins RFDC/s_axi_dac_clk_wiz]
  connect_bd_intf_net [get_bd_intf_pins smartconnect_axilite/M04_AXI] [get_bd_intf_pins RFDC/s_axi_adc_clk_wiz]
  connect_bd_net [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins SD_FEC/AXI_clk100]
  connect_bd_net [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins RFDC/s_axi_aclk]
  connect_bd_net [get_bd_pins proc_sys_reset_1/peripheral_aresetn] [get_bd_pins RFDC/s_axi_aresetn]

  delete_bd_objs [get_bd_nets axi_intc_0_irq]
  create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconcat:1.0 irq_cat
  set_property CONFIG.NUM_PORTS {5} [get_bd_cells irq_cat]
  connect_bd_net [get_bd_pins axi_intc_0/irq] [get_bd_pins irq_cat/In0]
  connect_bd_net [get_bd_pins SD_FEC/dec_irq] [get_bd_pins irq_cat/In1]
  connect_bd_net [get_bd_pins SD_FEC/enc_irq] [get_bd_pins irq_cat/In2]
  connect_bd_net [get_bd_pins SD_FEC/gpio_irq] [get_bd_pins irq_cat/In3]
  connect_bd_net [get_bd_pins RFDC/irq] [get_bd_pins irq_cat/In4]
  connect_bd_net [get_bd_pins irq_cat/dout] [get_bd_pins ps_e/pl_ps_irq0]


  create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axis_vip_dac
  set_property CONFIG.INTERFACE_MODE {MASTER} [get_bd_cells axis_vip_dac]
  set_property CONFIG.TDATA_NUM_BYTES {32} [get_bd_cells axis_vip_dac]
  create_bd_cell -type ip -vlnv xilinx.com:ip:axi4stream_vip:1.1 axis_vip_adc
  set_property CONFIG.INTERFACE_MODE {SLAVE} [get_bd_cells axis_vip_adc]

  connect_bd_net [get_bd_pins RFDC/s0_axis_aclk] [get_bd_pins axis_vip_dac/aclk]
  connect_bd_net [get_bd_pins RFDC/m0_axis_aclk] [get_bd_pins axis_vip_adc/aclk]


  connect_bd_intf_net [get_bd_intf_pins RFDC/m00_axis] [get_bd_intf_pins axis_vip_adc/S_AXIS]
  connect_bd_intf_net [get_bd_intf_pins axis_vip_dac/M_AXIS] [get_bd_intf_pins RFDC/s00_axis]

  connect_bd_net [get_bd_pins RFDC/m0_axis_resetn] [get_bd_pins axis_vip_adc/aresetn]
  connect_bd_net [get_bd_pins RFDC/s0_axis_resetn] [get_bd_pins axis_vip_dac/aresetn]

  create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sys_diff_clock
  connect_bd_intf_net [get_bd_intf_pins SD_FEC/sys_diff_clock] [get_bd_intf_ports sys_diff_clock]
  
  create_bd_port -dir I -type rst ext_reset
  connect_bd_net [get_bd_pins /SD_FEC/ext_reset] [get_bd_ports ext_reset]
  set_property CONFIG.POLARITY ACTIVE_HIGH [get_bd_ports ext_reset]

  create_bd_port -dir O -from 4 -to 0 led_bits
  connect_bd_net [get_bd_pins /SD_FEC/led_bits] [get_bd_ports led_bits]

  save_bd_design
}  