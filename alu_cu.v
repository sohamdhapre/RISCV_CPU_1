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
            
            2'b10: 
            begin // R-Type Instructions
                case (funct3)
                    3'b000: 
                    begin // !!!fix: use case instead of if-else
                        if (funct7 == 7'b0100000)
                            alu_control = 4'b0110; // SUB
                        else
                            alu_control = 4'b0010; // ADD
                    end
                    3'b111: alu_control = 4'b0000; // AND

                    3'b110: alu_control = 4'b0001; // OR

                    3'b100: alu_control = 4'b0011; //xor

                    3'b001: alu_control = 4'b0100; // sll

                    3'b101: //srl and sra
                        case (funct7)
                            7'b0: 
                            begin
                                alu_control = 4'b0101; //srl
                            end

                            7'b0100000: 
                            begin
                                alu_control = 4'b1101; //sra
                            end

                            default: alu_control = 4'b0000;
                        endcase    

                    3'b010: alu_control = 4'b0111; //slt

                    3'b011: alu_control = 4'b1111; //sltu                


                    default: alu_control = 4'b0000;
                endcase
            end

            2'b11:
            begin // I-Type Arith Instructions
                case (funct3)
                    3'b000: alu_control = 4'b0010; //ADDi

                    3'b111: alu_control = 4'b0000; // ANDi

                    3'b110: alu_control = 4'b0001; // ORi

                    3'b100: alu_control = 4'b0011; //xori

                    3'b001: alu_control = 4'b0100; // slli

                    3'b101: //srl and sra
                        case (funct7)
                            7'b0: 
                            begin
                                alu_control = 4'b0101; //srli
                            end

                            7'b0100000: 
                            begin
                                alu_control = 4'b1101; //srai
                            end

                            default: alu_control = 4'b0000;
                        endcase                    

                    3'b010: alu_control = 4'b0111; //slti

                    3'b011: alu_control = 4'b1111; //sltiu

                    default: alu_control = 4'b0000;
                endcase
            end


            
            default: alu_control = 4'b0000;
        endcase
    end
endmodule