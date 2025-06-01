// TCES330 Spring 2025 University of Washington Tacoma Dr. Jie Sheng
// Rodney Deacon & Mahri Yalkapova
// 06-01-2025
// Week 9, Project Folder ControlUnit
// // this module will implement Register and ALU operations

/*Variable Meaning
PC_clr Program counter (PC) clear command
IR_ld Instruction load command
PC_up PC increment command
D_addr Data memory address (8 bits)
D_wr Data memory write enable
RF_s Mux select line
RF_Ra_addr Register file A-side read address (4 bits)
RF_Rb_addr Register file B-side read address (4 bits)
RF_W_en Register file write enable
RF_W_Addr Register file write address (4 bits)
ALU_s0 ALU function select (3 bits)
*/



module StateMachine (
   input Clk,
   input [15:0] IR,
   output D_Wr, RF_s, RF_W_en,
   output [7:0] D_Addr,
   output [3:0]RF_W_addr, RF_Ra_addr, RF_Rb_addr,
   output [2:0] Alu_s0
   );

// localparams
typedef enum logic [3:0] { 
   Noop = 0,    // 0  NOOP
   Store,   // 1 STORE
   Load_A,    // 2.1 LOAD
   Load_B,    // 2.1 LOAD
   Add,     // 3 ADD
   Sub, // 4 SUB
   Halt, // 5 HALT
   Init, // 6 Init
   Fetch, // 7 Fetch
   Decode // 8 Decode
 } State;

 typedef enum logic [3:0] { 
   _noop = 0,    // 0  NOOP
   _store,   // 1 STORE
   _load,    // 2 LOAD
   _add,     // 3 ADD
   _sub, // 4 SUB
   _halt, // 5 HALT
 } inst;

// wires / logic
// logic [3:0] CurrentState

State CurrentState, NextState;

// assignments
   // assign StateOut = CurrentState;
   // only for monitoring but we can monitor in the testbench by using DUT. ..

// combinational logic
   always_comb begin : state_logic
      case(CurrentState)
      // noop
         Noop : NextState = Fetch;
      // store
         Store    : begin D_addr = IR[7:0];D_wr = 1;
            RF_Ra_addr = IR[11:5];
            
            end 
      // load
         Load_A   : NextState = Load_B;
         Load_B   : begin 
            NextState = Fetch;
            D_addr = IR[11:4];
            RF_s = 1;
            RF_W_addr = IR[3:0];
            RF_W_en = 1;
         end
      // add
         Add      : begin
            NextState = Fetch;
            RF_W_addr = IR[3:0];
            RF_W_en = 1;
            RF_Ra_addr = IR[11:8];
            RF_Rb_addr = IR[7:4];
            Alu_s0 = 1; // option 1 chosen from ALU (addition)

         end


      // sub
         Sub      : begin                 // subtraction
            NextState = Fetch;               // change NextState
            RF_W_addr = IR[3:0];             // the register file address is equal to the first four bits of the instruction register
            RF_W_en = 1;                     // enable RF write
            RF_Ra_addr = IR[11:8];              // register a is assigned the address from IR
            RF_Rb_addr = IR[7:4];               // register b is assigned the address from IR
            Also_s0 = 2;                        // option 2 chosen from ALU (subtraction)
         end         
      // halt
         Halt     : NextState = Halt;
      // init
         Init     : NextState = Fetch;
      // fetch
         Fetch    : NextState = Decode;
      // decode
         Decode:  case(IR[3:0]) // check the first four bits of the instruction register addrress 
            _noop    : NextState = Noop;     // 0 noop
            _store   : NextState = Store;    // 1 store
            _load    : NextState = Load_A;     // 2 load
            _add     : NextState = Add;      // 3 ADD
            _sub     : NextState = Sub;      // 4 SUB
            _halt    : NextState = Halt;     // 5 HALT
            default  : NextState = Noop;   // default instruction is noop
         endcase

         default: NextState = Fetch; // default case is init i.e. NextState = Fetch
      endcase
   end

// proceedural logic
   always_ff @( posedge Clk ) begin : ff_logic
         State <= NextState;   // go to the state we described above
  end // end the always ff logic   
   
/*
State Machine State OutputsState Non-Zero Outputs
Init PC_clr = 1
Fetch IR_ld = 1, PC_up =1
Decode Check the opcode
LoadA D_addr = IR[11:4], RF_s = 1, RF_W_addr = IR[3:0]
LoadB D_addr = IR[11:4], RF_s = 1, RF_W_addr = IR[3:0], RF_W_en = 1
Store D_addr = IR[7:0], D_wr = 1, RF_Ra_addr = IR[11:8]
Add, Sub RF_Ra_addr = IR[11:8], RF_Rb_addr = IR[7:4], RF_W_addr = IR[3:0], RF_W_en = 1, 
ALU_s0 = alu function  (1 for Add  or 2 for Sub), RF_s = 0
Halt
*/
// proceedural logic

endmodule

// test bench
module StateMachine_tb;

// localparams

   logic Clk;
   logic D_Wr, RF_s, RF_W_en;
   logic [7:0] D_Addr;
   logic [3:0]RF_W_addr, RF_Ra_addr, RF_Rb_addr;
   logic [2:0] Alu_s0;
// instantiation
   StateMachine DUT(
                  Clk,
                  D_Wr, RF_s, RF_W_en,
                  D_Addr,
                  RF_W_addr, RF_Ra_addr, RF_Rb_addr,
                  Alu_s0
               );


   // clock
   always begin
      Clk = 0; #10;
      Clk = 1; #10;
   end

   // testbench logic
   initial begin

   end
   // monitor
   initial begin
      $monitor("");
   end

endmodule