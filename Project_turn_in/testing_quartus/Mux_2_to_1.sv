// TCES330 Spring 2025 University of Washington Tacoma Instructor Dr. Jie Sheng
// Rodney Deacon and Mahri Yalkapova
// this module is two to 1 multiplexer. If s = 0, output m is equal to input x
// if s = 1. output m is equal to input y.

module Mux_2_to_1(m, x,s,y);
    input s;
    input [15:0] x,y;
    output [15:0] m;

    // assignment using ternary operator
    assign m = s ? y : x;

endmodule

// test bench

module Mux_2_to_1_tb;
    logic x,s,y; // input
    logic m; // output

    Mux_2_to1 DUT(m,x,s,y); // Mux_2_to1(m, x,s,y)

    initial begin
        for (int i = 0; i < 8; i++) begin
            {s,y,x} = i; #5;
        end
        $stop;  
    end  
    
    initial begin
        $display("time \t s \t y \t x \t m");
        $monitor( $realtime, "\t%b\t%b\t%b\t%b", s,y,x,m );
    end

endmodule