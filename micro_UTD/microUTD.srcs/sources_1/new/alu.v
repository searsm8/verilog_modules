`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2022 12:45:11 PM
// Design Name: 
// Module Name: alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu(
    input [15:0] inA,
    input [15:0] inB,
    input [2:0] opCode,
    output [15:0] out,
    output zero,
    output carry,
    output neg
    );
    
    reg [16:0] result;
    always @ (inA, inB, opCode) begin
    case(opCode)
        3'b000: result = 0;        
        3'b001: result = inA + inB;
        3'b010: result = inA & inB;           
        
     endcase 
     end //always
     
     assign zero = ~|result[15:0]; // if any bits are 1, then zero is not true
     assign neg = result[15];
     assign carry = result[16];
     assign out = result[15:0];
     
        
    
endmodule
