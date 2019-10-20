`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2019 03:06:33 PM
// Design Name: 
// Module Name: vector_constructor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module full_vector_constructor #(
		parameter ELEMENT_WIDTH = 24,
		parameter ADDR_WIDTH = 17,
		parameter VECTOR_DIMENSION = 3
	)(
		input clk,
		input reset,
		input enabled,
		input [ELEMENT_WIDTH-1:0] expected_first_elements,
		input [ELEMENT_WIDTH-1:0] expected_second_elements,
		
		input [ELEMENT_WIDTH-1:0] first_element_in,
		input [ELEMENT_WIDTH-1:0] second_element_in,
		
		output reg [ADDR_WIDTH-1:0] first_vector_addr,
		output reg [ELEMENT_WIDTH-1:0] first_vector [0:VECTOR_DIMENSION-1],
		
		output reg [ADDR_WIDTH-1:0] second_vector_addr,
		output reg [ELEMENT_WIDTH-1:0] second_vector [0:VECTOR_DIMENSION-1],
		output reg vectors_ready
    );
	
	localparam COUNT_WIDTH = $clog2(VECTOR_DIMENSION);
	reg [COUNT_WIDTH-1:0] first_count = 'b0;
	
	reg read_first_matrix = 1'b1;
	
	always @(posedge clk or reset) begin
		if (reset) begin
			count <= 'b0;
			
			first_vector_addr <= 'b0;
			first_matrix_pos <= 'b0;
			
			second_vector_addr <= expected_second_elements;
			second_matrix_pos <= 'b0;
			
			read_first_matrix <= 1'b1;
			vector <= 'b0;
			vector_ready <= 'b0;
		end else begin
			if (enabled) begin
				
			end else begin
				
			end
		end
	end
	
endmodule
