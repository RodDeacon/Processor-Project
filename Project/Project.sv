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
   
   // MEOW
   assign LEDR = SW;
   assign LEDG[0] = ~KEY[0];
   assign LEDG[1] = ~KEY[1];
   assign LEDG[2] = ~KEY[2];
   assign LEDG[3] = ~KEY[3];

   logic ResetN, Bo;
   logic [15:0] IR_Out, ALU_A, ALU_B, ALU_Out, M;
   logic [6:0] PC_Out;
   logic [3:0] State, NextState;
   logic [0:6] HEX_internal [7:0]; // internal hex array

   (*keep*) logic Out; // Keep prevents logic out from being optimized

   // button instantiation
   ButtonSync unit_BS(KEY[2], CLOCK_50, Bo);
   // ButtonSync unit_BS(KEY[2], CLOCK_50, ResetN, Bo);
   // ButtonSync unit_BS(KEY[2], CLOCK_50, Bo);

   // key filter
   KeyFilter Filter(CLOCK_50, Bo, Out);

   // processor
   Processor unit_P(Out, KEY[1], IR_Out, PC_Out, State, NextState, ALU_A, ALU_B, ALU_Out);

   // mux8_to_1
   Mux_8_to_1 unit_Mux({{1'b0, PC_Out}, {4'b0, State}}, ALU_A, ALU_B, ALU_Out, {12'b0,NextState}, 16'b0, 16'b0, 16'b0, SW[17:15], M);

   // generate block for the decoders
   genvar i;
   generate       // for loop which goes 8 times
      for ( i = 0; i < 8; i++) begin : decoders
         if (i < 4) begin// for the first four (0 to 3), will work with the IR_OUT
            Decoder decoder_inst(
                  .V(IR_Out[((i*4)+3):(i*4)]), // index is from i * 4 to i * 4 + 3
                  .Hex(HEX_internal[i])
            );
         
         end
         else begin// the next four (4 to 7), will work with the output of the 8_to_1_mux
            // j = (i - 4);
            Decoder decoder_inst(
                .V(M[(((i - 4)*4)+3):((i - 4)*4)]), // index is from (i - 4) * 4 to (i - 4) * 4 + 3
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
`timescale 1ns/1ps

module Project_tb;

  // Inputs
  logic [17:0] SW;
  logic [3:0] KEY;
  logic CLOCK_50;

  // Outputs
  logic [17:0] LEDR;
  logic [3:0] LEDG;
  logic [0:6] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;

  // Instantiate the Unit Under Test (UUT)
  Project dut (
    .SW(SW),
    .KEY(KEY),
    .CLOCK_50(CLOCK_50),
    .LEDR(LEDR),
    .LEDG(LEDG),
    .HEX7(HEX7), .HEX6(HEX6), .HEX5(HEX5), .HEX4(HEX4),
    .HEX3(HEX3), .HEX2(HEX2), .HEX1(HEX1), .HEX0(HEX0)
  );

  // Clock generation
  initial begin
    CLOCK_50 = 0;
    forever #10 CLOCK_50 = ~CLOCK_50;  // 50 MHz clock => 20ns period
  end

  // Stimulus
  initial begin
    // Initialize inputs
    SW = 18'd0;
    KEY = 4'b1111;

    // Wait for reset stabilization
    #50;

    // Simulate button press on KEY[2] for reset
    KEY[2] = 0; #20; KEY[2] = 1; #100;

    // Simulate KEY[0] (e.g., processor step or input)
    KEY[0] = 0; #20; KEY[0] = 1; #100;

    // Change switches to simulate input
    SW = 18'b000_0000_0000_0000_0001; #100;
    SW = 18'b001_0000_0000_0000_0010; #100;

    // Repeat as needed
    $display("Simulation running...");
    #1000;

    // Stop the simulation
    $stop;
  end

  // Optional: Monitor outputs
  initial begin
    $monitor("Time=%0t | LEDR=%b | LEDG=%b | HEX0=%b", $time, LEDR, LEDG, HEX0);
  end

endmodule
// module Project_tb;

//    // initialize logic wires
//    logic    [17:0]   SW;
//    logic    [3:0]    KEY;
//    logic             CLOCK_50;
//    logic    [17:0]   LEDR;
//    logic    [3:0]    LEDG;
//    logic    [0:6]    HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0; 

//    // initialize the DUT
//    Project DUT(   SW,
//     KEY,
//     CLOCK_50,
//      LEDR,
//      LEDG,
//     HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0 
// );

//    // clock
//    always begin
//       C
//    end
//    // tb logic
//    initial begin
//       $stop;
//    end
//    // monitor

//    initial begin
//       $monitor($realtime, " NextState = %b, A = %b", DUT.NextState, DUT.unit_Mux.A);
//    end

// /*
//    logic ResetN, Bo, Out;
//    logic [15:0] IR_Out, ALU_A, ALU_B, ALU_Out, M;
//    logic [6:0] PC_Out;
//    logic [3:0] State, NextState;
//    logic [0:6] HEX_internal [7:0]; // internal hex array
// */

// endmodule