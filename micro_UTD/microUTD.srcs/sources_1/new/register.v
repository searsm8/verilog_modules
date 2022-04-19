
module register #(parameter WIDTH=16) (
    input clk, clear,
    input [WIDTH-1:0] in,
    input load,
    output reg [WIDTH-1:0] out
);

always @(posedge clk) begin
    if (clear)
        out <= 0;
    else if(load)
        out <= in;
end //always
endmodule

module counter #(parameter WIDTH=8) (
    input clk, clear, enable,
    input [WIDTH-1:0] in,
    input load,
    input incr,
    output reg [WIDTH-1:0] count
);

always @(posedge clk) begin
    if (clear)
        count <= 0;
    else if (load)
        count <= in;
    else if (enable) begin
        if(incr)
            count <= count + 1;
        else
            count <= count - 1;
    end
end // always

endmodule