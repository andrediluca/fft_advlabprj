module stage
#(
  parameter FFT_N = 1024,
  parameter stage_no = 1
)
(
  input wire clk,
  input wire enable,
  input wire ctrl,
  input wire [$clog2(FFT_N)-stage_no-2:0] address,
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

reg ctrl_dly = 0;
reg signed [15:0] bf_xb_re_dly;
reg signed [15:0] bf_xb_im_dly;
reg signed [15:0] dly_out_re_reg;
reg signed [15:0] dly_out_im_reg;

always @(posedge clk) begin
  ctrl_dly <= ctrl;
  bf_xb_re_dly <= bf_xb_re;
  bf_xb_im_dly <= bf_xb_im;
  dly_out_re_reg <= dly_out_re;
  dly_out_im_reg <= dly_out_im;
end

assign X_out_re = (ctrl_dly) ? bf_Xa_re : dly_out_re_reg;
assign X_out_im = (ctrl_dly) ? bf_Xa_im : dly_out_im_reg;
assign dly_in_re = (ctrl_dly) ? bf_Xb_re : bf_xb_re_dly;
assign dly_in_im = (ctrl_dly) ? bf_Xb_im : bf_xb_im_dly;



// Last stage has no delay and a single element ROM, so we skip the delay line module and ROM.
generate
  if ( stage_no != $clog2(FFT_N) ) begin

    delay #(.delay_len(FFT_N/2**(stage_no+1)-1)) delay_line(
      .clk(clk),
      .enable(enable),
      .x_in_re(dly_in_re),
      .x_in_im(dly_in_im),
      .x_out_re(dly_out_re),
      .x_out_im(dly_out_im)
    );

    twiddle_rom #(.FFT_N(FFT_N), .stage_no(stage_no)) rom_inst(
      .address(address),
      .W_re(W_re),
      .W_im(W_im)
   );

  end else begin

    assign dly_out_re = dly_in_re;
    assign dly_out_im = dly_in_im;
    assign W_re = 16'h7fff;
    assign W_im = 0;

  end
endgenerate

butterfly butterfly_inst(
  .clk(clk),
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
