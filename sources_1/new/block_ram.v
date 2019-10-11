`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Joe Desmond
// 
// Create Date: 10/11/2019 11:47:27 AM
// Design Name: Block RAM
// Module Name: block_ram
// Project Name: Vector Multiplier
// Target Devices: Basys 3 FPGA Board (Xilinx Artix-7)
// Tool Versions: 
// Description: A RAM module with one port, a reset line, and a write enable line. Intended to be inferred as Block RAM.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`define reset_memory(INIT_MEM_FILE, memory)	\
	integer i;	\
	if (INIT_MEM_FILE != "") begin	\
		$readmemh(INIT_MEM_FILE, memory);	\
    end else begin	\
		for (i = 0; i < DEPTH; i = i + 1) begin	\
			memory[i] = 'b0;	\
		end	\
	end


module block_ram #(
		ADDR_WIDTH = 18,						//Bit length of each address
		DATA_WIDTH = 8,							//Bit length of one addressable word
		DEPTH = 204800,							//Number of addressable words
		INIT_MEM_FILE = ""						//Optional memory initializer
	)(
		input clk,								//Clock
		input reset,							//Reset line
		input [ADDR_WIDTH-1:0] addr,			//Address to read from or write to
		input write_enable,						//High if data_in should be written to addr
		input [DATA_WIDTH-1:0] data_in,			//Data word to be written to memory
		output reg [DATA_WIDTH-1:0] data_out	//Data word at addr
    );
	
	reg [DATA_WIDTH-1:0] memory [0:DEPTH-1];	//Internal memory
	
	initial begin
		`reset_memory(INIT_MEM_FILE, memory);
	end
	
	
	always @(posedge clk) begin
		if (reset) begin
			`reset_memory(INIT_MEM_FILE, memory);
		end else begin
			if (write_en) begin
				memory[addr] = data_in;
			end else begin
				data_out <= memory[addr];
			end
		end
	end
	
endmodule
