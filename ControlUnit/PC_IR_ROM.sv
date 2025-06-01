// TCES330 Spring 2025 University of Washington Tacoma Dr. Jie Sheng
// Rodney Deacon & Mahri Yalkapova
// 06-01-2025
// Week 9, Project Folder ControlUnit
// InstMemory, IR, PC testing

`timescale 1 ps / 1 ps
module PC_IR_ROM (input Clk, PC_Clr, PC_Up, IR_ld ,
                  output [15:0] inst_out); // IR is the instruction output to state machine

// internal wires
   // two internal wire
   logic [6:0] mem_addr, PC_out; // from pc to adr of ROM (7-bit)    
   logic [15:0] inst_in, ROM_out;// from ROM to IR (16-bits) 

   assign inst_in = ROM_out;  // for readability (not necessary)
	assign mem_addr = PC_out;

// instantiate modules

PC unit_PC(Clk, PC_Clr, PC_Up, PC_out);

InstMemory unit_ROM(mem_addr, Clk, ROM_out);

IR unit_IR(Clk, IR_ld, inst_in, inst_out);

endmodule


// tb
module PC_IR_ROM_tb;

   // logic
	logic Clk, PC_Clr, PC_Up, IR_ld;
   logic [15:0] inst_out; 

   // instantiation
   PC_IR_ROM DUT( 
            Clk, PC_Clr, PC_Up, IR_ld,
            inst_out 
            );

	always begin
		Clk = 0; #10;
      Clk = 1; #10;
	end





// --




// ---
	initial begin
      // initialize
      Clk = 0;
      PC_Clr = 1;
      // load and enable 
      IR_ld = 1; // for the purposes of this test bench, this just means that we will be able to see an out put @inst_out
      PC_Up = 1;
      
      @(posedge Clk) #1;
      
      PC_Clr = 0; // dessert the PC_Clr so program counter can count.
      repeat(5) @(posedge Clk) #1 ;
      
// test output of IR
      assert (inst_out == 0) 
         $display("Success!!! Expected 0, actual: %d", inst_out);
         else   $error("at testing IR Expected 0, actual: %d", inst_out);
// test PC 
      assert (DUT.unit_PC.mem_addr == 5 ) 
         $display("Success. %d", DUT.unit_PC.mem_addr ); 
         else  $error("Error! The value is: %d", DUT.unit_PC.mem_addr );

// test from the actual values of the ROM memory location 7 should return 2.
   repeat (2) @(posedge Clk) #3;
   assert (DUT.unit_ROM.address == 7) 
      $display("Success. %d", DUT.unit_ROM.address);  
      else   $error("Error! The mem_adress is: %d", DUT.unit_ROM.address);

   PC_Up = 0; 
   repeat(2) @(posedge Clk) #1;
   assert (inst_out == 'd10) 
      $display("Success. inst_out = %d", inst_out);  
      else   $error("inst_out should be 2, inst _out = %d", inst_out);


      $stop;
   end
// ---- 

   initial begin
      $display($realtime, " PC_Clr = %d, PC_Up = %d, IR_ld = %d, inst_out = %d ", PC_Clr, PC_Up, IR_ld, inst_out );
   end

endmodule



/// --- - - -- - -- 


// initial begin
//     // Initialize
//     PC_Clr = 1;
//     IR_ld = 1;
//     PC_Up = 1;

//     @(posedge Clk);
//     PC_Clr = 0; // Release reset
    
//     // Wait a few cycles to let PC count and pipeline data propagate
//     repeat (8) @(posedge Clk);
    
//     // At this point PC.mem_addr should be 7 (or 8 depending on counting)
//     if (DUT.unit_PC.mem_addr != 7) 
//       $error("PC address expected 7 but got %d", DUT.unit_PC.mem_addr);
//     else
//       $display("PC address correct: %d", DUT.unit_PC.mem_addr);
    
//     // Because of pipeline delay, inst_out corresponds to PC address from 2 cycles ago
//     // Adjust expected value accordingly (e.g., expect 10 at this point)
//     if (inst_out != 10) 
//       $error("inst_out expected 10 but got %d", inst_out);
//     else
//       $display("inst_out correct: %d", inst_out);
    
//     $stop;
// end


/// --- -- --- -
// initial begin
//     // Initialize signals
//     PC_Clr = 1;
//     PC_Up = 1;
//     IR_ld = 1;

//     // Wait one clock to clear PC
//     @(posedge Clk);
//     #1;
//     PC_Clr = 0;  // Release clear so PC starts counting

//     // Check PC = 0, inst_out should be ROM[0]
//     @(posedge Clk);
//     #2; // small delay to allow signals to settle
//     assert (DUT.unit_PC.mem_addr == 0)
//       else $error("PC mem_addr expected 0 but is %d", DUT.unit_PC.mem_addr);
//     assert (inst_out == 1)  // assuming ROM[0] = 1 in your .mif
//       else $error("inst_out expected 1 but is %d", inst_out);

//     // Advance PC 7 cycles to check address 7 and inst_out
//     repeat (7) @(posedge Clk);
//     #2; // wait for outputs to settle

//     assert (DUT.unit_PC.mem_addr == 7)
//       else $error("PC mem_addr expected 7 but is %d", DUT.unit_PC.mem_addr);
//     assert (inst_out == 2)  // assuming ROM[7] = 2 as per your content
//       else $error("inst_out expected 2 but is %d", inst_out);

//     // Advance more cycles and check PC and inst_out again
//     repeat (5) @(posedge Clk);
//     #2;

//     assert (DUT.unit_PC.mem_addr == 12)
//       else $error("PC mem_addr expected 12 but is %d", DUT.unit_PC.mem_addr);
//     assert (inst_out == 3)  // assuming ROM[12] = 3 as per your content
//       else $error("inst_out expected 3 but is %d", inst_out);

//     $display("All tests passed!");
//     $stop;
// end