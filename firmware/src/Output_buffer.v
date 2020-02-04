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
    input reset,
    input enable,
    input[15:0] data_in_re,
    input[15:0] data_in_im,
    output reg[31:0] data_out,
    output reg data_valid
    );

integer counter_USB = 0;
reg counter_done=0;

always @(posedge CLK) begin

    if (enable==1) begin
    
        if(counter_USB>1024)
            counter_done<=1;
        
        else 
            counter_USB<=counter_USB+1;
    
    end 
    
    if (reset==0) begin
        counter_USB<=0;
        counter_done<=0;
    end
        
end  
 
always @(posedge CLK) begin
    
    data_valid<=0;
    
    if (counter_done==1 && enable==1) begin
        data_valid<=1;
        data_out<={data_in_re, data_in_im};
    end
end 
 
    
endmodule
