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
    input noisep,
    input noisen
    );

wire m_axis_tvalid;
wire m_axis_tready;
wire [15 : 0] m_axis_tdata;
wire m_axis_aclk;
wire s_axis_aclk;
wire m_axis_resetn;
wire [15 : 0] di_in;
wire dwe_in;
wire drdy_out;
wire [15 : 0] do_out;
wire vauxp0;
wire vauxn0;
wire eoc_out;
wire [4 : 0] channel_out;

xadc_wiz_0 our_XADC (
  .m_axis_tvalid(m_axis_tvalid),  // output wire m_axis_tvalid
  .m_axis_tready(m_axis_tready),  // input wire m_axis_tready
  .m_axis_tdata(m_axis_tdata),    // output wire [15 : 0] m_axis_tdata
  .m_axis_aclk(m_axis_aclk),      // input wire m_axis_aclk
  .s_axis_aclk(s_axis_aclk),      // input wire s_axis_aclk
  .m_axis_resetn(m_axis_resetn),  // input wire m_axis_resetn
  .di_in(di_in),                  // input wire [15 : 0] di_in
  .daddr_in(channel_out),            // input wire [6 : 0] daddr_in
  .den_in(eoc_out),                // input wire den_in
  .dwe_in(dwe_in),                // input wire dwe_in
  .drdy_out(drdy_out),            // output wire drdy_out
  .do_out(do_out),                // output wire [15 : 0] do_out
  .eoc_out(eoc_out),              // output wire 
  .channel_out(channel_out),      // output wire [4 : 0] channel_out              
  .vauxp0(noisep),                // input wire vauxp0
  .vauxn0(noisen)               // input wire vauxn0
 
);

endmodule

