// TCES330 Spring 2025 University of Washington Tacoma Dr. Jie Sheng
// Rodney Deacon
// 05-01-2025
// Week 5, Lab4 Folder Part1
// this module will 16 bit input A and B Sel 3 bit, output Q 3-bit
`timescale 1 ps / 1 ps

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
    input [7:0] D_Addr, // 8-bit input Data Address
    input D_wr, RF_W_en, Clk,      // Data write enable ;; Register write enable 
    input [3:0] RF_W_addr, RF_Ra_addr, RF_Rb_addr, // write address ; reg a addres ; reg b address
    output [15:0]A, B    // A and B data output
);

logic [15:0] R_data, W_data_RF, W_data_DM; //output from the DRAM

assign W_data_DM = A; 
assign W_data_RF = R_data;
// FIXME : GOES TO MUX.. we can temporarily just connect directly to the RegFile

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
DataMemory unit_DM (D_Addr, 
                  Clk, 
                  W_data_DM, 
                  D_wr, 
                  R_data
);

// instantiate the RF
RegisterFile unit_RF (Clk, 
                  RF_W_en, 
                  RF_W_addr, 
                  RF_Ra_addr, 
                  RF_Rb_addr, 
                  W_data_RF, 
                  A, 
                  B
);


// localparam

// assignments

// combinational logic

// sequential logic

// generate block

// additional logic


    
endmodule


// tb
module  DMemReg_tb();
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


      $stop;
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

// RF_W_addr=4'd1;      // define write address as register 1
   // RF_Ra_addr=4'd2;     // read address for register A (register 2)


      //LOAD // come from data memory to register file.
         // 0010 d7d6d5d4d3d2d1d0 r3r2r1r0 <----- this is the instruction LOAD from 6-instruction processor seen on slide 3 
         // first four bits are the opcode, next 8 bits are the data address, and last 4 bits are the register address. 
      D_Addr=8'd0;         // instantiate the data address to 0
      // this is the input to DRAM

      RF_W_addr=4'd1;      // write address to register 1
      // this is input to Register file

      RF_Ra_addr=4'd2;     // read address for register A (register 2)
      // input to Register file

      RF_Rb_addr=4'd3;     // read address for register B (register 3)
      // input to Register file

      D_wr=1'b0;           // data write enable is 0, meaning we are not writing to the data memory
      // write enable for the dram
         // (set to 0)
      
      RF_W_en=1'b1;        // register file write enable is 1, meaning we are writing to the register file
      // write enable for register file
         // (set to 1)

      
      #20;  // wait for one clock cycle
   
   // store load combo
      // test if output Ra_data can be passed to Dmemory and then be transferred to the RegFile
      // and output to Rb_data



      // display the data at all the registers
      @(posedge Clk) #2; $display("the data at location %d", D_Addr, "is %d", A);
         
      @(negedge Clk) D_Addr=8'd5; 
      D_wr=1'b0; 
      RF_W_en=1'b1; // load data from address 5 into register 1

      @(posedge Clk) #2; $display("the data at location %d", D_Addr, "is %d", A);
      // x=A; // this is not needed, as we are not using the x variable in this testbench.
      // @(negedge Clk) D_Addr=8'd41; RF_W_addr=4'd2; RF_Ra_addr=4'd3; RF_Rb_addr=4'd4; wr=1'b0; RF_W_en=1'b1;

      

      //STORE
         // 0001 r3r2r1r0 d7d6d5d4d3d2d1d0 <----- this is the instruction STORE from 6-instruction processor seen on slide 3
         // first four bits are the opcode, next 8 bits are the data address, and last 4 bits are the register address.


   //    D_Addr=8'd0;
   //    @(negedge Clk) D_Addr=8'd5; wr=1'b1; W_data=16'd10;
   //    @(posedge Clk) #2; $display("the data at location %d", D_Addr, "is %d", R_data);
   //    x=R_data;
   // @(negedge Clk)D_Addr=8'd41; W_data=16'd20;
   //    @(posedge Clk) #2; $display("the data at location %d", D_Addr, "is %d", R_data);
   //    y=Dout;
   //    Din=x+y;
   //    @(posedge Clk) #2; $display("the data at location %d", Addr, "is %d", Dout);
   // @(posedge Clk) #2; $display("the data at location %d", Addr, "is %d", Dout);
   */