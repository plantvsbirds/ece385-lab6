module reg_16 (
  input  logic Clk, Reset, Load_En,
  input  logic [15:0]  Data_In,
  output logic [15:0]  Data_Out
);

  always_ff @ (posedge Clk)
  begin
 	 if (Reset)
		  Data_Out <= 16'h0;
	 else if (Load_En)
		  Data_Out <= Data_In;
	end
endmodule
