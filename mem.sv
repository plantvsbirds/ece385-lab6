module mem (
  input logic Mem_Fetch_En, Mem_Write_En,
  inout logic Data_Bus,
  inout logic [15:0] MAR,
  output logic CE, UB, LB, OE, WE,
  output logic [19:0] ADDR,
);
  always_comb
    assign ADDR = { 20'b0 };
    // high-impedance value ZZZZZZ
    begin
      if (Mem_Fetch_En || Mem_Write_En) begin
        assign CE = 0;
        assign UB = 0;
        assign LB = 0;
        assign ADDR = { 4'b0, MAR };
        // extend to 20 bits
      end
      if (Mem_Write_En) begin
        assign WE = 0;
      end
      if (Mem_Read_En) begin
        assign OE = 0;
      end
      if (!Mem_Write_En && !Mem_Fetch_En) begin
        assign CE = 1;
      end
    end
endmodule // mem