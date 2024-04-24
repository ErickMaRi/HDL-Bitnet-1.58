`timescale 1ns/1ps

// SUMADOR DE N BITS DE SALIDA

module int_adder #(parameter WIDTH = 8) (
    input clk,
    input signed [WIDTH-1:0] a,
    input signed [WIDTH-1:0] b,
    output reg signed [WIDTH:0] sum
);

always @(posedge clk) begin
    sum <= a + b;
end

endmodule

// ARBOL DE SUMADORES

module tree_adder(
    input clk,
    input signed [7:0] numbers[4095:0], // Array of 4096 8-bit signed numbers
    output reg signed [19:0] total_sum // Correct output width to handle all possible values
);

localparam LEVELS = 12;
localparam NUMBERS = 4096;

wire signed [20:0] sums [LEVELS:0][NUMBERS/2-1:0];
genvar i, j;

generate
    // Handle the first level separately
    for (j = 0; j < NUMBERS/2; j++) begin : first_level
        int_adder #(.WIDTH(8)) adder_first (
            .clk(clk),
            .a(numbers[2*j]),
            .b(numbers[2*j+1]),
            .sum(sums[0][j])
        );
    end

    // Handle subsequent levels
    for (i = 1; i < LEVELS; i++) begin : levels
        localparam int WIDTH = 9 + i - 1; // Adjust input width for each level
        localparam int OUT_WIDTH = WIDTH + 1; // Each sum should be one bit wider
        localparam int NUM_PAIRS = NUMBERS >> (i + 1);
        for (j = 0; j < NUM_PAIRS; j++) begin : sum_pairs
            int_adder #(.WIDTH(WIDTH)) adder (
                .clk(clk),
                .a(sums[i-1][2*j][WIDTH-1:0]),
                .b(sums[i-1][2*j+1][WIDTH-1:0]),
                .sum(sums[i][j])
            );
        end
    end
endgenerate

// Assign the final output
always @(*) begin
    total_sum <= sums[LEVELS-1][0]; // Fetch the final result from the last array index
end

endmodule