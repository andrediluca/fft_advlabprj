############################## Setup project ####################################
set prj_name "FFT_spctr"
set root_dir [file dirname [info script]]
set prj_dir "${root_dir}/${prj_name}"
create_project $prj_name $prj_dir -part xc7a200tsbg484-1
set_property board_part digilentinc.com:nexys_video:part0:1.1 [current_project]
set_property target_language VHDL [current_project]

############################# Load sources #####################################
add_files -fileset sources_1 "${root_dir}/src/"
#set top_name "FFT_"
add_files -fileset constrs_1 "${root_dir}/xdc/"
add_files -fileset sim_1 "${root_dir}/sim/"
set_property file_type Verilog [get_files -of [get_filesets [list sources_1 sim_1]]]
update_compile_order -fileset sources_1

create_ip -name clk_wiz -vendor xilinx.com -library ip -version 6.0 -module_name clk_wiz_0
set_property -dict [list \
	CONFIG.USE_FREQ_SYNTH {false} \
	CONFIG.PRIM_IN_FREQ {60} \
	CONFIG.PRIMARY_PORT {FT_CLK} \
	CONFIG.CLK_OUT1_PORT {ftclk60} \
	CONFIG.USE_LOCKED {false} \
	CONFIG.USE_RESET {false} \
	CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {60}] \
	[get_ips clk_wiz_0]

create_ip -name clk_wiz -vendor xilinx.com -library ip -version 6.0 -module_name clk_wiz_1
set_property -dict [list \
	CONFIG.PRIMITIVE {PLL} \
	CONFIG.CLK_IN1_BOARD_INTERFACE {sys_clock} \
	CONFIG.CLK_OUT1_PORT {clk50} \
	CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {50} \
	CONFIG.USE_LOCKED {false} \
	CONFIG.USE_RESET {false} \
	CONFIG.MMCM_DIVCLK_DIVIDE {2} \
	CONFIG.MMCM_CLKFBOUT_MULT_F {17} \
	CONFIG.MMCM_COMPENSATION {ZHOLD} \
	CONFIG.MMCM_CLKOUT0_DIVIDE_F {17}] \
	[get_ips clk_wiz_1]

create_ip -name fifo_generator -vendor xilinx.com -library ip -version 13.2 -module_name out_buffer
set_property -dict [list \
	CONFIG.Fifo_Implementation {Independent_Clocks_Block_RAM} \
	CONFIG.Performance_Options {First_Word_Fall_Through} \
	CONFIG.Input_Data_Width {32} \
	CONFIG.Output_Data_Width {8} \
	CONFIG.Output_Depth {4096} \
	CONFIG.Reset_Type {Asynchronous_Reset} \
	CONFIG.Full_Flags_Reset_Value {1} \
	CONFIG.Read_Data_Count_Width {12}] \
	[get_ips out_buffer]

create_ip -name xadc_wiz -vendor xilinx.com -library ip -version 3.3 -module_name xadc_wiz_0
set_property -dict [list \
	CONFIG.INTERFACE_SELECTION {None} \
	CONFIG.ENABLE_AXI4STREAM {true} \
	CONFIG.ADC_CONVERSION_RATE {48} \
	CONFIG.ENABLE_RESET {true} \
	CONFIG.OT_ALARM {false} \
	CONFIG.USER_TEMP_ALARM {false} \
	CONFIG.VCCINT_ALARM {false} \
	CONFIG.VCCAUX_ALARM {false} \
	CONFIG.SINGLE_CHANNEL_SELECTION {VAUXP0_VAUXN0} \
	CONFIG.BIPOLAR_OPERATION {true}] \
	[get_ips xadc_wiz_0]
