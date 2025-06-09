// TCES330 Spring 2025 University of Washington Tacoma Dr. Jie Sheng
// Rodney Deacon & Mahri Yalkapova
// 06-07-2025
// Week 9, Project Folder 
// This module is the finite state machine that generates
// a clock pulse every time when the button Key is pressed

module ButtonSync(
    input Bi, Clk,      // input Bi-key pressed, Clk
    output logic Bo     // output 
);

    // Define three states as local params
    localparam A = 2'd0, 
               B = 2'd1, 
               C = 2'd2;
    
    // wires
    logic [1:0] State, NextState;
    logic NextBo;

    // comb logic to describe state transitions
    always_comb begin
        NextBo = 0;  // default
        case (State)
            A: begin
                if (Bi) begin
                    NextState = B;
                    NextBo = 0;
                end else begin
                    NextState = A;
                end
            end

            B: begin
                NextBo = 1;
                if (Bi) begin
                    NextState = C;
                end else begin
                    NextState = A;
                end
            end

            C: begin
                if (Bi) begin
                    NextState = C;
                end else begin
                    NextState = A;
                end
            end

            default: NextState = A;
        endcase
    end

    always_ff @(posedge Clk) begin
            State <= NextState;
            Bo <= NextBo;
    end

endmodule


module ButtonSync_tb;

    // logic
	logic Bi, Clk, ResetN;
	logic Bo;

    //initalize
    ButtonSync DUT(
            Bi, Clk, 
            Bo);

    // clock
    always begin
        Clk = 1'b0; #10;
        Clk = 1'b1; #10;
    end

    // logic
    initial begin
        // initialize inputs
        ResetN = 1'b0;
        Bi = 1'b0;
        @(negedge Clk); #1;

        @(posedge Clk);
        @(negedge Clk); #1;
        // after the negative edge, input bi goes high
        ResetN = 1'b1;
        Bi = 1'b1;
        // stays 1 for 3 cycles
        repeat(3) @(posedge Clk);
        
        @(negedge Clk); #1;
        Bi = 1'b0;

        repeat(2) @(posedge Clk);

        $stop;
    end

    // monitor
    initial begin
        $display($realtime, " Bi = %b, Bo = %b", Bi, Bo);
    end
    
endmodule