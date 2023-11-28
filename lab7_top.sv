`define MREAD 2'b01
`define MWRITE 2'b10
`define MNONE 2'b00

module lab7_top( mem_cmd, mem_addr, read_data, write_data )

	input [15:0]  read_data, write_data;
	input [8:0] mem_addr;
	input [1:0] mem_cmd, KEY;

	wire [15:0]  read_data, din:
	wire[7:0] write_address, read_address;
	wire reset, clk, msel, write;

	output [7:0] , SW, LEDR;

	reg [7:0] LEDR;


RAM  MEM(clk, read_address, write_address, write, din, dout);

assign clk =  ~ KEY[0]

assign reset = ~ KEY[1]


assign din = write_data

assign write_address = mem_addr;

assign read_address = write_address;



assign msel = (1'b1 == mem_addr[8:8]);

assign write = (msel && (`MWRITE == mem_cmd)[0]);  			//maybe remove the [0]

assign read_data = ( msel && (`MWREAD == mem_cmd)[0] ) ? dout : {16{1’bz}}; 	        //maybe remove the [0]



assign read_data = ({ mem_cmd, mem_addr} == {`MREAD, 9'h140}) ? {8'h00, SW[7:0]} : {16{1'bz}};



always_ff@(posedge clk)
	begin
		if({mem_cmd,  mem_addr} == {`MWRITE, 9`h100})  LEDR[7:0] = write_data;
	end
	
