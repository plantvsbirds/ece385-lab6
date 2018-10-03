module mem (
  input logic Mem_Fetch_En, Mem_Write_En,
  // inout logic Data_Bus,
  input logic [15:0] MAR,
  output logic CE, UB, LB, OE, WE,
  output logic [19:0] ADDR
);
  always_comb
    begin
    ADDR = { 20'b0 };
    CE = 1;
    UB = 1;
    LB = 1;
    OE = 1;
    WE = 1;
    // high-impedance value ZZZZZZ
      if (Mem_Fetch_En || Mem_Write_En) begin
        CE = 0;
        UB = 0;
        LB = 0;
        ADDR = { 4'b0, MAR };
        // extend to 20 bits
      end
      if (Mem_Write_En) begin
        WE = 0;
      end
      if (Mem_Fetch_En) begin
        OE = 0;
      end
      if (!Mem_Write_En && !Mem_Fetch_En) begin
        CE = 1;
      end
    end
endmodule // mem