`timescale 1ns/1ps

module tern_mult_tb;

// Inputs
logic signed [7:0] list_in [4095:0];
logic signed [1:0] weight_matrix [4095:0][4095:0];
logic clk;

// Outputs
logic signed [19:0] product_list [4095:0];

// Instantiate the module under test
vector_ternary_multiplication dut (
    .list_in(list_in),
    .weight_matrix(weight_matrix),
    .clk(clk),
    .product_list(product_list)
);

// Clock generation
always begin
    #1 clk = ~clk; // Toggle clock every time unit
end

// Initialize inputs
initial begin
    clk = 0;

    // Verification at a glance
    $display("Running verification at a glance tests...");

    // Test case 1: All zeros
    for (int i = 0; i < 4096; i++) begin
        list_in[i] = 0;
        for (int j = 0; j < 4096; j++) begin
            weight_matrix[i][j] = 0;
        end
    end
    #4100; // Wait for computations to complete
    for (int i = 0; i < 4096; i++) begin
        assert (product_list[i] === 0) else $error("Error in all zeros test: Expected 0, got %d for index %d", product_list[i], i);
    end
    $display("All zeros test passed");

    // Test case 2: All ones
    for (int i = 0; i < 4096; i++) begin
        list_in[i] = 8'd127;
        for (int j = 0; j < 4096; j++) begin
            weight_matrix[i][j] = 2'd1;
        end
    end
    #4100; // Wait for computations to complete
    for (int i = 0; i < 4096; i++) begin
        assert (product_list[i] === 20'd520192) else $error("Error in all ones test: Expected 520192, got %d for index %d", product_list[i], i);
    end
    $display("All ones test passed");

    // Numerical robustness
    $display("Running numerical robustness tests...");
    for (int i = 0; i < 100; i++) begin
        int start_index = $unsigned($random) % 4064; // Random start index (0 to 4063)
        int subset_size = $unsigned($random) % 32 + 1; // Random subset size (1 to 32)

        for (int j = start_index; j < start_index + subset_size; j++) begin
            list_in[j] = $signed($random) % 256;
            for (int k = 0; k < 4096; k++) begin
                weight_matrix[j][k] = $signed($random) % 3 - 1;
            end
        end

        #4100; // Wait for computations to complete

        for (int j = start_index; j < start_index + subset_size; j++) begin
            logic signed [19:0] expected_result = 0;
            for (int k = 0; k < 4096; k++) begin
                expected_result += list_in[j] * weight_matrix[j][k];
            end
            assert (product_list[j] === expected_result) else $error("Error in numerical robustness test %d: Expected %d, got %d for index %d", i, expected_result, product_list[j], j);
        end
    end
    $display("Numerical robustness tests passed");

    $finish;
end

endmodule