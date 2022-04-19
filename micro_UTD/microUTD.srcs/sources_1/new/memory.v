`timescale 1ns / 1ps

module memory #(parameter BITWIDTH=16, ADDR_SIZE=12) (
    input clk, enable,
    input [ADDR_SIZE-1:0] addr,
    input [BITWIDTH-1:0] in,
    input write,
    output reg [BITWIDTH-1:0] out
    );
    
    reg [BITWIDTH-1:0] mem [2**ADDR_SIZE-1:0];
    
    always @(posedge clk) begin
        if(enable) begin
            if(write)
                mem[addr] <= in;
            out <= mem[addr];
        end
    end //always
    
    
endmodule
