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

`define print_result(num) $display(num + ": Success"); else $warning(num + ": Failure");


module fixed_pt_multiplier_tb(

    );
	
	localparam OPERAND_WIDTH = 24;
	localparam DECIMAL_PLACE = 8;
	
	reg [OPERAND_WIDTH-1:0] operand1;
	reg [OPERAND_WIDTH-1:0] operand2;
	wire [OPERAND_WIDTH-1:0] product;
	
	fixed_pt_multiplier #(
		.OPERAND_WIDTH(OPERAND_WIDTH),
		.DECIMAL_PLACE(DECIMAL_PLACE)
	) DUT (
		.operand1(operand1),
		.operand2(operand2),
		.product(product)
	);
	
	initial begin
		operand1 = 'hAC00;
		operand2 = 'hDC00;
		#10 assert (product == 'h93D000) $display("1: Success"); else $warning("1: Failure");
		operand1 = 'h1280;
		operand2 = 'h1500;
		#10 assert (product == 'h18480) $display("2: Success"); else $warning("2: Failure");
		operand1 = 'hFF5433;
		operand2 = 'h738;
		#10 assert (product == 'h3327D0) $display("3: Success"); else $warning("3: Failure");
		operand1 = 'hABCD;
		operand2 = 'h738;
		#10 assert (product == 'h4D82F) $display("4: Success"); else $warning("4: Failure");
		
	end
	
endmodule
