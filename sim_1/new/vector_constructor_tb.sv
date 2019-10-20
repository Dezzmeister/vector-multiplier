`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2019 05:41:32 PM
// Design Name: 
// Module Name: vector_constructor_tb
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


module vector_constructor_tb(
		
    );
	
	localparam ELEMENT_WIDTH = 24;
	localparam ADDR_WIDTH = 3;
	localparam VECTOR_DIMENSION = 3;
	
	reg clk;
	reg reset;
	reg [ELEMENT_WIDTH-1:0] expected_elements;
	reg [ELEMENT_WIDTH-1:0] element_in;
	reg element_ready;
	
	wire [ADDR_WIDTH-1:0] addr;
	wire [ELEMENT_WIDTH-1:0] vector [0:VECTOR_DIMENSION-1];
	wire done;
	wire vector_ready;
	
	vector_constructor #(
		.ELEMENT_WIDTH(ELEMENT_WIDTH),
		.ADDR_WIDTH(ADDR_WIDTH),
		.VECTOR_DIMENSION(VECTOR_DIMENSION)
	) DUT (
		.clk(clk),
		.reset(reset),
		.expected_elements(expected_elements),
		.element_in(element_in),
		.element_ready(element_ready),
		.addr(addr),
		.vector(vector),
		.done(done),
		.vector_ready(vector_ready)
	);
	
	localparam [ELEMENT_WIDTH-1:0] ELEMENTS[] = {
		'hAA_00, 'h1B4_80, 'h59_16,
		'h15_F0, 'h4555_7E, 'h200_00
	};
	
	integer i;
	initial begin
		clk = 1'b0;
		reset = 1'b1;
		expected_elements = 'h6;
		element_in = 'h0;
		element_ready = 1'b0;
		#50 reset = 1'b0;
		
		for (i = 0; i < $size(ELEMENTS); i = i + 1) begin
			#10 element_in = ELEMENTS[i];
			element_ready = 1'b1;
			#10 element_ready = 1'b0;
		end
		
		if (done) begin
			reset = 1'b1;
			#20 reset = 1'b0;
		end
	end
	
	always begin
		#5 clk = ~clk;
	end
	
endmodule
