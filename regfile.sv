module regfile(data_in, writenum, write, readnum, clk, data_out);

	input [15:0] data_in;
	input [2:0] writenum, readnum;
	input write, clk;
	output [15:0] data_out;

	reg [7:0] writenum_dec, readnum_dec; //outputs of decoders
	reg [15:0] R0, R1, R2, R3, R4, R5, R6, R7, data_out; //register values

	always_comb //3:8 decoder for the write num
		begin
		writenum_dec = 1 << writenum; //3:8 decoder
		end
	
	always_ff @(posedge clk) //ff for the register R0
		begin
		if(write == 1'b1) // checking in write is high
			case(writenum_dec) // checking whcih register should be writen
				8'b00000001: R0 = data_in; //setting R__ to the input
				8'b00000010: R1 = data_in;
				8'b00000100: R2 = data_in;
				8'b00001000: R3 = data_in;
				8'b00010000: R4 = data_in;
				8'b00100000: R5 = data_in;
				8'b01000000: R6 = data_in;
				8'b10000000: R7 = data_in;
			endcase
		end 

	
	always_comb //multiplxer for read num
		begin
		readnum_dec = 1 << readnum; //3:8 decoder

		case(readnum_dec) // multiplexer for the data out
			8'b00000001: data_out = R0; //setting the output to R__
			8'b00000010: data_out = R1;
			8'b00000100: data_out = R2;
			8'b00001000: data_out = R3;
			8'b00010000: data_out = R4;
			8'b00100000: data_out = R5;
			8'b01000000: data_out = R6;
			8'b10000000: data_out = R7;
			default : data_out = 8'bxxxxxxxx;
		endcase
		end
endmodule
