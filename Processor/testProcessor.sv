// TCES 330, Spring 2025
// Testbench  for the programmable processor

`timescale 1 ns / 1 ps
module testProcessor; // 
 
  logic Clk;             // system clock
  logic Reset;           // system reset
  logic [15:0] IR_Out;   // instruction register
  logic [7:0] PC_Out;    // program counter
  logic [3:0] State, NextState;        // state machine state, next state
  logic [15:0] ALU_A, ALU_B, ALU_Out;  // ALU inputs and output 
 
  Processor DUT( Clk, Reset, IR_Out, PC_Out, State, NextState, ALU_A, ALU_B, ALU_Out );

  // generate 50 MHz clock
  always begin
    Clk = 0;
    #10;
    Clk = 1'b1;
    #10;
  end

initial	// Test stimulus
  begin
    $display( "\nBegin Simulation." );
    Reset = 0;         // reset for one clock
    @ ( posedge Clk ) 
    #30  Reset = 1; //or #21 Reset = 1; just wait a little bit time to off the ridge 
    wait( IR_Out == 16'h5000 );  // halt instruction
    $display( "\nEnd of Simulation.\n" );

    $display("True ALU A = %h", DUT.unit_DP.unit_RF.A_Data);

    $stop;
  end
  
initial begin
    $monitor( "Time is %0t : Reset = %b   PC_Out = %h   IR_Out = %h  State = %h  ALU A = %h  ALU B = %h ALU Out = %h  RA Address = %b", $stime, Reset, PC_Out, IR_Out, State, ALU_A, ALU_B, ALU_Out, DUT.RF_Ra_Addr);
    $monitor($realtime, " input address of A = %h\n", DUT.unit_DP.unit_RF.Read_A_Addr,
            "output data of A = %h", DUT.unit_DP.unit_RF.A_Data);
            //  " input address of B = %h\n", DUT.unit_DP.unit_RF.RF_Rb_Addr,
            //  " output address of A = %h\n", DUT.unit_DP.unit_RF.A_Data,
            //  " output address of B = %h\n", DUT.unit_DP.unit_RF.B_Data);    
end


endmodule    



                           