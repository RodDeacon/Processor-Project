// TCES330 Spring 2025 University of Washington Tacoma Dr. Jie Sheng
// Rodney Deacon & Mahri Yalkapova
// 05-30-2025
// Week 8, Project Folder RegisterAlu
// // this module will implement Register and ALU operations

module RegAlu (
    input [3:0] RF_W_addr, RF_Ra_addr, RF_Rb_addr,
    input RF_W_en, Clk,
    input [2:0] Alu_s0,
    output [15:0] Q
);

    // wires / logic
    logic [15:0] A, B, W_data;
   logic [2:0] Sel; // select for alu
    assign W_data = Q;

  
    // instantiate reg
    RegisterFile unit_RF (Clk, RF_W_en,
                            RF_W_addr, RF_Ra_addr, RF_Rb_addr, W_data,
                            A, B);


    // instantiate alu

    ALU unit_ALU (A,B, Alu_s0,Q); // also include params in the future


// module ALU (A,B,Sel, Q);
//    parameter bit_width = 16;
//    parameter n_op = 8; // number of operations 

//    input [ $clog2(n_op)-1 : 0 ]Sel; // the selecting bit will be ceiling log base 2 of number of operations - 1  
//    input [bit_width -1: 0]A,B;
//    output logic [bit_width -1: 0]Q;
   
// // Always comb for ALU logic

endmodule

module RegAlu_tb();

   // logic 
   logic [3:0] RF_W_addr, RF_Ra_addr, RF_Rb_addr;
   logic RF_W_en, Clk;
   logic [2:0] Alu_s0;
   logic [15:0] Q;

   // instantiation
   /*
    input [3:0] RF_W_addr, RF_Ra_addr, RF_Rb_addr,
    input RF_W_en, Clk,
    input [2:0] Alu_s0,
    output [15:0] Q,
);
*/

   RegAlu DUT (  RF_W_addr, RF_Ra_addr, RF_Rb_addr,
   RF_W_en, Clk, Alu_s0, Q);

   //clk
   always begin
      Clk = 0; #10;
      Clk = 1; #10;
   end

   
   // Testbench for RegAlu
   initial begin

      @(negedge Clk) #1;
      // enable W_wr
      RF_W_en = 1;
   // assign a data
      //   assign W_data = 47
      DUT.W_data = 16'd47;
      //    assign W_addr = R[1]
      RF_Ra_addr = 4'd1;
      //    assign RF_Ra_addr
      RF_W_addr = RF_Ra_addr; 
      // wait a clock cycle
      @(posedge Clk) #1;
      // Ra_data should be == W_data
      assert(DUT.unit_RF.A_Data == DUT.W_data) $display("Ra_data (should be 47): %d", DUT.unit_RF.A_Data);
         else $error("FAILED: got %d, expected 47", DUT.unit_RF.A_Data);

   // assign b data
      //   assign W_data
      DUT.W_data = 16'd17;
      //    assign W_addr
      RF_Rb_addr = 4'd2;
      //    assign Rb_addr
      RF_W_addr = RF_Rb_addr;
      // W_addr = Rb_addr
      // wait a clock cycle
      @(posedge Clk) #1;
      // Rb_add should be == W_data
      assert(DUT.unit_RF.B_Data == DUT.W_data) $display("Rb_data (should be 17): %d", DUT.unit_RF.B_Data);
            else $error("FAILED: got %d, expected 17", DUT.unit_RF.B_Data);


      

/*
      case (Sel)
//   if Sel == 0 the output is 0
         0 : Q = 16'd0;
//   if Sel == 1 the output is A + B
         1 : Q = A + B;
//   if Sel == 2 the output is A – B
         2 : Q = A - B;
//   if Sel == 3 the output is A (pass-through)
         3 : Q = A;
//   if Sel == 4 the output is A ^ B
         4 : Q = A ^ B;
//   if Sel == 5 the output is A | B
         5 : Q = A | B;
//   if Sel == 6 the output is A & B
         6 : Q = A & B;
//   if Sel == 7 the output is A + 1;
         7 : Q = A + 16'd1;
      endcase
*/


      // test add R[1] + R[2] (47 + 17)
         // set proper value for ALU for addition (3)        
         @(negedge Clk) #1;
         RF_W_en = 0; #1;
         Alu_s0 = 3'd1;
         
         // wait some time
         @(posedge Clk) #1;
         // ensure that Q == alu out(internal output of alu) == W_data
         assert(Q == 64) $display("yay, it worked. Q should be 64. Q == %d", Q); /// expected value
            else $error("waa waa not working Q should be 64 but it is %d", Q);
         assert((Q == DUT.unit_ALU.Q) && (Q == DUT.W_data)) $display("The output q is eqaul to W_data, Q = %d, W_Data = %d ", Q, DUT.W_data);
            else $error("sadge.. it doesnt work :(");


      // test subtract R[1] - R[2] (47 - 17)
         // set proper value for ALU for subtraction (4)
         Alu_s0 = 3'd2;
         // wait some time
         @(posedge Clk) #1;
         // ensure that Q == alu out(internal output of alu) == W_data
         assert(Q == 30) $display("yay, it worked Q should be 30. Q == %d", Q); /// expected value
            else $error("waa waa not working Q should be 30 but it is %d", Q);
         assert((Q == DUT.unit_ALU.Q) && (Q == DUT.W_data)) $display("The output q is eqaul to W_data, Q = %d, W_Data = %d ", Q, DUT.W_data);
            else $error("sadge.. it doesnt work :(");

         // ensure that Q == alu out(internal output of alu) == W_data

   $stop;

   
   end
   // $monitor("At time %t: RegAlu outputs...", $time);

   // always begin
   //    $display($time, "A = %d, B = %d, Q = %d", DUT.A, DUT.B, Q);
   // end

   initial begin
      $monitor("A = %d, B = %d", DUT.unit_RF.A_Data, DUT.unit_RF.B_Data);

   end

   endmodule