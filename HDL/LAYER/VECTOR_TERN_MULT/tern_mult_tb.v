`timescale 1ns/1ps

module vector_ternary_multiplication_tb;
    localparam VECTOR_SIZE = 4096;
    localparam CHUNK_SIZE = 256; // Adjust this value as needed

    logic signed [7:0] list_in [VECTOR_SIZE-1:0];
    logic signed [1:0] weight_matrix [VECTOR_SIZE-1:0][VECTOR_SIZE-1:0];
    logic clk;
    logic rst;
    logic signed [19:0] product_list [VECTOR_SIZE-1:0];

    // Instantiate the module under test
    vector_ternary_multiplication dut (
        .list_in(list_in),
        .weight_matrix(weight_matrix),
        .clk(clk),
        .rst(rst),
        .product_list(product_list)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Simulation
    initial begin
        $dumpfile("sim.vcd");
        $dumpvars(0, dut.clk);
        $dumpvars(0, dut.rst);
        $dumpvars(0, dut.list_in);
        $dumpvars(0, dut.weight_matrix);
        $dumpvars(0, dut.product_list);

        // Dump signals of the tree_adder instance
        $dumpvars(0, dut.tree_adder_inst.clk);
        $dumpvars(0, dut.tree_adder_inst.numbers);
        $dumpvars(0, dut.tree_adder_inst.total_sum);

        // Reset
        rst = 1;
        #10;
        rst = 0;

        // Simulate for each chunk
        for (int chunk_idx = 0; chunk_idx < VECTOR_SIZE / CHUNK_SIZE; chunk_idx++) begin
            // Initialize the weight matrix and input vector for the current chunk
            for (int i = 0; i < CHUNK_SIZE; i++) begin
                for (int j = 0; j < VECTOR_SIZE; j++) begin
                    if (i + chunk_idx * CHUNK_SIZE == j)
                        weight_matrix[i + chunk_idx * CHUNK_SIZE][j] = 2'b01; // Weight 1
                    else
                        weight_matrix[i + chunk_idx * CHUNK_SIZE][j] = 2'b00; // Weight 0
                end
                list_in[i + chunk_idx * CHUNK_SIZE] = $signed({1'b0, $unsigned(i - 128)});
            end

            // Wait for the simulation to complete for the current chunk
            #40970;

            // Verify the outputs for the current chunk
            for (int i = 0; i < CHUNK_SIZE; i++) begin
                // Add your verification logic here
                $display("product_list[%0d] = %0d", i + chunk_idx * CHUNK_SIZE, product_list[i + chunk_idx * CHUNK_SIZE]);
            end
        end

        $display("Simulation completed");
        $finish;
    end
endmodule