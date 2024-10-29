# Custom 19-bit CPU Architecture

This repository contains the implementation of a custom 19-bit CPU architecture, developed in SystemVerilog, with a specialized instruction set and core components, including a Control Unit, Register Unit, ALU, Memory Unit, and FFT functionality.

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Instruction Set](#instruction-set)
- [Components](#components)
- [Contributing](#contributing)


---

## Overview

The custom 19-bit CPU is designed to support basic arithmetic, logical, memory, and FFT operations, with each instruction being 19 bits wide. This design is intended to provide hands-on experience in designing and testing a CPU architecture from scratch using SystemVerilog.

## Architecture

The CPU architecture consists of the following modules:

1. **Control Unit** - Decodes instructions, controls operations, and initiates various signals.
2. **Register Unit** - Handles register read and write operations.
3. **ALU** - Performs arithmetic and logical operations.
4. **Memory Unit** - Reads and writes data to memory.
5. **FFT Unit** - Performs Fast Fourier Transform (FFT) operations.

## Instruction Set

| Opcode | Instruction | Description                  |
|--------|-------------|------------------------------|
| 00000  | ADD         | Addition                     |
| 00001  | SUB         | Subtraction                  |
| 00010  | MUL         | Multiplication               |
| 01111  | LD          | Load data from memory        |
| 00110  | AND         | Logical AND                  |
| 00111  | OR          | Logical OR                   |
| 01000  | XOR         | Logical XOR                  |
| 10001  | FFT         | Perform FFT on input data    |

## Components

Each component in the CPU is encapsulated in a SystemVerilog module, facilitating modular testing and design flexibility.

### Control Unit

The `ControlUnit` module decodes the instruction and sets control signals like `RegWrite`, `MemRead`, `MemWrite`, `branch`, `jump`, and `FFTstart`.

### Register Unit

The `RegisterUnit` module manages read and write operations for the registers, interfacing with ALU inputs and instruction fields.

### ALU

The `ALU_Unit` module performs arithmetic and logical operations based on the opcode and outputs the result for further processing.

### Memory Unit

The `MemoryUnit` module reads data from or writes data to memory locations based on the ALU output.

### FFT Unit

The `FFT` module performs Fast Fourier Transform (FFT) operations, using real and imaginary data inputs.

## Setup and Usage

### Prerequisites

To simulate and test this CPU, ensure you have a SystemVerilog-compatible simulator (e.g., ModelSim, QuestaSim, or Vivado) installed.



## Contributing

Contributions are welcome! If you'd like to improve the architecture, fix issues, or add new features, please follow these steps:

1. Fork this repository.
2. Create a feature branch (`git checkout -b feature-branch`).
3. Commit your changes (`git commit -m 'Add new feature'`).
4. Push to the branch (`git push origin feature-branch`).
5. Open a pull request.


