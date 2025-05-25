// TCES330 Spring 2025 University of Washington Tacoma Dr. Jie Sheng
// Rodney Deacon
// 05-01-2025
// Week 5, Lab4 Folder Part1
// this module will 16 bit input A and B Sel 3 bit, output Q 3-bit


module  DMemReg//#(
    //parameters
   // paramater ) // TODO: EXPLORE THIS PARAMATERIZATION IN HEIRARCHY LATER.
   
   /*module RegisterFile #
   (// params
      parameter int data_bits = 16,                      // width of data in bits
      parameter int reg_count = 16,                      // how many registers are in the register file
      parameter int reg_addr_width = $clog2(reg_count))  // the bit length of register memory addresses
   */
  
(
    //ports
    input [7:0] D_Addr; // 8-bit input Data Address
    input D_Wr, RF_W_en, Clk;      // Data write enable ;; Register write enable 
    input [3:0] RF_W_Addr, RF_Ra_Addr, RF_Rb_Addr; // write address ; reg a addres ; reg b address
    output [15:0]A, B;     // A and B data output
);

logic [15:0] R_data; //output from the D

// instantiate the Dmem
/* module DataMemory (
	address,
	clock,
	data,
	wren,
	q);module DataMemory (
	input	[7:0]  address;
	input	  clock;
	input	[15:0]  data;
	input	  wren;
	output	[15:0]  q;*/
DataMemory unit0 (D_Addr, Clk, W_data, D_Wr, R_data);

// instantiate the RF
/*module RegisterFile #
   (// params
      parameter int data_bits = 16,                      // width of data in bits
      parameter int reg_count = 16,                      // how many registers are in the register file
      parameter int reg_addr_width = $clog2(reg_count))  // the bit length of register memory addresses
   (// input / output portlist                      // write data default 16 bits 
      input                         Clk, Write_En,   
      input [reg_addr_width-1:0]    Write_Addr, Read_A_Addr, Read_B_Addr,   // read reg a, b, and write addresses default 4 bits
      input [data_bits-1:0]         Write_Data,                            // write en and clk both 1 bit (pos edge clk)
      output [data_bits-1:0]        A_Data, B_Data);   */
RegisterFile unit1(Clk, RF_W_en, 
                  RF_W_Addr, RF_Ra_Addr, RF_Rb_Addr, 
                  R_data, A, B);


// localparam

// assignments

// combinational logic

// sequential logic

// generate block

// additional logic


    
endmodule


// tb
module  


endmodule