module data_memory (
    input clk,
    /* verilator lint_off UNUSEDSIGNAL */
    input [31:0] addr,
    /* verilator lint_off UNUSEDSIGNAL */
    input [31:0] write_data,
    input mem_read,
    input mem_write,
    output reg [31:0] read_data
);
    reg [31:0] memory [0:255]; // 1KB memory
    
    always @(posedge clk) begin
        if (mem_write) begin
            memory[addr[9:2]] <= write_data;
        end
    end
    
    always @(*) begin
        if (mem_read) begin
            read_data = memory[addr[9:2]];
        end else begin
            read_data = 32'd0;
        end
    end
    
    initial begin
        // Initialize memory
        for (integer i = 0; i < 256; i = i + 1) begin
            memory[i] = 32'd0;
        end
    end
endmodule
