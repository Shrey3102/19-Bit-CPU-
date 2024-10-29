`timescale 1ns / 1ps

module RegisterUnit (
    input  logic        clk,
    input  logic        rst,
    input  logic [3:0]  ReadAddr1,
    input  logic [3:0]  ReadAddr2,
    input  logic [3:0]  WriteAddr,
    input  logic [18:0] WriteData,
    input  logic        WriteEN,
    output logic [18:0] ReadData1,
    output logic [18:0] ReadData2
);
    logic [18:0] registers[16];
    always_ff @(posedge clk ) begin
        if (!rst) begin
            for (int i = 0; i < 16; i++) begin
                registers[i] <= 19'b0;
            end
        end else if (WriteEN) begin
            registers[WriteAddr] <= WriteData;
        end
    end
    assign ReadData1 = registers[ReadAddr1];
    assign ReadData2 = registers[ReadAddr2];
endmodule
