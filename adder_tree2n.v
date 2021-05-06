
// adder_tree2n module generates a tree of parallel adders to efficiently add sets of numbers
// TREE_SIZE is expected to be a power of 2
//
// example: TREE_SIZE = 4, DATA_SIZE = 8
// inputs A and B will be 32 bits long (4 sets of 8 bits)
// Tree will consist of 3 layers:
// L0 with four 8b adders
// L1 with two 9b adders
// L2 with one 10b adder
// output Z will be 11 bits (each layer of addition adds one bit)
module adder_tree2n #(parameter TREE_SIZE=4, DATA_SIZE = 8)
(
	input [TREE_SIZE*DATA_SIZE - 1 : 0] A,
	input [TREE_SIZE*DATA_SIZE - 1 : 0] B,
	output [DATA_SIZE + $clog2(TREE_SIZE) : 0] Z
);

genvar i, j;
generate
for(i = 0; i <= $clog2(TREE_SIZE); i=i+1) begin : layer
	for(j = 0; j < TREE_SIZE / (2**i); j=j+1) begin : adders
		wire [DATA_SIZE + i : 0] sum;
		if(i == 0)
			assign sum = A[(j+1)*DATA_SIZE-1 : j*DATA_SIZE] + B[(j+1)*DATA_SIZE-1 : j*DATA_SIZE];
		else
			assign sum = layer[i-1].adders[2*j].sum + layer[i-1].adders[2*j+1].sum;
	end
end
endgenerate

assign Z = layer[$clog2(TREE_SIZE)].adders[0].sum;

endmodule
