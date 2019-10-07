`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/04/2019 01:38:25 PM
// Design Name: 
// Module Name: element_constructor_tb
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


module element_constructor_tb(

    );
	localparam ELEMENT_WIDTH = 3;
	
	reg clk;
	reg reset;
	reg [7:0] data;
	reg data_ready;
	
	wire [(ELEMENT_WIDTH*8)-1:0] element;
	wire element_ready;
	
	element_constructor #(
		.ELEMENT_WIDTH(ELEMENT_WIDTH)
	) DUT (
		.clk(clk),
		.reset(reset),
		.data(data),
		.data_ready(data_ready),
		.element(element),
		.element_ready(element_ready)
	);
	
	localparam [7:0] ELEMENTS[] = {
		8'h01, 8'h90, 8'h44,
		8'h76, 8'h69, 8'hAB,
		8'h44, 8'h00, 8'hC4
	};
	
	integer i;
	initial begin
		clk = 1'b0;
		#10 reset = 1'b1;
		#10 reset = 1'b0;
		
		for (i = 0; i < $size(ELEMENTS); i = i + 1) begin
			#5 data = ELEMENTS[i];
			#5 data_ready = 1'b1;
			#10 data_ready = 1'b0;
		end
	end
	
	always begin
		#5 clk = ~clk;
	end
	
endmodule
