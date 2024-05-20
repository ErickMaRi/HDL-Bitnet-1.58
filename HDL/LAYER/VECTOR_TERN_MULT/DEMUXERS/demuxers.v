`timescale 1ns/1ps
// 	Atomic demuxer that 
// 		Takes as input:
// 			Two signed 8 bit integers:
//				A and B:
// 					A = -B always
//		Has a control signal:
// 			signed 2 bit integers (specifically: -1, 0, 1)
// 		If control is -1:
// 			The output is B
// 		If control is 0:
// 			The output is a hardwired zero
// 		If control is 1:
//			The output is A

module atomic_demuxer(
  input signed [7:0] A,
  input signed [7:0] B,
  input signed [1:0] control,
  input clk,
  output reg signed [7:0] Y
);

  always @(posedge clk) begin
    case (control)
      -2'b1:  // -1
        Y <= B;  // Use non-blocking assignment for registers
      -2'b0:  // 0
        Y <= 8'b0;  // Hardwired zero
      default:  // 1
        Y <= A;
    endcase
  end
endmodule



// 	Demuxer array 
// 		That takes as input:
// 			A list of 4096 signed 8 bit integer numbers of the A type
// 			A list of 4096 signed 8 bit integer numbers if the B type
// 			A list of 4096 signed 2 bit integers (control signals)
// 		Instantiates:
// 			4096 instances of the previous "Atomic demuxer"
// 		Outputs:
// 			A list of 4096 signed 8 bit integer numbers (that are either of the A,B or zero type)

module demuxer_array(
    input signed [7:0] A_list[4095:0],
    input signed [7:0] B_list[4095:0],
    input signed [1:0] control_list[4095:0],
    input clk,
    output reg signed [7:0] Y_list[4095:0]
);

// Instantiate 4096 atomic_demuxer instances
genvar i;
generate
    for (i = 0; i < 4096; i = i + 1) begin : demux_instances
        atomic_demuxer demux_inst (
            .A(A_list[i]),
            .B(B_list[i]),
            .control(control_list[i]),
            .clk(clk),
            .Y(Y_list[i])
        );
    end
endgenerate

endmodule