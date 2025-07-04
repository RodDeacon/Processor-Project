// TCES330 Spring 2025 University of Washington Tacoma Dr. Jie Sheng
// Rodney Deacon & Mahri Yalkapova
// 06-07-2025
// Week 10, Project Folder
// this module will connect all necessary components of the processor together to the DE2 Board

module Project(
   input [17:0] SW,
   input [3:0] KEY,
   input CLOCK_50,
   output [17:0] LEDR,
   output [3:0] LEDG,
   output [0:6] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0 
);
   
   // MEOW
   assign LEDR = SW;
   assign LEDG[0] = ~KEY[0];
   assign LEDG[1] = ~KEY[1];
   assign LEDG[2] = ~KEY[2];
   assign LEDG[3] = ~KEY[3];

   logic ResetN, Bo, Out;
   logic [15:0] IR_Out, ALU_A, ALU_B, ALU_Out, M;
   logic [6:0] PC_Out;
   logic [3:0] State, NextState;
   logic [0:6] HEX_internal [7:0]; // internal hex array

   // button instantiation
   ButtonSync unit_BS(KEY[2], CLOCK_50, ResetN, Bo);

   // key filter
   KeyFilter unit_KF(CLOCK_50, Bo, Out);

   // processor
   Processor unit_P(Out, KEY[0], IR_Out, PC_Out, State, NextState, ALU_A, ALU_B, ALU_Out);

   // mux8_to_1
   Mux_8_to_1 unit_Mux({{1'b0, PC_Out}, {4'b0, State}}, ALU_A, ALU_B, ALU_Out, {12'b0,NextState}, 16'b0, 16'b0, 16'b0, SW[17:15], M);

   // generate block for the decoders
   genvar i;
   generate       // for loop which goes 8 times
      for ( i = 0; i < 8; i++) begin : decoders
         if (i < 4) begin// for the first four (0 to 3), will work with the IR_OUT
            Decoder decoder_inst(
                  .V(IR_Out[((i*4)+3):(i*4)]), // index is from  
                  .Hex(HEX_internal[i])
            );
         
         end
         else begin// the next four (4 to 7), will work with the output of the 8_to_1_mux
            Decoder decoder_inst(
                .V(M[((i*4)+3):(i*4)]), 
                  .Hex(HEX_internal[i])
            );
         end
      end
   endgenerate

   // output assignments
   assign HEX0 = HEX_internal[0];
   assign HEX1 = HEX_internal[1];
   assign HEX2 = HEX_internal[2];
   assign HEX3 = HEX_internal[3];
   assign HEX4 = HEX_internal[4];
   assign HEX5 = HEX_internal[5];
   assign HEX6 = HEX_internal[6];
   assign HEX7 = HEX_internal[7];

endmodule

module Project_tb;

   // initialize logic wires
 logic [17:0] SW;
  logic  [3:0] KEY;
  logic  CLOCK_50;
  logic  [17:0] LEDR;
    logic [3:0] LEDG;
   logic [0:6] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0; 

   // initialize the DUT
   Project DUT(   SW,
    KEY,
    CLOCK_50,
     LEDR,
     LEDG,
    HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0 
);

   // clock
   always begin
      
   end
   // tb logic
   initial begin
      $stop;
   end
   // monitor

   initial begin
      $monitor($realtime, " NextState = %b, A = %b", DUT.NextState, DUT.unit_Mux.A);
   end

/*
   logic ResetN, Bo, Out;
   logic [15:0] IR_Out, ALU_A, ALU_B, ALU_Out, M;
   logic [6:0] PC_Out;
   logic [3:0] State, NextState;
   logic [0:6] HEX_internal [7:0]; // internal hex array
*/

endmodule