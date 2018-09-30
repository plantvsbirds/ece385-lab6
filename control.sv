module control (input  logic Clk, Reset, /* LoadA, LoadB, Execute, */
                output logic Mem_Fetch_En, Mem_Write_En);

  enum logic [4:0] {REST, FETCH, DEC, EXEC, DONE} curr_state, next_state; 

  initial begin: INIT_STATE
  	curr_state = REST;
  end

   always_ff @ (posedge Clk)  
    begin
        if (Reset)
            curr_state <= REST;
        else 
            curr_state <= next_state;
    end

	always_comb
    begin
		  next_state = REST;
        unique case (curr_state)
        REST : begin
          if (Execute) begin
            next_state = FETCH;
          end
          end
        FETCH : begin
          // next_state = DEC;
          next_state = DONE;
          end
        DONE : begin
          if (~Execute) begin
            next_state = REST;
          end
          end
        endcase
   
        Mem_Write_En = 0;
        Mem_Fetch_En = 0;
        case (curr_state) 
        FETCH : begin
          Mem_Fetch_En = 1;
		      end
        endcase
    end
endmodule
