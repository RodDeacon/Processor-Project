// TCES330 Spring 2025 University of Washington Tacoma Dr. Jie Sheng
// Rodney Deacon & Mahri Yalkapova
// 06-01-2025
// Week 9, Project Folder ControlUnit
// // this module will implement Register and ALU operations
/*
Control Unit module should instantiate 
the following submodules:
PC.sv
IR.sv
InstMemory.v
FSM.sv
Required input signals: Clock, ResetN
(Notice here the ResetN signal is required 
for FSM; it is active low!)
Required output signals: PC_Out, IR_Out, 
OutState, NextState, D_Addr, D_Wr,RF_s, 
RF_W_en, RF_Ra_Addr, RF_Rb_Addr, 
RF_W_Addr, ALU_s0*/

module ControlUnit (
   input Clk,
   output D_Wr, RF_s, RF_W_en,
   output [7:0] D_Addr,
   output [3:0]RF_W_addr, RF_Ra_addr, RF_Rb_addr,
   output [2:0] Alu_s0);

// localparams

// wires / logic

// assignments

// instantiations

// combinational logic

// proceedural logic

endmodule

// test bench
module ControlUnit_tb;

// localparams

// wires / logic

   logic Clk;
   logic D_Wr, RF_s, RF_W_en;
   logic [7:0] D_Addr;
   logic [3:0]RF_W_addr, RF_Ra_addr, RF_Rb_addr;
   logic [2:0] Alu_s0;
// instantiation
   ControlUnit DUT(
                  Clk,
                  D_Wr, RF_s, RF_W_en,
                  D_Addr,
                  RF_W_addr, RF_Ra_addr, RF_Rb_addr,
                  Alu_s0
               );

   // clock
   always begin
      Clk = 0; #10;
      Clk = 1; #10;
   end

   // testbench logic
   initial begin

   end
   // monitor
   initial begin
      $monitor("");
   end

endmodule