// Testbench for twos_complement and twos_complement_list modules

module twos_complement_tb;

  // Clock signal
  reg clk;

  // Data for twos_complement module
  reg signed [7:0] data_in;

  // Outputs from twos_complement module
  wire signed [7:0] neg_a;
  wire signed [7:0] pos_a;

  // Data for twos_complement_list module (**Ensure size matches port declaration**)
  reg signed [7:0] data_list [4095:0]; // Sample data list (size should match module port)

  // Outputs from twos_complement_list module
  wire signed [7:0] original_data [4095:0];
  wire signed [7:0] twos_complement_list_out [4095:0];

  // Instantiate modules
  twos_complement u_twos_complement (.a(data_in), .clk(clk), .neg_a(neg_a), .pos_a(pos_a));

  twos_complement_list u_twos_complement_list (.clk(clk), .data_in(data_list), .original_data(original_data), .twos_complement(twos_complement_list_out));

  // Clock generation
  always begin
    #5 clk = ~clk;
  end

  initial begin
    // Initialize data and clock
    data_in = 8'b00001010; // Positive value
    clk = 1'b0;

    #10; // Wait for some clock cycles

    // Test data for twos_complement_list (**Adjust values as needed**)
    data_list[0] = 8'b00001010;
    data_list[1] = 8'b11110101; // Negative value
    data_list[2] = 8'b10000001; // Minimum negative value
    data_list[3] = 8'b01111111; // Maximum positive value

    // You can add more elements to the data_list array here

    #10; // Wait for processing

    // Print results
    $display("** twos_complement module results **");
    $display("Data In (Signed):  %d", data_in);
    $display("Data In (Binary): %b", data_in);
    $display("Negation (Signed): %d", neg_a);
    $display("Negation (Binary):%b", neg_a);
    $display("Positive Value (Signed): %d", pos_a);
    $display("Positive Value (Binary):%b\n", pos_a);

    $display("** twos_complement_list module results **");
    for (int i = 0; i < 4; i = i + 1) begin
      $display("Data %d (Signed):  %d", i, original_data[i]);
      $display("Data %d (Binary): %b", i, original_data[i]);
      $display("Two's Comp. %d (Signed): %d", i, twos_complement_list_out[i]);
      $display("Two's Comp. %d (Binary):%b\n", i, twos_complement_list_out[i]);
    end

    #10; // Wait for some time
    $finish;
  end

endmodule
