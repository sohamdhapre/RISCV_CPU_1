module instruction_fetcher 
(
    input wire [31:0] current_pc,
    output wire [31:0] current_instruction
);

    reg [31:0] instruction_memory [0:255];

    initial 
    begin
        $readmemh("program.hex", instruction_memory);
    end

    assign current_instruction = instruction_memory[current_pc[31:2]];

endmodule