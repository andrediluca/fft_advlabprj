/*******************************************************
* Delay lane
*It consists of a shift register of delay_len taps.
*****************************************************/
module delay
#(parameter delay_len = 10) // delay period
(
  //control signal
  input wire clk,
  input wire enable,
  //input signal
  input wire signed [15:0] x_in_re, // real part of a
  input wire signed [15:0] x_in_im, // im part of a
  //output
  output wire signed [15:0] x_out_re,
  output wire signed [15:0] x_out_im
  );
  //
  reg [15:0] delay_sr_re [delay_len-1:0];
  reg [15:0] delay_sr_im [delay_len-1:0];

  genvar i;
  generate
  for(i = 0; i < delay_len; i = i + 1) begin
    always @(posedge clk) begin
      if (enable) begin
        delay_sr_re[i+1] <= delay_sr_re[i];
        delay_sr_im[i+1] <= delay_sr_im[i];
      end
    end
  end
  endgenerate

  always @(posedge clk) begin
    if (enable) begin
      delay_sr_re[0] <= x_in_re;
      delay_sr_im[0] <= x_in_im;
    end
  end

  assign x_out_re = delay_sr_re[delay_len - 1];
  assign x_out_im = delay_sr_im[delay_len - 1];
endmodule
