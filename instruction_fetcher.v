module instruction_fetcher 
(
    input wire [31:0] current_pc,
    output wire [31:0] current_instruction
);

    reg [31:0] memory [0:255];

    initial 
    begin
        $readmemh("program.hex", memory);
    end

    assign current_instruction = memory[current_pc[31:2]];

endmodule