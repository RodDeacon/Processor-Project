/*Required input signals: Clock, D_Addr, 
D_Wr, RF_s, RF_W_Addr, RF_W_en, 
RF_Ra_Addr, RF_Rb_Addr, ALU_s0
Required output signals: ALU_inA, 
ALU_inB, ALU_out*/

// synopsys translate_off
`timescale 1 ps / 1 ps
module DataPath#(// params
   )
   ( // input  
   input Clk, D_wr, RF_W_en, RF_s,
   input [7:0] D_Addr, 
   input [3:0] RF_W_addr, RF_Ra_addr, RF_Rb_addr,
   input [2:0] Alu_s0
);
// localparam
logic [15:0] R_data, W_data_mux, A, B, W_data_D, Mux0, ALU_out;

assign W_data_D = A;
assign Mux0 = ALU_out;

// assignments
// instantiate modules

   DataMemory unit_DM (D_Addr, 
                     Clk, 
                     W_data_D, 
                     D_wr, 
                     R_data
   );
   

// module Mux_2_to_1(m, x,s,y);

   Mux_2_to_1 unit_MUX (W_data_mux, Mux0, RF_s, R_data);


    // instantiate reg
    RegisterFile unit_RF (Clk, RF_W_en,
                            RF_W_addr, RF_Ra_addr, RF_Rb_addr, W_data_mux,
                            A, B);


    // instantiate alu

    ALU unit_ALU (A, B, Alu_s0, ALU_out); // also include params in the future

   

   
// combinational logic

// sequential logic

// generate block

// additional logic

endmodule

module DataPath_tb();

   logic Clk, D_wr, RF_W_en, RF_s; 
   logic [7:0] D_Addr; 
   logic [3:0] RF_W_addr, RF_Ra_addr, RF_Rb_addr;
   logic [2:0] Alu_s0;

   DataPath DUT (Clk, D_wr, RF_W_en, RF_s, D_Addr, 
      RF_W_addr, RF_Ra_addr, RF_Rb_addr, Alu_s0);

   
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
      $display("Register B (should be 123): %d", DUT.B);
      assert(DUT.B == 16'd123) else $error("LOAD failed: got %d, expected 123", DUT.B);


      $display("W_data_D = %d, R_data = %d",DUT.W_data_D, DUT.R_data);
      $display("Mux input is x = %d, s = %d, y = %d\noutput m = %d", DUT.unit_MUX.x,DUT.unit_MUX.s,DUT.unit_MUX.y,DUT.unit_MUX.m);
      $display("w_in_rf = %d",DUT.unit_RF.Write_Data);       

      // --- STORE OPERATION TEST ---
      @(negedge Clk) #1; // Wait for clock edge to store data

    // store to memory
      D_wr = 1'b1;      // disable data's ability to write to register file 
      RF_W_en = 1'b1;   // Enable register file write to store the data in memory

      // Ra stores data to the memory
      // R[2], data in the address is 222
      RF_Ra_addr = 4'd2;
      RF_W_addr = 4'd2;
      DUT.W_data_D = 16'd222; 
      // R = 16'd222; 
      // use dot operator to store value at the Ra_data so that we can test if it passes to the W-data input of the RAM (DataMemory)
      D_Addr = 8'd9; // Address to store data

      @(negedge Clk) #1; // Wait for clock edge to store data
      @(posedge Clk) #1; // Wait for data to propagate
      $display("Data stored at address %d (should be 222): %d", D_Addr, DUT.unit_DM.data);
      $display("The input of the Ram is : %d", DUT.W_data_D);
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
         assert(Mux0 == 64) $display("yay, it worked. Q should be 345. Q == %d", Mux0); /// expected value
            else $error("waa waa not working Q should be 345 but it is %d", Mux0);
         assert((Mux0 == DUT.unit_ALU.ALU_out) && (Mux0 == DUT.W_data_mux)) $display("The output q is eqaul to W_data, Q = %d, W_Data = %d ", Mux0, DUT.W_data);
            else $error("sadge.. it doesnt work :(");


      // test subtract R[1] - R[2] (222 - 123)
         // set proper value for ALU for subtraction (4)
         Alu_s0 = 3'd2;
         // wait some time
         @(posedge Clk) #1;
         // ensure that Q == alu out(internal output of alu) == W_data
         assert(Mux0 == 30) $display("yay, it worked Q should be 99. Q == %d", Mux0); /// expected value
            else $error("waa waa not working Q should be 99 but it is %d", Mux0);
         assert((Mux0 == DUT.unit_ALU.ALU_out) && (Mux0 == DUT.W_data_mux)) $display("The output q is eqaul to W_data, Q = %d, W_Data = %d ", Mux0, DUT.W_data);
            else $error("sadge.. it doesnt work :(");

      $stop;
   end

   

// monitor
   initial begin
      $monitor("reer");
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