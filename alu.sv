module ALU(Ain,Bin,ALUop,out,Z,N,V);

input [15:0] Ain, Bin;
input [1:0] ALUop;

output [15:0] out;
output Z, N, V;

reg [15:0] out;
reg Z, N, V;


// fill out the rest

assign out = ((ALUop == 2'b00) ? (Ain + Bin): 
	      (ALUop == 2'b01) ? (Ain - Bin):
	      (ALUop == 2'b10) ? (Ain & Bin):
	      (ALUop == 2'b11) ? (~Bin): 16'dx);

			
always_comb begin

	case(ALUop)
		
		2'b01 : begin 
			V = 1'b0;
			if((Ain[15] == 1'b1) && (Bin[15] == 1'b0) && (out[15] == 1'b0)) 
				V = 1'b1;
			if((Ain[15] == 1'b0) && (Bin[15] == 1'b1) && (out[15] == 1'b1)) 
				V = 1'b1;
			N = ((out[15] == 1'b1) ? 1'b1 : 1'b0); 
			Z = ((out == 16'b0000000000000000) ? 1'b1 : 1'b0);
			end
		default : begin N = 1'b0; V = 1'b0; Z = 1'b0; end
	endcase
end

endmodule
