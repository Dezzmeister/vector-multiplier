`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Boston College
// Engineer: Joe Desmond
// 
// Create Date: 10/13/2019 08:36:17 PM
// Design Name: Dot Product Calculator
// Module Name: dot_product
// Project Name: Vector Multiplier
// Target Devices: Basys 3 FPGA Board (Xilinx Artix-7)
// Tool Versions: 
// Description: Calculates the dot product of two vectors with fixed-point elements.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module dot_product #(
		parameter ELEMENT_WIDTH = 64,
		parameter DECIMAL_PLACE = 24,
		parameter VECTOR_DIMENSION = 10
	)(
		input clk,
		input reset,
		input signed [ELEMENT_WIDTH-1:0] vec0 [0:VECTOR_DIMENSION-1],
		input signed [ELEMENT_WIDTH-1:0] vec1 [0:VECTOR_DIMENSION-1],
		
		output reg [ELEMENT_WIDTH-1:0] product
    );
	
	wire [ELEMENT_WIDTH-1:0] hadamard [0:VECTOR_DIMENSION-1];
	
	genvar i;
	generate
		for (i = 0; i < VECTOR_DIMENSION; i = i + 1) begin : hadamard_multipliers
			fixed_pt_multiplier #(
				.OPERAND_WIDTH(ELEMENT_WIDTH),
				.DECIMAL_PLACE(DECIMAL_PLACE)
			) element_multiplier (
				.operand1(vec0[i]),
				.operand2(vec1[i]),
				.product(hadamard[i])
			);
		end
	endgenerate
	
	integer j;
	always @(posedge clk or reset) begin
		if (reset) begin
			product <= 'b0;
		end else begin
			product = 'b0;
			
			for (j = 0; j < VECTOR_DIMENSION; j = j + 1) begin
				product = product + hadamard[j];
			end
		end
	end
	
endmodule
