`define HALT 5'b10010

module lab7_top_tb;
  reg [3:0] KEY;
  reg [9:0] SW;
  wire [9:0] LEDR; 
  wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  reg err;

  lab7_top DUT(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);

  initial forever begin
    KEY[0] = 0; #5;
    KEY[0] = 1; #5;
  end

  initial begin
    err = 0;
    KEY[1] = 1'b0; // reset asserted
   
    if (DUT.MEM.mem[0] !== 16'b1101000000000100) begin err = 1; $display("FAILED: mem[0] wrong"); $stop; end
    if (DUT.MEM.mem[1] !== 16'b1101000100001000) begin err = 1; $display("FAILED: mem[1] wrong"); $stop; end
    if (DUT.MEM.mem[2] !== 16'b1010000100000000) begin err = 1; $display("FAILED: mem[2] wrong"); $stop; end
    if (DUT.MEM.mem[3] !== 16'b1000000100000000) begin err = 1; $display("FAILED: mem[3] wrong"); $stop; end
    if (DUT.MEM.mem[4] !== 16'b0110000000000000) begin err = 1; $display("FAILED: mem[4] wrong"); $stop; end
    if (DUT.MEM.mem[5] !== 16'b1110000000000000) begin err = 1; $display("FAILED: mem[5] wrong"); $stop; end
    if (DUT.MEM.mem[12] !== 16'hBEEF) begin err = 1; $display("FAILED: mem[12] wrong"); $stop; end

    @(negedge KEY[0]);

    KEY[1] = 1'b1;

    #10; 

    
    if (DUT.CPU.PC !== 9'b0) begin err = 1; $display("FAILED: PC is not reset to zero."); $stop; end

    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC); 
 
    if (DUT.CPU.PC !== 9'h1) begin err = 1; $display("FAILED: PC should be 1."); $stop; end
    
    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  

    if (DUT.CPU.PC !== 9'h2) begin err = 1; $display("FAILED: PC should be 2."); $stop; end
    if (DUT.CPU.DP.REGFILE.R0 !== 16'h4) begin err = 1; $display("FAILED: R0 should be 4."); $stop; end  

    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  

    if (DUT.CPU.PC !== 9'h3) begin err = 1; $display("FAILED: PC should be 3."); $stop; end
    if (DUT.CPU.DP.REGFILE.R1 !== 16'h8) begin err = 1; $display("FAILED: R1 should be 8."); $stop; end  

    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  

    if (DUT.CPU.PC !== 9'h4) begin err = 1; $display("FAILED: PC should be 4."); $stop; end
    if (DUT.CPU.DP.REGFILE.R0 !== 16'd12) begin err = 1; $display("FAILED: R0 should be 12."); $stop; end

    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  
   
    if (DUT.CPU.PC !== 9'h5) begin err = 1; $display("FAILED: PC should be 5."); $stop; end
    if (DUT.MEM.mem[8] !== 16'd12) begin err = 1; $display("FAILED: m[8] should be 12."); $stop; end 

    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  
   
    if (DUT.CPU.PC !== 9'h6) begin err = 1; $display("FAILED: PC should be 6."); $stop; end
    if (DUT.CPU.DP.REGFILE.R0 !== 16'hBEEF) begin err = 1; $display("FAILED: R0 should be BEEF."); $stop; end 

    #50;
 
    if (DUT.CPU.PC !== 9'h6) begin err = 1; $display("FAILED: PC should be 7."); $stop; end
    if (DUT.CPU.SM.state !== `HALT) begin err = 1; $display("FAILED: State should be HALT."); $stop; end 

  
    $display("I hope you're hungry");

    $stop;

  end
endmodule