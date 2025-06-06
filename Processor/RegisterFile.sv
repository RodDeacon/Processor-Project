// TCES330 Spring 2025 University of Washington Tacoma Dr. Jie Sheng
// Rodney Deacon
// 05-22-2025
// Week 8, Register Folder RegisterFile
// this module will implement RegisterFile operations

/*Course Project - week8 status check

We talked about data memory (RAM) design and testing on Tuesday, and the demo example

Download demo example is shared on Canvas.

You are required to work together with your project partner starting this week on the design and testing for the remaining 
parts of the Datapath, as we discussed in class. In particular, during Thursday (May 22)'s class, we 
will work on design and testing of the register file, which contributes 2 points to the total (100 points) of your project. 
Rubrics for the assessment of course project is attached.

To help you finish the design and testing of register file, please follow the hints given below:

1. decide the portlist of the register file (check page 8 of the pdf file DataPath)

2. understand the difference between RAM and register file - notice that (1) register file has two 
outputs - Data A and Data B, which means you need to feed the module with addresses of both 
register A and register B; (2) all the 16 registers have no data at the beginning - the 
testbench should first initialize a specific register by writing data to it; 
then read this register to see if the data has been correctly assigned. 

3. timing of read and write operations (of the register file) is very similar as that of RAM.

4. In ModelSim, you can check the contents of register file (same for RAM) by click on menu view -> memory list as I illustrated during Tuesday's class.

Please submit (one submission per group) your design and testing of the register file by midnight Saturday May 24. 
Hopefully you can use Thursday's class time (as well as lab session in the afternoon) to have it done by the end of day. 
Then your group can move on to the design and testing of the remaining parts of processor's datapath as listed in the project timeline
.*/

module RegisterFile #
   (// params
      parameter int data_bits = 16,                      // width of data in bits
      parameter int reg_count = 16,                      // how many registers are in the register file
      parameter int reg_addr_width = $clog2(reg_count))  // the bit length of register memory addresses
   (// input / output portlist                      // write data default 16 bits 
      input                         Clk, Write_En,   
      input [reg_addr_width-1:0]    Write_Addr, Read_A_Addr, Read_B_Addr,   // read reg a, b, and write addresses default 4 bits
      input [data_bits-1:0]         Write_Data,                            // write en and clk both 1 bit (pos edge clk)
      output [data_bits-1:0]        A_Data, B_Data);                       // a and b data output both default 16 bits
// RegisterFile DUT ( Write_En, Clk, Write_Addr, Read_A_Addr, Read_B_Addr,  Write_Data,A_Data, B_Data
   // - - - logic - - - // 
   // logic [nbits] regfile [n] // n registers, each nbits 
   logic [data_bits-1:0] regfile [0:reg_count-1]; // the registers store data_bits length of data (16 bits by default)

   // - - - assignments - - - // 
// read the registers (can be done in assignments)/*
   // THE FOLLOWING IS AN EXAMPLE FROM SLIDE 10 of "Processor2025_Datapath.pdf"
   // reg [31:0] RF [31:0]; // 32 registers each 32 bits long

   // assign Data1 = RF[Read1]; // read1 and 2 are the input 
   // assign Data2 = RF[Read2]; // data1 and 2 are the output*/

   assign A_Data = regfile[Read_A_Addr]; // read the registers
   assign B_Data = regfile[Read_B_Addr]; // assign them to output 

   // - - - combinational logic - - - // 

   // - - - sequential logic - - - // 
// write the registers
   always_ff @(posedge Clk) begin // write the register with new value if regwrite is high
      if (Write_En) regfile[Write_Addr] <= Write_Data; // write the data to the address in the array
   end
   // - - - generate - - - // 

endmodule

// // - - - testbench - - - //
// module RegisterFile_tb;
// // - - - port list - - - //
// // params
//    localparam int data_bits = 16;                    // width of data in bits
//    localparam int reg_count = 16;                      // how many registers are in the register file
//    localparam int reg_addr_width = $clog2(reg_count);  // the bit length of register memory addresses
   
// // input / output portlist
// /*      input                         Clk, Write_En,   
//       input [reg_addr_width-1:0]    Write_Addr, Read_A_Addr, Read_B_Addr,   // read reg a, b, and write addresses default 4 bits
//       input [data_bits-1:0]         Write_Data,                            // write en and clk both 1 bit (pos edge clk)
//       output [data_bits-1:0]        A_Data, B_Data);*/          // write data default 16 bits 
//    logic                         Clk, Write_En;  
//    logic [reg_addr_width-1:0]    Write_Addr, Read_A_Addr, Read_B_Addr;  // read reg a, b, and write addresses default 4 bits
//    logic [data_bits-1:0]         Write_Data, A_Data, B_Data;                          // write en and clk both 1 bit (pos edge clk)
    

// // - - - DUT instantiation - - - //
//    RegisterFile DUT ( Clk, Write_En, Write_Addr, Read_A_Addr, Read_B_Addr, Write_Data,A_Data, B_Data);

// // - - - clk - - - //
//    always begin
//       Clk = 0; #10;
//       Clk = 1; #10;
//    end
// // - - - tb logic - - - //
//    initial begin

//    end

// // - - - monitor - - - //
//    initial begin

//    end
// endmodule

module RegisterFile_tb;

	logic Clk, write;
	logic [3:0] wrAddr, rdAddrA, rdAddrB;
	logic [15:0] wrData, rdDataA, rdDataB;
	
	logic [4:0] counter;
	
	RegisterFile DUT (clk, write, wrAddr, wrData, rdAddrA, rdDataA, rdAddrB, rdDataB);
	
	always begin
		Clk = 0; #10;
		Clk = 1; #10;
	end
	
	initial begin
	
		//load data into memory
		write = 1;
		rdAddrA = 0;
		rdAddrB = 0;
		for (counter=0; counter <= 4'b1111; counter++) begin
			wrData = counter;
			wrAddr = counter;
			#40;
		end
		
		//read data from memory
		write = 0;
		for (counter=0; counter <= 4'b1111; counter++) begin
			rdAddrA = counter;
			rdAddrB = counter; #40;
			
			$display("Memory address A[%0d] contains: %0d", rdAddrA, DUT.rdDataA);
			$display("Memory address B[%0d] contains: %0d", rdAddrB, DUT.rdDataB);
		end
	
	$stop; 
	end

endmodule
