module main_control 
(
    input wire [6:0] opcode,
    output reg branch,
    output reg mem_read,
    output reg mem_to_reg,
    output reg [1:0] alu_op,
    output reg mem_write,
    output reg alu_src_2,
    output reg reg_write
);

    always @(*) 
    begin
        // Default all signals to 0 to prevent Verilog latches
        {branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src_2, reg_write} = 8'b00000000;

        case (opcode)
            7'b0110011: 
            begin // R-Type (ADD, SUB, AND)
                reg_write = 1;
                alu_src_2   = 0;
                alu_op    = 2'b10; // 10 means "Look at funct3/funct7"
            end
            
            //I-Type Arith
            7'b0010011:
            begin
                alu_src_2 = 1;
                reg_write = 1;
                alu_op = 2'b11; 
            end


            7'b0000011: 
            begin // I-Type Load (LW)
                reg_write  = 1;
                alu_src_2    = 1; // ALU takes Immediate instead of rs2
                mem_read   = 1;
                mem_to_reg = 1; // Register gets data from Memory
                alu_op     = 2'b00; // 00 means "Always ADD" (for addr calculation)
            end

            7'b0100011:
            begin //S-type, Store Word
            mem_write = 1;
            alu_src_2 = 1;
            alu_op = 2'b00;
            end
            
            7'b1100011: 
            begin // B-Type Branch (BEQ)
                branch = 1;
                alu_src_2 = 0;
                alu_op = 2'b01; // 01 means "Always SUB" (for comparison)
            end
        endcase
    end
endmodule