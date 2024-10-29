module ControlUnit (
    input  logic [18:0] instruction,
    output logic [4:0]  opcode,
    output logic [3:0]  rs1,
    output logic [3:0]  rs2,
    output logic [3:0]  rd,
    output logic [9:0]  immediate,
    output logic        RegWrite,
    output logic        MemRead,
    output logic        MemWrite,
    output logic        branch,
    output logic        jump,
    output logic        FFTstart
);
    always_comb begin
        opcode = instruction[18:14];
        rs1 = instruction[13:10];
        rs2 = instruction[9:6];
        rd = instruction[5:2];
        immediate = instruction[9:0];
        RegWrite = 0;
        MemRead = 0;
        MemWrite = 0;
        branch = 0;
        jump = 0;
        FFTstart = 0;
        case (opcode)
            ADD, SUB, MUL, DIV, AND, OR, XOR, NOT: RegWrite = 1;
            INCR, DECR: RegWrite = 1;
            LD: begin
                RegWrite = 1;
                MemRead = 1;
            end
            ST: MemWrite = 1;
            BEQ, BNE: branch = 1;
            JMP, CALL: jump = 1;
            RET: jump = 1;
            FFT: begin
                RegWrite = 1;
                FFTstart = 1;
            end
            ENC, DEC: RegWrite = 1;
        endcase
    end
endmodule