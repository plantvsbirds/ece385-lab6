module test_bench(inout wire [15:0] Data);

timeunit 10ns;
timeprecision 1ns;


       logic [11:0] LED;
       logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
       logic CE, UB, LB, OE, WE;
       logic [19:0] ADDR;
							 
       logic Clk, Reset, Run, Continue;
       logic[15:0]     S, IR_Debug, PC_Debug, MAR_Debug, MDR_Debug;
	 
		always begin : CLOCK_GENERATION
		#1 Clk = ~Clk;
		end
	
		initial begin : CLOCK_INITIALIZATION
		Clk = 0;
		end
	
		lab6_toplevel tp(.*);
	
		initial begin: TEST_VECTORS
		
		Reset = 0;
		Run = 1;
		
		//test case 1
		#2 Reset = 1;
		#2 Run = 0;
		#2 Run = 1;
		
		#20 Continue = 1;
		
		#2 Continue = 0;
		
		end
		
endmodule
		