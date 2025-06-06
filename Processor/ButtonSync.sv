//TCES 330 Spring 2025 
//The ButtonSync module

module ButtonSync(
		input Bi, Clk, ResetN,
		output Bo
);

	localparam 	A  = 2'd0, 
					B  = 2'd1, 
					C  = 2'd2;
					
	logic [1:0] State, NextState;
					
	always_comb begin
    
    case (State)
      A: begin
			Bo = 0;
			if (Bi) begin
				NextState = B;
			end
			else NextState = A;
        
      end  
      
      B: begin
			Bo = 1;
			if (Bi) begin
				NextState = C:
			end 
			else NextState = A;
        
      end  
      
      C: begin
        Bo = 0;
		  if (Bi) begin
				NextState = C;
		  end
		  else NextState = A;
      end
      
      default: begin
			NextState = A;
      end
    endcase 
  end 
  

  always_ff @(posedge Clk) begin
		if (!ResetN)
			State <= A;
		else
			State <= NextState;
  end 

  

endmodule 