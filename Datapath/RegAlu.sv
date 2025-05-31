// TCES330 Spring 2025 University of Washington Tacoma Dr. Jie Sheng
// Rodney Deacon & Mahri Yalkapova
// 05-30-2025
// Week 8, Project Folder RegisterAlu
// // this module will implement Register and ALU operations

module RegAlu (
    input [3:0] RF_W_addr, RF_Ra_addr, RF_Rb_addr,
    input RF_W_en,
    input [2:0] ALU_s0,
    output [15:0] Q,
);
      /*
   
      */
endmodule

module RegAlu_tb();
    // Testbench for RegAlu
    initial begin
        // Initialize signals and test cases
        $display("Starting RegAlu Testbench...");

        // Add test cases here
        // For example, you can instantiate the RegAlu module and apply inputs

        // Wait for some time to observe outputs
        #100;

        $display("RegAlu Testbench completed.");
        $finish;
    end

    monitor("At time %t: RegAlu outputs...", $time);

    endmodule