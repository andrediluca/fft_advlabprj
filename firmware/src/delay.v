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
  wire signed [15:0] x_out_re,
  wire signed [15:0] x_out_im
  );
  //
  reg [delay_len-1:0] delay_sr_re [15:0];
  reg [delay_len-1:0] delay_sr_im [15:0];

  genvar i;
  generate
    for(i = 0; i < 16; i = i + 1) begin
      always @(posedge clk) begin
        if (enable) begin
          delay_sr_re[i] <= {delay_sr_re[i][delay_len - 2 : 0], x_in_re[i]};
          delay_sr_im[i] <= {delay_sr_im[i][delay_len - 2 : 0], x_in_im[i]};
        end

      end
      assign x_out_re[i] = delay_sr_re[i][delay_len - 1];
      assign x_out_im[i] = delay_sr_im[i][delay_len - 1];
    end
  endgenerate
endmodule
