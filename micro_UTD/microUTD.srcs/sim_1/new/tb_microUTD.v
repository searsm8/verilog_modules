module tb_microUTD();
reg clk;
reg reset;
reg interrupt;

wire [11:0] data_addr;
wire [15:0] data_mem_in;
wire [15:0] data_mem_out;
wire data_mem_write;
wire UUT_data_write;
wire [15:0] UUT_data_out;
wire [11:0] UUT_data_addr;

wire [11:0] instr_addr;
wire [15:0] instr_mem_out;
wire [11:0] UUT_instr_addr;

//internal wires
reg pgrm_mode; //if 1, testbench can program memories
reg [15:0] pgrm_data_mem_in;
reg [15:0] pgrm_instr_mem_in;
reg [11:0] pgrm_data_addr;
reg [11:0] pgrm_instr_addr;

memory #(.BITWIDTH(16), .ADDR_SIZE(12)) instr_mem (.clk(clk), .enable(1'b1), .addr(instr_addr), .in(pgrm_instr_mem_in), .write(pgrm_mode), .out(instr_mem_out));
memory #(.BITWIDTH(16), .ADDR_SIZE(12)) data_mem (.clk(~clk), .enable(1'b1), .addr(data_addr), .in(data_mem_in), .write(data_mem_write), .out(data_mem_out));
microUTD UUT (.clk(clk), .reset(reset), .interrupt(interrupt), .instr(instr_mem_out), .data_in(data_mem_out), .data_write(UUT_data_write), .data_out(UUT_data_out),
         .data_addr(UUT_data_addr), .instr_addr(UUT_instr_addr));
         
