# Copyright (C) 2024, Advanced Micro Devices, Inc.
# SPDX-License-Identifier: Apache-2.0

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
  set C0_CH0_LPDDR5_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr5_rtl:1.0 C0_CH0_LPDDR5_0 ]

  set C0_CH1_LPDDR5_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr5_rtl:1.0 C0_CH1_LPDDR5_0 ]

  set sys_clk0_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sys_clk0_0 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {320000000} \
   ] $sys_clk0_0


  # Create ports

  # Create instance: axi_noc_0, and set properties
  set axi_noc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc2:* axi_noc_0 ]
  set_property -dict [list \
    CONFIG.DDR5_DEVICE_TYPE {Components} \
    CONFIG.DDRMC5_CONFIG {DDRMC5_CONTROLLERTYPE LPDDR5_SDRAM DDRMC5_SPEED_GRADE LPDDR5-6400 DDRMC5_DEVICE_TYPE Components DDRMC5_F0_LP5_BANK_ARCH 16B DDRMC5_F1_LP5_BANK_ARCH 16B DDRMC5_DRAM_WIDTH x16 DDRMC5_DATA_WIDTH\
16 DDRMC5_ROW_ADDR_WIDTH 16 DDRMC5_COL_ADDR_WIDTH 6 DDRMC5_BA_ADDR_WIDTH 4 DDRMC5_BG_WIDTH 0 DDRMC5_BURST_ADDR_WIDTH 4 DDRMC5_NUM_RANKS 1 DDRMC5_LATENCY_MODE x16 DDRMC5_NUM_SLOTS 1 DDRMC5_NUM_CK 1 DDRMC5_NUM_CH\
2 DDRMC5_STACK_HEIGHT 1 DDRMC5_DRAM_SIZE 16Gb DDRMC5_MEMORY_DENSITY 2GB DDRMC5_DM_EN true DDRMC5_DQS_OSCI_EN ENABLE DDRMC5_SIDE_BAND_ECC false DDRMC5_INLINE_ECC false DDRMC5_DDR5_2T DISABLE DDRMC5_REFRESH_MODE\
NORMAL DDRMC5_REFRESH_TYPE ALL_BANK DDRMC5_FREQ_SWITCHING false DDRMC5_BACKGROUND_SCRUB false DDRMC5_SCRUB_SIZE 1 DDRMC5_MEM_FILL false DDRMC5_PERIODIC_READ ENABLE DDRMC5_USER_REFRESH false DDRMC5_WL_SET\
A DDRMC5_WR_DBI false DDRMC5_RD_DBI false DDRMC5_AUTO_PRECHARGE false DDRMC5_CRYPTO false DDRMC5_ON_DIE_ECC false DDRMC5_F0_TCK 2500 DDRMC5_INPUTCLK0_PERIOD 3125 DDRMC5_F0_TFAW 20000 DDRMC5_F0_DDR5_TRP\
18000 DDRMC5_F0_TRTP 7500 DDRMC5_F0_TRCD 18000 DDRMC5_TREFI 3906000 DDRMC5_DDR5_TRFC1 0 DDRMC5_DDR5_TRFC2 0 DDRMC5_DDR5_TRFCSB 0 DDRMC5_F0_TRAS 42000 DDRMC5_F0_TZQLAT 30000 DDRMC5_F0_DDR5_TCCD_L_WR 0 DDRMC5_F0_TXP\
7500 DDRMC5_F0_DDR5_TPD 0 DDRMC5_DDR5_TREFSBRD 0 DDRMC5_DDR5_TRFC1_DLR 0 DDRMC5_DDR5_TRFC1_DPR 0 DDRMC5_DDR5_TRFC2_DLR 0 DDRMC5_DDR5_TRFC2_DPR 0 DDRMC5_DDR5_TRFCSB_DLR 0 DDRMC5_DDR5_TREFSBRD_SLR 0 DDRMC5_DDR5_TREFSBRD_DLR\
0 DDRMC5_F0_CL 46 DDRMC5_F0_CWL 0 DDRMC5_F0_DDR5_TRRD_L 0 DDRMC5_F0_TCCD_L 17 DDRMC5_F0_DDR5_TCCD_L_WR2 0 DDRMC5_DDR5_TFAW_DLR 0 DDRMC5_F1_TCK 2500 DDRMC5_F1_TFAW 20000 DDRMC5_F1_DDR5_TRP 18000 DDRMC5_F1_TRTP\
7500 DDRMC5_F1_TRCD 18000 DDRMC5_F1_TRAS 42000 DDRMC5_F1_TZQLAT 30000 DDRMC5_F1_DDR5_TCCD_L_WR 0 DDRMC5_F1_TXP 7500 DDRMC5_F1_DDR5_TPD 0 DDRMC5_F1_CL 46 DDRMC5_F1_CWL 0 DDRMC5_F1_DDR5_TRRD_L 0 DDRMC5_F1_TCCD_L\
17 DDRMC5_F1_DDR5_TCCD_L_WR2 0 DDRMC5_LP5_TRFCAB 280000 DDRMC5_LP5_TRFCPB 140000 DDRMC5_LP5_TPBR2PBR 90000 DDRMC5_F0_LP5_TRPAB 21000 DDRMC5_F0_LP5_TRPPB 18000 DDRMC5_F0_LP5_TRRD 5000 DDRMC5_LP5_TPBR2ACT\
7500 DDRMC5_F0_LP5_TCSPD 12500 DDRMC5_F0_RL 9 DDRMC5_F0_WL 5 DDRMC5_F1_LP5_TRPAB 21000 DDRMC5_F1_LP5_TRPPB 18000 DDRMC5_F1_LP5_TRRD 5000 DDRMC5_F1_LP5_TCSPD 12500 DDRMC5_F1_RL 9 DDRMC5_F1_WL 5 DDRMC5_LP5_TRFMAB\
280000 DDRMC5_LP5_TRFMPB 190000 DDRMC5_SYSTEM_CLOCK Differential DDRMC5_UBLAZE_BLI_INTF false DDRMC5_REF_AND_PER_CAL_INTF false DDRMC5_PRE_DEF_ADDR_MAP_SEL ROW_BANK_COLUMN DDRMC5_USER_DEFINED_ADDRESS_MAP\
None DDRMC5_ADDRESS_MAP NA,NA,NA,NA,NA,NA,NA,NA,RA15,RA14,RA13,RA12,RA11,RA10,RA9,RA8,RA7,RA6,RA5,RA4,RA3,RA2,RA1,RA0,BA3,BA2,BA1,BA0,CA5,CA4,CA3,CA2,NC,CA1,CA0,NC,NC,NC,NC,NA DDRMC5_MC0_CONFIG_SEL config9\
DDRMC5_LOW_TRFC_DPR false DDRMC5_NUM_MC 1 DDRMC5_NUM_MCP 1 DDRMC5_MAIN_DEVICE_TYPE Components DDRMC5_INTERLEAVE_SIZE 128 } \
    CONFIG.MC_CHAN_REGION0 {DDR_CH0_LEGACY} \
    CONFIG.NUM_CLKS {10} \
    CONFIG.NUM_MC {1} \
    CONFIG.NUM_MI {0} \
    CONFIG.NUM_NSI {0} \
    CONFIG.NUM_SI {10} \
  ] $axi_noc_0


  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} MC_1 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.DEST_IDS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S00_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} MC_1 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.DEST_IDS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S01_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} MC_1 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.DEST_IDS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S02_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} MC_1 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.DEST_IDS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S03_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} MC_1 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.DEST_IDS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S04_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} MC_1 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.DEST_IDS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S05_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} MC_1 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.DEST_IDS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S06_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} MC_1 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.DEST_IDS {} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /axi_noc_0/S07_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} MC_1 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.DEST_IDS {} \
   CONFIG.CATEGORY {ps_pmc} \
 ] [get_bd_intf_pins /axi_noc_0/S08_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS {MC_0 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} MC_1 { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}}} \
   CONFIG.DEST_IDS {} \
   CONFIG.CATEGORY {ps_rpu} \
 ] [get_bd_intf_pins /axi_noc_0/S09_AXI]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S00_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk0]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S01_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk1]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S02_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk2]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S03_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk3]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S04_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk4]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S05_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk5]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S06_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk6]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S07_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk7]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S09_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk8]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S08_AXI} \
 ] [get_bd_pins /axi_noc_0/aclk9]

  # Create instance: psx_wizard_0, and set properties
  set psx_wizard_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:psx_wizard:* psx_wizard_0 ]
  set_property -dict [list \
    CONFIG.PSX_PMCX_CONFIG(PMCX_CRP_PL0_REF_CTRL_DIVISOR0) {24} \
    CONFIG.PSX_PMCX_CONFIG(PMCX_CRP_PL0_REF_CTRL_FREQMHZ) {50} \
    CONFIG.PSX_PMCX_CONFIG(PMCX_EMMC) {CD_ENABLE 0 POW_ENABLE 0 WP_ENABLE 0 RESET_ENABLE 0 CD_IO PMCX_MIO_2 POW_IO PMCX_MIO_12 WP_IO PMCX_MIO_1 RESET_IO PMCX_MIO_25 CLK_50_SDR_ITAP_DLY 0x00 CLK_50_SDR_OTAP_DLY\
0x00 CLK_50_DDR_ITAP_DLY 0x00 CLK_50_DDR_OTAP_DLY 0x00 CLK_100_SDR_OTAP_DLY 0x00 CLK_200_SDR_OTAP_DLY 0x00} \
    CONFIG.PSX_PMCX_CONFIG(PMCX_EMMC_DATA_TRANSFER_MODE) {4Bit} \
    CONFIG.PSX_PMCX_CONFIG(PMCX_EMMC_PERIPHERAL) {PRIMARY_ENABLE 0 SECONDARY_ENABLE 0 IO PMCX_MIO_14:25 IO_TYPE MIO} \
    CONFIG.PSX_PMCX_CONFIG(PMCX_I3C_I2C_PERIPHERAL) {ENABLE 1 TYPE I3C} \
    CONFIG.PSX_PMCX_CONFIG(PMCX_MIO26) {DRIVE_STRENGTH 8mA SLEW slow PULL pullup SCHMITT 0 AUX_IO 0 USAGE GPIO OUTPUT_DATA default DIRECTION in} \
    CONFIG.PSX_PMCX_CONFIG(PMCX_MIO48) {DRIVE_STRENGTH 8mA SLEW slow PULL pullup SCHMITT 0 AUX_IO 0 USAGE GPIO OUTPUT_DATA default DIRECTION in} \
    CONFIG.PSX_PMCX_CONFIG(PMCX_OSPI_ECC_FAIL_IO) {PMCX_MIO_26} \
    CONFIG.PSX_PMCX_CONFIG(PMCX_OSPI_PERIPHERAL) {PRIMARY_ENABLE 0 SECONDARY_ENABLE 0 IO PMCX_MIO_0:13 MODE Single} \
    CONFIG.PSX_PMCX_CONFIG(PMCX_QSPI_FBCLK) {ENABLE 1 IO PMCX_MIO_6} \
    CONFIG.PSX_PMCX_CONFIG(PMCX_QSPI_PERIPHERAL) {PRIMARY_ENABLE 1 SECONDARY_ENABLE 0 MODE Dual_Parallel} \
    CONFIG.PSX_PMCX_CONFIG(PMCX_SDIO_20_PERIPHERAL) {PRIMARY_ENABLE 0 SECONDARY_ENABLE 0 IO PMCX_MIO_13:25 IO_TYPE MIO} \
    CONFIG.PSX_PMCX_CONFIG(PMCX_SDIO_30) {CD_ENABLE 1 POW_ENABLE 1 WP_ENABLE 1 RESET_ENABLE 0 CD_IO PMCX_MIO_24 POW_IO PMCX_MIO_17 WP_IO PMCX_MIO_25 RESET_IO PMCX_MIO_17 CLK_50_SDR_ITAP_DLY 0x00 CLK_50_SDR_OTAP_DLY\
0x00 CLK_50_DDR_ITAP_DLY 0x00 CLK_50_DDR_OTAP_DLY 0x00 CLK_100_SDR_OTAP_DLY 0x00 CLK_200_SDR_OTAP_DLY 0x00} \
    CONFIG.PSX_PMCX_CONFIG(PMCX_SDIO_30_PERIPHERAL) {PRIMARY_ENABLE 1 SECONDARY_ENABLE 0 IO PMCX_MIO_13:25 IO_TYPE MIO} \
    CONFIG.PSX_PMCX_CONFIG(PMCX_USE_PMCX_AXI_NOC0) {1} \
    CONFIG.PSX_PMCX_CONFIG(PSX_CAN0_PERIPHERAL) {ENABLE 1 IO PMCX_MIO_46:47 IO_TYPE MIO} \
    CONFIG.PSX_PMCX_CONFIG(PSX_CAN1_PERIPHERAL) {ENABLE 1 IO PMCX_MIO_44:45 IO_TYPE MIO} \
    CONFIG.PSX_PMCX_CONFIG(PSX_ENET0_MDIO) {ENABLE 1 IO PSX_MIO_24:25 IO_TYPE MIO} \
    CONFIG.PSX_PMCX_CONFIG(PSX_ENET0_PERIPHERAL) {ENABLE 1 IO PSX_MIO_0:11 IO_TYPE MIO MODE RGMII} \
    CONFIG.PSX_PMCX_CONFIG(PSX_ENET1_MDIO) {ENABLE 0 IO PMCX_MIO_50:51 IO_TYPE MIO} \
    CONFIG.PSX_PMCX_CONFIG(PSX_ENET1_PERIPHERAL) {ENABLE 0 IO PMCX_MIO_38:49 IO_TYPE MIO MODE RGMII} \
    CONFIG.PSX_PMCX_CONFIG(PSX_GEN_IPI0_ENABLE) {1} \
    CONFIG.PSX_PMCX_CONFIG(PSX_GEN_IPI1_ENABLE) {1} \
    CONFIG.PSX_PMCX_CONFIG(PSX_GEN_IPI1_MASTER) {R52_0} \
    CONFIG.PSX_PMCX_CONFIG(PSX_GEN_IPI1_NOBUF_ENABLE) {1} \
    CONFIG.PSX_PMCX_CONFIG(PSX_GEN_IPI1_NOBUF_MASTER) {A78_0} \
    CONFIG.PSX_PMCX_CONFIG(PSX_GEN_IPI2_ENABLE) {1} \
    CONFIG.PSX_PMCX_CONFIG(PSX_GEN_IPI2_MASTER) {R52_1} \
    CONFIG.PSX_PMCX_CONFIG(PSX_GEN_IPI2_NOBUF_ENABLE) {1} \
    CONFIG.PSX_PMCX_CONFIG(PSX_GEN_IPI2_NOBUF_MASTER) {R52_0} \
    CONFIG.PSX_PMCX_CONFIG(PSX_GEN_IPI3_ENABLE) {1} \
    CONFIG.PSX_PMCX_CONFIG(PSX_GEN_IPI3_NOBUF_ENABLE) {1} \
    CONFIG.PSX_PMCX_CONFIG(PSX_GEN_IPI3_NOBUF_MASTER) {R52_1} \
    CONFIG.PSX_PMCX_CONFIG(PSX_GEN_IPI4_ENABLE) {1} \
    CONFIG.PSX_PMCX_CONFIG(PSX_GEN_IPI4_NOBUF_ENABLE) {1} \
    CONFIG.PSX_PMCX_CONFIG(PSX_GEN_IPI4_NOBUF_MASTER) {R52_2} \
    CONFIG.PSX_PMCX_CONFIG(PSX_GEN_IPI5_ENABLE) {1} \
    CONFIG.PSX_PMCX_CONFIG(PSX_GEN_IPI5_NOBUF_ENABLE) {1} \
    CONFIG.PSX_PMCX_CONFIG(PSX_GEN_IPI5_NOBUF_MASTER) {R52_3} \
    CONFIG.PSX_PMCX_CONFIG(PSX_GEN_IPI6_ENABLE) {1} \
    CONFIG.PSX_PMCX_CONFIG(PSX_GEN_IPI6_NOBUF_ENABLE) {1} \
    CONFIG.PSX_PMCX_CONFIG(PSX_GEN_IPI6_NOBUF_MASTER) {R52_0} \
    CONFIG.PSX_PMCX_CONFIG(PSX_GEN_IPI_PMCNOBUF_ENABLE) {1} \
    CONFIG.PSX_PMCX_CONFIG(PSX_GEN_IPI_PMCX_ENABLE) {1} \
    CONFIG.PSX_PMCX_CONFIG(PSX_GEN_IPI_PSM_ENABLE) {1} \
    CONFIG.PSX_PMCX_CONFIG(PSX_GPIO2_MIO_PERIPHERAL) {ENABLE 0 IO PSX_MIO_0:25} \
    CONFIG.PSX_PMCX_CONFIG(PSX_I3C_I2C0_PERIPHERAL) {ENABLE 1 IO PMCX_MIO_42:43 IO_TYPE MIO TYPE I3C} \
    CONFIG.PSX_PMCX_CONFIG(PSX_I3C_I2C1_PERIPHERAL) {ENABLE 1 IO PMCX_MIO_40:41 IO_TYPE MIO TYPE I3C} \
    CONFIG.PSX_PMCX_CONFIG(PSX_MIO18) {DRIVE_STRENGTH 8mA SLEW slow PULL pullup SCHMITT 0 AUX_IO 0 USAGE GPIO OUTPUT_DATA default DIRECTION in} \
    CONFIG.PSX_PMCX_CONFIG(PSX_MIO19) {DRIVE_STRENGTH 8mA SLEW slow PULL pullup SCHMITT 0 AUX_IO 0 USAGE GPIO OUTPUT_DATA default DIRECTION in} \
    CONFIG.PSX_PMCX_CONFIG(PSX_MIO20) {DRIVE_STRENGTH 8mA SLEW slow PULL pullup SCHMITT 0 AUX_IO 0 USAGE GPIO OUTPUT_DATA default DIRECTION in} \
    CONFIG.PSX_PMCX_CONFIG(PSX_MIO21) {DRIVE_STRENGTH 8mA SLEW slow PULL pullup SCHMITT 0 AUX_IO 0 USAGE GPIO OUTPUT_DATA default DIRECTION in} \
    CONFIG.PSX_PMCX_CONFIG(PSX_MIO22) {DRIVE_STRENGTH 8mA SLEW slow PULL pullup SCHMITT 0 AUX_IO 0 USAGE GPIO OUTPUT_DATA default DIRECTION in} \
    CONFIG.PSX_PMCX_CONFIG(PSX_MIO23) {DRIVE_STRENGTH 8mA SLEW slow PULL pullup SCHMITT 0 AUX_IO 0 USAGE GPIO OUTPUT_DATA default DIRECTION in} \
    CONFIG.PSX_PMCX_CONFIG(PSX_PCIE_RESET) {ENABLE 0 IO PMCX_MIO_38:39} \
    CONFIG.PSX_PMCX_CONFIG(PSX_SPI0) {GRP_SS0_ENABLE 0 GRP_SS0_IO PMCX_MIO_15 GRP_SS1_ENABLE 0 GRP_SS1_IO PMCX_MIO_14 GRP_SS2_ENABLE 0 GRP_SS2_IO PMCX_MIO_13 PERIPHERAL_ENABLE 0 PERIPHERAL_IO PMCX_MIO_12:17\
IO_TYPE MIO} \
    CONFIG.PSX_PMCX_CONFIG(PSX_SPI1) {GRP_SS0_ENABLE 0 GRP_SS0_IO PSX_MIO_9 GRP_SS1_ENABLE 0 GRP_SS1_IO PSX_MIO_8 GRP_SS2_ENABLE 0 GRP_SS2_IO PSX_MIO_7 PERIPHERAL_ENABLE 0 PERIPHERAL_IO PSX_MIO_6:11 IO_TYPE\
MIO} \
    CONFIG.PSX_PMCX_CONFIG(PSX_TTC0_PERIPHERAL_ENABLE) {1} \
    CONFIG.PSX_PMCX_CONFIG(PSX_TTC1_PERIPHERAL_ENABLE) {1} \
    CONFIG.PSX_PMCX_CONFIG(PSX_TTC2_PERIPHERAL_ENABLE) {1} \
    CONFIG.PSX_PMCX_CONFIG(PSX_TTC3_PERIPHERAL_ENABLE) {1} \
    CONFIG.PSX_PMCX_CONFIG(PSX_UART0_PERIPHERAL) {ENABLE 1 IO PSX_MIO_16:17 IO_TYPE MIO} \
    CONFIG.PSX_PMCX_CONFIG(PSX_UART0_RTS_CTS) {ENABLE 0 IO PSX_MIO_2:3 IO_TYPE MIO} \
    CONFIG.PSX_PMCX_CONFIG(PSX_UART1_PERIPHERAL) {ENABLE 1 IO PSX_MIO_12:13 IO_TYPE MIO} \
    CONFIG.PSX_PMCX_CONFIG(PSX_UART1_RTS_CTS) {ENABLE 1 IO PSX_MIO_14:15 IO_TYPE MIO} \
    CONFIG.PSX_PMCX_CONFIG(PSX_USB0_PERIPHERAL) {ENABLE 0 IO PMCX_MIO_13:25 IO_TYPE MIO} \
    CONFIG.PSX_PMCX_CONFIG(PSX_USB1_PERIPHERAL) {ENABLE 1 IO PMCX_MIO_27:39 IO_TYPE MIO} \
    CONFIG.PSX_PMCX_CONFIG(PSX_USE_FPD_AXI_NOC) {1} \
    CONFIG.PSX_PMCX_CONFIG(PSX_USE_FPD_AXI_PL) {0} \
    CONFIG.PSX_PMCX_CONFIG(PSX_USE_LPD_AXI_NOC) {1} \
    CONFIG.PSX_PMCX_CONFIG(PSX_USE_PMCPL_CLK0) {0} \
  ] $psx_wizard_0


  # Create interface connections
  connect_bd_intf_net -intf_net axi_noc_0_C0_CH0_LPDDR5 [get_bd_intf_ports C0_CH0_LPDDR5_0] [get_bd_intf_pins axi_noc_0/C0_CH0_LPDDR5]
  connect_bd_intf_net -intf_net axi_noc_0_C0_CH1_LPDDR5 [get_bd_intf_ports C0_CH1_LPDDR5_0] [get_bd_intf_pins axi_noc_0/C0_CH1_LPDDR5]
  connect_bd_intf_net -intf_net psx_wizard_0_FPD_AXI_NOC0 [get_bd_intf_pins axi_noc_0/S00_AXI] [get_bd_intf_pins psx_wizard_0/FPD_AXI_NOC0]
  connect_bd_intf_net -intf_net psx_wizard_0_FPD_AXI_NOC1 [get_bd_intf_pins axi_noc_0/S01_AXI] [get_bd_intf_pins psx_wizard_0/FPD_AXI_NOC1]
  connect_bd_intf_net -intf_net psx_wizard_0_FPD_AXI_NOC2 [get_bd_intf_pins axi_noc_0/S02_AXI] [get_bd_intf_pins psx_wizard_0/FPD_AXI_NOC2]
  connect_bd_intf_net -intf_net psx_wizard_0_FPD_AXI_NOC3 [get_bd_intf_pins axi_noc_0/S03_AXI] [get_bd_intf_pins psx_wizard_0/FPD_AXI_NOC3]
  connect_bd_intf_net -intf_net psx_wizard_0_FPD_AXI_NOC4 [get_bd_intf_pins axi_noc_0/S04_AXI] [get_bd_intf_pins psx_wizard_0/FPD_AXI_NOC4]
  connect_bd_intf_net -intf_net psx_wizard_0_FPD_AXI_NOC5 [get_bd_intf_pins axi_noc_0/S05_AXI] [get_bd_intf_pins psx_wizard_0/FPD_AXI_NOC5]
  connect_bd_intf_net -intf_net psx_wizard_0_FPD_AXI_NOC6 [get_bd_intf_pins axi_noc_0/S06_AXI] [get_bd_intf_pins psx_wizard_0/FPD_AXI_NOC6]
  connect_bd_intf_net -intf_net psx_wizard_0_FPD_AXI_NOC7 [get_bd_intf_pins axi_noc_0/S07_AXI] [get_bd_intf_pins psx_wizard_0/FPD_AXI_NOC7]
  connect_bd_intf_net -intf_net psx_wizard_0_LPD_AXI_NOC0 [get_bd_intf_pins axi_noc_0/S09_AXI] [get_bd_intf_pins psx_wizard_0/LPD_AXI_NOC0]
  connect_bd_intf_net -intf_net psx_wizard_0_PMCX_AXI_NOC0 [get_bd_intf_pins axi_noc_0/S08_AXI] [get_bd_intf_pins psx_wizard_0/PMCX_AXI_NOC0]
  connect_bd_intf_net -intf_net sys_clk0_0_1 [get_bd_intf_ports sys_clk0_0] [get_bd_intf_pins axi_noc_0/sys_clk0]

  # Create port connections
  connect_bd_net -net psx_wizard_0_fpd_axi_noc0_clk [get_bd_pins psx_wizard_0/fpd_axi_noc0_clk] [get_bd_pins axi_noc_0/aclk0]
  connect_bd_net -net psx_wizard_0_fpd_axi_noc1_clk [get_bd_pins psx_wizard_0/fpd_axi_noc1_clk] [get_bd_pins axi_noc_0/aclk1]
  connect_bd_net -net psx_wizard_0_fpd_axi_noc2_clk [get_bd_pins psx_wizard_0/fpd_axi_noc2_clk] [get_bd_pins axi_noc_0/aclk2]
  connect_bd_net -net psx_wizard_0_fpd_axi_noc3_clk [get_bd_pins psx_wizard_0/fpd_axi_noc3_clk] [get_bd_pins axi_noc_0/aclk3]
  connect_bd_net -net psx_wizard_0_fpd_axi_noc4_clk [get_bd_pins psx_wizard_0/fpd_axi_noc4_clk] [get_bd_pins axi_noc_0/aclk4]
  connect_bd_net -net psx_wizard_0_fpd_axi_noc5_clk [get_bd_pins psx_wizard_0/fpd_axi_noc5_clk] [get_bd_pins axi_noc_0/aclk5]
  connect_bd_net -net psx_wizard_0_fpd_axi_noc6_clk [get_bd_pins psx_wizard_0/fpd_axi_noc6_clk] [get_bd_pins axi_noc_0/aclk6]
  connect_bd_net -net psx_wizard_0_fpd_axi_noc7_clk [get_bd_pins psx_wizard_0/fpd_axi_noc7_clk] [get_bd_pins axi_noc_0/aclk7]
  connect_bd_net -net psx_wizard_0_lpd_axi_noc0_clk [get_bd_pins psx_wizard_0/lpd_axi_noc0_clk] [get_bd_pins axi_noc_0/aclk8]
  connect_bd_net -net psx_wizard_0_pmcx_axi_noc0_clk [get_bd_pins psx_wizard_0/pmcx_axi_noc0_clk] [get_bd_pins axi_noc_0/aclk9]

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces psx_wizard_0/psxl_0_pmc_ppu_0] [get_bd_addr_segs axi_noc_0/DDR_MC_PORT01/C0_DDR_CH0_LEGACY] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces psx_wizard_0/psxl_0_psx_cortexa78_0] [get_bd_addr_segs axi_noc_0/DDR_MC_PORT01/C0_DDR_CH0_LEGACY] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces psx_wizard_0/psxl_0_psx_cortexa78_1] [get_bd_addr_segs axi_noc_0/DDR_MC_PORT01/C0_DDR_CH0_LEGACY] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces psx_wizard_0/psxl_0_psx_cortexa78_10] [get_bd_addr_segs axi_noc_0/DDR_MC_PORT01/C0_DDR_CH0_LEGACY] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces psx_wizard_0/psxl_0_psx_cortexa78_11] [get_bd_addr_segs axi_noc_0/DDR_MC_PORT01/C0_DDR_CH0_LEGACY] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces psx_wizard_0/psxl_0_psx_cortexa78_12] [get_bd_addr_segs axi_noc_0/DDR_MC_PORT01/C0_DDR_CH0_LEGACY] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces psx_wizard_0/psxl_0_psx_cortexa78_13] [get_bd_addr_segs axi_noc_0/DDR_MC_PORT01/C0_DDR_CH0_LEGACY] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces psx_wizard_0/psxl_0_psx_cortexa78_14] [get_bd_addr_segs axi_noc_0/DDR_MC_PORT01/C0_DDR_CH0_LEGACY] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces psx_wizard_0/psxl_0_psx_cortexa78_15] [get_bd_addr_segs axi_noc_0/DDR_MC_PORT01/C0_DDR_CH0_LEGACY] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces psx_wizard_0/psxl_0_psx_cortexa78_2] [get_bd_addr_segs axi_noc_0/DDR_MC_PORT01/C0_DDR_CH0_LEGACY] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces psx_wizard_0/psxl_0_psx_cortexa78_3] [get_bd_addr_segs axi_noc_0/DDR_MC_PORT01/C0_DDR_CH0_LEGACY] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces psx_wizard_0/psxl_0_psx_cortexa78_4] [get_bd_addr_segs axi_noc_0/DDR_MC_PORT01/C0_DDR_CH0_LEGACY] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces psx_wizard_0/psxl_0_psx_cortexa78_5] [get_bd_addr_segs axi_noc_0/DDR_MC_PORT01/C0_DDR_CH0_LEGACY] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces psx_wizard_0/psxl_0_psx_cortexa78_6] [get_bd_addr_segs axi_noc_0/DDR_MC_PORT01/C0_DDR_CH0_LEGACY] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces psx_wizard_0/psxl_0_psx_cortexa78_7] [get_bd_addr_segs axi_noc_0/DDR_MC_PORT01/C0_DDR_CH0_LEGACY] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces psx_wizard_0/psxl_0_psx_cortexa78_8] [get_bd_addr_segs axi_noc_0/DDR_MC_PORT01/C0_DDR_CH0_LEGACY] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces psx_wizard_0/psxl_0_psx_cortexa78_9] [get_bd_addr_segs axi_noc_0/DDR_MC_PORT01/C0_DDR_CH0_LEGACY] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces psx_wizard_0/psxl_0_psx_cortexr52_0] [get_bd_addr_segs axi_noc_0/DDR_MC_PORT01/C0_DDR_CH0_LEGACY] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces psx_wizard_0/psxl_0_psx_cortexr52_1] [get_bd_addr_segs axi_noc_0/DDR_MC_PORT01/C0_DDR_CH0_LEGACY] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces psx_wizard_0/psxl_0_psx_cortexr52_2] [get_bd_addr_segs axi_noc_0/DDR_MC_PORT01/C0_DDR_CH0_LEGACY] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces psx_wizard_0/psxl_0_psx_cortexr52_3] [get_bd_addr_segs axi_noc_0/DDR_MC_PORT01/C0_DDR_CH0_LEGACY] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces psx_wizard_0/psxl_0_psx_dpc_0] [get_bd_addr_segs axi_noc_0/DDR_MC_PORT01/C0_DDR_CH0_LEGACY] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces psx_wizard_0/psxl_0_psx_lpd_dma_0] [get_bd_addr_segs axi_noc_0/DDR_MC_PORT01/C0_DDR_CH0_LEGACY] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces psx_wizard_0/psxl_0_psx_pmc_0] [get_bd_addr_segs axi_noc_0/DDR_MC_PORT01/C0_DDR_CH0_LEGACY] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces psx_wizard_0/psxl_0_psx_pmcx_dma_0] [get_bd_addr_segs axi_noc_0/DDR_MC_PORT01/C0_DDR_CH0_LEGACY] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces psx_wizard_0/psxl_0_psx_pmcx_dma_1] [get_bd_addr_segs axi_noc_0/DDR_MC_PORT01/C0_DDR_CH0_LEGACY] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces psx_wizard_0/psxl_0_psx_psm_0] [get_bd_addr_segs axi_noc_0/DDR_MC_PORT01/C0_DDR_CH0_LEGACY] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


