`timescale 1ns / 1ps

module FFT_top_TB(
);

parameter tclk = 20;

reg clk = 0;
reg rst = 1;
reg enable;
reg signed [15:0] xb_re;
reg signed [15:0] xb_im;
wire signed [15:0] Xb_re;
wire signed [15:0] Xb_im;

reg signed [15:0] test_data [1023:0];
reg signed [15:0] result_re [1023:0];
reg signed [15:0] result_im [1023:0];


integer i;

FFT_top uut (
	.clk(clk),
	.rst(rst),
	.enable(enable),
	.xb_re(xb_re),
	.xb_im(xb_im),
	.Xb_re(Xb_re),
	.Xb_im(Xb_im)
);

always #(tclk/2) clk = ~clk;

initial begin
	rst = 1;
	wait(clk == 1'b1);
	enable = 0;
	#100;
	xb_im = 0;
	$readmemh("sin_10.mem", test_data);
	rst = 0;
	enable = 1;
	for(i=0; i<1024; i=i+1) begin
		xb_re = test_data[i];
		//xb_re = 1;
		#tclk;
		enable = 0;
		#(tclk*10);
		enable = 1;

	end
    #(tclk * 10);
	for(i=0; i<1024; i=i+1) begin
		result_re[i] = Xb_re;
		result_im[i] = Xb_im;
		#tclk;
	end
	$writememh("output_re.mem", result_re);
	$writememh("output_im.mem", result_im);

	$finish;
end

endmodule
