module main (input  logic Clk, Reset /* LoadA, LoadB, Execute, */);
  logic Mem_Fetch_En, Mem_Write_En;

  control c0(.*);
  mem m0 (.Mem_Fetch_En, .Mem_Write_En);
  logic [15:0] PC_In, PC_Out;
  reg PC (.Data_In(PC_In), .Data_Out(PC_Out), .*);
  logic [15:0] IR_In, IR_Out;
  reg IR (.Data_In(IR_In), .Data_Out(IR_Out), .*);
  logic [15:0] MAR_In, MAR_Out;
  reg MAR (.Data_In(MAR_In), .Data_Out(MAR_Out), .*);
  logic [15:0] MDR_In, MDR_Out;
  reg MDR (.Data_In(MDR_In), .Data_Out(MDR_Out), .*);
  logic [15:0] ST_In, ST_Out;
  reg ST (.Data_In(ST_In), .Data_Out(ST_Out), .*);
endmodule // main