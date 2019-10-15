`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2019 10:44:24 PM
// Design Name: 
// Module Name: fixed_pt_multiplier_tb
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

module fixed_pt_multiplier_tb(

    );
	
	localparam OPERAND_WIDTH = 24;
	localparam DECIMAL_PLACE = 8;
	
	reg signed [OPERAND_WIDTH-1:0] operand1;
	reg signed [OPERAND_WIDTH-1:0] operand2;
	wire signed [OPERAND_WIDTH-1:0] product;
	
	fixed_pt_multiplier #(
		.OPERAND_WIDTH(OPERAND_WIDTH),
		.DECIMAL_PLACE(DECIMAL_PLACE)
	) DUT_1 (
		.operand1(operand1),
		.operand2(operand2),
		.product(product)
	);
	
	localparam OPERAND_WIDTH_2 = 64;
	localparam DECIMAL_PLACE_2 = 32;
	
	reg signed [OPERAND_WIDTH_2-1:0] lg_operand1;
	reg signed [OPERAND_WIDTH_2-1:0] lg_operand2;
	wire signed [OPERAND_WIDTH_2-1:0] lg_product;
	
	fixed_pt_multiplier #(
		.OPERAND_WIDTH(OPERAND_WIDTH_2),
		.DECIMAL_PLACE(DECIMAL_PLACE_2)
	) DUT_2 (
		.operand1(lg_operand1),
		.operand2(lg_operand2),
		.product(lg_product)
	);
	
	initial begin
		lg_operand1 = 'h0;
		lg_operand2 = 'h0;
	
		operand1 = 'hAC_00;
		operand2 = 'hDC_00;
		$display("Testing small operand multiplier: Q15.8");
		#10 assert (product == 'h93D0_00) `print_result(1'd1);
		operand1 = 'h12_80;
		operand2 = 'h15_00;
		#10 assert (product == 'h184_80) `print_result(2'd2);
		operand1 = 'hFF54_33;
		operand2 = 'h7_38;
		#10 assert (product == 'hFB27_D0) `print_result(2'd3);
		operand1 = 'hAB_CD;
		operand2 = 'h7_38;
		#10 assert (product == 'h4D8_2F) `print_result(3'd4);
		
		
		#10 $display("Testing large operand multiplier: Q31.32");
		lg_operand1 = 'h0_ABCDEE;
		lg_operand2 = 'h0_1223344;
		#10 assert (lg_product == 'h0_0000C2C1) `print_result(3'd5);
		lg_operand1 = 'hCAFE_A900FCB3;
		lg_operand2 = 'h7E_17384000;
		#10 assert (lg_product == 'h63FBC0_AA201945) `print_result(3'd6);
	end
	
endmodule
