#create_clock -period 5 -name sys_clk [get_ports sys_clk_p]
#set_propagated_clock sys_clk_p

#create_clock -period 10.0 [get_ports sys_clk_p]
#set_input_jitter [get_clocks -of_objects [get_ports sys_clk_p]] 0.1

# Note: the following CLOCK_DEDICATED_ROUTE constraint will cause a warning in place similar
# to the following:
#   WARNING:Place:1402 - A clock IOB / PLL clock component pair have been found that are not
#   placed at an optimal clock IOB / PLL site pair.
# This warning can be ignored.  See the Users Guide for more information.

#set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets sys_clk_p]
#set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_pins -hierarchical *pll*CLKIN1]

set_property VCCAUX_IO DONTCARE [get_ports sys_clk_p]
set_property IOSTANDARD LVDS [get_ports sys_clk_p]
set_property LOC AD12 [get_ports sys_clk_p]

set_property VCCAUX_IO DONTCARE [get_ports sys_clk_n]
set_property IOSTANDARD LVDS [get_ports sys_clk_n]
set_property LOC AD11 [get_ports sys_clk_n]

set_property IOSTANDARD LVCMOS25 [get_ports uart_tx]
set_property LOC K24 [get_ports uart_tx]
set_property IOSTANDARD LVCMOS25 [get_ports uart_rx]
set_property LOC M19 [get_ports uart_rx]
set_property IOSTANDARD LVCMOS25 [get_ports uart_rts]
set_property LOC L27 [get_ports uart_rts]
set_property IOSTANDARD LVCMOS25 [get_ports uart_cts]
set_property LOC K23 [get_ports uart_cts]

set_property IOSTANDARD LVCMOS25 [get_ports GPIO_SW_C]
set_property LOC G12 [get_ports GPIO_SW_C]
set_property IOSTANDARD LVCMOS15 [get_ports GPIO_SW_N]
set_property LOC AA12 [get_ports GPIO_SW_N]
set_property IOSTANDARD LVCMOS15 [get_ports GPIO_SW_E]
set_property LOC AG5 [get_ports GPIO_SW_E]
set_property IOSTANDARD LVCMOS15 [get_ports GPIO_SW_S]
set_property LOC AB12 [get_ports GPIO_SW_S]
set_property IOSTANDARD LVCMOS15 [get_ports GPIO_SW_W]
set_property LOC AC6 [get_ports GPIO_SW_W]
set_property IOSTANDARD LVCMOS15 [get_ports reset]
set_property LOC AB7 [get_ports reset]

set_property -dict { PACKAGE_PIN Y29    IOSTANDARD LVCMOS25 } [get_ports { sw[0] }]; 
set_property -dict { PACKAGE_PIN W29    IOSTANDARD LVCMOS25 } [get_ports { sw[1] }];
set_property -dict { PACKAGE_PIN AA28   IOSTANDARD LVCMOS25 } [get_ports { sw[2] }];
set_property -dict { PACKAGE_PIN Y28    IOSTANDARD LVCMOS25 } [get_ports { sw[3] }];

#-------------------------------------
# LED Status Pinout   (bottom to top)
#-------------------------------------
set_property IOSTANDARD LVCMOS15 [get_ports {led[0]}]
set_property SLEW SLOW [get_ports {led[0]}]
set_property DRIVE 4 [get_ports {led[0]}]
set_property LOC AB8 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS15 [get_ports {led[1]}]
set_property SLEW SLOW [get_ports {led[1]}]
set_property DRIVE 4 [get_ports {led[1]}]
set_property LOC AA8 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS15 [get_ports {led[2]}]
set_property SLEW SLOW [get_ports {led[2]}]
set_property DRIVE 4 [get_ports {led[2]}]
set_property LOC AC9 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS15 [get_ports {led[3]}]
set_property SLEW SLOW [get_ports {led[3]}]
set_property DRIVE 4 [get_ports {led[3]}]
set_property LOC AB9 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS25 [get_ports {led[4]}]
set_property SLEW SLOW [get_ports {led[4]}]
set_property DRIVE 4 [get_ports {led[4]}]
set_property LOC AE26 [get_ports {led[4]}]
set_property IOSTANDARD LVCMOS25 [get_ports {led[5]}]
set_property SLEW SLOW [get_ports {led[5]}]
set_property DRIVE 4 [get_ports {led[5]}]
set_property LOC G19 [get_ports {led[5]}]
set_property IOSTANDARD LVCMOS25 [get_ports {led[6]}]
set_property SLEW SLOW [get_ports {led[6]}]
set_property DRIVE 4 [get_ports {led[6]}]
set_property LOC E18 [get_ports {led[6]}]
set_property IOSTANDARD LVCMOS25 [get_ports {led[7]}]
set_property SLEW SLOW [get_ports {led[7]}]
set_property DRIVE 4 [get_ports {led[7]}]
set_property LOC F16 [get_ports {led[7]}]