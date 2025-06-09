// TCES330 Spring 2025 University of Washington Tacoma Dr. Jie Sheng
// Rodney Deacon & Mahri Yalkapova
// 06-01-2025
// Week 9, Project Folder ControlUnit
// This module connects the PC, IR, and StateMachine modules to form the Control Unit of the CPU

`timescale 1 ps / 1 ps
import StateDefs::*; // import state definitions to use as output states
module ControlUnit ( 
   input Clk, ResetN,                  // active low reset
   output D_Wr, RF_s, RF_W_en,                     
   output [7:0] D_Addr,
   output [3:0]RF_W_Addr, RF_Ra_Addr, RF_Rb_Addr,
   output [2:0] ALU_s0,
   output State OutState, NextState,    //outputs for viewing the states
   output [15:0] IR_Out,
   output [6:0] PC_Out);

// wires / logic
logic clock, pc_clr, pc_up, ir_ld, resetN; 
logic [6:0]  pc_out, rom_in;
logic [15:0] rom_out, ir_in, ir_out; 

// input assignments
assign resetN = ResetN;    // assign input to wire
assign clock = Clk;        
assign rom_in = pc_out;    // added for readability
assign ir_in = rom_out;

// instantiate PC module
PC unit_PC(clock, pc_clr, pc_up, pc_out);

//instantiate InstMemory module
InstMemory unit_ROM(rom_in, clock, rom_out);

//instantiate IR module
IR unit_IR(clock, ir_ld, ir_in, ir_out);

//instantiate Finite State Machine module
StateMachine unit_SM(clock, resetN,                               // input signal wires
                     ir_out,                                      // input instruction from IR
                     D_Wr, RF_s, RF_W_en,                         // output control signals
                     pc_clr, ir_ld, pc_up,                        // control signal wires for PC and IR
                     D_Addr, RF_W_Addr, RF_Ra_Addr, RF_Rb_Addr,   
                     ALU_s0, 
                     OutState, NextState                          // output state signals for observation
                     );

// output assignments
assign IR_Out = ir_out;
assign PC_Out = pc_out;

endmodule

// test bench
module ControlUnit_tb;

// wires / logic
   logic Clk, ResetN;
   logic D_Wr, RF_s, RF_W_en;
   logic [7:0] D_Addr;
   logic [3:0]RF_W_Addr, RF_Ra_Addr, RF_Rb_Addr;
   logic [2:0] ALU_s0;
   State OutState, NextState;
   logic [15:0] IR_Out;
   logic [6:0] PC_Out;

// instantiation
   ControlUnit DUT(
                  Clk,ResetN,
                  D_Wr, RF_s, RF_W_en,
                  D_Addr,
                  RF_W_Addr, RF_Ra_Addr, RF_Rb_Addr,
                  ALU_s0, 
                  OutState, NextState,
                  IR_Out,
                  PC_Out
               );

   // clock
   always begin
      Clk = 0; #10;
      Clk = 1; #10;
   end

   // testbench logic
   initial begin
      @(negedge Clk) ResetN = 0; #1; // resets
      @(posedge Clk);
      @(negedge Clk) ResetN = 1; #1; // deassert
      @(posedge Clk);

      // Test Load
      repeat (1200) @(posedge Clk); #1; 

   $stop;
   end
   // monitor
   initial begin
      #1; $monitor($realtime, " ResetN = %b, OutState = %s, NextState = %s, IR_Out = %h, PC_Out, %h", ResetN, state_to_string(OutState), state_to_string(NextState), IR_Out, PC_Out,
                           "\nPC_UP = %b", DUT.pc_up,
                           "\nunit_PC.Up = %b", DUT.unit_PC.Up, // monitor the OutState, NextState, IR_Out, PC_Out, ResetN
                           "\nunit_PC.Clr = %b", DUT.unit_PC.Clr, // monitor the OutState, NextState, IR_Out, PC_Out, ResetN
                           "\nunit_PC.mem_addr = %b", DUT.unit_PC.mem_addr); // monitor the OutState, NextState, IR_Out, PC_Out, ResetN
   end
endmodule