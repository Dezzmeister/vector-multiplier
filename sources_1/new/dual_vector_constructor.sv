`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2019 10:45:25 AM
// Design Name: 
// Module Name: dual_vector_constructor
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


module dual_vector_constructor #(
		parameter ELEMENT_WIDTH = 24,
		parameter ADDR_WIDTH = 17,
		parameter VECTOR_DIMENSION = 3
	)(
		input clk,
		input reset,
		input enabled,
		input start,
		
		input [ELEMENT_WIDTH-1:0] first_expected_elements,
		input [ELEMENT_WIDTH-1:0] first_element_in,
		
		input [ELEMENT_WIDTH-1:0] second_expected_elements,
		input [ELEMENT_WIDTH-1:0] second_element_in,
		
		output [ADDR_WIDTH-1:0] first_addr,
		output [ADDR_WIDTH-1:0] second_addr,
		
		output [ELEMENT_WIDTH-1:0] first_vector [0:VECTOR_DIMENSION-1],
		output first_vector_ready,
		
		output [ELEMENT_WIDTH-1:0] second_vector [0:VECTOR_DIMENSION-1],
		output second_vector_ready,
		
		output done
    );
	
	reg first_enabled;
	
	wire first_done;
	reg first_finished;
	
	wire second_done;
	wire second_enabled;
	reg second_reset;
	
	wire [ELEMENT_WIDTH-1:0] first_elements_received;
	wire [ELEMENT_WIDTH-1:0] second_elements_received;
	
	//assign done = first_finished & second_done;
	assign done = (first_elements_received == first_expected_elements) & (second_elements_received == second_expected_elements);
	assign second_enabled = enabled;
	
	shift_vector_constructor #(
		.ELEMENT_WIDTH(ELEMENT_WIDTH),
		.ADDR_WIDTH(ADDR_WIDTH),
		.VECTOR_DIMENSION(VECTOR_DIMENSION)
	) first_vector_constructor (
		.clk(clk),
		.reset(reset),
		.enabled(first_enabled),
		.elements_received(first_elements_received),
		.expected_elements(first_expected_elements),
		.element_in(first_element_in),
		.addr(first_addr),
		.vector(first_vector),
		.vector_ready(first_vector_ready),
		.done(first_done)
	);
	
	wire [ADDR_WIDTH-1:0] raw_second_addr;
	assign second_addr = raw_second_addr + first_expected_elements;
	
	shift_vector_constructor #(
		.ELEMENT_WIDTH(ELEMENT_WIDTH),
		.ADDR_WIDTH(ADDR_WIDTH),
		.VECTOR_DIMENSION(VECTOR_DIMENSION)
	) second_vector_constructor (
		.clk(clk),
		.reset(second_reset),
		.enabled(second_enabled),
		.expected_elements(second_expected_elements),
		.element_in(second_element_in),
		.elements_received(second_elements_received),
		.addr(raw_second_addr),
		.vector(second_vector),
		.vector_ready(second_vector_ready),
		.done(second_done)
	);
	
	always @(posedge clk or reset) begin
		if (reset) begin
			first_enabled <= 1'b0;
			second_reset <= 1'b1;
			first_finished <= 1'b0;
		end else begin
			if (first_done) begin
				first_finished <= 1'b1;
			end else begin
			
			end
		
			if (start | second_done) begin
				first_enabled <= 1'b1;
			end else begin
				if (first_vector_ready) begin
					first_enabled <= 1'b0;
				end
			end
			
			if (second_done) begin
				second_reset <= 1'b1;
			end else begin
				second_reset <= 1'b0;
			end
		end
	end
	
endmodule
