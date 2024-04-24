

module vector_ternary_multiplication (
    input signed [7:0] list_in [4095:0],
    input signed [1:0] weight_matrix [4095:0][4095:0],
    input logic clk,
    output logic signed [19:0] product_list [4095:0]
);

`include "DEMUXERS/demuxers.v" // Include demuxer_array module
`include "TWOS/twos.v" // Include twos_complement_list module
`include "ADDER/adder.v" // Include tree_adder module

// Generate negated values using twos_complement_list
logic signed [7:0] neg_list [4095:0];
logic signed [7:0] orig_list [4095:0];

twos_complement_list negate_inst (
    .data_in(list_in),
    .clk(clk),
    .twos_complement(neg_list),
    .original_data(orig_list)
);

// Perform selection based on weights using demuxer_array
logic signed [7:0] selected_list [4095:0][4096:0];

genvar i, j;
generate
    for (i = 0; i < 4096; i = i + 1) begin : demux_instances
        demuxer_array demux_inst (
            .A_list(orig_list[i:i]),
            .B_list(neg_list[i:i]),
            .control_list(weight_matrix[i]),
            .clk(clk),
            .Y_list(selected_list[i])
        );
    end
endgenerate

// Add the selected elements using tree_adder
generate
    for (i = 0; i < 4096; i = i + 1) begin : adder_instances
        tree_adder adder_inst (
            .clk(clk),
            .numbers(selected_list[i]),
            .total_sum(product_list[i])
        );
    end
endgenerate

endmodule