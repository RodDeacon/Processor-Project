// TCES330 Spring 2025 University of Washington Tacoma Dr. Jie Sheng
// Rodney Deacon & Mahri Yalkapova
// 06-01-2025
// Week 9, Project Folder ControlUnit
// This module implements the Program Counter, which 
// counts to the next place in the instruction memory when recieving
// PC_up high signal from StateMachine

module PC (input Clk, Clr, Up, // up is enable
            output logic[6:0] mem_addr); // output memory location which next instruction can be found

 // always block logic for flipflop
   always_ff @(posedge Clk) begin
      if (Clr == 1) begin // clear all 
         mem_addr <= 'd0;
      end else if (Up == 1) begin // else if , enabled, count up 
         mem_addr <= mem_addr + 1'b1;
      end else begin // else; clearn is not asserted, en is not high, Q remains the same as it was before.
         mem_addr <= mem_addr;
      end
   end

endmodule

// test bench
module PC_tb;

// wires / logic
logic Clk, Clr, Up;
logic [6:0] mem_addr; 

// instantiation
   PC DUT(Clk, Clr, Up, mem_addr);

// clock
   always begin
      Clk = 0; #10;
      Clk = 1; #10;
   end

// testbench logic
   initial begin
      Up = 1;
      Clr = 1;
      // clear one
      // wait for a clock cycle to enable clear
      @(posedge Clk) #1;
      @(negedge Clk) #1;
      Clr = 0;
      @(posedge Clk) #1; 

 // test counting up
      repeat (20) @(posedge Clk) #1;  
      
      assert (mem_addr == 'd21) $display("Success! mem_addr = %d", mem_addr);
      else   $error("The mem_addr should be 19, but it is %d.",mem_addr);
      


// try counting with Up disabled      
      // reset
      //Clr = 1; #1;

      @(negedge Clk) #1;         //Clr = 0; #1;    
      Up = 0;
      repeat (20) @(posedge Clk) #1; 

      assert (mem_addr == 'd21) $display("Success! mem_addr = %d", mem_addr);
      else   $error("The mem_addr should be 21, but it is %d.",mem_addr);
      
// try counting with clr enabled
      @(negedge Clk) #1;               // test reset
      Clr = 1; #1; 
      repeat (20) @(posedge Clk) #1;          
      
      assert (mem_addr == 'b0) $display("Success! mem_addr = %d", mem_addr);
      else   $error("The mem_addr should be 0, but it is %d.",mem_addr);

      $stop;
   end
   // monitor
   initial begin
      $monitor($realtime, " Clk = %b, Clr = %b, Up = %b, mem_addr = %h", Clk, Clr, Up, mem_addr);
   end
endmodule
/*module PC (input , , , // up is enable
            output logic[6:0] ); // output memory location which next instruction can be found
*/