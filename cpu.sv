module cpu(clk, reset, load, N, V, Z, read_data, write_data, mem_cmd, mem_addr);
input clk, reset, load;

output [1:0] mem_cmd;
input [15:0] read_data;
output [15:0] write_data;
output [8:0] mem_addr;

output N, V, Z;

  
/////////////////////////////////////////////////////  DECLARE I/O FOR MODULES  ///////////////////////////////////////////////////////////////////////////////////////////////////////

  wire loada, loadb, asel, bsel, loadc, loads, write, clk, reset, load_ir, N, V, Z, Z_out, N_out, V_out, addr_sel, load_pc, load_addr, reset_pc;
  wire [1:0] ALUop, shift, op, mem_cmd;
  wire [2:0] readnum, writenum, nsel, opcode;
  wire [3:0] vsel;
  wire [15:0] in, ins, sximm5, sximm8, datapath_out, out, Din, mdata, write_data, read_data;

  reg [8:0] PC, DA, mem_addr, next_pc;


////////////////////////////////////////////////////  DEFINE AND INSTANTIATE INSTRUCTION FLIP-FLOP  /////////////////////////////////////////////////////////////////////////////////////

  vDFF #16 INS_R(clk, Din, ins);
  assign Din = (load_ir ? read_data : ins);

////////////////////////////////////////////////////  INSTANTIATE DECODER, FSM, DATAPATH AND MEMORY  ///////////////////////////////////////////////////////////////////////////////////////////

  ins_decoder DCDR (ins, nsel, ALUop, sximm5, sximm8, shift, readnum, writenum, opcode, op);

  fsm SM (opcode, op, nsel, clk, reset, vsel, loada, loadb, asel, bsel, loadc, loads, write, load_pc, reset_pc, load_ir, addr_sel, mem_cmd, load_addr); 

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
		if(load_addr) DA = datapath_out[8:0];
	end

always_comb
	begin
		if(reset_pc) next_pc = 9'd0;
		else next_pc = (PC + 1'b1);

		if(addr_sel) mem_addr = PC;
		else mem_addr = DA;
	end	

endmodule
