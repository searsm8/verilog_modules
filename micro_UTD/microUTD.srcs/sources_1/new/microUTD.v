//top level module for µUTD CPU

module microUTD(
    input clk,
    input reset,
    input interrupt,
    input [15:0] instr,     //interface with instruction memory
    input [15:0] data_in,       //interface with data memory
    output data_write,
    output [15:0] data_out,
    output [11:0] data_addr,
    output [11:0] instr_addr
);

//microinstruction wires, described in decoder module
wire [11:0] PC_in;
wire clear_A, clear_B;
wire [15:0] in_A;
wire [15:0] in_B;
wire [15:0] out_A;
wire [15:0] out_B;
wire load_A, load_B, load_PC, load_SP, load_stack;
wire SP_incr;
wire [11:0] SP_out;
wire stack_write;
wire [15:0] stack_in;
wire [15:0] stack_out;
wire [15:0] alu_in_A;
wire [15:0] alu_in_B;
wire [2:0] alu_opCode;
wire [15:0] alu_result;
wire alu_zero, alu_neg, alu_carry;
reg zero, carry;
wire clear_carry, clear_zero;

wire [1:0] PC_sel;
wire [1:0] A_sel;
wire [1:0] B_sel;
wire op1_sel, op2_sel;
wire data_out_sel;
wire stack_sel;
wire enable_B, incr_B;
reg [11:0] next_PC;



//instantiate submodules
counter  #(.WIDTH(12)) PC   (.clk(~clk), .clear(reset), .enable(1'b1), .in(PC_in), .load(load_PC), .incr(1'b1), .count(instr_addr));
counter  #(.WIDTH(12)) SP   (.clk(~clk), .clear(reset), .enable(load_SP), .in(), .load(1'b0), .incr(SP_incr), .count(SP_out));
register #(.WIDTH(16)) regA (.clk(clk), .clear(clear_A), .in(in_A), .load(load_A), .out(out_A));
counter  #(.WIDTH(16)) regB (.clk(clk), .clear(clear_B), .enable(enable_B), .in(in_B), .load(load_B), .incr(incr_B), .count(out_B));
alu main_alu (.inA(alu_in_A), .inB(alu_in_B), .opCode(alu_opCode), .out(alu_result), .zero(alu_zero), .neg(alu_neg), .carry(alu_carry));
memory #(.BITWIDTH(16), .ADDR_SIZE(12)) stack (.clk(clk), .enable(1'b1), .addr(SP_out), .in(stack_in), .write(stack_write), .out(stack_out));
decoder instr_decoder(.instr(instr), .interrupt(interrupt), .zero(zero), .carry(carry), .load_A(load_A), .load_B(load_B), .load_PC(load_PC), .load_SP(load_SP), .load_stack(load_stack), 
    .alu_op(alu_opCode), .SP_incr(SP_incr), .stack_write(stack_write), .clear_carry(clear_carry), .clear_zero(clear_zero),
    .PC_sel(PC_sel), .stack_sel(stack_sel), .op1_sel(op1_sel), .op2_sel(op2_sel), .A_sel(A_sel), .B_sel(B_sel), .data_out_sel(data_out_sel), 
    .clear_A(clear_A), .clear_B(clear_B), .mem_write(data_write), .mem_addr(data_addr), .enable_B(enable_B), .incr_B(incr_B), .update_flags(update_flags) );

//implement control MUXes
assign in_A = A_sel[1] ? (stack_out) : (A_sel[0] ? alu_result : data_in);
assign in_B = B_sel[1] ? (~out_B) : (B_sel[0] ? alu_result : data_in);

assign alu_in_A = out_A;
assign alu_in_B = out_B;

always@(posedge clk) next_PC <= instr_addr+1;
assign stack_in = stack_sel ? out_A : next_PC;
assign PC_in = PC_sel[1] ? next_PC+1 : (PC_sel[0] ? stack_out[11:0] : data_addr);
assign data_out = data_out_sel ? out_B  : out_A;
always@(posedge clk) zero  <= clear_zero ? 1'b0 : (update_flags ? alu_zero  : zero);
always@(posedge clk) carry  <= clear_carry ? 1'b0 : (update_flags ? alu_carry  : carry);
 
endmodule