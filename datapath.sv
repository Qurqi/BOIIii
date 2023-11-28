module datapath(clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads, writenum, write, Z_out, N_out, V_out, datapath_out, sximm8, sximm5, PC, mdata);

//Declare all inputs and outputs

input write, clk, loada, loadb, loadc, asel, bsel, loads;

input [3:0] vsel;

input [1:0] shift, ALUop;

input [2:0] writenum, readnum;

input [7:0] PC;

input [15:0] sximm8, sximm5, mdata;

output [15:0] datapath_out;

output Z_out, N_out, V_out;

//Declare all internal signals

wire [15:0] data_out, Da, Qb, Db, Dc, sout, Ain, Bin, out;

wire Z, N, V, Dz, Dn, Dv;

wire [3:0] vsel;

reg [15:0] Qa, in, datapath_out, data_in;

reg Z_out, N_out, V_out;


//Write code for Multiplexer 

always_comb begin

case(vsel)

	4'b0001 : data_in = datapath_out;
	4'b0010 : data_in = {8'd0,PC};
	4'b0100 : data_in = sximm8;
	4'b1000 : data_in = mdata;

	default: data_in = 16'bxxxxxxxxxxxxxxxx;
endcase
end

regfile REGFILE(data_in, writenum, write, readnum, clk, data_out);


///// LOAD REGISTER A ///////////////

vDFF #16 A(clk, Da, Qa); 

assign Da = (loada ? data_out : Qa);

///// LOAD REGISTER B ///////////////

vDFF #16 B(clk, Db, in);

assign Db = (loadb ? data_out : in);

///// SHIFTER //////////////////////

shifter shifter(in, shift, sout);

///// LOAD REGISTER B ///////////////

assign Ain = (asel ? 16'd0 : Qa);

assign Bin = (bsel ? sximm5 : sout);
	 
ALU adder(Ain, Bin, ALUop, out, Z, N, V);

//Register load enable circuit C

assign Dc = (loadc ? out : datapath_out);

vDFF #16 C(clk, Dc, datapath_out);

//Register load enable for Z_out

vDFF Zflip(clk, Dz, Z_out);

assign Dz = (loads ? Z : Z_out);

//Register load enable for N_out

vDFF Nflip(clk, Dn, N_out);

assign Dn = (loads ? N : N_out);

//Register load enable for V_out

vDFF Vflip(clk, Dv, V_out);

assign Dv = (loads ? V : V_out);

endmodule
