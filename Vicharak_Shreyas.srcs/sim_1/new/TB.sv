`timescale 1ns / 1ps

module CPU_tb;

    // Testbench signals
    logic clk;
    logic rst;
    logic [18:0] instruction;
    logic [18:0] results;

    // Instantiate the CPU
    CPU uut (
        .clk(clk),
        .rst(rst),
        .instruction(instruction),
        .results(results)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns clock period
    end

    // Reset task
    task apply_reset();
        begin
            rst = 0;
            #20;
            rst = 1;
        end
    endtask

    // Task to apply and check instructions
    task test_instruction(input [18:0] instr, input [18:0] expected_result, input string instr_name);
        begin
            instruction = instr;
            #20; // Wait for CPU to process the instruction
            if (results !== expected_result) begin
                $display("ERROR: %s failed. Expected: %0d, Got: %0d", instr_name, expected_result, results);
            end else begin
                $display("PASS: %s succeeded. Result: %0d", instr_name, results);
            end
        end
    endtask

    // Test sequence
    initial begin
        // Apply reset
        apply_reset();

        // Test ADD (assume rs1 = 1, rs2 = 1, rd = 3, expected result = 2)
        test_instruction({5'b00000, 4'b0001, 4'b0001, 4'b0011}, 19'd2, "ADD");

        // Test SUB (assume rs1 = 5, rs2 = 3, rd = 3, expected result = 2)
        test_instruction({5'b00001, 4'b0101, 4'b0011, 4'b0011}, 19'd2, "SUB");

        // Test MUL (assume rs1 = 2, rs2 = 2, rd = 3, expected result = 4)
        test_instruction({5'b00010, 4'b0010, 4'b0010, 4'b0011}, 19'd4, "MUL");

        // Test LD (Load), assume memory returns value 10 at address
        test_instruction({5'b01111, 4'b0001, 4'b0000, 4'b0010}, 19'd10, "LD");

        // Test AND
        test_instruction({5'b00110, 4'b0001, 4'b0010, 4'b0011}, 19'd0, "AND");

        // Test OR
        test_instruction({5'b00111, 4'b0001, 4'b0010, 4'b0011}, 19'd3, "OR");

        // Test XOR
        test_instruction({5'b01000, 4'b0001, 4'b0010, 4'b0011}, 19'd3, "XOR");

        // Test FFT (initialize FFT start to test functionality)
        test_instruction({5'b10001, 4'b0000, 4'b0000, 4'b0000}, 19'd0, "FFT");

        // Finish simulation
        #20;
        $finish;
    end

    // Monitor all values
    initial begin
        $monitor("Time: %0t | Instruction: %b | Result: %d", $time, instruction, results);
    end

endmodule
