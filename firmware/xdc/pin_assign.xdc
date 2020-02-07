# Clock Signal
set_property -dict {PACKAGE_PIN R4 IOSTANDARD LVCMOS33} [get_ports sysCLK]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports sysCLK]
set_property -dict {PACKAGE_PIN E22 IOSTANDARD LVCMOS12} [get_ports rst]
set_property -dict {PACKAGE_PIN F21 IOSTANDARD LVCMOS12} [get_ports enable_sw]

## XADC Header
#set_property -dict { PACKAGE_PIN J14   IOSTANDARD LVCMOS33 } [get_ports { noise_p }]; #IO_L3P_T0_DQS_AD1P_15 Sch=xa_p[1]
#set_property -dict { PACKAGE_PIN H14   IOSTANDARD LVCMOS33 } [get_ports { noise_n }]; #IO_L3N_T0_DQS_AD1N_15 Sch=xa_n[1]

# FT2232 USB
set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33} [get_ports FT_CLK]
set_property -dict {PACKAGE_PIN U20 IOSTANDARD LVCMOS33} [get_ports {FT_DATA[0]}]
set_property -dict {PACKAGE_PIN P14 IOSTANDARD LVCMOS33} [get_ports {FT_DATA[1]}]
set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS33} [get_ports {FT_DATA[2]}]
set_property -dict {PACKAGE_PIN U17 IOSTANDARD LVCMOS33} [get_ports {FT_DATA[3]}]
set_property -dict {PACKAGE_PIN R17 IOSTANDARD LVCMOS33} [get_ports {FT_DATA[4]}]
set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS33} [get_ports {FT_DATA[5]}]
set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS33} [get_ports {FT_DATA[6]}]
set_property -dict {PACKAGE_PIN N14 IOSTANDARD LVCMOS33} [get_ports {FT_DATA[7]}]
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports FT_OE_N]
set_property -dict {PACKAGE_PIN P19 IOSTANDARD LVCMOS33} [get_ports FT_RD_N]
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33} [get_ports FT_RXF_N]
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports SIWU_N]
set_property -dict {PACKAGE_PIN Y19 IOSTANDARD LVCMOS33} [get_ports FT_TXE_N]
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS33} [get_ports FT_WR_N]

set_output_delay -clock [get_clocks [get_clocks -of_object [get_ports FT_CLK]]] -min -add_delay 0.000 [get_ports {FT_DATA[*]}]
set_output_delay -clock [get_clocks [get_clocks -of_object [get_ports FT_CLK]]] -max -add_delay 8.000 [get_ports {FT_DATA[*]}]
set_output_delay -clock [get_clocks [get_clocks -of_object [get_ports FT_CLK]]] -min -add_delay 0.000 [get_ports FT_OE_N]
set_output_delay -clock [get_clocks [get_clocks -of_object [get_ports FT_CLK]]] -max -add_delay 8.000 [get_ports FT_OE_N]
set_output_delay -clock [get_clocks [get_clocks -of_object [get_ports FT_CLK]]] -min -add_delay 0.000 [get_ports FT_RD_N]
set_output_delay -clock [get_clocks [get_clocks -of_object [get_ports FT_CLK]]] -max -add_delay 8.000 [get_ports FT_RD_N]
set_output_delay -clock [get_clocks [get_clocks -of_object [get_ports FT_CLK]]] -min -add_delay 0.000 [get_ports FT_WR_N]
set_output_delay -clock [get_clocks [get_clocks -of_object [get_ports FT_CLK]]] -max -add_delay 8.000 [get_ports FT_WR_N]
set_input_delay -clock [get_clocks [get_clocks -of_object [get_ports FT_CLK]]] -min -add_delay -1.000 [get_ports {FT_DATA[*]}]
set_input_delay -clock [get_clocks [get_clocks -of_object [get_ports FT_CLK]]] -max -add_delay 7.150 [get_ports {FT_DATA[*]}]
set_input_delay -clock [get_clocks [get_clocks -of_object [get_ports FT_CLK]]] -min -add_delay -1.000 [get_ports FT_RXF_N]
set_input_delay -clock [get_clocks [get_clocks -of_object [get_ports FT_CLK]]] -max -add_delay 7.150 [get_ports FT_RXF_N]
set_input_delay -clock [get_clocks [get_clocks -of_object [get_ports FT_CLK]]] -min -add_delay -1.000 [get_ports FT_TXE_N]
set_input_delay -clock [get_clocks [get_clocks -of_object [get_ports FT_CLK]]] -max -add_delay 7.150 [get_ports FT_TXE_N]


