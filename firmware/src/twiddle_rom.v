/**********************************************************
* ROM to implement a lookup table for the twiddle factors *
**********************************************************/
module twiddle_rom
#(
	parameter rom_len = 512,
	parameter stage_no = 1
)
(
	input wire [15:0] address,
	output reg signed [15:0] W_re,
	output reg signed [15:0] W_im
);

	reg signed [15:0] sin_lut [rom_len-1:0];
	reg signed [15:0] cos_lut [rom_len-1:0];

	// initialize lut ROM
	//integer n;
	initial begin
		$readmemh("cos.mem", cos_lut);
		$readmemh("sin.mem", sin_lut);
	end


	always @(address) begin
		W_re <= cos_lut[address*stage_no];
		W_im <= sin_lut[address*stage_no];
	end

endmodule
