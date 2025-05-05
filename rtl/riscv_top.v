module riscv_top (
    input clk,
    input reset
);
    // PC signals
    wire [31:0] pc;
    wire [31:0] next_pc;
    
    // Instruction memory signals
    wire [31:0] instruction;
    
    // Control unit signals
    wire reg_write;
    wire alu_src;
    wire mem_to_reg;
    wire mem_read;
    wire mem_write;
    wire branch;
    wire [1:0] alu_op;
    wire [1:0] imm_src;
    
    // Register file signals
    wire [31:0] read_data1;
    wire [31:0] read_data2;
    wire [31:0] write_data;
    
    // ALU signals
    wire [31:0] alu_result;
    wire alu_zero;
    wire [3:0] alu_control;
    
    // Sign extend signals
    wire [31:0] imm_ext;
    
    // Data memory signals
    wire [31:0] mem_read_data;
    
    // Internal signals
    wire [31:0] alu_src_b;
    wire pc_src;
    wire [31:0] pc_plus_4;
    wire [31:0] pc_branch;
    
    // Instantiate PC
    pc pc_inst (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .current_pc(pc)
    );
    
    // PC + 4
    assign pc_plus_4 = pc + 32'd4;
    
    // PC branch target
    assign pc_branch = pc + imm_ext;
    
    // PC source mux
    assign pc_src = branch & alu_zero;
    assign next_pc = pc_src ? pc_branch : pc_plus_4;
    
    // Instruction memory
    instruction_memory imem (
        .pc(pc),
        .instruction(instruction)
    );
    
    // Control unit
    control_unit control (
        .opcode(instruction[6:0]),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_to_reg(mem_to_reg),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .branch(branch),
        .alu_op(alu_op),
        .imm_src(imm_src)
    );
    
    // Register file
    register_file reg_file (
        .clk(clk),
        .reset(reset),
        .reg_write(reg_write),
        .read_reg1(instruction[19:15]),
        .read_reg2(instruction[24:20]),
        .write_reg(instruction[11:7]),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );
    
    // Sign extend
    sign_extend sign_ext (
        .instruction(instruction),
        .imm_src(imm_src),
        .imm_ext(imm_ext)
    );
    
    // ALU source mux
    assign alu_src_b = alu_src ? imm_ext : read_data2;
    
    // ALU control
    // assign alu_control[3] = alu_op[0] | (alu_op[1] & instruction[30]);
    // assign alu_control[2] = ~alu_op[1] | ~instruction[14];
    // assign alu_control[1] = alu_op[1] & (instruction[13] | instruction[14]);
    // assign alu_control[0] = alu_op[1] & (instruction[12] | instruction[13]);
    // 新控制信号生成逻辑（更清晰的优先级）
    assign alu_control = 
    (alu_op == 2'b00) ? 4'b0010 :               // I-type (addi/lw/sw): ADD
    (alu_op == 2'b01) ? 4'b0110 :               // Branch: SUB
    // R-type指令
    (instruction[14:12] == 3'b000) ? 
        (instruction[30] ? 4'b0110 : 4'b0010) : // ADD/SUB
    (instruction[14:12] == 3'b111) ? 4'b0000 :  // AND
    (instruction[14:12] == 3'b110) ? 4'b0001 :  // OR
    (instruction[14:12] == 3'b100) ? 4'b1000 :  // XOR
    (instruction[14:12] == 3'b010) ? 4'b0111 :  // SLT
    (instruction[14:12] == 3'b001) ? 4'b1001 :  // SLL
    (instruction[14:12] == 3'b101) ? 
        (instruction[30] ? 4'b1011 : 4'b1010) : // SRL/SRA
    4'b0000;                                    // Default
    
    // ALU
    alu alu_inst (
        .a(read_data1),
        .b(alu_src_b),
        .alu_control(alu_control),
        .result(alu_result),
        .zero(alu_zero)
    );
    
    // Data memory
    data_memory dmem (
        .clk(clk),
        .addr(alu_result),
        .write_data(read_data2),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .read_data(mem_read_data)
    );
    
    // Write back mux
    assign write_data = mem_to_reg ? mem_read_data : alu_result;
endmodule
