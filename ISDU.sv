//------------------------------------------------------------------------------
// Company:          UIUC ECE Dept.
// Engineer:         Stephen Kempf
//
// Create Date:    17:44:03 10/08/06
// Design Name:    ECE 385 Lab 6 Given Code - Incomplete ISDU
// Module Name:    ISDU - Behavioral
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 02-13-2017
//    Spring 2017 Distribution
//------------------------------------------------------------------------------


module ISDU (   input logic         Clk, 
									Reset,
									Run,
									Continue,
									
				input logic[3:0]    Opcode, 
				input logic         IR_5,
				input logic         IR_11,
				input logic         BEN,
				  
				output logic        LD_MAR,
									LD_MDR,
									LD_IR,
									LD_BEN,
									LD_CC,
									LD_REG,
									LD_PC,
									LD_LED, // for PAUSE instruction
				output logic INC_PC_En,
				
									
				output logic        GatePC,
									GateMDR,
									GateALU,
									GateMARMUX,
									
				output logic [1:0]  PCMUX,
				output logic        DRMUX,
									SR1MUX,
									SR2MUX,
									ADDR1MUX,
				output logic [1:0]  ADDR2MUX,
									ALUK,
				  
				output logic        Mem_CE,
									Mem_UB,
									Mem_LB,
									Mem_OE,
									Mem_WE
				);

	enum logic [10:0] {
		Halted,
		FETCH_MAR,
		FETCH_MDR,
		FETCH_MDR1,
		FETCH_MDR2,
		FETCH_MDR3,
		FETCH_IR,
		FETCH_INC_PC,
		PauseIR1, 
		PauseIR2,
		Rest,
		Rest_2
/*
		S_18, 
		S_33_1, 
		S_33_2, 
		S_35, 
		S_32, 
		S_01
*/
		}   State, Next_state;   // Internal state logic
		
	always_ff @ (posedge Clk)
	begin
		if (Reset) 
			State <= Halted;
		else 
			State <= Next_state;
	end
   
	always_comb
	begin 
		// Default next state is staying at current state
		Next_state = State;
		
		// Default controls signal values
		LD_MAR = 1'b0;
		LD_MDR = 1'b0;
		LD_IR = 1'b0;
		LD_BEN = 1'b0;
		LD_CC = 1'b0;
		LD_REG = 1'b0;
		LD_PC = 1'b0;
		LD_LED = 1'b0;
		 
		GatePC = 1'b0;
		GateMDR = 1'b0;
		GateALU = 1'b0;
		GateMARMUX = 1'b0;
		 
		ALUK = 2'b00;
		 
		PCMUX = 2'b00;
		DRMUX = 1'b0;
		SR1MUX = 1'b0;
		SR2MUX = 1'b0;
		ADDR1MUX = 1'b0;
		ADDR2MUX = 2'b00;
		 
		Mem_OE = 1'b1;
		Mem_WE = 1'b1;
	
		// Assign next state
		unique case (State)
			Halted : 
				if (Run) 
					Next_state = FETCH_MAR;                      
			FETCH_MAR : 
				Next_state = FETCH_MDR;
			FETCH_MDR :
				Next_state = FETCH_MDR1;
			FETCH_MDR1 :
				Next_state = FETCH_MDR2;
			FETCH_MDR2 :
				Next_state = FETCH_MDR3;
			FETCH_MDR3 :
				Next_state = FETCH_IR;
				// wait
			FETCH_IR :
				Next_state = FETCH_INC_PC;
			FETCH_INC_PC :
				Next_state = Rest;
			// PauseIR1 and PauseIR2 are only for Week 1 such that TAs can see 
			// the values in IR.
			Rest : 
				if (Continue) 
					Next_state = Rest_2; 
			Rest_2 : 
				if (~Continue) 
					Next_state = FETCH_MAR; 
			/*
			S_32 : 
				case (Opcode)
					4'b0001 : 
						Next_state = S_01;

					// You need to finish the rest of opcodes.....

					default : 
						Next_state = S_18;
				endcase
			S_01 : 
				Next_state = S_18;

			// You need to finish the rest of states.....

			
			*/
			default :
					Next_state = Halted;  

		endcase
		
		// Assign control signals based on current state
		case (State)
			Halted: ;
			FETCH_MAR : 
				begin 
					// GatePC = 1'b1; // ??
					LD_MAR = 1'b1;
					// PCMUX = 2'b00; // ??
					// LD_PC = 1'b1;
				end
				/*
			FETCH_MDR : 
				Mem_OE = 1'b0;
				*/
			FETCH_MDR, FETCH_MDR1, FETCH_MDR2, FETCH_MDR3 : 
				begin 
					LD_MAR = 1'b0;
					Mem_OE = 1'b0;
					LD_MDR = 1'b1;
				end
			FETCH_IR : 
				begin
					LD_IR = 1'b1;
				end
			FETCH_INC_PC : 
				begin
					LD_PC = 1'b1;
				end
				
			PauseIR1: ;
			PauseIR2: ;
				/*
			S_35 : 
				begin 
					GateMDR = 1'b1; // ??
					LD_IR = 1'b1;
				end
			S_32 : 
				LD_BEN = 1'b1; //?
			S_01 : 
				begin 
					SR2MUX = IR_5;
					ALUK = 2'b00;
					GateALU = 1'b1;
					LD_REG = 1'b1;
					// incomplete...
				end

			// You need to finish the rest of states.....
			*/
			
			default : ;
		endcase
	end 

	 // These should always be active
	assign Mem_CE = 1'b0;
	assign Mem_UB = 1'b0;
	assign Mem_LB = 1'b0;
	
endmodule
