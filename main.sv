module main (
  input logic Clk, Reset, Execute, Continue, 
  input logic [15:0] S,
  output logic [11:0] LED,
  output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
  output logic CE, UB, LB, OE, WE,
  output logic [19:0] ADDR
  // inout logic Data_Bus
);

  initial begin: INIT_STATE
    CE = 1;
    UB = 1;
    LB = 1;
    OE = 1;
    WE = 1;
  end

  logic Mem_Fetch_En, Mem_Write_En;

  logic [15:0] PC_In, PC_Out, PC_Load_En;
  reg_16 PC (.Data_In(PC_In), .Data_Out(PC_Out), .Load_En(PC_Load_En), .*);

  logic [15:0] IR_In, IR_Out, IR_Load_En;
  reg_16 IR (.Data_In(IR_In), .Data_Out(IR_Out), .Load_En(IR_Load_En), .*);

  logic [15:0] MAR_In, MAR_Out, MAR_Load_En;
  reg_16 MAR (.Data_In(MAR_In), .Data_Out(MAR_Out), .Load_En(MAR_Load_En), .*);

  logic [15:0] MDR_In, MDR_Out, MDR_Load_En;
  reg_16 MDR (.Data_In(MDR_In), .Data_Out(MDR_Out), .Load_En(MDR_Load_En), .*);

  logic [15:0] ST_In, ST_Out, ST_Load_En;
  reg_16 ST (.Data_In(ST_In), .Data_Out(ST_Out), .Load_En(ST_Load_En), .*);

  control c0(.*);
  mem m0 (
    .Mem_Fetch_En, .Mem_Write_En,
    .MAR(MAR_Out),
    // .Data_Bus(Data_Bus), /* ? */
    .CE, .UB, .LB, .OE, .WE,
    .ADDR,
  );

endmodule // main