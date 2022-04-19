`timescale 1ns / 1ps

module tb_register();

reg clk;
reg clear;
reg [15:0] in1;
reg [11:0] in2;
reg load1, load2;
wire [15:0] reg_out;
wire [11:0] count_out;

register16b reg_UUT(.clk(clk), .clear(clear), .in(in1), .load(load1), .out(reg_out));
counter12b counter_UUT(.clk(clk), .clear(clear), .in(in2), .load(load2), .count(count_out));

initial
begin
    clk = 0;
    in1 = 56; load1 = 0;
    in2 = 0; load2 = 0;
    #5 clk = ~clk; #5 clk = ~clk;
    clear = 1;
    #5 clk = ~clk; #5 clk = ~clk;    
    #5 clk = ~clk; #5 clk = ~clk;
    clear = 0;
    #5 clk = ~clk; #5 clk = ~clk;
    #5 clk = ~clk; #5 clk = ~clk;
    #5 clk = ~clk; #5 clk = ~clk;
    load1 = 1;
    #5 clk = ~clk; #5 clk = ~clk;
    load1 = 0;
    in2 = 15; load2 = 1;
    #5 clk = ~clk; #5 clk = ~clk;
    in2 = 0; load2 = 0;
    #5 clk = ~clk; #5 clk = ~clk;
    #5 clk = ~clk; #5 clk = ~clk;
    #5 clk = ~clk; #5 clk = ~clk;
    in1 = 678; load1 = 1;
    #5 clk = ~clk; #5 clk = ~clk;
    in1 = 34;
    #5 clk = ~clk; #5 clk = ~clk;
    in1 = 2222;
    #5 clk = ~clk; #5 clk = ~clk;
    in1 = 0; load1 = 0;
    
    
end

endmodule