# Systolic Array for Matrix Multiplication
SystemVerilog | RTL Design | Pipelined Processing Elements

## Overview
This project implements a parameterized N×N systolic array for parallel matrix multiplication.
The design consists of a grid of Processing Elements (PEs), where each PE performs multiply-accumulate operations while data propagates through the array in a pipelined manner.
Matrix A elements are fed into the array from the left, while Matrix B elements are fed from the top. Partial products are accumulated within the processing elements to generate the resulting matrix.

## Specifications
- Parameterized data width: `DATAWIDTH = 16`
- Parameterized array size: `N_SIZE = 5`
- N×N processing-element architecture
- Synchronized clock and reset
- Valid input and output signals
- Pipelined multiply-accumulate operations
- Matrix multiplication using systolic data flow

## Interface

### Inputs
- `clk` – Positive-edge clock
- `rst_n` – Active-low reset
- `valid_in` – Indicates valid input matrix data
- `matrix_a_in` – Input elements from matrix A
- `matrix_b_in` – Input elements from matrix B

### Outputs
- `valid_out` – Indicates valid output data
- `matrix_c_out` – Resulting matrix elements

## Architecture

The systolic array consists of N×N Processing Elements.

Each Processing Element:

1. Receives input data from neighboring elements.
2. Performs a multiply operation.
3. Accumulates the multiplication result.
4. Passes the required data to the next Processing Element.

The pipelined structure allows multiple multiply-accumulate operations to take place concurrently.

## Current Status

The project is **partially completed**.

The RTL architecture and systolic-array implementation were developed, along with the corresponding testbench and simulation analysis.
However, the implementation does not yet achieve complete functional correctness for all required cases.
Further improvements and debugging are required, as documented in the project report.

## Tools

- SystemVerilog
- QuestaSim
- VS Code

## Author
Raghad Waleed
