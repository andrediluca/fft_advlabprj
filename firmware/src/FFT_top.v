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
  reg [log_FFT_N:0] counter_reg;
  reg [15:0] xb_re_reg;
  reg [15:0] xb_im_reg;

  // generate stages
  genvar i;
  generate
    for(i=0; i<log_FFT_N-1; i=i+1) begin
      stage #(.FFT_N(FFT_N), .stage_no(i)) stage_inst(
        .clk(clk),
        .enable(enable),
        .ctrl(counter_reg[log_FFT_N-1-i]),
        .address(counter_reg[log_FFT_N-1-i:0]),
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
    .ctrl(counter_reg[0]),
    .bf_xb_re(stage_interconn_re[log_FFT_N-1]),
    .bf_xb_im(stage_interconn_im[log_FFT_N-1]),
    .X_out_re(stage_interconn_re[log_FFT_N]),
    .X_out_im(stage_interconn_im[log_FFT_N])
   );

  assign stage_interconn_re[0] = xb_re_reg;
  assign stage_interconn_im[0] = xb_im_reg;
  assign Xb_re = stage_interconn_re[log_FFT_N];
  assign Xb_im = stage_interconn_im[log_FFT_N];


  always @(posedge clk) begin
    counter_reg <= counter;
    xb_re_reg <= xb_re;
    xb_im_reg <= xb_im;
    if (enable) begin

      if (counter == 1023)
        counter <= 0;
      else
        counter <= counter + 1;
      end else if (rst) begin
        counter <= 0;

    end
  end

endmodule
