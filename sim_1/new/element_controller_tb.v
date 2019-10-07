`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2019 10:54:57 PM
// Design Name: 
// Module Name: element_controller_tb
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


module element_controller_tb(

    );
	
	localparam ELEMENT_WIDTH = 3;
	localparam ADDR_WIDTH = 17;
	
	//Inputs
	reg clk;
	reg reset;
	reg [(ELEMENT_WIDTH*8)-1:0] element;
	reg element_ready;
	
	//Outputs
	wire [ADDR_WIDTH-1:0] addr;
	wire [2:0] state;
	wire done;
	wire [(ELEMENT_WIDTH*8)-1:0] expected_first_elements;
	wire [(ELEMENT_WIDTH*8)-1:0] expected_second_elements;
	
	
	element_controller #(
		.ELEMENT_WIDTH(ELEMENT_WIDTH),
		.ADDR_WIDTH(ADDR_WIDTH)
	) DUT (
		.clk(clk),
		.reset(reset),
		.element(element),
		.element_ready(element_ready),
		.addr(addr),
		.state(state),
		.done(done),
		.expected_first_elements(expected_first_elements),
		.expected_second_elements(expected_second_elements)
	);
	
	localparam [(ELEMENT_WIDTH*8)-1:0] ELEMENTS[] = {
		'h00, 'h00, 'h00,
		'h01,
		'h05, 'h02,
		'hab00, 'hcd69, 'h1738, 'h01, 'h700,
		'h10040, 'h696969,
		'h00,
		'h00
	};
	
	integer i;
	initial begin
		clk = 1'b0;
		#50 reset = 1'b1;
		#50 reset = 1'b0;
		
		for (i = 0; i < $size(ELEMENTS); i = i + 1) begin
			#5 element = ELEMENTS[i];
			#5 element_ready = 1'b1;
			#10 element_ready = 1'b0;
		end
	end
	
	always begin
		#5 clk = ~clk;
	end
	
endmodule
