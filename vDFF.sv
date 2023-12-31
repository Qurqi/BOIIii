module vDFF(clk, in, out) ;
  parameter n = 1;  // width
  input clk ;
  input [n-1:0] in ;
  output [n-1:0] out ;
  reg [n-1:0] out ;

  always_ff @(posedge clk)
    out = in ;
endmodule 
