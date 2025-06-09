// TCES330 Spring 2025 University of Washington Tacoma Dr. Jie Sheng
// Rodney Deacon and Mahri Yalkapova
// 05-22-2025
// Week 8, Register Folder RegisterFile
// this module will implement RegisterFile operations

module RegisterFile #
   (// params
      parameter int data_bits = 16,                      // width of data in bits
      parameter int reg_count = 16,                      // how many registers are in the register file
      parameter int reg_addr_width = $clog2(reg_count))  // the bit length of register memory addresses
   (// input / output portlist                      	
      input                         Clk, Write_En,   
      input [reg_addr_width-1:0]    Write_Addr, Read_A_Addr, Read_B_Addr,   // read reg a, b, and write addresses default 4 bits
      input [data_bits-1:0]         Write_Data,                            // write en and clk both 1 bit (pos edge clk)
      output [data_bits-1:0]        A_Data, B_Data);                       // a and b data output both default 16 bits

   // - - - logic - - - // 
   // logic [nbits] regfile [n] // n registers, each nbits 
   logic [data_bits-1:0] regfile [0:reg_count-1]; // the registers store data_bits length of data (16 bits by default)

   // - - - assignments - - - // 
	// read the registers
   assign A_Data = regfile[Read_A_Addr]; 
   assign B_Data = regfile[Read_B_Addr];

   // - - - sequential logic - - - // 
   // write the registers
   always_ff @(posedge Clk) begin // write the register with new value if regwrite is high
      if (Write_En) regfile[Write_Addr] <= Write_Data; // write the data to the address in the array
   end

endmodule

//testbench
module RegisterFile_tb;

   //logic
	logic Clk, write;
	logic [3:0] wrAddr, rdAddrA, rdAddrB;
	logic [15:0] wrData, rdDataA, rdDataB;
	logic [4:0] counter;
	
   //RegisterFile instantiation
	RegisterFile DUT (Clk, write, wrAddr, wrData, rdAddrA, rdDataA, rdAddrB, rdDataB);
	
   //Clock
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
