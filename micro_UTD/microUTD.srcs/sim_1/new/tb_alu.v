`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2022 12:58:11 PM
// Design Name: 
// Module Name: tb_alu
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


module tb_alu(

    );
    reg [15:0] inA;
    reg [15:0] inB;
    reg [2:0] opCode;
    wire [15:0] result;
    wire zero, neg; 
    alu UUT (.inA(inA), .inB(inB), .opCode(opCode), .result(result), .zero(zero), .neg(neg));
    
    initial
    begin
    inA = 0;
    inB = 0;
    opCode = 0;
    #10;
    
    inA = 9;
    inB = 5;
    opCode = 1;
    #10;
    
    inA = 7;
    inB = 17;
    opCode = 2; //result = 1
    #10;
    
    inA = 35;
    inB = -15;
    opCode = 1;
    #10;
    
    inA = 99;
    inB = 55;
    opCode = 1;
    #10;
    
    inA = 17;
    inB = 6;
    opCode = 2; //result = 0
    #10;
    
    inA = 33;
    inB = -55;
    opCode = 1;
    #10;
    end //initial block
    
endmodule
