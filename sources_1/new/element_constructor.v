`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Joe Desmond
// 
// Create Date: 10/04/2019 01:15:30 PM
// Design Name: Element Constructor
// Module Name: element_constructor
// Project Name: Vector Multiplier
// Target Devices: Basys3 FPGA (Xilinx Artix-7)
// Tool Versions: 
// Description: Constructs elements of a given byte width from incoming bytes
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module element_constructor #(
		parameter ELEMENT_WIDTH = 3							//Number of 8-bit bytes in 1 element
	)(
		input clk,											//Clock
		input reset,										//Reset line
		
		input [7:0] data,									//Next byte of data
		input data_ready,									//High when the incoming data is valid
		
		output reg [(ELEMENT_WIDTH*8)-1:0] element = 'b0,	//Current element (shift register)
		output reg element_ready = 1'b0						//High when the current element is valid
    );
	
	reg [3:0] byte_count = 'b0;								//Number of incoming bytes received for the next element
	
	always @(posedge clk or reset) begin
		if (reset) begin
			byte_count <= 'b0;
			element <= 'b0;
			element_ready <= 1'b0;
		end else begin
			if (data_ready) begin
				if (byte_count == ELEMENT_WIDTH - 1) begin
					byte_count <= 'b0;
					element_ready <= 1'b1;
				end else begin
					byte_count <= byte_count + 1'b1;
					element_ready <= 1'b0;
				end
				
				element <= (element << 8) | data;
			end else begin
				element_ready <= 1'b0;
				element <= element;
			end
		end
	end
	
endmodule
