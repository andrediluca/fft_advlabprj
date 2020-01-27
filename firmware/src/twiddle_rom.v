/**********************************************************
* ROM to implement a lookup table for the twiddle factors *
**********************************************************/
//import "DPI-C" function real sin (input real x);
//import "DPI-C" function real cos (input real x);

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

	localparam PI = 3.141592653589793;
	localparam ROM_LEN = FFT_N/(2**(stage_no+1)) - 1;
	reg signed [15:0] sin_lut [ROM_LEN:0];
	reg signed [15:0] cos_lut [ROM_LEN:0];

  // initialize lut ROM
  // W = exp(-i*2pi*k/N) = cos(2pi*k/N) - i*sin(2pi*k/N)
  // k goes from 0 to FFT_N/2 with step 2**S, where S is stage number
	integer n, step;
	real arg;
	initial begin
		for(n=0; n<=ROM_LEN; n=n+1) begin
			step = 2**stage_no;
			arg = 2*PI/FFT_N * step * n;
			sin_lut[n] = -$sin(arg) * (2**(15)-1);
			cos_lut[n] =  $cos(arg) * (2**(15)-1);
		end
	end


	always @(address) begin
		W_re <= cos_lut[address];
		W_im <= sin_lut[address];
	end

endmodule
