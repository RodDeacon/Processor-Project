// TCES330 Spring 2025 University of Washington Tacoma Dr. Jie Sheng
// Rodney Deacon
// 04-24-2025
// Week 3, HW3 Folder Q1
// this module decode 4-bit binary number (representatation of a hex digit) into a seven segment

module Decoder( Hex, V); 
    input [3:0] V;              // input binary number to be converted 
    output logic [0:6]Hex;      // the seven segments which will hold the decimal representation of the number

    always_comb begin           // Always block used to define output logic 
        case (V)                // case statement to assign Hex based on input V
            4'b0000 : Hex = 7'b0000001; // 0
            4'b0001 : Hex = 7'b1001111; // 1
            4'b0010 : Hex = 7'b0010010; // 2
            4'b0011 : Hex = 7'b0000110; // 3
            4'b0100 : Hex = 7'b1001100; // 4
            4'b0101 : Hex = 7'b0100100; // 5
            4'b0110 : Hex = 7'b0100000; // 6
            4'b0111 : Hex = 7'b0001111; // 7
            4'b1000 : Hex = 7'b0000000; // 8
            4'b1001 : Hex = 7'b0000100; // 9
            4'b1010 : Hex = 7'b0001000; // 10 A
            4'b1011 : Hex = 7'b1100000; // 11 b
            4'b1100 : Hex = 7'b0110001; // 12 C
            4'b1101 : Hex = 7'b1000010; // 13 d
            4'b1110 : Hex = 7'b0110000; // 14 E 
            4'b1111 : Hex = 7'b0111000; // 15 F
        endcase
    end
endmodule

// testbench for the decoder
module Decoder_tb;
    // input / output
    logic [3:0]V;
    logic [0:6]Hex;

    Decoder DUT(.V(V), .Hex(Hex));                  // initialize Decoder for testbench

    initial begin
        for (int i = 0; i < 16; i++) begin          // for loop for all 16 cases for input
            V = i; #1;
        end
    end

    initial begin                                   // display for user
        $display("time v3 \t\tv2 \tv1\tv0\t hex[0-6]");
        $monitor($realtime, "\t%b\t%b\t%b\t%b\t %b%b%b%b%b%b%b", V[3],V[2],V[1],V[0],Hex[0],Hex[1],Hex[2],Hex[3],Hex[4],Hex[5],Hex[6]);
    end
endmodule