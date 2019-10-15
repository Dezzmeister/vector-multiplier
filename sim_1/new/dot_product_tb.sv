`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2019 10:32:59 PM
// Design Name: 
// Module Name: dot_product_tb
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

`include "testbench_macros.vh"

module dot_product_tb(

    );
	
	localparam ELEMENT_WIDTH = 32;
	localparam DECIMAL_PLACE = 8;
	localparam VECTOR_DIMENSION = 3;
	
	reg clk;
	reg reset;
	reg signed [ELEMENT_WIDTH-1:0] vec0 [0:VECTOR_DIMENSION-1];
	reg signed [ELEMENT_WIDTH-1:0] vec1 [0:VECTOR_DIMENSION-1];
	
	wire signed [ELEMENT_WIDTH-1:0] product;
	
	dot_product #(
		.ELEMENT_WIDTH(ELEMENT_WIDTH),
		.DECIMAL_PLACE(DECIMAL_PLACE),
		.VECTOR_DIMENSION(VECTOR_DIMENSION)
	) DUT (
		.clk(clk),
		.reset(reset),
		.vec0(vec0),
		.vec1(vec1),
		.product(product)
	);
	
	initial begin
		foreach (vec0[i]) vec0[i] = 'h0;
		foreach (vec1[i]) vec1[i] = 'h0;
		clk = 1'b0;
		reset = 1'b0;
		#10 reset = 1'b1;
		#40 reset = 1'b0;
		#10 vec0 = {'h10_80, 'hAB_C0, 'h69_4D};
			vec1 = {'hDD_00, 'hDF_F8, 'h34_16};
		#10 assert (product == 'hB9ED_D2) `print_result(1'd1);
			vec0[0] = 'hFFFFEF_80;									//negative 0x10.80
		#10 assert (product == 'h9D70_D2) `print_result(2'd2);
	end
	
	always begin
		#5 clk = ~clk;
	end
	
endmodule
