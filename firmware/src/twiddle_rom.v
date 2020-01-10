/**********************************************************
* ROM to implement a lookup table for the twiddle factors *
**********************************************************/
module twiddle_rom
#(
	parameter FFT_N = 1024,
	parameter stage_no = 1
)
(
	input wire [$clog2(FFT_N)-stage_no-2:0] address,
	output reg signed [15:0] W_re,
	output reg signed [15:0] W_im
);

	reg signed [15:0] sin_lut [FFT_N/2-1:0];
	reg signed [15:0] cos_lut [FFT_N/2-1:0];

	// initialize lut ROM
	//integer n;
	initial begin
		$readmemh("cos.mem", cos_lut);
		$readmemh("sin.mem", sin_lut);
	end


	always @(address) begin
		W_re <= cos_lut[address*(2**stage_no)];
		W_im <= sin_lut[address*(2**stage_no)];
	end

endmodule
