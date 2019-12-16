`timescale 1ns / 1ps

module delay_TB(
);

parameter tclk = 20;

reg clk = 0;
reg enable = 0;
reg signed [15:0] x_in_re;
reg signed [15:0] x_in_im;
wire signed [15:0] x_out_re;
wire signed [15:0] x_out_im;


// unit under test
delay #(.delay_len(30)) uut(
	.clk(clk),
	.enable(enable),
	.x_in_re(x_in_re),
	.x_in_im(x_in_im),
	.x_out_re(x_out_re),
	.x_out_im(x_out_im)
);


always #(tclk/2) clk = ~clk;

always begin

	// TODO: more comprehensive testing
	#100;
	enable <= 1'b1;
	x_in_re <= 2;
	x_in_im <= 1;
	#(tclk)
	x_in_re <= 0;
	x_in_im <= 0;
	#(30 * tclk)
	if (x_in_re != x_out_re )
		$error(" Real part not equal");
	if (x_in_im != x_out_im )
		$error(" Im part not equal");
end

endmodule
