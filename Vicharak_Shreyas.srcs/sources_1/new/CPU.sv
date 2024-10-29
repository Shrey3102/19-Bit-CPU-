module CPU (
    input  logic        clk,
    input  logic        rst,
    input  logic [18:0] instruction,
    output logic [18:0] results
);
    logic [4:0]  opcode;
    logic [3:0]  rs1, rs2, rd;
    logic [9:0]  immediate;
    logic [18:0] RegData1, RegData2, ALUresult, DataMem;
    logic        RegWrite, MemRead, MemWrite, branch, jump, FFTstart;
    logic [18:0] FFT_realIN [0:7], FFT_imagIN [0:7], FFT_realOUT [0:7], FFT_imagOUT [0:7];
    logic        FFTdone;


    ControlUnit ctrl_unit (
        .instruction(instruction),
        .opcode(opcode),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .immediate(immediate),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .branch(branch),
        .jump(jump),
        .FFTstart(FFTstart)
    );


    RegisterUnit reg_file (
        .clk(clk),
        .rst(rst),
        .ReadAddr1(rs1),
        .ReadAddr2(rs2),
        .WriteAddr(rd),
        .WriteData(results),
        .WriteEN(RegWrite),
        .ReadData1(RegData1),
        .ReadData2(RegData2)
    );

   
    ALU_Unit alu_unit (
        .opcode(opcode),
        .operand1(RegData1),
        .operand2(RegData2),
        .results(ALUresult)
    );

    
    MemoryUnit mem_unit (
        .clk(clk),
        .address(ALUresult),
        .WriteData(RegData2),
        .WriteEN(MemWrite),
        .ReadData(DataMem)
    );

   
    FFT fft_unit (
        .clk(clk),
        .reset(~rst),
        .start(FFTstart),
        .real_in(FFT_realIN),
        .imag_in(FFT_imagIN),
        .real_out(FFT_realOUT),
        .imag_out(FFT_imagOUT),
        .done(FFTdone)
    );

   
    always_ff @(posedge clk) begin
        if (!rst) begin
            for (int i = 0; i < 8; i++) begin
                FFT_realIN[i] <= 19'b0;
                FFT_imagIN[i] <= 19'b0;
            end
        end else if (FFTstart) begin
            FFT_realIN[0] <= RegData1;
            FFT_imagIN[0] <= RegData2;
        end
    end

  
    always_comb begin
        case (opcode)
            LD:     results = DataMem;
            FFT:    results = FFTdone ? FFT_realOUT[0] : 19'b0;
            default: results = ALUresult;
        endcase
    end
endmodule
