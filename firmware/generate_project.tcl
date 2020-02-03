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
