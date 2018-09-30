module main (
  input logic Clk, Reset, Run, Continue,
  input logic [15:0] S,
  output logic [11:0] LED,
  output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
  output logic CE, UB, LB, OE, WE,
  output logic [19:0] ADDR,
  inout logic Data_Bus, 
);

  initial begin: INIT_STATE
    assign CE = 1;
    assign UB = 1;
    assign LB = 1;
    assign OE = 1;
    assign WE = 1;
  end

  logic Mem_Fetch_En, Mem_Write_En;

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

  control c0(.*);
  mem m0 (
    .Mem_Fetch_En, .Mem_Write_En,
    .MAR(MAR_Out),
    .Data_Bus(Data_Bus), /* ? */
    .CE, .UB, .LB, .OE, .WE,
    .ADDR,
  );

endmodule // main