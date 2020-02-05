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
    input CLK,
    input rst,
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
	output FT_RD_N
);

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

clk_wiz_0 ftpll (
    .FT_CLK(FT_CLK),
    .ftclk60(ftclk60)
);

xadc_wiz_0 our_XADC (
  .m_axis_tvalid(m_axis_tvalid),
  .m_axis_tready(1'b1),
  .m_axis_tdata(m_axis_tdata),
  .m_axis_aclk(CLK),
  .s_axis_aclk(CLK),
  .m_axis_resetn(rst),
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
	.enable(m_axis_tvalid),
	.xb_re({4'd0, m_axis_tdata[11:0]}),
	.xb_im(0),
	.Xb_re(out_re),
	.Xb_im(out_im)
);

Output_buffer outbf(
    .CLK(CLK),
    .usbCLK(ftclk60),
    .reset(rst),
    .enable(m_axis_tvalid),
    .data_in_re(out_re),
    .data_in_im(out_im),
    .data_out(usb_data_out),
    .data_valid(usb_data_valid),
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
	.rstn(rst),
	.data_in(usb_data_out),
	.in_DV(usb_data_valid),
	.din_rd(data_rd),
	.pause_rcv(1)
);

endmodule

