`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Boston College
// Engineer: Joe Desmond
// 
// Create Date: 10/12/2019 08:51:01 PM
// Design Name: Fixed Point Multiplier
// Module Name: fixed_pt_multiplier
// Project Name: Vector Multiplier
// Target Devices: Basys 3 FPGA Board (Xilinx Artix-7)
// Tool Versions: 
// Description: Multiplies two signed fixed point numbers.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fixed_pt_multiplier #(
		parameter OPERAND_WIDTH = 24,					//Bit width of each operand
		parameter DECIMAL_PLACE = 12					//Bit position of the decimal place, counted from the LSB
	)(
		input signed [OPERAND_WIDTH-1:0] operand1,		//First operand
		input signed [OPERAND_WIDTH-1:0] operand2,		//Second operand
		output signed [OPERAND_WIDTH-1:0] product		//Product of operand1 and operand2
    );
	
	wire signed [OPERAND_WIDTH+DECIMAL_PLACE-1:0] full_product;		//The product of operand1 and operand2 with an extra `DECIMAL_PLACE` bits 
																	//so that the most significant bits of the product are not empty when
																	//the unnecessary fractional bits are shifted off
	assign full_product = (operand1 * operand2);
	
	assign product = full_product >>> DECIMAL_PLACE;				//The product, converted to fixed point with a signed (arithmetic) right shift
	
endmodule
