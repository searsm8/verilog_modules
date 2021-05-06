`timescale 1ns / 1ps

`define assert(signal, value) \
        if (signal !== value) begin \
            $display("ASSERTION FAILED in %m: signal != value"); \
            $finish; \
        end
        
module tb_adder_tree2n();
	parameter TREE_SIZE = 8;
	parameter DATA_SIZE = 8;
	
	//inputs
	reg [TREE_SIZE*DATA_SIZE - 1 : 0] A;
	reg [TREE_SIZE*DATA_SIZE - 1 : 0] B;
	
	//outputs
	wire [DATA_SIZE + $clog2(TREE_SIZE):0] Z;
	
	//instatiate UUT
	adder_tree2n #(.TREE_SIZE(TREE_SIZE), .DATA_SIZE(DATA_SIZE)) UUT (.A(A), .B(B), .Z(Z));
	
	initial
	begin
	#0 A = 0; B = 0;
	
	#10 A = 7; B = 5;
	#1 `assert(Z,12); $display("Test 1 Passed: 7 + 5 = 12");
	
	#10 A = 123; B = 45;
	#1 `assert(Z, 168); $display("Test 2 Passed: 123 + 45 = 168");
	
	#10 A = {8'd5, 8'd16}; B = {8'd41, 8'd17};
    #1 `assert(Z, 79); $display("Test 3 Passed: 5+16+41+17 = 79");
			
	#10 A = {8'd215, 8'd126}; B = {8'd241, 8'd187};	
	#1 `assert(Z, 769); $display("Test 4 Passed: 215+126+241+187 = 769");
	
	#10 $finish;
	end
endmodule