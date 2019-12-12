
/******************************************
* Butterfly computation   
* the output is registered and so delayed 
* of 1-clk cycle
*******************************************/

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

reg  signed [15:0] diff_re;
reg  signed [15:0] diff_im;

always @(posedge clk) begin
  if (enable) begin
    Xa_re <= xa_re + xb_re;
    Xa_im <= xa_im + xb_im;
    
    diff_re = xa_re - xb_re;
    diff_im = xa_im - xb_im;
    Xb_re <= diff_re * W_re - diff_im * W_im; 
    Xb_im <= diff_re * W_im + diff_im * W_re;
  end
end
    
    
 
endmodule
