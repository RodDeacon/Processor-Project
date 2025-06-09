// TCES330 Spring 2025 University of Washington Tacoma Dr. Jie Sheng
// Rodney Deacon & Mahri Yalkapova
// 06-07-2025
// Week 10, Project Folder
// this module will connect all necessary components of the processor together to the DE2 Board

module Project(
   input [17:0] SW,
   input [3:0] KEY,
   input CLOCK_50,
   output logic [17:0] LEDR,
   output logic [3:0] LEDG,
   output logic [0:6] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0 
);
// logic
   logic ResetN, Bo;
   logic [15:0] IR_Out, ALU_A, ALU_B, ALU_Out, M;
   logic [6:0] PC_Out;
   logic [3:0] State, NextState;
   logic [0:6] HEX_internal [7:0]; // internal hex array

   (*keep*) logic Out; // Keep prevents logic out from being optimized

// input assignments
   assign LEDR = SW;
   assign LEDG[0] = ~KEY[0];
   assign LEDG[1] = ~KEY[1];
   assign LEDG[2] = ~KEY[2];
   assign LEDG[3] = ~KEY[3];

// output assignments
   assign HEX0 = HEX_internal[0];
   assign HEX1 = HEX_internal[1];
   assign HEX2 = HEX_internal[2];
   assign HEX3 = HEX_internal[3];
   assign HEX4 = HEX_internal[4];
   assign HEX5 = HEX_internal[5];
   assign HEX6 = HEX_internal[6];
   assign HEX7 = HEX_internal[7];

// instantation of submodules

   // button instantiation
   ButtonSync unit_BS(KEY[2], CLOCK_50, Bo);

   // key filter
   KeyFilter Filter(CLOCK_50, Bo, Out);

   // processor
   Processor unit_P(Out, KEY[1], IR_Out, PC_Out, State, NextState, ALU_A, ALU_B, ALU_Out);

   // mux8_to_1
   Mux_8_to_1 unit_Mux(
               {  // concatinate the following two concatinations in order to obtain a 16-bit input (A) to the mux
                  {1'b0, PC_Out},   // concatinate PC_out with 1 bit padding to convert from 7-bit to 8-bit,  
                  {4'b0, State}     // concatinate State (Current State) with 4 bits to pad to 8 bits
               },    
               ALU_A, ALU_B, ALU_Out,  // inputs B, C, D
               {12'b0,NextState},      // concatinate NextState with 12 bits to create a 16-bit input (E)
               16'b0, 16'b0, 16'b0,    // no inputs for F G and H
               SW[17:15],              // Select signal is controlled by the switches 17-15 (Little endian binary) 
               M);                     // output 16 bit M which is used to drive the instantiation of the Decoders for the 7-segment displays 

// generate block for the decoders
   genvar i;
   generate       
   // for loop which goes 8 times one for each 7-segment display
      for ( i = 0; i < 8; i++) begin : decoders
         if (i < 4) begin                                // for the first four (0 to 3), will work with the IR_OUT
            Decoder decoder_inst(
               .V(IR_Out[((i*4)+3):(i*4)]),                    // index is from i * 4 to i * 4 + 3
               .Hex(HEX_internal[i])
            );
         end
         else begin                                      // the next four (4 to 7), will work with the output of the 8_to_1_mux
            Decoder decoder_inst(
               .V(M[(((i - 4)*4)+3):((i - 4)*4)]),             // index is from (i - 4) * 4 to (i - 4) * 4 + 3
               .Hex(HEX_internal[i])
            );
         end
      end
   endgenerate
endmodule