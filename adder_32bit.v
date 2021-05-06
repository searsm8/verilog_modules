
module adder32_bit
(
            sum,
            carry_out,
            data_1,
            data_2,
            carry_in
);
parameter data_width=31;
output reg [data_width:0] sum;
output reg carry_out;

input [data_width:0] data_1;
input [data_width:0] data_2;
input carry_in;

always @ (data_1, data_2, carry_in) //whenever an input changes
{carry_out, sum} = data_1 + data_2 + carry_in; // use {} to concatenate bits for carry_out
    
endmodule
