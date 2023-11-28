module ins_decoder(ins, nsel, ALUop, sximm5, sximm8, shift, readnum, writenum, opcode, op);

////////////  I/O DECLARATION  ///////////////////
  
  input [2:0] nsel;
  
  input [15:0] ins;

  output [1:0] ALUop, shift, op;

  output [2:0] readnum, writenum, opcode;

  output [15:0] sximm5, sximm8;
  
/////////  INTERNAL SIGNAL ASSIGNMENT  ///////////
  
  wire [2:0] Rm, Rd, Rn;

  wire [7:0] imm8;

  wire [4:0] imm5;

  wire [2:0] temp;
  
/////////  ASSIGN DIRECT-OUTPUTS  ////////////////
  
  assign opcode = ins[15:13];

  assign op = ins[12:11];
  
  assign Rm = ins[2:0];
  
  assign Rd = ins[7:5];
  
  assign Rn = ins[10:8];

  assign shift = ins[4:3];

  assign imm8 = ins[7:0];

  assign imm5 = ins[4:0];
  
  assign ALUop = ins[12:11];
  
////////  REGISTER MULTIPLEXER  //////////////////
  
  assign writenum = ((nsel == 3'b001) ? Rm :
			(nsel == 3'b010) ? Rd :
			  (nsel == 3'b100) ? Rn : 3'bxxx);

////////  ASSIGN WRITENUM & READNUM  //////////////////

  assign readnum = writenum;

///////////  SIGN EXTEND ////////////////////////

  assign sximm8 = {{8{imm8[7]}},imm8};

  assign sximm5 = {{11{imm5[4]}}, imm5};

////////////  THAT'S ALL FOLKS  ///////////////////
  
endmodule
