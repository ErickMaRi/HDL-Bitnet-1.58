`timescale 1ns/1ps
module vector_ternary_multiplication (
    input signed [7:0] list_in [4095:0],
    input signed [1:0] weight_matrix [4095:0][4095:0],
    input logic clk,
    input logic rst,
    output logic signed [19:0] product_list [4095:0]
    );

    localparam VECTOR_SIZE = 4096;
    localparam CHUNK_SIZE = 256; // Ajusta este valor según sea necesario

    logic signed [7:0] selected_value;
    logic signed [20:0] partial_sum;

    integer i, j, k, chunk_start, chunk_end;

    logic signed [7:0] chunk_values [VECTOR_SIZE-1:0]; // Asegúrate que sea de 4096 elementos
    logic signed [1:0] chunk_weights [VECTOR_SIZE-1:0]; // Asegúrate que sea de 4096 elementos

    logic signed [20:0] tree_adder_input [VECTOR_SIZE-1:0];
    logic signed [19:0] tree_adder_output;

    logic signed [7:0] original_data [4095:0];
    logic signed [7:0] twos_complement [4095:0];

    tree_adder tree_adder_inst (
        .clk(clk),
        .numbers(chunk_values), // Asegúrate que sea del tamaño correcto
        .total_sum(tree_adder_output)
    );

    twos_complement_list twos_complement_inst (
        .clk(clk),
        .data_in(list_in),
        .original_data(original_data),
        .twos_complement(twos_complement)
    );

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < VECTOR_SIZE; i++) begin
                product_list[i] <= 0;
            end
        end else begin
            for (i = 0; i < VECTOR_SIZE; i++) begin
                for (j = 0; j < VECTOR_SIZE; j++) begin
                    case (weight_matrix[i][j])
                        2'b01: selected_value = original_data[j];
                        2'b11: selected_value = twos_complement[j];
                        default: selected_value = 0;
                    endcase

                    chunk_values[j] = selected_value;
                    chunk_weights[j] = weight_matrix[i][j];
                end

                partial_sum = 0;
                for (j = 0; j < VECTOR_SIZE; j++) begin
                    tree_adder_input[j] = (chunk_weights[j] != 2'b00) ? chunk_values[j] : 0;
                    partial_sum += tree_adder_input[j];
                end

                product_list[i] <= partial_sum[19:0];
            end
        end
    end

endmodule
