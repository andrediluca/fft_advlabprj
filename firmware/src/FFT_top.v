module FFT_top
#(
  parameter FFT_N = 1024
)
(
  input wire clk,
  input wire rst,
  input wire enable,
  input wire signed [15:0] xb_re,
  input wire signed [15:0] xb_im,
  output wire signed [15:0] Xb_re,
  output wire signed [15:0] Xb_im
);

  localparam log_FFT_N = $clog2(FFT_N);

  wire [15:0] stage_interconn_re [log_FFT_N+1:0];
  wire [15:0] stage_interconn_im [log_FFT_N+1:0];
  reg [log_FFT_N:0] counter;

  // generate stages
  genvar i;
  generate
    for(i=0; i<log_FFT_N-1; i=i+1) begin
      stage #(.FFT_N(FFT_N), .stage_no(i)) stage_inst(
        .clk(clk),
        .enable(enable),
        .ctrl(counter[log_FFT_N-1-i]),
        .address(counter[log_FFT_N-1-i:0]),
        .bf_xb_re(stage_interconn_re[i]),
        .bf_xb_im(stage_interconn_im[i]),
        .X_out_re(stage_interconn_re[i+1]),
        .X_out_im(stage_interconn_im[i+1])
      );
    end
  endgenerate

  // implement last stage
  stage #(.FFT_N(FFT_N), .stage_no(log_FFT_N)) stage_inst(
    .clk(clk),
    .enable(enable),
    .ctrl(counter[0]),
    .bf_xb_re(stage_interconn_re[log_FFT_N-1]),
    .bf_xb_im(stage_interconn_im[log_FFT_N-1]),
    .X_out_re(stage_interconn_re[log_FFT_N]),
    .X_out_im(stage_interconn_im[log_FFT_N])
   );

  assign stage_interconn_re[0] = xb_re;
  assign stage_interconn_im[0] = xb_im;
  assign Xb_re = stage_interconn_re[log_FFT_N];
  assign Xb_im = stage_interconn_im[log_FFT_N];


  always @(posedge clk) begin
    if (enable) begin

    if (counter == 1023)
      counter <= 0;
    else
      counter <= counter + 1;
    end else if (rst) begin
      counter <= 1023;
    end
  end

endmodule
