module MemoryUnit (
    input  logic        clk,
    input  logic [18:0] address,
    input  logic [18:0] WriteData,
    input  logic        WriteEN,
    output logic [18:0] ReadData
);
    logic [18:0] memory [2**19];
    always_ff @(posedge clk) begin
        if (WriteEN) begin
            memory[address] <= WriteData;
        end
    end
    assign ReadData = memory[address];
endmodule