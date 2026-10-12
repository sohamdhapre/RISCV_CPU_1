module memory_cu (
    input wire clk,
    input wire mem_read,
    input wire mem_write,
    input wire [31:0] alu_out,      // The calculated memory address from the ALU
    input wire [31:0] store_data,   // The data to write (routed from rs2)
    output reg [31:0] read_data     // The data sent back to the Register File
);

    wire [31:0] raw_mem_data;

    // 1. Memory Instantiation & Byte-to-Word Translation
    memory data_ram (
        .clk(clk),
        .write_enable(mem_write),
        .word_address({2'b00, alu_out[31:2]}), // Shift right by 2
        .write_data(store_data),
        .read_data(raw_mem_data)
    );

    // 2. Read Guard Logic
    always @(*) begin
        if (mem_read) begin
            read_data = raw_mem_data;
        end else begin
            read_data = 32'b0; 
        end
    end

endmodule