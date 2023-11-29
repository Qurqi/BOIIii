//States
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

//Mem cmd values
`define MREAD 2'b01 
`define MWRITE  2'b10
`define MNONE 2'b00 

//HEX letters
`define La 7'b0001000
`define Lb 7'b0000011
`define Lc 7'b1000110
`define Ld 7'b0100001 
`define Le 7'b0000110
`define Lf 7'b0001110 

//HEX numbers
`define N0 7'b1000000
`define N1 7'b1111001
`define N2 7'b0100100
`define N3 7'b0110000
`define N4 7'b0011001
`define N5 7'b0010010
`define N6 7'b0000010
`define N7 7'b1111000 
`define N8 7'b0000000
`define N9 7'b0011000

//HEX empty
`define Hn 7'b1111111

module lab7_top(KEY, SW, LEDR, HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);

   input [3:0] KEY;
   input [9:0] SW;

   wire [15:0]  read_data, din, dout, write_data;
	wire [7:0] write_address, read_address;
	wire [8:0] mem_addr;
	wire [1:0] mem_cmd;
	wire reset, clk, msel, write, load, N, V, Z;

	output [9:0] LEDR;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

	reg [9:0] LEDR;
  
  assign HEX5[0] = ~Z;
  assign HEX5[6] = ~N;
  assign HEX5[3] = ~V;
  
  sseg H0(write_data[3:0],   HEX0);
  sseg H1(write_data[7:4],   HEX1);
  sseg H2(write_data[11:8],  HEX2);
  sseg H3(write_data[15:12], HEX3);
  
  assign HEX4 = 7'b1111111;
  assign {HEX5[2:1],HEX5[5:4]} = 4'b1111; // disabled
 

	cpu CPU(clk, reset, load, N, V, Z, read_data, write_data, mem_cmd, mem_addr);
	
	RAM MEM(clk, read_address, write_address, write, din, dout);

	assign clk =  ~ KEY[0];

	assign reset = ~ KEY[1];

	assign din = write_data;

	assign write_address = mem_addr[7:0];

	assign read_address = write_address;

	assign msel = (1'b0 == mem_addr[8:8]);

	assign write = (msel && (`MWRITE == mem_cmd));  		

	assign read_data = (( msel && (`MREAD == mem_cmd)) ? dout : {16{1'bz}});     

	assign read_data = ( ( {mem_cmd, mem_addr} == {`MREAD, 9'h140} ) ? ({8'h00, SW[7:0]}) : ({16{1'bz}}) );


	always_ff@(posedge clk)
		begin
			if({mem_cmd,  mem_addr} == {`MWRITE, 9'h100})  LEDR[7:0] = write_data[7:0];
		end
	
	always @(*)
		begin
		
		LEDR[9:8] = 2'b00;
		
		end
	
endmodule

module sseg(in,segs);
  input [3:0] in;
  output reg [6:0] segs;


  // NOTE: The code for sseg below is not complete: You can use your code from
  // Lab4 to fill this in or code from someone else's Lab4.  
  //
  // IMPORTANT:  If you *do* use someone else's Lab4 code for the seven
  // segment display you *need* to state the following three things in
  // a file README.txt that you submit with handin along with this code: 
  //
  //   1.  First and last name of student providing code
  //   2.  Student number of student providing code
  //   3.  Date and time that student provided you their code
  //
  // You must also (obviously!) have the other student's permission to use
  // their code.
  //
  // To do otherwise is considered plagiarism.
  //
  // One bit per segment. On the DE1-SoC a HEX segment is illuminated when
  // the input bit is 0. Bits 6543210 correspond to:
  //
  //    0000
  //   5    1
  //   5    1
  //    6666
  //   4    2
  //   4    2
  //    3333
  //
  // Decimal value | Hexadecimal symbol to render on (one) HEX display
  //             0 | 0
  //             1 | 1
  //             2 | 2
  //             3 | 3
  //             4 | 4
  //             5 | 5
  //             6 | 6
  //             7 | 7
  //             8 | 8
  //             9 | 9
  //            10 | A
  //            11 | b
  //            12 | C
  //            13 | d
  //            14 | E
  //            15 | F
 
         always_comb begin
//dispalying the number from the switches
                                    case(in[3:0])
                                             4'b0000: segs = `N0;

                                             4'b0001: segs = `N1;

                                             4'b0010: segs = `N2;

                                             4'b0011: segs = `N3;

                                             4'b0100: segs = `N4;

                                             4'b0101: segs = `N5;

                                             4'b0110: segs = `N6;

                                             4'b0111: segs = `N7;

                                             4'b1000: segs = `N8;

                                             4'b1001: segs = `N9;

                                             4'b1010: segs = `La;

                                             4'b1011: segs = `Lb;

                                             4'b1100: segs = `Lc;

                                             4'b1101: segs = `Ld;

                                             4'b1110: segs = `Le;

                                             4'b1111: segs = `Lf;

//if no other cases exist then diplaying nothing
                                             default: segs = 7'b0110110;
                       		    endcase
         end

endmodule
	
