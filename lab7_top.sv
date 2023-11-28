`define RST  5'b00000 
`define DECODE  5'b00001 
`define getA  5'b00010
`define getB  5'b00011 
`define ADD  5'b00100 
`define CMP  5'b00101 
`define AND  5'b00110
`define MVN  5'b00111
`define WriteReg  5'b01000
`define MOVimm 5'b01001 
`define MOV1 5'b01010 
`define MOV2 5'b01011 
`define MOV3 5'b01100 
`define IF1 5'b01101 
`define IF2 5'b01110 
`define UpdatePC 5'b01111 
`define LDR 5'b10000
`define STR 5'b10001
`define HALT 5'b10010
`define ADDS_sx5 5'b10011
`define ADDL_sx5 5'b10100
`define read_mem 5'b10101
`define load_data 5'b10110
`define write_memdata 5'b10111
`define store_rd 5'b11000
`define load_mem 5'b11001
`define MREAD 2'b01 
`define MWRITE  2'b10
`define MNONE 2'b00 


module lab7_top(KEY, SW, LEDR);

	input [1:0] KEY;
   input [9:0] SW;

   wire [15:0]  read_data, din, dout, write_data;
	wire [7:0] write_address, read_address;
	wire [8:0] mem_addr;
	wire [1:0] mem_cmd;
	wire reset, clk, msel, write, load, N, V, Z;

	output [9:0] LEDR;

	reg [9:0] LEDR;

	cpu CPU(clk, reset, load, N, V, Z, read_data, write_data, mem_cmd, mem_addr);
	
	RAM MEM(clk, read_address, write_address, write, din, dout);

	assign clk =  ~ KEY[0];

	assign reset = ~ KEY[1];

	assign din = write_data;

	assign write_address = mem_addr[7:0];

	assign read_address = write_address;

	assign msel = (1'b1 == mem_addr[8:8]);

	assign write = (msel && (`MWRITE == mem_cmd));  		

	assign read_data = (( msel && (`MREAD == mem_cmd)) ? dout : {16{1'bz}});     

	assign read_data = ({ mem_cmd, mem_addr} == {`MREAD, 9'h140}) ? {8'h00, SW[7:0]} : {16{1'bz}};


	always_ff@(posedge clk)
		begin
			if({mem_cmd,  mem_addr} == {`MWRITE, 9'h100})  LEDR[7:0] = write_data[7:0];
		end
	
	always
		begin
		
		LEDR[9:8] = 2'b00;
		
		end
	
endmodule
	
