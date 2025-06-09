// TCES330 Spring 2025 University of Washington Tacoma Dr. Jie Sheng
// Rodney Deacon & Mahri Yalkapova
// 06-01-2025
// Week 9, Project Folder DataPath
// this module will connect all necessary components of the processor together 
// to form the Data Path of the CPU

`timescale 1 ps / 1 ps
module DataPath
   ( // input / output portlist
   input Clk, D_wr, RF_W_en, RF_s,
   input [7:0] D_Addr, 
   input [3:0] RF_W_addr, RF_Ra_addr, RF_Rb_addr,
   input [2:0] Alu_s0,
   output logic [15:0] A, B, ALU_Out
   );

// logic
   logic [15:0] 
   wire_A_Data    // 16-bit
   ,wire_B_Data    // 16-bit
   ,wire_ALU_MUX0  // 16-bit
   ,wire_RAM_MUX1  // 16-bit
   ,wire_MUX_RF;    // 16-bit

// assignments
   assign A = wire_A_Data;
   assign B = wire_B_Data;
	assign ALU_Out = wire_ALU_MUX0;

// instantiate modules

   // intantiate DataMemory
   DataMemory unit_DM (D_Addr, 
                        Clk, 
                        wire_A_Data, 
                        D_wr, 
                        wire_RAM_MUX1
                        );
   
// instantiate Mux_2_to_1(m, x,s,y); non-standard mux  output first, then x, then select, then y
   Mux_2_to_1 unit_MUX (wire_MUX_RF, wire_ALU_MUX0, RF_s, wire_RAM_MUX1);

    // instantiate reg
    RegisterFile unit_RF (Clk, RF_W_en,
                           RF_W_addr, RF_Ra_addr, 
                           RF_Rb_addr, wire_MUX_RF,
                           wire_A_Data, wire_B_Data);


    // instantiate alu
    ALU unit_ALU (wire_A_Data, wire_B_Data, Alu_s0, ALU_Out);

endmodule

module DataPath_tb();

   logic Clk, D_wr, RF_W_en, RF_s; 
   logic [7:0] D_Addr; 
   logic [3:0] RF_W_addr, RF_Ra_addr, RF_Rb_addr;
   logic [2:0] Alu_s0;
   logic [15:0] A, B, ALU_Out; // outputs from the datapath

// initialize DUT
   DataPath DUT (Clk, D_wr, RF_W_en, RF_s, D_Addr, 
      RF_W_addr, RF_Ra_addr, RF_Rb_addr, Alu_s0,A,B, ALU_Out);

// clock generation
   always begin
      Clk = 0; #10;
      Clk = 1; #10;

   end
// logic
   initial begin
      
         //test selec1 of MUX
         @(negedge Clk) #1;
         RF_s = 1'd1;

   // test the REGISTERFILE AND THE DMEM 
      // Initialize all signals
      D_Addr = 0;
      D_wr = 0;
      RF_W_en = 0;
      RF_W_addr = 0;
      RF_Ra_addr = 0;
      RF_Rb_addr = 0;
      @(negedge Clk) #1;

      // --- LOAD OPERATION TEST ---
      // 1. Set up for load: DataMemory address 0, write to reg 0, read reg 0
      D_Addr = 8'd0;
      RF_W_addr = 4'd0;
      RF_Rb_addr = 4'd0;
      D_wr = 1'b0; // Not writing to memory
      RF_W_en = 1'b1; // Enable register file write

      @(posedge Clk) #1; // Wait for register file to latch data + delay
      RF_W_en = 1'b0; // Disable write after latching
      @(posedge Clk) #1; // Wait for data to propagate + delay
      $display("Register B (should be 123): %d", DUT.wire_B_Data);
      assert(DUT.wire_B_Data == 16'd123) else $error("LOAD failed: got %d, expected 123", DUT.wire_B_Data);


      $display("wire_A_Data = %d, wire_RAM_MUX1 = %d",DUT.wire_A_Data, DUT.wire_RAM_MUX1);
      $display("Mux input is x = %d, s = %d, y = %d\noutput m = %d", DUT.unit_MUX.x,DUT.unit_MUX.s,DUT.unit_MUX.y,DUT.unit_MUX.m);
      $display("w_in_rf = %d",DUT.unit_RF.Write_Data);       

      // --- STORE OPERATION TEST ---
      @(negedge Clk) #1; // Wait for clock edge to store data

    // store to memory
      RF_W_addr = 4'd2; // Register which will be written to
      RF_W_en = 1'b1;   // Enable register file write to store the data in memory

      D_Addr = 8'd9; // Address to store data
      D_wr = 1'b0;      // disable data's ability to write to register file 


      // Ra stores data to the memory
      // R[2], data in the address is 222
      // RF_Ra_addr = 4'd2;
      // DUT.wire_A_Data = 16'd222; 
      // R = 16'd222; 
      // use dot operator to store value at the Ra_data so that we can test if it passes to the W-data input of the RAM (DataMemory)

      @(negedge Clk) #1; // Wait for clock edge to store data
      @(posedge Clk) #1; // Wait for data to propagate

      RF_W_en = 1'b0;// turn off write
      $display("Data stored at address %d (should be 222): %d", D_Addr, DUT.unit_DM.data);
      $display("The input of the Ram is : %d", DUT.wire_A_Data);
      $display("Ra_data is : ", DUT.unit_RF.A_Data);


      // TEST ALU 
       //test selec1 of MUX
         @(negedge Clk) #1;
         RF_s = 1'd0;

          // test add R[1] + R[2] (222 + 123)
         // set proper value for ALU for addition (3)        
         @(negedge Clk) #1;
         RF_W_en = 0; #1;
         Alu_s0 = 3'd1;
         
         // wait some time
         @(posedge Clk) #1;
         // ensure that Q == alu out(internal output of alu) == W_data
         assert(DUT.wire_ALU_MUX0 == 64) $display("yay, it worked. Q should be 345. Q == %d", DUT.wire_ALU_MUX0); /// expected value
            else $error("waa waa not working Q should be 345 but it is %d", DUT.wire_ALU_MUX0);
         assert((DUT.wire_ALU_MUX0 == DUT.unit_ALU.Q) && (DUT.wire_ALU_MUX0 == DUT.wire_MUX_RF)) $display("The output q is eqaul to W_data, Q = %d, W_Data = %d ", DUT.wire_ALU_MUX0, DUT.wire_MUX_RF);
            else $error("sadge.. it doesnt work :(");


      // test subtract R[1] - R[2] (222 - 123)
         // set proper value for ALU for subtraction (4)
         Alu_s0 = 3'd2;
         // wait some time
         @(posedge Clk) #1;
         // ensure that Q == alu out(internal output of alu) == W_data
         assert(DUT.wire_ALU_MUX0 == 30) $display("yay, it worked Q should be 99. Q == %d", DUT.wire_ALU_MUX0); /// expected value
            else $error("waa waa not working Q should be 99 but it is %d", DUT.wire_ALU_MUX0);
         assert((DUT.wire_ALU_MUX0 == DUT.unit_ALU.Q) && (DUT.wire_ALU_MUX0 == DUT.wire_MUX_RF)) $display("The output q is eqaul to W_data, Q = %d, W_Data = %d ", DUT.wire_ALU_MUX0, DUT.wire_MUX_RF);
            else $error("sadge.. it doesnt work :(");

      $stop;
   end

// monitor
   initial begin
      $monitor($realtime, " D_wr = %b | RF_w_en = %b | RF_s = %b | Alu_s0 = %b | D_Addr = %h | RF_W_addr = %b | RF_Ra_addr = %b | RF_Rb_addr = %b | A = %h | B = %h | ALU_Out = %h"
                           ,D_wr, RF_W_en, RF_s, Alu_s0
                           ,D_Addr, RF_W_addr, RF_Ra_addr, RF_Rb_addr
                           ,A, B, ALU_Out);     
   end
endmodule

/* code graveyard 

        _.---,._,'
       /' _.--.<
         /'     `'
       /' _.---._____
       \.'   ___, .-'`
           /'    \\             .
         /'       `-.          -|-
        |                       |
        |                   .-'~~~`-.
        |                 .'         `.
        |                 |  R  I  P  |
  jgs   |                 |           |
        |                 |           |
         \              \\|           |//
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
*/
/*module  DMemReg_tb();
   logic [7:0] D_Addr; // 8-bit input Data Address
   logic D_wr, RF_W_en, Clk;      // Data write enable ;; Register write enable 
   logic [3:0] RF_W_addr, RF_Ra_addr, RF_Rb_addr; // write address ; reg a addres ; reg b address
   logic [15:0]A, B;     // A and B data output

   DMemReg DUT (D_Addr, D_wr, RF_W_en, Clk, RF_W_addr, RF_Ra_addr, RF_Rb_addr, A, B);

   // Clock generation
   always begin
      Clk=1'b0; #10;
      Clk=1'b1; #10;
   end

   initial begin
      // Initialize all signals
      D_Addr = 0;
      D_wr = 0;
      RF_W_en = 0;
      RF_W_addr = 0;
      RF_Ra_addr = 0;
      RF_Rb_addr = 0;
      #25;

      // --- LOAD OPERATION TEST ---
      // 1. Set up for load: DataMemory address 0, write to reg 0, read reg 0
      D_Addr = 8'd0;
      RF_W_addr = 4'd0;
      RF_Rb_addr = 4'd0;
      D_wr = 1'b0; // Not writing to memory
      RF_W_en = 1'b1; // Enable register file write

      @(posedge Clk) #1; // Wait for register file to latch data + delay
      RF_W_en = 1'b0; // Disable write after latching

      @(posedge Clk) #1; // Wait for data to propagate + delay
      $display("Register B (should be 123): %d", B);
      assert(B == 16'd123) else $error("LOAD failed: got %d, expected 123", B);


      // --- STORE OPERATION TEST ---
      
    // PREPARE TO STORE DATA IN MEMORY

      // Set the data to be stored in memory
      // enable write to register file 
      RF_W_en = 1'b1; // Enable register file write
      // have write address (2) RF[2] = 222
      RF_W_addr = 4'd2;
      // and write data
      DUT.W_data_RF = 16'd222; 
      @(negedge Clk) #1; // Wait for clock edge to store data
      @(posedge Clk) #1; // Wait for data to propagate

      // now that the RF[2] = 222, we can test if we can store it in the memory
      

    // store to memory

      D_wr = 1'b0;      // disable data's ability to write to register file 
      RF_W_en = 1'b1;   // Enable register file write to store the data in memory

      // Ra stores data to the memory
      // R[2], data in the address is 222
      RF_Ra_addr = 4'd2;
      // use dot operator to store value at the Ra_data so that we can test if it passes to the W-data input of the RAM (DataMemory)
      D_Addr = 8'd9; // Address to store data

      @(negedge Clk) #1; // Wait for clock edge to store data
      @(posedge Clk) #1; // Wait for data to propagate
      $display("Data stored at address %d (should be 222): %d", D_Addr, DUT.unit_DM.data);


       //  // PREPARE TO STORE DATA IN MEMORY

   //    // Set the data to be stored in memory
   //    // enable write to register file 
   //    RF_W_en = 1'b1; // Enable register file write
   //    // have write address (2) RF[2] = 222
   //    RF_W_addr = 4'd2;
   //    // and write data
   //   DUT.Ra_data = 16'd222; 
   //    // DUT.Mux0 = 16'd222;
   //    RF_s = 0; 
   //    @(negedge Clk) #1; // Wait for clock edge to store data
   //    @(posedge Clk) #1; // Wait for data to propagate

   //    // now that the RF[2] = 222, we can test if we can store it in the memory

         // D_wr = 1'b0;      // disable data's ability to write to register file 
      // RF_W_en = 1'b1;   // Enable register file write to store the data in memory

      // // Ra stores data to the memory
      // // R[2], data in the address is 222
      // RF_Ra_addr = 4'd2;
      // // use dot operator to store value at the Ra_data so that we can test if it passes to the W-data input of the RAM (DataMemory)
      // D_Addr = 8'd9; // Address to store data

      // @(negedge Clk) #1; // Wait for clock edge to store data
      // @(posedge Clk) #1; // Wait for data to propagate
      // $display("Data stored at address %d (should be 222): %d", D_Addr, DUT.unit_DM.data);

      // //test select 0 of MUX
      //    @(negedge Clk) #1;
      //    RF_s = 1'd0;
      

      $stop;
   end*/