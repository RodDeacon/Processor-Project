/* 
Mahri Yalkapova
TCES 330 - Spring 2025
4/8/2025
Lab1 - Part3
Describing 8-to-1 mux
*/

module Mux_8_to_1(A, B, C, D, E, F, G, H, S, M);

	input A, B, C, D, E, F, G, H;	//mux inputs
	input [2:0] S;						//3-bit select line
	output logic M;							//mux output
	
	always_comb begin
		case (S)
			3'b000 : M = A;
			3'b001 : M = B;
			3'b010 : M = C;
			3'b011 : M = D;
			3'b100 : M = E;
			3'b101 : M = F;
			3'b110 : M = G;
			3'b111 : M = H;
			
		endcase
	end
	
	
endmodule

//testbench for 8-1 mux
module Mux_8_to_1_tb;

	logic A, B, C, D, E, F, G, H;
	logic [2:0] SE;
	logic MO;
	
	Mux_8_to_1 DUT (.A(A), .B(B), .C(C), .D(D), .E(E), .F(F), .G(G), .H(H), .S(SE), .M(MO));
	
	initial begin
		//edge cases
		A=0; B=0; C=0; D=0; E=0; F=0; G=0; H=0; 	//all inputs are zeros
		SE = 0; #50;				//set SE=0 and run for 50ps
		SE = 1; #50;				//set SE=1 and run for 50ps
		SE = 2; #50;				//set SE=2 and run for 50ps

		A=1; B=1; C=1; D=1; E=1; F=1; G=1; H=1; 	//all inputs are zeros
		SE = 0; #50;				//set SE=0 and run for 50ps
		SE = 1; #50;				//set SE=1 and run for 50ps
		SE = 2; #50;				//set SE=2 and run for 50ps
					
		//randomize test cases
		for (int i=0; i<50; i++) begin
			{A, B, C, D, E, F, G, H} = $random;
			SE = i%3; #50;
		end
		$stop;
	end

	initial begin
		$monitor(A,,, B,,, C,,, D,,, E,,, F,,, G,,, H,,, SE,,, MO);
		
		$monitor("%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b", A, B, C, D, E, F, G, H, SE, MO);
	end
	
	

endmodule