`timescale 1ns/1ps

module testbench;

// Inputs
reg signed [7:0] A_list[4095:0];
reg signed [7:0] B_list[4095:0];
reg signed [1:0] control_list[4095:0];
reg clk;

// Output
wire signed [7:0] Y_list[4095:0];

// Instantiate the demuxer_array module
demuxer_array dut (
    .A_list(A_list),
    .B_list(B_list),
    .control_list(control_list),
    .clk(clk),
    .Y_list(Y_list)
);

// Clock generation
always #5 clk = ~clk;

// Initialize inputs
integer i;
initial begin
    clk = 0;
    $dumpfile("sim.vcd");
    $dumpvars(0, testbench);

    // Initialize A_list and B_list with opposite values
    for (i = 0; i < 4096; i = i + 1) begin
        A_list[i] = $random; // Assign random value
        B_list[i] = -A_list[i]; // Assign opposite value
    end

    // Initialize control_list with all possible values
    for (i = 0; i < 1366; i = i + 1) begin
        control_list[i] = -1; // -1
    end
    for (i = 1366; i < 2732; i = i + 1) begin
        control_list[i] = 0; // 0
    end
    for (i = 2732; i < 4096; i = i + 1) begin
        control_list[i] = 1; // 1
    end

    // Wait for a few clock cycles
    #100;

    // Display output for a few indices
    for (i = 0; i < 16; i = i + 1) begin
        $display("Index: %d, A: %d, B: %d, Control: %d, Output: %d", i, A_list[i], B_list[i], control_list[i], Y_list[i]);
    end

    // Test case 1: Control = -1 (Output should be B)
    for (i = 0; i < 1366; i = i + 1) begin
        if (Y_list[i] !== B_list[i]) begin
            $display("Error at index %d: Output %d does not match B %d for control -1", i, Y_list[i], B_list[i]);
        end
    end

    // Test case 2: Control = 0 (Output should be 0)
    for (i = 1366; i < 2732; i = i + 1) begin
        if (Y_list[i] !== 0) begin
            $display("Error at index %d: Output %d is not 0 for control 0", i, Y_list[i]);
        end
    end

    // Test case 3: Control = 1 (Output should be A)
    for (i = 2732; i < 4096; i = i + 1) begin
        if (Y_list[i] !== A_list[i]) begin
            $display("Error at index %d: Output %d does not match A %d for control 1", i, Y_list[i], A_list[i]);
        end
    end

    #10 $finish;
end

endmodule