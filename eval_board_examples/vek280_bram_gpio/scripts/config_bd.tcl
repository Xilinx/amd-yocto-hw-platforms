# Copyright (C) 2024, Advanced Micro Devices, Inc.
# SPDX-License-Identifier: Apache-2.0

proc create_project_1 { parentCell nameHier } {

set parentObj [get_bd_cells $parentCell]

set oldCurInst [current_bd_instance .]

current_bd_instance $parentObj

if {$nameHier ne "" } {

set hier_obj [create_bd_cell -type hier $nameHier]

current_bd_instance $hier_obj

}

set versal_cips_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:versal_cips versal_cips_0 ]

apply_bd_automation -rule xilinx.com:bd_rule:cips -config { board_preset {Yes} boot_config {Custom} configure_noc {Add new AXI NoC} debug_config {JTAG} design_flow {Full System} mc_type {LPDDR} num_mc_ddr {None} num_mc_lpddr {2} pl_clocks {None} pl_resets {None}}  [get_bd_cells versal_cips_0]

set_property -dict [list \
    CONFIG.CLOCK_MODE {Custom} \
    CONFIG.PS_PMC_CONFIG { \
    CLOCK_MODE {Custom} \
    DDR_MEMORY_MODE {Connectivity to DDR via NOC} \
    DEBUG_MODE {JTAG} \
    DESIGN_MODE {1} \
    DEVICE_INTEGRITY_MODE {Sysmon temperature voltage and external IO monitoring} \
    IO_CONFIG_MODE {Custom} \
    PMC_CRP_PL0_REF_CTRL_FREQMHZ {100} \
    PMC_GPIO0_MIO_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 0 .. 25}}} \
    PMC_GPIO1_MIO_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 26 .. 51}}} \
    PMC_MIO12 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
    PMC_MIO37 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA high} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
    PMC_MIO38 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA high} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
    PMC_OSPI_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 0 .. 11}} {MODE Single}} \
    PMC_REF_CLK_FREQMHZ {33.3333} \
    PMC_SD1 {{CD_ENABLE 1} {CD_IO {PMC_MIO 28}} {POW_ENABLE 1} {POW_IO {PMC_MIO 51}} {RESET_ENABLE 0} {RESET_IO {PMC_MIO 12}} {WP_ENABLE 0} {WP_IO {PMC_MIO 1}}} \
    PMC_SD1_PERIPHERAL {{CLK_100_SDR_OTAP_DLY 0x3} {CLK_200_SDR_OTAP_DLY 0x2} {CLK_50_DDR_ITAP_DLY 0x36} {CLK_50_DDR_OTAP_DLY 0x3} {CLK_50_SDR_ITAP_DLY 0x2C} {CLK_50_SDR_OTAP_DLY 0x4} {ENABLE 1} {IO {PMC_MIO 26 .. 36}}} \
    PMC_SD1_SLOT_TYPE {SD 3.0} \
    PMC_USE_PMC_NOC_AXI0 {1} \
    PS_BOARD_INTERFACE {ps_pmc_fixed_io} \
    PS_CAN0_PERIPHERAL {{ENABLE 1} {IO {PS_MIO 14 .. 15}}} \
    PS_CAN1_PERIPHERAL {{ENABLE 1} {IO {PS_MIO 16 .. 17}}} \
    PS_CRL_CAN0_REF_CTRL_FREQMHZ {160} \
    PS_CRL_CAN1_REF_CTRL_FREQMHZ {160} \
    PS_ENET0_MDIO {{ENABLE 1} {IO {PS_MIO 24 .. 25}}} \
    PS_ENET0_PERIPHERAL {{ENABLE 1} {IO {PS_MIO 0 .. 11}}} \
    PS_GEN_IPI0_ENABLE {1} \
    PS_GEN_IPI0_MASTER {A72} \
    PS_GEN_IPI1_ENABLE {1} \
    PS_GEN_IPI1_MASTER {R5_0} \
    PS_GEN_IPI2_ENABLE {1} \
    PS_GEN_IPI2_MASTER {R5_1} \
    PS_GEN_IPI3_ENABLE {1} \
    PS_GEN_IPI4_ENABLE {1} \
    PS_GEN_IPI5_ENABLE {1} \
    PS_GEN_IPI6_ENABLE {1} \
    PS_GPIO_EMIO_PERIPHERAL_ENABLE {0} \
    PS_HSDP_EGRESS_TRAFFIC {JTAG} \
    PS_HSDP_INGRESS_TRAFFIC {JTAG} \
    PS_HSDP_MODE {NONE} \
    PS_I2C0_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 46 .. 47}}} \
    PS_I2C1_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 44 .. 45}}} \
    PS_I2CSYSMON_PERIPHERAL {{ENABLE 0} {IO {PMC_MIO 39 .. 40}}} \
    PS_MIO7 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL disable} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
    PS_MIO9 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL disable} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
    PS_NUM_FABRIC_RESETS {1} \
    PS_PCIE_EP_RESET1_IO {PS_MIO 18} \
    PS_PCIE_EP_RESET2_IO {PS_MIO 19} \
    PS_PCIE_RESET {ENABLE 1} \
    PS_TTC0_PERIPHERAL_ENABLE {1} \
    PS_TTC1_PERIPHERAL_ENABLE {1} \
    PS_TTC2_PERIPHERAL_ENABLE {1} \
    PS_TTC3_PERIPHERAL_ENABLE {1} \
    PS_UART0_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 42 .. 43}}} \
    PS_USB3_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 13 .. 25}}} \
    PS_USE_FPD_AXI_NOC0 {1} \
    PS_USE_FPD_AXI_NOC1 {1} \
    PS_USE_FPD_CCI_NOC {1} \
    PS_USE_FPD_CCI_NOC0 {1} \
    PS_USE_NOC_LPD_AXI0 {1} \
    PS_USE_PMCPL_CLK0 {1} \
    PS_USE_PMCPL_CLK1 {0} \
    PS_USE_PMCPL_CLK2 {0} \
    PS_USE_PMCPL_CLK3 {0} \
    SMON_ALARMS {Set_Alarms_On} \
    SMON_ENABLE_TEMP_AVERAGING {0} \
    SMON_INTERFACE_TO_USE {I2C} \
    SMON_PMBUS_ADDRESS {0x18} \
    SMON_TEMP_AVERAGING_SAMPLES {0} \
  } \
] [get_bd_cells versal_cips_0]


