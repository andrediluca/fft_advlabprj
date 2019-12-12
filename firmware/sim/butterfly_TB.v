`timescale 1ns / 1ps

module butterfly_TB(
);

reg clk = 0;
reg enable = 0;
reg signed [15:0] xa_re;
reg signed [15:0] xa_im;
reg signed [15:0] xb_re;
reg signed [15:0] xb_im;
reg signed [15:0] W_re;
reg signed [15:0] W_im;
wire signed [15:0] Xa_re;
wire signed [15:0] Xa_im;
wire signed [15:0] Xb_re;
wire signed [15:0] Xb_im;

butterfly uut(
	.clk(clk),
	.enable(enable),
	.xa_re(xa_re),
	.xa_im(xa_im),
	.xb_re(xb_re),
	.xb_im(xb_im),
	.W_re(W_re),
	.W_im(W_im),
	.Xa_re(Xa_re),
	.Xa_im(Xa_im),
	.Xb_re(Xb_re),
	.Xb_im(Xb_im)
);


always #10 clk = ~clk;

always begin

	#100;
	enable <= 1'b1;
	xa_re <= 1;
	xa_im <= 0;
	xb_re <= 3;
	xb_im <= 0;
	W_re  <= 2;
	W_im  <= 0;

end






endmodule
