`timescale 1ns/1ps

`include "ADDER/adder.v"
`include "TWOS/twos.v"

module vector_ternary_multiplication (
    input signed [7:0] list_in [4095:0],
    input signed [1:0] weight_matrix [4095:0][4095:0],
    input logic clk,
    input logic rst,
    output logic signed [19:0] product_list [4095:0]
);
    // Parameters and internal signals
    localparam VECTOR_SIZE = 4096;
    localparam DATA_WIDTH = 8;
    localparam RESULT_WIDTH = 20;

    logic signed [DATA_WIDTH-1:0] data_values [VECTOR_SIZE-1:0];
    logic signed [DATA_WIDTH-1:0] original_data [VECTOR_SIZE-1:0];
    logic signed [DATA_WIDTH-1:0] data_values_twos_complement [VECTOR_SIZE-1:0];
    logic signed [RESULT_WIDTH-1:0] partial_sums; // partial sums es un solo registro integer de 20 bits con signo
    logic signed [DATA_WIDTH-1:0] temp_product_list [VECTOR_SIZE-1:0];

    integer i, j;

    // Parse input data
    always_comb begin
        for (i = 0; i < VECTOR_SIZE; i = i + 1) begin
            data_values[i] = list_in[i];
        end
    end

    // Instantiate the two's complement module
    twos_complement_list twos_inst (
        .clk(clk),
        .data_in(data_values),
        .original_data(original_data),
        .twos_complement(data_values_twos_complement)
    );

    // Parallel MUX controlled by weight matrix
    always_comb begin
        for (i = 0; i < VECTOR_SIZE; i = i + 1) begin
            temp_product_list[i] = 0; // Initialize accumulator
            for (j = 0; j < VECTOR_SIZE; j = j + 1) begin
                case (weight_matrix[i][j])
                    2'b00: temp_product_list[i] = temp_product_list[i];
                    2'b01: temp_product_list[i] = temp_product_list[i] + original_data[j];
                    2'b10: temp_product_list[i] = temp_product_list[i] + data_values_twos_complement[j];
                    default: temp_product_list[i] = temp_product_list[i];
                endcase
            end
        end
    end

    // Instantiate the tree adder
    tree_adder adder_tree_inst (
        .clk(clk),
        .numbers(temp_product_list),
        .total_sum(partial_sums)
    );

    // Controller for output coordination
    reg [12:0] cycle_count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cycle_count <= 0;
        end else begin
            if (cycle_count < VECTOR_SIZE) begin
                cycle_count <= cycle_count + 1;
            end
        end
    end

    // DeMUX and output assignment
    always_comb begin
        if (cycle_count < VECTOR_SIZE) begin
            product_list[cycle_count] = partial_sums;
        end else begin
            product_list[cycle_count] = '0; // Keep output zero while calculating
        end
    end

endmodule
