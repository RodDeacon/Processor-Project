// TCES330 Spring 2025 University of Washington Tacoma Dr. Jie Sheng
// Rodney Deacon & Mahri Yalkapova
// 06-01-2025
// Week 9, Project Folder ControlUnit
// test the DROM
// go to that address and fetch the instruction at that address.
`timescale 1 ps / 1 ps
module DROM_tb;

   // logic

	logic	[6:0]  address; // input address
	logic	  clock;         // clock
	logic	[15:0]  q;     // output q data goes to instruction register 

   // instantiate the DROM 

   InstMemory DUT (address,clock,q);

   // clock
   always begin
      clock = 0; #10;
      clock = 1; #10;
   end

   // logic
   initial begin
      // check if the input is the output
      // display the input
      $display("The input address is %h", address);
      // wait a clock cycle
      @(posedge clock) #1;
      // display the output
      $display("The output instruction is %h", q);
   end

   // monitor
   initial begin
      $monitor("");
   end


endmodule