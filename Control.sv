//Two-always example for state machine

module control (input  logic Clk, Reset, LoadA, LoadB, Execute,
                output logic Shift_En, Ld_A, Ld_B, debug);

    // Declare signals curr_state, next_state of type enum
    // with enum values of A, B, ..., F as the state values
	 // Note that the length implies a max of 8 states, so you will need to bump this up for 8-bits
    enum logic [9:0] {A, B, C, D, E, F, G, H, I, J}   curr_state, next_state; 

	 initial begin: INIT_STATE
			curr_state = A;
	 end
	 
	//updates flip flop, current state is the only one
    always_ff @ (posedge Clk)  
    begin
        if (Reset)
            curr_state <= A;
        else 
            curr_state <= next_state;
    end

    // Assign outputs based on state
	always_comb
    begin
		  next_state = A;
		  debug = 1'b0;
        unique case (curr_state)
				A : begin
					debug = 1'b0;
					if (Execute) begin next_state = B; debug = 1'b1; end
				end
            B : begin
					next_state = C;
					debug = 1'b1;
				end
            C : begin
				next_state = D;
				debug = 1'b1;
				end
            D : begin
				next_state = E;
				debug = 1'b1;
				end
            E : begin
				next_state = F;
				debug = 1'b1;
				end
            F : begin
				next_state = G;
				debug = 1'b1;
				end
            G : begin
				next_state = H;
				debug = 1'b1;
				end
            H : begin
				next_state = I;
				debug = 1'b1;
				end
            I : begin
				next_state = J;
				debug = 1'b1;
				end
            J : begin
				debug = 1'b0;
				if (~Execute) next_state = A;
				end
        endcase
   
		  // Assign outputs based on ‘state’
        case (curr_state) 
	   	   A: 
	         begin
                Ld_A = LoadA;
                Ld_B = LoadB;
                Shift_En = 1'b0;
		      end
	   	   J: 
		      begin
                Ld_A = 1'b0;
                Ld_B = 1'b0;
                Shift_En = 1'b0;
							// do not shift because exec is stopped
		      end
	   	   default: //default case, can also have default assignments for Ld_A and Ld_B before case
		      begin 
                Ld_A = 1'b0;
                Ld_B = 1'b0;
                Shift_En = 1'b1;
							// constantly shifting, not loading
		      end
        endcase
    end

endmodule
