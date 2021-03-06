/********************************************
* Butterfly computation
* the output is registered and so is delayed
* of 1-clk cycle
********************************************/

module butterfly(
	// control signals
	input wire clk,
	input wire enable,
	// input data
	input wire signed [15:0] xa_re, // real part of a
	input wire signed [15:0] xa_im, // im part of b
	input wire signed [15:0] xb_re,
	input wire signed [15:0] xb_im,
	input wire signed [15:0] W_re,  // real part of twiddle from ROM
	input wire signed [15:0] W_im,  // im part of twiddle from ROM
	// output data
	output reg signed [15:0] Xa_re,
	output reg signed [15:0] Xa_im,
	output reg signed [15:0] Xb_re,
	output reg signed [15:0] Xb_im
);


function signed [15:0] adder;
	/*******************************
	* Function to set fixed value for
	* overflow or underflow case
	*********************************/
	input reg signed [15:0] a;
	input reg signed [15:0] b;
	input op;
	reg signed [16:0] res;

	begin
		if (op == 1'b0) begin
			res = a+b;
		end else begin
			res = a-b;
		end

		if (res[16:15] == 2'b01) begin
			res = 2**15-1;
		end else if (res[16:15] == 2'b10) begin
			res = -(2**15-1);
		end

		adder = res[15:0];

	end
endfunction

reg signed [15:0] diff_re;
reg signed [15:0] diff_im;
reg signed [31:0] mult_1, mult_2, mult_3, mult_4;


always @(posedge clk) begin

	if (enable) begin
		Xa_re <= adder(xa_re, xb_re, 1'b0);
		Xa_im <= adder(xa_im, xb_im, 1'b0);

		diff_re = adder(xa_re, xb_re, 1'b1);
		diff_im = adder(xa_im, xb_im, 1'b1);

		mult_1 = diff_re * W_re;
		mult_2 = diff_im * W_im;
		mult_3 = diff_re * W_im;
		mult_4 = diff_im * W_re;

		// mind the extra sign bit when truncating mult output
		// eg. 8-bit q2.5 mult: s_mm.nnnnn * s_mm.nnnnn = ss_mmmm.nn_nnnn_nnnn
		Xb_re <= adder(mult_1[30:15], mult_2[30:15], 1'b1);
		Xb_im <= adder(mult_3[30:15], mult_4[30:15], 1'b0);
	end

end

endmodule
