module memory (
    input wire clk,
    input wire write_enable,
    input wire [31:0] word_address, 
    input wire [31:0] write_data,
    output wire [31:0] read_data
);

    // 1. Storage Array: 256 words of 32-bit memory (1KB total)
    reg [31:0] ram [0:255];

    // 2. Synchronous Write
    always @(posedge clk) begin
        if (write_enable) begin
            ram[word_address[7:0]] <= write_data;
        end
    end

    // 3. Asynchronous Read (Required for Single-Cycle)
    assign read_data = ram[word_address[7:0]];

endmodule