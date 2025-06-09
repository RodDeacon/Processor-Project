// TCES330 Spring 2025 University of Washington Tacoma Dr. Jie Sheng
// Rodney Deacon and Mahri Yalkapova
// 06-08-2025
// this module will perfrom arithmetic or logical
// operation on 16 bit input A and B based on 
// the 3 bit selectring signal Sel, and output it 
// in a 16-bit Q 

module ALU (A,B,Sel, Q);
   parameter bit_width = 16;        // the bit-width
   parameter n_op = 8;              // number of operations 

   input [ $clog2(n_op)-1 : 0 ]Sel; // the selecting bit will be ceiling log base 2 of number of operations - 1  
   input [bit_width -1: 0]A,B;      // 2 inputs A and B
   output logic [bit_width -1: 0]Q; // output Q
   
// Always comb for ALU logic
   always_comb begin : case_block
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
   end
endmodule


// test bench for ALU
module ALU_tb();
   // parameters
   localparam bit_width = 16;
   localparam n_op = 8; // number of operations 

   // logic
   logic [ $clog2(n_op)-1 : 0 ]S;
   logic [bit_width -1: 0]A,B;
   logic [bit_width -1: 0]Q;

   // DUT instantiation 
   //module ALU (A,B,Sel, Q);
   ALU  DUT(.A(A),.B(B),.Sel(S),.Q(Q));

   initial begin
      // test 0
      S = 0; #1;
      assert(Q==0);

      // test 1
      S = 1; A = 1; B = 2; #1;
      $display("S = %b ",S, "A = %b  ", A, "B = %b  ",B, "Q = %b  ", Q); 
      assert(Q == A+B);

      // test 2
      S = 2; A = 2; B = 1; #1;
      $display("S = %b ",S, "A = %b  ", A, "B = %b  ",B, "Q = %b  ", Q);
      assert(Q == A-B);

      // test 3
      S = 3; A = 2; #1;
      $display("S = %b ",S, "A = %b ", A, "B = %b ",B, "Q = %b ", Q);
      assert(Q == A);

      // test 4
      S = 4; A = 0101; B = 1111; #1;
      $display("S = %b ",S, "A = %b ", A, "B = %b ",B, "Q = %b ", Q);
      S = 4; A = 0000; B = 0000; #1;
      $display("S = %b ",S, "A = %b ", A, "B = %b ",B, "Q = %b ", Q);
      assert(Q == A ^ B);

      // test 5
      S = 5; A = 0101; B = 1010; #1;
      $display("S = %b ",S, "A = %b ", A, "B = %b ",B, "Q = %b ", Q);
      S = 5; A = 0000; B = 0000; #1;
      $display("S = %b ",S, "A = %b ", A, "B = %b ",B, "Q = %b ", Q);
      assert(Q == A | B);

      // test 6
      S = 6; A = 1011; B = 1000; #1;
      $display("S = %b ",S, "A = %b ", A, "B = %b ",B, "Q = %b ", Q);
      S = 6; A = 1111; B = 1111; #1;
      $display("S = %b ",S, "A = %b ", A, "B = %b ",B, "Q = %b ", Q);
      assert(Q == A & B);

      // test 7
      S = 7; A = 3; #1;
      $display("S = %b ",S, "A = %b ", A, "B = %b ",B, "Q = %b ", Q);
      assert(Q == A + 16'd1);

      $stop;
   end
endmodule