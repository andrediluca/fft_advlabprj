`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2020 03:51:27 PM
// Design Name: 
// Module Name: Output_buffer
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


module Output_buffer(
    input CLK,
    input usbCLK,
    input reset,
    input enable,
    input[15:0] data_in_re,
    input[15:0] data_in_im,
    output [7:0] data_out,
    output data_valid,
    output buff_full,
    input data_rd
    );

integer counter_USB = 0;
reg counter_done=0;
(* mark_debug = "true" *)reg [31:0] buff_data_in;
(* mark_debug = "true" *)reg buff_data_in_valid;
wire buff_empty;

//conveter
wire [31:0] s_conv_tdata;
wire s_conv_tready, s_conv_tvalid;

always @(posedge CLK) begin

    if (enable==1) begin
        //1024 + 10
        if(counter_USB>1032)
            counter_done<=1;
        
        else 
            counter_USB<=counter_USB+1;
    
    end 
    
    if (reset==1) begin
        counter_USB<=0;
        counter_done<=0;
    end
        
end  
 
always @(posedge CLK) begin
    
    buff_data_in_valid<=0;
    
    if (counter_done==1 && enable==1) begin
        buff_data_in_valid<=1;
        buff_data_in<={data_in_re, data_in_im};
    end
end 
 
out_buffer buff (
  .rst(reset),                // input wire rst
  .wr_clk(CLK),               // input wire wr_clk
  .rd_clk(usbCLK),            // input wire rd_clk
  .din(buff_data_in),         // input wire [31 : 0] din
  .wr_en(buff_data_in_valid), // input wire wr_en
  .rd_en(s_conv_tready),      // input wire rd_en
  .dout(s_conv_tdata),        // output wire [7 : 0] dout
  .full(buff_full),           // output wire full
  .empty(buff_empty)          // output wire empty
  //.wr_rst_busy(data_out),   // output wire wr_rst_busy
  //.rd_rst_busy(rd_rst_busy) // output wire rd_rst_busy
);
assign s_conv_tvalid = ~buff_empty;

axis_dwidth_converter width_converter (
  .aclk(usbCLK),
  .aresetn(~reset),
  .s_axis_tvalid(s_conv_tvalid),
  .s_axis_tready(s_conv_tready),
  .s_axis_tdata(s_conv_tdata),
  .m_axis_tvalid(data_valid),
  .m_axis_tready(data_rd),
  .m_axis_tdata(data_out)
);

endmodule
