`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2019 12:38:01 PM
// Design Name: 
// Module Name: element_controller
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


module element_controller #(
		parameter ELEMENT_WIDTH = 3,
		parameter ADDR_WIDTH = 17
	)(
		input clk,
		input reset,
		input [(ELEMENT_WIDTH*8)-1:0] element = 'b0,
		input element_ready,
		
		output reg [ADDR_WIDTH-1:0] addr,
		output reg [2:0] state,
		output reg done,
		output [(ELEMENT_WIDTH*8)-1:0] expected_first_elements,
		output [(ELEMENT_WIDTH*8)-1:0] expected_second_elements 
    );
	
	localparam IDLE = 8'b00000000;
	localparam ACCEPT_METADATA_OPCODE = 8'b00000001;
	localparam ACCEPT_VECTORS_STATE = 3'b010;
	localparam RESET_STATE = 3'b011;
	
	localparam METADATA_ELEMENTS = 2;
	
	reg [(ELEMENT_WIDTH*8*METADATA_ELEMENTS)-1:0] metadata = 'b0;
	assign expected_first_elements = metadata[(ELEMENT_WIDTH*8*METADATA_ELEMENTS):(ELEMENT_WIDTH*8*(METADATA_ELEMENTS-1))];
	assign expected_second_elements = metadata[(ELEMENT_WIDTH*8*(METADATA_ELEMENTS-1)):(ELEMENT_WIDTH*8*(METADATA_ELEMENTS-2))];
	
	
	reg [3:0] metadata_count = 'b0;
		
	always @(posedge clk or reset) begin
		if (reset) begin
			addr <= 'b0;
			metadata <= 'b0;
			state <= IDLE[2:0];
			done <= 1'b0;
			metadata_count <= 'b0;
		end else begin
			if (element_ready) begin
				unique if (state == IDLE[2:0]) begin
					state <= element[2:0];
					addr <= addr;
					metadata_count <= 'b0;
					metadata <= metadata;
					done <= 1'b0;
				end else if (state == ACCEPT_METADATA_OPCODE[2:0]) begin
					if (metadata_count == METADATA_ELEMENTS - 1) begin
						state <= ACCEPT_VECTORS_STATE;
					end else begin
						state <= state;
					end
					
					metadata_count <= metadata_count + 1'b1;
					metadata <= (metadata << (ELEMENT_WIDTH*8)) | element;
					addr <= addr;
					done <= 1'b0;
				end else if (state == ACCEPT_VECTORS_STATE) begin
					addr <= addr + 1'b1;
					state <= ((addr + 1'b1) == (expected_first_elements + expected_second_elements)) ? RESET_STATE : state;
					done <= 1'b0;
					metadata <= metadata;
				end else if (state == RESET_STATE) begin
					state <= IDLE[2:0];
					addr <= 'b0;
					done <= 1'b1;
					metadata_count <= 'b0;
					metadata <= metadata;
				end
			end else begin
				metadata <= metadata;
				done <= 1'b0;
				metadata_count <= metadata_count;
				state <= state;
				addr <= addr;
			end
		end
	end
	
endmodule
