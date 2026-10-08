module register_file 
(
    input wire clk,
    input wire write_enable,
    input wire [4:0] rs1,          // Read register 1 address
    input wire [4:0] rs2,          // Read register 2 address
    input wire [4:0] rd,           // Write register address
    input wire [31:0] write_data,  // Data to write
    output wire [31:0] read_data1, // Data from rs1
    output wire [31:0] read_data2  // Data from rs2
);

    reg [31:0] registers [31:0];

    assign read_data1 = (rs1 == 5'b00000) ? 32'h00000000 : registers[rs1];
    assign read_data2 = (rs2 == 5'b00000) ? 32'h00000000 : registers[rs2];

    always @(posedge clk) 
    begin
        if (write_enable && (rd != 5'b00000)) begin
            registers[rd] <= write_data;
        end
    end

endmodule