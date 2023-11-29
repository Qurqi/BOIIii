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

module cpu_tb();

wire N, V, Z;
wire [15:0] write_data;
wire [8:0] mem_addr;
wire [1:0] mem_cmd;

reg clk, reset, err;

reg [15:0] read_data;

cpu DUT(clk, reset, load, N, V, Z, read_data, write_data, mem_cmd, mem_addr);

initial
forever begin

clk = 1'b0; #5;
clk = 1'b1; #5;

end

initial begin
 
err = 1'b0;
reset = 1'b0;

#5;

reset = 1'b1;

#5;

reset = 1'b0;

read_data = 16'b1101000000000011; //Test MOV #

#70;

assert(cpu_tb.DUT.DP.REGFILE.R0 == 16'd3) $display("Positive MOV PASS");
	else begin  $error("FAIL"); err = 1'b1; end

read_data = 16'b1101000100000010; //Test MOV 2

#70;

assert(cpu_tb.DUT.DP.REGFILE.R1 == 16'd2) $display("Positive MOV PASS");
	else begin  $error("FAIL"); err = 1'b1; end

read_data = 16'b1010000001000001; //Test ADD  = 5
 
#96;

assert(cpu_tb.DUT.DP.REGFILE.R2 == 16'd5) $display("ADD PASS");
	else begin  $error("FAIL"); err = 1'b1; end

read_data = 16'b1110000000000000; //test HALT

#40;

assert(cpu_tb.DUT.SM.state == `HALT) $display("HALT PASS");
	else begin  $error("FAIL"); err = 1'b1; end

$stop;

end

endmodule