//------------------------------------------------------------------------------
// Company:        UIUC ECE Dept.
// Engineer:       Stephen Kempf
//
// Create Date:    
// Design Name:    ECE 385 Lab 6 Given Code - SLC-3 
// Module Name:    SLC3
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 09-22-2015 
//    Revised 10-19-2017 
//    spring 2018 Distribution
//
//------------------------------------------------------------------------------
module slc3(
    input logic [15:0] S,
    input logic Clk, Reset, Run, Continue,
    output logic [11:0] LED,
    output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
    output logic CE, UB, LB, OE, WE,
    output logic [19:0] ADDR,
    inout wire [15:0] Data, //tristate buffers need to be of type wire
	 
	 
    output wire [15:0] IR_Debug, PC_Debug, MAR_Debug, MDR_Debug
);

// Declaration of push button active high signals
logic Reset_ah, Continue_ah, Run_ah;

assign Reset_ah = ~Reset;
assign Continue_ah = ~Continue;
assign Run_ah = ~Run;

// Internal connections
logic BEN;
logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED;
logic GatePC, GateMDR, GateALU, GateMARMUX;
logic [1:0] PCMUX, ADDR2MUX, ALUK;
logic DRMUX, SR1MUX, SR2MUX, ADDR1MUX;
logic MIO_EN;

// logic [15:0] MDR_In;
// logic [15:0] MAR, MDR, IR, PC;
logic [15:0] Data_from_SRAM, Data_to_SRAM;

// Signals being displayed on hex display
logic [3:0][3:0] hex_4;

// Connect MAR to ADDR, which is also connected as an input into MEM2IO.
// MEM2IO will determine what gets put onto Data_CPU (which serves as a potential
// input into MDR)
assign MIO_EN = ~OE;

// logic LD_BEN, LD_CC, LD_REG, LD_LED;
logic [15:0] PC_Plus_One, PC_Out;

logic  INC_PC_En;
reg_16 PC (.Data_In(PC_Plus_One), .Data_Out(PC_Out), .Load_En(LD_PC), .Reset(Reset_ah), .*);
add_1 adder_PC(.In(PC_Out), .Out(PC_Plus_One));


logic [15:0] IR_Out;
logic [15:0] MAR_In, MAR_Out;
logic [15:0] MDR_In, MDR_Out;
logic [15:0] ST_In, ST_Out;


