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
   output D_wr, RF_s, RF_W_en,
   output [7:0] D_Addr,
   output [3:0]RF_W_addr, RF_Ra_addr, RF_Rb_addr,
   output [2:0] Alu_s0);

// localparams

// wires / logic
logic PC_Clr, PC_Up, IR_ld;
logic [6:0] PC_Out;
logic [15:0] ROM_Out, IR_Out;

// assignments
assign inst_in = ROM_Out;  // for readability (not necessary)
assign mem_addr = PC_Out;

// instantiations
/*module StateMachine (
   input Clk, 
   input [15:0] IR,
   output logic D_wr, RF_s, RF_W_en, PC_clr, IR_ld, PC_up, 
   output logic [7:0] D_addr,
   output logic [3:0] RF_W_addr, RF_Ra_addr, RF_Rb_addr,
   output logic [2:0] Alu_s0
   );*/

PC unit_PC(Clk, PC_Clr, PC_Up, PC_Out);

InstMemory unit_ROM(mem_addr, Clk, ROM_Out);

IR unit_IR(Clk, IR_ld, inst_in, inst_out);

StateMachine unit_SM(Clk, inst_out, D_wr, RF_s,
               RF_W_en, PC_Clr, IR_ld, PC_Up, 
               D_Addr, RF_W_Addr, RF_Ra_Addr, RF_Rb_Addr,
               Alu_s0);

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

      @(posedge Clk);

      // Test Load
      repeat (4) @(posedge Clk); //from Load_A to Load_B
      assert(DUT.RF_s == 1) $display ();
      else $error();

   end
   // monitor
   initial begin
      $monitor("");
   end

endmodule