set_property -dict [list \
    CONFIG.NUM_CLKS {8} \
    CONFIG.NUM_SI {8} \
] [get_bd_cells axi_noc_0]

set_property -dict [list CONFIG.CONNECTIONS {MC_3 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}}] [get_bd_intf_pins /axi_noc_0/S00_AXI]
set_property -dict [list CONFIG.CONNECTIONS {MC_2 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}}] [get_bd_intf_pins /axi_noc_0/S01_AXI]
set_property -dict [list CONFIG.CONNECTIONS {MC_0 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}}] [get_bd_intf_pins /axi_noc_0/S02_AXI]
set_property -dict [list CONFIG.CONNECTIONS {MC_1 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}}] [get_bd_intf_pins /axi_noc_0/S03_AXI]
set_property -dict [list CONFIG.CONNECTIONS {MC_3 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}}] [get_bd_intf_pins /axi_noc_0/S04_AXI]
set_property -dict [list CONFIG.CONNECTIONS {MC_2 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}}] [get_bd_intf_pins /axi_noc_0/S05_AXI]
set_property -dict [list CONFIG.CATEGORY {ps_nci} CONFIG.CONNECTIONS {MC_0 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}}] [get_bd_intf_pins /axi_noc_0/S06_AXI]
set_property -dict [list CONFIG.CATEGORY {ps_nci} CONFIG.CONNECTIONS {MC_0 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}}] [get_bd_intf_pins /axi_noc_0/S07_AXI]

