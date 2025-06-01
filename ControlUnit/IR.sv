// TCES330 Spring 2025 University of Washington Tacoma Dr. Jie Sheng
// Rodney Deacon & Mahri Yalkapova
// 06-01-2025
// Week 9, Project Folder ControlUnit
// // this module will implement Register and ALU operations

/*IR is purely a group of flip-flops which will 
latch out the input signal
◦ Required input signals: Clock, ld, instruction 
from instruction memory
◦ Required output signal: instruction to the finite 
state machine
*/

module IR ( input Clk, ld,
            input [15:0] inst_in,          // instruction from instruction memory
            output [15:0] inst_out); //instruction to the finite state machine

// localparams

// wires / logic

// assignments

// instantiations

// combinational logic

// proceedural logic

endmodule

// test bench
module IR_tb;

// localparams

    // wires / logic
    logic Clk, ld;
    logic [15:0] inst_in;
    logic [15:0] inst_out;

// instantiation
   IR DUT(Clk, ld, inst_in, inst_out);

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