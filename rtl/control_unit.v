module control_unit (
    input [6:0] opcode,
    output reg reg_write,
    output reg alu_src,
    output reg mem_to_reg,
    output reg mem_read,
    output reg mem_write,
    output reg branch,
    output reg [1:0] alu_op,
    output reg [1:0] imm_src
);
    always @(*) begin
        case (opcode)
            7'b0110011: begin // R-type
                reg_write = 1'b1;
                alu_src = 1'b0;
                mem_to_reg = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b0;
                alu_op = 2'b10;
                imm_src = 2'b00;
            end
            7'b0000011: begin // lw
                reg_write = 1'b1;
                alu_src = 1'b1;
                mem_to_reg = 1'b1;
                mem_read = 1'b1;
                mem_write = 1'b0;
                branch = 1'b0;
                alu_op = 2'b00;
                imm_src = 2'b00;
            end
            7'b0100011: begin // sw
                reg_write = 1'b0;
                alu_src = 1'b1;
                mem_to_reg = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b1;
                branch = 1'b0;
                alu_op = 2'b00;
                imm_src = 2'b01;
            end
            7'b1100011: begin // beq
                reg_write = 1'b0;
                alu_src = 1'b0;
                mem_to_reg = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b1;
                alu_op = 2'b01;
                imm_src = 2'b10;
            end
            7'b0010011: begin // I-type (addi, etc.)
                reg_write = 1'b1;
                alu_src = 1'b1;
                mem_to_reg = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b0;
                alu_op = 2'b00;
                imm_src = 2'b00;
            end
            default: begin
                reg_write = 1'b0;
                alu_src = 1'b0;
                mem_to_reg = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b0;
                alu_op = 2'b00;
                imm_src = 2'b00;
            end
        endcase
    end
endmodule
