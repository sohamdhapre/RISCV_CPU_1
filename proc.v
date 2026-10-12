module proc (
    input wire clk,
    input wire reset
);

    // ==========================================
    // 1. Internal Wire Declarations
    // ==========================================
    // PC & Instruction
    wire [31:0] pc_current;
    wire [31:0] pc_next;
    wire [31:0] pc_plus_4;
    wire [31:0] pc_branch_target;
    wire [31:0] instruction;
    
    // Control Signals
    wire        ctrl_branch;
    wire        ctrl_mem_read;
    wire        ctrl_mem_to_reg;
    wire [1:0]  ctrl_alu_op;
    wire        ctrl_mem_write;
    wire        ctrl_alu_src_2;
    wire        ctrl_reg_write;
    wire [3:0]  alu_ctrl_code;

    // Register File & Immediate
    wire [31:0] reg_read_data1;
    wire [31:0] reg_read_data2;
    wire [31:0] reg_write_data;
    wire [31:0] imm_val;

    // ALU & Memory
    wire [31:0] alu_operand2;
    wire [31:0] alu_result;
    wire        alu_zero_flag;
    wire [31:0] mem_read_data;
    
    wire        pc_src; // The final branch decision flag


    // ==========================================
    // 2. Fetch Stage
    // ==========================================
    // Multiplexer for next PC (Branch vs PC+4)
    assign pc_plus_4 = pc_current + 32'd4;
    assign pc_src = ctrl_branch & alu_zero_flag;
    assign pc_next = (pc_src) ? pc_branch_target : pc_plus_4;

    program_counter_reg pc_reg_inst (
        .clk(clk),
        .reset(reset),
        .next_pc(pc_next),
        .current_pc(pc_current)
    );

    instruction_fetcher fetch_inst (
        .current_pc(pc_current),
        .current_instruction(instruction)
    );


    // ==========================================
    // 3. Decode Stage
    // ==========================================
    main_control main_ctrl_inst (
        .opcode(instruction[6:0]),
        .branch(ctrl_branch),
        .mem_read(ctrl_mem_read),
        .mem_to_reg(ctrl_mem_to_reg),
        .alu_op(ctrl_alu_op),
        .mem_write(ctrl_mem_write),
        .alu_src_2(ctrl_alu_src_2),
        .reg_write(ctrl_reg_write)
    );

    register_file reg_file_inst (
        .clk(clk),
        .write_enable(ctrl_reg_write),
        .rs1(instruction[19:15]),
        .rs2(instruction[24:20]),
        .rd(instruction[11:7]),
        .write_data(reg_write_data),
        .read_data1(reg_read_data1),
        .read_data2(reg_read_data2)
    );

    immediate_generator imm_gen_inst (
        .instruction_word(instruction),
        .immediate(imm_val)
    );


    // ==========================================
    // 4. Execute Stage
    // ==========================================
    alu_control alu_ctrl_inst (
        .alu_op(ctrl_alu_op),
        .funct3(instruction[14:12]),
        .funct7(instruction[31:25]),
        .alu_control(alu_ctrl_code)
    );

    // ALU Operand 2 Multiplexer (Register vs Immediate)
    assign alu_operand2 = (ctrl_alu_src_2) ? imm_val : reg_read_data2;

    // Branch Target Adder
    assign pc_branch_target = pc_current + imm_val;

    alu alu_inst (
        .alu_control(alu_ctrl_code),
        .src1(reg_read_data1),
        .src2(alu_operand2),
        .out(alu_result),
        .zero(alu_zero_flag)
    );


    // ==========================================
    // 5. Memory & Writeback Stage
    // ==========================================
    memory_cu mem_ctrl_inst (
        .clk(clk),
        .mem_read(ctrl_mem_read),
        .mem_write(ctrl_mem_write),
        .alu_out(alu_result),
        .store_data(reg_read_data2),
        .read_data(mem_read_data)
    );

    // Writeback Multiplexer (ALU Result vs Memory Data)
    assign reg_write_data = (ctrl_mem_to_reg) ? mem_read_data : alu_result;

endmodule