`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2019 12:16:12 PM
// Design Name: 
// Module Name: block_ram_tb
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


module block_ram_tb(

    );
	
	localparam ADDR_WIDTH = 4;
	localparam DATA_WIDTH = 24;
	localparam DEPTH = 2 ** ADDR_WIDTH;
	localparam INIT_MEM_FILE = "";
	
	reg clk;
	reg reset;
	reg [ADDR_WIDTH-1:0] addr;
	reg write_enable;
	reg [DATA_WIDTH-1:0] data_in;
	wire [DATA_WIDTH-1:0] data_out;
	
	block_ram #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.DATA_WIDTH(DATA_WIDTH),
		.DEPTH(DEPTH),
		.INIT_MEM_FILE(INIT_MEM_FILE)
	) DUT (
		.clk(clk),
		.reset(reset),
		.addr(addr),
		.write_enable(write_enable),
		.data_in(data_in),
		.data_out(data_out)
	);
	
	//TODO: Finish the testbench
	
endmodule
