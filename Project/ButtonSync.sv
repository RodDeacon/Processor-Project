//TCES 330 Spring 2025 
//The ButtonSync module
module ButtonSync(
    // input Bi, Clk, ResetN,
    input Bi, Clk, 
    output logic Bo
);

    localparam A = 2'd0, 
               B = 2'd1, 
               C = 2'd2;
    
    logic [1:0] State, NextState;
    logic NextBo;

    always_comb begin
        NextBo = 0;  // default
        case (State)
            A: begin
                if (Bi) begin
                    NextState = B;
                    NextBo = 0;
                end else begin
                    NextState = A;
                end
            end

            B: begin
                NextBo = 1;
                if (Bi) begin
                    NextState = C;
                end else begin
                    NextState = A;
                end
            end

            C: begin
                if (Bi) begin
                    NextState = C;
                end else begin
                    NextState = A;
                end
            end

            default: NextState = A;
        endcase
    end

    always_ff @(posedge Clk) begin
        // if (!ResetN) begin
        //     State <= A;
        //     Bo <= 0;
        // end else begin
            State <= NextState;
            Bo <= NextBo;
        // end
    end
endmodule

// module ButtonSync(
// 		input Bi, Clk, ResetN,
// 		output logic Bo
// );

// 	localparam 	A  = 2'd0, 
// 					B  = 2'd1, 
// 					C  = 2'd2;
					
// 	logic [1:0] State, NextState;
					
// 	always_comb begin
    
//     case (State)
//       A: begin
// 			Bo = 0;
// 			if (Bi) begin
// 				NextState = B;
// 			end
// 			else NextState = A;
        
//       end  
      
//       B: begin
// 			Bo = 1;
// 			if (Bi) begin
// 				NextState = C;
// 			end 
// 			else NextState = A;
        
//       end  
      
//       C: begin
//         Bo = 0;
// 		  if (Bi) begin
// 				NextState = C;
// 		  end
// 		  else NextState = A;
//       end
      
//       default: begin
// 			NextState = A;
//       end
//     endcase 
//   end 
  

//   always_ff @(posedge Clk) begin
// 		if (!ResetN)
// 			State <= A;
// 		else
// 			State <= NextState;
//   end 
// endmodule 

module ButtonSync_tb;

// logic

		logic Bi, Clk, ResetN;
		logic Bo;
//initalize
ButtonSync DUT(
		Bi, Clk, ResetN,
		 Bo);
// clock

always begin
	Clk = 1'b0; #10;
	Clk = 1'b1; #10;
end

// logic
initial begin
	// initialize inputs
	ResetN = 1'b0;
	Bi = 1'b0;
	@(negedge Clk); #1;

	@(posedge Clk);
	@(negedge Clk); #1;
	// after the negative edge, input bi goes high
	ResetN = 1'b1;
	Bi = 1'b1;
	// stays 1 for 3 cycles
	repeat(3) @(posedge Clk);
	
	@(negedge Clk); #1;
	Bi = 1'b0;

	repeat(2) @(posedge Clk);

	$stop;
end
// monitor
initial begin
	$display($realtime, " Bi = %b, Bo = %b", Bi, Bo);
end
endmodule