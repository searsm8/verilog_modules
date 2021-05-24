module multiplier_32x32_behav(X, Y, clk, P);
  
  parameter width = 32;
  
  input signed [width-1:0] Y; //multiplicand
  input signed [width-1:0] X; //multiplier

  reg signed [width-1:0] MC;
  reg signed [width-1:0] MR;
  input clk;
  output reg signed [2*width-1:0] P; //product
  
always @ (posedge clk)
begin
	MC <= Y;
	MR <= X;
	P <= MC * MR;
end
  
endmodule