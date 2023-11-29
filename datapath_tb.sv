module datapath_tb;
	
	reg [15:0] sximm8, sximm5, mdata;
	reg [8:0] PC;
	reg [3:0] vsel;
	reg [2:0] writenum, readnum;
	reg [1:0] ALUop, shift;
	reg clk, write, loada, loadb, asel, bsel, loadc, loads, err;
	
	wire [15:0] datapath_out;
	wire Z_out, N_out, V_out;

	datapath DUT(clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads, writenum, write, Z_out, N_out, V_out, datapath_out, sximm8, sximm5, PC, mdata);



	initial 
		begin
		clk = 1'b0;
		#4;
		forever	
			begin
				clk = 1'b1;
				#5;
				clk = 1'b0;
				#5;
			end
		end

	initial
		begin
		err = 1'b0;
			
//testing vsel MUX
		mdata = 16'd54;
		sximm8 = 16'd72;
		PC = 9'd20;

		vsel = 4'b1000;
		#10;
			if(DUT.data_in !== mdata) err = 1'b1;
			
		vsel = 4'b0100;
		#10;
			if(DUT.data_in !== sximm8) err = 1'b1;
			
		vsel = 4'b0010;
		#10;
			if(DUT.data_in !== {8'd0, PC[8:0]}) err = 1'b1;

		vsel = 4'b0001;
		#10;
			if(DUT.data_in !== DUT.datapath_out) err = 1'b1;

//load value into R1
		sximm8 = 16'b1111111111111100;
		write = 1'b1;
		vsel = 4'b0100;
		writenum = 3'b001;
		#10; //50
		if(DUT.REGFILE.R1 !== 16'b1111111111111100) err = 1'b1;


//load value into R3 and read R1 to A
		sximm8 = 16'b0000000000000111;
		write = 1'b1;
		vsel = 4'b0100;
		writenum = 3'b011;
		readnum = 3'b001;
		loada = 1'b1;
		#10;
		if(DUT.REGFILE.R3 !== 16'b0000000000000111) err = 1'b1;
		if(DUT.Qa !== 16'b1111111111111100) err = 1'b1;

			
//Read R3 to B
		loada = 1'b0;
		write = 1'b0;
		readnum = 3'b011;
		loadb = 1'b1;
		#10;
		if(DUT.in !== 16'b0000000000000111) err = 1'b1;

			
//Add A and B(shifter right 1) put in datapath_out
		loadb = 1'b0;
		ALUop = 2'b00;
		shift = 2'b10;
		asel = 1'b0;
		bsel = 1'b0;
		loadc = 1'b1;
		loads = 1'b1;
		#10;
		if(datapath_out !== 16'b1111111111111111) err = 1'b1;
		if(Z_out !== 1'b0) err = 1'b1;
    		if(N_out !== 1'b0) err = 1'b1;
		if(V_out !== 1'b0) err = 1'b1;
//#50s

//CMP A and B put in datapath_out ( (+) - (-) = (-) )
		ALUop = 2'b01;
		shift = 2'b00;
		asel = 1'b0;
		bsel = 1'b0;
		loadc = 1'b1;
		loads = 1'b1;
		#10; //90
		if(datapath_out !== 16'b1111111111110101) err = 1'b1;
		if(Z_out !== 1'b0) err = 1'b1;
    		if(N_out !== 1'b1) err = 1'b1;
    		if(V_out !== 1'b0) err = 1'b1;


//Anded A and B put in datapath_out
		ALUop = 2'b10;
		shift = 2'b00;
		asel = 1'b0;
		bsel = 1'b0;
		loadc = 1'b1;
		#10; //100
		if(datapath_out !== 16'b0000000000000100) err = 1'b1;


//NOT B put in datapath_out
		ALUop = 2'b11;
		shift = 2'b00;
		asel = 1'b0;
		bsel = 1'b0;
		loadc = 1'b1;
		loads = 1'b1;
		#10;
		if(datapath_out !== 16'b1111111111111000) err = 1'b1;
		if(Z_out !== 1'b0) err = 1'b1;


//Write to R5 (from data_path_out
		write = 1'b1;
		vsel = 4'b0001;
		writenum = 3'b101;
		readnum = 3'b101;
		#10;
		if(DUT.REGFILE.R5 !== 16'b1111111111111000) err = 1'b1;

//#90s

//setting multiplexers for b and a to alternates
		asel = 1'b1;
		bsel = 1'b1;
		#10;
		if(DUT.Ain !== 16'b0000000000000000) err = 1'b1;
		if(DUT.Bin !== sximm5) err = 1'b1;
			
			
//loading new values int A and B
		sximm8 = 16'b0111111111111100;
		write = 1'b1;
		vsel = 4'b0100;
		writenum = 3'b001;
		#10;

		sximm8 = 16'b1000000000000111;
		write = 1'b1;
		vsel = 4'b0100;
		writenum = 3'b011;
		readnum = 3'b001;
		loada = 1'b1;
		#10;//150
			
		loada = 1'b0;
		write = 1'b0;
		readnum = 3'b011;
		loadb = 1'b1;
		#10;

			
//CMP A and B put in datapath_out ( (+) - (-) = (-) )
		ALUop = 2'b01;
		shift = 2'b00;
		asel = 1'b0;
		bsel = 1'b0;
		loadc = 1'b1;
		loads = 1'b1;
		#10;
		if(Z_out !== 1'b0) err = 1'b1;
		if(N_out !== 1'b1) err = 1'b1;
		if(V_out !== 1'b1) err = 1'b1;
			

//loading new values int A and B
		sximm8 = 16'b0000000001010101;
		write = 1'b1;
		vsel = 4'b0100;
		writenum = 3'b001;
		#10;

		write = 1'b1;
		vsel = 4'b0100;
		writenum = 3'b011;
		readnum = 3'b001;
		loada = 1'b1;
		#10;
			
		loada = 1'b0;
		write = 1'b0;
		readnum = 3'b011;
		loadb = 1'b1;
		#10;

			
//CMP A and B put in datapath_out ( (+) - (+) = (0) )
		ALUop = 2'b01;
		shift = 2'b00;
		asel = 1'b0;
		bsel = 1'b0;
		loadc = 1'b1;
		loads = 1'b1;
		#10;
		if(Z_out !== 1'b1) err = 1'b1;
		if(N_out !== 1'b0) err = 1'b1;
		if(V_out !== 1'b0) err = 1'b1;


		$stop;
		end
endmodule

		
