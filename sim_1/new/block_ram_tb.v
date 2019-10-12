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
	localparam DATA_WIDTH = 3;
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
	
	initial begin
		clk = 1'b0;
		addr = 'b0;
		write_enable = 1'b0;
		data_in = 'b0;
		#50 reset = 1'b1;
		#50 reset = 1'b0;
		write_enable = 1'b1;
		data_in = 3'b110;
		addr = 'b0;
		#10 data_in = 3'b010;
		addr = 4'b0001;
		#10 data_in = 3'b100;
		addr = 4'b0010;
		#10 data_in = 3'b001;
		addr = 4'b0011;
		#10 data_in = 3'b111;
		addr = 4'b0100;
		#10 data_in = 'b0;
		addr = 'b0;
		write_enable = 1'b0;
		#10 addr = 4'b0001;
		#10 addr = 4'b0010;
		#10 addr = 4'b0011;
		#10 addr = 4'b0100;
		#10 addr = 4'b0101;
		#10 addr = 4'b0110;
	end
	
	always begin
		#5 clk = ~clk;
	end
	
endmodule
