// TCES330 Spring 2025 University of Washington Tacoma Dr. Jie Sheng
// Rodney Deacon
// 05-01-2025
// Week 5, Lab4 Folder Part1
// this module will 16 bit input A and B Sel 3 bit, output Q 3-bit


// 2^16 - 1 = 65535

module ALU (A,B,Sel, Q);
   param bit_width = 16;
   param n_op = 8; // number of operations 

   input [ $clog2(n_op)-1:0]Sel; // clog2(n_nop) - 1 will give us the upper bound to use
   input [bit_width -1: 0]A,B;
   ouput [bit_width -1: 0]Q;



// This ALU has eight functions:
//   if Sel == 0 the output is 0
//   if Sel == 1 the output is A + B
//   if Sel == 2 the output is A – B
//   if Sel == 3 the output is A (pass-through)
//   if Sel == 4 the output is A ^ B
//   if Sel == 5 the output is A | B
//   if Sel == 6 the output is A & B
//   if Sel == 7 the output is A + 1;
// if additional functions added for future expansion
// you need to expand the selecting signal too

// module ALU( A, B, Sel, Q );
//   input [2:0] Sel;     // function select
//   input [15:0] A, B;   // input data
//   output logic [15:0] Q; // ALU output (result)




endmodule


// TRY PARAMETER AND REDEFINE PARAM IN TB

module ALU_tb;

endmodule
