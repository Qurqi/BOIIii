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
`define MOV.1 5'b01010 
`define MOV.2 5'b01011 
`define MOV.3 5'b01100 
`define IF1 5'b01101 
`define IF2 5'b01110 
`define UpdatePC 5'b01111 
`define LDR 5'b10000
`define STR 5'b10001
`define HALT 5'b10010
`define ADDS_sx5 5'b10011
`define ADDL_sx5 5'b10100
`define read_mem 5'b10101
`define store_mem 5'b10110
`define write_memdata 5'b10111
`define load_rd 5'b11000
`define MREAD 2'b01 
`define MWRITE  2'b10
`define MNONE 2'b00 

module fsm(opcode, op, nsel, clk, reset, vsel, loada, loadb, asel, bsel, loadc, loads, write, load_pc, reset_pc, load_ir, addr_sel, mem_cmd, load_addr);

  input reset, clk;
  input [1:0] op, mem_cmd;
  input [2:0] opcode;

  output loada, loadb, asel, bsel, loadc, loads, load_ir, write, addr_sel, load_pc, reset_pc, load_addr;
  output [2:0] nsel;
  output [3:0] vsel;

  reg loada, loadb, asel, bsel, loadc, loads, write;
  reg [2:0] nsel;
  reg [3:0] vsel, state;


  always_ff @(posedge clk)
    begin
      
      if (reset) state = `RST;
      
      else
          case(state)
            `RST:
              state = `IF1;
            
            `DECODE:
              casex({opcode, op})

                5'b11010 : state = `MOVimm;
                5'b11000 : state = `MOV.1;
                5'b101xx : state = `getA;
                5'b01100 : state = `LDR;
                5'b10000 : state = `STR;
                5'b111xx : state = `HALT;

                default: state = 5'bxxxxx;
              endcase
                
            `getA: 
              state = `getB;
            
            `getB: 
              case(op)

                2'b00 : state = `ADD;
                2'b01 : state = `CMP;
                2'b10 : state = `AND;
                2'b11 : state = `MVN;

                default: state = 5'bxxxxx;
              endcase
            
            `ADD: 
              state = `WriteReg;
            
            `CMP: 
              state = `WriteReg;
            
            `AND: 
              state = `WriteReg;
            
            `MVN: 
              state = `WriteReg;

            `WriteReg: 
              state = `IF1;
            
            `MOVimm: 
              state = `IF1;
            
            `MOV.1: 
              state = `MOV.2;
            
            `MOV.2: 
              state = `MOV.3;
            
            `MOV.3: 
              state = `IF1;
            
            `IF1:
                state = `IF2;

            `IF2:
                state = `UpdatePC;

            `UpdatePC:
                state = `DECODE;

            `LDR:
                state = `ADDL_sx5;

            `STR:
                state = `ADDS_sx5;

            `ADDL_sx5 :
                   state = `read_mem;

            `read_mem :
                    state = `write_memdata;

            `write_memdata :
                    state = `IF1;

            `ADDS_sx5 :
                   state = `store_mem;

            `store_mem :
                    state = `load_rd;

            `load_rd :
                    state = `IF1;

            `HALT :
                state = `HALT;


            
            default: state = 5'bxxxxx;
          endcase
    end
  
  always_comb
    begin
      
      //to avoid inferred latch
      {mem_cmd, loadA, loadb, asel, bsel, loadc, loads, load_ir, write, addr_sel, load_pc, load_ir, reset_pc, nsel, vsel} = 21'b000000000000000000000; 
      
      case(state)
        
        `RST:
          begin

            //reset pc
            reset_pc = 1'b1;
            load_pc = 1'b1;
            
          end
            
        `DECODE:
          begin

            //undo last state outputs
            load_pc = 1'b0;        
            
          end

