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


module vector_constructor #(
		parameter ELEMENT_WIDTH = 24,
		parameter ADDR_WIDTH = 17,
		parameter VECTOR_DIMENSION = 3
	)(
		input clk,
		input reset,
		input enabled,
		input [(ELEMENT_WIDTH*8)-1:0] expected_first_elements,
		input [(ELEMENT_WIDTH*8)-1:0] expected_second_elements,
		input [ELEMENT_WIDTH-1:0] element_in,
		
		output reg [ADDR_WIDTH-1:0] addr,
		output reg [ELEMENT_WIDTH-1:0] vector [0:VECTOR_DIMENSION-1];
		output reg vector_ready
    );
	
	
endmodule
