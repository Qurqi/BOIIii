`define ST1  4'b0000 //wait
`define ST2  4'b0001 //decode
`define ST3  4'b0010 //getA
`define ST4  4'b0011 //getB
`define ST5  4'b0100 //ADD
`define ST6  4'b0101 //CMP
`define ST7  4'b0110 //AND
`define ST8  4'b0111 //MVN
`define ST9  4'b1000 //write reg
`define ST10 4'b1001 //MOVimm
`define ST11 4'b1011 //MOV.1
`define ST12 4'b1100 //MOV.2
`define ST13 4'b1101 //MOV.3

module cpu(clk, reset, load, in, out, N, V, Z, read_data, mem_addr, mem_cmd, read_data, write_data);
input clk, reset, load;
input [15:0] in;

output [15:0] out, read_data, write_data;
Output [8:0] mem_addr
Output [1:0] mem_cmd;
output N, V, Z:

  
/////////////////////////////////////////////////////  DECLARE I/O FOR MODULES  ///////////////////////////////////////////////////////////////////////////////////////////////////////

  wire loada, loadb, asel, bsel, loadc, loads, write, clk, reset, load_ir, Z_out, N_out, V_out, N, V, Z, addr_sel, load_pc, load_addr, reset_pc;
  wire [1:0] ALUop, shift, op;
  wire [2:0] readnum, writenum, nsel, opcode;
  wire [3:0] vsel;
  wire [15:0] in, ins, sximm5, sximm8, datapath_out, out;

  reg [8:0] PC, DA, mem_addr, next_pc;
  
  assign PC = 8'd0;

////////////////////////////////////////////////////  DEFINE AND INSTANTIATE INSTRUCTION FLIP-FLOP  /////////////////////////////////////////////////////////////////////////////////////

vDFF #16 INS_R(clk, Din, ins);

assign Din = (load ? in : ins);

////////////////////////////////////////////////////  INSTANTIATE DECODER, FSM, AND DATAPATH  ///////////////////////////////////////////////////////////////////////////////////////////

  ins_decoder DCDR(ins, nsel, ALUop, sximm5, sximm8, shift, readnum, writenum, opcode, op);

  fsm SM(opcode, op, nsel, clk, reset, vsel, loada, loadb, asel, bsel, loadc, loads, write,    load_ir, addr_sel, reset_pc, mem_cmd); ///still need too update

  datapath DP(clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads, writenum, write, Z_out, N_out, V_out, datapath_out, sximm8, sximm5, PC, mdata);

////////////////////////////////////////////////////  FIN  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

assign out = datapath_out;

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
