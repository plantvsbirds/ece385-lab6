module reg_16 (
  input  logic Clk, Reset, Shift_In, Load, Shift_En,
  input  logic [15:0]  D,
  output logic Shift_Out,
  output logic [15:0]  Data_Out
);

  always_ff @ (posedge Clk)
  begin
 	 if (Reset)
		  Data_Out <= 16'h0;
	 else if (Load)
		  Data_Out <= D;
	 else
endmodule
