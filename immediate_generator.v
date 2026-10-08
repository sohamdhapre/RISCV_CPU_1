module immediate_generator 
(
    input wire [31:0] instruction_word,
    output reg [31:0] immediate
);

    wire [6:0] opcode = instruction_word[6:0];

    // Combinational logic block to decode the immediate
    always @(*) 
    begin
        case (opcode)
            // I-Type (e.g., ADDI, LW, JALR)
            7'b0010011, 7'b0000011, 7'b1100111: 
            begin
                immediate = { {20{instruction_word[31]}}, instruction_word[31:20] };
            end
            
            // S-Type (e.g., SW - Store Word)
            7'b0100011: 
            begin
                immediate = { {20{instruction_word[31]}}, instruction_word[31:25], instruction_word[11:7] };
            end
            
            // B-Type (e.g., BEQ - Branch if Equal)
            7'b1100011: 
            begin
                immediate = { {19{instruction_word[31]}}, instruction_word[31], instruction_word[7], instruction_word[30:25], instruction_word[11:8], 1'b0 };
            end
            
            // U-Type (e.g., LUI - Load Upper Immediate)
            7'b0110111, 7'b0010111: 
            begin
                immediate = { instruction_word[31:12], 12'b0 };
            end
            
            // J-Type (e.g., JAL - Jump and Link)
            7'b1101111: 
            begin
                immediate = { {11{instruction_word[31]}}, instruction_word[31], instruction_word[19:12], instruction_word[20], instruction_word[30:21], 1'b0 };
            end
            // Default fallback to prevent latches

            // E-Type
            // NO            
            default: 
            begin
                immediate = 32'b0;
            end
        endcase
    end

endmodule