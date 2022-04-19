// the decoder produces microinstructions based on the opcode to control the execution of an instruction
module decoder(
    input [15:0] instr,
    input interrupt,
    input zero, carry,
    output reg load_A, load_B, load_PC, load_SP, load_stack,
    output reg [2:0] alu_op,
    output reg SP_incr, // 0 = decrement stack pointer, 1 = increment stack pointer
    output reg stack_write, // 0 = read from stack, 1 = write to stack    
    output reg stack_sel, // select the source for the stack 0 = PC, 1 = RegA      
    output reg op1_sel, op2_sel, //selects operands going into ALU
    output reg [1:0] A_sel, // 0 = read from memory, 1 = take ALU result, 2 = from stack
    output reg [1:0] B_sel, // 0 = read from memory, 1 = take ALU result, 2 = B'
    output reg [1:0] PC_sel, //select the source for the PC 0 = addr, 1 = stack, 2 = next_PC
    output reg enable_B, 
    output reg incr_B, //0 = decrement B, 1 = increment B
    output reg data_out_sel, // select where the output data (which goes to data memory) comes from. 0 = RegA, 1 = RegB
    output wire clear_A, clear_B, clear_zero, clear_carry,  
    output reg mem_write, // 0 = read, 1 = write
    output reg update_flags,     
    output reg [11:0] mem_addr
);
wire [3:0] opCode = instr[15:12];
wire [3:0] opCode_LSBs = instr[11:8];

reg IFF; // interrupt flip flop.
reg IEN; // interrupt enable

always @(instr) begin
    //set defaults
    load_A = 0; load_B = 0; load_PC = 0; load_SP = 0; load_stack = 0;
    mem_write = 0; stack_write = 0; enable_B = 0; update_flags = 0;
    mem_addr = instr[11:0];
    
    if(IEN & interrupt & ~IFF) begin 
        // first cycle of Interrupt Service Routine, JSR to INTVEC
        load_A = 0; load_B = 0; load_PC = 1; load_SP = 1; load_stack = 1;
        mem_write = 0; mem_addr = 12'hF00; // start address of ISR
        PC_sel = 0; SP_incr = 1; stack_sel = 0; stack_write = 1;   
        IFF = 1;          
    end
    else
    case(opCode)
        4'b0000: begin //LDA
            load_A = 1; load_B = 0; load_PC = 0; load_SP = 0; load_stack = 0;
            alu_op = 0; op1_sel = 0; 
            A_sel = 0; mem_write = 0;
        end
        4'b0001: begin //LDB
            load_A = 0; load_B = 1; load_PC = 0; load_SP = 0; load_stack = 0;
            alu_op = 0; op1_sel = 0; 
            B_sel = 0; mem_write = 0;
        end
        
        4'b0010: begin //STA
            load_A = 0; load_B = 0; load_PC = 0; load_SP = 0; load_stack = 0;
            alu_op = 0;
            data_out_sel = 0; mem_write = 1;
        end
        
        4'b0011: begin //STB
            load_A = 0; load_B = 0; load_PC = 0; load_SP = 0; load_stack = 0;
            alu_op = 0;
            data_out_sel = 1; mem_write = 1;
        end
        
        4'b0100: begin //JMP
            load_A = 0; load_B = 0; load_PC = 1; load_SP = 0; load_stack = 0;
            mem_write = 0;
            PC_sel = 0;
        end
        
        4'b0101: begin //NOP
            load_A = 0; load_B = 0; load_PC = 0; load_SP = 0; load_stack = 0;
            mem_write = 0;
        end
        
        4'b1000: begin //JSR
            load_A = 0; load_B = 0; load_PC = 1; load_SP = 1; load_stack = 1;
            mem_write = 0;
            PC_sel = 0; SP_incr = 1; stack_sel = 0; stack_write = 1;
        end
                
        4'b1010: begin //PUSHA
            load_A = 0; load_B = 0; load_PC = 0; load_SP = 1; load_stack = 1;
            mem_write = 0;
            SP_incr = 1; stack_sel = 1; stack_write = 1;
        end
        
        4'b1100: begin //POPA
            load_A = 1; load_B = 0; load_PC = 0; load_SP = 1; load_stack = 0;
            mem_write = 0;
            SP_incr = 0; A_sel = 2; stack_write = 0;
        end
        
        4'b1110: begin //RET
            load_A = 0; load_B = 0; load_PC = 1; load_SP = 1; load_stack = 0;
            mem_write = 0;
            SP_incr = 0; PC_sel = 1; stack_write = 0;
        end
        
        
        4'b0111: begin //Register reference instructions
            case(opCode_LSBs)                
                4'b0001: begin //ADD
                    load_A = 1; load_B = 0; load_PC = 0; load_SP = 0; load_stack = 0;
                    mem_write = 0; update_flags = 1;
                    alu_op = 1; op1_sel = 0; op2_sel = 0; A_sel = 1;       
                end 
                4'b0010: begin //AND
                    load_A = 1; load_B = 0; load_PC = 0; load_SP = 0; load_stack = 0;
                    mem_write = 0; update_flags = 1;
                    alu_op = 2; op1_sel = 0; op2_sel = 0; A_sel = 1;
                end
                //CLA and CLB implemented as assign
                4'b0011: begin //CLA
                    load_A = 0; load_B = 0; load_PC = 0; load_SP = 0; load_stack = 0;
                    mem_write = 0;
                end 
                4'b0100: begin //CLB
                    load_A = 0; load_B = 0; load_PC = 0; load_SP = 0; load_stack = 0;
                    mem_write = 0;
                end 
                4'b0101: begin //CMB
                    B_sel = 2;  load_B = 1;
                end 
                4'b0110: begin //INCB
                    enable_B = 1; incr_B = 1;
                end 
                4'b0111: begin //DECB
                    enable_B = 1; incr_B = 0;        
                end                
                4'b1010: begin //ION
                    IEN = 1;
                end 
                4'b1011: begin //IOF
                    IEN = 0;
                end 
                4'b1100: begin //SC
                    if(carry) begin
                        load_PC = 1; PC_sel = 2;
                    end        
                end 
                4'b1101: begin //SZ
                     if(zero) begin
                        load_PC = 1; PC_sel = 2;
                    end 
                end                 
            endcase        
        end
        
        4'b1111: begin //User configurable instructions
        
        end                        
    endcase
    
    IFF = interrupt;
end //always    
    //logic for Clear signals
    assign clear_A = (opCode == 4'h7) && (opCode_LSBs == 4'h3);
    assign clear_B = (opCode == 4'h7) && (opCode_LSBs == 4'h4);    
    assign clear_carry = (opCode == 4'h7) && (opCode_LSBs == 4'h8);
    assign clear_zero  = (opCode == 4'h7) && (opCode_LSBs == 4'h9);



endmodule