//program mode MUXes
assign data_mem_in  = pgrm_mode ? pgrm_data_mem_in  : UUT_data_out;
assign instr_addr   = pgrm_mode ? pgrm_instr_addr : UUT_instr_addr;
assign data_addr    = pgrm_mode ? pgrm_data_addr : UUT_data_addr;
assign data_mem_write=pgrm_mode ? 1'b1 : UUT_data_write;
integer i;
initial
begin
    clk = 0; reset = 0; pgrm_mode = 1;
    #5; clk = ~clk; #5; clk = ~clk;
    //read in data to memory
    pgrm_data_addr = 0; pgrm_data_mem_in = 0; #5; clk = ~clk; #5; clk = ~clk;
    pgrm_data_addr = 1; pgrm_data_mem_in = 1; #5; clk = ~clk; #5; clk = ~clk;
    pgrm_data_addr = 2; pgrm_data_mem_in = 10; #5; clk = ~clk; #5; clk = ~clk;
    pgrm_data_addr = 3; pgrm_data_mem_in = 7; #5; clk = ~clk; #5; clk = ~clk;
    pgrm_data_addr = 16'h0F00; pgrm_data_mem_in = 35; #5; clk = ~clk; #5; clk = ~clk;
    pgrm_data_addr = 16'h0F01; pgrm_data_mem_in = 29; #5; clk = ~clk; #5; clk = ~clk;
    
    //read in instructions to memory
    pgrm_instr_addr = 0; pgrm_instr_mem_in = 16'h0000; #5; clk = ~clk; #5; clk = ~clk; // LDA @ 0
    pgrm_instr_addr = 1; pgrm_instr_mem_in = 16'h1001; #5; clk = ~clk; #5; clk = ~clk; // LDB
    pgrm_instr_addr = 2; pgrm_instr_mem_in = 16'h7600; #5; clk = ~clk; #5; clk = ~clk; // INCB
    pgrm_instr_addr = 3; pgrm_instr_mem_in = 16'h7100; #5; clk = ~clk; #5; clk = ~clk; // ADD
    pgrm_instr_addr = 4; pgrm_instr_mem_in = 16'hA000; #5; clk = ~clk; #5; clk = ~clk; // PUSHA
    pgrm_instr_addr = 5; pgrm_instr_mem_in = 16'h0002; #5; clk = ~clk; #5; clk = ~clk; // LDA
    pgrm_instr_addr = 6; pgrm_instr_mem_in = 16'h7500; #5; clk = ~clk; #5; clk = ~clk; // CMB
    pgrm_instr_addr = 7; pgrm_instr_mem_in = 16'h7200; #5; clk = ~clk; #5; clk = ~clk; // AND
    pgrm_instr_addr = 8; pgrm_instr_mem_in = 16'h7500; #5; clk = ~clk; #5; clk = ~clk; // CMB
    pgrm_instr_addr = 9; pgrm_instr_mem_in = 16'hC000; #5; clk = ~clk; #5; clk = ~clk; // POPA
    pgrm_instr_addr = 10; pgrm_instr_mem_in = 16'h7D00; #5; clk = ~clk; #5; clk = ~clk; // SZ
    pgrm_instr_addr = 11; pgrm_instr_mem_in = 16'h4002; #5; clk = ~clk; #5; clk = ~clk; // JMP
    pgrm_instr_addr = 12; pgrm_instr_mem_in = 16'h2000; #5; clk = ~clk; #5; clk = ~clk; // STA
    pgrm_instr_addr = 13; pgrm_instr_mem_in = 16'h5000; #5; clk = ~clk; #5; clk = ~clk; // NOP
    pgrm_instr_addr = 14; pgrm_instr_mem_in = 16'h5000; #5; clk = ~clk; #5; clk = ~clk; // NOP

    /*
    pgrm_instr_addr = 0; pgrm_instr_mem_in = 16'h0000; #5; clk = ~clk; #5; clk = ~clk; // LDA @ 0
    pgrm_instr_addr = 1; pgrm_instr_mem_in = 16'h7B00; #5; clk = ~clk; #5; clk = ~clk; // IOF
    pgrm_instr_addr = 2; pgrm_instr_mem_in = 16'h1002; #5; clk = ~clk; #5; clk = ~clk; // LDB @ 2
    pgrm_instr_addr = 3; pgrm_instr_mem_in = 16'h7500; #5; clk = ~clk; #5; clk = ~clk; // CMB
    pgrm_instr_addr = 4; pgrm_instr_mem_in = 16'h7100; #5; clk = ~clk; #5; clk = ~clk; // ADD
    pgrm_instr_addr = 5; pgrm_instr_mem_in = 16'h7D00; #5; clk = ~clk; #5; clk = ~clk; // SZ
    pgrm_instr_addr = 6; pgrm_instr_mem_in = 16'h8016; #5; clk = ~clk; #5; clk = ~clk; // JSR @ 22    
    pgrm_instr_addr = 7; pgrm_instr_mem_in = 16'h5000; #5; clk = ~clk; #5; clk = ~clk; // NOP
    pgrm_instr_addr = 8; pgrm_instr_mem_in = 16'h5000; #5; clk = ~clk; #5; clk = ~clk; // NOP (trigger interrupt here!
    pgrm_instr_addr = 9; pgrm_instr_mem_in = 16'h5000; #5; clk = ~clk; #5; clk = ~clk; // NOP
    */
    
    // SUBROUTINE
    pgrm_instr_addr = 22; pgrm_instr_mem_in = 16'h7600; #5; clk = ~clk; #5; clk = ~clk; // INCB
    pgrm_instr_addr = 23; pgrm_instr_mem_in = 16'h7500; #5; clk = ~clk; #5; clk = ~clk; // CMB
    pgrm_instr_addr = 24; pgrm_instr_mem_in = 16'h7700; #5; clk = ~clk; #5; clk = ~clk; // DECB
    pgrm_instr_addr = 25; pgrm_instr_mem_in = 16'h7100; #5; clk = ~clk; #5; clk = ~clk; // ADD
    pgrm_instr_addr = 26; pgrm_instr_mem_in = 16'h2000; #5; clk = ~clk; #5; clk = ~clk; // STA @ 0
    pgrm_instr_addr = 27; pgrm_instr_mem_in = 16'hE000; #5; clk = ~clk; #5; clk = ~clk; // RET
    
    // ISR
    pgrm_instr_addr = 12'hF00; pgrm_instr_mem_in = 16'h0F00; #5; clk = ~clk; #5; clk = ~clk; // LDA @ F00
    pgrm_instr_addr = 12'hF01; pgrm_instr_mem_in = 16'h1F01; #5; clk = ~clk; #5; clk = ~clk; // LDB @ F01
    pgrm_instr_addr = 12'hF02; pgrm_instr_mem_in = 16'h7100; #5; clk = ~clk; #5; clk = ~clk; // ADD    
    pgrm_instr_addr = 12'hF03; pgrm_instr_mem_in = 16'h2F02; #5; clk = ~clk; #5; clk = ~clk; // STA @ F02
    pgrm_instr_addr = 12'hF04; pgrm_instr_mem_in = 16'hE000; #5; clk = ~clk; #5; clk = ~clk; // RET
    
    /*
    pgrm_instr_addr = 0; pgrm_instr_mem_in = 16'h0000; #5; clk = ~clk; #5; clk = ~clk; // LDA @ 0
    pgrm_instr_addr = 1; pgrm_instr_mem_in = 16'h1001; #5; clk = ~clk; #5; clk = ~clk; // LDB @ 1
    pgrm_instr_addr = 2; pgrm_instr_mem_in = 16'h7100; #5; clk = ~clk; #5; clk = ~clk; // ADD
    pgrm_instr_addr = 3; pgrm_instr_mem_in = 16'hA000; #5; clk = ~clk; #5; clk = ~clk; // PUSHA
    pgrm_instr_addr = 4; pgrm_instr_mem_in = 16'h0002; #5; clk = ~clk; #5; clk = ~clk; // LDA @ 2
    pgrm_instr_addr = 5; pgrm_instr_mem_in = 16'h1003; #5; clk = ~clk; #5; clk = ~clk; // LDB @ 3
    pgrm_instr_addr = 6; pgrm_instr_mem_in = 16'h7200; #5; clk = ~clk; #5; clk = ~clk; // AND
    pgrm_instr_addr = 7; pgrm_instr_mem_in = 16'h2004; #5; clk = ~clk; #5; clk = ~clk; // STA @ 4
    pgrm_instr_addr = 8; pgrm_instr_mem_in = 16'h1004; #5; clk = ~clk; #5; clk = ~clk; // LDB @ 4
    pgrm_instr_addr = 9; pgrm_instr_mem_in = 16'hC000; #5; clk = ~clk; #5; clk = ~clk; // POPA
    pgrm_instr_addr = 10; pgrm_instr_mem_in = 16'h7100; #5; clk = ~clk; #5; clk = ~clk; // ADD
    pgrm_instr_addr = 11; pgrm_instr_mem_in = 16'h2005; #5; clk = ~clk; #5; clk = ~clk; // STA @ 5
    pgrm_instr_addr = 12; pgrm_instr_mem_in = 16'h5000; #5; clk = ~clk; #5; clk = ~clk; // NOP
    pgrm_instr_addr = 13; pgrm_instr_mem_in = 16'h7300; #5; clk = ~clk; #5; clk = ~clk; // CLA
    pgrm_instr_addr = 14; pgrm_instr_mem_in = 16'h7400; #5; clk = ~clk; #5; clk = ~clk; // CLB
    pgrm_instr_addr = 15; pgrm_instr_mem_in = 16'h5000; #5; clk = ~clk; #5; clk = ~clk; // NOP
    pgrm_instr_addr = 16; pgrm_instr_mem_in = 16'h4000; #5; clk = ~clk; #5; clk = ~clk; // JMP @ 0
    pgrm_instr_addr = 17; pgrm_instr_mem_in = 16'h5000; #5; clk = ~clk; #5; clk = ~clk; // NOP   
   */
    pgrm_mode = 0;
    reset = 1; #5; clk = ~clk; #5; clk = ~clk; reset = 0;

    //run the CPU for many clks
    for(i = 0; i < 235; i = i+1) begin
        #5; clk = ~clk; 
        if(i == 2) interrupt = 1;
        else interrupt = 0;
        #5; clk = ~clk;
    end
$finish;
end

endmodule