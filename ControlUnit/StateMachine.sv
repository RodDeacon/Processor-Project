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



import StateDefs::*; // import statedefs package in order to use enums. (wildcard)
// import StateDefs::State; // import State enumerator
// import StateDefs::inst;  // import instruction enumerator

module StateMachine (
   input Clk, 
   input [15:0] IR,
   output logic D_wr, RF_s, RF_W_en, PC_clr, IR_ld, PC_up, 
   output logic [7:0] D_addr,
   output logic [3:0] RF_W_addr, RF_Ra_addr, RF_Rb_addr,
   output logic [2:0] Alu_s0
   );

// localparams
// typedef enum logic [3:0] { 
//    Noop = 0,    // 0  NOOP
//    Store,   // 1 STORE
//    Load_A,    // 2.1 LOAD
//    Load_B,    // 2.1 LOAD
//    Add,     // 3 ADD
//    Sub, // 4 SUB
//    Halt, // 5 HALT
//    Init, // 6 Init
//    Fetch, // 7 Fetch
//    Decode // 8 Decode
//  } State;

//  typedef enum logic [3:0] { 
//    _noop = 0,    // 0  NOOP
//    _store,   // 1 STORE
//    _load,    // 2 LOAD
//    _add,     // 3 ADD
//    _sub, // 4 SUB
//    _halt // 5 HALT
//  } inst;

// wires / logic
// logic [3:0] CurrentState

State CurrentState, NextState;
inst _inst; 


// assignments
   assign _inst = inst'(IR[15:12]); // cast as instruction enum inst
   // assign StateOut = CurrentState;
   // only for monitoring but we can monitor in the testbench by using DUT. ..

// combinational logic
   always_comb begin : state_logic
      case(CurrentState)
      // noop
         Noop : NextState = Fetch;
      // store
         Store    : begin 
            D_addr = IR[7:0];
            D_wr = 1;
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
            Alu_s0 = 2;                        // option 2 chosen from ALU (subtraction)
         end         
      // halt
         Halt     : NextState = Halt;
      // init
         Init     : begin 
            PC_clr = 1;
            NextState = Fetch;
         end 
      // fetch
         Fetch    : begin 
            PC_up = 1;
            IR_ld = 1;
            NextState = Decode;
         end 
      // decode
         Decode:  case(_inst) // check the first four bits of the instruction register addrress 
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
         CurrentState <= NextState;   // go to the state we described above
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

// wires / logic

   logic Clk;
   logic [15:0] IR;
   logic D_Wr, RF_s, RF_W_en, PC_clr, IR_ld, PC_up;
   logic [7:0] D_Addr;
   logic [3:0]RF_W_addr, RF_Ra_addr, RF_Rb_addr;
   logic [2:0] Alu_s0;
// instantiation
   StateMachine DUT ( Clk,
     IR,
    D_Wr, RF_s, RF_W_en, PC_clr, IR_ld, PC_up,
     D_Addr,
    RF_W_addr, RF_Ra_addr, RF_Rb_addr,
    Alu_s0);

// functions
   // make function for string 
   function string state_to_string(State s);
   case (s)
      Noop:     return "Noop";
      Store:    return "Store";
      Load_A:   return "Load_A";
      Load_B:   return "Load_B";
      Add:      return "Add";
      Sub:      return "Sub";
      Halt:     return "Halt";
      Init:     return "Init";
      Fetch:    return "Fetch";
      Decode:   return "Decode";
      default:  return "Unknown";
   endcase
endfunction

function string inst_to_string(inst instruction);
    case (instruction)
        _noop  : return "Noop";
        _store : return "Store";
        _load  : return "Load_A";
        _add   : return "Add";
        _sub   : return "Sub";
        _halt  : return "Halt";
        default: return "Unknown";
    endcase
