module selector (
  input logic Clk,
  input logic [2:0]  Select,
  input logic Select_Imm,
  input logic [15:0] Data_In_0,
  input logic [15:0] Data_In_1,
  input logic [15:0] Data_In_2,
  input logic [15:0] Data_In_3,
  input logic [15:0] Data_In_4,
  input logic [15:0] Data_In_5,
  input logic [15:0] Data_In_6,
  input logic [15:0] Data_In_7,
  input logic [15:0] Data_In_Imm,
  output logic [15:0] Data_Out
);

	always_comb
	begin
		if (Select_Imm)
			Data_Out = Data_In_Imm;
		else begin
			unique case(Select)
				4'b000:
					Data_Out = Data_In_0;
				4'b001:
					Data_Out = Data_In_1;
				4'b010:
					Data_Out = Data_In_2;
				4'b011:
					Data_Out = Data_In_3;
				4'b100:
					Data_Out = Data_In_4;
				4'b101:
					Data_Out = Data_In_5;
				4'b110:
					Data_Out = Data_In_6;
				4'b111:
					Data_Out = Data_In_7;
			endcase
		end
	end
endmodule
