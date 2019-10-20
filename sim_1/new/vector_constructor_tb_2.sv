`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2019 06:56:36 PM
// Design Name: 
// Module Name: vector_constructor_tb_2
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


module vector_constructor_tb_2(

    );
	
	localparam ELEMENT_WIDTH = 24;
	localparam ADDR_WIDTH = 3;
	localparam VECTOR_DIMENSION = 3;
	
	reg clk;
	reg long_clk;
	reg reset;
	reg [ELEMENT_WIDTH-1:0] expected_elements;
	
	wire [ELEMENT_WIDTH-1:0] element_in;
	
	wire [ADDR_WIDTH-1:0] addr;
	wire [ELEMENT_WIDTH-1:0] vector [0:VECTOR_DIMENSION-1];
	wire done;
	wire vector_ready;
	
	localparam [ELEMENT_WIDTH-1:0] ELEMENTS[0:5] = {
		'hAA_00, 'h1B4_80, 'h59_16,
		'h15_F0, 'h4555_7E, 'h200_00
	};
	
	localparam ELEMENTS_LENGTH = $size(ELEMENTS);
	
	wire [ELEMENT_WIDTH-1:0] port_a_data_out;
	
	reg port_a_clk;
	reg [ADDR_WIDTH-1:0] port_a_addr;
	reg port_a_write_enable;
	reg [ELEMENT_WIDTH-1:0] port_a_data_in;
	
	dual_port_block_ram #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.DATA_WIDTH(ELEMENT_WIDTH),
		.DEPTH(ELEMENTS_LENGTH),
		.INIT_MEM_FILE("")
	) ram (
		.port_a_clk(port_a_clk),					//Port A is used to prepare the ram for the test
		.port_a_addr(port_a_addr),
		.port_a_write_enable(port_a_write_enable),
		.port_a_data_in(port_a_data_in),
		.port_a_data_out(port_a_data_out),
		
		.port_b_clk(clk),
		.port_b_addr(addr),
		.port_b_write_enable(1'b0),
		.port_b_data_in('b0),
		.port_b_data_out(element_in)
	);
	
	wire enabled;
	assign enabled = ~reset;
	
	wire [ELEMENT_WIDTH-1:0] elements_received;
	
	shift_vector_constructor #(
		.ELEMENT_WIDTH(ELEMENT_WIDTH),
		.ADDR_WIDTH(ADDR_WIDTH),
		.VECTOR_DIMENSION(VECTOR_DIMENSION)
	) DUT (
		.clk(clk),
		.reset(reset),
		.expected_elements(expected_elements),
		.element_in(element_in),
		.enabled(enabled),
		.elements_received(elements_received),
		.addr(addr),
		.vector(vector),
		.done(done),
		.vector_ready(vector_ready)
	);
	
	integer i;
	initial begin
		port_a_write_enable = 1'b1;
		port_a_clk = 1'b0;
		for (i = 0; i < $size(ELEMENTS); i = i + 1) begin
			#10 port_a_clk = 1'b0;
			port_a_addr = i;
			port_a_data_in = ELEMENTS[i];
			#10 port_a_clk = 1'b1;
		end
		
		#10 port_a_write_enable = 1'b0;
	
		clk = 1'b0;
		long_clk = 1'b0;
		reset = 1'b1;
		expected_elements = $size(ELEMENTS);
		#50 reset = 1'b0;
	end
	
	
	always begin
		#5 clk = ~clk;
	end
	
	always begin
		#10 long_clk = ~long_clk;
	end
	
endmodule
