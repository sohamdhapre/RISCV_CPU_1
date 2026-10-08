module alu_control 
(
    input wire [1:0] alu_op,
    input wire [2:0] funct3,
    input wire [6:0] funct7,
    output reg [3:0] alu_control
);

    always @(*) 
    begin
        case (alu_op)
            2'b00: alu_control = 4'b0010; // Force ADD (Loads/Stores)
            2'b01: alu_control = 4'b0110; // Force SUB (Branches)
            
            2'b10: begin // R-Type Instructions
                case (funct3)
                    3'b000: 
                    begin
                        if (funct7 == 7'b0100000)
                            alu_control = 4'b0110; // SUB
                        else
                            alu_control = 4'b0010; // ADD
                    end
                    3'b111: alu_control = 4'b0000; // AND
                    3'b110: alu_control = 4'b0001; // OR
                    default: alu_control = 4'b0000;
                endcase
            end
            
            default: alu_control = 4'b0000;
        endcase
    end
endmodule