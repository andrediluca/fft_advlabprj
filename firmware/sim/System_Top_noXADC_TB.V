`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.02.2020 09:32:23
// Design Name: 
// Module Name: System_Top_TB
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


module System_Top_noXADC_TB(

    );
    
    parameter t_sysCLK = 10;
    parameter t_FT_CLK = 16;
    
    reg sysCLK = 0;
    reg rst = 1;
    reg data_valid = 1;
    reg enable_sw;
    reg FT_CLK = 0;
	wire [7:0] FT_DATA;
	reg FT_RXF_N = 1;
	reg FT_TXE_N = 1;
	wire FT_OE_N;
	wire FT_WR_N;
	wire FT_RD_N;
	
	reg signed [7:0] test_data [1023:0];
	reg signed [11:0] data_in;
    integer i;

    System_Top_noXADC uut(
    .sysCLK(sysCLK),
    .rst(rst),
    .enable_sw(enable_sw),
    .data(data_in),
    .data_valid(data_valid),
	.FT_CLK(FT_CLK),
	.FT_DATA(FT_DATA),
	.FT_RXF_N(FT_RXF_N),
	.FT_TXE_N(FT_TXE_N),
	.FT_OE_N(FT_OE_N),
	.FT_WR_N(FT_WR_N),
	.FT_RD_N(FT_RD_N),
	.SIWU_N()
);
always #(t_sysCLK/2) sysCLK = ~sysCLK;
always #(t_FT_CLK/2) FT_CLK = ~FT_CLK;
initial begin
    #(200 * t_sysCLK)
	rst = 1;
	enable_sw = 1;
    rst = 0;
    FT_RXF_N = 0;
	FT_TXE_N = 0;
	
	$readmemh("sin_10_8bit.mem", test_data);
	for(i=0; i<1024; i=i+1) begin
		data_in = test_data[i];
		#t_sysCLK;
	end

end

endmodule
