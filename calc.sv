module calc(
	input [15:0] RHS0,
	input [15:0] RHS1,
	input [3:0] Opcode,
	output [15:0] Result
);

	always_comb begin
		unique case(Opcode)
			4'b0001:
				Result = RHS0 + RHS1;
			4'b0101:
				Result = RHS0 & RHS1;
			4'b1001:
				Result = ~RHS0;
			default:
				Result = 16'b0;
		endcase
	end


endmodule
