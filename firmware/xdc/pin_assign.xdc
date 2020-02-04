# Clock Signal
set_property -dict { PACKAGE_PIN R4    IOSTANDARD LVCMOS33 } [get_ports { CLK }]; #IO_L13P_T2_MRCC_34 Sch=sysclk
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports CLK]
set_property -dict { PACKAGE_PIN E22  IOSTANDARD LVCMOS12 } [get_ports { rst }]; #IO_L22P_T3_16 Sch=sw[0]


## XADC Header
set_property -dict { PACKAGE_PIN J14   IOSTANDARD LVCMOS33 } [get_ports { noise_p }]; #IO_L3P_T0_DQS_AD1P_15 Sch=xa_p[1]
set_property -dict { PACKAGE_PIN H14   IOSTANDARD LVCMOS33 } [get_ports { noise_n }]; #IO_L3N_T0_DQS_AD1N_15 Sch=xa_n[1]