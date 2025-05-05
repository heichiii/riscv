module sign_extend (
    /* verilator lint_off UNUSEDSIGNAL */
    input [31:0] instruction,
    /* verilator lint_off UNUSEDSIGNAL */
    input [1:0] imm_src,
    output reg [31:0] imm_ext
);
    always @(*) begin
        case (imm_src)
            2'b00: imm_ext = {{20{instruction[31]}}, instruction[31:20]}; // I-type
            2'b01: imm_ext = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; // S-type
            2'b10: imm_ext = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0}; // B-type
            default: imm_ext = 32'd0;
        endcase
    end
endmodule
