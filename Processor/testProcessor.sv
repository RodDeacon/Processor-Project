// TCES 330, Spring 2025
// Testbench  for the programmable processor
`timescale 1 ns / 1 ps

import StateDefs::*; // import statedefs package in order to use enums. (wildcard)
module testProcessor; // 
 
  logic Clk;             // system clock
  logic Reset;           // system reset
  logic [15:0] IR_Out;   // instruction register
  logic [6:0] PC_Out;    // program counter
  logic [3:0] Statee, NextState;        // state machine state, next state
  logic [15:0] ALU_A, ALU_B, ALU_Out;  // ALU inputs and output 
  State CurrentState, NextStateEnum;

  Processor DUT( Clk, Reset, IR_Out, PC_Out, Statee, NextState, ALU_A, ALU_B, ALU_Out );

  // generate 50 MHz clock
  always begin
    Clk = 0;
    #10;
    Clk = 1'b1;
    #10;
  end

initial	// Test stimulus
  begin
    CurrentState = State'(Statee);
    NextStateEnum = State'(NextState); 
    $display( "\nBegin Simulation." );
    Reset = 0;         // reset for one clock
    @ ( posedge Clk ) 
    #30  Reset = 1; //or #21 Reset = 1; just wait a little bit time to off the ridge 
    wait( IR_Out == 16'h5000 );  // halt instruction
    $display( "\nEnd of Simulation.\n" );

    $display("True ALU A = %h", DUT.unit_DP.unit_RF.A_Data);

    $stop;
  end
  
// initial begin
//     $monitor( "Time is %0t : Reset = %b   PC_Out = %h   IR_Out = %h  State = %h  ALU A = %h  ALU B = %h ALU Out = %h  RA Address = %b", $stime, Reset, PC_Out, IR_Out, Statee, ALU_A, ALU_B, ALU_Out, DUT.RF_Ra_Addr);
//     $monitor($realtime, " input address of A = %h\n", DUT.unit_DP.unit_RF.Read_A_Addr,
//             "output data of A = %h", DUT.unit_DP.unit_RF.A_Data);
//             //  " input address of B = %h\n", DUT.unit_DP.unit_RF.RF_Rb_Addr,
//             //  " output address of A = %h\n", DUT.unit_DP.unit_RF.A_Data,
//             //  " output address of B = %h\n", DUT.unit_DP.unit_RF.B_Data);    
// end
  // Real-time monitor
  initial begin
    $monitor("T=%0t | Reset=%b | PC=%h | IR=%h | State=%h | ALU A=%h | ALU B=%h | ALU Out=%h | RF_Ra_Addr=%b | A_Data=%h | Read_A_Addr=%h", 
      $time, Reset, PC_Out, IR_Out, Statee, ALU_A, ALU_B, ALU_Out,
      DUT.RF_Ra_Addr,
      DUT.unit_DP.unit_RF.A_Data,
      DUT.unit_DP.unit_RF.Read_A_Addr);
  end


endmodule    



                           /*// TCES 330, Spring 2025
// Testbench  for the programmable processor
`timescale 1 ns / 1 ps

import StateDefs::*; // import statedefs package to use enum State

module testProcessor;

  // DUT I/O Signals
  logic Clk;
  logic Reset;
  logic [15:0] IR_Out;
  logic [6:0] PC_Out;
  logic [3:0] State, NextState;
  logic [15:0] ALU_A, ALU_B, ALU_Out;
  State CurrentState, NextStateEnum;

  // Instantiate the DUT
  Processor DUT(
    .Clk(Clk),
    .Reset(Reset),
    .IR_Out(IR_Out),
    .PC_Out(PC_Out),
    .State(State),
    .NextState(NextState),
    .ALU_A(ALU_A),
    .ALU_B(ALU_B),
    .ALU_Out(ALU_Out)
  );

  // Clock generation: 50 MHz -> 20ns period
  always begin
    Clk = 0; #10;
    Clk = 1; #10;
  end

  // Test stimulus
  initial begin
    $display("\n=== Begin Simulation ===");

    Reset = 0;         // assert reset
    @ (posedge Clk);
    #1 Reset = 1;       // deassert reset after 1 tick
    @ (posedge Clk);

    // Wait until Halt instruction (0x5000) is seen
    wait(IR_Out == 16'h5000);

    $display("\n=== End of Simulation ===");
    $display("Final ALU A Data = %h", DUT.unit_DP.unit_RF.A_Data);
    $stop;
  end

  // Real-time monitor
  initial begin
    $monitor("T=%0t | Reset=%b | PC=%h | IR=%h | State=%h | ALU A=%h | ALU B=%h | ALU Out=%h | RF_Ra_Addr=%b | A_Data=%h | Read_A_Addr=%h", 
      $time, Reset, PC_Out, IR_Out, Statee, ALU_A, ALU_B, ALU_Out,
      DUT.RF_Ra_Addr,
      DUT.unit_DP.unit_RF.A_Data,
      DUT.unit_DP.unit_RF.Read_A_Addr);
  end

endmodule




                           */