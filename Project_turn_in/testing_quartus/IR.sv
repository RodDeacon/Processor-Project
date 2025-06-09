// TCES330 Spring 2025 University of Washington Tacoma Dr. Jie Sheng
// Rodney Deacon & Mahri Yalkapova
// 06-01-2025
// Week 9, Project Folder ControlUnit
// This module is the Instruction register. It will latch the Instruction from the Instruction
// Memory (A.mif) and pass it to the state machine so long as ld is high.

module IR ( input Clk, ld,
            input [15:0] inst_in,          // instruction from instruction memory
            output logic [15:0] inst_out); //instruction to the finite state machine

   // loads instruction from ROM if load is 1, otherwise stays the same
   always_ff @(posedge Clk) begin
      if (ld == 1) begin
         inst_out <= inst_in;
      end else begin 
         inst_out <= inst_out;
      end
   end

endmodule

// test bench
module IR_tb;

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
      ld = 1;
      inst_in = 'd444;
      
      @(posedge Clk) #1; // wait for the values to be latched
   
      assert(inst_out == 'd444)   $display("Success!!! The output should be 444, actual: %d", inst_out);
      else $error("Expecting 444, actual: %d", inst_out);

      // disable the ld, wait for sometime, test again
      @(negedge Clk) #1;
      ld = 0;
      repeat(5) @(posedge Clk) #1;
      assert(inst_out == 'd444)   $display("Success!!! The output should be 444, actual: %d", inst_out);
      else $error("Expecting 444, actual: %d", inst_out);
      

      $stop;
   end
   // monitor
   initial begin
      $monitor($realtime, " ld = %b, inst_in = %d, inst_out = %d",ld, inst_in, inst_out);
   end

endmodule
