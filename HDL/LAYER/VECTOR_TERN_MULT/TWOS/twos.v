`timescale 1ns/1ps

// twos.v contiene el módulo atómico para el complemento de dos de un número con signo
// de ocho bits, presenta el valor original y su complemento coordinado con el reloj
/* verilator lint_on MODDUP */
module twos_complement (
  input signed [7:0] a,
  input logic clk,
  output reg signed [7:0] neg_a,
  output reg signed [7:0] pos_a
);

always @(posedge clk) begin
  neg_a <= -a;
  pos_a <= a; // Positive value is the original input
end

endmodule
/* verilator lint_off MODDUP */

// realiza en paralelo el complemento de dos de 4096 números con signo de ocho bits
// y presenta la salida y el valor original coordinado con el reloj
/* verilator lint_on MODDUP */
module twos_complement_list (
    input logic clk,
    input signed [7:0] data_in [4095:0], // Array of 4096 8-bit signed numbers
    output reg signed [7:0] original_data [4095:0], // Original data list
    output reg signed [7:0] twos_complement [4095:0] // Two's complement of the data list
);

  // Instantiate 4096 instances of the twos_complement module
  genvar i;
  generate
    for (i = 0; i < 4096; i = i + 1) begin
      twos_complement instance_name (
        .a(data_in[i]),
        .clk(clk),
        .neg_a(twos_complement[i]),
        .pos_a(original_data[i])
      );
    end
  endgenerate

endmodule
/* verilator lint_off MODDUP */