`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Boston College
// Engineer: Joe Desmond
// 
// Create Date: 10/20/2019 09:52:32 AM
// Design Name: Shift Vector Constructor
// Module Name: shift_vector_constructor
// Project Name: Vector Multiplier
// Target Devices: Basys 3 FPGA Board (Xilinx Artix-7)
// Tool Versions: 
// Description: Constructs full vectors when coupled with a RAM module containing vector elements. Reads elements sequentially (starting at address 0), assuming
//				that every N elements is a new vector.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module shift_vector_constructor #(
		parameter ELEMENT_WIDTH = 24,									//Bit width of one element (data width of RAM)
		parameter ADDR_WIDTH = 17,										//Address width of RAM
		parameter VECTOR_DIMENSION = 3									//Number of elements in one vector
	)(
		input clk,														//Clock - NOTE: The same clock must be used to read from the RAM module
		input reset,													//Reset line
		input [ELEMENT_WIDTH-1:0] expected_elements,					//Number of expected elements
		input [ELEMENT_WIDTH-1:0] element_in,							//Latest element read from RAM module
		input enabled,													//High if the vector constructor should continue building vectors
		
		output reg [ELEMENT_WIDTH-1:0] elements_received,				//Total number of elements received since reset
		output reg [ADDR_WIDTH-1:0] addr,								//Read address for the RAM module
		output reg [ELEMENT_WIDTH-1:0] vector [0:VECTOR_DIMENSION-1],	//Latest vector
		output reg vector_ready,										//High for one clock cycle when the latest vector is valid
		output done														//High for one clock cycle when the vector constructor has built all expected vectors (All the expected elements were used)
    );
	
	reg delay;															//Delays the vector constructor when it is first enabled so that old, invalid data is ignored
	
	localparam COUNT_WIDTH = $clog2(VECTOR_DIMENSION);					
	reg [COUNT_WIDTH-1:0] count;										//The current element to write to in the current vector
	
	integer i;
	always @(posedge clk) begin
		if (reset) begin
			elements_received <= 'b0;
			addr <= 'b0;
			
			for (i = 0; i < VECTOR_DIMENSION; i = i + 1) begin
				vector[i] <= 'b0;
			end
			
			vector_ready <= 1'b0;
			
			delay <= 1'b1;
			count <= 'b0;
		end else begin
			if (enabled) begin
				addr <= addr + 1'b1;
				
				if (delay == 1'b0) begin
					vector[count] <= element_in;
					elements_received <= elements_received + 1'b1;
					
					if (count == VECTOR_DIMENSION - 1'b1) begin
						count <= 'b0;
						vector_ready <= 1'b1;
					end else begin
						vector_ready <= 1'b0;
						count <= count + 1'b1;
					end
				end else begin
					vector_ready <= 1'b0;
					delay <= 1'b0;
				end
			end
		end
	end
	
	assign done = (elements_received == expected_elements);
	
endmodule
