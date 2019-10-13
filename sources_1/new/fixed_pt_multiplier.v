`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2019 08:51:01 PM
// Design Name: 
// Module Name: fixed_pt_multiplier
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


module fixed_pt_multiplier #(
		parameter OPERAND_WIDTH = 24,
		parameter DECIMAL_PLACE = 12
	)(
		input signed [OPERAND_WIDTH-1:0] operand1,
		input signed [OPERAND_WIDTH-1:0] operand2,
		output signed [OPERAND_WIDTH-1:0] product
    );
	
	wire signed [OPERAND_WIDTH+DECIMAL_PLACE-1:0] full_product;
	assign full_product = (operand1 * operand2);
	
	assign product = full_product >> DECIMAL_PLACE;
	
endmodule
