module mem (
  input logic Mem_Fetch_En, Mem_Write_En,
  inout logic Data_Bus,
);
  always_comb
    begin
      if (Mem_Fetch_En) begin

      end
      if (Mem_Write_En) begin

      end
    end
endmodule // mem