//ALU---
        `getA: 
          begin

          //setting this states gates
            nsel = 3'b100;
            loada = 1'b1;

          end
            
        `getB: 
          begin

            //undo last states
            loada = 1'b0;

            //setting this states gates
            nsel = 3'b001;
            loadb = 1'b1;

          end
            
        `ADD: 
          begin

            //undo last states
            loadb = 1'b0;

            //setting this states gates
            asel = 1'b0;
            bsel = 1'b0;
            loadc = 1'b1;
            loads = 1'b1;

          end
          
        `CMP: 
          begin

            //undo last states
            loadb = 1'b0;

            //setting this states gates
            asel = 1'b0;
            bsel = 1'b0;
            loadc = 1'b1;
            loads = 1'b1;

          end
              
        `AND: 
          begin

            //undo last states
            loadb = 1'b0;

	        //setting this states gates
            asel = 1'b0;
            bsel = 1'b0;
            loadc = 1'b1;
            loads = 1'b1;

          end
            
        `MVN: 
          begin
            //undo last states
            loadb = 1'b0;
            //setting this states gates
            asel = 1'b0;
            bsel = 1'b0;
            loadc = 1'b1;
            loads = 1'b1;
          end
            
        `WriteReg: //write reg
          begin
            //undo last states
            loadc = 1'b0;
            //setting this states gates
            nsel = 3'b010;
            vsel = 4'b0001;
            write = 1'b1;
          end

//MOV---
        `MOVimm: //MOVimm
          begin
            //setting this states gates
            nsel = 3'b100;
            vsel = 4'b0100;
            write = 1'b1;
          end

        `MOV.1: //MOV.1 -into b
          begin
            //undo last states
            write = 1'b0;
            //setting this states gates
            nsel = 3'b001;
	    loadb = 1'b1;
          end
	    
	`MOV.2: //MOV.2 -into c/datapathout
          begin
            //undo last states
            loadb = 1'b0;
            //setting this states gates
            asel = 1'b1;
            bsel = 1'b0;
            loadc = 1'b1;
          end

	`MOV.3: //MOV.3 -into reg
          begin
	    //undo last states
            loadc = 1'b0;
            //setting this states gates
            nsel = 3'b010;
            vsel = 4'b0001;
            write = 1'b1;
          end

//PC MODIFICATION STATES

    `IF1: //IF1
          begin
            //undo previous states
            reset_pc = 1'b0;
            load_pc = 1'b0;
            //set new inputs
            addr_sel = 1'b1;
            mem_cmd = `MREAD;

          end

    `IF2: //IF2
          begin
            
            addr_sel = 1'b1;
            load_ir = 1'b1;
            mem_cmd = `MREAD;

          end

     `UpdatePC: //UpdatePC
          begin
            //undo previous state inputs
            mem_cmd = `MNONE;
            load_ir = 1'b0;
            addr_sel = 1'b0;
            //new inputs
            load_pc = 1'b1;

          end

//NEW INSTRUCTIONS

     `LDR: 
          begin
            
          nsel = 3'b100; //load Rn
          loada = 1'b1; // loada high so on next clock it will load up to the multiplexer
          loadb = 1'b0; // dont load into b

          end

    `STR: 
          begin
            
          nsel = 3'b100;
          loada = 1'b1;
          loadb = 1'b0;

          end
    
    `ADDL_sx5: //output the sum of Rn and sx5 LOADS ADDRESS
          begin

            loada = 1'b0; // Since a is already loaded, turn this low
            asel = 1'b0; // Load Rn value
            bsel = 1'b1; // Load imm5
            loadc = 1'b1; // Load the sum of a and b on the next clock cycle

          end

    `ADDS_sx5: // LOADS ADDRESS
          begin

            loadb = 1'b0;
            loada = 1'b0;
            asel = 1'b0;
            bsel = 1'b1;
            loadc = 1'b1; 

          end
    

    `read_mem: 
          begin

            mem_cmd = `MNONE; //Do nothing for now 
            load_addr = 1'b1; // Load the memory address into the register on the next clock cycle
            addr_sel = 1'b0; //Select the new address on the next clock cycle
            vsel = 4'b1000; //prep m data to hold M[Rn + imm5]
            loadc = 1'b0; //dont load val at C
            nsel = 3'b010; //select Rd for loading
            vsel = 4'b1000; // Select mdata to write into Rd
            
          end

    `load_mem :
            begin

            mem_cmd = `MREAD; //Read specified address 
            load_addr = 1'b0; //

            end

    `store_mem: // stores memory address for later writing
            begin

            mem_cmd = `MNONE;
            load_addr = 1'b1;
            addr_sel = 1'b0;
            vsel = 3'b010;
            loada = 1'b0;
            loadb = 1'b1;
            bsel = 1'b0;
            asel = 1'b1;

            end

    `load_rd: //STR Rd in mem
        begin

        mem_cmd = `MWRITE;
        loadc = 1'b1;
        load_addr = 1'b0;

        end
         

    `write_memdata:
        begin

        write = 1'b1;

        end
        





        //setting all gates to x if not in 'real' state
	default: {mem_cmd, loadA, loadb, asel, bsel, loadc, loads, load_ir, write, addr_sel, load_pc, load_ir, reset_pc, nsel, vsel} = 21'bxxxxxxxxxxxxxxxxxxxxx;
        
      endcase
    end
  
endmodule
