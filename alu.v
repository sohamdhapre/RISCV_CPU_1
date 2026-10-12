module alu
(
    input  wire [3:0]  alu_control,
    input  wire [31:0] src1,
    input  wire [31:0] src2,
    output reg  [31:0] out,
    output wire        zero
);

    // Combinational evaluation of the zero flag
    assign zero = (out == 32'b0);

    always @(*) 
    begin
        case (alu_control)
            4'b0010: 
            begin // ADD
                out = src1 + src2;
            end
            
            4'b0110: 
            begin // SUB
                out = src1 - src2;
            end
            
            4'b0000: 
            begin // AND
                out = src1 & src2;
            end
            
            4'b0001: 
            begin // OR
                out = src1 | src2;
            end

            4'b0011: //xor
            begin
                out = src1 ^ src2;
            end

            4'b1101: 
            begin // SRA 
                out = $signed(src1) >>> src2[4:0];
            end
            4'b0101: 
            begin // SRL 
                out = src1 >> src2[4:0];
            end
            4'b0100:
            begin: SLL
                out = src1 << src2[4:0];
            end

            4'b0111: // SLT (Signed)
            begin
                out = ($signed(src1) < $signed(src2)) ? 32'b1 : 32'b0;
            end
            
            4'b1111: // SLTU (Unsigned)
            begin
                out = (src1 < src2) ? 32'b1 : 32'b0;
            end

            
            default: begin
                out = 32'b0;
            end
        endcase
    end

endmodule