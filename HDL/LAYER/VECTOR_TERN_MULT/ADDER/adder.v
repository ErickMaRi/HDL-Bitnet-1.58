`timescale 1ns/1ps

// adder.v contiene un sumador de
// enteros con signo de n-1 a n bits 
/* verilator lint_on MODDUP */
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
/* verilator lint_off MODDUP */



// árbol de sumadores
// para una lista de 4096 números de ocho bits con signo
/* verilator lint_on MODDUP */
module tree_adder(
    input clk,
    input signed [7:0] numbers [4095:0], // Array of 4096 8-bit signed numbers
    output reg signed [19:0] total_sum // Correct output width to handle all possible values
);

localparam LEVELS = 12;
localparam NUMBERS = 4096;

// Define separate sum arrays for each level with appropriate sizes
wire signed [8:0] sums1 [2047:0];
wire signed [9:0] sums2 [1023:0];
wire signed [10:0] sums3 [511:0];
wire signed [11:0] sums4 [255:0];
wire signed [12:0] sums5 [127:0];
wire signed [13:0] sums6 [63:0];
wire signed [14:0] sums7 [31:0];
wire signed [15:0] sums8 [15:0];
wire signed [16:0] sums9 [7:0];
wire signed [17:0] sums10 [3:0];
wire signed [18:0] sums11 [1:0];
wire signed [19:0] sums12 [0:0];
genvar i;

// Generate first level separately
generate
    for (i = 0; i < NUMBERS/2; i = i + 1) begin : level1
        int_adder #(.WIDTH(8)) adder_inst (
            .clk(clk),
            .a(numbers[2*i]),
            .b(numbers[2*i+1]),
            .sum(sums1[i])
        );
    end
endgenerate

// Generate subsequent levels
generate
    for (i = 0; i < NUMBERS/4; i = i + 1) begin : level2
        int_adder #(.WIDTH(9)) adder_inst (
            .clk(clk),
            .a(sums1[2*i]),
            .b(sums1[2*i+1]),
            .sum(sums2[i])
        );
    end
endgenerate

generate
    for (i = 0; i < NUMBERS/8; i = i + 1) begin : level3
        int_adder #(.WIDTH(10)) adder_inst (
            .clk(clk),
            .a(sums2[2*i]),
            .b(sums2[2*i+1]),
            .sum(sums3[i])
        );
    end
endgenerate

generate
    for (i = 0; i < NUMBERS/16; i = i + 1) begin : level4
        int_adder #(.WIDTH(11)) adder_inst (
            .clk(clk),
            .a(sums3[2*i]),
            .b(sums3[2*i+1]),
            .sum(sums4[i])
        );
    end
endgenerate

generate
    for (i = 0; i < NUMBERS/32; i = i + 1) begin : level5
        int_adder #(.WIDTH(12)) adder_inst (
            .clk(clk),
            .a(sums4[2*i]),
            .b(sums4[2*i+1]),
            .sum(sums5[i])
        );
    end
endgenerate

generate
    for (i = 0; i < NUMBERS/64; i = i + 1) begin : level6
        int_adder #(.WIDTH(13)) adder_inst (
            .clk(clk),
            .a(sums5[2*i]),
            .b(sums5[2*i+1]),
            .sum(sums6[i])
        );
    end
endgenerate

generate
    for (i = 0; i < NUMBERS/128; i = i + 1) begin : level7
        int_adder #(.WIDTH(14)) adder_inst (
            .clk(clk),
            .a(sums6[2*i]),
            .b(sums6[2*i+1]),
            .sum(sums7[i])
        );
    end
endgenerate

generate
    for (i = 0; i < NUMBERS/256; i = i + 1) begin : level8
        int_adder #(.WIDTH(15)) adder_inst (
            .clk(clk),
            .a(sums7[2*i]),
            .b(sums7[2*i+1]),
            .sum(sums8[i])
        );
    end
endgenerate

generate
    for (i = 0; i < NUMBERS/512; i = i + 1) begin : level9
        int_adder #(.WIDTH(16)) adder_inst (
            .clk(clk),
            .a(sums8[2*i]),
            .b(sums8[2*i+1]),
            .sum(sums9[i])
        );
    end
endgenerate

generate
    for (i = 0; i < NUMBERS/1024; i = i + 1) begin : level10
        int_adder #(.WIDTH(17)) adder_inst (
            .clk(clk),
            .a(sums9[2*i]),
            .b(sums9[2*i+1]),
            .sum(sums10[i])
        );
    end
endgenerate

generate
    for (i = 0; i < NUMBERS/2048; i = i + 1) begin : level11
        int_adder #(.WIDTH(18)) adder_inst (
            .clk(clk),
            .a(sums10[2*i]),
            .b(sums10[2*i+1]),
            .sum(sums11[i])
        );
    end
endgenerate

generate
    for (i = 0; i < NUMBERS/4096; i = i + 1) begin : level12
        int_adder #(.WIDTH(19)) adder_inst (
            .clk(clk),
            .a(sums11[2*i]),
            .b(sums11[2*i+1]),
            .sum(sums12[i])
        );
    end
endgenerate

// Assign the final output
always @(posedge clk) begin
    total_sum <= $unsigned(sums12[0]); // Cast to unsigned to avoid width mismatch warning
end

endmodule
/* verilator lint_off MODDUP */