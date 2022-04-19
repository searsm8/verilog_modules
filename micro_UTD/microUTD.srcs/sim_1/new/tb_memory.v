`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2022 04:03:44 PM
// Design Name: 
// Module Name: tb_memory
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


module tb_memory( );

    reg clk;
    reg [11:0] addr;
    reg [15:0] in;
    reg write;
    wire [15:0] out;
    memory #(.BITWIDTH(16), .ADDR_SIZE(12)) mem_UUT (.clk(clk), .addr(addr), .in(in), .write(write), .out(out));
    
    initial begin
    clk = 0; addr = 0; in = 0; write = 0;
    #5; clk = ~clk; #5; clk = ~clk;
    in = 16'h1055; write = 1;
    #5; clk = ~clk; #5; clk = ~clk;
    addr = 100; in = 16'hFFEE; write = 1;
    #5; clk = ~clk; #5; clk = ~clk;
    addr = 17; in = 16'hAAAA; write = 1;
    #5; clk = ~clk; #5; clk = ~clk;
    addr = 100; in = 78; write = 0;
    #5; clk = ~clk; #5; clk = ~clk;
    addr = 17; in = 78; write = 0;
    #5; clk = ~clk; #5; clk = ~clk;
    addr = 0; in = 78; write = 0;
    #5; clk = ~clk; #5; clk = ~clk;
    
    $finish;
        
    end
endmodule
