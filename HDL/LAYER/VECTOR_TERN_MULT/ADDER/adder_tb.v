`timescale 1ns / 1ps

// TESTBENCH SUMADOR

module int_adder_testbench;

parameter WIDTH = 8; // Width of the adder
parameter T = 8; // Number of random test cases

// Random value function that fits the width of the adder
function signed [WIDTH-1:0] random_value;
begin
    random_value = $random % (2 ** WIDTH);
end
endfunction

// Test signal declarations
reg signed [WIDTH-1:0] a, b;
wire signed [WIDTH:0] sum;
reg clk;

// Instantiate the Device Under Test (DUT)
int_adder #(.WIDTH(WIDTH)) dut (
    .clk(clk),
    .a(a),
    .b(b),
    .sum(sum)
);

initial begin
    clk = 0;
    forever #1 clk = ~clk; // Generate clock signal
end

initial begin
    integer i;

    $dumpfile("int_adder_tb.vcd");
    $dumpvars();
    
    $display("Testing int_adder with WIDTH = %d", WIDTH);

    // Test overflow
    a = {1'b0, {(WIDTH-1){1'b1}}}; // Largest positive number
    b = 1;
    #2; // Wait for clock
    $display("Overflow Test: a = %d (%b), b = %d (%b), sum = %d (%b)", a, a, b, b, sum, sum);

    // Test underflow
    a = {1'b1, {(WIDTH-1){1'b0}}}; // Smallest negative number
    b = -1;
    #2; // Wait for clock
    $display("Underflow Test: a = %d (%b), b = %d (%b), sum = %d (%b)", a, a, b, b, sum, sum);

    // Random value tests
    for (i = 0; i < T; i++) begin
        a = random_value();
        b = random_value();
        #2; // Wait for clock
        $display("Random Test: a = %d (%b), b = %d (%b), sum = %d (%b)", a, a, b, b, sum, sum);
    end

    // $finish;
end

endmodule

// TESTBENCH ARBOL
module tree_adder_testbench;

parameter INPUT_WIDTH = 8;
parameter NUM_INPUTS = 4096;

// Random value function that fits the width of the adder
function signed [INPUT_WIDTH-1:0] random_value;
begin
  // Generate a random bit pattern within the width
  random_value = $random;
  // Force MSB to 0 to guarantee a positive value
  random_value[INPUT_WIDTH-1] = 0;
end
endfunction

// Test signal declarations
reg signed [INPUT_WIDTH-1:0] numbers[NUM_INPUTS-1:0];
wire signed [INPUT_WIDTH+11:0] total_sum; // Estimating the width for total sum
reg clk;

// Instantiate the Device Under Test (DUT)
tree_adder dut (
    .clk(clk),
    .numbers(numbers),
    .total_sum(total_sum)
);

initial begin
    clk = 0;
    forever #1 clk = ~clk; // Generate clock signal
end

initial begin
    integer i;

    $dumpfile("tree_adder_tb.vcd");
    $dumpvars();

    $display("Testing tree_adder with INPUT_WIDTH = %d, NUM_INPUTS = %d", INPUT_WIDTH, NUM_INPUTS);

    // Test with the same negative number repeated
    $display("Testing with the same negative number repeated:");
    for (i = 0; i < NUM_INPUTS; i++) begin
        numbers[i] = -128; // Repeat the negative number -64
    end
    #200; // Allow some time for propagation
    $display("Sum: %d (%b)", total_sum, total_sum);

    // Test with the same positive number repeated
    $display("Testing with the same positive number repeated:");
    for (i = 0; i < NUM_INPUTS; i++) begin
        numbers[i] = 127; // Repeat the positive number 64
    end
    #200; // Allow some time for propagation
    $display("Sum: %d (%b)", total_sum, total_sum);

    // Test with positive random numbers
    $display("Testing with positive random numbers:");
    for (i = 0; i < NUM_INPUTS; i++) begin
        numbers[i] = random_value(); // Random signed values
	// $display("RANDOM VALUE = %d (%b)", numbers[i], numbers[i]);
    end
    #200; // Allow some time for propagation
    $display("Sum: %d (%b)", total_sum, total_sum);

    // Test with negative random numbers
    $display("Testing with negative random numbers:");
    for (i = 0; i < NUM_INPUTS; i++) begin
        numbers[i] = -random_value(); // Random signed values
	// $display("RANDOM VALUE = %d", numbers[i]);
    end
    #200; // Allow some time for propagation
    $display("Sum: %d (%b)", total_sum, total_sum);

    $finish;
end

endmodule