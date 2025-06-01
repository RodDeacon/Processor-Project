// TCES330 Spring 2025 University of Washington Tacoma Dr. Jie Sheng
// Rodney Deacon & Mahri Yalkapova
// 06-01-2025
// Week 9, Project Folder ControlUnit
// // this module will implement Register and ALU operations

/* PC is purely a counter 
◦ Required input signals: Clock, Clr, Up
◦ Required output signal: address (7-bit) to 
access instruction memory  
◦ Notice here Clr is active high – from FSM*/

module PC (input Clr, Up, 
            output [6:0] mem_addr); // output memory location which next instruction can be found

// localparams

// wires / logic

// assignments

// instantiations

// combinational logic

// proceedural logic

endmodule

// test bench
module PC_tb;

// localparams

// wires / logic
logic Clr, Up;
logic [6:0] mem_addr; 

// instantiation
   PC DUT(Clr, Up, mem_addr);

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