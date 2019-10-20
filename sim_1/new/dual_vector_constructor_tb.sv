`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2019 12:48:47 PM
// Design Name: 
// Module Name: dual_vector_constructor_tb
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


module dual_vector_constructor_tb(

    );
	
	localparam ELEMENT_WIDTH = 24;
	localparam ADDR_WIDTH = 8;
	localparam VECTOR_DIMENSION = 3;
	
	reg clk;
	reg reset;
	reg enabled;
	reg start;
	
	reg [ELEMENT_WIDTH-1:0] first_expected_elements;
	reg [ELEMENT_WIDTH-1:0] first_element_in;
	
	reg [ELEMENT_WIDTH-1:0] second_expected_elements;
	reg [ELEMENT_WIDTH-1:0] second_element_in;
	
	wire [ADDR_WIDTH-1:0] first_addr;
	wire [ADDR_WIDTH-1:0] second_addr;
	
	wire [ELEMENT_WIDTH-1:0] first_vector [0:VECTOR_DIMENSION-1];
	wire first_vector_ready;
	
	wire [ELEMENT_WIDTH-1:0] second_vector [0:VECTOR_DIMENSION-1];
	wire second_vector_ready;
	
	wire done;
	
	
	localparam [ELEMENT_WIDTH-1:0] ELEMENTS[] = {
		'hAA_00, 'h1B4_80, 'h59_16,
		'h15_F0, 'h4555_7E, 'h200_00,
		'h443_78, 'hEC_C0, 'hDDD_C4,
		'h17_38, 'h1738_00, 'h173_80,
		'h82F_80, 'h900_00, 'h999_99
	};
	
	
	dual_vector_constructor #(
		.ELEMENT_WIDTH(ELEMENT_WIDTH),
		.ADDR_WIDTH(ADDR_WIDTH),
		.VECTOR_DIMENSION(VECTOR_DIMENSION)
	) DUT (
		.clk(clk),
		.reset(reset),
		.enabled(enabled),
		.start(start),
		.first_expected_elements(first_expected_elements),
		.first_element_in(first_element_in),
		.second_expected_elements(second_expected_elements),
		.second_element_in(second_element_in),
		.first_addr(first_addr),
		.second_addr(second_addr),
		.first_vector(first_vector),
		.first_vector_ready(first_vector_ready),
		.second_vector(second_vector),
		.second_vector_ready(second_vector_ready),
		.done(done)
	);
	
	reg port_a_write_enable;
	reg [ADDR_WIDTH-1:0] write_addr;
	
	wire [ADDR_WIDTH-1:0] port_a_addr;
	assign port_a_addr = port_a_write_enable ? write_addr : first_addr;
	
	reg [ELEMENT_WIDTH-1:0] port_a_data_in;
	reg [ELEMENT_WIDTH-1:0] port_b_data_in;

	dual_port_block_ram #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.DATA_WIDTH(ELEMENT_WIDTH),
		.DEPTH(2 ** ADDR_WIDTH),
		.INIT_MEM_FILE("")
	) vector_file (
		.port_a_clk(clk),
		.port_a_addr(port_a_addr),
		.port_a_write_enable(port_a_write_enable),
		.port_a_data_in(port_a_data_in),
		.port_a_data_out(first_element_in),
		
		.port_b_clk(clk),
		.port_b_addr(second_addr),
		.port_b_write_enable(1'b0),
		.port_b_data_in(port_b_data_in),
		.port_b_data_out(second_element_in)
	);
	
	integer i;
	initial begin
		clk = 1'b0;
		reset = 1'b1;
		enabled = 1'b0;
		start = 1'b0;
		port_a_write_enable = 1'b0;
		port_b_data_in = 'Z;
		write_addr = 'b0;
		
		first_expected_elements = 'h6;
		second_expected_elements = 'h9;
		
		#50 reset = 1'b0;
		port_a_write_enable = 1'b1;
		
		write_addr = 'b0;
		port_a_data_in = ELEMENTS[0];
		
		for (i = 1; i < $size(ELEMENTS); i = i + 1) begin
			#10 write_addr = i;
			port_a_data_in = ELEMENTS[i];
		end
		
		#10 port_a_write_enable = 1'b0;
		#5 enabled = 1'b1;
		start = 1'b1;
		#5 start = 1'b0;
	end
	
	always begin
		#5 clk = ~clk;
	end
	
endmodule