reg_16 IR (.Data_In(MDR_Out), .Data_Out(IR_Out), .Load_En(LD_IR), .Reset(Reset_ah), .*);
reg_16 MAR (.Data_In(PC_Out), .Data_Out(MAR_Out), .Load_En(LD_MAR), .Reset(Reset_ah), .*);
assign ADDR = { 4'b00, MAR_Out }; //Note, our external SRAM chip is 1Mx16, but address space is only 64Kx16
reg_16 MDR (.Data_In(MDR_In), .Data_Out(MDR_Out), .Load_En(LD_MDR), .Reset(Reset_ah), .*);
reg_16 ST (.Data_In(ST_In), .Data_Out(ST_Out), .Load_En(ST_Load_En), .Reset(Reset_ah), .*);

wire [7:0]reg_in[15:0];
wire [7:0]reg_out[15:0];
wire reg_ld[7:0];

generate
  genvar i;
  for (i=0; i<8; i=i+1) begin : make_reg
    reg_16 reg_i(
        .Clk(Clk)
		, .Reset(Reset_ah)
		, .Load_En(reg_ld[i])
		, .Data_In(reg_in[i])
		, .Data_Out(reg_out[i]),
      );
  end
endgenerate

logic [1:0] Value_RHS [15:0];
assign imm = { 11'b0, IR_Out[4:0] };

selector s0(.Clk,
  .Select(IR_Out[8:6]),
  .Select_Imm(0), // RHS 0 never get imm.
  .Data_In_0(reg_out[0]),
  .Data_In_1(reg_out[1]),
  .Data_In_2(reg_out[2]),
  .Data_In_3(reg_out[3]),
  .Data_In_4(reg_out[4]),
  .Data_In_5(reg_out[5]),
  .Data_In_6(reg_out[6]),
  .Data_In_7(reg_out[7]),
  .Data_In_Imm(5'b00000),
  .Data_Out(Value_RHS[0])
);

selector s1(.Clk,
  .Select(IR_Out[2:0]),
  .Select_Imm(IR_Out[5]),
  .Data_In_0(reg_out[0]),
  .Data_In_1(reg_out[1]),
  .Data_In_2(reg_out[2]),
  .Data_In_3(reg_out[3]),
  .Data_In_4(reg_out[4]),
  .Data_In_5(reg_out[5]),
  .Data_In_6(reg_out[6]),
  .Data_In_7(reg_out[7]),
  .Data_In_Imm(imm),
  .Data_Out(Value_RHS[1])
);

logic [15:0]Calc_Result;

calc r0(
	.RHS0(Value_RHS[0]),
	.RHS1(Value_RHS[1]),
	.Opcode(IR_Out[15:12]),
	.Result(Calc_Result)
);

// You need to make your own datapath module and connect everything to the datapath
// Be careful about whether Reset is active high or low
// datapath d0 (/* Please fill in the signals.... */);


// Our SRAM and I/O controller
Mem2IO memory_subsystem(
    .*, .Reset(Reset_ah), .ADDR(ADDR), .Switches(S),
    .HEX0(hex_4[0][3:0]), .HEX1(hex_4[1][3:0]), .HEX2(hex_4[2][3:0]), .HEX3(hex_4[3][3:0]),
    .Data_from_CPU(MDR_Out), .Data_to_CPU(MDR_In),
    .Data_from_SRAM(Data_from_SRAM), .Data_to_SRAM(Data_to_SRAM)
);

// The tri-state buffer serves as the interface between Mem2IO and SRAM
tristate #(.N(16)) tr0(
    .Clk(Clk), .tristate_output_enable(~WE), .Data_write(Data_to_SRAM), .Data_read(Data_from_SRAM), .Data(Data)
);

// State machine and control signals
ISDU state_controller(
    .*, .Reset(Reset_ah), .Run(Run_ah), .Continue(Continue_ah),
    .Opcode(IR_Out[15:12]), .IR_5(IR_Out[5]), .IR_11(IR_Out[11]),
    .Mem_CE(CE), .Mem_UB(UB), .Mem_LB(LB), .Mem_OE(OE), .Mem_WE(WE),
	 .INC_PC_En
);


// For week 1, hexdrivers will display IR. Comment out these in week 2.
// HexDriver hex_driver3 (IR_Out[15:12], HEX3);
// HexDriver hex_driver2 (IR_Out[11:8], HEX2);
// HexDriver hex_driver1 (IR_Out[7:4], HEX1);
// HexDriver hex_driver0 (IR_Out[3:0], HEX0);

// For week 2, hexdrivers will be mounted to Mem2IO
HexDriver hex_driver3 (hex_4[3][3:0], HEX3);
HexDriver hex_driver2 (hex_4[2][3:0], HEX2);
HexDriver hex_driver1 (hex_4[1][3:0], HEX1);
HexDriver hex_driver0 (hex_4[0][3:0], HEX0);

// The other hex display will show PC for both weeks.
HexDriver hex_driver7 (PC_Out[15:12], HEX7);
HexDriver hex_driver6 (PC_Out[11:8], HEX6);
HexDriver hex_driver5 (PC_Out[7:4], HEX5);
HexDriver hex_driver4 (PC_Out[3:0], HEX4);


assign IR_Debug = IR_Out;
assign PC_Debug = PC_Out;
assign MAR_Debug = MAR_Out;
assign MDR_Debug = MDR_Out;

	initial begin
	  // PC_In = 74;
	end

endmodule
