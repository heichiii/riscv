module instruction_memory (
    /* verilator lint_off UNUSEDSIGNAL */
    input [31:0] pc,
    /* verilator lint_off UNUSEDSIGNAL */
    output [31:0] instruction
);
    reg [31:0] memory [0:255]; // 1KB memory
    
    assign instruction = memory[pc[9:2]]; // Word aligned
    
    initial begin
        $readmemh("test.hex", memory); // Load instructions from hex file
    end
endmodule
