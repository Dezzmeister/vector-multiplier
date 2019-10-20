`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Boston College
// Engineer: Joe Desmond
// 
// Create Date: 10/19/2019 11:48:00 AM
// Design Name: Dual Port Block Ram
// Module Name: dual_port_block_ram
// Project Name: Vector Multiplier
// Target Devices: Basys 3 FPGA Board (Xilinx Artix-7)
// Tool Versions: 
// Description: A RAM module with two writable ports, intended to be inferred as Block RAM
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


module dual_port_block_ram #(
		parameter ADDR_WIDTH = 12,						//Bit length of each address
		parameter DATA_WIDTH = 8,						//Bit length of one addressable word
		parameter DEPTH = 2048,							//Number of addressable words
		parameter INIT_MEM_FILE = ""					//Optional memory initializer
    )(		
		input port_a_clk,								//Port A clock
		input [ADDR_WIDTH-1:0] port_a_addr,				//Port A address
		input port_a_write_enable,						//Port A write enable
		input [DATA_WIDTH-1:0] port_a_data_in,			//Port A data in line
		output reg [DATA_WIDTH-1:0] port_a_data_out,	//Port A data out line
		
		input port_b_clk,								//Port B clock
		input [ADDR_WIDTH-1:0] port_b_addr,				//Port B address
		input port_b_write_enable,						//Port B write enable
		input [DATA_WIDTH-1:0] port_b_data_in,			//Port B data in line
		output reg [DATA_WIDTH-1:0] port_b_data_out		//Port B data out line
	);
	
	reg [DATA_WIDTH-1:0] memory [0:DEPTH-1];			//Internal memory
	
	initial begin
		`reset_memory(INIT_MEM_FILE, memory);
	end
	
	
	always @(posedge port_a_clk) begin
		port_a_data_out <= memory[port_a_addr];
		
		if (port_a_write_enable) begin
			memory[port_a_addr] <= port_a_data_in;
		end
	end
	
	always @(posedge port_b_clk) begin
		port_b_data_out <= memory[port_b_addr];
		
		if (port_b_write_enable) begin
			memory[port_b_addr] <= port_b_data_in;
		end
	end
	
endmodule
