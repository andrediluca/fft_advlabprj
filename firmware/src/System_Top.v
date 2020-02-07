`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.01.2020 10:13:15
// Design Name: 
// Module Name: System_Top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module System_Top(
    input sysCLK,
    input rst,
    input enable_sw,
    //input noise_p,
    //input noise_n,
    input vp_in,
    input vn_in,
	input FT_CLK,
	inout [7:0] FT_DATA,
	input FT_RXF_N,
	input FT_TXE_N,
	output FT_OE_N,
	output FT_WR_N,
	output FT_RD_N,
	output SIWU_N
);

assign SIWU_N = 1; //aaaaaaaaaaaaa

wire m_axis_tvalid;
wire [15:0] m_axis_tdata;
wire m_axis_resetn;
wire vauxp0;
wire vauxn0;
wire eoc_out;
wire [4:0] channel_out;

wire ftclk60;
wire [15:0] out_re, out_im;
wire [7:0] usb_data_out;
wire usb_data_valid, data_rd;

wire enable, fft_enable;
assign enable = ~buff_full & enable_sw;
assign fft_enable = m_axis_tvalid & enable;
wire n_rst;
assign n_rst = ~ rst;

clk_wiz_0 ftpll (
    .FT_CLK(FT_CLK),
    .ftclk60(ftclk60)
);

clk_wiz_1 syspll (
    .clk_in1(sysCLK),
    .clk50(CLK)
);


xadc_wiz_0 our_XADC (
  .m_axis_tvalid(m_axis_tvalid),
  .m_axis_tready(enable),
  .m_axis_tdata(m_axis_tdata),
  .m_axis_aclk(CLK),
  .s_axis_aclk(CLK),
  .m_axis_resetn(n_rst),
  .eoc_out(eoc_out),
  .channel_out(channel_out),
  .vp_in(vp_in),
  .vn_in(vn_in)
  //.vauxp0(noise_p),
  //.vauxn0(noise_n)
 
);

FFT_top FFT_core (
	.clk(CLK),
	.rst(rst),
	.enable(fft_enable),
	.xb_re({4'd0, m_axis_tdata[11:0]}),
	.xb_im(0),
	.Xb_re(out_re),
	.Xb_im(out_im)
);

Output_buffer outbf(
    .CLK(CLK),
    .usbCLK(ftclk60),
    .reset(rst),
    .enable(fft_enable),
    .data_in_re(out_re),
    .data_in_im(out_im),
    .data_out(usb_data_out),
    .data_valid(usb_data_valid),
    .buff_full(buff_full),
    .data_rd(data_rd)
);

FTDI_mFIFO usb_out (
	.CLK(ftclk60),
	.DATA(FT_DATA),
	.RXF_N(FT_RXF_N),
	.TXE_N(FT_TXE_N),
	.OE_N(FT_OE_N),
	.RD_N(FT_RD_N),
	.WR_N(FT_WR_N),
	// internal iface
	.rstn(n_rst),
	.data_in(usb_data_out),
	.in_DV(usb_data_valid),
	.din_rd(data_rd),
	.pause_rcv(1)
);

endmodule

