typedef enum logic[4:0] {
    ADD  = 5'b00000,
    SUB  = 5'b00001,
    MUL  = 5'b00010,
    DIV  = 5'b00011,
    INCR = 5'b00100,
    DECR = 5'b00101,
    AND  = 5'b00110,
    OR   = 5'b00111,
    XOR  = 5'b01000,
    NOT  = 5'b01001,
    JMP  = 5'b01010,
    BEQ  = 5'b01011,
    BNE  = 5'b01100,
    CALL = 5'b01101,
    RET  = 5'b01110,
    LD   = 5'b01111,
    ST   = 5'b10000,
    FFT  = 5'b10001,
    ENC  = 5'b10010,
    DEC  = 5'b10011
} Opcode_T;
module ALU_Unit (
    input  logic [4:0]  opcode,
    input  logic [18:0] operand1,
    input  logic [18:0] operand2,
    output logic [18:0] results
);
    always_comb begin
        case (opcode)
            ADD:  results = operand1 + operand2;
            SUB:  results = operand1 - operand2;
            MUL:  results = operand1 * operand2;
            DIV:  results = operand1 / operand2;
            INCR: results = operand1 + 1;
            DECR: results = operand1 - 1;
            AND:  results = operand1 & operand2;
            OR:   results = operand1 | operand2;
            XOR:  results = operand1 ^ operand2;
            NOT:  results = ~operand1;
            default: results = 19'b0;
        endcase
    end
endmodule