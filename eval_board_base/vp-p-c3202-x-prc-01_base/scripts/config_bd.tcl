# Copyright (C) 2026, Advanced Micro Devices, Inc.
# SPDX-License-Identifier: Apache-2.0

# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
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


  # Create interface ports
  set C0_DDR5_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr5_dimm_rtl:1.0 C0_DDR5_0 ]

  set SYS_CLK0_IN_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 SYS_CLK0_IN_0 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {320000000} \
   ] $SYS_CLK0_IN_0


  # Create ports

  # Create instance: axi_noc2_1, and set properties
  set axi_noc2_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc2:1.1 axi_noc2_1 ]
  set_property -dict [list \
    CONFIG.DDR5_DEVICE_TYPE {DIMMs} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_ADDRESS_MAP) {NA,NA,NA,NA,NA,NA,RA15,RA14,RA13,RA12,RA11,RA10,RA9,RA8,RA7,RA6,RA5,RA4,RA3,RA2,RA1,RA0,BA1,BA0,BG2,BG1,BG0,CA9,CA8,CA7,CA6,CA5,NC,CA4,NC,NC,NC,NC,NA,NA} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_AUTO_PRECHARGE) {false} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_BACKGROUND_SCRUB) {false} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_BA_ADDR_WIDTH) {2} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_BG_WIDTH) {3} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_BOARD_INTRF_EN) {false} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_BURST_ADDR_WIDTH) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_CAL_MASK_POLL) {ENABLE} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_CLAMSHELL) {false} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_CLOCK_STOPPED_SR) {false} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_COL_ADDR_WIDTH) {10} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_CONFIG12_SWAP) {false} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_CONFIG13_OPT) {false} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_CONTROLLERTYPE) {DDR5_SDRAM} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_CRYPTO) {false} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_DATA_WIDTH) {32} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_DDR5_2T) {DISABLE} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_DDR5_PAR_RCD_EN) {false} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_DDR5_RDIMM_ADDR_MODE) {DDR} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_DDR5_TFAW_DLR) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_DDR5_TREFSBRD) {30000} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_DDR5_TREFSBRD_DLR) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_DDR5_TREFSBRD_SLR) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_DDR5_TRFC1) {295000} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_DDR5_TRFC1_DLR) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_DDR5_TRFC1_DPR) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_DDR5_TRFC2) {160000} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_DDR5_TRFC2_DLR) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_DDR5_TRFC2_DPR) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_DDR5_TRFCSB) {130000} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_DDR5_TRFCSB_DLR) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_DEVICE_TYPE) {SODIMMs} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_DIMM0_SLOT0_HID) {000} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_DIMM0_SLOT1_HID) {010} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_DIMM1_SLOT0_HID) {001} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_DIMM1_SLOT1_HID) {011} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_DM_EN) {true} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_DQS_OSCI_EN) {DISABLE} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_DRAM_SIZE) {16Gb} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_DRAM_WIDTH) {x8} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_EXTENDED_DDRMC5E) {false} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F0_CL) {26} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F0_CWL) {24} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F0_DDR5_TCCD_L_WR) {32} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F0_DDR5_TCCD_L_WR2) {16} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F0_DDR5_TCCD_L_WR2_RU) {16} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F0_DDR5_TCCD_L_WR_RU) {32} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F0_DDR5_TPD) {7500} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F0_DDR5_TRP) {16250} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F0_DDR5_TRRD_L) {8} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F0_LP5_BANK_ARCH) {NA} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F0_LP5_TCSPD) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F0_LP5_TRPAB) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F0_LP5_TRPAB_DERATE) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F0_LP5_TRPPB) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F0_LP5_TRPPB_DERATE) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F0_LP5_TRRD) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F0_LP5_TRRD_DERATE) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F0_RL) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F0_TCCD_L) {8} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F0_TCK) {625} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F0_TFAW) {20000} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F0_TRAS) {32000} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F0_TRAS_DERATE) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F0_TRCD) {16250} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F0_TRCD_DERATE) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F0_TRTP) {12} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F0_TRTP_RU) {12} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F0_TXP) {7500} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F0_TZQLAT) {30000} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F0_WL) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F1_CL) {26} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F1_CWL) {24} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F1_DDR5_TCCD_L_WR) {32} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F1_DDR5_TCCD_L_WR2) {16} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F1_DDR5_TCCD_L_WR2_RU) {16} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F1_DDR5_TCCD_L_WR_RU) {32} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F1_DDR5_TPD) {7500} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F1_DDR5_TRP) {16250} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F1_DDR5_TRRD_L) {8} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F1_LP5_BANK_ARCH) {NA} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F1_LP5_TCSPD) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F1_LP5_TRPAB) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F1_LP5_TRPAB_DERATE) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F1_LP5_TRPPB) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F1_LP5_TRPPB_DERATE) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F1_LP5_TRRD) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F1_LP5_TRRD_DERATE) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F1_RL) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F1_TCCD_L) {8} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F1_TCK) {625} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F1_TFAW) {20000} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F1_TRAS) {32000} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F1_TRAS_DERATE) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F1_TRCD) {16250} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F1_TRCD_DERATE) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F1_TRTP) {12} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F1_TRTP_RU) {12} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F1_TXP) {7500} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F1_TZQLAT) {30000} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_F1_WL) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_FREQ_SWITCHING) {false} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_INIT_TIMEOUT) {0X00653CFE} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_INLINE_ECC) {false} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_INPUTCLK0_PERIOD) {3125} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_INTERLEAVE_SIZE) {128} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_LATENCY_MODE) {NA} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_LBDQ_SWAP) {false} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_LOW_TRFC_DPR) {false} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_LP5_TPBR2ACT) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_LP5_TPBR2PBR) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_LP5_TRFCAB) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_LP5_TRFCPB) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_LP5_TRFMAB) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_LP5_TRFMPB) {0} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_LP5_X64_EN) {false} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_MAIN_DEVICE_TYPE) {DIMMs} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_MC0_CONFIG_SEL) {config4} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_MC1_CONFIG_SEL) {config4} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_MC2_CONFIG_SEL) {config4} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_MC3_CONFIG_SEL) {config4} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_MC4_CONFIG_SEL) {config4} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_MC5_CONFIG_SEL) {config4} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_MC6_CONFIG_SEL) {config4} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_MC7_CONFIG_SEL) {config4} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_MEMORY_DENSITY) {8GB} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_MEM_FILL) {false} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_NUM_CH) {1} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_NUM_CK) {1} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_NUM_MC) {2} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_NUM_MCP) {1} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_NUM_RANKS) {1} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_NUM_SLOTS) {1} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_ON_DIE_ECC) {false} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_OP_TEMPERATURE) {LOW} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_OTF_SCRUB) {false} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_PERIODIC_READ) {ENABLE} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_PRE_DEF_ADDR_MAP_SEL) {ROW_BANK_COLUMN} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_RDIMM_DUAL_SLOT) {false} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_RD_DBI) {false} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_REFRESH_MODE) {NORMAL} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_REFRESH_TYPE) {ALL_BANK} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_REF_AND_PER_CAL_INTF) {false} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_REG_SCRUB_INTVL) {0x015180} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_ROW_ADDR_WIDTH) {16} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_SCRUB_SIZE) {1} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_SELF_REFRESH) {DISABLE} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_SIDE_BAND_ECC) {false} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_SILICON_REVISION) {NA} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_SPEED_GRADE) {DDR5-6400BN(52-52-52)} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_STACK_HEIGHT) {1} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_SYSTEM_CLOCK) {Differential} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_TREFI) {3900000} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_UBLAZE_BLI_INTF) {false} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_USER_DEFINED_ADDRESS_MAP) {None} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_USER_REFRESH) {false} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_WL_SET) {A} \
    CONFIG.DDRMC5_CONFIG(DDRMC5_WR_DBI) {false} \
    CONFIG.DDRMC5_INTERLEAVE_SIZE {128} \
    CONFIG.MC_CHAN_REGION1 {DDR_CH0_MED} \
    CONFIG.NUM_CLKS {8} \
    CONFIG.NUM_MC {2} \
    CONFIG.NUM_MCP {1} \
    CONFIG.NUM_MI {0} \
    CONFIG.NUM_SI {8} \
  ] $axi_noc2_1


  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {MC_0 {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4} initial_boot {true} }} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins $axi_noc2_1/S00_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {MC_0 {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4} initial_boot {true} }} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins $axi_noc2_1/S01_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {MC_0 {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4} initial_boot {true} }} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins $axi_noc2_1/S02_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {MC_0 {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4} initial_boot {true} }} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins $axi_noc2_1/S03_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {MC_0 {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4} initial_boot {true} }} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_nci} \
 ] [get_bd_intf_pins $axi_noc2_1/S04_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {MC_0 {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4} initial_boot {true} }} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_nci} \
 ] [get_bd_intf_pins $axi_noc2_1/S05_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {MC_0 {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4} initial_boot {true} }} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_rpu} \
 ] [get_bd_intf_pins $axi_noc2_1/S06_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.R_TRAFFIC_CLASS {BEST_EFFORT} \
   CONFIG.W_TRAFFIC_CLASS {BEST_EFFORT} \
   CONFIG.CONNECTIONS {MC_0 {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4} initial_boot {true} }} \
   CONFIG.DEST_IDS {} \
   CONFIG.NOC_PARAMS {} \
   CONFIG.CATEGORY {ps_pmc} \
 ] [get_bd_intf_pins $axi_noc2_1/S07_AXI]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S00_AXI} \
 ] [get_bd_pins $axi_noc2_1/aclk0]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S01_AXI} \
 ] [get_bd_pins $axi_noc2_1/aclk1]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S02_AXI} \
 ] [get_bd_pins $axi_noc2_1/aclk2]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S03_AXI} \
 ] [get_bd_pins $axi_noc2_1/aclk3]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S07_AXI} \
 ] [get_bd_pins $axi_noc2_1/aclk4]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S04_AXI} \
 ] [get_bd_pins $axi_noc2_1/aclk5]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S05_AXI} \
 ] [get_bd_pins $axi_noc2_1/aclk6]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S06_AXI} \
 ] [get_bd_pins $axi_noc2_1/aclk7]

  # Create instance: ps_wizard_0, and set properties
  set ps_wizard_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ps_wizard:1.0 ps_wizard_0 ]
  set_property -dict [list \
    CONFIG.CPM6_CONFIG(CPM6_PERIPHERAL_EN) {0} \
    CONFIG.CPM6_CONFIG(PMC_REFCLK_FREQ) {33.3} \
    CONFIG.PS_PMC_CONFIG(CPM6_CTRL0_MODE) {CTRL} \
    CONFIG.PS_PMC_CONFIG(PMC_HSM1_CLK_OUT_ENABLE) {1} \
    CONFIG.PS_PMC_CONFIG(PMC_I2CPMC_PERIPHERAL) {ENABLE 1 IO PMC_MIO_46:47 IO_TYPE MIO} \
    CONFIG.PS_PMC_CONFIG(PMC_MIO37) {DRIVE_STRENGTH 8mA SLEW slow PULL pullup SCHMITT 0 AUX_IO 0 USAGE GPIO OUTPUT_DATA default DIRECTION in} \
    CONFIG.PS_PMC_CONFIG(PMC_MIO48) {DRIVE_STRENGTH 8mA SLEW slow PULL pullup SCHMITT 0 AUX_IO 0 USAGE GPIO OUTPUT_DATA default DIRECTION in} \
    CONFIG.PS_PMC_CONFIG(PMC_MIO49) {DRIVE_STRENGTH 8mA SLEW slow PULL pullup SCHMITT 0 AUX_IO 0 USAGE GPIO OUTPUT_DATA default DIRECTION in} \
    CONFIG.PS_PMC_CONFIG(PMC_OSPI_PERIPHERAL) {PRIMARY_ENABLE 0 SECONDARY_ENABLE 0 IO PMC_MIO_0:13 MODE Single} \
    CONFIG.PS_PMC_CONFIG(PMC_QSPI_BAUD_RATE_DIV) {8} \
    CONFIG.PS_PMC_CONFIG(PMC_QSPI_PERIPHERAL) {PRIMARY_ENABLE 0 SECONDARY_ENABLE 1 MODE Dual_Parallel} \
    CONFIG.PS_PMC_CONFIG(PMC_QSPI_PERIPHERAL_DATA_MODE) {x4} \
    CONFIG.PS_PMC_CONFIG(PMC_SD1_20) {CD_ENABLE 1 POW_ENABLE 1 WP_ENABLE 1 RESET_ENABLE 0 CD_IO PMC_MIO_28 POW_IO PMC_MIO_51 WP_IO PMC_MIO_50 RESET_IO PMC_MIO_12 CLK_50_SDR_ITAP_DLY 0x2C CLK_50_SDR_OTAP_DLY\
0x4 CLK_50_DDR_ITAP_DLY 0x00 CLK_50_DDR_OTAP_DLY 0x00 CLK_100_SDR_OTAP_DLY 0x00 CLK_200_SDR_OTAP_DLY 0x00} \
    CONFIG.PS_PMC_CONFIG(PMC_SD1_20_PERIPHERAL) {PRIMARY_ENABLE 0 SECONDARY_ENABLE 1 IO PMC_MIO_26:36 IO_TYPE MIO} \
    CONFIG.PS_PMC_CONFIG(PMC_SD1_30) {CD_ENABLE 0 POW_ENABLE 0 WP_ENABLE 0 RESET_ENABLE 0 CD_IO PMC_MIO_2 POW_IO PMC_MIO_12 WP_IO PMC_MIO_1 RESET_IO PMC_MIO_12 CLK_50_SDR_ITAP_DLY 0x00 CLK_50_SDR_OTAP_DLY\
0x00 CLK_50_DDR_ITAP_DLY 0x00 CLK_50_DDR_OTAP_DLY 0x00 CLK_100_SDR_OTAP_DLY 0x00 CLK_200_SDR_OTAP_DLY 0x00} \
    CONFIG.PS_PMC_CONFIG(PMC_SD1_30AD) {CD_ENABLE 0 POW_ENABLE 0 WP_ENABLE 0 RESET_ENABLE 0 CD_IO PMC_MIO_2 POW_IO PMC_MIO_12 WP_IO PMC_MIO_1 RESET_IO PMC_MIO_12 CLK_50_SDR_ITAP_DLY 0x00 CLK_50_SDR_OTAP_DLY\
0x00 CLK_50_DDR_ITAP_DLY 0x00 CLK_50_DDR_OTAP_DLY 0x00 CLK_100_SDR_OTAP_DLY 0x00 CLK_200_SDR_OTAP_DLY 0x00} \
    CONFIG.PS_PMC_CONFIG(PMC_SD1_30AD_PERIPHERAL) {PRIMARY_ENABLE 0 SECONDARY_ENABLE 0 IO PMC_MIO_0:11 IO_TYPE MIO} \
    CONFIG.PS_PMC_CONFIG(PMC_SD1_30_PERIPHERAL) {PRIMARY_ENABLE 0 SECONDARY_ENABLE 0 IO PMC_MIO_0:11 IO_TYPE MIO} \
    CONFIG.PS_PMC_CONFIG(PMC_SD1_EMMC_PERIPHERAL) {PRIMARY_ENABLE 0 SECONDARY_ENABLE 0 IO PMC_MIO_0:11 IO_TYPE MIO} \
    CONFIG.PS_PMC_CONFIG(PMC_USE_PMC_AXI_NOC0) {1} \
    CONFIG.PS_PMC_CONFIG(PS_CAN0_PERIPHERAL) {ENABLE 0 IO PMC_MIO_8:9 IO_TYPE MIO} \
    CONFIG.PS_PMC_CONFIG(PS_CAN1_PERIPHERAL) {ENABLE 1 IO PMC_MIO_40:41 IO_TYPE MIO} \
    CONFIG.PS_PMC_CONFIG(PS_ENET0_MDIO) {ENABLE 0 IO PMC_MIO_50:51 IO_TYPE MIO} \
    CONFIG.PS_PMC_CONFIG(PS_ENET0_PERIPHERAL) {ENABLE 1 IO PS_MIO_0:11 IO_TYPE MIO} \
    CONFIG.PS_PMC_CONFIG(PS_ENET1_MDIO) {ENABLE 1 IO PS_MIO_24:25 IO_TYPE MIO} \
    CONFIG.PS_PMC_CONFIG(PS_ENET1_PERIPHERAL) {ENABLE 1 IO PS_MIO_12:23 IO_TYPE MIO} \
    CONFIG.PS_PMC_CONFIG(PS_GEN_IPI0_ENABLE) {1} \
    CONFIG.PS_PMC_CONFIG(PS_GEN_IPI1_ENABLE) {1} \
    CONFIG.PS_PMC_CONFIG(PS_GEN_IPI2_ENABLE) {1} \
    CONFIG.PS_PMC_CONFIG(PS_GEN_IPI3_ENABLE) {1} \
    CONFIG.PS_PMC_CONFIG(PS_GEN_IPI4_ENABLE) {1} \
    CONFIG.PS_PMC_CONFIG(PS_GEN_IPI5_ENABLE) {1} \
    CONFIG.PS_PMC_CONFIG(PS_GEN_IPI6_ENABLE) {1} \
    CONFIG.PS_PMC_CONFIG(PS_GPIO_EMIO_PERIPHERAL_ENABLE) {0} \
    CONFIG.PS_PMC_CONFIG(PS_I2C0_PERIPHERAL) {ENABLE 0 IO PMC_MIO_2:3 IO_TYPE MIO} \
    CONFIG.PS_PMC_CONFIG(PS_I2C1_PERIPHERAL) {ENABLE 1 IO PMC_MIO_44:45 IO_TYPE MIO} \
    CONFIG.PS_PMC_CONFIG(PS_SLR_ID) {0} \
    CONFIG.PS_PMC_CONFIG(PS_SPI0) {GRP_SS0_ENABLE 0 GRP_SS0_IO PMC_MIO_15 GRP_SS1_ENABLE 0 GRP_SS1_IO PMC_MIO_14 GRP_SS2_ENABLE 0 GRP_SS2_IO PMC_MIO_13 PERIPHERAL_ENABLE 0 PERIPHERAL_IO PMC_MIO_12:17 IO_TYPE\
MIO} \
    CONFIG.PS_PMC_CONFIG(PS_SPI1) {GRP_SS0_ENABLE 0 GRP_SS0_IO PMC_MIO_35 GRP_SS1_ENABLE 0 GRP_SS1_IO PMC_MIO_34 GRP_SS2_ENABLE 0 GRP_SS2_IO PMC_MIO_33 PERIPHERAL_ENABLE 0 PERIPHERAL_IO PMC_MIO_32:37 IO_TYPE\
MIO} \
    CONFIG.PS_PMC_CONFIG(PS_TTC0_PERIPHERAL_ENABLE) {1} \
    CONFIG.PS_PMC_CONFIG(PS_TTC1_PERIPHERAL_ENABLE) {1} \
    CONFIG.PS_PMC_CONFIG(PS_TTC2_PERIPHERAL_ENABLE) {1} \
    CONFIG.PS_PMC_CONFIG(PS_TTC3_PERIPHERAL_ENABLE) {1} \
    CONFIG.PS_PMC_CONFIG(PS_UART0_PERIPHERAL) {ENABLE 1 IO PMC_MIO_42:43 IO_TYPE MIO} \
    CONFIG.PS_PMC_CONFIG(PS_UART1_PERIPHERAL) {ENABLE 0 IO PMC_MIO_4:5 IO_TYPE MIO} \
    CONFIG.PS_PMC_CONFIG(PS_USB3_PERIPHERAL) {ENABLE 1 IO PMC_MIO_13:25 IO_TYPE MIO} \
    CONFIG.PS_PMC_CONFIG(PS_USE_FPD_AXI_NOC0) {1} \
    CONFIG.PS_PMC_CONFIG(PS_USE_FPD_AXI_NOC1) {1} \
    CONFIG.PS_PMC_CONFIG(PS_USE_FPD_AXI_PL) {0} \
    CONFIG.PS_PMC_CONFIG(PS_USE_FPD_CCI_NOC) {1} \
    CONFIG.PS_PMC_CONFIG(PS_USE_LPD_AXI_NOC0) {1} \
    CONFIG.PS_PMC_CONFIG(PS_USE_LPD_AXI_PL) {0} \
    CONFIG.PS_PMC_CONFIG(PS_WWDT0_PERIPHERAL) {ENABLE 0 IO PMC_MIO_0:5 IO_TYPE MIO} \
    CONFIG.PS_PMC_CONFIG(PS_WWDT1_PERIPHERAL) {ENABLE 0 IO PMC_MIO_6:11 IO_TYPE MIO} \
    CONFIG.PS_PMC_CONFIG(SMON_OT) {THRESHOLD_LOWER -55 THRESHOLD_UPPER 125} \
    CONFIG.PS_PMC_CONFIG(SMON_USER_TEMP) {USER_ALARM_TYPE hysteresis THRESHOLD_LOWER -55 THRESHOLD_UPPER 125} \
  ] $ps_wizard_0


  # Create interface connections
  connect_bd_intf_net -intf_net SYS_CLK0_IN_0_1 [get_bd_intf_ports SYS_CLK0_IN_0] [get_bd_intf_pins axi_noc2_1/sys_clk0]
  connect_bd_intf_net -intf_net axi_noc2_1_C0_DDR5 [get_bd_intf_ports C0_DDR5_0] [get_bd_intf_pins axi_noc2_1/C0_DDR5]
  connect_bd_intf_net -intf_net ps_wizard_0_FPD_AXI_NOC0 [get_bd_intf_pins ps_wizard_0/FPD_AXI_NOC0] [get_bd_intf_pins axi_noc2_1/S04_AXI]
  connect_bd_intf_net -intf_net ps_wizard_0_FPD_AXI_NOC1 [get_bd_intf_pins ps_wizard_0/FPD_AXI_NOC1] [get_bd_intf_pins axi_noc2_1/S05_AXI]
  connect_bd_intf_net -intf_net ps_wizard_0_FPD_CCI_NOC0 [get_bd_intf_pins ps_wizard_0/FPD_CCI_NOC0] [get_bd_intf_pins axi_noc2_1/S00_AXI]
  connect_bd_intf_net -intf_net ps_wizard_0_FPD_CCI_NOC1 [get_bd_intf_pins ps_wizard_0/FPD_CCI_NOC1] [get_bd_intf_pins axi_noc2_1/S01_AXI]
  connect_bd_intf_net -intf_net ps_wizard_0_FPD_CCI_NOC2 [get_bd_intf_pins ps_wizard_0/FPD_CCI_NOC2] [get_bd_intf_pins axi_noc2_1/S02_AXI]
  connect_bd_intf_net -intf_net ps_wizard_0_FPD_CCI_NOC3 [get_bd_intf_pins ps_wizard_0/FPD_CCI_NOC3] [get_bd_intf_pins axi_noc2_1/S03_AXI]
  connect_bd_intf_net -intf_net ps_wizard_0_LPD_AXI_NOC0 [get_bd_intf_pins ps_wizard_0/LPD_AXI_NOC0] [get_bd_intf_pins axi_noc2_1/S06_AXI]
  connect_bd_intf_net -intf_net ps_wizard_0_PMC_AXI_NOC0 [get_bd_intf_pins ps_wizard_0/PMC_AXI_NOC0] [get_bd_intf_pins axi_noc2_1/S07_AXI]

  # Create port connections
  connect_bd_net -net ps_wizard_0_fpd_axi_noc0_clk  [get_bd_pins ps_wizard_0/fpd_axi_noc0_clk] \
  [get_bd_pins axi_noc2_1/aclk5]
  connect_bd_net -net ps_wizard_0_fpd_axi_noc1_clk  [get_bd_pins ps_wizard_0/fpd_axi_noc1_clk] \
  [get_bd_pins axi_noc2_1/aclk6]
  connect_bd_net -net ps_wizard_0_fpd_cci_noc0_clk  [get_bd_pins ps_wizard_0/fpd_cci_noc0_clk] \
  [get_bd_pins axi_noc2_1/aclk0]
  connect_bd_net -net ps_wizard_0_fpd_cci_noc1_clk  [get_bd_pins ps_wizard_0/fpd_cci_noc1_clk] \
  [get_bd_pins axi_noc2_1/aclk1]
  connect_bd_net -net ps_wizard_0_fpd_cci_noc2_clk  [get_bd_pins ps_wizard_0/fpd_cci_noc2_clk] \
  [get_bd_pins axi_noc2_1/aclk2]
  connect_bd_net -net ps_wizard_0_fpd_cci_noc3_clk  [get_bd_pins ps_wizard_0/fpd_cci_noc3_clk] \
  [get_bd_pins axi_noc2_1/aclk3]
  connect_bd_net -net ps_wizard_0_lpd_axi_noc0_clk  [get_bd_pins ps_wizard_0/lpd_axi_noc0_clk] \
  [get_bd_pins axi_noc2_1/aclk7]
  connect_bd_net -net ps_wizard_0_pmc_axi_noc0_clk  [get_bd_pins ps_wizard_0/pmc_axi_noc0_clk] \
  [get_bd_pins axi_noc2_1/aclk4]

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces ps_wizard_0/pmcps_0_psv_cortexa72_0] [get_bd_addr_segs axi_noc2_1/DDR_MC_PORTS/DDR_CH0_LEGACYx2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces ps_wizard_0/pmcps_0_psv_cortexa72_0] [get_bd_addr_segs axi_noc2_1/DDR_MC_PORTS/DDR_CH0_MEDx2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces ps_wizard_0/pmcps_0_psv_cortexa72_1] [get_bd_addr_segs axi_noc2_1/DDR_MC_PORTS/DDR_CH0_LEGACYx2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces ps_wizard_0/pmcps_0_psv_cortexa72_1] [get_bd_addr_segs axi_noc2_1/DDR_MC_PORTS/DDR_CH0_MEDx2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces ps_wizard_0/pmcps_0_psv_cortexr5_0] [get_bd_addr_segs axi_noc2_1/DDR_MC_PORTS/DDR_CH0_LEGACYx2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces ps_wizard_0/pmcps_0_psv_cortexr5_1] [get_bd_addr_segs axi_noc2_1/DDR_MC_PORTS/DDR_CH0_LEGACYx2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces ps_wizard_0/pmcps_0_psv_dpc_0] [get_bd_addr_segs axi_noc2_1/DDR_MC_PORTS/DDR_CH0_LEGACYx2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces ps_wizard_0/pmcps_0_psv_dpc_0] [get_bd_addr_segs axi_noc2_1/DDR_MC_PORTS/DDR_CH0_MEDx2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces ps_wizard_0/pmcps_0_psv_pmc_0] [get_bd_addr_segs axi_noc2_1/DDR_MC_PORTS/DDR_CH0_LEGACYx2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000180000000 -target_address_space [get_bd_addr_spaces ps_wizard_0/pmcps_0_psv_pmc_0] [get_bd_addr_segs axi_noc2_1/DDR_MC_PORTS/DDR_CH0_MEDx2] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces ps_wizard_0/pmcps_0_psv_psm_0] [get_bd_addr_segs axi_noc2_1/DDR_MC_PORTS/DDR_CH0_LEGACYx2] -force

  # Exclude Address Segments
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces ps_wizard_0/pmcps_0_psv_cortexr5_0] [get_bd_addr_segs axi_noc2_1/DDR_MC_PORTS/DDR_CH0_MEDx2]
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces ps_wizard_0/pmcps_0_psv_cortexr5_1] [get_bd_addr_segs axi_noc2_1/DDR_MC_PORTS/DDR_CH0_MEDx2]
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces ps_wizard_0/pmcps_0_psv_psm_0] [get_bd_addr_segs axi_noc2_1/DDR_MC_PORTS/DDR_CH0_MEDx2]


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()
