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

module cpu(clk, reset, load, N, V, Z, read_data, mem_addr, mem_cmd, read_data, write_data);
input clk, reset, load;
input [15:0] read_data;

output [15:0] out, write_data;
output [8:0] mem_addr
output [1:0] mem_cmd;
output N, V, Z:

  
/////////////////////////////////////////////////////  DECLARE I/O FOR MODULES  ///////////////////////////////////////////////////////////////////////////////////////////////////////

  wire loada, loadb, asel, bsel, loadc, loads, write, clk, reset, load_ir, Z_out, N_out, V_out, N, V, Z, addr_sel, load_pc, load_addr, reset_pc;
  wire [1:0] ALUop, shift, op, mem_cmd;
  wire [2:0] readnum, writenum, nsel, opcode;
  wire [3:0] vsel;
  wire [15:0] in, ins, sximm5, sximm8, datapath_out, out;

  reg [8:0] PC, DA, mem_addr, next_pc;
  
  assign PC = 8'd0;

////////////////////////////////////////////////////  DEFINE AND INSTANTIATE INSTRUCTION FLIP-FLOP  /////////////////////////////////////////////////////////////////////////////////////

  vDFF #16 INS_R(clk, Din, ins);
  assign Din = (load_ir ? read_data : ins);

////////////////////////////////////////////////////  INSTANTIATE DECODER, FSM, DATAPATH AND MEMORY  ///////////////////////////////////////////////////////////////////////////////////////////

  ins_decoder DCDR (ins, nsel, ALUop, sximm5, sximm8, shift, readnum, writenum, opcode, op);

  fsm SM (opcode, op, nsel, clk, reset, vsel, loada, loadb, asel, bsel, loadc, loads, write, load_ir, addr_sel, reset_pc, mem_cmd); ///still need too update

  datapath DP (clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads, writenum, write, Z_out, N_out, V_out, datapath_out, sximm8, sximm5, PC, mdata);

////////////////////////////////////////////////////  FIN  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

assign write_data = datapath_out;

assign mdata = read_data;

assign N = N_out;

assign V = V_out;

assign Z = Z_out;


////////////////////////////////////////////////////  Added  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

always_ff@(posedge clk)
	begin
		if(load_pc) PC = next_pc;
		if(load_addr) DA = datapath_out;
	end

always_comb
	begin
		if(reset_pc) next_pc = 9'd0;
		else next_pc = (PC + 1'b1;

		if(addr_sel) mem_addr = PC;
		else next_pc = DA;
	end	

endmodule