connect_bd_intf_net [get_bd_intf_pins versal_cips_0/FPD_AXI_NOC_0] [get_bd_intf_pins axi_noc_0/S06_AXI]
connect_bd_intf_net [get_bd_intf_pins versal_cips_0/FPD_AXI_NOC_1] [get_bd_intf_pins axi_noc_0/S07_AXI]
connect_bd_net [get_bd_pins versal_cips_0/fpd_axi_noc_axi0_clk] [get_bd_pins axi_noc_0/aclk6]
connect_bd_net [get_bd_pins versal_cips_0/fpd_axi_noc_axi1_clk] [get_bd_pins axi_noc_0/aclk7]


create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/versal_cips_0/fpd_axi_noc_axi0_clk (799 MHz)} Clk_slave {Auto} Clk_xbar {Auto} Master {/versal_cips_0/FPD_AXI_NOC_0} Slave {/axi_gpio_0/S_AXI} ddr_seg {Auto} intc_ip {/axi_noc_0} master_apm {0}}  [get_bd_intf_pins axi_gpio_0/S_AXI]

apply_bd_automation -rule xilinx.com:bd_rule:board -config { Board_Interface {gpio_led ( GPIO LED ) } Manual_Source {Auto}}  [get_bd_intf_pins axi_gpio_0/GPIO]
connect_bd_net [get_bd_pins versal_cips_0/pl0_resetn] [get_bd_pins rst_versal_cips_0_99M/ext_reset_in]
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0
apply_bd_automation -rule xilinx.com:bd_rule:bram_cntlr -config {BRAM "Auto" }  [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA]
apply_bd_automation -rule xilinx.com:bd_rule:bram_cntlr -config {BRAM "Auto" }  [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTB]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/versal_cips_0/fpd_axi_noc_axi0_clk (799 MHz)} Clk_slave {Auto} Clk_xbar {Auto} Master {/versal_cips_0/FPD_AXI_NOC_0} Slave {/axi_bram_ctrl_0/S_AXI} ddr_seg {Auto} intc_ip {/axi_noc_0} master_apm {0}}  [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]

#segmented configuration

set_property -dict [list CONFIG.CONNECTIONS {MC_3 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4} initial_boot {true}}}] [get_bd_intf_pins /axi_noc_0/S00_AXI]
set_property -dict [list CONFIG.CONNECTIONS {MC_2 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4} initial_boot {true}}}] [get_bd_intf_pins /axi_noc_0/S01_AXI]
set_property -dict [list CONFIG.CONNECTIONS {MC_0 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4} initial_boot {true}}}] [get_bd_intf_pins /axi_noc_0/S02_AXI]
set_property -dict [list CONFIG.CONNECTIONS {MC_1 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4} initial_boot {true}}}] [get_bd_intf_pins /axi_noc_0/S03_AXI]
set_property -dict [list CONFIG.CONNECTIONS {MC_3 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4} initial_boot {true}}}] [get_bd_intf_pins /axi_noc_0/S04_AXI]
set_property -dict [list CONFIG.CONNECTIONS {MC_2 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4} initial_boot {true}}}] [get_bd_intf_pins /axi_noc_0/S05_AXI]
set_property -dict [list CONFIG.CONNECTIONS {MC_0 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4} initial_boot {true}} M01_AXI {read_bw {5} write_bw {5} initial_boot {false}} M00_AXI {read_bw {5} write_bw {5} initial_boot {false}}}] [get_bd_intf_pins /axi_noc_0/S06_AXI]
set_property -dict [list CONFIG.CONNECTIONS {MC_0 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4} initial_boot {true}}}] [get_bd_intf_pins /axi_noc_0/S07_AXI]


current_bd_instance $oldCurInst
}

create_project_1 "" ""
