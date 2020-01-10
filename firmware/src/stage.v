module stage
#(
	parameter stage_no = 1,
	parameter FFT_N = 1024
)
(
	input wire clk,
	input wire enable,
	input wire ctrl,
	input wire [15:0] address,
	input wire signed [15:0] bf_xb_re,
	input wire signed [15:0] bf_xb_im,
	output wire signed [15:0] X_out_re,
	output wire signed [15:0] X_out_im
);

// butterfly I/O
wire signed [15:0] bf_Xa_re, bf_Xa_im, bf_Xb_re, bf_Xb_im;
wire signed [15:0] W_re, W_im;
// delay line I/O
wire signed [15:0] dly_out_re, dly_out_im, dly_in_re, dly_in_im;

assign X_out_re = (ctrl) ? bf_Xa_re : dly_out_re;
assign X_out_im = (ctrl) ? bf_Xa_im : dly_out_im;
assign dly_in_re = (ctrl) ? bf_Xb_re : bf_xb_re;
assign dly_in_im = (ctrl) ? bf_Xb_im : bf_xb_im;


twiddle_rom #(.rom_len(FFT_N/2), .stage_no(stage_no)) rom_inst(
	.address(address),
	.W_re(W_re),
	.W_im(W_im)
);

// Last stage has no delay, so we skip the delay line module
generate
  if ( (FFT_N/2**(stage_no+1)-1) > 0 ) begin
    delay #(.delay_len(FFT_N/2**(stage_no+1)-1)) delay_line(
      .clk(clk),
      .enable(enable),
      .x_in_re(dly_in_re),
      .x_in_im(dly_in_im),
      .x_out_re(dly_out_re),
      .x_out_im(dly_out_im)
    );
  end else begin
    assign dly_out_re = dly_in_re;
    assign dly_out_im = dly_in_im;
  end
endgenerate

butterfly butterfly_inst(
	.clk(clk),
	.enable(enable),
	.xa_re(dly_out_re),
	.xa_im(dly_out_im),
	.xb_re(bf_xb_re),
	.xb_im(bf_xb_im),
	.W_re(W_re),
	.W_im(W_im),
	.Xa_re(bf_Xa_re),
	.Xa_im(bf_Xa_im),
	.Xb_re(bf_Xb_re),
	.Xb_im(bf_Xb_im)
);

endmodule