endfunction


   // clock
   always begin
      Clk = 0; #10;
      Clk = 1; #10;
   end
   
    
   // testbench logic
   initial begin
      inst _counter;  
      State _state;
      Clk = 0; // clk 0
      
      // test all instructions except for load
     
      for (int i = 0; i < 6; i ++) begin
         _counter = inst'(i); // instruction variable. this will track expected instruction by using i
         _state   = State'(i);   // state variable. This will track the expected State by using i
         // reset the FSM: 
         @(negedge Clk) #1;
         DUT.CurrentState = State'(Init); // 
         DUT._inst = inst'(i); 

         $display("Resetting to Init to test %s.\nCurrentState = %s",inst_to_string(_counter), state_to_string(DUT.CurrentState)); 
         // wait 3 to get to get expected
         repeat (3) @(posedge Clk) #1;
         assert (DUT.CurrentState == _state) $display("Success! The Expected state was %s and was %s!", inst_to_string(_counter), state_to_string(DUT.CurrentState)); 
            else   $error("The expected state was %s. It was actually %s.", inst_to_string(_counter), state_to_string(DUT.CurrentState));
       
         if (_counter == _load) begin // if the expected instruction == load, do this  aswell.
            // wait 1 to get to load B
            @(posedge Clk) #1;
            // assert for current state
            assert (DUT.CurrentState == Load_B)
            $display("Success! The Expected state was Load_B and was %s!", state_to_string(DUT.CurrentState)); 
            else   $error("The expected state was Load_B. It was actually %s.", state_to_string(DUT.CurrentState));
               // TODO: assert for all variables which are being changed..
         end
      end


      $stop;
   end
   // monitor
   initial begin
      $monitor("");
   end

endmodule



      // // test load
      //    // reset the FSM: 
      // @(negedge Clk) #1;
      // DUT.CurrentState = State'(Init); // 
      // DUT._inst = inst'('d2); 
      //    $display("Resetting to Init to test load.\nCurrentState = %s",state_to_string(DUT.CurrentState)); 
      // // wait 3 to get to load A
      //    repeat (3) @(posedge Clk) #1;
      //    assert (DUT.CurrentState == Load_A)
      //       $display("Success! The Expected state was Load_A and was %s!", state_to_string(DUT.CurrentState)); 
      //       else   $error("The expected state was Load_A. It was actually %s.", state_to_string(DUT.CurrentState));
      //  // wait 1 to get to load B
      //    @(posedge Clk) #1;
      //    // assert for current state
      //    assert (DUT.CurrentState == Load_B)
      //       $display("Success! The Expected state was Load_B and was %s!", state_to_string(DUT.CurrentState)); 
      //       else   $error("The expected state was Load_B. It was actually %s.", state_to_string(DUT.CurrentState));
         

         





































      // DUT.CurrentState = State'(Init);
      // DUT._inst = inst'('d0);       //
      
      // // $display("CurrentState = %s",state_to_string(DUT.CurrentState)); 
      // // reset high
      // // wait

      // // reset low

      // // test noop
      //    // // init values
      //    // @(negedge Clk) #1;  
         
         
         
      //    $display("CurrentState = %s",state_to_string(DUT.CurrentState)); 
      //    repeat (3) @(posedge Clk) #1; // wait the required amount of time
      //    assert (DUT.CurrentState == Noop) 
      //       $display("Success! The Expected state was Noop and was %s!", state_to_string(DUT.CurrentState)); 
      //       else   $error("The expected state was Noop. It was actually %s.", state_to_string(DUT.CurrentState));
      //    // $display("CurrentState = %s",state_to_string(DUT.CurrentState)); 

         

      // // test store
      
      //    // reset the FSM: 
      // @(negedge Clk) #1;
      // DUT.CurrentState = State'(Init);
      // // change the instruction
      // DUT._inst = inst'('d2); 
      //    $display("Resetting to Init to test load.\nCurrentState = %s",state_to_string(DUT.CurrentState)); 
      // // wait 3 to get to load A
      //    repeat (3) @(posedge Clk) #1;
      //    assert (DUT.CurrentState == Load_A)
      //       $display("Success! The Expected state was Load_A and was %s!", state_to_string(DUT.CurrentState)); 
      //       else   $error("The expected state was Load_A. It was actually %s.", state_to_string(DUT.CurrentState));
      //  // wait 1 to get to load B
      //    @(posedge Clk) #1;
      //    // assert for current state
      //    assert (DUT.CurrentState == Load_B)
      //       $display("Success! The Expected state was Load_B and was %s!", state_to_string(DUT.CurrentState)); 
      //       else   $error("The expected state was Load_B. It was actually %s.", state_to_string(DUT.CurrentState));
         

      // // test add
      // @(negedge Clk) #1;
      // DUT.CurrentState = State'(Init);
      // DUT._inst = inst'(d4);
      // $display("Success! The Expected state was Add and was %s!", state_to_string(DUT.CurrentState))
      // repeat (3) @(posedge Clk) #1;
      
      

      // // test sub

      // // test halt
