// TCES330 Spring 2025 University of Washington Tacoma Dr. Jie Sheng
// Rodney Deacon & Mahri Yalkapova
// 06-01-2025
// Week 9, Project Folder Processor

module Processor(
    input Clk, Reset,
    output [15:0] IR_Out,
    output logic [6:0] PC_Out,
    output [3:0] State, NextState,
    output logic [15:0] ALU_A, ALU_B, ALU_Out
);
// MEOW

//localparams
logic D_Wr, RF_s, RF_W_en;
logic [7:0] D_Addr;
logic [3:0] RF_W_Addr, RF_Ra_Addr, RF_Rb_Addr;
logic [2:0] Alu_s0;
//logic [6:0] pc_wire;

// assign PC_Out = {1'b0, pc_wire};

//assign pc_wire  = PC_Out;
//instantiations

/*ControlUnit DUT(
                  Clk,ResetN,
                  D_Wr, RF_s, RF_W_en,
                  D_Addr,
                  RF_W_Addr, RF_Ra_Addr, RF_Rb_Addr,
                  ALU_s0, 
                  OutState, NextState,
                  IR_Out,
                  PC_Out
               );*/
ControlUnit unit_CU(Clk, Reset, D_Wr, RF_s, RF_W_en, D_Addr,
                    RF_W_Addr, RF_Ra_Addr, RF_Rb_Addr, Alu_s0,
                    State, NextState, IR_Out, PC_Out);

/*DataPath DUT (Clk, D_wr, RF_W_en, RF_s, D_Addr, 
      RF_W_Addr, RF_Ra_Addr, RF_Rb_Addr, Alu_s0);*/
DataPath unit_DP(Clk, D_Wr, RF_W_en, RF_s, D_Addr,
                RF_W_Addr, RF_Ra_Addr, RF_Rb_Addr, Alu_s0, ALU_A, ALU_B, ALU_Out);
					 
//assignments
//assign ALU_A = unit_DP.A;
//assign ALU_B = unit_DP.B;
//assign ALU_Out = unit_DP.ALU_out;
//assign PC_Out = {1'b0, pc_wire};

endmodule

module Processor_tb;

endmodule