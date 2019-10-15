`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Boston College
// Engineer: Joe Desmond
// 
// Create Date: 10/06/2019 12:38:01 PM
// Design Name: Element Controller
// Module Name: element_controller
// Project Name: Vector Multiplier
// Target Devices: Basys 3 FPGA Board (Xilinx Artix-7)
// Tool Versions: 
// Description: Controls the flow of vector elements from the element constructor into the vector file
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module element_controller #(
		parameter ELEMENT_WIDTH = 3,								//Number of bytes in 1 element
		parameter ADDR_WIDTH = 17									//Bit width of an address to the vector file
	)(
		input clk,													//Clock
		input reset,												//Reset line
		input [(ELEMENT_WIDTH*8)-1:0] element = 'b0,				//Next element
		input element_ready,										//High if element is valid
		
		output reg [ADDR_WIDTH-1:0] addr,							//Address to write to in vector file
		output reg [2:0] state,										//State of the element controller
		output reg done,											//High FOR ONE CLOCK CYCLE when the element controller finishes processing all expected elements
		output [(ELEMENT_WIDTH*8)-1:0] expected_first_elements,		//Number of expected ELEMENTS (not vectors) in the first matrix
		output [(ELEMENT_WIDTH*8)-1:0] expected_second_elements 	//Number of expected ELEMENTS (not vectors) in the second matrix
    );
	
	localparam IDLE = 8'b00000000;									//Idle opcode
	localparam ACCEPT_METADATA_OPCODE = 8'b00000001;				//Opcode to start accepting metadata from the PC. Vector data will follow metadata
	localparam ACCEPT_VECTORS_STATE = 3'b010;						//State when the element controller is accepting vectors
	localparam RESET_STATE = 3'b011;								//State when the element controller is done and needs to reset itself (or when it receives RESET bits while idle)
																	//In a state-driven reset, the metadata persists
	
	localparam METADATA_ELEMENTS = 2;								//Number of metadata elements to expect
	
	reg [(ELEMENT_WIDTH*8*METADATA_ELEMENTS)-1:0] metadata = 'b0;		//Internal storage of metadata
	assign expected_first_elements = metadata[(ELEMENT_WIDTH*8*METADATA_ELEMENTS):(ELEMENT_WIDTH*8*(METADATA_ELEMENTS-1))];
	assign expected_second_elements = metadata[(ELEMENT_WIDTH*8*(METADATA_ELEMENTS-1)):(ELEMENT_WIDTH*8*(METADATA_ELEMENTS-2))];
	
	
	reg [3:0] metadata_count = 'b0;			//Number of metadata fields received
		
	always @(posedge clk or reset) begin
		if (reset) begin		//The element controller has been reset externally
			addr <= 'b0;
			metadata <= 'b0;
			state <= IDLE[2:0];
			done <= 1'b0;
			metadata_count <= 'b0;
		end else begin
			if (element_ready) begin		//There is valid data ready for the element controller
				unique if (state == IDLE[2:0]) begin	//The controller is idle
					state <= element[2:0];				//While the controller is idle, the state will be the value of the 3 least significant bits in the latest valid element
					addr <= addr;
					metadata_count <= 'b0;
					metadata <= metadata;
					done <= 1'b0;
				end else if (state == ACCEPT_METADATA_OPCODE[2:0]) begin	//The controller is accepting metadata
					if (metadata_count == METADATA_ELEMENTS - 1) begin		//The controller has received all expected metadata
						state <= ACCEPT_VECTORS_STATE;
					end else begin
						state <= state;
					end
					
					metadata_count <= metadata_count + 1'b1;
					metadata <= (metadata << (ELEMENT_WIDTH*8)) | element;
					addr <= addr;
					done <= 1'b0;
				end else if (state == ACCEPT_VECTORS_STATE) begin		//The controller is accepting vector elements
					addr <= addr + 1'b1;
					state <= ((addr + 1'b1) == (expected_first_elements + expected_second_elements)) ? RESET_STATE : state;
					done <= 1'b0;
					metadata <= metadata;
				end else if (state == RESET_STATE) begin		//The controller needs to perform a state-driven reset: it is either done, or it received RESET bits while idle
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
