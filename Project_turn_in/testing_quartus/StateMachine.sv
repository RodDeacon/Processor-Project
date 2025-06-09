// TCES330 Spring 2025 University of Washington Tacoma Dr. Jie Sheng
// Rodney Deacon & Mahri Yalkapova
// 06-01-2025
// Week 9, Project Folder
// This module is a Finite State Machine for the CPU project.
// It has 10 total states


import StateDefs::*; // import StateDefs package in order to use enums.
// using a wildcard allows us to import enumerated types and all functions

module StateMachine (
   input Clk, ResetN, // active low reset 
   input [15:0] IR,
   output logic D_wr, RF_s, RF_W_en, PC_clr, IR_ld, PC_up, 
   output logic [7:0] D_addr,
   output logic [3:0] RF_W_addr, RF_Ra_addr, RF_Rb_addr,
   output logic [2:0] Alu_s0,
   output State CurrentState, NextState // for viewing purposes passed to control unit
   );

// logic / parameters
   inst _inst; // instantiate and inst (instruction enum) _inst

// assignments
   assign _inst = inst'(IR[15:12]); // cast IR as instruction enum

// combinational logic
   always_comb begin : state_logic
   // define all variables used in the state machine as 0
      D_wr = 0;
		RF_s = 0;
		RF_W_en = 0;
		PC_clr = 0;
		IR_ld = 0;
		PC_up = 0;
		D_addr = 8'd0;
		RF_W_addr = 4'd0;
		RF_Ra_addr = 4'd0;
		RF_Rb_addr = 4'd0;
		Alu_s0 = 3'd0;

	// case statement	
      case(CurrentState)   // Depending on CurrentState
      // noop
         Noop : NextState = Fetch;
      // store
         Store    : begin 
            NextState = Fetch;
            D_addr = IR[7:0];
            D_wr = 1;
            RF_Ra_addr = IR[11:8];
            end 
      
         Load_A   : begin           // load A
            NextState = Load_B;
            D_addr = IR[11:4];
            RF_s = 1;
            RF_W_addr = IR[3:0];            
            end
         Load_B   : begin            // load B
            NextState = Fetch;
            D_addr = IR[11:4];
            RF_s = 1;
            RF_W_addr = IR[3:0];
            RF_W_en = 1;
         end

         Add      : begin                    // add
            NextState = Fetch;
            RF_W_addr = IR[3:0];
            RF_W_en = 1;
            RF_Ra_addr = IR[11:8];
            RF_Rb_addr = IR[7:4];
            Alu_s0 = 3'd1; // option 1 chosen from ALU (addition)
            RF_s = 0;

         end


      // sub
         Sub      : begin                 // subtraction
            NextState = Fetch;               // change NextState
            RF_W_addr = IR[3:0];             // the register file address is equal to the first four bits of the instruction register
            RF_W_en = 1;                     // enable RF write
            RF_Ra_addr = IR[11:8];              // register a is assigned the address from IR
            RF_Rb_addr = IR[7:4];               // register b is assigned the address from IR
            Alu_s0 = 3'd2;                        // option 2 chosen from ALU (subtraction)
            RF_s = 0;
         end         
      // halt
         Halt     : NextState = Halt;        // Halt
      // init
         Init     : begin                    // Init (initial) 
            PC_clr = 1;
            NextState = Fetch;
         end 
      // fetch
         Fetch    : begin                    // Fetch
            PC_clr = 0;
            PC_up = 1;
            IR_ld = 1;
            D_wr = 0;
            RF_s = 0;
            NextState = Decode;
         end 
      // decode
         Decode:  case(_inst)                // Decode the first four bits of the instruction register addrress 
            _noop    : NextState = Noop;        // 0 noop
            _store   : NextState = Store;       // 1 store
            _load    : NextState = Load_A;      // 2 load
            _add     : NextState = Add;         // 3 ADD
            _sub     : NextState = Sub;         // 4 SUB
            _halt    : NextState = Halt;        // 5 HALT
            default  : NextState = Init;        // default instruction is noop
         endcase
      // default
         default: NextState = Init;          // default case is init i.e. NextState = Fetch
      endcase
   end

// proceedural logic
   always_ff @( posedge Clk ) begin : ff_logic

   // RESET LOGIC
         if (!ResetN) begin // if reset is asserted
            CurrentState <= Init;
         end else begin                  // else, no reset
            CurrentState <= NextState;    // go to the state we described above
         end
  end 
endmodule

// test bench
module StateMachine_tb;
// wires / logic

   logic Clk, ResetN;
   logic [15:0] IR;
   logic D_Wr, RF_s, RF_W_en, PC_clr, IR_ld, PC_up;
   logic [7:0] D_addr;
   logic [3:0]RF_W_addr, RF_Ra_addr, RF_Rb_addr;
   logic [2:0] Alu_s0;
   State CurrentState, NextState;

// instantiation
   StateMachine DUT ( Clk,ResetN,
     IR,
    D_Wr, RF_s, RF_W_en, PC_clr, IR_ld, PC_up,
     D_addr,
    RF_W_addr, RF_Ra_addr, RF_Rb_addr,
    Alu_s0,
    CurrentState, NextState);

// clock
   always begin
      Clk = 0; #100;
      Clk = 1; #100;
   end
   
    
// testbench logic
   always begin
      inst _counter;  
      State _state;

      Clk = 0; // clk 0
      ResetN = 1'b0; // reset
      IR = 16'h0000; // instruction register
      @(negedge Clk) #1;
      @(posedge Clk) #1;
      
      ResetN = 1'b1; // reset off

   // test all instructions except for load
     
      for (int i = 0; i < 6; i ++) begin
         _counter = inst'(i); // instruction variable. this will track expected instruction by using i
         _state   = State'(i);   // state variable. This will track the expected State by using i
         // reset the FSM: 
         @(negedge Clk) #1;
         DUT.CurrentState = State'(Init); // cast the init 
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
   end

   initial begin
      $monitor("\n",$realtime," ResetN  = %b | PC_clr = %b | PC_up = %b | IR_ld = %d | IR= %h\n",
                              ResetN, PC_clr, PC_up, IR_ld, IR,
                              "\t RF_W_en = %b | RF_W_addr = %h | RF_Ra_addr = %h | RF_Rb_addr = %h\n",
                                 RF_W_en, RF_W_addr, RF_Ra_addr, RF_Rb_addr,
                              "\t D_wr = %b | D_addr = %h | RF_s = %b | Alu_s0 = %b\n",
                                 DUT.D_wr, D_addr, RF_s, Alu_s0, 
                              "\t  CurrentState = %s   |   NextState = %s\n", state_to_string(CurrentState), state_to_string(NextState)
                                    );
   end
endmodule